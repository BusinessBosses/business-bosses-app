import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/presentation/setup_shop.dart';
import 'package:business_bosses_v2/features/aipromote/controller/ai_promote_controller.dart';
import 'package:business_bosses_v2/features/aipromote/models/business_info_model.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BusinessInfoForm extends StatefulWidget {
  final BusinessInfo initialInfo;
  final Function(BusinessInfo) onSubmit;
  final bool isLoading;

  const BusinessInfoForm({
    super.key,
    required this.initialInfo,
    required this.onSubmit,
    required this.isLoading,
  });

  @override
  State<BusinessInfoForm> createState() => _BusinessInfoFormState();
}

class _BusinessInfoFormState extends State<BusinessInfoForm> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _industryController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  TextEditingController _websiteController = TextEditingController();
  final ProfileController profileController = ProfileController();
  final ShopController shopController = Get.find();
  final AiPromoteController aiPromoteController = Get.find();

  @override
  void initState() {
    super.initState();
    if (shopController.shop == null) {
      if (profileController.myProfile.hasShop) {
        shopController.initShop();
      } else {
        Get.off(() => const Setupshop(
              backToHome: true,
            ));
      }
    } else {
      _nameController = TextEditingController(text: shopController.shop!.name);
      _industryController =
          TextEditingController(text: shopController.shop!.category);
      _bioController =
          TextEditingController(text: shopController.shop!.description);
      _websiteController =
          TextEditingController(text: shopController.shop!.url);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _industryController.dispose();
    _bioController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final BusinessInfo info = BusinessInfo(
      name: _nameController.text,
      industry: _industryController.text,
      bio: _bioController.text,
      website: _websiteController.text,
    );
    widget.onSubmit(info);
    aiPromoteController.setBusinessDetails(
      name: _nameController.text.trim(),
      desc: _bioController.text.trim(),
      loc: _websiteController.text.trim(), // pass website as “location”
      ind: _industryController.text.trim(),
    );
  }

  Widget _buildInputGroup(
    String label,
    TextEditingController controller, {
    String? placeholder,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF4B5563),
            ),
          ),
          SizedBox(height: 6),
          TextFormField(
            enabled: label == 'Website or Contact Link' &&
                    (shopController.shop!.url == null ||
                        shopController.shop!.url!.isEmpty)
                ? true
                : false,
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: placeholder,
              filled: true,
              fillColor: Color(0xFFF9FAFB),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xFFD1D5DB)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xFFD1D5DB)),
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

  @override
  Widget build(BuildContext context) {
    return shopController.shop == null
        ? CircularProgressIndicator()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Business Info Confirmation',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Confirm your business information below to create your AI-generated promotion',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                ),
              ),
              SizedBox(height: 24),
              _buildInputGroup(
                'Business Name',
                _nameController,
                placeholder: 'Enter your business name',
              ),
              _buildInputGroup(
                'Industry',
                _industryController,
                placeholder: 'Enter your industry',
              ),
              _buildInputGroup(
                'Tagline/Description',
                _bioController,
                placeholder: 'Enter a short description or tagline',
                maxLines: 3,
              ),
              _buildInputGroup(
                'Website or Contact Link',
                _websiteController,
                placeholder: 'Enter your website URL',
                keyboardType: TextInputType.url,
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: widget.isLoading ? null : _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6366F1),
                    disabledBackgroundColor: Color(0xFFA5B4FC),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: widget.isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Generate Mini Ad',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          );
  }
}
