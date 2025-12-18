import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/presentation/expanded_order_load.dart';
import 'package:business_bosses_v2/bbpro/widgets/drawercontent.dart';
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/chat/controllers/ai_chat_controller.dart';
import 'package:business_bosses_v2/features/forum/controller/challenge_controller.dart';
import 'package:business_bosses_v2/features/home/controller/commumities_controller.dart';
import 'package:business_bosses_v2/features/home/widgets/bottom_bar.dart';
import 'package:business_bosses_v2/features/home/widgets/list_items.dart';

import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:upgrader/upgrader.dart';
import '../chat/controllers/chat_controller.dart';
import '../chat/models/my_message.dart';
import '../home/controller/home_controller.dart';
import '../home/widgets/home_appbar.dart';
import '../marketplace/controllers/market_controller.dart';
import '../profile/controller/profile_controller.dart';

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
  final ChallengeController challengeController =
      Get.put(ChallengeController());
  final AiChatController ctrl = Get.put(AiChatController());
  late io.Socket socket;

  final ScrollController _scrollController = ScrollController();
  final MarketController marketController = Get.put(MarketController());
  final ShopController shopController =
      Get.put(ShopController(), permanent: true);

  final ValueNotifier<bool> _isScrolledNotifier = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkOrderVisit();
      if (marketController.marketDescription.isEmpty) {
        marketController.initDescription();
      }
    });

    _scrollController.addListener(_onScrollChanged);
  }

  void _onScrollChanged() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      _isScrolledNotifier.value = true;
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      _isScrolledNotifier.value = false;
    }
  }

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
    WidgetsBinding.instance.removeObserver(this);
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
            SystemNavigator.pop();
          }
        });
      },
      child: UpgradeAlert(
        upgrader: Upgrader(
          durationUntilAlertAgain: const Duration(minutes: 1),
        ),
        child: Obx(() {
          bool shouldDisableDrawer = homeController.loading.value ||
              homeController.noConnection.value ||
              homeController.error.value;

          return AdvancedDrawer(
            backdrop: Container(
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
            rtlOpening: false,
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

            // ⭐⭐ FIX APPLIED HERE ⭐⭐
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight),
                child: Obx(() {
                  if (homeController.loading.value) {
                    return Container();
                  }

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
                            hasBadge: hasBadge,
                            coinsCount: profileController.myProfile.coinscount
                                    ?.toString() ??
                                '0',
                            hasUnreadNotification: profileController
                                        .myProfile.unReadCount !=
                                    null &&
                                profileController.myProfile.unReadCount! > 0,
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
                  if (marketController.proItems.isEmpty) {
                    marketController.initProItems();
                  }
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
          color: Colors.white,
          child: PostsWidget(
            onPageChange: widget.onPageChange,
            scrollController: _scrollController,
          ),
        ),
        BottomBar(
          activeIndex: 0,
          scrollControl: _scrollToTop,
        ),
      ],
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 120.0),
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
                'Promote and Grow Your Business Globally',
                style: TextStyle(fontSize: 16),
              ),
            )
          ],
        ),
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
        _communitiesController.fetchIndustries();
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
        _communitiesController.fetchIndustries();
      },
      icon: const Icon(
        Icons.warning,
        size: 60,
      ),
    );
  }
}
