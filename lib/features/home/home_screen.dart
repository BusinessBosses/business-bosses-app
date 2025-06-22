import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/presentation/expanded_order_load.dart';
import 'package:business_bosses_v2/bbpro/widgets/drawercontent.dart';
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/chat/controllers/ai_chat_controller.dart';
import 'package:business_bosses_v2/features/forum/controller/challenge_controller.dart';
import 'package:business_bosses_v2/features/home/controller/commumities_controller.dart';
import 'package:business_bosses_v2/features/home/widgets/bottom_bar.dart';
import 'package:business_bosses_v2/features/home/widgets/floatingbutton.dart';
import 'package:business_bosses_v2/features/home/widgets/forum_item.dart';
import 'package:business_bosses_v2/features/home/widgets/list_items.dart';
import 'package:business_bosses_v2/features/live_event/controller/live_event_controller.dart';
import 'package:business_bosses_v2/features/donations/controller/donations_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/supplier_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.onPageChange});

  final Function(int)? onPageChange;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  final AdvancedDrawerController _advancedDrawerController =
      AdvancedDrawerController();
  final HomeController homeController = Get.put(HomeController());
  final ProfileController _profileController = Get.find();
  final CommunitiesController _communitiesController =
      Get.put(CommunitiesController());
  final LiveController liveEventController = Get.put(LiveController());
  final ChallengeController challengeController =
      Get.put(ChallengeController());
  final DonationsController donationsController =
      Get.put(DonationsController());
  final SupplierController supplierController = Get.put(SupplierController());
  final AiChatController ctrl = Get.put(AiChatController());
  late io.Socket socket;

  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  final MarketController marketController = Get.put(MarketController());
  final ShopController shopController =
      Get.put(ShopController(), permanent: true);

  // Instead of plain bools, use ValueNotifiers so we don't call setState on every scroll.
  final ValueNotifier<bool> _isScrolledNotifier = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _isTabVisibleNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2, initialIndex: 0);

    WidgetsBinding.instance.addObserver(this);

    // Run checkOrderVisit and shop init once, after first frame:
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkOrderVisit();
    });

    // Listen to scroll events to update both notifiers:
    _scrollController.addListener(_onScrollChanged);

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
      });

      socket.onError((dynamic err) {
        print(err);
      });
    }

    // Initial connection
    connectSocket();
  }

  void _onScrollChanged() {
    // Hide/show bottom bar based on scroll direction:
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      _isScrolledNotifier.value = true;
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      _isScrolledNotifier.value = false;
    }

    // Show/hide tabs in the app bar based on scroll offset:
    if (_scrollController.hasClients &&
        _scrollController.position.pixels >= 230) {
      _isTabVisibleNotifier.value = true;
    } else {
      _isTabVisibleNotifier.value = false;
    }
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed) {
  //     homeController.fetchPosts(fromBackground: true);
  //   }
  //   super.didChangeAppLifecycleState(state);
  // }

  void _scrollToTop() {
    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrollChanged);
    _scrollController.dispose();
    _isScrolledNotifier.dispose();
    _isTabVisibleNotifier.dispose();
    socket.off('newPostEvent');
    WidgetsBinding.instance.removeObserver(this);
    _tabController.dispose();
    super.dispose();
  }

  void checkOrderVisit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? visit = prefs.getBool('visited');
    if (visit != null && !visit) {
      Get.to(() => ExpandedOrdersView(order: prefs.getString('orderId')!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) return;

        showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Exit App'),
              content: const Text('Are you sure you want to exit?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Yes'),
                ),
              ],
            );
          },
        ).then((bool? shouldExit) {
          if (shouldExit == true && context.mounted) {
            SystemNavigator.pop(); // This exits the app completely
          }
        });
      },
      child: UpgradeAlert(
        upgrader: Upgrader(
          durationUntilAlertAgain: const Duration(minutes: 1),
        ),
        child: Obx(() {
          // Check if we should disable drawer interactions
          bool shouldDisableDrawer = homeController.loading.value ||
              homeController.noConnection.value ||
              homeController.error.value;

          return AdvancedDrawer(
            backdrop: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Colors.white,
                    Colors.white.withValues(alpha: 0.2),
                  ],
                ),
              ),
            ),
            controller: _advancedDrawerController,
            animationCurve: Curves.easeInOut,
            animationDuration: const Duration(milliseconds: 300),
            animateChildDecoration: true,
            rtlOpening: false,
            // Disable gestures when in loading/error states
            disabledGestures: shouldDisableDrawer,
            childDecoration: const BoxDecoration(
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
                  _profileController.myProfile.unReadCount != null &&
                      _profileController.myProfile.unReadCount! > 0,
            ),
            child: Scaffold(
              backgroundColor: Colors.white,
              floatingActionButton: Obx(() {
                return homeController.loading.value
                    ? Container()
                    : Floatingbutton();
              }),
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight),
                child: Obx(() {
                  if (homeController.loading.value) {
                    return Container();
                  }
                  return ValueListenableBuilder<bool>(
                    valueListenable: _isTabVisibleNotifier,
                    builder: (BuildContext context, bool isTabVisible, _) {
                      return GetBuilder<ChatController>(
                        builder: (ChatController chatController) {
                          final List<MessageModel> unseenChats =
                              chatController.chats.where((MessageModel msg) {
                            return msg.receiverUid ==
                                    homeController
                                        .profileController.myProfile.uid &&
                                !msg.seen;
                          }).toList();
                          final bool hasBadge = unseenChats.isNotEmpty;

                          return GetBuilder<ProfileController>(
                            builder: (ProfileController profileController) {
                              return HomeAppBar(
                                onMenuClick: shouldDisableDrawer
                                    ? null
                                    : () {
                                        _advancedDrawerController.showDrawer();
                                      },
                                isTabVisible: isTabVisible,
                                hasBadge: hasBadge,
                                coinsCount: profileController
                                        .myProfile.coinscount
                                        ?.toString() ??
                                    '0',
                                hasUnreadNotification: profileController
                                            .myProfile.unReadCount !=
                                        null &&
                                    profileController.myProfile.unReadCount! >
                                        0,
                                controller: _tabController,
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                }),
              ),
              body: Obx(() {
                if (homeController.loading.value) {
                  return _buildLoading();
                } else if (homeController.noConnection.value) {
                  return _buildNoConnection();
                } else if (homeController.error.value) {
                  return _buildError();
                } else {
                  return _buildMainContent();
                }
              }),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildMainContent() {
    return Stack(
      children: <Widget>[
        Container(
          color: backgroundColor,
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              PostsWidget(
                onPageChange: widget.onPageChange,
                scrollController: _scrollController,
              ),
              _buildForumList(homeController),
            ],
          ),
        ),
        BottomBar(
          activeIndex: 0,
          scrollControl: _scrollToTop,
        ),
      ],
    );
  }

  Widget _buildForumList(HomeController controller) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SizedBox(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: ListView.builder(
            controller: _scrollController,
            itemCount: controller.forums.length,
            itemBuilder: (BuildContext context, int index) {
              return ForumItem(
                forum: controller.forums[index],
                controller: homeController,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildLoading() {
    return Center(
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
              'Promote your Business, Network & Grow Globally',
              style: TextStyle(fontSize: 16),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildNoConnection() {
    return SafetyModel(
      isLoading: false,
      title: 'Error While Loading Data\nCheck your Internet Connection',
      subTitle: 'Try Reloading Again',
      clickableText: 'Refresh',
      onTap: () {
        homeController.loadData();
        _profileController.fetchData();
        marketController.initMarket();
        _communitiesController.fetchIndustries();
        liveEventController.initEvents();
      },
      icon: const Icon(
        Icons.warning,
        size: 60,
      ),
    );
  }

  Widget _buildError() {
    return SafetyModel(
      isLoading: false,
      title: 'Error While Loading Data',
      subTitle: 'Try Reloading Again',
      clickableText: 'Refresh',
      onTap: () {
        homeController.loadData();
        _profileController.fetchData();
        marketController.initMarket();
        _communitiesController.fetchIndustries();
        liveEventController.initEvents();
      },
      icon: const Icon(
        Icons.warning,
        size: 60,
      ),
    );
  }
}
