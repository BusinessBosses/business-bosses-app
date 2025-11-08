import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/widgets/button.dart';
import 'package:business_bosses_v2/bbpro/widgets/dropdown.dart';
import 'package:business_bosses_v2/bbpro/widgets/edit_text.dart';
import 'package:business_bosses_v2/bbpro/widgets/textfield.dart';
import 'package:business_bosses_v2/features/home/controller/partners_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

class BecomeaPartnerScreen extends StatefulWidget {
  const BecomeaPartnerScreen({super.key});

  @override
  State<BecomeaPartnerScreen> createState() => _BecomeaPartnerScreenState();
}

class _BecomeaPartnerScreenState extends State<BecomeaPartnerScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController urlController = TextEditingController();
  final ShopController shopController = Get.find();

  // PartnerController instance
  final PartnerController partnerController = Get.put(PartnerController());

  // Only one image allowed
  List<PlatformFile> _attachments = <PlatformFile>[];
  String country = '';

  // PICK: images only, single file
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image, // restrict to images only
      // allowedExtensions not needed when using FileType.image
      // allowedExtensions: <String>['png','jpg','jpeg','gif'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        // keep only the first selected image (single)
        _attachments = <PlatformFile>[result.files.first];
      });
    }
  }

  void _removeFile(int index) {
    setState(() {
      _attachments.removeAt(index);
    });
  }

  Future<void> _onSubmitPressed() async {
    // Basic validation
    if (nameController.text.trim().isEmpty) {
      Get.snackbar('Validation', 'Company name is required');
      return;
    }
    if (emailController.text.trim().isEmpty) {
      Get.snackbar('Validation', 'Company email is required');
      return;
    }
    if (bioController.text.trim().isEmpty) {
      Get.snackbar('Validation', 'Customised message / bio is required');
      return;
    }
    if (descriptionController.text.trim().isEmpty) {
      Get.snackbar(
          'Validation', 'Description of your deal/offering is required');
      return;
    }

    // Replace these with actual dropdown-selected values if you wire them later
    final String selectedPartnershipType = 'Brand deals/Discounts';
    final String selectedCategory = 'Other';

    final PlatformFile? image =
        _attachments.isNotEmpty ? _attachments.first : null;

    await partnerController.submitPartner(
      companyName: nameController.text.trim(),
      companyEmail: emailController.text.trim(),
      companyPhone: phoneController.text.trim().isEmpty
          ? null
          : phoneController.text.trim(),
      partnershipType: selectedPartnershipType,
      category: selectedCategory,
      location: country.isEmpty ? shopController.shop?.location : country,
      companyUrl: urlController.text.trim(),
      companyDescription:
          bioController.text.trim().isEmpty ? null : bioController.text.trim(),
      image: image,
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    companyNameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        ),
        centerTitle: true,
        title: const Text(
          'Become a Partner',
          textAlign: TextAlign.center,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: CustomEditText(
                  caption: 'Company Name *',
                  hintText: 'Enter your company name',
                  controller: nameController,
                  inputType: TextInputType.name),
            ),
            CustomEditText(
                caption: 'Company Email Address *',
                hintText: 'Enter your company email address',
                controller: emailController,
                inputType: TextInputType.emailAddress),
            CustomEditText(
                optionalText: Text(
                  'Please add your country code. Eg. +44 100 000 0000',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                caption: 'Company Phone Number (Optional)',
                hintText: 'Enter your company phone number',
                inputType: TextInputType.phone,
                controller: phoneController),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7.0),
              child: CountryListPick(
                appBar: AppBar(
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
                  ),
                  centerTitle: true,
                  title: const Text(
                    'Select Location',
                    textAlign: TextAlign.center,
                  ),
                ),
                initialSelection:
                    country.isEmpty ? shopController.shop!.location : country,
                pickerBuilder:
                    (BuildContext context, CountryCode? countryCode) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(radiusValue),
                    ),
                    child: CustomTextWidget(
                      caption: 'Company Location *',
                      iconName: 'assets/svgs/nexticon.svg',
                      text: country.isEmpty
                          ? shopController.shop!.location
                          : country,
                    ),
                  );
                },
                onChanged: (CountryCode? code) async {
                  setState(() {
                    country = code!.name!;
                  });
                },
                useSafeArea: false,
              ),
            ),
            CustomDropdownWidget(
              caption: 'Type of Partnership *',
              items: <String>[
                'Brand deals/Discounts',
                'Organisation Initiatives',
                'Government Initiatives'
              ],
              iconName: 'assets/svgs/dropdown.svg',
            ),
            CustomEditText(
              maxLength: 300,
              caption: 'Description of your deal/offering *',
              hintText: 'Eg. 30% discount on new membership',
              controller: descriptionController,
              inputType: TextInputType.name,
            ),
            CustomEditText(
              maxLength: 300,
              caption: 'Add customised message, bio or note *',
              hintText: 'Enter your customised message',
              controller: bioController,
              inputType: TextInputType.name,
            ),
            CustomEditText(
                caption: 'Website or link to redeem the deal',
                hintText: 'Enter website or link',
                controller: urlController,
                inputType: TextInputType.url),
            CustomDropdownWidget(
              caption: 'Company Category *',
              items: <String>[
                'Agriculture, Food & Beverage',
                'Books & Education',
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
                'Other'
              ],
              iconName: 'assets/svgs/dropdown.svg',
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildLabel(
                          'Add image or file (Optional)', LucideIcons.image),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: InkWell(
                    onTap: _attachments.isEmpty ? _pickFile : null,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.grey[300]!,
                          width: 2,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            LucideIcons.uploadCloud,
                            size: 20,
                            color: Colors.grey[400],
                          ),
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
            ),
            // Attachment List (will show at most one image)
            if (_attachments.isNotEmpty) ...<Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _attachments.length,
                  itemBuilder: (BuildContext context, int index) {
                    final PlatformFile file = _attachments[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.image,
                              color: Colors.grey[400]), // image icon
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              file.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${(file.size / 1024).toStringAsFixed(1)} KB',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[400],
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () => _removeFile(index),
                            iconSize: 20,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],

            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  textAlign: TextAlign.center,
                  'By clicking submit, you agree to let Business Bosses use your logo and branding on marketing materials to promote the partnership.',
                  style: TextStyle(
                    fontSize: 12,
                    color: subtextColor,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Obx(() {
                return ProCustomButton(
                  loading: partnerController.isLoading.value,
                  text: partnerController.isLoading.value
                      ? 'Submitting...'
                      : 'Submit',
                  color: primaryColorLT,
                  onPressed: partnerController.isLoading.value
                      ? () {}
                      : () {
                          _onSubmitPressed();
                        },
                );
              }),
            ),
            SizedBox(
              height: 200,
            )
          ],
        ),
      ),
    );
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
