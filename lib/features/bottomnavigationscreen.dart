import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/features/home/all_communities_screen.dart';

import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/home/home_screen.dart';
import 'package:business_bosses_v2/features/home/marketplace_screen.dart';
import 'package:business_bosses_v2/features/live_event/presentation/live_event.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/features/profile/presentation/my_profile_screen.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BottomNavigationExampleState createState() =>
      _BottomNavigationExampleState();

  // static final GlobalKey<NavigatorState> homekey = GlobalKey<NavigatorState>();
  // static final GlobalKey<NavigatorState> bossupkey =
  //     GlobalKey<NavigatorState>();
  // static final GlobalKey<NavigatorState> eventskey =
  //     GlobalKey<NavigatorState>();
  // static final GlobalKey<NavigatorState> marketplacekey =
  //     GlobalKey<NavigatorState>();
  // static final GlobalKey<NavigatorState> profilekey =
  //     GlobalKey<NavigatorState>();
}

class _BottomNavigationExampleState extends State<BottomNavigationScreen> {
  int _selectedPageIndex = 0;

  final PageController _pageController = PageController(initialPage: 0);

  final List<Widget> _pages = <Widget>[
    const HomeScreen(),
    const AllCommunitiesScreen(),
    const LiveEvent(),
    const MarketplaceScreen(),
    const MyProfileScreen(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
        overlays: <SystemUiOverlay>[SystemUiOverlay.bottom]);
    Get.put(ProfileController());
    Get.put(HomeController());
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: Stack(children: <Widget>[
        // Padding(
        //   padding: const EdgeInsets.only(top: 20.0),
        //   child: Row(
        //     children: [
        //       Expanded(
        //         child: Text(
        //           "d",
        //           style: const TextStyle(color: Colors.white),
        //           textAlign: TextAlign.center,
        //           key: BottomNavigationScreen.homekey,
        //         ),
        //       ),
        //       Expanded(
        //         child: Text(
        //           "d",
        //           style: const TextStyle(color: Colors.white),
        //           textAlign: TextAlign.center,
        //           key: BottomNavigationScreen.bossupkey,
        //         ),
        //       ),
        //       Expanded(
        //         child: Text(
        //           "d",
        //           key: BottomNavigationScreen.eventskey,
        //           style: const TextStyle(color: Colors.white),
        //           textAlign: TextAlign.center,
        //         ),
        //       ),
        //       Expanded(
        //         child: Text(
        //           "d",
        //           key: BottomNavigationScreen.marketplacekey,
        //           style: const TextStyle(color: Colors.white),
        //           textAlign: TextAlign.center,
        //         ),
        //       ),
        //       Expanded(
        //         child: Text(
        //           "d",
        //           key: BottomNavigationScreen.profilekey,
        //           style: const TextStyle(color: Colors.white),
        //           textAlign: TextAlign.center,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: _selectedPageIndex,
          onTap: (int selectedPageIndex) {
            setState(() {
              _selectedPageIndex = selectedPageIndex;
              _pageController.jumpToPage(selectedPageIndex);
            });
          },
          selectedItemColor: primaryColorLT,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle:
              const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/svgs/hom.svg',
                height: 21,
              ),
              label: 'Home',
              activeIcon: SvgPicture.asset(
                'assets/svgs/hom.svg',
                height: 21,
                colorFilter:
                    const ColorFilter.mode(primaryColorLT, BlendMode.srcIn),
              ),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/svgs/bossup.svg',
                height: 22,
                colorFilter:
                    const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
              ),
              label: 'Boss Up',
              activeIcon: SvgPicture.asset(
                'assets/svgs/bossup.svg',
                height: 22,
                colorFilter:
                    const ColorFilter.mode(primaryColorLT, BlendMode.srcIn),
              ),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/svgs/liveevent.svg',
                height: 23,
                colorFilter:
                    const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
              ),
              label: 'Events',
              activeIcon: SvgPicture.asset(
                'assets/svgs/liveevent.svg',
                height: 23,
                colorFilter:
                    const ColorFilter.mode(primaryColorLT, BlendMode.srcIn),
              ),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/svgs/marketplace.svg',
                height: 23,
              ),
              label: 'Marketplace',
              activeIcon: SvgPicture.asset(
                'assets/svgs/marketplace.svg',
                colorFilter:
                    const ColorFilter.mode(primaryColorLT, BlendMode.srcIn),
                height: 23,
              ),
            ),
            BottomNavigationBarItem(
              icon: SizedBox(
                height: 25.0,
                width: 25.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(1000),
                  child: NetworkImageWithPlaceHolder(
                    imageUrl:
                        Get.put(ProfileController()).myProfile.photoUrl ?? '',
                    radius: radius,
                    placeHolder: Icons.person,
                    iconSize: 20.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              label: 'Profile',
            ),
          ],
        ),
      ]),
    );
  }
}
