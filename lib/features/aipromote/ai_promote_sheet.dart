import 'dart:io';

import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/features/aipromote/ad_preview.dart';
import 'package:business_bosses_v2/features/aipromote/business_form.dart';
import 'package:business_bosses_v2/features/aipromote/controller/ai_promote_controller.dart';
import 'package:business_bosses_v2/features/aipromote/models/business_info_model.dart';
import 'package:business_bosses_v2/features/aipromote/success_screen.dart';
import 'package:business_bosses_v2/features/forum/controller/create_bossup_controller.dart';
import 'package:business_bosses_v2/features/posts/controllers/create_post_controller.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum PromoteStep { info, preview, success }

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
  );
  String _adContent = '';
  bool _loading = false;

  // Safe controller initialization
  late final AiPromoteController aiPromoteController;
  ProfileController? profileController;
  late final CreatePostController createPostController;
  late final CreateBossUpController createBossUpController;
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
    createBossUpController = Get.put(CreateBossUpController());

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

    const int maxUses = 4;
    if (count >= maxUses) {
      return false;
    }

    await prefs.setInt('promo_count', count + 1);
    return true;
  }

  void _handleInfoSubmit(BusinessInfo info) async {
    final bool isSubscribed = profileController?.myProfile.isSubscribed ?? true;

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
      // Simulate AI generation with error handling
      await aiPromoteController.generateAd();

      setState(() {
        // Safe access to adCopy with null check
        _adContent = (aiPromoteController.adCopy.value.isNotEmpty)
            ? aiPromoteController.adCopy.value
            : 'AI generated ad content will appear here.';
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
    if (platforms.contains('homepage') && profileController == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile controller not available')),
      );
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      for (String platform in platforms) {
        String? image;
        if (selectedImage != null) {
          dynamic response = await ApiService.uploadFile(selectedImage);
          if (response['success']) {
            image = response['fileUrl'];
          } else {
            showSnackbar(
              message: 'Error while creating supplier!',
              error: true,
            );
            setState(() {
              _loading = false;
            });
            return;
          }
        }

        if (platform == 'homepage') {
          // Safe call with null check
          await createPostController.createPost(
            <String, dynamic>{
              'title': _adContent.trim(),
              'timestamp': DateTime.now().millisecondsSinceEpoch,
              'images': image != null ? <String>[image] : <dynamic>[],
            },
            profileController!, // Using ! since we checked above
          );
        } else {
          await createBossUpController.createForum(<String, dynamic>{
            'title': 'AI Generated Ad for ${_businessInfo.name}',
            'description': _adContent.trim(),
            'timestamp': DateTime.now().millisecondsSinceEpoch,
            'industryId': 'industryId',
            'images': image != null ? <String>[image] : <dynamic>[],
          });
        }
      }

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

  Widget _buildProgressIndicator() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1), // Translucent white
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildProgressStep(PromoteStep.info),
          _buildProgressLine(),
          _buildProgressStep(PromoteStep.preview),
          _buildProgressLine(),
          _buildProgressStep(PromoteStep.success),
        ],
      ),
    );
  }

  Widget _buildProgressStep(PromoteStep step) {
    bool isActive = _currentStep.index >= step.index;
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive
            ? const Color.fromARGB(255, 0, 0, 0)
            : const Color(0xFFE5E7EB),
      ),
    );
  }

  Widget _buildProgressLine() {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        color: const Color(0xFFE5E7EB),
      ),
    );
  }

  Widget _buildContent() {
    if (!_prefsLoaded && _currentStep == PromoteStep.preview) {
      return const Center(child: CircularProgressIndicator());
    }

    int remaining = 0;
    if (_currentStep == PromoteStep.preview) {
      final bool isSubscribed =
          profileController?.myProfile.isSubscribed ?? true;
      final int maxUses =
          isSubscribed ? 9999 : 4; // Or hide UI completely for subscribed

      remaining = (_promoCount >= maxUses) ? 0 : (maxUses - _promoCount);
    }

    switch (_currentStep) {
      case PromoteStep.info:
        return BusinessInfoForm(
          infoClicked: infoClicked,
          remainingPromos: remaining,
          limitReached: profileController!.myProfile.isSubscribed
              ? false
              : _promoCount >= 4,
          initialInfo: _businessInfo,
          onSubmit: _handleInfoSubmit,
          isLoading: _loading,
        );
      case PromoteStep.preview:
        return AdPreview(
          content: _adContent,
          onEdit: _handleAdEdit,
          onPost: _handlePostAd,
          isLoading: _loading,
          remainingPromos: remaining,
        );
      case PromoteStep.success:
        return SuccessScreen(onCreateAnother: _handleCreateAnother);
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
                                  ? 'Preview Promotion'
                                  : hasShop
                                      ? 'Business Info Confirmation'
                                      : 'Profile Info Confirmation',
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
