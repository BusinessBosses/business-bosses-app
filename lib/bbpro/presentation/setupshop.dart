import 'dart:io';

import 'package:business_bosses_v2/bbpro/models/shop_model.dart';
import 'package:business_bosses_v2/bbpro/widgets/button.dart';
import 'package:business_bosses_v2/bbpro/widgets/customcard.dart';
import 'package:business_bosses_v2/bbpro/widgets/edittext.dart';
import 'package:business_bosses_v2/bbpro/widgets/selectionboxes.dart';
import 'package:business_bosses_v2/bbpro/widgets/textfield.dart';
import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/presentation/bottomnavscreen.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setupshop extends StatefulWidget {
  final Shop? shop;
  const Setupshop({super.key, this.shop});

  @override
  // ignore: library_private_types_in_public_api
  _SetupshopState createState() => _SetupshopState();
}

class _SetupshopState extends State<Setupshop> {
  final ShopController shopController = Get.put(ShopController());
  final ProfileController profileController = Get.find();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController bankController = TextEditingController();
  final TextEditingController paypalController = TextEditingController();
  final TextEditingController walletController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cashController = TextEditingController();
  String? _selectedLocation;
  File? _selectedImage;
  bool loading = false;
  String? image;

  Map<String, bool> selections = <String, bool>{
    'Bank': false,
    'Paypal': false,
    'Wallet': false,
    'Cash': false,
  };

  void _onSelectionChanged(Map<String, bool> newSelections) {
    setState(() {
      if (newSelections['Bank'] == false) {
        bankController.clear();
      }
      if (newSelections['Paypal'] == false) {
        paypalController.clear();
      }
      if (newSelections['Wallet'] == false) {
        walletController.clear();
      }
      if (newSelections['Cash'] == false) {
        cashController.clear();
      }
      selections = newSelections;
    });
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

  @override
  void initState() {
    super.initState();
    if (widget.shop != null) {
      nameController.text = widget.shop!.name;
      descriptionController.text = widget.shop!.description;
      phoneController.text = widget.shop!.phone;
      emailController.text = widget.shop!.email;
      _selectedLocation = widget.shop!.location;
      image = widget.shop!.image;
      _populatePaymentMethods(widget.shop!.payments);
    } else {
      shopController.initShop().then((bool value) {
        if (value) {
          Get.to(() => const Bottomnavscreen());
        }
      });
    }
  }

  bool _validateForm() {
    if (_selectedImage == null && image == null) {
      showSnackbar(message: 'Photo is required', error: true);
      return false;
    }
    if (nameController.text.isEmpty) {
      showSnackbar(message: 'Shop name is required', error: true);
      return false;
    }
    if (phoneController.text.isEmpty) {
      showSnackbar(message: 'Phone number is required', error: true);
      return false;
    }
    if (emailController.text.isEmpty || !emailController.text.contains('@')) {
      showSnackbar(message: 'Valid email address is required', error: true);
      return false;
    }
    if (_selectedLocation == null) {
      showSnackbar(message: 'Location is required', error: true);
      return false;
    }
    if (selections['Bank'] == true && bankController.text.isEmpty) {
      showSnackbar(message: 'Bank payment details are required', error: true);
      return false;
    }
    if (selections['Paypal'] == true && paypalController.text.isEmpty) {
      showSnackbar(message: 'Paypal payment details are required', error: true);
      return false;
    }
    if (selections['Wallet'] == true && walletController.text.isEmpty) {
      showSnackbar(message: 'Wallet payment details are required', error: true);
      return false;
    }
    if (selections['Cash'] == true && cashController.text.isEmpty) {
      showSnackbar(message: 'Cash payment details are required', error: true);
      return false;
    }
    return true;
  }

  // Helper to populate payment method details based on shop data
  void _populatePaymentMethods(List<dynamic> paymentMethods) {
    for (Map<String, dynamic> method in paymentMethods) {
      if (method['paymentMethod'] == 'Bank') {
        selections['Bank'] = true;
        bankController.text = method['details'];
      } else if (method['paymentMethod'] == 'Paypal') {
        selections['Paypal'] = true;
        paypalController.text = method['details'];
      } else if (method['paymentMethod'] == 'Wallet') {
        selections['Wallet'] = true;
        walletController.text = method['details'];
      } else if (method['paymentMethod'] == 'Cash') {
        selections['Cash'] = true;
      }
    }
  }

  void successDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(height: 20),
                  Text(
                    widget.shop != null
                        ? 'Shop updated successfully!'
                        : 'Shop created successfully!',
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 50,
                  ),
                  const SizedBox(height: 20),
                  ProCustomButton(
                    onPressed: () {
                      Get.to(() => const Bottomnavscreen());
                    },
                    text: 'My Dashboard',
                    icon: const Icon(
                      Icons.navigate_next,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: probackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: widget.shop != null ? true : false,
        title: Text(
          widget.shop != null ? 'Edit Shop' : 'Set Up Shop',
          style: const TextStyle(
            color: proprimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Obx(
        () => shopController.loading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Column(
                    children: <Widget>[
                      CustomCard(
                        buttonvisible: true,
                        caption: 'Customize your Shop',
                        subText: 'Add a photo for your shop',
                        buttonText: 'Choose Photo',
                        onPressed: _pickImage,
                        imagePath: _selectedImage != null
                            ? _selectedImage!.path
                            : widget.shop != null && widget.shop!.image != null
                                ? widget.shop!.image!
                                : 'assets/images/shopplaceholder.png',
                        iconpath: 'assets/svgs/uploadicon.svg',
                      ),
                      const SizedBox(height: 15),
                      CustomEditText(
                        caption: 'Shop name *',
                        hintText: 'Enter shop name here',
                        controller: nameController,
                      ),
                      const SizedBox(height: 15),
                      CustomEditText(
                        optionalText: RichText(
                          text: const TextSpan(
                            children: <InlineSpan>[
                              TextSpan(
                                text: '(Description)',
                                style: TextStyle(
                                  color: subtextColor,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        maxLength: 300,
                        caption: 'Shop Message *',
                        hintText: 'Enter shop description here',
                        controller: descriptionController,
                      ),
                      const SizedBox(height: 15),
                      CustomEditText(
                        optionalText: RichText(
                          text: const TextSpan(
                            children: <InlineSpan>[
                              TextSpan(
                                text: '(Optional)',
                                style: TextStyle(
                                  color: subtextColor,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        hintText: '+234 000 000 000',
                        controller: phoneController,
                        caption: 'Phone Number',
                      ),
                      const SizedBox(height: 15),
                      CustomEditText(
                        optionalText: RichText(
                          text: const TextSpan(
                            children: <InlineSpan>[
                              TextSpan(
                                text: '(Optional)',
                                style: TextStyle(
                                  color: subtextColor,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        caption: 'Business Email Address',
                        hintText: 'example@business.com',
                        controller: emailController,
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
                              icon: SvgPicture.asset(
                                  'assets/svgs/backbutton.svg'),
                            ),
                            centerTitle: true,
                            title: const Text(
                              'Select Location',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          initialSelection: _selectedLocation,
                          pickerBuilder:
                              (BuildContext context, CountryCode? countryCode) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(radiusValue),
                              ),
                              child: CustomTextWidget(
                                caption: 'Location',
                                iconName: 'assets/svgs/nexticon.svg',
                                text:
                                    _selectedLocation ?? 'Choose Shop Location',
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
                      const SizedBox(height: 15),
                      CustomCard(
                        caption: 'Add a Payment Method',
                        subText: 'Choose how clients pay you',
                        buttonText: 'Choose Photo',
                        onPressed: () {},
                        imagePath: 'assets/images/paymentplaceholder.png',
                        iconpath: 'assets/svgs/uploadicon.svg',
                      ),
                      const SizedBox(height: 15),
                      SelectionSection(
                        onSelectionChanged: _onSelectionChanged,
                      ),
                      const SizedBox(height: 15),
                      Visibility(
                        visible: selections['Bank'] ?? false,
                        child: CustomEditText(
                          maxLength: 300,
                          caption:
                              'Enter Bank Details - FULL NAME: COUNTRY: BANK NAME: ACCOUNT NUMBER:',
                          hintText: 'Enter account information here',
                          controller: bankController,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Visibility(
                        visible: selections['Paypal'] ?? false,
                        child: CustomEditText(
                          maxLength: 300,
                          caption:
                              'Enter Paypal Details - FULL NAME: PAYPAL EMAIL ADDRESS:',
                          hintText: 'Enter account information here',
                          controller: paypalController,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Visibility(
                        visible: selections['Wallet'] ?? false,
                        child: CustomEditText(
                          maxLength: 300,
                          caption:
                              'Enter Wallet Details - FULL NAME: WALLET EMAIL ADDRESS: or WALLET NUMBER',
                          hintText: 'Enter account information here',
                          controller: walletController,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Visibility(
                        visible: selections['Cash'] ?? false,
                        child: CustomEditText(
                          maxLength: 300,
                          caption: 'Enter Cash Payment Details',
                          hintText: 'Enter payment information here',
                          controller: cashController,
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ProCustomButton(
                          loading: loading,
                          onPressed: submitForm,
                          text: widget.shop != null
                              ? 'Save Changes'
                              : 'Complete Setup',
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  void submitForm() async {
    if (!_validateForm()) return;

    setState(() {
      loading = true;
    });

    List<Map<String, dynamic>> paymentMethods = <Map<String, dynamic>>[];

    // Add payment methods to the array
    if (selections['Bank'] == true && bankController.text.isNotEmpty) {
      paymentMethods.add(<String, dynamic>{
        'paymentMethod': 'Bank',
        'details': bankController.text,
      });
    }
    if (selections['Paypal'] == true && paypalController.text.isNotEmpty) {
      paymentMethods.add(<String, dynamic>{
        'paymentMethod': 'Paypal',
        'details': paypalController.text,
      });
    }
    if (selections['Wallet'] == true && walletController.text.isNotEmpty) {
      paymentMethods.add(<String, dynamic>{
        'paymentMethod': 'Wallet',
        'details': walletController.text,
      });
    }
    if (selections['Cash'] == true && cashController.text.isNotEmpty) {
      paymentMethods.add(<String, dynamic>{
        'paymentMethod': 'Cash',
        'details': cashController.text,
      });
    }

    if (_selectedImage != null) {
      dynamic response = await ApiService.uploadFile(_selectedImage!);
      if (response['success']) {
        image = response['fileUrl'];
      } else {
        showSnackbar(
          message: 'Error while adding shop!',
          error: true,
        );
        setState(() {
          loading = false;
        });
        return;
      }
    }

    final Map<String, dynamic> data = <String, dynamic>{
      'userId': profileController.myProfile.uid,
      'name': nameController.text,
      'email': emailController.text,
      'phone': phoneController.text,
      'description': descriptionController.text,
      'image': image,
      'location': _selectedLocation,
      'paymentMethods': paymentMethods,
      'details': 'Some additional details about the shop'
    };

    final Map<String, dynamic> dataUpdate = <String, dynamic>{
      'name': nameController.text,
      'email': emailController.text,
      'phone': phoneController.text,
      'description': descriptionController.text,
      'image': image,
      'location': _selectedLocation,
      'paymentMethods': paymentMethods,
    };
    bool response = false;
    if (widget.shop != null) {
      response = await shopController.updateShop(widget.shop!.id, dataUpdate);
    } else {
      response = await shopController.addShop(data);
    }
    if (response) {
      // ignore: use_build_context_synchronously
      successDialog(context);
    } else {
      showSnackbar(
        message: 'Error while adding shop!',
        error: true,
      );
    }
    setState(() {
      loading = false;
    });
  }
}
