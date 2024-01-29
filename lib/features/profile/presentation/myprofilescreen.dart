import 'dart:io';

import 'package:business_bosses_v2/features/home/sellProduct.dart';
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
  final LiveController liveEventController = Get.put(LiveController());
  bool isScrolled = true;

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    return GetBuilder<ProfileController>(
      builder: (ProfileController profileController) {
        return Scaffold(
          backgroundColor: Colors.white,
          floatingActionButton: FloatingActionButton.extended(
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
                                itemBuilder: (BuildContext context, int index) {
                                  return ListTile(
                                    onTap: () {
                                      Navigator.pop(context);
                                      index == 0
                                          ? Get.toNamed(Routes.createPost)
                                          : index == 1
                                              ? sellProduct(context)
                                              : Get.toNamed(Routes.createevent);
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
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text('@${profileController.myProfile.username}'),
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  Get.to(() => const MyEvents());
                },
                icon: const Icon(Icons.calendar_month),
              ),
              IconButton(
                icon: SvgPicture.asset(
                  'assets/svgs/settings.svg',
                  height: 24.0,
                ),
                onPressed: () {
                  // Navigator.pushNamed(context, '/settingsScreen');
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
                          ? 2
                          : 3,
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
                                    ],
                            ),
                          ),

                          const SizedBox(
                            width: double.infinity,
                            height: 1.5,
                            child: ColoredBox(color: backgroundcolorinterface),
                          ), // Container(

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
                                                is ScrollStartNotification) {
                                              // Scrolling started
                                              setState(() {
                                                isScrolled = false;
                                              });
                                            } else if (notification
                                                is ScrollEndNotification) {
                                              // Scrolling stopped
                                              setState(() {
                                                isScrolled = true;
                                              });
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
                                                is ScrollStartNotification) {
                                              // Scrolling started
                                              setState(() {
                                                isScrolled = false;
                                              });
                                            } else if (notification
                                                is ScrollEndNotification) {
                                              // Scrolling stopped
                                              setState(() {
                                                isScrolled = true;
                                              });
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
                                      ]
                                    : <Widget>[
                                        NotificationListener<
                                            ScrollNotification>(
                                          onNotification: (notification) {
                                            if (notification
                                                is ScrollStartNotification) {
                                              // Scrolling started
                                              setState(() {
                                                isScrolled = false;
                                              });
                                            } else if (notification
                                                is ScrollEndNotification) {
                                              // Scrolling stopped
                                              setState(() {
                                                isScrolled = true;
                                              });
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
                                                is ScrollStartNotification) {
                                              // Scrolling started
                                              setState(() {
                                                isScrolled = false;
                                              });
                                            } else if (notification
                                                is ScrollEndNotification) {
                                              // Scrolling stopped
                                              setState(() {
                                                isScrolled = true;
                                              });
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
                                                              is ScrollStartNotification) {
                                                            // Scrolling started
                                                            setState(() {
                                                              isScrolled =
                                                                  false;
                                                            });
                                                          } else if (notification
                                                              is ScrollEndNotification) {
                                                            // Scrolling stopped
                                                            setState(() {
                                                              isScrolled = true;
                                                            });
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
                // BottomBar(
                //   activeIndex: 4,
                //   homePageKey: phomePageKey,
                //   bossupPageKey: pbossupPageKey,
                //   liveEventPageKey: pliveEventPageKey,
                //   marketPlacePageKey: pmarketPlacePageKey,
                //   profilePageKey: pprofilePageKey,
                // )
              ],
            ),
          ),
        );
      },
    );
  }
}
