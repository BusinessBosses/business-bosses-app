import 'dart:io';

import 'package:business_bosses_v2/bbpro/widgets/button.dart';
import 'package:business_bosses_v2/bbpro/widgets/edit_text.dart';
import 'package:business_bosses_v2/bbpro/widgets/textfield.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utils/theme/theme.dart';
import '../../forum/widgets/field_container.dart';
import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/shop_model.dart';
import 'package:get/get.dart';

class VerifyBusinessScreen extends StatefulWidget {
  const VerifyBusinessScreen({super.key});

  @override
  VerifyBusinessScreenState createState() => VerifyBusinessScreenState();
}

class VerifyBusinessScreenState extends State<VerifyBusinessScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ShopController shopController = Get.find<ShopController>();

  final List<XFile> _keyIndividualDocs = <XFile>[];
  final List<XFile> _businessRegDocs = <XFile>[];
  final List<XFile> _proofOfAddressDocs = <XFile>[];

  String? description;
  String? email;
  String? name;
  String? url;
  String? _selectedCategory = 'Agriculture, Food & Beverage';
  String? _selectedLocation;
  bool _isProcessing = false;
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final List<String> categories = <String>[
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
    'Vehicle & Transportation'
  ];

  @override
  void initState() {
    super.initState();
    _fetchShopDetails();
  }

  Future<void> _fetchShopDetails() async {
    await shopController.initShop();
    if (shopController.shop != null) {
      final Shop shop = shopController.shop!;
      setState(() {
        _nameController.text = shop.name;
        name = shop.name;

        if (shop.email != null) {
          _emailController.text = shop.email!;
          email = shop.email;
        }
        if (shop.phone != null) {
          _phoneController.text = shop.phone!;
        }
        if (shop.url != null) {
          _urlController.text = shop.url!;
          url = shop.url;
        }
        descriptionController.text = shop.description;
        description = shop.description;

        if (categories.contains(shop.category)) {
          _selectedCategory = shop.category;
        }
        _selectedLocation = shop.location;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: backgroundcolorinterface,
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Verify Business'),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 16.0, left: 0.0, right: 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CustomEditText(
                maxLength: 30,
                controller: _nameController,
                onChanged: (String val) => name = val,
                caption: 'Business Name *',
                hintText: 'Enter Business Name',
              ),
              const SizedBox(
                height: 15,
              ),
              CustomEditText(
                maxLength: 30,
                controller: _emailController,
                onChanged: (String val) => email = val,
                caption: 'Business Email *',
                inputType: TextInputType.emailAddress,
                hintText: 'Enter Business Email',
              ),
              const SizedBox(height: 15.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextFormField(
                  controller: _phoneController,
                  onChanged: (String val) => email = val,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.phone,
                  decoration: inputDecoration.copyWith(
                    hintText: '*Enter Business Telephone',
                  ),
                ),
              ),
              const SizedBox(height: 15.0),
              CustomEditText(
                controller: _urlController,
                onChanged: (String val) => url = val,
                maxLength: 30,
                hintText: 'Enter Business Website link',
                caption: 'Business Website Link *',
              ),
              const SizedBox(height: 15.0),
              CustomEditText(
                controller: descriptionController,
                inputType: TextInputType.multiline,
                maxLength: 300,
                onChanged: (String val) => description = val,
                hintText: 'Describe your business...',
                caption: 'Business Description',
              ),
              const SizedBox(height: 15.0),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(radiusValue),
                  ),
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16,
                    top: 4,
                    bottom: 5,
                  ),
                  child: DropdownButton<String>(
                    underline: Container(),
                    value: _selectedCategory,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_right),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(fontSize: 14, color: textColor),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCategory = newValue!;
                      });
                    },
                    items: categories
                        .map<DropdownMenuItem<String>>((String? value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: value != null
                            ? Text(value)
                            : Text(
                                value ?? 'Select Category',
                                style: bodyText2.copyWith(
                                  fontSize: 14,
                                  color: hintColor,
                                ),
                              ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 12.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  initialSelection: _selectedLocation,
                  pickerBuilder:
                      (BuildContext context, CountryCode? countryCode) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(radiusValue),
                      ),
                      child: CustomTextWidget(
                        hashint: true,
                        caption: 'Location',
                        iconcolor: textColor,
                        iconName: 'assets/svgs/nexticon.svg',
                        text: _selectedLocation ?? 'Choose Location',
                      ),
                    );
                  },
                  onChanged: (CountryCode? code) async {
                    setState(() {
                      _selectedLocation = code!.name;
                    });
                    // Logic for shared prefs if needed
                  },
                  useSafeArea: false,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              _buildUploadSection(
                context,
                title: 'Key Individuals',
                subtitle:
                    'Directors/Signatories - Proof of Identity: Government-issued photo ID (Passport, Driver\'s License).',
                files: _keyIndividualDocs,
                onAdd: () => _pickFiles(_keyIndividualDocs),
                onRemove: (int index) => _removeFile(_keyIndividualDocs, index),
              ),
              _buildUploadSection(
                context,
                title: 'Business Registration',
                subtitle: 'Certificate of Incorporation, or Business License',
                files: _businessRegDocs,
                onAdd: () => _pickFiles(_businessRegDocs),
                onRemove: (int index) => _removeFile(_businessRegDocs, index),
              ),
              _buildUploadSection(
                context,
                title: 'Proof of Address',
                subtitle:
                    'Utility bill or bank statement for the business\'s registered address.',
                files: _proofOfAddressDocs,
                onAdd: () => _pickFiles(_proofOfAddressDocs),
                onRemove: (int index) =>
                    _removeFile(_proofOfAddressDocs, index),
              ),
              SizedBox(
                width: double.infinity,
                child: ProCustomButton(
                  color: primaryColorLT,
                  onPressed: () async {
                    setState(() {
                      _isProcessing = true;
                    });

                    bool anError = false;

                    if (descriptionController.text.isEmpty ||
                        _emailController.text.isEmpty ||
                        _nameController.text.isEmpty ||
                        _urlController.text.isEmpty ||
                        _phoneController.text.isEmpty ||
                        _selectedCategory == null ||
                        _selectedLocation == null ||
                        _keyIndividualDocs.isEmpty ||
                        _businessRegDocs.isEmpty ||
                        _proofOfAddressDocs.isEmpty) {
                      anError = true;
                    }

                    if (anError) {
                      showSnackbar(
                          message: 'All fields are mandatory!',
                          error: true,
                          title: 'Error!');
                      setState(() {
                        _isProcessing = false;
                      });
                      return;
                    } else if (!_isValidURL(url!)) {
                      showSnackbar(
                          message: 'Please enter a valid website link!',
                          error: true,
                          title: 'Error');
                      setState(() {
                        _isProcessing = false;
                      });
                      return;
                    } else {
                      await _submitVerification();
                    }
                    setState(() {
                      _isProcessing = false;
                    });
                  },
                  loading: _isProcessing,
                  text: 'Submit Verification',
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickFiles(List<XFile> targetList) async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        targetList.addAll(images);
      });
    }
  }

  void _removeFile(List<XFile> targetList, int index) {
    setState(() {
      targetList.removeAt(index);
    });
  }

  Widget _buildUploadSection(
    BuildContext context, {
    required String title,
    required String subtitle,
    required List<XFile> files,
    required VoidCallback onAdd,
    required Function(int) onRemove,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16),
          child: GestureDetector(
            onTap: onAdd,
            child: FieldContainer(
              child: Row(
                children: <Widget>[
                  SvgPicture.asset('assets/svgs/file.svg'),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Text(
                      'Upload $title',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: hintColor),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  CircleAvatar(
                    radius: 26 / 1.38,
                    backgroundColor: backgroundColor,
                    child: SvgPicture.asset(
                      'assets/svgs/addimagepost.svg',
                      height: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16,
            bottom: 20,
            top: 10,
          ),
          child: files.isNotEmpty
              ? Wrap(
                  spacing: 10.0,
                  runSpacing: 10.0,
                  children: files.map((XFile image) {
                    final int index = files.indexOf(image);
                    return Stack(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.file(
                            File(image.path),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          child: GestureDetector(
                            onTap: () => onRemove(index),
                            child: const CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.red,
                              child: Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  bool _isValidURL(String url) {
    final RegExp urlPattern = RegExp(
      r'^(https?:\/\/)?([a-zA-Z0-9-]{1,63}\.){1,255}[a-zA-Z]{2,63}(:[0-9]{1,5})?(\/.*)?$',
    );
    return urlPattern.hasMatch(url);
  }

  Future<void> _submitVerification() async {
    // Simulate API call for now
    await Future<void>.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Verification Submitted!'),
        content: const Text(
            'Your business details have been submitted for verification. We will review it shortly.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // close screen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
