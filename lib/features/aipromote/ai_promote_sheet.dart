import 'dart:io';

import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/aipromote/ad_preview.dart';
import 'package:business_bosses_v2/features/aipromote/business_form.dart';
import 'package:business_bosses_v2/features/aipromote/controller/ai_promote_controller.dart';
import 'package:business_bosses_v2/features/aipromote/models/business_info_model.dart';
import 'package:business_bosses_v2/features/aipromote/success_screen.dart';
import 'package:business_bosses_v2/features/posts/controllers/create_post_controller.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum PromoteStep { info, preview, success }

/// Monthly "Post with AI" promotions allowed for non-Pro (free) users.
const int kFreeMonthlyPromotions = 4;

class AIPromoteSheet extends StatefulWidget {
  const AIPromoteSheet({super.key});

  @override
  State<AIPromoteSheet> createState() => _AIPromoteSheetState();
}

class _AIPromoteSheetState extends State<AIPromoteSheet>
    with TickerProviderStateMixin {
  PromoteStep _currentStep = PromoteStep.info;
  final ShopController shopController = Get.find();
  BusinessInfo _businessInfo = BusinessInfo(
    name: 'Your Business Name',
    industry: 'Your Industry',
    bio: 'Your business tagline or description',
    website: 'https://yourwebsite.com',
    location: 'Your Location',
    postType: 'Promote My Business',
  );
  String _adContent = '';
  String _adTitle = '';
  bool _loading = false;

  // Safe controller initialization
  late final AiPromoteController aiPromoteController;
  ProfileController? profileController;
  late final CreatePostController createPostController;
  int _promoCount = 0;
  bool _prefsLoaded = false;
  bool hasShop = false;
  bool infoClicked = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers safely
    aiPromoteController = Get.put(AiPromoteController());

    _initializeControllers();

    // Safe way to get ProfileController - it might not exist
    try {
      profileController = Get.find<ProfileController>();
    } catch (e) {
      debugPrint('ProfileController not found: $e');
      // You might want to initialize it here or handle the absence
      // profileController = Get.put(ProfileController());
    }

    createPostController = Get.put(CreatePostController());

    _loadPromoPrefs();
  }

  Future<void> _loadPromoPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _promoCount = prefs.getInt('promo_count') ?? 0;
      _prefsLoaded = true;
    });
  }

  void _initializeControllers() async {
    if (shopController.shop == null && profileController!.myProfile.hasShop) {
      hasShop = true;
    } else if (shopController.shop != null) {
      hasShop = true;
    } else {
      hasShop = false;
    }
  }

  Future<bool> _canUsePromotion({required bool isSubscribed}) async {
    if (isSubscribed) {
      // No limit for subscribed users
      return true;
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final DateTime now = DateTime.now();
    final int count = prefs.getInt('promo_count') ?? 0;
    final String? lastResetStr = prefs.getString('promo_last_reset');

    DateTime? lastReset;
    if (lastResetStr != null) {
      lastReset = DateTime.tryParse(lastResetStr);
    }

    // Reset monthly
    if (lastReset == null ||
        lastReset.month != now.month ||
        lastReset.year != now.year) {
      await prefs.setInt('promo_count', 1);
      await prefs.setString('promo_last_reset', now.toIso8601String());
      return true;
    }

    const int maxUses = kFreeMonthlyPromotions;
    if (count >= maxUses) {
      return false;
    }

    await prefs.setInt('promo_count', count + 1);
    return true;
  }

  void _handleInfoSubmit(BusinessInfo info) async {
    // Default to NOT subscribed when the profile is unavailable, so a missing
    // profile can never silently grant unlimited free promotions.
    final bool isSubscribed = profileController?.myProfile.isSubscribed ?? false;

    if (!isSubscribed) {
      final bool allowed = await _canUsePromotion(isSubscribed: isSubscribed);

      if (!allowed) {
        if (mounted) {
          showSnackbar(
            message: 'Free promotion limit reached. Upgrade to continue.',
            error: true,
          );
        }
        return;
      }
    } else {
      // Subscribed user
      final bool allowed = await _canUsePromotion(isSubscribed: isSubscribed);

      if (!allowed) {
        if (mounted) {
          showSnackbar(
            message:
                'You’ve reached your monthly promotion limit (12). Please wait until next month.',
            error: true,
          );
        }
        return;
      }
    }

    setState(() {
      _businessInfo = info;
      _loading = true;
    });

    try {
      // Populate the controller this sheet generates from, directly from the
      // submitted form data — so the prompt is always built and generateAd is
      // never run against an empty/stale instance.
      aiPromoteController.setBusinessDetails(
        name: info.name,
        desc: info.bio,
        loc: info.location,
        ind: info.industry,
        type: info.postType,
        priceVal: info.price,
        additionalDetailsVal: info.additionalDetails,
      );

      await aiPromoteController.generateAd();

      final String generated = aiPromoteController.adCopy.value.trim();

      // Generation failed (e.g. missing API key / network) → surface the real
      // reason instead of silently advancing to a placeholder preview.
      if (generated.isEmpty) {
        setState(() => _loading = false);
        if (mounted && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                aiPromoteController.errorMessage.value ??
                    'Could not generate content. Please try again.',
              ),
            ),
          );
        }
        return;
      }

      setState(() {
        _adContent = generated;
        _adTitle = aiPromoteController.adTitle.value.trim();
        _loading = false;
        _currentStep = PromoteStep.preview;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });

      // Show error to user
      if (mounted && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating ad: $e')),
        );
      }
    }
  }

  void _handleAdEdit(String content) {
    setState(() {
      _adContent = content;
    });
  }

  void _handlePostAd(List<String> platforms, File? selectedImage) async {
    // Check if profileController is available when needed
    if (profileController == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile controller not available')),
      );
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      String? image;
      if (selectedImage != null) {
        dynamic response = await ApiService.uploadFile(selectedImage);
        if (response['success']) {
          image = response['fileUrl'];
        } else {
          showSnackbar(
            message: 'Error while uploading image!',
            error: true,
          );
          setState(() {
            _loading = false;
          });
          return;
        }
      }

      // Automatically update user matchType based on post type
      String? newMatchType;
      if (_businessInfo.postType == 'Promote My Business' ||
          _businessInfo.postType == 'Sell a Product or Service') {
        newMatchType = 'seller';
      } else if (_businessInfo.postType == 'Need a Product or Service') {
        // Buyers looking for products/services are matched against sellers.
        newMatchType = 'buyer';
      } else if (_businessInfo.postType == 'Find a Partner') {
        newMatchType = 'partner';
      }

      if (newMatchType != null &&
          profileController!.myProfile.matchType != newMatchType) {
        await ApiService.put(
          path: 'users/${profileController!.myProfile.uid}',
          body: <String, String>{'matchType': newMatchType},
        );
        profileController!.myProfile = UserModel.fromMap(<dynamic, dynamic>{
          ...profileController!.myProfile.toMap(),
          'matchType': newMatchType
        });
        // Keep the match-type the matches screen renders from in sync with the
        // stored matchType, otherwise the view shows one type while the fetched
        // data is for another.
        profileController!.currentMatchType.value = newMatchType;
      }

      // Post once to the Boss Up Feed (Old Home). We intentionally do NOT also
      // create a Find-My-Match forum here — the Boss Up/home feed merges posts
      // and forums, so a second write would surface the same content twice.
      // The post stores a single text field, so put the refined headline first
      // (above the content) when one is present.
      final String postText = _adTitle.trim().isNotEmpty
          ? '${_adTitle.trim()}\n\n${_adContent.trim()}'
          : _adContent.trim();
      createPostController.shouldPromote.value = false;
      await createPostController.createPost(
        <String, dynamic>{
          'title': postText,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'images': image != null ? <String>[image] : <dynamic>[],
        },
        profileController!,
        skipNavigation: true,
      );

      // Success - only update state if widget is still mounted
      if (mounted) {
        setState(() {
          _currentStep = PromoteStep.success;
          _loading = false;
        });
      }
    } catch (err) {
      debugPrint('Error posting ad: $err');

      if (mounted && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error posting ad: $err')),
        );
      }

      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  void _handleCreateAnother() {
    if (mounted) {
      setState(() {
        _currentStep = PromoteStep.info;
      });
    }
  }

  // Widget _buildProgressIndicator() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: Colors.white.withValues(alpha: 0.1), // Translucent white
  //       borderRadius: BorderRadius.circular(16),
  //     ),
  //     padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: <Widget>[
  //         _buildProgressStep(PromoteStep.info),
  //         _buildProgressLine(),
  //         _buildProgressStep(PromoteStep.preview),
  //         _buildProgressLine(),
  //         _buildProgressStep(PromoteStep.success),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildProgressStep(PromoteStep step) {
  //   bool isActive = _currentStep.index >= step.index;
  //   return Container(
  //     width: 12,
  //     height: 12,
  //     decoration: BoxDecoration(
  //       shape: BoxShape.circle,
  //       color: isActive
  //           ? const Color.fromARGB(255, 0, 0, 0)
  //           : const Color(0xFFE5E7EB),
  //     ),
  //   );
  // }

  // Widget _buildProgressLine() {
  //   return Expanded(
  //     child: Container(
  //       height: 2,
  //       margin: const EdgeInsets.symmetric(horizontal: 8),
  //       color: const Color(0xFFE5E7EB),
  //     ),
  //   );
  // }

  Widget _buildContent() {
    if (!_prefsLoaded && _currentStep == PromoteStep.preview) {
      return const Center(child: CircularProgressIndicator());
    }

    int remaining = 0;
    if (_currentStep == PromoteStep.preview) {
      final bool isSubscribed =
          profileController?.myProfile.isSubscribed ?? false;
      final int maxUses = isSubscribed
          ? 9999
          : kFreeMonthlyPromotions; // Or hide UI completely for subscribed

      remaining = (_promoCount >= maxUses) ? 0 : (maxUses - _promoCount);
    }

    switch (_currentStep) {
      case PromoteStep.info:
        return BusinessInfoForm(
          infoClicked: infoClicked,
          remainingPromos: remaining,
          limitReached: profileController!.myProfile.isSubscribed
              ? false
              : _promoCount >= kFreeMonthlyPromotions,
          initialInfo: _businessInfo,
          onSubmit: _handleInfoSubmit,
          isLoading: _loading,
        );
      case PromoteStep.preview:
        return AdPreview(
          title: _adTitle,
          content: _adContent,
          onEdit: _handleAdEdit,
          onPost: _handlePostAd,
          isLoading: _loading,
          remainingPromos: remaining,
        );
      case PromoteStep.success:
        return SuccessScreen(
            onCreateAnother: _handleCreateAnother,
            postType: _businessInfo.postType);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      maxChildSize: 0.9,
      minChildSize: 0.9,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: <Widget>[
              // Header
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xFFF3F4F6)),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            infoClicked = !infoClicked;
                          });
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              _currentStep == PromoteStep.preview
                                  ? 'Preview Post'
                                  : 'Post with AI. Get Matched',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1F2937),
                              ),
                            ),
                            SizedBox(width: 5),
                            _currentStep != PromoteStep.preview
                                ? Icon(
                                    Icons.info_outline,
                                    color: Color(0xFF0EA5E9),
                                    size: 20,
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (Navigator.canPop(context)) {
                            Navigator.of(context).pop();
                          }
                        },
                        child: CircleAvatar(
                          backgroundColor: const Color(0xFFF3F4F6),
                          radius: 18,
                          child: Icon(Icons.close, color: Color(0xFF6B7280)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              // Progress Indicator
              // _buildProgressIndicator(),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  child: _buildContent(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
