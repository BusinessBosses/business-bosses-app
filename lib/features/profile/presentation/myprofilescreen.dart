import 'package:business_bosses_v2/bbpro/presentation/bottomnavscreen.dart';
import 'package:business_bosses_v2/bbpro/presentation/setupshop.dart';
import 'package:business_bosses_v2/bbpro/presentation/shopscreen.dart';
import 'package:business_bosses_v2/features/forum/widgets/forum_item.dart';
import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/donations/widgets/donation_item.dart';
import 'package:business_bosses_v2/features/home/widgets/bottom_bar.dart';
import 'package:business_bosses_v2/features/home/widgets/course_item.dart';
import 'package:business_bosses_v2/features/home/widgets/home_appbar.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/features/profile/widgets/profileinfodisplay.dart';
import 'package:business_bosses_v2/features/live_event/controller/live_event_controller.dart';
import 'package:business_bosses_v2/features/profile/widgets/profilepostsdisplay.dart';
import 'package:business_bosses_v2/features/withdrawal/presentation/withdrawalscreen.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_svg/svg.dart';
import 'package:business_bosses_v2/features/live_event/widgets/my_events.dart';
import 'package:get/get.dart';
import '../../../common/widgets/tiles/outlinebuttonheader.dart';
import '../../../navigation/routes.dart';
import '../../marketplace/controllers/market_controller.dart';
import '../../marketplace/models/market_model.dart';
import '../../marketplace/widgets/marketplace_item.dart';
import '../../marketplace/widgets/service_item.dart';
import '../widgets/my_profile_header.dart';

bool isExpanded = false;

// ignore: public_member_api_docs
class MyProfileScreen extends StatefulWidget {
  // ignore: public_member_api_docs
  static const String routeName = '/my-profile-screen';

  // ignore: public_member_api_docs
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final ProfileController profileController = Get.find();
  final MarketController marketController = Get.find();
  final HomeController homeController = Get.find();
  final LiveController liveEventController = Get.put(LiveController());

  bool isScrolled = true;

  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    return GetBuilder<ProfileController>(
      builder: (ProfileController profileController) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight - 10),
            child: Stack(children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: CupertinoSlidingSegmentedControl<int>(
                      backgroundColor: Colors.grey[200]!,
                      padding: const EdgeInsets.all(5),
                      children: <int, Widget>{
                        0: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Text('Profile',
                              style: _currentIndex == 0
                                  ? const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    )
                                  : const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.grey)),
                        ),
                        1: Text('My-Biz',
                            style: _currentIndex == 1
                                ? const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14)
                                : const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.grey)),
                      },
                      onValueChanged: (int? value) {
                        if (value != null) {
                          setState(() {
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
                  const SizedBox(height: 10.0),
                ],
              ),
              if (_currentIndex == 0)
                Positioned(
                    bottom: 10,
                    right: 0,
                    child: IconButton(
                      icon: SvgPicture.asset(
                        'assets/svgs/settings.svg',
                        height: 24.0,
                      ),
                      onPressed: () {
                        Get.toNamed(Routes.settings);
                      },
                    )),
              if (_currentIndex == 0)
                Positioned(
                    bottom: 10,
                    left: 0,
                    child: IconButton(
                      onPressed: () {
                        Get.to(() => const MyEvents(
                              toHome: true,
                            ));
                      },
                      icon: const Icon(Icons.calendar_month),
                    )),
            ]),
          ),
          body: PageView(
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
                          headerSliverBuilder:
                              (BuildContext context, bool innerBoxIsScrolled) {
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
                                    context, profileController.myProfile),
                                const SizedBox(height: 15.0),
                                // },

                                const SizedBox(
                                  width: double.infinity,
                                  height: 1.5,
                                  child: ColoredBox(
                                      color: backgroundcolorinterface),
                                ),
                                Material(
                                  color: const Color(0xFFF9F9F9),
                                  child: TabBar(
                                    isScrollable: calculateTabLength() <= 4
                                        ? false
                                        : true,
                                    indicatorColor:
                                        primaryColorLT, // Replace primaryColorLT with the desired color
                                    labelStyle: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                    labelColor: Colors.black,
                                    tabs: <Widget>[
                                      const Tab(
                                        text: 'About',
                                      ),
                                      const Tab(
                                        text: 'Posts',
                                      ),
                                      if (marketController.markets
                                          .where((MarketModel market) =>
                                              market.userId ==
                                              profileController.myProfile.uid)
                                          .isNotEmpty)
                                        const Tab(text: 'Shop'),
                                      if (homeController
                                          .userresources.isNotEmpty)
                                        const Tab(text: 'Resources'),
                                      if (homeController
                                          .userdonations.isNotEmpty)
                                        const Tab(text: 'Donations'),
                                      if (homeController.usercourses.isNotEmpty)
                                        const Tab(text: 'Courses'),
                                    ],
                                  ),
                                ),

                                const SizedBox(
                                  width: double.infinity,
                                  height: 1.5,
                                  child: ColoredBox(
                                      color: backgroundcolorinterface),
                                ), // Container(

                                Expanded(
                                  child: TabBarView(children: <Widget>[
                                    NotificationListener<ScrollNotification>(
                                      onNotification:
                                          (ScrollNotification notification) {
                                        if (notification
                                            is ScrollUpdateNotification) {
                                          if (notification.dragDetails !=
                                                  null &&
                                              notification.dragDetails!
                                                      .primaryDelta !=
                                                  null) {
                                            double primaryDelta = notification
                                                .dragDetails!.primaryDelta!;

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
                                            profileinfodisplay(context,
                                                profileController.myProfile),
                                          ],
                                        ),
                                      ),
                                    ),
                                    NotificationListener<ScrollNotification>(
                                      onNotification:
                                          (ScrollNotification notification) {
                                        if (notification
                                            is ScrollUpdateNotification) {
                                          if (notification.dragDetails !=
                                                  null &&
                                              notification.dragDetails!
                                                      .primaryDelta !=
                                                  null) {
                                            double primaryDelta = notification
                                                .dragDetails!.primaryDelta!;

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
                                      child: profilepostsdisplay(
                                        ispublicposts: false,
                                        context,
                                        profileController.myProfile,
                                        profileController.posts,
                                        loading:
                                            profileController.isLoading.value,
                                      ),
                                    ),

                                    ///Marketplace

                                    if (marketController.markets
                                        .where((MarketModel market) =>
                                            market.userId ==
                                            profileController.myProfile.uid)
                                        .isNotEmpty)
                                      profileController.myProfile.isSubscribed
                                          ? const ShopScreen()
                                          : SizedBox(
                                              height: double.infinity,
                                              width: double.infinity,
                                              child: Obx(() {
                                                return marketController.markets
                                                        .where((MarketModel
                                                                market) =>
                                                            market.userId ==
                                                            profileController
                                                                .myProfile.uid)
                                                        .isEmpty
                                                    ? Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          SvgPicture.asset(
                                                            'assets/svgs/store.svg',
                                                            height: 40,
                                                            color: Colors.grey,
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          const Text(
                                                            'No Items Found in your Shop',
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
                                                        itemCount: marketController
                                                            .markets
                                                            .where((MarketModel
                                                                    market) =>
                                                                market.userId ==
                                                                profileController
                                                                    .myProfile
                                                                    .uid)
                                                            .length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          final List<
                                                                  MarketModel>
                                                              filteredMarkets =
                                                              marketController
                                                                  .markets
                                                                  .where((MarketModel
                                                                          market) =>
                                                                      market
                                                                          .userId ==
                                                                      profileController
                                                                          .myProfile
                                                                          .uid)
                                                                  .toList();
                                                          final MarketModel
                                                              market =
                                                              filteredMarkets[
                                                                  index];

                                                          return market
                                                                  .isProduct
                                                              ? MarketTile(
                                                                  post: market,
                                                                  controller:
                                                                      marketController,
                                                                  key: ValueKey(
                                                                      market
                                                                          .marketId),
                                                                )
                                                              : ServiceTile(
                                                                  post: market,
                                                                  controller:
                                                                      marketController,
                                                                  key: ValueKey(
                                                                      market
                                                                          .marketId),
                                                                );
                                                        },
                                                      );
                                              })),

                                    ///Forum or Resources
                                    if (homeController.userresources.isNotEmpty)
                                      SizedBox(
                                          height: double.infinity,
                                          width: double.infinity,
                                          child: Obx(() {
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
                                                  controller: homeController,
                                                );
                                              },
                                            );
                                          })),

                                    ///Donations
                                    if (homeController.userdonations.isNotEmpty)
                                      SizedBox(
                                          height: double.infinity,
                                          width: double.infinity,
                                          child: Obx(() {
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
                                                        color: Colors.grey,
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      const Text(
                                                        'No Crowdfunds Found',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
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
                                                    itemCount: homeController
                                                        .userdonations.length,
                                                    itemBuilder:
                                                        (BuildContext context,
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
                                                        donation: homeController
                                                            .userdonations[i],
                                                        isLastItem: isLastItem,
                                                      );
                                                    },
                                                  );
                                          })),

                                    ///Courses
                                    if (homeController.usercourses.isNotEmpty)
                                      SizedBox(
                                        height: double.infinity,
                                        width: double.infinity,
                                        child: Obx(() {
                                          return homeController.loading.value
                                              ? const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                )
                                              : homeController.cError.value
                                                  ? Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        SvgPicture.asset(
                                                          'assets/svgs/courses.svg',
                                                          height: 40,
                                                          color: Colors.grey,
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        const Text(
                                                          'Error Loading Courses!',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 50,
                                                        ),
                                                      ],
                                                    )
                                                  : homeController
                                                          .usercourses.isEmpty
                                                      ? Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            SvgPicture.asset(
                                                              'assets/svgs/courses.svg',
                                                              height: 40,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            const Text(
                                                              'No Courses Found',
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
                                        }),
                                      )
                                  ]),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const BottomBar(
                        activeIndex: 4,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: const Bottomnavscreen(),
                )
              ]),
        );
      },
    );
  }

  int calculateTabLength() {
    int tabLength = 2;

    if (marketController.markets
        .where((MarketModel market) =>
            market.userId == profileController.myProfile.uid)
        .isNotEmpty) tabLength++;
    if (homeController.userresources.isNotEmpty) tabLength++;
    if (homeController.userdonations.isNotEmpty) tabLength++;
    if (homeController.usercourses.isNotEmpty) tabLength++;

    return tabLength;
  }
}
