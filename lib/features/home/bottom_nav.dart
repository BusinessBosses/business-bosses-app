import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/common/widgets/text_widget.dart';
import 'package:business_bosses_v2/features/impact/presentation/leaderboard_screen.dart';
import 'package:business_bosses_v2/features/home/utils/post_options_sheet.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../utils/theme/theme.dart';
import '../profile/presentation/my_profile_screen.dart';
import '../chat/chat_screen.dart';
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
  //final ProfileController _profileController = Get.find();
  // final ChatController _chatController = Get.put(ChatController());
  // final HomeController _homeController = Get.put(HomeController());
  // final MarketController _marketController = Get.put(MarketController());
  // final BossUpController _bossUpController = Get.put(BossUpController());
  int _activeIndex = 0;
  final List<String> screens = <String>[
    Routes.home,
    Routes.allCommunitiesScreen,
    Routes.marketPlace,
    Routes.myProfile
  ];

  int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
  // ignore: unused_field
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
          color: Colors.black.withValues(alpha: .8),
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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) return;
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
                  HomeScreen(), // Index 0: Boss up
                  ChatScreen(), // Index 1: Inbox
                  LeaderboardScreen(), // Index 2: Post (+) - wait, post is floating. Index 2 used to be Ranking.
                  MarketplaceScreen(), // Index 3: Home
                  MyProfileScreen(), // Index 4: Profile
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 103.0,
                decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      spreadRadius: 10,
                      blurRadius: 50,
                      offset: const Offset(0, 7), // changes position of shadow
                    ),
                  ],
                ),
                child: Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          height: 20.0,
                          color: Colors.transparent,
                        ),
                        Container(
                          height: 83.0,
                          padding: const EdgeInsets.only(bottom: 20),
                          color: Colors.white,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 10,
                                child: BottomTabButton(
                                  icon: 'assets/svgs/marketplace.svg',
                                  label: 'Home',
                                  onTap: () {
                                    _onChangePage(3);
                                  },
                                  isActive: _activeIndex == 3,
                                ),
                              ),
                              Expanded(
                                flex: 10,
                                child: BottomTabButton(
                                  icon:
                                      'assets/svgs/messagefilled.svg', // Assuming inbox icon or similar
                                  onTap: () {
                                    // Need to find which index is Inbox. Usually 1.
                                    _onChangePage(1);
                                  },
                                  label: 'Inbox',
                                  isActive: _activeIndex == 1,
                                ),
                              ),
                              // Placeholder for middle button if any, or just skip
                              Expanded(
                                flex: 10,
                                child: BottomTabButton(
                                  icon: 'assets/svgs/bossup.svg',
                                  onTap: () {
                                    _onChangePage(0);
                                  },
                                  label: 'Boss up',
                                  isActive: _activeIndex == 0,
                                ),
                              ),
                              Expanded(
                                flex: 10,
                                child: BottomTabButton(
                                  icon: 'assets/svgs/profilebottom.svg',
                                  onTap: () => _onChangePage(4),
                                  isActive: _activeIndex == 4,
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
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            child: FloatingActionButton(
                              heroTag: 'postButton',
                              child: const Icon(Icons.add),
                              onPressed: () => _showPostOptionsSheet(context),
                            ),
                          ),
                          const Text(
                            'Post',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w700,
                              color: textColor,
                            ),
                          ),
                        ],
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
    _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenName, // Optional, for Android screen_class override
    );
  }

  dynamic _onChangePage(int currentIndex) {
    setState(() {
      _activeIndex = currentIndex;
    });
    logScreenView(screens[currentIndex]);

    return;
  }

  void _showPostOptionsSheet(BuildContext context) {
    PostOptionsBottomSheet.show(context);
  }
}

/// Bottom Tab Button click
class BottomTabButton extends StatelessWidget {
  final bool isActive;
  final String? icon;
  final void Function()? onTap;
  final String label;
  final int count;
  final Widget? widget;

  /// Bottom Tab Button click
  const BottomTabButton({
    super.key,
    required this.isActive,
    this.icon,
    required this.onTap,
    this.label = '',
    this.count = 0,
    this.widget,
  });

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find();
    return InkWell(
      onTap: onTap,
      child: Container(
        height: double.infinity,
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (icon != null && icon!.isNotEmpty)
                    SizedBox(
                      height: 32.0,
                      child: SvgPicture.asset(
                        icon!,
                        height: 25,
                        width: 25,
                        colorFilter: ColorFilter.mode(
                            isActive ? primaryColorLT : textColor,
                            BlendMode.srcIn),
                      ),
                    )
                  else if (widget != null)
                    widget!
                  else
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2.0, top: 3),
                      child: SizedBox(
                        height: 28.0,
                        width: 28.0,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(1000),
                            child: NetworkImageWithPlaceHolder(
                              imageUrl:
                                  profileController.myProfile.photoUrl ?? '',
                              radius: radius,
                              placeHolder: Icons.person,
                              iconSize: 22.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (label.isNotEmpty)
                    FittedBox(
                      child: Text(
                        label,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                          color: isActive ? primaryColorLT : textColor,
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
                  children: <Widget>[
                    SizedBox(
                      width: 25,
                      height: 25,
                      child: Stack(
                        children: <Widget>[
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
