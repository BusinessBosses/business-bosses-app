import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/widgets/button.dart';
import 'package:business_bosses_v2/bbpro/widgets/dropdown.dart';
import 'package:business_bosses_v2/bbpro/widgets/edit_text.dart';
import 'package:business_bosses_v2/bbpro/widgets/textfield.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/features/donations/presentation/partner_created.dart';
import 'package:business_bosses_v2/features/partners/controllers/partners_controller.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';

class BecomeaPartnerScreen extends StatefulWidget {
  const BecomeaPartnerScreen({super.key});

  @override
  State<BecomeaPartnerScreen> createState() => _BecomeaPartnerScreenState();
}

class _BecomeaPartnerScreenState extends State<BecomeaPartnerScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController urlController = TextEditingController();
  final ProfileController profileController = Get.find();

  final ShopController shopController = Get.find();
  final PartnerController partnerController = Get.put(PartnerController());

  List<PlatformFile> _attachments = <PlatformFile>[];
  String country = '';
  String selectedPartnershipType = 'Brand deals/Discounts';
  String selectedCategory = 'Business Services & Consulting';

  /// Pick image (single)
  Future<void> _pickFile() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _attachments = <PlatformFile>[result.files.first];
      });
    }
  }

  void _removeFile() {
    setState(() => _attachments.clear());
  }

  Future<void> _onSubmitPressed() async {
    if (!_validateInputs()) return;

    final PlatformFile? image =
        _attachments.isNotEmpty ? _attachments.first : null;

    final ApiResponseModel resp = await partnerController.submitPartner(
      companyName: nameController.text.trim(),
      companyEmail: profileController.myProfile.email, // default to user email
      partnershipType: 'marketplace', // default
      category: selectedCategory,
      location: country.isEmpty ? shopController.shop?.location : country,
      companyUrl: urlController.text.trim(),
      companyDescription: descriptionController.text.trim(),
      image: image,
      userId: profileController.myProfile.uid,
    );

    if (resp.success) {
      // ✅ Pop screen after successful submission
      if (mounted) Get.until((Route<dynamic> route) => route.isFirst);
      showSnackbar(
        title: 'Success',
        message: 'Your partnership has been submitted for moderation.',
      );
      Get.to(() => const PartnerCreated());
    }
  }

  bool _validateInputs() {
    if (nameController.text.trim().isEmpty) {
      showSnackbar(
        title: 'Validation',
        message: 'Name of Deal is required',
        error: true,
      );
      return false;
    }

    if (country.isEmpty) {
      showSnackbar(
        title: 'Validation',
        message: 'Please select your location',
        error: true,
      );
      return false;
    }

    if (selectedCategory.isEmpty) {
      showSnackbar(
        title: 'Validation',
        message: 'Please select your industry category',
        error: true,
      );
      return false;
    }

    if (descriptionController.text.trim().isEmpty) {
      showSnackbar(
        title: 'Validation',
        message: 'Description of your deal/offering is required',
        error: true,
      );
      return false;
    }

    if (urlController.text.trim().isEmpty) {
      showSnackbar(
        title: 'Validation',
        message: 'Deal link is required',
        error: true,
      );
      return false;
    }

    if (_attachments.isEmpty) {
      showSnackbar(
        title: 'Validation',
        message: 'Please upload an image',
        error: true,
      );
      return false;
    }

    return true;
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        ),
        centerTitle: true,
        title: Column(
          children: <Widget>[
            const Text('Become a Partner',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                )),
            const SizedBox(height: 5),
            const Text('Reach More Buyers & Customers',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20,
          children: <Widget>[
            const SizedBox(height: 15),
            CustomEditText(
              caption: 'Name of Deal *',
              hintText: 'Enter your deal name',
              controller: nameController,
              inputType: TextInputType.name,
            ),
            _buildCountrySelector(),
            CustomEditText(
              maxLength: 300,
              caption: 'Description of your deal/offering *',
              hintText: 'Eg. 30% discount on new membership',
              controller: descriptionController,
              inputType: TextInputType.text,
            ),
            CustomEditText(
              caption: 'Link to redeem the deal *',
              hintText: 'Enter link',
              controller: urlController,
              inputType: TextInputType.url,
            ),
            CustomDropdownWidget(
              caption: 'Industry Category *',
              items: const <String>[
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
                'Business Services & Consulting'
              ],
              iconName: 'assets/svgs/dropdown.svg',
              onChanged: (String? val) => selectedCategory = val!,
            ),
            _buildImagePicker(),
            _buildAttachmentList(),
            _buildAgreementText(),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildCountrySelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7.0),
      child: CountryListPick(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
          ),
          centerTitle: true,
          title: const Text('Select Location'),
        ),
        initialSelection:
            country.isEmpty ? shopController.shop?.location : country,
        pickerBuilder: (BuildContext context, CountryCode? countryCode) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(radiusValue),
            ),
            child: CustomTextWidget(
              caption: 'Company Location *',
              iconName: 'assets/svgs/nexticon.svg',
              text: country.isEmpty
                  ? shopController.shop?.location ?? 'Select country'
                  : country,
            ),
          );
        },
        onChanged: (CountryCode? code) =>
            setState(() => country = code?.name ?? ''),
        useSafeArea: false,
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: _buildLabel('Add image or file', LucideIcons.image),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: InkWell(
            onTap: _attachments.isEmpty ? _pickFile : null,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey[300]!, width: 2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(LucideIcons.uploadCloud,
                      size: 20, color: Colors.grey[400]),
                  const SizedBox(width: 10),
                  Text(
                    'Tap to select file',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAttachmentList() {
    if (_attachments.isEmpty) return const SizedBox();
    final PlatformFile file = _attachments.first;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: <Widget>[
            const Icon(Icons.image, color: Colors.grey),
            const SizedBox(width: 12),
            Expanded(child: Text(file.name, overflow: TextOverflow.ellipsis)),
            const SizedBox(width: 8),
            Text('${(file.size / 1024).toStringAsFixed(1)} KB',
                style: TextStyle(fontSize: 12, color: Colors.grey[400])),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red, size: 20),
              onPressed: _removeFile,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAgreementText() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Text(
          'By clicking submit, you agree to let Business Bosses use your logo and branding on marketing materials to promote the partnership.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: subtextColor),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Obx(() {
      final bool loading = partnerController.isLoading.value;
      return SizedBox(
        width: double.infinity,
        child: ProCustomButton(
          loading: loading,
          text: loading ? 'Submitting...' : 'Submit',
          color: primaryColorLT,
          onPressed: _onSubmitPressed,
        ),
      );
    });
  }

  Widget _buildLabel(String text, IconData icon) {
    return Row(
      children: <Widget>[
        Icon(icon, size: 16, color: Colors.grey[700]),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}
