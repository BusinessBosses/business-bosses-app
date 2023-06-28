import 'package:business_bosses_v2/common/widgets/text_widget.dart';
import 'package:business_bosses_v2/features/chat/controllers/chat_controller.dart';
import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/posts/controllers/posts_controller.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../utils/theme/theme.dart';
import '../forum/controller/bossup_controller.dart';
import '../marketplace/controllers/market_controller.dart';
import '../posts/presentation/create_post_screen.dart';
import '../profile/presentation/myprofilescreen.dart';
import 'all_communities_screen.dart';
import 'home_screen.dart';
import 'marketplace_screen.dart';

/// Bottom Nav Screen is basically where all home screens are navigated through
class BottomNavScreen extends StatefulWidget {
  final int selectedIndex;

  /// Constructor
  const BottomNavScreen(this.selectedIndex, bool bool, {super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  // final PostsController _postsController = Get.put(PostsController());
  // final ProfileController _profileController = Get.put(ProfileController());
  // final ChatController _chatController = Get.put(ChatController());
  // final HomeController _homeController = Get.put(HomeController());
  // final MarketController _marketController = Get.put(MarketController());
  // final BossUpController _bossUpController = Get.put(BossUpController());
  int _activeIndex = 0;
  final List<String> screens = [
    Routes.home,
    Routes.allCommunitiesScreen,
    Routes.marketPlace,
    Routes.myProfile
  ];
  int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
  late FirebaseAnalyticsObserver _observer;

  // final GetStorage sandBox = GetStorage();

  /// Show daily coin dialog
  void showCoinDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const TextWidget(
          text: 'Congratulations',
          fontWeight: FontWeight.bold,
          size: 20,
        ),
        content: TextWidget(
          text: 'You have earned 1 coin for logging into Business Bosses today',
          color: Colors.black.withOpacity(.8),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const TextWidget(
              text: 'OK',
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _activeIndex = widget.selectedIndex;
    _observer = FirebaseAnalyticsObserver(analytics: _analytics);
  }

  @override
  void dispose() {
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
      child: Scaffold(
          body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: IndexedStack(
                index: _activeIndex,
                children: const <Widget>[
                  HomeScreen(),
                  AllCommunitiesScreen(),
                  MarketplaceScreen(),
                  MyProfileScreen(),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 103.0,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      spreadRadius: 10,
                      blurRadius: 50,
                      offset: const Offset(0, 7), // changes position of shadow
                    ),
                  ],
                ),
                child: Stack(
                  children: <Widget>[
                    Column(
                      children: [
                        Container(
                          height: 20.0,
                          color: Colors.transparent,
                        ),
                        Container(
                          height: 83.0,
                          padding: const EdgeInsets.only(bottom: 20),
                          color: Colors.white,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 10,
                                child: BottomTabButton(
                                  icon: 'assets/svgs/hom.svg',
                                  label: 'Home',
                                  onTap: () {
                                    _onChangePage(0);
                                  },
                                  isActive: _activeIndex == 0,
                                ),
                              ),
                              Expanded(
                                flex: 10,
                                child: BottomTabButton(
                                  icon: 'assets/svgs/bossup.svg',
                                  onTap: () {
                                    _onChangePage(1);
                                  },
                                  label: 'Boss Up',
                                  isActive: _activeIndex == 1,
                                ),
                              ),
                              Container(
                                width: 72.0,
                                height: double.infinity,
                                color: Colors.white,
                              ),
                              Expanded(
                                flex: 10,
                                child: BottomTabButton(
                                  label: 'Marketplace',
                                  icon: 'assets/svgs/marketplace.svg',
                                  onTap: () {
                                    _onChangePage(2);
                                  },
                                  isActive: _activeIndex == 2,
                                ),
                              ),
                              Expanded(
                                flex: 10,
                                child: BottomTabButton(
                                  icon: 'assets/svgs/profilebottom.svg',
                                  onTap: () => _onChangePage(3),
                                  isActive: _activeIndex == 3,
                                  label: 'Profile',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      child: Container(
                        alignment: Alignment.center,
                        child: FloatingActionButton(
                          child: const Icon(Icons.add),
                          onPressed: () async {
                            // log("Hello world");
                            Navigator.push(
                              context,
                              MaterialPageRoute<dynamic>(
                                builder: (BuildContext context) =>
                                    const CreatePostScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )

            //navbar
          ],
        ),
      )),
    );
  }

  void logScreenView(String screenName) {
    _analytics.setCurrentScreen(
      screenName: screenName,
      screenClassOverride: screenName,
    );
  }

  dynamic _onChangePage(int currentIndex) {
    setState(() {
      _activeIndex = currentIndex;
    });
    logScreenView(screens[currentIndex]);

    return;
  }
}

/// Bottom Tab Button click
class BottomTabButton extends StatelessWidget {
  // ignore: public_member_api_docs
  final bool isActive;
  // ignore: public_member_api_docs
  final String icon;
  // ignore: public_member_api_docs
  final void Function()? onTap;
  // ignore: public_member_api_docs
  final String label;
  // ignore: public_member_api_docs
  final int count;

  /// Bottom Tab Button click
  const BottomTabButton({
    super.key,
    required this.isActive,
    required this.icon,
    required this.onTap,
    this.label = '',
    this.count = 0,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: double.infinity,
        color: Colors.white,
        child: Stack(
          children: [
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30.0,
                    child: SvgPicture.asset(
                      icon,
                      height: 23,
                      width: 23,
                      color: isActive ? primaryColorLT : iconColor,
                    ),
                  ),
                  if (label.isNotEmpty)
                    FittedBox(
                      child: Text(
                        label,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w700,
                          color: isActive ? primaryColorLT : iconColor,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (count > 0)
              Positioned(
                right: 10.0,
                bottom: 23.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 25,
                      height: 25,
                      child: Stack(
                        children: [
                          Positioned(
                            right: 10,
                            child: SvgPicture.asset(
                              'assets/svgs/coin.svg',
                              height: 14,
                            ),
                          ),
                          Positioned(
                            top: 12,
                            left: 5,
                            child: Container(
                              color: Colors.transparent,
                              child: Text(
                                '$count',
                                style: const TextStyle(
                                  color: Color.fromRGBO(133, 133, 133, 1),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
