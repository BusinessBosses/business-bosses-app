import 'dart:io';

import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/supplier_model.dart';
import 'package:business_bosses_v2/bbpro/widgets/customcard.dart';
import 'package:business_bosses_v2/bbpro/widgets/textfield.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:business_bosses_v2/bbpro/widgets/button.dart';
import 'package:business_bosses_v2/bbpro/widgets/dropdown.dart';
import 'package:business_bosses_v2/bbpro/widgets/edittext.dart';
import 'package:business_bosses_v2/bbpro/widgets/multipleedit.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddSupplier extends StatefulWidget {
  final Vendor? supplier;
  const AddSupplier({super.key, this.supplier});

  @override
  State<AddSupplier> createState() => _AddSupplierState();
}

class _AddSupplierState extends State<AddSupplier> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController productController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController urlController = TextEditingController();
  final ProfileController profileController = Get.find();
  final ShopController shopController = Get.find();
  String? _selectedLocation;
  String? category;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  File? _selectedImage;
  bool isSubmit = false;
  String? image;
  List<String>? updateImage;

  @override
  void initState() {
    super.initState();
    if (widget.supplier != null) {
      nameController.text = widget.supplier!.name;
      emailController.text = widget.supplier!.email;
      phoneController.text = widget.supplier!.phone;
      urlController.text = widget.supplier!.url;
      descriptionController.text = widget.supplier!.description;
      updateImage = widget.supplier!.images;
      _selectedLocation = widget.supplier!.location;
    }
  }

  void _submitForm() async {
    if (nameController.text.isEmpty) {
      showSnackbar(message: 'Name is required!', error: true);
      return;
    }
    if (emailController.text.isEmpty) {
      showSnackbar(message: 'Email is required', error: true);
      return;
    }
    if (phoneController.text.isEmpty) {
      showSnackbar(message: 'Phone Number is required', error: true);
      return;
    }
    if (descriptionController.text.isEmpty) {
      showSnackbar(message: 'Description is required', error: true);
      return;
    }
    if (category == null) {
      showSnackbar(message: 'Category is required', error: true);
      return;
    }

    if (_selectedLocation == null) {
      showSnackbar(message: 'Location is required', error: true);
      return;
    }
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        isSubmit = true;
      });
      if (_selectedImage != null) {
        dynamic response = await ApiService.uploadFile(_selectedImage!);
        if (response['success']) {
          image = response['fileUrl'];
        } else {
          showSnackbar(
            message: 'Error while creating supplier!',
            error: true,
          );
          setState(() {
            isSubmit = false;
          });
          return;
        }
      }

      // Creating JSON to be sent
      Map<String, dynamic> supplierData = <String, dynamic>{
        'userId': profileController.myProfile.uid,
        'name': nameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'description': descriptionController.text,
        'url': urlController.text,
        'category': category,
        'images': <String?>[image],
        'location': _selectedLocation,
      };

      try {
        bool success = await shopController.addSupplier(supplierData);
        if (success) {
          showSnackbar(message: 'Supplier Added Successfully!');
          await Future.delayed(
              const Duration(seconds: 1)); // Optional delay for visibility
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
        } else {
          showSnackbar(message: 'Error Adding Supplier!', error: true);
        }
      } catch (e) {
        showSnackbar(message: 'An error occurred: $e', error: true);
      } finally {
        setState(() {
          isSubmit = false;
        });
      }
      // You can now send `supplierData` to your API endpoint
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: probackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Add Supplier',
          style: TextStyle(
            color: proprimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
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
      body: Stack(
        children: <Widget>[
          SizedBox(
            height: double.infinity,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 15),
                    CustomCard(
                      buttonvisible: true,
                      caption: 'Supplier Information',
                      subText: 'Add a photo for your supplier',
                      buttonText: 'Choose Photo',
                      onPressed: _pickImage,
                      imagePath: _selectedImage?.path ??
                          'assets/images/shopplaceholder.png',
                      iconpath: 'assets/svgs/uploadicon.svg',
                    ),
                    const SizedBox(height: 15),
                    CustomEditText(
                      caption: 'Supplier\'s Name',
                      hintText: 'Enter name here',
                      controller: nameController,
                    ),
                    // const SizedBox(height: 15),
                    // CustomEditText(
                    //   caption: 'Supplied Products',
                    //   hintText: 'Eg. Dresses, Bags, etc',
                    //   controller: productController,
                    // ),
                    const SizedBox(height: 15),
                    CustomEditText(
                      maxLength: 300,
                      caption: 'Description',
                      hintText: 'Add a description here',
                      controller: descriptionController,
                    ),
                    const SizedBox(height: 15),
                    CustomDropdownWidget(
                      caption: 'Select Industry',
                      items: const <String>['test1', 'test2', 'test3'],
                      iconName: 'assets/svgs/dropdown.svg',
                      onChanged: (String? value) => setState(() {
                        category = value!;
                      }),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: CountryListPick(
                        appBar: AppBar(
                          leading: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon:
                                SvgPicture.asset('assets/svgs/backbutton.svg'),
                          ),
                          centerTitle: true,
                          title: const Text(
                            'Select Location',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        initialSelection: '',
                        pickerBuilder:
                            (BuildContext context, CountryCode? countryCode) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(radiusValue),
                            ),
                            child: CustomTextWidget(
                              caption: 'Location',
                              iconName: 'assets/svgs/nexticon.svg',
                              text: _selectedLocation ?? 'Choose Shop Location',
                            ),
                          );
                        },
                        onChanged: (CountryCode? code) async {
                          setState(() {
                            _selectedLocation = code!.name;
                          });
                        },
                        useSafeArea: false,
                      ),
                    ),
                    const SizedBox(height: 15),
                    CustomEditText(
                      caption: 'Website',
                      hintText: 'Eg. https://www.supplier.com',
                      controller: urlController,
                    ),
                    const SizedBox(height: 15),
                    CustomEditText(
                      caption: 'Email',
                      hintText: 'example@business.com',
                      controller: emailController,
                    ),
                    const SizedBox(height: 15),
                    CustomEditText(
                      caption: 'Phone number',
                      hintText: '+234 000 000 000',
                      controller: phoneController,
                    ),
                    const SizedBox(height: 15),
                    const SizedBox(height: 150),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ProCustomButton(
                loading: isSubmit,
                text: 'Save',
                onPressed: () async {
                  _submitForm();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }
}
