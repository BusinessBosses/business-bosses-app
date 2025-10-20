import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/widgets/button.dart';
import 'package:business_bosses_v2/bbpro/widgets/dropdown.dart';
import 'package:business_bosses_v2/bbpro/widgets/edit_text.dart';
import 'package:business_bosses_v2/bbpro/widgets/textfield.dart';
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
  final ShopController shopController = Get.find();

  List<PlatformFile> _attachments = <PlatformFile>[];
  String country = '';

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: <String>[
        'pdf',
        'doc',
        'docx',
        'txt',
        'png',
        'jpg',
        'jpeg',
        'gif'
      ],
    );

    if (result != null) {
      setState(() {
        _attachments =
            <PlatformFile>[..._attachments, ...result.files].take(5).toList();
      });
    }
  }

  void _removeFile(int index) {
    setState(() {
      _attachments.removeAt(index);
    });
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
                caption: 'Company Phone *',
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
              caption: 'Company Category *',
              items: <String>[
                'Brand deals/Discounts',
                'Organisation Initiatives',
                'Government Initiatives'
              ],
              iconName: 'assets/svgs/dropdown.svg',
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
              caption: 'Description of your deal/offering',
              hintText: 'Eg. 30% discount on new membership',
              controller: bioController,
              inputType: TextInputType.name,
            ),
            CustomEditText(
                caption: 'Website or link to redeem the deal',
                hintText: 'Enter website or link',
                controller: emailController,
                inputType: TextInputType.emailAddress),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildLabel('Attach File (Optional)', LucideIcons.file),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: InkWell(
                    onTap: _attachments.length < 5 ? _pickFile : null,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.grey[300]!,
                          width: 2,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: <Widget>[
                          Icon(
                            LucideIcons.uploadCloud,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Drag & drop file here',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'or click to browse',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Attachment List
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
                          Icon(Icons.description, color: Colors.grey[400]),
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
            CustomEditText(
              maxLength: 300,
              caption: 'Add customised message, bio or note',
              optionalText: Text('Optional',
                  style: TextStyle(color: Colors.grey, fontSize: 12)),
              hintText: 'Enter your customised message',
              controller: bioController,
              inputType: TextInputType.name,
            ),
            SizedBox(
              width: double.infinity,
              child: ProCustomButton(
                text: 'Submit',
                color: primaryColorLT,
                onPressed: () {},
              ),
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
