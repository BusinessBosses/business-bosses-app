import 'dart:io';

import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/features/home/widgets/sellingpopup.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/supplier_controller.dart';
import 'package:business_bosses_v2/features/marketplace/models/suppliers_model.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../action/action.dart';
import '../../../common/widgets/buttons/my_outlined_button.dart';
import '../../../utils/theme/theme.dart';
import '../../forum/widgets/field_container.dart';
import '../../profile/controller/profile_controller.dart';

/// SELLING SCREEN MARKETPLACE
class AddSupplierScreen extends StatefulWidget {
  /// SELLING SCREEN MARKETPLACE
  const AddSupplierScreen({Key? key, this.supplier}) : super(key: key);

  final SuppliersModel? supplier;
  @override
  // ignore: library_private_types_in_public_api
  _AddSupplierScreenState createState() => _AddSupplierScreenState();
}

class _AddSupplierScreenState extends State<AddSupplierScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ProfileController _profileController = Get.find();
  final SupplierController supplierController = Get.put(SupplierController());
  final List<XFile> _selectedImages = <XFile>[];

  SuppliersModel? _supplier;

  String? description;
  String? email;
  String? name;
  String? url;
  String? discount;
  String? _selectedCategory;
  String? _selectedLocation;
  String? filterCode;
  String? filterLocation;
  String? filterCategory;
  bool _isProcessing = false;
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    descriptionController.text = _supplier?.description ?? '';
    email = _supplier?.email ?? '';
    _emailController.text = _supplier?.email ?? '';
    _selectedCategory = _supplier?.category;
    _selectedLocation = _supplier?.location;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SupplierController>(
        builder: (SupplierController controller) {
      return GestureDetector(
        onTap: () => unFocusKeyboard(context),
        child: Scaffold(
          backgroundColor: backgroundcolorinterface,
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(
                widget.supplier != null ? 'Edit Supplier' : 'Add a Supplier'),
            automaticallyImplyLeading: false, // Used for removing back buttoon.
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
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Enter Supplier\'s Business Details',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    controller: _nameController,
                    onChanged: (String val) => name = val,
                    textInputAction: TextInputAction.next,
                    decoration: inputDecoration.copyWith(
                      hintText: '* Enter Business Name',
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    controller: _emailController,
                    onChanged: (String val) => email = val,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    decoration: inputDecoration.copyWith(
                      hintText: '* Enter Business Email',
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    controller: _phoneController,
                    onChanged: (String val) => email = val,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.phone,
                    decoration: inputDecoration.copyWith(
                      hintText: '* Enter Business Telephone',
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    controller: _urlController,
                    onChanged: (String val) => url = val,
                    textInputAction: TextInputAction.next,
                    decoration: inputDecoration.copyWith(
                      hintText: '* Business Website Link',
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16),
                  child: DetectableTextField(
                    controller: descriptionController,
                    detectionRegExp: detectionRegExp(hashtag: false)!,
                    onDetectionTyped: (String text) {},
                    onDetectionFinished: () {},
                    keyboardType: TextInputType.multiline,
                    maxLength: 300,
                    maxLines: 5,
                    basicStyle: Theme.of(context).textTheme.bodyMedium,
                    onChanged: (String val) => description = val,
                    decoration: inputDecoration.copyWith(
                      hintText: '* What do you supply or manufacture?',
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16),
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
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCategory = newValue!;
                        });
                      },
                      items: <String?>[
                        null,
                        'Home, Garden & Outdoors',
                        'Fashion & Beauty',
                        'Sports & Entertainment',
                        'Books & Education',
                        'Jewellery & Timepieces',
                        'Security, Safety & Equipment',
                        'Video Games & Electronics',
                        'Agriculture, Food, Beverage',
                        'Construction & Real Estate',
                        'Vehicle & Transportation',
                        'Business Services & Events',
                        'Other',
                      ].map<DropdownMenuItem<String>>((String? value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: value != null
                              ? Text(value)
                              : Text(
                                  value ?? 'Select Category',
                                  style: bodyText2.copyWith(
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
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
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
                        style: TextStyle(fontSize: 20),
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
                        child: ListTile(
                          leading: _selectedLocation != null
                              ? Text(_selectedLocation!)
                              : Text(
                                  'Location',
                                  style: bodyText2.copyWith(color: hintColor),
                                ),
                          trailing: const Icon(Icons.keyboard_arrow_right),
                        ),
                      );
                    },
                    onChanged: (CountryCode? code) async {
                      setState(() {
                        _selectedLocation = code!.name;
                      });

                      try {
                        SharedPreferences marketplaceCountry =
                            await SharedPreferences.getInstance();
                        await marketplaceCountry.setString(
                            'country', code!.name!);
                        await marketplaceCountry.setString(
                            'currency', code.code!);
                      } catch (e) {}
                    },
                    useSafeArea: false,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                widget.supplier != null
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16),
                        child: GestureDetector(
                          onTap: _pickImages,
                          child: FieldContainer(
                            child: Row(
                              children: <Widget>[
                                SvgPicture.asset('assets/svgs/file.svg'),
                                const SizedBox(width: 16.0),
                                Expanded(
                                  child: Text(
                                    'Add Attachment',
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
                    bottom: 10,
                  ),
                  child: _selectedImages.isNotEmpty
                      ? Wrap(
                          spacing: 10.0,
                          runSpacing: 10.0,
                          children: _selectedImages.map((XFile image) {
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
                                    onTap: () {
                                      _removeImage(
                                          _selectedImages.indexOf(image));
                                    },
                                    child: const CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.red,
                                      child: Icon(Icons.close,
                                          size: 16, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        )
                      : const SizedBox.shrink(),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16),
                  child: MCustomButton(
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
                          _selectedImages.isEmpty) {
                        anError = true;
                      }
                      if (!_isValidURL(url!)) {
                        showSnackbar(
                            message:
                                'Please enter a valid business website link!',
                            error: true,
                            title: 'Error');
                        return;
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
                      } else {
                        await _onChangeForum();
                      }
                      setState(() {
                        _isProcessing = false;
                      });
                    },
                    label: widget.supplier != null
                        ? 'Update Supplier'
                        : 'Add Supplier',
                    isProcessing: _isProcessing,
                    buttonType: ButtonType.elevated,
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 20,
                      top: 20,
                      bottom: 50,
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text.rich(
                          TextSpan(
                            children: <InlineSpan>[
                              const TextSpan(
                                text:
                                    'By clicking on Sell, you confirm that you will abide by the ',
                                style: TextStyle(
                                    fontSize: 12, color: subtextColor),
                              ),
                              TextSpan(
                                text: 'Marketplace Guidelines',
                                style: const TextStyle(
                                  color: Colors.red,
                                  decoration: TextDecoration.underline,
                                  fontSize: 12,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          sellingGuide(context),
                                    );
                                  },
                              ),
                              const TextSpan(
                                text:
                                    ', and declare that the listing does not include any Prohibited Items',
                                style: TextStyle(
                                    fontSize: 12, color: subtextColor),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(images);
      });
    }
  }

  String? removeAfterHyphen(String? input) {
    // Find the index of the hyphen
    int hyphenIndex = input!.indexOf('-');

    // Check if the hyphen exists in the string
    if (hyphenIndex != -1) {
      // Remove everything after the hyphen (including the hyphen itself)
      return input.substring(0, hyphenIndex).trim();
    } else {
      // If no hyphen is found, return the original string

      return input;
    }
  }

  Future<void> _onChangeForum() async {
    if (widget.supplier != null) {
    } else {
      final List<String> imageUrls = await _uploadImages(_selectedImages);
      final ApiResponseModel response =
          await supplierController.addSupplier(<String, dynamic>{
        'category': removeAfterHyphen(_selectedCategory),
        'location': _selectedLocation,
        'description': descriptionController.text,
        'userId': _profileController.myProfile.uid,
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'url': _urlController.text,
        'images': imageUrls,
      });
      if (response.success) {
        Get.back();
      } else {
        showSnackbar(
            message: 'Supplier not added!', title: 'Error!', error: true);
      }
    }
  }

  bool _isValidURL(String url) {
    final RegExp urlPattern = RegExp(
      r'^(https?:\/\/)?([a-zA-Z0-9-]{1,63}\.){1,255}[a-zA-Z]{2,63}(:[0-9]{1,5})?(\/.*)?$',
    );
    return urlPattern.hasMatch(url);
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<List<String>> _uploadImages(List<XFile> images) async {
    final List<String> uploadedImageUrls = <String>[];
    const String uploadUrl =
        'https://businessbosses.com.ng/upload.php'; // Replace with your upload URL

    for (final XFile image in images) {
      final http.MultipartRequest request =
          http.MultipartRequest('POST', Uri.parse(uploadUrl));

      request.files.add(await http.MultipartFile.fromPath('file', image.path));

      final http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final String responseBody = await response.stream.bytesToString();
        final Map<String, dynamic> responseJson = json.decode(responseBody);
        final String imageUrl = responseJson['fileUrl'];
        uploadedImageUrls.add(imageUrl);
      } else {
        throw Exception('Failed to upload image');
      }
    }
    return uploadedImageUrls;
  }
}
