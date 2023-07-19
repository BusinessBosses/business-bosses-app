import 'package:business_bosses_v2/features/home/widgets/bottom_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/models/user_model.dart';
import '../../common/widgets/buttons/my_outlined_button.dart';
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
  int pageSize = 20;

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
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: Container(
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
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      color: backgroundcolorinterface,
                                      child: Stack(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20, top: 25),
                                            child: GestureDetector(
                                              onTap: (() {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          sellingGuide(),
                                                );
                                              }),
                                              child: Row(
                                                children: [
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
                                          Column(children: [
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 20),
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      minimumSize: const Size(
                                                          150,
                                                          45) // put the width and height you want
                                                      ),
                                                  onPressed: () {
                                                    Get.to(
                                                      () =>
                                                          const CreateSellingitemScreen(
                                                        isUpd: false,
                                                      ),
                                                    );
                                                  },
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      const Text(
                                                        'Sell',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
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
                                                boxShadow: [
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
                                                    margin:
                                                        const EdgeInsets.only(
                                                            bottom: 10,
                                                            top: 10,
                                                            right: 20,
                                                            left: 20),
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
                                                    children: [
                                                      Row(
                                                        children: <Widget>[
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 25,
                                                                    right: 20,
                                                                    left: 35),
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
                                                                      'http://44.210.87.234/learningImages/marketplace.jpg',
                                                                  placeholder: (BuildContext
                                                                              context,
                                                                          String
                                                                              photo) =>
                                                                      const CircularProgressIndicator(),
                                                                  errorWidget: (BuildContext context,
                                                                          String
                                                                              photo,
                                                                          dynamic
                                                                              error) =>
                                                                      const Icon(
                                                                          Icons
                                                                              .error),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          const Expanded(
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          35),
                                                              child: Text(
                                                                '- Sell your products and services \n - Find Supplies',
                                                                style:
                                                                    TextStyle(
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
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 35,
                                                                top: 0,
                                                                right: 20),
                                                        child: Row(
                                                          children: <Widget>[
                                                            Row(
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      right: 3,
                                                                      top: 5),
                                                                  child:
                                                                      SvgPicture
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
                                                                          users:
                                                                              _marketController.users,
                                                                        ));
                                                                  },
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            5.0),
                                                                    child:
                                                                        RichText(
                                                                      text:
                                                                          TextSpan(
                                                                        children: [
                                                                          TextSpan(
                                                                              text: 'Members: (${_marketController.users.length})',
                                                                              style: const TextStyle(
                                                                                fontSize: 12,
                                                                                fontWeight: FontWeight.w600,
                                                                                color: primaryColorLT,
                                                                                decoration: TextDecoration.underline,
                                                                              )),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 8,
                                                                      top: 5,
                                                                      right: 3),
                                                                  child:
                                                                      SvgPicture
                                                                          .asset(
                                                                    'assets/svgs/marketplace.svg',
                                                                    color:
                                                                        textColor,
                                                                    height: 15,
                                                                  ),
                                                                ),
                                                                Obx(
                                                                  () {
                                                                    return Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              5.0),
                                                                      child:
                                                                          RichText(
                                                                        text:
                                                                            TextSpan(
                                                                          children: <InlineSpan>[
                                                                            TextSpan(
                                                                              text: 'Listings: ${_marketController.markets.length}',
                                                                              style: const TextStyle(
                                                                                fontSize: 12,
                                                                                color: textColor,
                                                                                fontWeight: FontWeight.w600,
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
                                                                  children: [
                                                                    joinedButton(),
                                                                  ],
                                                                ))
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      hmeController.bossUp !=
                                                                  null &&
                                                              hmeController
                                                                  .bossUp!
                                                                  .isNotEmpty
                                                          ? GestureDetector(
                                                              onTap: () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (BuildContext
                                                                              context) =>
                                                                          const Bossuppartner()),
                                                                );
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                  right: 20,
                                                                  top: 15,
                                                                  left: 20,
                                                                  bottom: 10,
                                                                ),
                                                                child:
                                                                    Container(
                                                                  height: 40,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: const Color(
                                                                        0xFFF4F4F4),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    // boxShadow: [
                                                                    //   BoxShadow(
                                                                    //     color: Colors
                                                                    //         .grey
                                                                    //         .withOpacity(0.3),
                                                                    //     spreadRadius:
                                                                    //         20,
                                                                    //     blurRadius:
                                                                    //         500,
                                                                    //     offset: const Offset(
                                                                    //         0,
                                                                    //         3),
                                                                    //   ),
                                                                    // ],
                                                                  ),
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: const Color(
                                                                          0xFFFFFFFF),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      // boxShadow: [
                                                                      //   BoxShadow(
                                                                      //     color: Colors
                                                                      //         .white
                                                                      //         .withOpacity(1),
                                                                      //     spreadRadius:
                                                                      //         20,
                                                                      //     blurRadius:
                                                                      //         500,
                                                                      //     offset: const Offset(
                                                                      //         0,
                                                                      //         3),
                                                                      //   ),
                                                                      // ],
                                                                    ),
                                                                    child: Row(
                                                                      children: [
                                                                        const Padding(
                                                                          padding:
                                                                              EdgeInsets.only(
                                                                            left:
                                                                                10,
                                                                          ),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Padding(
                                                                              padding: EdgeInsets.all(2),
                                                                              child: Text(
                                                                                'Boss Up by',
                                                                                style: TextStyle(fontSize: 11),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                            width:
                                                                                10),
                                                                        Text(
                                                                          '|',
                                                                          style: TextStyle(
                                                                              fontSize: 20,
                                                                              color: textColor.withOpacity(0.5)),
                                                                        ),
                                                                        const SizedBox(
                                                                            width:
                                                                                10),
                                                                        Text(
                                                                          hmeController.bossUp != null && hmeController.bossUp!.isNotEmpty
                                                                              ? hmeController.bossUp!.last['companyName'] ?? ''
                                                                              : '',
                                                                          style:
                                                                              const TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          softWrap:
                                                                              false,
                                                                        ),
                                                                        const Spacer(),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(right: 10.0),
                                                                          child:
                                                                              SvgPicture.asset(
                                                                            'assets/svgs/nexticon.svg',
                                                                            color:
                                                                                textColor,
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          : const SizedBox(),
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
                          body: Padding(
                            padding: const EdgeInsets.only(bottom: 50, top: 0),
                            child: Obx(() {
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
                                return _marketController.markets.isEmpty
                                    ? filterCategory != null ||
                                            filterLocation != null
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
                                              setState(() {
                                                filterLocation = null;
                                                filterCode = null;
                                                filterCategory = null;
                                                _selectedLocation = null;
                                                _selectedCategory = null;
                                                _marketController.initMarket();
                                              });
                                            },
                                          )
                                        : SafetyModel(
                                            isLoading: false,
                                            icon: const Icon(
                                              Icons.edit,
                                              color: Colors.grey,
                                              size: 80.0,
                                            ),
                                            title:
                                                'Be the first one to Sell your Item',
                                            // subTitle: '',
                                            clickableText: 'Start a topic',
                                            onTap: () {
                                              Get.to(
                                                () =>
                                                    const CreateSellingitemScreen(
                                                  isUpd: false,
                                                ),
                                              );
                                            },
                                          )
                                    : RefreshIndicator(
                                        onRefresh: refreshData,
                                        child: NotificationListener<
                                            ScrollNotification>(
                                          onNotification:
                                              (ScrollNotification scrollInfo) {
                                            if (scrollInfo.metrics.pixels ==
                                                scrollInfo
                                                    .metrics.maxScrollExtent) {
                                              _marketController.loadMore(
                                                  pageSize,
                                                  _marketController
                                                      .paginationPage.value);
                                              _marketController
                                                  .paginationPage.value++;
                                            }
                                            return false;
                                          },
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: _marketController
                                                    .markets.length +
                                                1,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              if (index <
                                                  _marketController
                                                      .markets.length) {
                                                final MarketModel market =
                                                    _marketController
                                                        .markets[index];
                                                return MarketTile(post: market);
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
                                        ),
                                      );
                              }
                            }),
                          ),
                        ),
                      ),
                    ),
                    const BottomBar(
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
          _marketController.isJoined.value = !_marketController.isJoined.value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
        ),
        alignment: Alignment.center,
        child: SizedBox(
          height: 38,
          width: 80,
          child: Obx(() => !_marketController.isJoined.value
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
                )),
        ),
      ),
    );
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
