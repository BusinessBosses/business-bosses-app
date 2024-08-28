import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/forum/controller/challenge_controller.dart';
import 'package:business_bosses_v2/features/home/controller/commumities_controller.dart';
import 'package:business_bosses_v2/features/home/widgets/bottom_bar.dart';
import 'package:business_bosses_v2/features/home/widgets/challengessection.dart';
import 'package:business_bosses_v2/features/home/widgets/eventssection.dart';
import 'package:business_bosses_v2/features/home/widgets/floatingbutton.dart';
import 'package:business_bosses_v2/features/home/widgets/forum_item.dart';
import 'package:business_bosses_v2/features/home/widgets/learningsection.dart';
import 'package:business_bosses_v2/features/home/widgets/list_items.dart';
import 'package:business_bosses_v2/features/home/widgets/marketplacesection.dart';
import 'package:business_bosses_v2/features/home/widgets/searchsection.dart';
import 'package:business_bosses_v2/features/live_event/controller/live_event_controller.dart';
import 'package:business_bosses_v2/features/donations/controller/donations_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';
import '../../utils/constants/constants.dart';
import '../chat/controllers/chat_controller.dart';
import '../chat/models/my_message.dart';
import '../home/controller/home_controller.dart';
import '../home/widgets/home_appbar.dart';
import '../marketplace/controllers/market_controller.dart';
import '../posts/models/post_model.dart';
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
  final CommunitiesController _communitiesController =
      Get.put(CommunitiesController());
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

  int marketIndex = 0;
  // final GlobalKey<NavigatorState> postButtonKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3, initialIndex: 1);

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
    });

    // Function to establish the WebSocket connection
    void connectSocket() {
      socket = io.io(Constants.socketUrl, <String, dynamic>{
        'transports': <String>['websocket'],
      });

      socket.onConnect((_) {
        print('Connection established');
      });

      socket.on('newPostEvent', (dynamic data) {
        final int postIndex = homeController.posts.indexWhere(
            (PostModel element) => element.postId == data['newPost']['postId']);
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

      socket.onConnectError((dynamic err) {
        print(err);
        // Handle connection errors as needed
      });

      socket.onError((dynamic err) {
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
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _tabController.addListener(() {
      setState(() {}); // Update the state when the tab is changed
    });
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
              backgroundColor: Colors.white,
              appBar: PreferredSize(
                preferredSize: controller.loading.value
                    ? const Size.fromHeight(0)
                    : const Size.fromHeight(kToolbarHeight + 50),
                child: controller.loading.value
                    ? Container()
                    : GetBuilder<ChatController>(
                        builder: (ChatController chatController) {
                        final List<MessageModel> unseenChats = chatController
                            .chats
                            .where((MessageModel element) =>
                                element.receiverUid ==
                                    controller
                                        .profileController.myProfile.uid &&
                                !element.seen)
                            .toList();
                        final bool hasBadge = unseenChats.isNotEmpty;

                        return GetBuilder<ProfileController>(
                          builder: (ProfileController profileController) =>
                              HomeAppBar(
                            isTabVisible: isTabVisible,
                            hasBadge: hasBadge,
                            coinsCount: profileController.myProfile.coinscount
                                    ?.toString() ??
                                '',
                            hasUnreadNotification: profileController
                                        .myProfile.unReadCount !=
                                    null &&
                                profileController.myProfile.unReadCount! > 0,
                            controller: _tabController,
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
                                        child: TabBarView(
                                            controller: _tabController,
                                            children: <Widget>[
                                              ListView(
                                                children: const [
                                                  // Padding(
                                                  //   padding: EdgeInsets.only(
                                                  //       left: 15.0,
                                                  //       right: 15,
                                                  //       top: 15),
                                                  //   child: SearchSection(),
                                                  // ),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  LearningSection(),
                                                  // BossOfWeekProfileTile(),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  ChallengesSection(),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  EventsSection(),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  MarketplaceSection(),
                                                  SizedBox(
                                                    height: 120,
                                                  ),
                                                ],
                                              ),
                                              PostsWidget(
                                                onPageChange:
                                                    widget.onPageChange,
                                              ),
                                              ListView.builder(
                                                shrinkWrap: true,
                                                itemCount:
                                                    controller.forums.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return ForumItem(
                                                    forum: controller
                                                        .forums[index],
                                                    controller: homeController,
                                                  );
                                                },
                                              ),
                                            ]),
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
