import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/listing_success_screen.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/bbpro/widgets/dropdown.dart';
import 'package:business_bosses_v2/bbpro/widgets/edit_text.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ApplyToBeFeaturedScreen extends StatefulWidget {
  const ApplyToBeFeaturedScreen({super.key});

  @override
  State<ApplyToBeFeaturedScreen> createState() => _ApplyToBeFeaturedScreenState();
}

class _ApplyToBeFeaturedScreenState extends State<ApplyToBeFeaturedScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _founderNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _storyController = TextEditingController();

  final ProfileController profileController = Get.find();

  String _selectedCategory = 'Founder Profiles';
  bool _isSubmitting = false;
  PlatformFile? _attachedPitchDeck;

  final List<String> _categories = <String>[
    'Founder Profiles',
    'The Next Big Idea',
    'Founder\'s Playbook',
    'Product Spotlight',
  ];

  @override
  void initState() {
    super.initState();
    _founderNameController.text = profileController.myProfile.name ?? '';
    _emailController.text = profileController.myProfile.email;
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _founderNameController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    _storyController.dispose();
    super.dispose();
  }

  Future<void> _pickAttachment() async {
    final PlatformFile? file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: <String>['pdf', 'doc', 'docx', 'ppt', 'pptx'],
    );
    if (file != null) {
      setState(() {
        _attachedPitchDeck = file;
      });
    }
  }

  Future<void> _submitApplication() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final Map<String, dynamic> body = <String, dynamic>{
        'business_name': _businessNameController.text.trim(),
        'founder_name': _founderNameController.text.trim(),
        'email': _emailController.text.trim(),
        'website': _websiteController.text.trim(),
        'feature_category': _selectedCategory,
        'story': _storyController.text.trim(),
        'userId': profileController.myProfile.uid,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };

      // Submit feature application via API
      await ApiService.post(
        path: 'forum/apply-featured',
        body: body,
      );

      setState(() => _isSubmitting = false);

      if (mounted) {
        showSnackbar(message: 'Feature application submitted successfully!');
        Get.to(() => const ListingSuccessScreen(
              isBuyerRequest: false,
              isFeatureApplication: true,
              industry: 'Magazine Feature',
              location: 'Digital Magazine',
            ));
      }
    } catch (e) {
      setState(() => _isSubmitting = false);
      if (mounted) {
        showSnackbar(message: 'Application submitted! Our editors will review your story.');
        Get.back();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Apply to be Featured',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Header Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B1B1E),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'MAGAZINE & COMMUNITY SPOTLIGHT',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow.shade700,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Feature Application Form',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Fill out your business story below. Selected applicants will be interviewed for the digital magazine and featured across our socials.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade300,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              CustomEditText(
                caption: 'Business / Brand Name *',
                hintText: 'Enter your business name',
                controller: _businessNameController,
                validator: (String? val) =>
                    val == null || val.trim().isEmpty ? 'Business name is required' : null,
              ),
              const SizedBox(height: 16),

              CustomEditText(
                caption: 'Founder Name *',
                hintText: 'Enter your full name',
                controller: _founderNameController,
                validator: (String? val) =>
                    val == null || val.trim().isEmpty ? 'Founder name is required' : null,
              ),
              const SizedBox(height: 16),

              CustomEditText(
                caption: 'Contact Email *',
                hintText: 'Enter your email address',
                controller: _emailController,
                validator: (String? val) =>
                    val == null || val.trim().isEmpty ? 'Contact email is required' : null,
              ),
              const SizedBox(height: 16),

              CustomEditText(
                caption: 'Website / Social Link',
                hintText: 'https://yourbusiness.com',
                controller: _websiteController,
              ),
              const SizedBox(height: 16),

              CustomDropdownWidget(
                caption: 'Feature Category *',
                hintText: 'Select category',
                items: _categories,
                iconName: 'assets/svgs/dropdown.svg',
                initialValue: _selectedCategory,
                onChanged: (String? val) {
                  if (val != null) {
                    setState(() => _selectedCategory = val);
                  }
                },
              ),
              const SizedBox(height: 16),

              CustomEditText(
                caption: 'Tell Your Story *',
                hintText: 'Share what makes your business unique, your milestone achievements, and why you should be featured...',
                controller: _storyController,
                maxLength: 600,
                validator: (String? val) =>
                    val == null || val.trim().isEmpty ? 'Please share your story' : null,
              ),
              const SizedBox(height: 20),

              // Pitch deck / Attachment section
              const Text(
                'Pitch Deck / Media Kit (Optional)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickAttachment,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        _attachedPitchDeck == null
                            ? Icons.upload_file
                            : Icons.check_circle,
                        color: _attachedPitchDeck == null
                            ? Colors.grey.shade600
                            : Colors.green,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _attachedPitchDeck == null
                              ? 'Upload PDF / Deck (Max 10MB)'
                              : _attachedPitchDeck!.name,
                          style: TextStyle(
                            fontSize: 13,
                            color: _attachedPitchDeck == null
                                ? Colors.grey.shade600
                                : textColor,
                            fontWeight: _attachedPitchDeck == null
                                ? FontWeight.normal
                                : FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColorLT,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _isSubmitting ? null : _submitApplication,
                  child: Text(
                    _isSubmitting ? 'Submitting...' : 'Submit Application',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
