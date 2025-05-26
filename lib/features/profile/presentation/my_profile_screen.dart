import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/presentation/bottom_nav_screen.dart';
import 'package:business_bosses_v2/bbpro/presentation/shop_screen.dart';
import 'package:business_bosses_v2/bbpro/widgets/drawercontent.dart';
import 'package:business_bosses_v2/bbpro/widgets/menubutton.dart';
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/chat/ai_chat.dart';
import 'package:business_bosses_v2/features/forum/widgets/forum_item.dart';
import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/donations/widgets/donation_item.dart';
import 'package:business_bosses_v2/features/home/widgets/bottom_bar.dart';
import 'package:business_bosses_v2/features/home/widgets/course_item.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/features/profile/widgets/profileinfodisplay.dart';
import 'package:business_bosses_v2/features/live_event/controller/live_event_controller.dart';
import 'package:business_bosses_v2/features/profile/widgets/profilepostsdisplay.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../common/widgets/tiles/outlinebuttonheader.dart';
import '../../marketplace/controllers/market_controller.dart';
import '../../marketplace/models/market_model.dart';
import '../../marketplace/widgets/marketplace_item.dart';
import '../../marketplace/widgets/service_item.dart';
import '../widgets/my_profile_header.dart';

bool isExpanded = false;

// ignore: public_member_api_docs
class MyProfileScreen extends StatefulWidget {
  final int? selectedIndex;
  final int? currentIndex;
  // ignore: public_member_api_docs
  static const String routeName = '/my-profile-screen';

  // ignore: public_member_api_docs
  const MyProfileScreen({super.key, this.selectedIndex, this.currentIndex});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final ProfileController profileController = Get.find();
  final MarketController marketController = Get.find();
  final ShopController shopController = Get.find();
  final HomeController homeController = Get.find();
  final LiveController liveEventController = Get.put(LiveController());
  final AdvancedDrawerController _advancedDrawerController =
      AdvancedDrawerController();
  bool isScrolled = true;
  bool loading = true;

  int _currentIndex = 0;
  late PageController _pageController;

  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    _selectedIndex = widget.selectedIndex ?? 0;
    _currentIndex = widget.currentIndex ?? 0;
    _pageController = PageController(initialPage: widget.currentIndex ?? 0);
    if (shopController.shop == null) {
      shopController.initShop().then((bool value) {
        loading = false;
        setState(() {});
      });
    } else {
      loading = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    return GetBuilder<ProfileController>(
      builder: (ProfileController profileController) {
        return AdvancedDrawer(
          backdrop: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[Colors.white, Colors.white.withOpacity(0.2)],
              ),
            ),
          ),
          controller: _advancedDrawerController,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 300),
          animateChildDecoration: true,
          rtlOpening: false,
          // openScale: 1.0,
          disabledGestures: false,
          childDecoration: const BoxDecoration(
            // NOTICE: Uncomment if you want to add shadow behind the page.
            // Keep in mind that it may cause animation jerks.
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black12,
                blurRadius: 3,
              ),
            ],
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),

          drawer: DrawerContent(
            oncloseclick: () {
              _advancedDrawerController.hideDrawer();
            },
            currentuser: homeController.profileController.myProfile,
            hasUnreadNotification:
                profileController.myProfile.unReadCount != null &&
                    profileController.myProfile.unReadCount! > 0,
          ),

          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(
                  (_selectedIndex == 0 || _selectedIndex == 4)
                      ? kToolbarHeight
                      : 0),
              child: Stack(children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    if (_selectedIndex == 0 || _selectedIndex == 4)
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: CupertinoSlidingSegmentedControl<int>(
                          backgroundColor: backgroundColor,
                          padding: const EdgeInsets.all(5),
                          children: <int, Widget>{
                            0: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                'Profile',
                                style: _currentIndex == 0
                                    ? const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      )
                                    : const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: textColor,
                                      ),
                              ),
                            ),
                            1: Text(
                              'My-Biz',
                              style: _currentIndex == 1
                                  ? const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 14)
                                  : const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: textColor,
                                    ),
                            ),
                          },
                          onValueChanged: (int? value) {
                            if (value != null) {
                              setState(() {
                                _selectedIndex == 0;
                                _currentIndex = value;
                                _pageController.animateToPage(
                                  _currentIndex,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.ease,
                                );
                              });
                            }
                          },
                          groupValue: _currentIndex,
                        ),
                      ),
                    if (_selectedIndex == 0 || _selectedIndex == 4)
                      const SizedBox(height: 10.0),
                  ],
                ),
                if (_selectedIndex == 0 || _selectedIndex == 4)
                  Positioned(
                      bottom: 5,
                      right: 0,
                      child: GestureDetector(
                          onTap: () {
                            _advancedDrawerController.showDrawer();
                          },
                          child: const CustomMenuButton())),
                if (_selectedIndex == 0 || _selectedIndex == 4)
                  Positioned(
                      bottom: 5,
                      left: 0,
                      child: IconButton(
                        onPressed: () {
                          Get.to(
                            () => const MyEvents(
                              toHome: true,
                            ),
                          );
                        },
                        icon: const Icon(Icons.calendar_month),
                      )),
              ]),
            ),
            body: loading
                ? const SafetyModel()
                : PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.white,
                              child: NestedScrollView(
                                headerSliverBuilder: (BuildContext context,
                                    bool innerBoxIsScrolled) {
                                  return <Widget>[
                                    SliverStickyHeader(
                                      sticky: false,
                                      header: MyProfileHeader(
                                        myProfile: profileController.myProfile,
                                      ),
                                    )
                                  ];
                                },
                                body: DefaultTabController(
                                  length: calculateTabLength(),
                                  child: Column(
                                    children: <Widget>[
                                      // if (_publicUser.uid !=
                                      //     'FirebaseAuth.instance.currentUser.uid') ...{
                                      OutlineButtonHeader(
                                        context,
                                        profileController.myProfile,
                                      ),
                                      const SizedBox(height: 15.0),
                                      // },

                                      const SizedBox(
                                        width: double.infinity,
                                        height: 1.5,
                                        child: ColoredBox(
                                          color: backgroundcolorinterface,
                                        ),
                                      ),
                                      Material(
                                        color: const Color(0xFFF9F9F9),
                                        child: TabBar(
                                          isScrollable:
                                              calculateTabLength() <= 4
                                                  ? false
                                                  : true,
                                          indicatorColor:
                                              primaryColorLT, // Replace primaryColorLT with the desired color
                                          labelStyle: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                          labelColor: Colors.black,
                                          tabs: <Widget>[
                                            const Tab(
                                              child: FittedBox(
                                                child: Text(
                                                  'About',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 14),
                                                ),
                                              ),
                                            ),
                                            const Tab(
                                              child: FittedBox(
                                                child: Text(
                                                  'Posts',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 14),
                                                ),
                                              ),
                                            ),
                                            if (!profileController
                                                .myProfile.isSubscribed)
                                              if (marketController.markets
                                                  .where((MarketModel market) =>
                                                      market.userId ==
                                                      profileController
                                                          .myProfile.uid)
                                                  .isNotEmpty)
                                                const Tab(
                                                  child: FittedBox(
                                                    child: Text(
                                                      'Listings',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 14),
                                                    ),
                                                  ),
                                                ),
                                            if (homeController
                                                .userresources.isNotEmpty)
                                              const Tab(
                                                child: FittedBox(
                                                  child: Text(
                                                    'Resources',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 14),
                                                  ),
                                                ),
                                              ),
                                            if (homeController
                                                .userdonations.isNotEmpty)
                                              const Tab(
                                                child: FittedBox(
                                                  child: Text(
                                                    'Donations',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 14),
                                                  ),
                                                ),
                                              ),
                                            if (homeController
                                                .usercourses.isNotEmpty)
                                              const Tab(
                                                child: FittedBox(
                                                  child: Text(
                                                    'Courses',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 14),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),

                                      const SizedBox(
                                        width: double.infinity,
                                        height: 1.5,
                                        child: ColoredBox(
                                          color: backgroundcolorinterface,
                                        ),
                                      ), // Container(

                                      Expanded(
                                        child: TabBarView(children: <Widget>[
                                          NotificationListener<
                                              ScrollNotification>(
                                            onNotification: (ScrollNotification
                                                notification) {
                                              if (notification
                                                  is ScrollUpdateNotification) {
                                                if (notification.dragDetails !=
                                                        null &&
                                                    notification.dragDetails!
                                                            .primaryDelta !=
                                                        null) {
                                                  double primaryDelta =
                                                      notification.dragDetails!
                                                          .primaryDelta!;

                                                  if (primaryDelta > 0) {
                                                    // Scrolling downward
                                                    setState(() {
                                                      isScrolled = true;
                                                    });
                                                  } else if (primaryDelta < 0) {
                                                    // Scrolling upward
                                                    setState(() {
                                                      isScrolled = false;
                                                    });
                                                  }
                                                }
                                              }

                                              return true;
                                            },
                                            child: SingleChildScrollView(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  const SizedBox(
                                                    height: 30,
                                                  ),
                                                  profileinfodisplay(
                                                      context,
                                                      profileController
                                                          .myProfile),
                                                ],
                                              ),
                                            ),
                                          ),
                                          NotificationListener<
                                              ScrollNotification>(
                                            onNotification: (ScrollNotification
                                                notification) {
                                              if (notification
                                                  is ScrollUpdateNotification) {
                                                if (notification.dragDetails !=
                                                        null &&
                                                    notification.dragDetails!
                                                            .primaryDelta !=
                                                        null) {
                                                  double primaryDelta =
                                                      notification.dragDetails!
                                                          .primaryDelta!;

                                                  if (primaryDelta > 0) {
                                                    // Scrolling downward
                                                    setState(
                                                      () {
                                                        isScrolled = true;
                                                      },
                                                    );
                                                  } else if (primaryDelta < 0) {
                                                    // Scrolling upward
                                                    setState(
                                                      () {
                                                        isScrolled = false;
                                                      },
                                                    );
                                                  }
                                                }
                                              }

                                              return true;
                                            },
                                            child: profilepostsdisplay(
                                              ispublicposts: false,
                                              context,
                                              profileController.myProfile,
                                              profileController.posts,
                                              loading: profileController
                                                  .isLoading.value,
                                            ),
                                          ),

                                          ///Marketplace
                                          if (!profileController
                                              .myProfile.isSubscribed)
                                            if (marketController.markets
                                                .where((MarketModel market) =>
                                                    market.userId ==
                                                    profileController
                                                        .myProfile.uid)
                                                .isNotEmpty)
                                              profileController
                                                      .myProfile.isSubscribed
                                                  ? const ShopScreen()
                                                  : SizedBox(
                                                      height: double.infinity,
                                                      width: double.infinity,
                                                      child: Obx(
                                                        () {
                                                          return marketController
                                                                  .markets
                                                                  .where((MarketModel
                                                                          market) =>
                                                                      market
                                                                          .userId ==
                                                                      profileController
                                                                          .myProfile
                                                                          .uid)
                                                                  .isEmpty
                                                              ? Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: <Widget>[
                                                                    SvgPicture
                                                                        .asset(
                                                                      'assets/svgs/store.svg',
                                                                      height:
                                                                          40,
                                                                      colorFilter:
                                                                          const ColorFilter
                                                                              .mode(
                                                                        Colors
                                                                            .grey,
                                                                        BlendMode
                                                                            .srcIn,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    const Text(
                                                                      'No items found in your listing',
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w700,
                                                                        fontSize:
                                                                            15,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          50,
                                                                    ),
                                                                  ],
                                                                )
                                                              : ListView
                                                                  .builder(
                                                                  physics:
                                                                      const NeverScrollableScrollPhysics(),
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemCount: marketController
                                                                      .markets
                                                                      .where((MarketModel
                                                                              market) =>
                                                                          market
                                                                              .userId ==
                                                                          profileController
                                                                              .myProfile
                                                                              .uid)
                                                                      .length,
                                                                  itemBuilder:
                                                                      (BuildContext
                                                                              context,
                                                                          int index) {
                                                                    final List<MarketModel> filteredMarkets = marketController
                                                                        .markets
                                                                        .where((MarketModel
                                                                                market) =>
                                                                            market.userId ==
                                                                            profileController.myProfile.uid)
                                                                        .toList();
                                                                    final MarketModel
                                                                        market =
                                                                        filteredMarkets[
                                                                            index];

                                                                    return market
                                                                            .isProduct
                                                                        ? MarketTile(
                                                                            post:
                                                                                market,
                                                                            controller:
                                                                                marketController,
                                                                            key:
                                                                                ValueKey<String>(market.marketId),
                                                                          )
                                                                        : ServiceTile(
                                                                            post:
                                                                                market,
                                                                            controller:
                                                                                marketController,
                                                                            key:
                                                                                ValueKey<String>(market.marketId),
                                                                          );
                                                                  },
                                                                );
                                                        },
                                                      ),
                                                    ),

                                          ///Forum or Resources
                                          if (homeController
                                              .userresources.isNotEmpty)
                                            SizedBox(
                                              height: double.infinity,
                                              width: double.infinity,
                                              child: Obx(
                                                () {
                                                  return ListView.builder(
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount: homeController
                                                        .userresources.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int i) {
                                                      return ForumItem(
                                                        forum: homeController
                                                            .userresources[i],
                                                        controller:
                                                            homeController,
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ),

                                          ///Donations
                                          if (homeController
                                              .userdonations.isNotEmpty)
                                            SizedBox(
                                              height: double.infinity,
                                              width: double.infinity,
                                              child: Obx(
                                                () {
                                                  return homeController
                                                          .userdonations.isEmpty
                                                      ? Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            SvgPicture.asset(
                                                              'assets/svgs/supporter.svg',
                                                              height: 40,
                                                              colorFilter:
                                                                  const ColorFilter
                                                                      .mode(
                                                                Colors.grey,
                                                                BlendMode.srcIn,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            const Text(
                                                              'No Crowdfunds Found',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 15,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 50,
                                                            ),
                                                          ],
                                                        )
                                                      : ListView.builder(
                                                          physics:
                                                              const NeverScrollableScrollPhysics(),
                                                          shrinkWrap: true,
                                                          itemCount:
                                                              homeController
                                                                  .userdonations
                                                                  .length,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int i) {
                                                            bool isLastItem = homeController
                                                                        .userdonations
                                                                        .length !=
                                                                    1
                                                                ? i ==
                                                                    homeController
                                                                            .userdonations
                                                                            .length -
                                                                        1
                                                                : i ==
                                                                    homeController
                                                                        .userdonations
                                                                        .length;
                                                            return DonationItem(
                                                              donation:
                                                                  homeController
                                                                      .userdonations[i],
                                                              isLastItem:
                                                                  isLastItem,
                                                            );
                                                          },
                                                        );
                                                },
                                              ),
                                            ),

                                          ///Courses
                                          if (homeController
                                              .usercourses.isNotEmpty)
                                            SizedBox(
                                              height: double.infinity,
                                              width: double.infinity,
                                              child: Obx(
                                                () {
                                                  return homeController
                                                          .loading.value
                                                      ? const Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        )
                                                      : homeController
                                                              .cError.value
                                                          ? Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: <Widget>[
                                                                SvgPicture
                                                                    .asset(
                                                                  'assets/svgs/courses.svg',
                                                                  height: 40,
                                                                  colorFilter:
                                                                      const ColorFilter
                                                                          .mode(
                                                                    Colors.grey,
                                                                    BlendMode
                                                                        .srcIn,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),
                                                                const Text(
                                                                  'Error Loading Courses!',
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    fontSize:
                                                                        15,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  height: 50,
                                                                ),
                                                              ],
                                                            )
                                                          : homeController
                                                                  .usercourses
                                                                  .isEmpty
                                                              ? Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: <Widget>[
                                                                    SvgPicture
                                                                        .asset(
                                                                      'assets/svgs/courses.svg',
                                                                      height:
                                                                          40,
                                                                      colorFilter:
                                                                          const ColorFilter
                                                                              .mode(
                                                                        Colors
                                                                            .grey,
                                                                        BlendMode
                                                                            .srcIn,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    const Text(
                                                                      'No Courses Found',
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w700,
                                                                        fontSize:
                                                                            15,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          50,
                                                                    ),
                                                                  ],
                                                                )
                                                              : ListView
                                                                  .builder(
                                                                  physics:
                                                                      const NeverScrollableScrollPhysics(),
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemCount:
                                                                      homeController
                                                                          .usercourses
                                                                          .length,
                                                                  itemBuilder:
                                                                      (BuildContext
                                                                              context,
                                                                          int i) {
                                                                    return CourseItem(
                                                                      course: homeController
                                                                          .usercourses[i],
                                                                    );
                                                                  },
                                                                );
                                                },
                                              ),
                                            )
                                        ]),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            BottomBar(
                              activeIndex: 4,
                            )
                          ],
                        ),
                      ),
                      // profileController.myProfile.isSubscribed
                      //     ?
                      SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Bottomnavscreen(
                          initialindex: 0,
                          onTabChanged: (int index) {
                            setState(
                              () {
                                _selectedIndex = index;
                              },
                            );
                          },
                        ),
                      )
                      // :
                      // // Center(
                      // //     child: SingleChildScrollView(
                      // //       child: Column(
                      // //         mainAxisAlignment: MainAxisAlignment.center,
                      // //         crossAxisAlignment: CrossAxisAlignment.center,
                      // //         children: <Widget>[
                      // //           const Text(
                      // //             'Upgrade now to unlock \nBiz-Centre',
                      // //             style: TextStyle(
                      // //               fontSize: 18,
                      // //               fontWeight: FontWeight.w700,
                      // //             ),
                      // //             textAlign: TextAlign.center,
                      // //           ),
                      // //           const SizedBox(
                      // //             height: 30,
                      // //           ),
                      // //           Lottie.asset(
                      // //             'assets/anim/padlock.json',
                      // //             fit: BoxFit.cover,
                      // //             height: 90,
                      // //             width: 90,
                      // //           ),
                      // //           const SizedBox(
                      // //             height: 30,
                      // //           ),
                      // //           const Padding(
                      // //               padding: EdgeInsets.only(
                      // //                   left: 0.0, top: 10, bottom: 10),
                      // //               child: ProSubscribeSection(
                      // //                 isGrow: true,
                      // //               )),
                      // //         ],
                      // //       ),
                      // //     ),
                      // //   ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  int calculateTabLength() {
    int tabLength = 2;

    if (marketController.markets
        .where((MarketModel market) =>
            market.userId == profileController.myProfile.uid)
        .isNotEmpty) {
      tabLength++;
    }
    if (homeController.userresources.isNotEmpty) tabLength++;
    if (homeController.userdonations.isNotEmpty) tabLength++;
    if (homeController.usercourses.isNotEmpty) tabLength++;

    return tabLength;
  }
}
