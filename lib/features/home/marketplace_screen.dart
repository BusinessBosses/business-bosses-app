import 'package:business_bosses_v2/common/widgets/text_widget.dart';
import 'package:business_bosses_v2/features/home/widgets/bottom_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/models/user_model.dart';
import '../../common/widgets/safety_model.dart';
import '../../services/api_service.dart';
import '../../utils/constants/constants.dart';
import '../../utils/size_config.dart';
import '../../utils/theme/theme.dart';
import '../marketplace/controllers/market_controller.dart';
import '../marketplace/models/market_model.dart';
import '../marketplace/presentation/market_members.dart';
import '../marketplace/presentation/sell_screen.dart';
import '../marketplace/widgets/marketplace_item.dart';
import '../moreinfoscreens/bossuppartner.dart';
import '../profile/controller/profile_controller.dart';
import 'controller/home_controller.dart';

/// Buying and Selling screen
class MarketplaceScreen extends StatefulWidget {
  /// Mrketplace constructor
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  final ProfileController _profileController = Get.find();
  final MarketController _marketController = Get.find();
  final HomeController hmeController = Get.find();
  String? _selectedCategory;
  String? _selectedLocation;
  final bool _isSearching = false;
  String? filterCode;
  String? filterLocation;
  String? filterCategory;

  @override
  void initState() {
    super.initState();
  }

  filterResults() {}

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MarketController>(
        builder: (MarketController homeController) {
      return Scaffold(
        backgroundColor: backgroundcolorinterface,
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text('Marketplace'),
            actions: [
              IconButton(
                  icon: _isSearching
                      ? const Icon(Icons.close)
                      : SvgPicture.asset(
                          'assets/svgs/search.svg',
                        ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Center(
                          child: StatefulBuilder(builder:
                              (BuildContext context, StateSetter setState) {
                            return AlertDialog(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Filter'),
                                  IconButton(
                                    icon: const Icon(Icons.close),
                                    color: Colors.red,
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                              content: SingleChildScrollView(
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        color: backgroundcolorinterface,
                                        borderRadius:
                                            BorderRadius.circular(radiusValue),
                                      ),
                                      padding: const EdgeInsets.only(
                                        left: 16.0,
                                        right: 16,
                                        top: 4,
                                        bottom: 5,
                                      ),
                                      margin: const EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                      ),
                                      child: DropdownButton<String>(
                                        underline: Container(),
                                        value: _selectedCategory,
                                        isExpanded: true,
                                        icon: const Icon(
                                          Icons.keyboard_arrow_right,
                                        ),
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
                                        ].map<DropdownMenuItem<String>>(
                                            (String? value) {
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
                                    const SizedBox(height: 12.0),
                                    CountryListPick(
                                      appBar: AppBar(
                                        leading: IconButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          icon: SvgPicture.asset(
                                              'assets/svgs/backbutton.svg'),
                                        ),
                                        centerTitle: true,
                                        // ignore: prefer_const_constructors
                                        title: Text(
                                          'Select Location',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      initialSelection: filterCode ?? 'GB',
                                      pickerBuilder: (BuildContext context,
                                          CountryCode? countryCode) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: backgroundcolorinterface,
                                            borderRadius: BorderRadius.circular(
                                                radiusValue),
                                          ),
                                          child: ListTile(
                                            leading: _selectedLocation != null
                                                ? Text(_selectedLocation!)
                                                : Text(
                                                    'Location',
                                                    style: bodyText2.copyWith(
                                                        color: hintColor),
                                                  ),
                                            trailing: const Icon(
                                                Icons.keyboard_arrow_right),
                                          ),
                                        );
                                      },
                                      onChanged: (CountryCode? code) {
                                        setState(
                                          () {
                                            _selectedLocation = code?.name;
                                            filterCode = code?.code;
                                          },
                                        );
                                      },
                                      useSafeArea: false,
                                    ),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Reset'),
                                  onPressed: () {
                                    setState(() {
                                      filterLocation = null;
                                      filterCode = null;
                                      filterCategory = null;
                                      _selectedLocation = null;
                                      _selectedCategory = null;
                                      _marketController.initMarket();
                                      Navigator.of(context).pop();
                                    });
                                  },
                                ),
                                ElevatedButton(
                                  child: const Text('Search'),
                                  onPressed: () {
                                    setState(() {
                                      filterLocation = _selectedLocation;
                                      filterCategory = _selectedCategory;
                                      _marketController.filterMarket(
                                          filterLocation, filterCategory);
                                    });
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          }),
                        );
                      },
                    );
                  }),
            ]),
        body: _marketController.isLoading
            ? const CircularProgressIndicator()
            : SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: SingleChildScrollView(
                          child: TextWidget(
                        text: "sdfsdfsd",
                      )),
                    ),
                    BottomBar(
                      activeIndex: 2,
                    )
                  ],
                ),
              ),
      );
    });
  }

  Future<void> loadData() async {
    setState(() {});

    // Call the loadPosts() function from the PostsController
    // await Get.find<PostsController>().loadPosts();
    await Get.find<MarketController>().initMarket();
    print('working');

    setState(() {});
  }

  Future<void> refreshData() async {
    await loadData(); // Trigger data reload
  }

  Widget joinedButton() {
    return GestureDetector(
        onTap: () async {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          final String? userId = prefs.getString(Constants.USER_ID);
          await ApiService.post(path: 'members', body: <String, dynamic>{
            'type': 'marketplace',
          });
          setState(() {
            if (_marketController.isJoined.value) {
              _marketController.users
                  .removeWhere((UserModel user) => user.uid == userId);
            } else {
              _marketController.users.add(_profileController.myProfile);
            }
            _marketController.isJoined.value =
                !_marketController.isJoined.value;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
          ),
          alignment: Alignment.center,
          child: Material(
            elevation: 4.0,
            shadowColor: Colors.black.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 0),
                      color: Colors.black.withAlpha(80),
                      blurRadius: 100.0, // soften the shadow
                      spreadRadius: 5, //extend the shadow
                    )
                  ]),
              child: Obx(
                () => Text(
                  _marketController.isJoined.value ? 'Leave' : 'Join',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: primaryColorLT,
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Widget sellingGuide() {
    return Dialog(
      backgroundColor: backgroundColor,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      insetPadding: const EdgeInsets.all(10),
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: SizeConfig.safeBlockVertical * 3,
            ),
            const Text(
                'All listings created on Business Bosses must meet the following guidelines or the listing and the user account will be deleted and banned permanently.'),
            const SizedBox(
              height: 20,
            ),
            Text(
              'GUIDELINES',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w900, color: Colors.black),
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical * 3,
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('🚫 ', style: bodyText2),
                Expanded(
                  child: Text(
                      'Weapons, ammunitions, explosives, and hazardous goods listings are not allowed',
                      style: bodyText2),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical * 2,
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('🚫  ', style: bodyText2),
                Expanded(
                  child: Text(
                      'Human trafficking, prostitution, escort, sexual services or pornographic listings are not allowed',
                      style: bodyText2),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical * 2,
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('🚫  ', style: bodyText2),
                Expanded(
                  child: Text(
                      'Illegal Drugs, Prescription or Recreational Drugs, Other Drug paraphernalia and alcohol listings is not allowed',
                      style: bodyText2),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical * 2,
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('🚫  ', style: bodyText2),
                Expanded(
                  child: Text(
                      'You cannot list stolen goods and your listing must not infringe intellectual property rights of a third-party (e.g. copyright)',
                      style: bodyText2),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical * 2,
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('🚫  ', style: bodyText2),
                Expanded(
                  child: Text(
                      'Selling animals and posting about animals for adoption listings are not allowed',
                      style: bodyText2),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical * 3,
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical * 2,
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('✅  ', style: bodyText2),
                Expanded(
                  child: Text(
                      'Ensure any image and description are honest and fair.',
                      style: bodyText2),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical * 2,
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('✅  ', style: bodyText2),
                Expanded(
                  child: Text(
                      "Business Bosses does not offer an in-built payment feature yet, it's down to you to choose a payment provider that offers buyer protection (e.g PayPal or escrow)",
                      style: bodyText2),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.safeBlockHorizontal * 3,
            ),
          ],
        ),
      ),
    );
  }
}
