import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/aipromote/controller/ai_promote_controller.dart';
import 'package:business_bosses_v2/features/aipromote/models/business_info_model.dart';
import 'package:business_bosses_v2/features/premium/premiumscreen.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/features/profile/presentation/my_profile_screen.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BusinessInfoForm extends StatefulWidget {
  final BusinessInfo initialInfo;
  final Function(BusinessInfo) onSubmit;
  final bool isLoading;
  final bool limitReached;

  const BusinessInfoForm({
    super.key,
    required this.initialInfo,
    required this.onSubmit,
    required this.isLoading,
    required this.limitReached,
  });

  @override
  State<BusinessInfoForm> createState() => _BusinessInfoFormState();
}

class _BusinessInfoFormState extends State<BusinessInfoForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _industryController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();

  // Add FocusNodes
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _industryFocus = FocusNode();
  final FocusNode _bioFocus = FocusNode();
  final FocusNode _websiteFocus = FocusNode();

  final ProfileController profileController = Get.find();
  final ShopController shopController = Get.find();
  final AiPromoteController aiPromoteController = Get.find();

  bool hasShop = false;
  List<String> missingFields = <String>[];
  bool infoClicked = false;
  UserModel profile = UserModel();

  @override
  void initState() {
    profile = profileController.myProfile;
    super.initState();
    _initializeControllers();
    _setupListeners();
  }

  void _setupListeners() {
    _nameController.addListener(() => _updateMissingFields());
    _industryController.addListener(() => _updateMissingFields());
    _bioController.addListener(() => _updateMissingFields());
    _websiteController.addListener(() => _updateMissingFields());
  }

  void _initializeControllers() async {
    if (shopController.shop == null && profileController.myProfile.hasShop) {
      hasShop = true;
      await shopController.initShop(); // make sure this is async
      _setShopData();
    } else if (shopController.shop != null) {
      hasShop = true;
      _setShopData();
    } else {
      hasShop = false;
      _setProfileData();
      // Auto-focus the first empty field when using profile data
      _autoFocusFirstEmptyField();
    }
  }

  void _autoFocusFirstEmptyField() {
    // Use WidgetsBinding to ensure this runs after the build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_nameController.text.trim().isEmpty) {
        _nameFocus.requestFocus();
      } else if (_industryController.text.trim().isEmpty) {
        _industryFocus.requestFocus();
      } else if (_bioController.text.trim().isEmpty) {
        _bioFocus.requestFocus();
      } else if (_websiteController.text.trim().isEmpty) {
        _websiteFocus.requestFocus();
      }
    });
  }

  void _setShopData() {
    if (shopController.shop != null) {
      _nameController.text = shopController.shop!.name;
      _industryController.text = shopController.shop!.category;
      _bioController.text = shopController.shop!.description;
      _websiteController.text = shopController.shop!.url ?? '';
    }
  }

  void _setProfileData() {
    missingFields.clear();

    // Set name from profile
    _nameController.text = profile.name ?? '';

    // Set industry from profile (you might need to adjust this based on your profile model)
    _industryController.text = profile.industry ?? '';

    // Set bio from profile
    _bioController.text = profile.bio ?? '';

    // Set website from profile
    _websiteController.text = profile.website ?? '';
  }

  void _updateMissingFields() {
    setState(() {
      missingFields.clear();

      if (_nameController.text.trim().isEmpty) {
        missingFields.add('Business Name');
      }

      if (_industryController.text.trim().isEmpty) {
        missingFields.add('Industry');
      }

      if (_bioController.text.trim().isEmpty) {
        missingFields.add('Description/Tagline');
      }

      if (_websiteController.text.trim().isEmpty) {
        missingFields.add('Website/Contact Link');
      }
    });
  }

  @override
  void dispose() {
    _nameController.removeListener(() => _updateMissingFields());
    _industryController.removeListener(() => _updateMissingFields());
    _bioController.removeListener(() => _updateMissingFields());
    _websiteController.removeListener(() => _updateMissingFields());

    _nameController.dispose();
    _industryController.dispose();
    _bioController.dispose();
    _websiteController.dispose();

    // Dispose FocusNodes
    _nameFocus.dispose();
    _industryFocus.dispose();
    _bioFocus.dispose();
    _websiteFocus.dispose();

    super.dispose();
  }

  void _handleSubmit() {
    final BusinessInfo info = BusinessInfo(
      name: _nameController.text,
      industry: _industryController.text,
      bio: _bioController.text,
      website: _websiteController.text,
    );
    aiPromoteController.setBusinessDetails(
      name: _nameController.text.trim(),
      desc: _bioController.text.trim(),
      loc: _websiteController.text.trim(), // pass website as "location"
      ind: _industryController.text.trim(),
    );
    widget.onSubmit(info);
  }

  Widget _buildInputGroup(
    String label,
    TextEditingController controller, {
    String? placeholder,
    int maxLines = 1,
    TextInputType? keyboardType,
    bool isMissing = false,
    FocusNode? focusNode, // Add focusNode parameter
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF4B5563),
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          TextFormField(
            controller: controller,
            focusNode: focusNode, // Add focusNode to TextFormField
            maxLines: maxLines,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: placeholder,
              filled: true,
              fillColor: isMissing ? Color(0xFFFEF3C7) : Color(0xFFF9FAFB),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: isMissing
                      ? Color.fromARGB(255, 217, 38, 6)
                      : Color(0xFFD1D5DB),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: isMissing
                      ? Color.fromARGB(255, 217, 38, 6)
                      : Color(0xFFD1D5DB),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xFF6366F1)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    // if (hasShop) return SizedBox.shrink();

    return Container(
      margin: EdgeInsets.only(bottom: 24),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFF0F9FF),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFF0EA5E9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.info_outline,
                color: Color(0xFF0EA5E9),
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                hasShop ? 'Using Shop Data' : 'Using Profile Data',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0EA5E9),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            hasShop
                ? 'We\'ve pre-filled your information from your shop. Please review and edit any fields as needed for better AI-generated promotions.'
                : 'We\'ve pre-filled your information from your profile. Please review and edit any fields as needed for better AI-generated promotions.',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF0369A1),
            ),
          ),
          if (missingFields.isNotEmpty) ...<Widget>[
            SizedBox(height: 8),
            Text(
              'Missing fields: ${missingFields.join(', ')}',
              style: TextStyle(
                fontSize: 12,
                color: Color.fromARGB(255, 217, 38, 6),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                hasShop
                    ? 'Business Info Confirmation'
                    : 'Profile Info Confirmation',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
                ),
              ),
              SizedBox(width: 5),
              Icon(
                Icons.info_outline,
                color: Color(0xFF0EA5E9),
                size: 20,
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        Text(
          hasShop
              ? 'Confirm your business information below to create your AI-generated promotion'
              : 'Confirm your profile information below to create your AI-generated promotion',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF6B7280),
          ),
        ),
        if (!hasShop)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: GestureDetector(
              onTap: () {
                Get.to(() => const MyProfileScreen(
                      currentIndex: 1,
                    ));
              },
              child: Text.rich(
                TextSpan(
                  text: 'Tip: ',
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                  children: <InlineSpan>[
                    WidgetSpan(
                      child: Text(
                        'Setup BizCentre',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          decorationColor: primaryColorLT, // underline color
                          color: primaryColorLT,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    TextSpan(
                      text: ' for quick promotion!',
                    ),
                  ],
                ),
              ),
            ),
          ),
        SizedBox(height: 24),
        infoClicked ? _buildInfoCard() : SizedBox.shrink(),
        _buildInputGroup(
          '${profileController.myProfile.isSubscribed ? 'Business ' : ''}Name',
          _nameController,
          placeholder:
              'Enter your ${profileController.myProfile.isSubscribed ? 'business ' : ''}name',
          isMissing: missingFields.contains('Business Name'),
          focusNode: _nameFocus, // Pass focusNode
        ),
        _buildInputGroup(
          'Industry',
          _industryController,
          placeholder: 'Enter your industry',
          isMissing: missingFields.contains('Industry'),
          focusNode: _industryFocus, // Pass focusNode
        ),
        _buildInputGroup(
          'Tagline/Description',
          _bioController,
          placeholder: 'Enter a short description or tagline',
          maxLines: 3,
          isMissing: missingFields.contains('Description/Tagline'),
          focusNode: _bioFocus, // Pass focusNode
        ),
        _buildInputGroup(
          'Website or Contact Link',
          _websiteController,
          placeholder: 'Enter your website URL / contact link',
          keyboardType: TextInputType.url,
          isMissing: missingFields.contains('Website/Contact Link'),
          focusNode: _websiteFocus, // Pass focusNode
        ),
        SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: widget.isLoading ? null : _handleSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  widget.limitReached == true ? Colors.grey : primaryColorLT,
              disabledBackgroundColor: backgroundColor,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: widget.isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: primaryColorLT,
                      strokeWidth: 2,
                    ))
                : Text(
                    widget.limitReached == true
                        ? 'Limit reached'
                        : 'Generate free promotion',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
        SizedBox(height: 10),
        if (!profileController.myProfile.isSubscribed)
          Center(
            child: GestureDetector(
              onTap: () {
                Get.bottomSheet(
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    height: Get.height * 0.9,
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          PremiumScreen(),
                        ],
                      ),
                    ),
                  ),
                  backgroundColor: Colors.white,
                );
              },
              child: RichText(
                text: TextSpan(
                  children: <InlineSpan>[
                    TextSpan(
                      text: 'Upgrade to Pro,',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: primaryColorLT,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    TextSpan(
                      text: ' Get Unlimited Promotion',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        SizedBox(height: 300),
      ],
    );
  }
}
