import 'package:business_bosses_v2/features/donations/controller/donations_controller.dart';
import 'package:business_bosses_v2/features/donations/widgets/donation_item.dart';
import 'package:business_bosses_v2/features/home/widgets/bottom_bar.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/features/profile/widgets/profileinfodisplay.dart';
import 'package:business_bosses_v2/features/live_event/controller/live_event_controller.dart';
import 'package:business_bosses_v2/features/profile/widgets/profilepostsdisplay.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_svg/svg.dart';
import 'package:business_bosses_v2/features/live_event/widgets/my_events.dart';
import 'package:get/get.dart';
import '../../../common/widgets/safety_model.dart';
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
  final DonationsController donationsController =
      Get.put(DonationsController());
  final LiveController liveEventController = Get.put(LiveController());
  bool isScrolled = true;

  @override
  void initState() {
    super.initState();
    donationsController.userid = profileController.myProfile.uid;
    donationsController.onInit();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    return GetBuilder<ProfileController>(
      builder: (ProfileController profileController) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text('@${profileController.myProfile.username}'),
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  Get.to(() => const MyEvents(
                        toHome: true,
                      ));
                },
                icon: const Icon(Icons.calendar_month),
              ),
              IconButton(
                icon: SvgPicture.asset(
                  'assets/svgs/settings.svg',
                  height: 24.0,
                ),
                onPressed: () {
                  Get.toNamed(Routes.settings);
                },
              )
            ],
          ),
          body: SizedBox(
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
                      length: marketController.markets
                              .where((MarketModel market) =>
                                  market.userId ==
                                  profileController.myProfile.uid)
                              .isEmpty
                          ? 6
                          : 7,
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
                            child: ColoredBox(color: backgroundcolorinterface),
                          ),
                          Material(
                            color: const Color(0xFFF9F9F9),
                            child: TabBar(
                              isScrollable: true,
                              indicatorColor:
                                  primaryColorLT, // Replace primaryColorLT with the desired color
                              labelStyle:
                                  const TextStyle(fontWeight: FontWeight.w500),
                              labelColor: Colors.black,
                              tabs: marketController.markets
                                      .where((MarketModel market) =>
                                          market.userId ==
                                          profileController.myProfile.uid)
                                      .isEmpty
                                  ? <Widget>[
                                      const Tab(
                                        text: 'About',
                                      ),
                                      const Tab(
                                        text: 'Posts',
                                      ),
                                      const Tab(
                                        text: 'Resources',
                                      ),
                                      const Tab(
                                        text: 'Donations',
                                      ),
                                      const Tab(
                                        text: 'Courses',
                                      ),
                                      const Tab(
                                        text: 'Reposts',
                                      ),
                                    ]
                                  : <Widget>[
                                      const Tab(
                                        text: 'About',
                                      ),
                                      const Tab(
                                        text: 'Posts',
                                      ),
                                      const Tab(
                                        text: 'Shop',
                                      ),
                                      const Tab(
                                        text: 'Resources',
                                      ),
                                      const Tab(
                                        text: 'Donations',
                                      ),
                                      const Tab(
                                        text: 'Courses',
                                      ),
                                      const Tab(
                                        text: 'Reposts',
                                      ),
                                    ],
                            ),
                          ),

                          const SizedBox(
                            width: double.infinity,
                            height: 1.5,
                            child: ColoredBox(color: backgroundcolorinterface),
                          ),

                          Expanded(
                            child: TabBarView(
                                children: marketController.markets
                                        .where((MarketModel market) =>
                                            market.userId ==
                                            profileController.myProfile.uid)
                                        .isEmpty
                                    ? <Widget>[
                                        NotificationListener<
                                            ScrollNotification>(
                                          onNotification: (notification) {
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
                                          onNotification: (notification) {
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
                                          child: profilepostsdisplay(
                                            ispublicposts: false,
                                            context,
                                            profileController.myProfile,
                                            profileController.posts,
                                            loading: profileController
                                                .isLoading.value,
                                          ),
                                        ),
                                        Text('Resources'),
                                        SingleChildScrollView(
                                          child: Column(children: <Widget>[
                                            Obx(() {
                                              if (donationsController
                                                  .loading.value) {
                                                // While data is being fetched, show a loading indicator
                                                return const Padding(
                                                  padding: EdgeInsets.all(80.0),
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              } else if (donationsController
                                                  .error.value) {
                                                // If an error occurs during data fetching, show an error message
                                                return Text(
                                                    'Error occurred during data fetching');
                                              } else {
                                                // If data fetching is successful, build your UI with the fetched data
                                                // Ensure you're accessing the correct data in userdonations list
                                                return Container(
                                                  child: donationsController
                                                          .userdonations.isEmpty
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(80.0),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              SvgPicture.asset(
                                                                'assets/svgs/supporter.svg',
                                                                height: 40,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              const Text(
                                                                'No Donations Found',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontSize: 15,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      : Column(
                                                          children: [
                                                            Container(
                                                              child: ListView
                                                                  .builder(
                                                                physics:
                                                                    NeverScrollableScrollPhysics(),
                                                                shrinkWrap:
                                                                    true,
                                                                itemCount:
                                                                    donationsController
                                                                        .userdonations
                                                                        .length,
                                                                itemBuilder:
                                                                    (BuildContext
                                                                            context,
                                                                        int i) {
                                                                  // Sort the list based on the 'date' key in each map in descending order
                                                                  bool isLastItem = donationsController
                                                                              .userdonations
                                                                              .length !=
                                                                          1
                                                                      ? i ==
                                                                          donationsController.userdonations.length -
                                                                              1
                                                                      : i ==
                                                                          donationsController.userdonations.length;
                                                                  // Ensure you're using userdonations[i] instead of donations[i]
                                                                  return DonationItem(
                                                                    donation:
                                                                        donationsController
                                                                            .userdonations[i],
                                                                    isLastItem:
                                                                        isLastItem,
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                );
                                              }
                                            })
                                          ]),
                                        ),
                                        Text('Courses'),
                                        Text('Reposts'),
                                      ]
                                    : <Widget>[
                                        NotificationListener<
                                            ScrollNotification>(
                                          onNotification: (notification) {
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
                                          onNotification: (notification) {
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
                                          child: profilepostsdisplay(
                                            ispublicposts: false,
                                            context,
                                            profileController.myProfile,
                                            profileController.posts,
                                            loading: profileController
                                                .isLoading.value,
                                          ),
                                        ),
                                        Text('Resources'),
                                        SingleChildScrollView(
                                          child: Column(
                                            children: <Widget>[
                                              Obx(() {
                                                return marketController.markets
                                                        .where((MarketModel
                                                                market) =>
                                                            market.userId ==
                                                            profileController
                                                                .myProfile.uid)
                                                        .isEmpty
                                                    ? const SafetyModel(
                                                        isLoading: false,
                                                        icon: Icon(
                                                          Icons.warning,
                                                          color: Colors.grey,
                                                          size: 80.0,
                                                        ),
                                                        title:
                                                            'This user has no items in store',
                                                        // subTitle: '',
                                                      )
                                                    : NotificationListener<
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
                                                                setState(() {
                                                                  isScrolled =
                                                                      true;
                                                                });
                                                              } else if (primaryDelta <
                                                                  0) {
                                                                // Scrolling upward
                                                                setState(() {
                                                                  isScrolled =
                                                                      false;
                                                                });
                                                              }
                                                            }
                                                          }

                                                          return true;
                                                        },
                                                        child: ListView.builder(
                                                          shrinkWrap: true,
                                                          physics:
                                                              const NeverScrollableScrollPhysics(),
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
                                                                    post:
                                                                        market,
                                                                    controller:
                                                                        marketController,
                                                                    key: ValueKey(
                                                                        market
                                                                            .marketId),
                                                                  )
                                                                : ServiceTile(
                                                                    post:
                                                                        market,
                                                                    controller:
                                                                        marketController,
                                                                    key: ValueKey(
                                                                        market
                                                                            .marketId),
                                                                  );
                                                          },
                                                        ),
                                                      );
                                              }),
                                              const SizedBox(
                                                height: 100,
                                              )
                                            ],
                                          ),
                                        ),
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
        );
      },
    );
  }
}
