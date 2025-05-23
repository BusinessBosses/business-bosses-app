import 'package:business_bosses_v2/features/aipromote/components/adpreview.dart';
import 'package:business_bosses_v2/features/aipromote/components/businessform.dart';
import 'package:business_bosses_v2/features/aipromote/components/successscreen.dart';
import 'package:flutter/material.dart';

enum PromoteStep { info, preview, success }

class AIPromoteSheet extends StatefulWidget {
  const AIPromoteSheet({super.key});

  @override
  _AIPromoteSheetState createState() => _AIPromoteSheetState();
}

class _AIPromoteSheetState extends State<AIPromoteSheet>
    with TickerProviderStateMixin {
  PromoteStep _currentStep = PromoteStep.info;
  BusinessInfo _businessInfo = BusinessInfo(
    name: 'Your Business Name',
    industry: 'Your Industry',
    bio: 'Your business tagline or bio',
    website: 'https://yourwebsite.com',
  );
  String _adContent = '';
  bool _loading = false;

  void _handleInfoSubmit(BusinessInfo info) async {
    setState(() {
      _businessInfo = info;
      _loading = true;
    });

    // Simulate AI generation
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _adContent =
          'Introducing ${info.name} - The premier ${info.industry} solution for your needs! ${info.bio} Visit us at ${info.website} today and transform your experience!';
      _loading = false;
      _currentStep = PromoteStep.preview;
    });
  }

  void _handleAdEdit(String content) {
    setState(() {
      _adContent = content;
    });
  }

  void _handlePostAd() async {
    setState(() {
      _loading = true;
    });

    await Future.delayed(Duration(milliseconds: 1500));

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
