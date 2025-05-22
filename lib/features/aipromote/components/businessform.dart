import 'package:flutter/material.dart';

class BusinessInfo {
  final String name;
  final String industry;
  final String bio;
  final String website;

  BusinessInfo({
    required this.name,
    required this.industry,
    required this.bio,
    required this.website,
  });

  BusinessInfo copyWith({
    String? name,
    String? industry,
    String? bio,
    String? website,
  }) {
    return BusinessInfo(
      name: name ?? this.name,
      industry: industry ?? this.industry,
      bio: bio ?? this.bio,
      website: website ?? this.website,
    );
  }
}

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
  _BusinessInfoFormState createState() => _BusinessInfoFormState();
}

class _BusinessInfoFormState extends State<BusinessInfoForm> {
  late TextEditingController _nameController;
  late TextEditingController _industryController;
  late TextEditingController _bioController;
  late TextEditingController _websiteController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialInfo.name);
    _industryController =
        TextEditingController(text: widget.initialInfo.industry);
    _bioController = TextEditingController(text: widget.initialInfo.bio);
    _websiteController =
        TextEditingController(text: widget.initialInfo.website);
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
    return Column(
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
          'Confirm or edit your business information below to create your AI-generated promotion',
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
          'Bio/Tagline',
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
