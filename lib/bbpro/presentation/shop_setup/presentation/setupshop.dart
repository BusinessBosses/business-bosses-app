import 'dart:io';

import 'package:business_bosses_v2/bbpro/common/widgets/button.dart';
import 'package:business_bosses_v2/bbpro/common/widgets/customcard.dart';
import 'package:business_bosses_v2/bbpro/common/widgets/edittext.dart';
import 'package:business_bosses_v2/bbpro/common/widgets/multipleedit.dart';
import 'package:business_bosses_v2/bbpro/common/widgets/progresstabbar.dart';
import 'package:business_bosses_v2/bbpro/common/widgets/selectionboxes.dart';
import 'package:business_bosses_v2/bbpro/common/widgets/textfield.dart';
import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setupshop extends StatefulWidget {
  const Setupshop({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SetupshopState createState() => _SetupshopState();
}

class _SetupshopState extends State<Setupshop>
    with SingleTickerProviderStateMixin {
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
  late TabController _tabController;
  final List<String> _tabs = <String>[
    '1. Shop Profile',
    '2. Contact Details',
    '3. Payments'
  ];

  Map<String, bool> selections = <String, bool>{
    'Bank': false,
    'Paypal': false,
    'Wallet': false,
    'Cash': false,
  };

  void _onSelectionChanged(Map<String, bool> newSelections) {
    setState(() {
      // Clear controllers if the corresponding selection is set to false
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
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  void _nextPage() {
    if (_tabController.index < _tabs.length - 1) {
      setState(() {
        _tabController.index += 1;
      });
    }
  }

  void _backPage() {
    setState(() {
      _tabController.index -= 1;
    });
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
                  const Text(
                    'Shop created successfully!',
                    style: TextStyle(
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
                      Get.back(); // Close the dialog
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
        automaticallyImplyLeading: false,
        title: const Text(
          'Set Up Shop',
          style: TextStyle(
            color: proprimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: ProgressTabBar(
                  tabs: _tabs,
                  currentIndex: _tabController.index,
                ),
              ),
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: <Widget>[
                    SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          CustomCard(
                            buttonvisible: true,
                            caption: 'Customize your Shop',
                            subText: 'Add a photo for your shop',
                            buttonText: 'Choose Photo',
                            onPressed: _pickImage,
                            imagePath: _selectedImage?.path ??
                                'assets/images/shopplaceholder.png',
                            iconpath: 'assets/svgs/uploadicon.svg',
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          CustomEditText(
                            caption: 'Shop name',
                            hintText: 'Enter shop name here',
                            controller: nameController,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          CustomEditText(
                            maxLength: 300,
                            caption: 'Project Description',
                            hintText: 'Enter shop description here',
                            controller: descriptionController,
                          )
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          MultipleEditTextWidget(
                            caption: 'Phone number',
                            hintText: '+234 000 000 000',
                            controller: phoneController,
                          ),
                          const SizedBox(height: 15),
                          MultipleEditTextWidget(
                            caption: 'Business Email Address',
                            hintText: 'example@business.com',
                            controller: emailController,
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 7.0),
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
                              pickerBuilder: (BuildContext context,
                                  CountryCode? countryCode) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.circular(radiusValue),
                                  ),
                                  child: CustomTextWidget(
                                    caption: 'Location',
                                    iconName: 'assets/svgs/nexticon.svg',
                                    text: _selectedLocation ??
                                        'Choose Shop Location',
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
                            height: 150,
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          CustomCard(
                            caption: 'Add a Payment Method',
                            subText: 'Choose how clients pay you',
                            buttonText: 'Choose Photo',
                            onPressed: () {},
                            imagePath: 'assets/images/paymentplaceholder.png',
                            iconpath: 'assets/svgs/uploadicon.svg',
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SelectionSection(
                            onSelectionChanged: _onSelectionChanged,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
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
                          const SizedBox(
                            height: 15,
                          ),
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
                          const SizedBox(
                            height: 15,
                          ),
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
                          const SizedBox(
                            height: 15,
                          ),
                          Visibility(
                            visible: selections['Cash'] ?? false,
                            child: CustomEditText(
                              maxLength: 300,
                              caption: 'Enter Cash Payment Details',
                              hintText: 'Enter payment information here',
                              controller: walletController,
                            ),
                          ),
                          const SizedBox(
                            height: 150,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                if (_tabController.index > 0)
                  Expanded(
                    child: ProCustomButton(
                      back: true,
                      text: 'Back',
                      onPressed: () async {
                        _backPage();
                      },
                      icon: const Icon(
                        Icons.navigate_before,
                        size: 20,
                      ),
                    ),
                  ),
                Expanded(
                  child: ProCustomButton(
                    loading: loading,
                    text: _tabController.index == 2 ? 'Complete Setup' : 'Next',
                    onPressed: () async {
                      Map<String, dynamic> selectionsText = <String, dynamic>{
                        'Bank': bankController.text.isEmpty
                            ? null
                            : bankController.text,
                        'Paypal': paypalController.text.isEmpty
                            ? null
                            : paypalController.text,
                        'Wallet': walletController.text.isEmpty
                            ? null
                            : walletController.text,
                        'Cash': cashController.text.isEmpty
                            ? null
                            : cashController.text,
                      };
                      if (_tabController.index == 2) {
                        setState(() {
                          loading = true;
                        });
                        final Map<String, dynamic> data = <String, dynamic>{
                          'userId': profileController.myProfile.uid,
                          'name': nameController.text,
                          'email': emailController.text,
                          'phone': phoneController.text,
                          'description': descriptionController.text,
                          'image': 'shop-image-url',
                          'location': _selectedLocation,
                          'paymentMethods': selectionsText,
                          'details': 'Some additional details about the shop'
                        };
                        bool response = await shopController.addShop(data);
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
                      } else {
                        _nextPage();
                      }
                    },
                    icon: _tabController.index == 2
                        ? Container()
                        : const Icon(
                            Icons.navigate_next,
                            size: 20,
                          ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
