import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/common/widgets/text_widget.dart';
import 'package:business_bosses_v2/features/courses/models/course_model.dart';
import 'package:business_bosses_v2/features/home/widgets/course_item.dart';
import 'package:business_bosses_v2/features/forum/controller/challenge_controller.dart';
import 'package:business_bosses_v2/features/home/controller/commumities_controller.dart';
import 'package:business_bosses_v2/features/home/widgets/bottom_bar.dart';
import 'package:business_bosses_v2/features/home/widgets/floatingbutton.dart';
import 'package:business_bosses_v2/features/home/widgets/forum_item.dart';
import 'package:business_bosses_v2/features/live_event/controller/live_event_controller.dart';
import 'package:business_bosses_v2/features/donations/controller/donations_controller.dart';
import 'package:business_bosses_v2/features/live_event/presentation/live_event.dart';
import 'package:business_bosses_v2/features/marketplace/models/market_model.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/marketplace_item.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/service_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:upgrader/upgrader.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../utils/constants/constants.dart';
import '../../utils/theme/theme.dart';
import '../chat/controllers/chat_controller.dart';
import '../chat/models/my_message.dart';
import '../home/controller/home_controller.dart';
import '../home/widgets/home_appbar.dart';
import '../marketplace/controllers/market_controller.dart';
import '../posts/models/post_model.dart';
import '../posts/widgets/userpost_tile.dart';
import '../profile/controller/profile_controller.dart';
import '../profile/widgets/boss_of_the_week_tile.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.onPageChange});

  final Function(int)? onPageChange;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  final HomeController homeController = Get.put(HomeController());
  final ProfileController _profileController = Get.find();
  final LiveController liveEventController = Get.put(LiveController());
  final ChallengeController challengeController =
      Get.put(ChallengeController());
  final DonationsController donationsController =
      Get.put(DonationsController());
  late io.Socket socket;
  bool isScrolled = true;
  bool isTabVisible = false;
  late TabController _tabController;

  // List<TargetFocus> targets = [];

  // int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
  // final GetStorage sandBox = GetStorage();
  final ScrollController _scrollController = ScrollController();
  final MarketController marketController = Get.put(MarketController());
  final CommunitiesController _communitiesController =
      Get.put(CommunitiesController());

  int marketIndex = 0;
  // final GlobalKey<NavigatorState> postButtonKey = GlobalKey<NavigatorState>();
  void _checkScrollPosition() {
    if (_scrollController.position.pixels >= 230) {
      setState(() {
        isTabVisible = true;
      });
    } else {
      setState(() {
        isTabVisible = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    WidgetsBinding.instance.addObserver(this);
    // showTutorial();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? tutorialShown = prefs.getString('tutorialShown');
      if (tutorialShown == null || tutorialShown.isEmpty) {
        // showTutorial();
        await prefs.setString('tutorialShown', 'true');
      }
    });
    final HomeController homeController = Get.find();

    void checkScrollPosition() {
      if (_scrollController.position.pixels >= 230) {
        setState(() {
          isTabVisible = true;
        });
      } else {
        setState(() {
          isTabVisible = false;
        });
      }
    }

    _scrollController.addListener(() {
      checkScrollPosition();
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 300 &&
          !homeController.loadingMore.value) {
        homeController.fetchPosts();
      }
    });

    // Function to establish the WebSocket connection
    void connectSocket() {
      socket = io.io(Constants.socketUrl, <String, dynamic>{
        'transports': <String>['websocket'],
      });

      socket.onConnect((_) {
        print('Connection established');
      });

      socket.on('newPostEvent', (data) {
        final int postIndex = homeController.mixedPosts.indexWhere(
            (Map<String, dynamic> element) =>
                element['shouldCount'] == null &&
                !element['isForum'] &&
                element['data'].postId == data['newPost']['postId']);
        if (postIndex == -1) {
          homeController.sinkPosts(data);
        }
      });

      socket.onDisconnect((_) {
        print('Connection Disconnection');
        // Reconnect the socket when it's disconnected
        Future.delayed(const Duration(seconds: 5), () {
          connectSocket();
        });
      });

      socket.onConnectError((err) {
        print(err);
        // Handle connection errors as needed
      });

      socket.onError((err) {
        print(err);
        // Handle socket errors as needed
      });
    }

    // Initial connection
    connectSocket();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final HomeController homeController = Get.find();

    if (state.index == 0) {
      homeController.fetchPosts(fromBackground: true);
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    socket.off('newPostEvent'); // Remove the listener
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Exit App'),
                content: const Text('Are you sure you want to exit?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text('Yes'),
                  ),
                ],
              );
            }).then((dynamic exit) {
          if (exit == true) {
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          }
        });
        return false;
      },
      child: GetBuilder<HomeController>(
        builder: (HomeController controller) {
          return UpgradeAlert(
            child: Scaffold(
              backgroundColor: backgroundcolorinterface,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight + 48),
                child: GetBuilder<ChatController>(
                    builder: (ChatController chatController) {
                  final List<MessageModel> unseenChats = chatController.chats
                      .where((MessageModel element) =>
                          element.receiverUid ==
                              controller.profileController.myProfile.uid &&
                          !element.seen)
                      .toList();
                  final bool hasBadge = unseenChats.isNotEmpty;
                  return GetBuilder<ProfileController>(
                    builder: (ProfileController profileController) =>
                        Homeappbar(
                      isTabVisible: isTabVisible,
                      hasBadge: hasBadge,
                      coinsCount:
                          profileController.myProfile.coinscount?.toString() ??
                              '',
                      hasUnreadNotification:
                          profileController.myProfile.unReadCount != null &&
                              profileController.myProfile.unReadCount! > 0,
                    ),
                  );
                }),
              ),
              body: controller.loading.value
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    'assets/app/app_logo_2.png',
                                    height: 40,
                                    width: 40,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 45,
                                height: 45,
                                child: CircularProgressIndicator(),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Text(
                              'Start, Grow and Promote Your Business Globally',
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        ],
                      ),
                    )
                  : controller.noConnection.value
                      ? SafetyModel(
                          isLoading: false,
                          title:
                              'Error While Loading Data\nCheck your Internet Connection',
                          subTitle: 'Try Reloading Again',
                          clickableText: 'Refresh',
                          onTap: () {
                            controller.loadData();
                            _profileController.fetchData();
                            _profileController.loadBoss();
                            marketController.initMarket();
                            marketController.initUsers();
                            _communitiesController.fetchIndustries();
                            liveEventController.initEvents();
                          },
                          icon: const Icon(
                            Icons.warning,
                            size: 60,
                          ),
                        )
                      : controller.error.value
                          ? SafetyModel(
                              isLoading: false,
                              title: 'Error While Loading Data',
                              subTitle: 'Try Reloading Again',
                              clickableText: 'Refresh',
                              onTap: () {
                                controller.loadData();
                                _profileController.fetchData();
                                _profileController.loadBoss();
                                marketController.initMarket();
                                marketController.initUsers();
                                _communitiesController.fetchIndustries();
                                liveEventController.initEvents();
                              },
                              icon: const Icon(
                                Icons.warning,
                                size: 60,
                              ),
                            )
                          : SizedBox(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    height: MediaQuery.of(context).size.height,
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.white,
                                    child: RefreshIndicator(
                                      onRefresh: controller.loadData,
                                      child: NotificationListener<
                                          ScrollNotification>(
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
                                        child: NestedScrollView(
                                          controller: _scrollController,
                                          headerSliverBuilder:
                                              (BuildContext context,
                                                  bool innerBoxIsScrolled) {
                                            return <Widget>[
                                              SliverStickyHeader(
                                                sticky: false,
                                                header: Container(
                                                  color:
                                                      backgroundcolorinterface,
                                                  child: LayoutBuilder(
                                                    builder:
                                                        (BuildContext context,
                                                            BoxConstraints
                                                                constraints) {
                                                      return BossOfWeekProfileTile(
                                                        onTileBuilt: () {
                                                          _checkScrollPosition();
                                                        },
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ];
                                          },
                                          body: Column(
                                            children: [
                                              Visibility(
                                                visible: isTabVisible,
                                                child: Material(
                                                  elevation: 0.1,
                                                  color: Colors.white,
                                                  child: DefaultTabController(
                                                    length: 2,
                                                    child: TabBar(
                                                      controller:
                                                          _tabController,
                                                      tabs: <Widget>[
                                                        Tab(
                                                          child: FittedBox(
                                                            child: Text(
                                                              'For you',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyLarge,
                                                            ),
                                                          ),
                                                        ),
                                                        Tab(
                                                          child: FittedBox(
                                                            child: Text(
                                                              'Following',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyLarge,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: TabBarView(
                                                    controller: _tabController,
                                                    children: [
                                                      ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount: controller
                                                            .mixedPosts.length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          if (index == 0) {
                                                            return Column(
                                                              children: <Widget>[
                                                                if (liveEventController
                                                                    .ongoing
                                                                    .isNotEmpty)
                                                                  Container(
                                                                    decoration:
                                                                        const BoxDecoration(
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          26,
                                                                          26,
                                                                          26),
                                                                    ),
                                                                    margin: const EdgeInsets
                                                                        .only(
                                                                        bottom:
                                                                            6),
                                                                    child: Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center, // Adjust alignment as needed
                                                                      children: <Widget>[
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              15.0),
                                                                          child:
                                                                              Lottie.asset(
                                                                            'assets/anim/liveevent.json',
                                                                            height:
                                                                                25,
                                                                          ),
                                                                        ),
                                                                        const Expanded(
                                                                          child:
                                                                              TextScroll(
                                                                            '     Live Events - Create or Start listening to live events from bosses.           ',
                                                                            mode:
                                                                                TextScrollMode.bouncing,
                                                                            style:
                                                                                TextStyle(color: Colors.white, fontSize: 15),
                                                                            velocity:
                                                                                Velocity(
                                                                              pixelsPerSecond: Offset(30, 0),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              right: 15.0),
                                                                          child:
                                                                              ElevatedButton(
                                                                            style:
                                                                                ButtonStyle(
                                                                              backgroundColor: MaterialStateProperty.all<Color>(Colors.grey.shade300),
                                                                            ),
                                                                            onPressed: () =>
                                                                                Get.to(() => const LiveEvent()),
                                                                            child:
                                                                                const Text(
                                                                              'Live Events',
                                                                              style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )
                                                              ],
                                                            );
                                                          }

                                                          final dynamic
                                                              currentPost =
                                                              controller
                                                                      .mixedPosts[
                                                                  index];
                                                          if (currentPost[
                                                                  'type'] ==
                                                              'post') {
                                                            final PostModel
                                                                post =
                                                                controller
                                                                        .posts[
                                                                    currentPost[
                                                                        'index']];

                                                            // Handle regular non-promoted PostModel
                                                            final PostModel
                                                                nonPromotedPostModel =
                                                                post;
                                                            final bool
                                                                hasIncrementedView =
                                                                controller
                                                                    .itemsWithIncrementedViews
                                                                    .contains(
                                                                        nonPromotedPostModel
                                                                            .postId);
                                                            return VisibilityDetector(
                                                              key: Key(index
                                                                  .toString()),
                                                              onVisibilityChanged:
                                                                  (VisibilityInfo
                                                                      info) {
                                                                if (info.visibleFraction ==
                                                                        1.0 &&
                                                                    !hasIncrementedView) {
                                                                  controller
                                                                      .updateViews(
                                                                          nonPromotedPostModel);
                                                                  setState(() {
                                                                    controller
                                                                        .itemsWithIncrementedViews
                                                                        .add(nonPromotedPostModel
                                                                            .postId);
                                                                  });
                                                                }
                                                              },
                                                              child: PostTile(
                                                                controller:
                                                                    controller,
                                                                post:
                                                                    nonPromotedPostModel,
                                                                onPageChange:
                                                                    (int page) {
                                                                  if (widget
                                                                          .onPageChange !=
                                                                      null) {
                                                                    widget.onPageChange!(
                                                                        page);
                                                                  }
                                                                },
                                                              ),
                                                            );
                                                          } else if (currentPost[
                                                                  'type'] ==
                                                              'promotedPost') {
                                                            final PostModel
                                                                post =
                                                                controller
                                                                        .promotedPosts[
                                                                    currentPost[
                                                                        'index']];

                                                            // Handle regular non-promoted PostModel
                                                            final PostModel
                                                                promotedPostModel =
                                                                post;
                                                            final bool
                                                                hasIncrementedView =
                                                                controller
                                                                    .itemsWithIncrementedViews
                                                                    .contains(
                                                                        promotedPostModel
                                                                            .postId);
                                                            return VisibilityDetector(
                                                              key: Key(index
                                                                  .toString()),
                                                              onVisibilityChanged:
                                                                  (VisibilityInfo
                                                                      info) {
                                                                if (info.visibleFraction ==
                                                                        1.0 &&
                                                                    !hasIncrementedView) {
                                                                  controller
                                                                      .updateViews(
                                                                          promotedPostModel);
                                                                  setState(() {
                                                                    controller
                                                                        .itemsWithIncrementedViews
                                                                        .add(promotedPostModel
                                                                            .postId);
                                                                  });
                                                                }
                                                              },
                                                              child: PostTile(
                                                                controller:
                                                                    controller,
                                                                post:
                                                                    promotedPostModel,
                                                                onPageChange:
                                                                    (int page) {
                                                                  if (widget
                                                                          .onPageChange !=
                                                                      null) {
                                                                    widget.onPageChange!(
                                                                        page);
                                                                  }
                                                                },
                                                              ),
                                                            );
                                                          } else if (currentPost[
                                                                  'type'] ==
                                                              'market') {
                                                            final MarketModel
                                                                post =
                                                                controller
                                                                        .promotedMarkets[
                                                                    currentPost[
                                                                        'index']];

                                                            // Handle regular non-promoted PostModel
                                                            final MarketModel
                                                                marketModel =
                                                                post;
                                                            final bool
                                                                hasIncrementedView =
                                                                controller
                                                                    .itemsWithIncrementedViews
                                                                    .contains(
                                                                        marketModel
                                                                            .marketId);
                                                            return VisibilityDetector(
                                                              key: Key(index
                                                                  .toString()),
                                                              onVisibilityChanged:
                                                                  (VisibilityInfo
                                                                      info) {
                                                                if (info.visibleFraction ==
                                                                        1.0 &&
                                                                    !hasIncrementedView) {
                                                                  marketController
                                                                      .updatemarketViews(
                                                                          marketModel);
                                                                  setState(() {
                                                                    controller
                                                                        .itemsWithIncrementedViews
                                                                        .add(marketModel
                                                                            .marketId);
                                                                  });
                                                                }
                                                              },
                                                              child: marketModel
                                                                      .isProduct
                                                                  ? MarketTile(
                                                                      controller:
                                                                          controller,
                                                                      post:
                                                                          marketModel,
                                                                    )
                                                                  : ServiceTile(
                                                                      controller:
                                                                          controller,
                                                                      post:
                                                                          marketModel,
                                                                    ),
                                                            );
                                                          } else if (currentPost[
                                                                  'type'] ==
                                                              'course') {
                                                            final CourseModel
                                                                post =
                                                                controller
                                                                        .promotedCourses[
                                                                    currentPost[
                                                                        'index']];

                                                            // Handle regular non-promoted PostModel
                                                            final CourseModel
                                                                courseModel =
                                                                post;
                                                            return Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: <Widget>[
                                                                const Padding(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              15,
                                                                          vertical:
                                                                              5),
                                                                  child:
                                                                      TextWidget(
                                                                    text:
                                                                        'Sponsored',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    size: 10,
                                                                  ),
                                                                ),
                                                                CourseItem(
                                                                    course:
                                                                        courseModel),
                                                              ],
                                                            );
                                                          } else {
                                                            return const SizedBox();
                                                          }
                                                        },
                                                      ),
                                                      ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount: controller
                                                            .forums.length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          return ForumItem(
                                                            forum: controller
                                                                .forums[index],
                                                            controller:
                                                                homeController,
                                                          );
                                                        },
                                                      ),
                                                    ]),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const BottomBar(
                                    activeIndex: 0,
                                  ),
                                  const Floatingbutton(),
                                ],
                              ),
                            ),
            ),
          );
        },
      ),
    );
  }
}
