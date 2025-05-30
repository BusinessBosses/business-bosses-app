import 'package:business_bosses_v2/features/aipromote/ad_preview.dart';
import 'package:business_bosses_v2/features/aipromote/business_form.dart';
import 'package:business_bosses_v2/features/aipromote/controller/ai_promote_controller.dart';
import 'package:business_bosses_v2/features/aipromote/models/business_info_model.dart';
import 'package:business_bosses_v2/features/aipromote/success_screen.dart';
import 'package:business_bosses_v2/features/forum/controller/create_bossup_controller.dart';
import 'package:business_bosses_v2/features/posts/controllers/create_post_controller.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum PromoteStep { info, preview, success }

class AIPromoteSheet extends StatefulWidget {
  const AIPromoteSheet({super.key});

  @override
  State<AIPromoteSheet> createState() => _AIPromoteSheetState();
}

class _AIPromoteSheetState extends State<AIPromoteSheet>
    with TickerProviderStateMixin {
  PromoteStep _currentStep = PromoteStep.info;
  BusinessInfo _businessInfo = BusinessInfo(
    name: 'Your Business Name',
    industry: 'Your Industry',
    bio: 'Your business tagline or description',
    website: 'https://yourwebsite.com',
  );
  String _adContent = '';
  bool _loading = false;
  final AiPromoteController aiPromoteController =
      Get.put(AiPromoteController());
  final ProfileController profileController = Get.find();
  final CreatePostController createPostController = Get.put(CreatePostController());
  final CreateBossUpController createBossUpController = Get.put(CreateBossUpController());

  void _handleInfoSubmit(BusinessInfo info) async {
    setState(() {
      _businessInfo = info;
      _loading = true;
    });

    // Simulate AI generation
    await aiPromoteController.generateAd();

    setState(() {
      _adContent = aiPromoteController.adCopy.value.isNotEmpty
          ? aiPromoteController.adCopy.value
          : 'AI generated ad content will appear here.';
      _loading = false;
      _currentStep = PromoteStep.preview;
    });
  }

  void _handleAdEdit(String content) {
    setState(() {
      _adContent = content;
    });
  }

  void _handlePostAd(List<String> platforms) async {
    setState(() {
      _loading = true;
    });

    // await Future<dynamic>.delayed(Duration(milliseconds: 1500));
    try {
      // if you need a ProfileController, retrieve it here:

      for (String platform in platforms) {
        if (platform == 'homepage') {
          // your GetX controller method
          await createPostController.createPost(
            <String, dynamic>{
              'title': _adContent.trim(),
              'timestamp': DateTime.now().millisecondsSinceEpoch,
            },
            profileController,
          );
        } else {
          await createBossUpController.createForum(<String, dynamic>{
            'title': 'AI Generated Ad for ${_businessInfo.name}',
            'description': _adContent.trim(),
            'timestamp': DateTime.now().millisecondsSinceEpoch,
            'industryId': 'industryId',
          });
        }
      }
      // final List<void> results = await Future.wait(futures);

      // inspect any http.Response failures
      // final Iterable<dynamic> httpFails = results
      //     .whereType<http.Response>()
      //     .where((Object? r) => r.statusCode < 200 || r.statusCode >= 300);
      // if (httpFails.isNotEmpty) {
      //   final r = httpFails.first;
      //   throw Exception('Challenge post failed (${r.statusCode})');
      // }

      // success!
      _currentStep = PromoteStep.success;
    } catch (err) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(content: Text('Error posting ad: $err')),
      );
    } finally {
      setState(() => _loading = false);
    }

    setState(() {
      _loading = false;
      _currentStep = PromoteStep.success;
    });
  }

  void _handleCreateAnother() {
    setState(() {
      _currentStep = PromoteStep.info;
    });
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
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
        color: isActive ? Color(0xFF6366F1) : Color(0xFFE5E7EB),
      ),
    );
  }

  Widget _buildProgressLine() {
    return Expanded(
      child: Container(
        height: 2,
        margin: EdgeInsets.symmetric(horizontal: 8),
        color: Color(0xFFE5E7EB),
      ),
    );
  }

  Widget _buildContent() {
    switch (_currentStep) {
      case PromoteStep.info:
        return BusinessInfoForm(
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
        );
      case PromoteStep.success:
        return SuccessScreen(
          onCreateAnother: _handleCreateAnother,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      minChildSize: 0.4,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: BoxDecoration(
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
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xFFF3F4F6)),
                  ),
                ),
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Text(
                        'AI Promote',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Progress Indicator
              _buildProgressIndicator(),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: EdgeInsets.all(24),
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
