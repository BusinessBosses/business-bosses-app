import 'package:business_bosses_v2/bbpro/common/widgets/button.dart';
import 'package:business_bosses_v2/bbpro/common/widgets/customcard.dart';
import 'package:business_bosses_v2/bbpro/common/widgets/dropdown.dart';
import 'package:business_bosses_v2/bbpro/common/widgets/edittext.dart';
import 'package:business_bosses_v2/bbpro/common/widgets/multipleedit.dart';
import 'package:business_bosses_v2/bbpro/common/widgets/progresstabbar.dart';
import 'package:business_bosses_v2/bbpro/common/widgets/selectionboxes.dart';
import 'package:business_bosses_v2/bbpro/common/widgets/textfield.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setupshop extends StatefulWidget {
  @override
  _SetupshopState createState() => _SetupshopState();
}

class _SetupshopState extends State<Setupshop>
    with SingleTickerProviderStateMixin {
  String? _selectedLocation;
  late TabController _tabController;
  final List<String> _tabs = [
    '1. Shop Profile',
    '2. Contact Details',
    '3. Payments'
  ];

  Map<String, bool> selections = {
    'Bank': false,
    'Paypal': false,
    'Wallet': false,
    'Cash': false,
  };

  void _onSelectionChanged(Map<String, bool> newSelections) {
    setState(() {
      selections = newSelections;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: probackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Set Up Shop',
          style: TextStyle(color: proprimaryColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ProgressTabBar(
                tabs: _tabs,
                currentIndex: _tabController.index,
              ),
            ),
            Expanded(
              child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          CustomCard(
                            buttonvisible: true,
                            caption: 'Customize your Shop',
                            subText: 'Add a photo for your shop',
                            buttonText: 'Choose Photo',
                            onPressed: () {},
                            imagePath: 'assets/images/shopplaceholder.png',
                            iconpath: 'assets/svgs/uploadicon.svg',
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          CustomEditText(
                              caption: 'Shop name',
                              hintText: 'Enter shop name here'),
                          const SizedBox(
                            height: 15,
                          ),
                          CustomEditText(
                              maxLength: 300,
                              caption: 'Project Description',
                              hintText: 'Enter shop description here')
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                        child: Column(children: [
                      MultipleEditTextWidget(
                        caption: 'Phone number',
                        hintText: '+234 000 000 000',
                      ),
                      const SizedBox(height: 15),
                      MultipleEditTextWidget(
                        caption: 'Business Email Address',
                        hintText: 'example@business.com',
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 7.0),
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
                              style: TextStyle(fontSize: 20),
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
                      SizedBox(
                        height: 150,
                      ),
                    ])),
                    SingleChildScrollView(
                      child: Column(
                        children: [
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
                            ),
                          ),
                          const SizedBox(
                            height: 150,
                          ),
                        ],
                      ),
                    ),
                  ]),
            ),
          ],
        ),
        Positioned(
            left: 0,
            right: 0,
            bottom: 30,
            child: ProCustomButton(
              text: _tabController.index == 2 ? 'Complete Setup' : 'Next',
              onPressed: () {
                _nextPage();
              },
              icon: _tabController.index == 2
                  ? Container()
                  : Icon(
                      Icons.navigate_next,
                      size: 20,
                    ),
            ))
      ]),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
