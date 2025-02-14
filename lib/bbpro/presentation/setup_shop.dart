import 'dart:convert';
import 'dart:io';

import 'package:business_bosses_v2/bbpro/models/shop_model.dart';
import 'package:business_bosses_v2/bbpro/widgets/button.dart';
import 'package:business_bosses_v2/bbpro/widgets/custom_card.dart';
import 'package:business_bosses_v2/bbpro/widgets/dropdown.dart';
import 'package:business_bosses_v2/bbpro/widgets/edit_text.dart';
import 'package:business_bosses_v2/bbpro/widgets/selectionboxes.dart';
import 'package:business_bosses_v2/bbpro/widgets/textfield.dart';
import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/features/home/home_screen.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/currency.dart';
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
  final bool backToHome;
  const Setupshop({
    super.key,
    this.shop,
    this.backToHome = false,
  });

  @override
  // ignore: library_private_types_in_public_api
  _SetupshopState createState() => _SetupshopState();
}

class _SetupshopState extends State<Setupshop> with TickerProviderStateMixin {
  final ShopController shopController = Get.find();
  // ignore: unused_field
  late TabController _viewController;
  final ProfileController profileController = Get.find();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController bankController = TextEditingController();
  final TextEditingController paypalController = TextEditingController();
  final TextEditingController walletController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final TextEditingController igslController = TextEditingController();
  final TextEditingController fbslController = TextEditingController();
  final TextEditingController lslController = TextEditingController();
  final TextEditingController xslController = TextEditingController();
  final TextEditingController cslController = TextEditingController();

  final TextEditingController bankNameController = TextEditingController();
  final TextEditingController bankCountryController = TextEditingController();
  final TextEditingController bankAccountController = TextEditingController();
  final TextEditingController bankFullNameController = TextEditingController();

  final TextEditingController paypalNameController = TextEditingController();
  final TextEditingController paypalEmailController = TextEditingController();

  final TextEditingController walletNameController = TextEditingController();
  final TextEditingController walletDetailsController = TextEditingController();

  String? _selectedLocation;
  File? _selectedImage;
  bool loading = true;
  bool isSubmit = false;
  String? image;
  String? imageType;

  Map<String, bool> selections = <String, bool>{
    'Bank': false,
    'Paypal': false,
    'Wallet': false,
    'Cash': false,
  };

  Map<String, bool> selectedOptions = <String, bool>{
    'Bank': false,
    'Paypal': false,
    'Wallet': false,
    'Cash': false
  };

  Map<String, dynamic> bankDetails = <String, dynamic>{};
  Map<String, dynamic> paypalDetails = <String, dynamic>{};

  Map<String, dynamic> walletDetails = <String, dynamic>{};

  // void _onSelectionChanged(Map<String, bool> newSelections) {
  //   setState(() {
  //     selections = newSelections;
  //     selectedOptions = Map.from(newSelections);
  //     if (newSelections['Bank'] == false) {
  //       bankController.clear();
  //     }
  //     if (newSelections['Paypal'] == false) {
  //       paypalController.clear();
  //     }
  //     if (newSelections['Wallet'] == false) {
  //       walletController.clear();
  //     }
  //     if (newSelections['Cash'] == false) {
  //       cashController.clear();
  //     }
  //   });
  // }

  void _showBottomSheet(BuildContext context, Function callback) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: ListView(
                children: <Widget>[
                  const SizedBox(height: 15),
                  SelectionSection(
                    onSelectionChanged: (Map<String, bool> newSelections) {
                      setModalState(() {
                        selections = newSelections;
                        selectedOptions = Map<String, bool>.from(newSelections);
                        if (newSelections['Bank'] == false) {
                          bankNameController.clear();
                          bankCountryController.clear();
                          bankAccountController.clear();
                          bankFullNameController.clear();
                        }
                        if (newSelections['Paypal'] == false) {
                          paypalNameController.clear();
                          paypalEmailController.clear();
                        }
                        if (newSelections['Wallet'] == false) {
                          walletNameController.clear();
                          walletDetailsController.clear();
                        }
                      });
                    },
                    options: const <String>['Bank', 'Paypal', 'Wallet', 'Cash'],
                    selectedOptions: selectedOptions,
                  ),
                  const SizedBox(height: 15),
                  Visibility(
                    visible: selections['Bank'] ?? false,
                    child: CustomEditText(
                      maxLength: 300,
                      ispaymentfield: true,
                      caption: 'Enter Bank Details',
                      hintText: 'Enter account information here',
                      controller: bankController,
                      pmh1: 'Full Name',
                      pmh2: 'Country',
                      pmh3: 'Bank Name',
                      pmh4: 'Account Number',
                      pm1controller: bankFullNameController,
                      pm2controller: bankCountryController,
                      pm3controller: bankNameController,
                      pm4controller: bankAccountController,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Visibility(
                    visible: selections['Paypal'] ?? false,
                    child: CustomEditText(
                      ispaymentfield: true,
                      maxLength: 300,
                      caption: 'Enter Paypal Details',
                      hintText: 'Enter account information here',
                      controller: paypalController,
                      pmh1: 'Full Name',
                      pmh2: 'Paypal Email Address',
                      pm1controller: paypalNameController,
                      pm2controller: paypalEmailController,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Visibility(
                    visible: selections['Wallet'] ?? false,
                    child: CustomEditText(
                      ispaymentfield: true,
                      maxLength: 300,
                      caption: 'Enter Wallet Details',
                      hintText: 'Enter account information here',
                      controller: walletController,
                      pmh1: 'Full Name',
                      pmh2: 'Wallet Email Address or Wallet Number',
                      pm1controller: walletNameController,
                      pm2controller: walletDetailsController,
                    ),
                  ),
                  const SizedBox(height: 15),
                  ProCustomButton(
                      text: 'Done',
                      onPressed: () {
                        Get.back();
                      }),
                  // Visibility(
                  //   visible: selections['Cash'] ?? false,
                  //   child: CustomEditText(
                  //     maxLength: 300,
                  //     caption: 'Enter Cash Payment Details',
                  //     hintText: 'Enter payment information here',
                  //     controller: cashController,
                  //   ),
                  // ),
                ],
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      callback(); // Call the callback after the BottomSheet is closed
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
    _viewController =
        TabController(length: widget.shop != null ? 2 : 1, vsync: this);
    if (widget.shop != null) {
      nameController.text = widget.shop!.name;
      descriptionController.text = widget.shop!.description;
      phoneController.text = widget.shop!.phone;
      emailController.text = widget.shop!.email;
      _selectedLocation = widget.shop!.location;
      image = widget.shop!.image;
      imageType = capitalizeFirstLetter(widget.shop!.imageType!);

      fbslController.text = widget.shop!.facebook ?? '';
      igslController.text = widget.shop!.instagram ?? '';
      lslController.text = widget.shop!.linkedIn ?? '';
      xslController.text = widget.shop!.twitter ?? '';
      cslController.text = widget.shop!.url ?? '';
      _populatePaymentMethods(widget.shop!.payments);
    } else {
      shopController.initShopData().then((bool value) {
        if (value) {
          Navigator.pop(context);
        } else {
          if (mounted) {
            loading = false;
            shopController.loading(false);
            setState(() {});
          }
        }
      });
    }
  }

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  bool _validateForm() {
    // if (_selectedImage == null && image == null) {
    //   showSnackbar(message: 'Photo is required', error: true);
    //   return false;
    // }
    if (nameController.text.isEmpty) {
      showSnackbar(message: 'Shop name is required', error: true);
      return false;
    }
    // if (phoneController.text.isEmpty) {
    //   showSnackbar(message: 'Phone number is required', error: true);
    //   return false;
    // }
    // if (emailController.text.isEmpty || !emailController.text.contains('@')) {
    //   showSnackbar(message: 'Valid email address is required', error: true);
    //   return false;
    // }
    if (_selectedLocation == null) {
      showSnackbar(message: 'Location is required', error: true);
      return false;
    }
    if (selections['Bank'] == true && bankDetails.isEmpty) {
      showSnackbar(message: 'Bank payment details are required', error: true);
      return false;
    }
    if (selections['Paypal'] == true && paypalDetails.isEmpty) {
      showSnackbar(message: 'Paypal payment details are required', error: true);
      return false;
    }
    if (selections['Wallet'] == true && walletDetails.isEmpty) {
      showSnackbar(message: 'Wallet payment details are required', error: true);
      return false;
    }
    // if (selections['Cash'] == true && cashController.text.isEmpty) {
    //   showSnackbar(message: 'Cash payment details are required', error: true);
    //   return false;
    // }
    return true;
  }

  // Helper to populate payment method details based on shop data
  void _populatePaymentMethods(List<dynamic> paymentMethods) {
    for (Map<String, dynamic> method in paymentMethods) {
      dynamic methodDetails;
      if (method['paymentMethod'] != 'Cash') {
        methodDetails = jsonDecode(method['details']);
      }
      if (method['paymentMethod'] == 'Bank') {
        selections['Bank'] = true;
        selectedOptions['Bank'] = true;
        bankFullNameController.text = methodDetails['Full Name'];
        bankAccountController.text = methodDetails['Account Number'];
        bankCountryController.text = methodDetails['Country'];
        bankNameController.text = methodDetails['Bank Name'];
        bankDetails.addAll(<String, dynamic>{
          'Full Name': bankFullNameController.text,
          'Country': bankCountryController.text,
          'Bank Name': bankNameController.text,
          'Account Number': bankAccountController.text
        });
      }
      if (method['paymentMethod'] == 'Paypal') {
        selections['Paypal'] = true;
        selectedOptions['Paypal'] = true;
        paypalEmailController.text = methodDetails['Paypal Email Address'];
        paypalNameController.text = methodDetails['Full Name'];
        paypalDetails.addAll(<String, dynamic>{
          'Full Name': paypalNameController.text,
          'Paypal Email Address': paypalEmailController.text
        });
      }
      if (method['paymentMethod'] == 'Wallet') {
        selections['Wallet'] = true;
        selectedOptions['Wallet'] = true;
        walletDetailsController.text =
            methodDetails['Wallet Email Address or Wallet Number'];
        walletNameController.text = methodDetails['Full Name'];
        walletDetails.addAll(<String, dynamic>{
          'Full Name': walletNameController.text,
          'Wallet Email Address or Wallet Number': walletDetailsController.text
        });
      }
      if (method['paymentMethod'] == 'Cash') {
        selections['Cash'] = true;
        selectedOptions['Cash'] = true;
      }
    }
    setState(() {});
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
                        ? 'Biz-Center updated successfully!'
                        : 'Biz-Center created successfully!',
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
                      Get.back();
                      Get.back();
                      setState(() {});
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
        // backgroundColor: probackgroundColor,
        leading: widget.shop != null || widget.backToHome
            ? IconButton(
                onPressed: () {
                  if (!widget.backToHome) {
                    Navigator.pop(context);
                  } else {
                    Get.off(() => const HomeScreen());
                  }
                },
                icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
              )
            : null,
        automaticallyImplyLeading: widget.shop != null ? true : false,
        title: Text(
          widget.shop != null ? 'Edit' : 'Set Up Shop',
          style: const TextStyle(
            color: proprimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        // bottom: widget.shop != null
        //     ? PreferredSize(
        //         preferredSize: const Size.fromHeight(30),
        //         child: CupertinoSlidingSegmentedControl<int>(
        //           groupValue: _viewController.index,
        //           children: const <int, Widget>{
        //             0: Padding(
        //               padding:
        //                   EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        //               child: Text('Shop', style: TextStyle(fontSize: 14)),
        //             ),
        //             1: Padding(
        //               padding:
        //                   EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        //               child: Text(' Profile', style: TextStyle(fontSize: 14)),
        //             ),
        //           },
        //           onValueChanged: (int? value) {
        //             if (value != null) {
        //               setState(() {
        //                 _viewController.index = value;
        //               });
        //             }
        //           },
        //         ),
        //       )
        //     : null,
      ),
      body: widget.shop == null && loading
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
                      caption: 'Customise your Biz-Center',
                      subText: 'Add a photo for your biz-center',
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
                    CustomDropdownWidget(
                      caption: 'Image Type',
                      initialValue: imageType,
                      items: const <String>['Circle', 'Banner'],
                      iconName: 'assets/svgs/dropdown.svg',
                      onChanged: (String? value) => setState(() {
                        imageType = value!.toLowerCase();
                      }),
                    ),
                    const SizedBox(height: 15),
                    CustomEditText(
                      maxLength: 30,
                      caption: 'Biz-Center name *',
                      hintText: 'Enter biz-center name here',
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
                      caption: 'Biz-Center Message *',
                      hintText: 'Enter biz-center description here',
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
                      hintText: '+448908654321',
                      controller: phoneController,
                      caption: 'Phone Number',
                      maxLength: 30,
                    ),
                    const SizedBox(height: 15),
                    CustomEditText(
                      maxLength: 50,
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
                    const SizedBox(height: 8),
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
                              iconName: 'assets/svgs/nexticon.svg',
                              text: _selectedLocation ??
                                  'Choose Biz-Center Location',
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
                          } catch (e) {
                            //
                          }
                        },
                        useSafeArea: false,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        _showBottomSheet(context, () {
                          bankDetails.addAll(<String, dynamic>{
                            'Full Name': bankFullNameController.text,
                            'Country': bankCountryController.text,
                            'Bank Name': bankNameController.text,
                            'Account Number': bankAccountController.text
                          });
                          paypalDetails.addAll(<String, dynamic>{
                            'Full Name': paypalNameController.text,
                            'Paypal Email Address': paypalEmailController.text
                          });
                          walletDetails.addAll(<String, dynamic>{
                            'Full Name': walletNameController.text,
                            'Wallet Email Address or Wallet Number':
                                walletDetailsController.text
                          });
                          setState(() {});
                          setState(() {});
                        });
                      },
                      child: CustomTextWidget(
                        padding: 15,
                        textpadding: 15,
                        caption: 'Select Payment Method *',
                        iconName: 'assets/svgs/dropdown.svg',
                        text: selections.entries
                            .where((MapEntry<String, bool> entry) =>
                                entry.value == true)
                            .map((MapEntry<String, bool> entry) => entry.key)
                            .toList()
                            .join(', '),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomEditText(
                      maxLength: 300,
                      ispaymentfield: true,
                      issl: true,
                      caption: 'Social Links',
                      hintText: '',
                      controller: bankController,
                      pmh1: 'Enter Instagram URL',
                      pmh2: 'Enter Facebook URL',
                      pmh3: 'Enter linkedIn URL',
                      pmh4: 'Enter X URL',
                      pmh5: 'Enter Custom URL',
                      pm1controller: igslController,
                      pm2controller: fbslController,
                      pm3controller: lslController,
                      pm4controller: xslController,
                      pm5controller: cslController,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ProCustomButton(
                        loading: isSubmit,
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
      //   if (widget.shop != null)
      //     UpdateProfileScreen(
      //       isShopedit: true,
      //       user: widget.shop?.user,
      //     )
      // ]),
    );
  }

  void submitForm() async {
    if (!_validateForm()) return;

    setState(() {
      isSubmit = true;
    });

    List<Map<String, dynamic>> paymentMethods = <Map<String, dynamic>>[];

    // Add payment methods to the array

    if (selections['Bank'] == true && bankDetails.isNotEmpty) {
      paymentMethods.add(<String, dynamic>{
        'paymentMethod': 'Bank',
        'details': jsonEncode(bankDetails),
      });
    }
    if (selections['Paypal'] == true && paypalDetails.isNotEmpty) {
      paymentMethods.add(<String, dynamic>{
        'paymentMethod': 'Paypal',
        'details': jsonEncode(paypalDetails),
      });
    }
    if (selections['Wallet'] == true && walletDetails.isNotEmpty) {
      paymentMethods.add(<String, dynamic>{
        'paymentMethod': 'Wallet',
        'details': jsonEncode(walletDetails),
      });
    }
    if (selections['Cash'] == true) {
      paymentMethods.add(<String, dynamic>{
        'paymentMethod': 'Cash',
        'details': 'some details',
      });
    }

    if (paymentMethods.isEmpty) {
      showSnackbar(
        message: 'Please select at least one payment method!',
        error: true,
      );
      setState(() {
        isSubmit = false;
      });
      return;
    }

    if (_selectedImage != null) {
      dynamic response = await ApiService.uploadFile(_selectedImage!);
      if (response['success']) {
        image = response['fileUrl'];
      } else {
        showSnackbar(
          message: 'Error while adding shop image!',
          error: true,
        );
        setState(() {
          isSubmit = false;
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
      'currency': _selectedLocation != null
          ? '${currencyValues[_selectedLocation.toString()]}'
          : 'USD',
      'details': 'Some additional details about the shop',
      'instagram': igslController.text,
      'twitter': xslController.text,
      'facebook': fbslController.text,
      'linkedIn': lslController.text,
      'url': cslController.text,
      'imageType': imageType,
    };

    final Map<String, dynamic> dataUpdate = <String, dynamic>{
      'name': nameController.text,
      'email': emailController.text,
      'phone': phoneController.text,
      'description': descriptionController.text,
      'image': image,
      'location': _selectedLocation,
      'currency': _selectedLocation != null
          ? '${currencyValues[_selectedLocation.toString()]}'
          : 'USD',
      'paymentMethods': paymentMethods,
      'instagram': igslController.text,
      'twitter': xslController.text,
      'facebook': fbslController.text,
      'linkedIn': lslController.text,
      'url': cslController.text,
      'imageType': imageType,
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
        title: 'Error while adding shop!',
        message: shopController.error!.message,
        error: true,
      );
    }
    setState(() {
      isSubmit = false;
    });
  }
}
