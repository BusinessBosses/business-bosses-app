import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/aipromote/controller/ai_promote_controller.dart';
import 'package:business_bosses_v2/features/aipromote/models/business_info_model.dart';
import 'package:business_bosses_v2/features/premium/premium_paywall_sheet.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/features/profile/presentation/my_profile_screen.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BusinessInfoForm extends StatefulWidget {
  final BusinessInfo initialInfo;
  final Function(BusinessInfo) onSubmit;
  final bool isLoading;
  final bool limitReached;
  final int? remainingPromos;
  final bool infoClicked;

  const BusinessInfoForm({
    super.key,
    required this.initialInfo,
    required this.onSubmit,
    required this.isLoading,
    required this.limitReached,
    this.remainingPromos,
    required this.infoClicked,
  });

  @override
  State<BusinessInfoForm> createState() => _BusinessInfoFormState();
}

class _BusinessInfoFormState extends State<BusinessInfoForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _industryController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _extraDetailsController = TextEditingController();
  String _selectedType = 'Promote My Business';

  // Add FocusNodes
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _industryFocus = FocusNode();
  final FocusNode _bioFocus = FocusNode();
  final FocusNode _websiteFocus = FocusNode();
  final FocusNode _locationFocus = FocusNode();

  final ProfileController profileController = Get.find();
  final ShopController shopController = Get.find();
  final AiPromoteController aiPromoteController = Get.find();

  bool hasShop = false;
  List<String> missingFields = <String>[];

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
    _locationController.addListener(() => _updateMissingFields());
    _priceController.addListener(() => _updateMissingFields());
    _extraDetailsController.addListener(() => _updateMissingFields());
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
      } else if (_locationController.text.trim().isEmpty) {
        _locationFocus.requestFocus();
      }
    });
  }

  void _setShopData() {
    if (shopController.shop != null) {
      _nameController.text = ''; // Clear for user to enter title
      _industryController.text = shopController.shop!.category;
      _bioController.text = ''; // Clear for user to enter description
      _websiteController.text = shopController.shop!.url ?? '';
      _locationController.text = shopController.shop!.location;
    }
  }

  void _setProfileData() {
    missingFields.clear();

    // Everything should be empty to fill if the user doesn't have a bizcenter shop
    _nameController.text = '';
    _industryController.text = '';
    _bioController.text = '';
    _websiteController.text = '';
    _locationController.text = '';
  }

  void _updateMissingFields() {
    setState(() {
      missingFields.clear();

      if (_nameController.text.trim().isEmpty) {
        missingFields.add('Title');
      }

      if (_industryController.text.trim().isEmpty) {
        missingFields.add('Industry');
      }

      if (_bioController.text.trim().isEmpty) {
        missingFields.add('Description/Tagline');
      }

      if (_locationController.text.trim().isEmpty) {
        missingFields.add('Location');
      }
    });
  }

  @override
  void dispose() {
    _nameController.removeListener(() => _updateMissingFields());
    _industryController.removeListener(() => _updateMissingFields());
    _bioController.removeListener(() => _updateMissingFields());
    _websiteController.removeListener(() => _updateMissingFields());
    _locationController.removeListener(() => _updateMissingFields());
    _priceController.removeListener(() => _updateMissingFields());
    _extraDetailsController.removeListener(() => _updateMissingFields());

    _nameController.dispose();
    _industryController.dispose();
    _bioController.dispose();
    _websiteController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _extraDetailsController.dispose();

    // Dispose FocusNodes
    _nameFocus.dispose();
    _industryFocus.dispose();
    _bioFocus.dispose();
    _websiteFocus.dispose();
    _locationFocus.dispose();

    super.dispose();
  }

  Future<void> _handleSubmit() async {
    _updateMissingFields();

    if (missingFields.isNotEmpty) {
      Get.snackbar(
        'Missing Information',
        'Please fill in all required fields: ${missingFields.join(', ')}',
        backgroundColor: Colors.amber.shade100,
        colorText: Colors.black,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(15),
      );
      return;
    }

    final BusinessInfo info = BusinessInfo(
      name: _nameController.text,
      industry: _industryController.text,
      bio: _bioController.text,
      website: _websiteController.text,
      location: _locationController.text,
      postType: _selectedType,
    );

    // Centralize location and industry updates
    if (profileController.myProfile.uid.isNotEmpty) {
      final String loc = _locationController.text.trim();
      final String ind = _industryController.text.trim();

      bool needsUpdate = false;
      final Map<String, dynamic> updateData = <String, dynamic>{};

      if (loc.isNotEmpty && loc != profileController.myProfile.location) {
        updateData['location'] = loc;
        needsUpdate = true;
      }
      if (ind.isNotEmpty && ind != profileController.myProfile.industry) {
        updateData['industry'] = ind;
        needsUpdate = true;
      }

      if (needsUpdate) {
        profileController.myProfile = profileController.myProfile.copyWith(
          location: loc.isNotEmpty ? loc : profileController.myProfile.location,
          industry: ind.isNotEmpty ? ind : profileController.myProfile.industry,
        );
        profileController.update();

        // Update backend
        await ApiService.put(
          path: 'users/${profileController.myProfile.uid}',
          body: updateData,
        );

        // Also update shop if location or industry changed
        if (shopController.shop != null) {
          final Map<String, dynamic> shopUpdateData = <String, dynamic>{};
          if (updateData.containsKey('location')) {
            shopUpdateData['location'] = updateData['location'];
          }
          if (updateData.containsKey('industry')) {
            shopUpdateData['category'] = updateData['industry'];
          }

          if (shopUpdateData.isNotEmpty) {
            await shopController.updateShop(
                shopController.shop!.id, shopUpdateData);
          }
        }
      }
    }

    aiPromoteController.setBusinessDetails(
      name: _nameController.text.trim(),
      desc: _bioController.text.trim(),
      loc: _locationController.text.trim(),
      ind: _industryController.text.trim(),
      type: _selectedType,
      priceVal: _priceController.text.trim(),
      additionalDetailsVal: _extraDetailsController.text.trim(),
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
    FocusNode? focusNode,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            focusNode: focusNode,
            maxLines: maxLines,
            keyboardType: keyboardType,
            style: const TextStyle(color: Colors.black87),
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
              filled: true,
              fillColor:
                  isMissing ? const Color(0xFFFEF3C7) : const Color(0xFFF3F4F6),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isMissing
                      ? const Color(0xFFEF4444)
                      : const Color(0xFFE5E7EB),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isMissing
                      ? const Color(0xFFEF4444)
                      : const Color(0xFFE5E7EB),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Color(0xFF6366F1), width: 1.5),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Select type of post',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedType,
                    isExpanded: true,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedType = newValue!;
                      });
                    },
                    items: <String>[
                      'Promote My Business',
                      'Sell a Product or Service',
                      'Need a Product or Service',
                      'Find a Partner',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        const Text(
          'Get featured, get matched, and discover new opportunities faster.',
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
                        'Setup BizCenter',
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
        widget.infoClicked ? _buildInfoCard() : SizedBox.shrink(),
        _buildInputGroup(
          'Title',
          _nameController,
          placeholder: 'Enter post title',
          isMissing: missingFields.contains('Title'),
          focusNode: _nameFocus, // Pass focusNode
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Industry',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: <String>[
                            'Agriculture, Food & Beverage',
                            'Learning & Education',
                            'Construction & Real Estate',
                            'Fashion & Beauty',
                            'Finance & Legal',
                            'Healthcare & Wellness',
                            'Home, Gardens & Outdoors',
                            'Jewellery & Timepieces',
                            'Media & Entertainment',
                            'Security, Safety & Equipment',
                            'Technology, Games & Electronic',
                            'Vehicle & Transportation',
                            'Business Services & Consulting',
                          ].contains(_industryController.text)
                              ? _industryController.text
                              : null,
                          isExpanded: true,
                          hint: const Text('Select Industry'),
                          onChanged: (String? newValue) {
                            setState(() {
                              _industryController.text = newValue!;
                            });
                          },
                          items: <String>[
                            'Agriculture, Food & Beverage',
                            'Learning & Education',
                            'Construction & Real Estate',
                            'Fashion & Beauty',
                            'Finance & Legal',
                            'Healthcare & Wellness',
                            'Home, Gardens & Outdoors',
                            'Jewellery & Timepieces',
                            'Media & Entertainment',
                            'Security, Safety & Equipment',
                            'Technology, Games & Electronic',
                            'Vehicle & Transportation',
                            'Business Services & Consulting',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInputGroup(
                'Country',
                _locationController,
                placeholder: 'Select Country',
                isMissing: missingFields.contains('Location'),
                focusNode: _locationFocus,
              ),
            ),
          ],
        ),
        _buildInputGroup(
          'Description',
          _bioController,
          placeholder: 'What is your post about?',
          maxLines: 3,
          isMissing: missingFields.contains('Description/Tagline'),
          focusNode: _bioFocus, // Pass focusNode
        ),
        _buildInputGroup(
          'Website or Contact Link',
          _websiteController,
          placeholder: 'Enter your website URL / contact link',
          keyboardType: TextInputType.url,
          focusNode: _websiteFocus, // Pass focusNode
        ),
        SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: widget.isLoading
                ? null
                : () {
                    if (widget.limitReached) {
                      showPremiumPaywall();
                      return;
                    }
                    _handleSubmit();
                  },
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
                        ? 'Limit reached For This Month'
                        : 'Generate Post with AI',
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
                showPremiumPaywall();
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
