import 'dart:io';

import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:business_bosses_v2/features/home/sellProduct.dart';
import 'package:business_bosses_v2/features/home/widgets/bottom_bar.dart';
import 'package:business_bosses_v2/features/home/widgets/sellingpopup.dart';
import 'package:business_bosses_v2/features/marketplace/models/market_model.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/market_members.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/sell_screen.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/sell_services.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/marketplace_item.dart';

import 'package:business_bosses_v2/features/marketplace/widgets/markets.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/products.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/service_item.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/services.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../common/models/user_model.dart';
import '../../common/widgets/buttons/my_outlined_button.dart';
import '../../common/widgets/safety_model.dart';
import '../../services/api_service.dart';
import '../../utils/constants/constants.dart';
import '../../utils/theme/theme.dart';
import '../marketplace/controllers/market_controller.dart';
import '../profile/controller/profile_controller.dart';
import 'controller/home_controller.dart';

/// Buying and Selling screen
class MarketplaceScreen extends StatefulWidget {
  /// Mrketplace constructor
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen>
    with AutomaticKeepAliveClientMixin<MarketplaceScreen> {
  final ProfileController _profileController = Get.find();
  final MarketController _marketController = Get.find();
  final HomeController hmeController = Get.find();
  String? _selectedCategory;
  String? _selectedLocation;
  final bool _isSearching = false;
  String? filterCode;
  bool get wantKeepAlive => true;
  String? filterLocation;
  String? filterCategory;
  int pageSize = 20;
  String? filteredCategory;
  bool isScrolled = true;

  @override
  void initState() {
    super.initState();
  }

  String formatCount(int count) {
    if (count >= 1000) {
      double countInK = count / 1000;
      if (countInK >= 1000) {
        return '${(countInK / 1000).toStringAsFixed(1)}M';
      } else {
        return '${countInK.toStringAsFixed(1)}K';
      }
    } else {
      return count.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    int userCount = _marketController.users.length;
    String formattedUserCount = formatCount(userCount);

    return Scaffold(
      backgroundColor: backgroundcolorinterface,
      floatingActionButton: !_marketController.loading.value
          ? Padding(
              padding: EdgeInsets.only(bottom: Platform.isAndroid ? 80.0 : 0),
              child: FloatingActionButton.extended(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(25.0),
                        ),
                      ),
                      builder: (context) {
                        return SizedBox(
                          height: 250,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Expanded(
                                  // Set a specific height
                                  child: ListView.separated(
                                    itemCount: 3,
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                            const Divider(),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return ListTile(
                                        onTap: () {
                                          Navigator.pop(context);
                                          index == 0
                                              ? Get.toNamed(Routes.createPost)
                                              : index == 1
                                                  ? sellProduct(context)
                                                  : Get.toNamed(
                                                      Routes.createevent);
                                        },
                                        minVerticalPadding: 0,
                                        contentPadding:
                                            const EdgeInsets.only(left: 10),
                                        leading: SvgPicture.asset(
                                          index == 0
                                              ? 'assets/svgs/text.svg'
                                              : index == 1
                                                  ? 'assets/svgs/sellicon.svg'
                                                  : 'assets/svgs/liveevent.svg',
                                          height: index == 0
                                              ? 25
                                              : index == 1
                                                  ? 30
                                                  : 22,
                                          color: textColor.withOpacity(1),
                                        ),
                                        title: Text(
                                          index == 0
                                              ? 'Create a Post'
                                              : index == 1
                                                  ? 'Sell your product & service'
                                                  : 'Create a Live Event',
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      });
                },
                label: const Text(
                  'Post',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                ),
                icon: const Icon(Icons.add),
                shape: isScrolled
                    ? RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100))
                    : CircleBorder(),
                isExtended: isScrolled,
                backgroundColor: primaryColorLT,
              ),
            )
          : Container(),
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Marketplace'),
          actions: <Widget>[
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
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
                                  Column(
                                    children: <Widget>[
                                      filteredCategory == null ||
                                              filteredCategory == 'Products'
                                          ? GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  if (filteredCategory ==
                                                      'Products') {
                                                    _selectedLocation = null;
                                                    _selectedCategory = null;
                                                    filteredCategory = null;
                                                  } else {
                                                    filteredCategory =
                                                        'Products';
                                                  }
                                                });
                                              },
                                              child: Container(
                                                alignment: Alignment.bottomLeft,
                                                decoration: BoxDecoration(
                                                  color:
                                                      backgroundcolorinterface,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          radiusValue),
                                                ),
                                                padding: const EdgeInsets.only(
                                                  left: 16.0,
                                                  right: 16,
                                                  top: 15,
                                                  bottom: 15,
                                                ),
                                                margin: const EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                ),
                                                child: const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Text(
                                                      'Products',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    Icon(
                                                      Icons.arrow_forward_ios,
                                                      size: 10,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : Container(),
                                      const SizedBox(height: 10),
                                      filteredCategory == null ||
                                              filteredCategory == 'Services'
                                          ? GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  if (filteredCategory ==
                                                      'Services') {
                                                    _selectedLocation = null;
                                                    _selectedCategory = null;
                                                    filteredCategory = null;
                                                  } else {
                                                    filteredCategory =
                                                        'Services';
                                                  }
                                                });
                                              },
                                              child: Container(
                                                alignment: Alignment.bottomLeft,
                                                decoration: BoxDecoration(
                                                  color:
                                                      backgroundcolorinterface,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          radiusValue),
                                                ),
                                                padding: const EdgeInsets.only(
                                                  left: 16.0,
                                                  right: 16,
                                                  top: 15,
                                                  bottom: 15,
                                                ),
                                                margin: const EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                ),
                                                child: const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Text(
                                                      'Services',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    Icon(
                                                      Icons.arrow_forward_ios,
                                                      size: 10,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                  const SizedBox(height: 12.0),
                                  filteredCategory == 'Products'
                                      ? Container(
                                          decoration: BoxDecoration(
                                            color: backgroundcolorinterface,
                                            borderRadius: BorderRadius.circular(
                                                radiusValue),
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
                                                        value ??
                                                            'Select Category',
                                                        style:
                                                            bodyText2.copyWith(
                                                          color: hintColor,
                                                        ),
                                                      ),
                                              );
                                            }).toList(),
                                          ),
                                        )
                                      : filteredCategory == 'Services'
                                          ? Container(
                                              decoration: BoxDecoration(
                                                color: backgroundcolorinterface,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        radiusValue),
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
                                                    _selectedCategory =
                                                        newValue!;
                                                  });
                                                },
                                                items: <String?>[
                                                  null,
                                                  'Write 1 Page Business Plan',
                                                  'Build 1 Page Website',
                                                  'Create Social Media AD',
                                                  'Monthly Account Book Keeping',
                                                  'Logo & Branding Guidelines',
                                                  'Test, Review & Feedback',
                                                ].map<DropdownMenuItem<String>>(
                                                    (String? value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: value != null
                                                        ? Text(value)
                                                        : Text(
                                                            value ??
                                                                'Select Service Type',
                                                            style: bodyText2
                                                                .copyWith(
                                                              color: hintColor,
                                                            ),
                                                          ),
                                                  );
                                                }).toList(),
                                              ),
                                            )
                                          : Container(),
                                  const SizedBox(height: 12.0),
                                  filteredCategory == 'Products'
                                      ? CountryListPick(
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
                                              style:
                                                  const TextStyle(fontSize: 20),
                                            ),
                                          ),
                                          initialSelection: filterCode ?? 'GB',
                                          pickerBuilder: (BuildContext context,
                                              CountryCode? countryCode) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                color: backgroundcolorinterface,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        radiusValue),
                                              ),
                                              child: ListTile(
                                                leading: _selectedLocation !=
                                                        null
                                                    ? Text(_selectedLocation!)
                                                    : Text(
                                                        'Location',
                                                        style:
                                                            bodyText2.copyWith(
                                                                color:
                                                                    hintColor),
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
                                        )
                                      : filteredCategory == 'Services'
                                          ? Container(
                                              decoration: BoxDecoration(
                                                color: backgroundcolorinterface,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        radiusValue),
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
                                                value: _selectedLocation,
                                                isExpanded: true,
                                                icon: const Icon(
                                                  Icons.keyboard_arrow_right,
                                                ),
                                                iconSize: 24,
                                                elevation: 16,
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    _selectedLocation =
                                                        newValue!;
                                                  });
                                                },
                                                items: <String?>[
                                                  null,
                                                  '1 Day Delivery',
                                                  '2 Day Delivery',
                                                  '3 Day Delivery',
                                                  '4 Day Delivery',
                                                  '5 Day Delivery',
                                                  '6 Day Delivery',
                                                  '7 Day Delivery',
                                                  '8 Day Delivery',
                                                  '9 Day Delivery',
                                                  '10 Day Delivery',
                                                  '11 Day Delivery',
                                                  '12 Day Delivery',
                                                  '13 Day Delivery',
                                                  '14 Day Delivery',
                                                  '15 Day Delivery',
                                                ].map<DropdownMenuItem<String>>(
                                                    (String? value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: value != null
                                                        ? Text(value)
                                                        : Text(
                                                            value ??
                                                                'Select Delivery Time',
                                                            style: bodyText2
                                                                .copyWith(
                                                              color: hintColor,
                                                            ),
                                                          ),
                                                  );
                                                }).toList(),
                                              ),
                                            )
                                          : Container(),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 25.0, bottom: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    TextButton(
                                      child: const Text('Reset'),
                                      onPressed: () {
                                        setState(() {
                                          filterLocation = null;
                                          filterCode = null;
                                          filterCategory = null;
                                          _selectedLocation = null;
                                          _selectedCategory = null;
                                          filteredCategory = null;
                                          _marketController.updateFiltered();
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
                                ),
                              )
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
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: NestedScrollView(
                      headerSliverBuilder:
                          (BuildContext context, bool innerBoxIsScrolled) {
                        return <Widget>[
                          SliverStickyHeader(
                            sticky: false,
                            header: Column(
                              children: <Widget>[
                                Container(
                                  width: double.infinity,
                                  color: backgroundcolorinterface,
                                  child: Stack(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15, top: 25),
                                        child: GestureDetector(
                                          onTap: (() {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  sellingGuide(context),
                                            );
                                          }),
                                          child: Row(
                                            children: <Widget>[
                                              const Text(
                                                'Guidelines ',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              SvgPicture.asset(
                                                'assets/svgs/info.svg',
                                                height: 20,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Column(children: <Widget>[
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              right: 15,
                                            ),
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  minimumSize: const Size(150,
                                                      45) // put the width and height you want
                                                  ),
                                              onPressed: () {
                                                showModalBottomSheet(
                                                    context: context,
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                        top: Radius.circular(
                                                            25.0),
                                                      ),
                                                    ),
                                                    builder:
                                                        (BuildContext context) {
                                                      return SizedBox(
                                                        height: 200,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(15.0),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: <Widget>[
                                                              Expanded(
                                                                // Set a specific height
                                                                child: ListView
                                                                    .separated(
                                                                  itemCount: 2,
                                                                  separatorBuilder:
                                                                      (BuildContext context,
                                                                              int index) =>
                                                                          const Divider(),
                                                                  itemBuilder:
                                                                      (BuildContext
                                                                              context,
                                                                          int index) {
                                                                    return ListTile(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                        index ==
                                                                                0
                                                                            ? Get.toNamed(Routes
                                                                                .sellscreen)
                                                                            : Get.to(() =>
                                                                                const CreateServiceScreen(isUpd: false));
                                                                      },
                                                                      minVerticalPadding:
                                                                          0,
                                                                      contentPadding:
                                                                          const EdgeInsets
                                                                              .only(
                                                                        left:
                                                                            10,
                                                                      ),
                                                                      leading:
                                                                          SvgPicture
                                                                              .asset(
                                                                        index ==
                                                                                0
                                                                            ? 'assets/svgs/sellicon.svg'
                                                                            : 'assets/svgs/sellicon.svg',
                                                                        height: index ==
                                                                                0
                                                                            ? 25
                                                                            : index == 1
                                                                                ? 30
                                                                                : 22,
                                                                        color: textColor
                                                                            .withOpacity(1),
                                                                      ),
                                                                      title:
                                                                          Text(
                                                                        index ==
                                                                                0
                                                                            ? 'Sell your product'
                                                                            : 'Sell your service',
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                18,
                                                                            fontWeight:
                                                                                FontWeight.w700),
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    });
                                              },
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  const Text(
                                                    'Sell',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  SvgPicture.asset(
                                                      'assets/svgs/startatopic.svg')
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            boxShadow: <BoxShadow>[
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.09),
                                                blurRadius:
                                                    100.0, // soften the shadow
                                                spreadRadius:
                                                    5, //extend the shadow
                                              )
                                            ],
                                          ),
                                          child: Stack(
                                            children: <Widget>[
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 10,
                                                    top: 10,
                                                    right: 15,
                                                    left: 15),
                                                height: 150,
                                                width: double.infinity,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                  child: const ColoredBox(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              Column(
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .only(
                                                            top: 25,
                                                            right: 15,
                                                            left: 30),
                                                        height: 86,
                                                        width: 142,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          child: FittedBox(
                                                            child:
                                                                CachedNetworkImage(
                                                              memCacheWidth:
                                                                  256,
                                                              imageUrl:
                                                                  'https://businessbosses.com.ng/learningImages/marketplace.jpg',
                                                              placeholder: (BuildContext
                                                                          context,
                                                                      String
                                                                          photo) =>
                                                                  const CircularProgressIndicator(),
                                                              errorWidget: (BuildContext
                                                                          context,
                                                                      String
                                                                          photo,
                                                                      dynamic
                                                                          error) =>
                                                                  const Icon(Icons
                                                                      .error),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 30),
                                                          child: Text(
                                                            _marketController
                                                                .marketDescription,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                            softWrap: true,
                                                            maxLines: 5,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 27,
                                                      top: 0,
                                                      right: 15,
                                                    ),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Row(
                                                          children: <Widget>[
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      right: 2,
                                                                      top: 5),
                                                              child: SvgPicture
                                                                  .asset(
                                                                'assets/svgs/members.svg',
                                                                height: 15,
                                                                color:
                                                                    primaryColorLT,
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                Get.to(() =>
                                                                    MarketMembersScreen(
                                                                      users: _marketController
                                                                          .users,
                                                                    ));
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top:
                                                                            5.0),
                                                                child: RichText(
                                                                  text:
                                                                      TextSpan(
                                                                    children: <InlineSpan>[
                                                                      TextSpan(
                                                                          text:
                                                                              'Members ($formattedUserCount)',
                                                                          style:
                                                                              const TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            color:
                                                                                primaryColorLT,
                                                                            decoration:
                                                                                TextDecoration.underline,
                                                                          )),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: <Widget>[
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 8,
                                                                      top: 5,
                                                                      right: 3),
                                                              child: SvgPicture
                                                                  .asset(
                                                                'assets/svgs/marketplace.svg',
                                                                color:
                                                                    textColor,
                                                                height: 15,
                                                              ),
                                                            ),
                                                            Obx(
                                                              () {
                                                                int postCount =
                                                                    _marketController
                                                                        .products
                                                                        .length;
                                                                String
                                                                    formattedpostCount =
                                                                    formatCount(
                                                                        postCount);
                                                                return Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              5.0),
                                                                  child:
                                                                      RichText(
                                                                    text:
                                                                        TextSpan(
                                                                      children: <InlineSpan>[
                                                                        TextSpan(
                                                                          text:
                                                                              'Listings ($formattedpostCount)',
                                                                          style:
                                                                              const TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            color:
                                                                                textColor,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                        const Spacer(),
                                                        Align(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: <Widget>[
                                                                joinedButton(),
                                                              ],
                                                            ))
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 1,
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ]),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ];
                      },
                      body: Obx(() {
                        if (_marketController.loading.value) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (_marketController.error.value) {
                          return const SafetyModel(
                            isLoading: false,
                            title: 'Error While Loading Data',
                            subTitle: 'Try Reloading Again',
                            icon: Icon(
                              Icons.warning,
                              size: 60,
                            ),
                          );
                        } else {
                          return _marketController.products.isEmpty &&
                                  !_marketController.isfiltered.value
                              ? SafetyModel(
                                  isLoading: false,
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.grey,
                                    size: 80.0,
                                  ),
                                  title: 'Be the first one to Sell your Item',
                                  // subTitle: '',
                                  clickableText: 'Post an item',
                                  onTap: () {
                                    Get.to(
                                      () => const CreateSellingitemScreen(
                                        isUpd: false,
                                      ),
                                    );
                                  },
                                )
                              : _marketController.searchResult.isEmpty &&
                                      _marketController.isfiltered.value
                                  ? SafetyModel(
                                      isLoading: false,
                                      icon: const Icon(
                                        Icons.shopping_cart,
                                        color: Colors.grey,
                                        size: 80.0,
                                      ),
                                      title:
                                          'No Items Available For This Search',
                                      // subTitle: '',
                                      clickableText: 'View All',
                                      onTap: () {
                                        setState(
                                          () {
                                            filterLocation = null;
                                            filterCode = null;
                                            filterCategory = null;
                                            _selectedLocation = null;
                                            _selectedCategory = null;
                                            _marketController.updateFiltered();
                                            _marketController.initMarket();
                                          },
                                        );
                                      },
                                    )
                                  : RefreshIndicator(
                                      onRefresh: refreshData,
                                      child: _marketController.isfiltered.value
                                          ? NotificationListener<
                                              ScrollNotification>(
                                              onNotification: (notification) {
                                                if (notification
                                                    is ScrollUpdateNotification) {
                                                  if (notification
                                                              .dragDetails !=
                                                          null &&
                                                      notification.dragDetails!
                                                              .primaryDelta !=
                                                          null) {
                                                    double primaryDelta =
                                                        notification
                                                            .dragDetails!
                                                            .primaryDelta!;

                                                    if (primaryDelta > 0) {
                                                      // Scrolling downward
                                                      setState(() {
                                                        isScrolled = true;
                                                      });
                                                    } else if (primaryDelta <
                                                        0) {
                                                      // Scrolling upward
                                                      setState(() {
                                                        isScrolled = false;
                                                      });
                                                    }
                                                  }
                                                }

                                                return true;
                                              },
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: _marketController
                                                        .isfiltered.value
                                                    ? _marketController
                                                        .searchResult.length
                                                    : _marketController
                                                            .markets.length +
                                                        1,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  if (index <
                                                      (_marketController
                                                              .isfiltered.value
                                                          ? _marketController
                                                              .searchResult
                                                              .length
                                                          : _marketController
                                                              .markets
                                                              .length)) {
                                                    final MarketModel market =
                                                        _marketController
                                                                .isfiltered
                                                                .value
                                                            ? _marketController
                                                                    .searchResult[
                                                                index]
                                                            : _marketController
                                                                .markets[index];
                                                    return VisibilityDetector(
                                                      key:
                                                          Key(index.toString()),
                                                      onVisibilityChanged:
                                                          (VisibilityInfo
                                                              info) {
                                                        final bool
                                                            hasIncrementedView =
                                                            hmeController
                                                                .itemsWithIncrementedViews
                                                                .contains(_marketController
                                                                    .markets[
                                                                        index]
                                                                    .marketId);
                                                        if (info.visibleFraction ==
                                                                1.0 &&
                                                            !hasIncrementedView) {
                                                          _marketController
                                                              .updatemarketViews(
                                                                  _marketController
                                                                          .markets[
                                                                      index]);
                                                          setState(() {
                                                            hmeController
                                                                .itemsWithIncrementedViews
                                                                .add(_marketController
                                                                    .markets[
                                                                        index]
                                                                    .marketId); // Set the flag to prevent further increments
                                                          });
                                                        }
                                                      },
                                                      child: _marketController
                                                              .markets[index]
                                                              .isProduct
                                                          ? MarketTile(
                                                              post: market,
                                                              controller:
                                                                  _marketController,
                                                              key: ValueKey(
                                                                  _marketController
                                                                      .markets[
                                                                          index]
                                                                      .marketId),
                                                            )
                                                          : ServiceTile(
                                                              post: market,
                                                              controller:
                                                                  _marketController,
                                                              key: ValueKey(
                                                                  _marketController
                                                                      .markets[
                                                                          index]
                                                                      .marketId),
                                                            ),
                                                    );
                                                  } else {
                                                    // Display a loading indicator at the end of the list
                                                    if (_marketController
                                                        .loadingMore.value) {
                                                      return const Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        ),
                                                      );
                                                    } else {
                                                      return const SizedBox
                                                          .shrink();
                                                    }
                                                  }
                                                },
                                              ),
                                            )
                                          : DefaultTabController(
                                              length: 3, // Number of tabs
                                              child: Column(
                                                children: <Widget>[
                                                  Container(
                                                    constraints:
                                                        const BoxConstraints
                                                            .expand(height: 50),
                                                    child: const TabBar(
                                                      tabs: <Widget>[
                                                        Tab(
                                                          icon: Icon(
                                                              Icons.dashboard),
                                                        ),
                                                        Tab(text: 'Products'),
                                                        Tab(text: 'Services'),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: TabBarView(
                                                      children: <Widget>[
                                                        // Content of Tab 1
                                                        NotificationListener<
                                                                ScrollNotification>(
                                                            onNotification:
                                                                (notification) {
                                                              if (notification
                                                                  is ScrollUpdateNotification) {
                                                                if (notification
                                                                            .dragDetails !=
                                                                        null &&
                                                                    notification
                                                                            .dragDetails!
                                                                            .primaryDelta !=
                                                                        null) {
                                                                  double
                                                                      primaryDelta =
                                                                      notification
                                                                          .dragDetails!
                                                                          .primaryDelta!;

                                                                  if (primaryDelta >
                                                                      0) {
                                                                    // Scrolling downward
                                                                    setState(
                                                                        () {
                                                                      isScrolled =
                                                                          true;
                                                                    });
                                                                  } else if (primaryDelta <
                                                                      0) {
                                                                    // Scrolling upward
                                                                    setState(
                                                                        () {
                                                                      isScrolled =
                                                                          false;
                                                                    });
                                                                  }
                                                                }
                                                              }

                                                              return true;
                                                            },
                                                            child:
                                                                const MarketsPage()),

                                                        // Content of Tab 2
                                                        NotificationListener<
                                                                ScrollNotification>(
                                                            onNotification:
                                                                (notification) {
                                                              if (notification
                                                                  is ScrollUpdateNotification) {
                                                                if (notification
                                                                            .dragDetails !=
                                                                        null &&
                                                                    notification
                                                                            .dragDetails!
                                                                            .primaryDelta !=
                                                                        null) {
                                                                  double
                                                                      primaryDelta =
                                                                      notification
                                                                          .dragDetails!
                                                                          .primaryDelta!;

                                                                  if (primaryDelta >
                                                                      0) {
                                                                    // Scrolling downward
                                                                    setState(
                                                                        () {
                                                                      isScrolled =
                                                                          true;
                                                                    });
                                                                  } else if (primaryDelta <
                                                                      0) {
                                                                    // Scrolling upward
                                                                    setState(
                                                                        () {
                                                                      isScrolled =
                                                                          false;
                                                                    });
                                                                  }
                                                                }
                                                              }

                                                              return true;
                                                            },
                                                            child:
                                                                const ProductsPage()),

                                                        // Content of Tab 3
                                                        NotificationListener<
                                                                ScrollNotification>(
                                                            onNotification:
                                                                (notification) {
                                                              if (notification
                                                                  is ScrollUpdateNotification) {
                                                                if (notification
                                                                            .dragDetails !=
                                                                        null &&
                                                                    notification
                                                                            .dragDetails!
                                                                            .primaryDelta !=
                                                                        null) {
                                                                  double
                                                                      primaryDelta =
                                                                      notification
                                                                          .dragDetails!
                                                                          .primaryDelta!;

                                                                  if (primaryDelta >
                                                                      0) {
                                                                    // Scrolling downward
                                                                    setState(
                                                                        () {
                                                                      isScrolled =
                                                                          true;
                                                                    });
                                                                  } else if (primaryDelta <
                                                                      0) {
                                                                    // Scrolling upward
                                                                    setState(
                                                                        () {
                                                                      isScrolled =
                                                                          false;
                                                                    });
                                                                  }
                                                                }
                                                              }

                                                              return true;
                                                            },
                                                            child:
                                                                const ServicesPage())
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                    );
                        }
                      }),
                    ),
                  ),
                  const BottomBar(
                    activeIndex: 3,
                  )
                ],
              ),
            ),
    );
  }

  Future<void> loadData() async {
    setState(() {});

    // Call the loadPosts() function from the PostsController
    // await Get.find<PostsController>().loadPosts();
    await Get.find<MarketController>().initMarket();
  }

  Future<void> refreshData() async {
    await loadData(); // Trigger data reload
  }

  Widget joinedButton() {
    return GestureDetector(
      onTap: () async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final String? userId = prefs.getString(Constants.USER_ID);

        setState(() {
          if (_marketController.isJoined.value) {
            _marketController.users
                .removeWhere((UserModel user) => user.uid == userId);
          } else {
            _marketController.users.add(_profileController.myProfile);
          }
          _marketController.isJoined.value = !_marketController.isJoined.value;
        });
        final Map<String, dynamic> marketData = <String, dynamic>{
          'industryId': 'market_place_id',
          'categoryId': Constants.MARKET_PLACE_CATEGORY_ID,
          'description': '- Sell your products and services \n - Find Supplies',
          'industry': 'Market Place',
          'photo':
              'https://businessbosses.com.ng/learningImages/marketplace.jpg',
          'active': true,
          'timestamp': DateTime.now().millisecondsSinceEpoch
        };
        _profileController.toggleInterests(Industry.toObject(marketData));
        await ApiService.post(path: 'members', body: <String, dynamic>{
          'type': 'marketplace',
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
        ),
        alignment: Alignment.center,
        child: SizedBox(
          height: 38,
          width: 75,
          child: Obx(
            () => !_marketController.isJoined.value
                ? const MCustomButton(
                    child: Text(
                      'Join',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: primaryColorLT,
                      ),
                    ),
                  )
                : const MCustomButton(
                    buttonType: ButtonType.outlinegrey,
                    child: Text(
                      'Leave',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF777777),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
