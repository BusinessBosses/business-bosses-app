import 'package:business_bosses_v2/features/home/bottom_nav.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({Key? key, this.activeIndex = 0}) : super(key: key);
  final int activeIndex;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 103.0,
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
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
                          icon: 'assets/svgs/hom.svg',
                          label: 'Home',
                          onTap: () {
                            if (activeIndex == 0) return;

                            Get.offAndToNamed(Routes.home);
                          },
                          isActive: activeIndex == 0,
                        ),
                      ),
                      Expanded(
                        flex: 10,
                        child: BottomTabButton(
                          icon: 'assets/svgs/bossup.svg',
                          onTap: () {
                            if (activeIndex == 1) return;
                            if (activeIndex == 0) {
                              Get.toNamed(Routes.allCommunitiesScreen);
                            } else {
                              Get.offAndToNamed(Routes.allCommunitiesScreen);
                            }
                          },
                          label: 'Boss Up',
                          isActive: activeIndex == 1,
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
                            if (activeIndex == 2) return;
                            if (activeIndex == 0) {
                              Get.toNamed(Routes.marketPlace);
                            } else {
                              Get.offAndToNamed(Routes.marketPlace);
                            }
                          },
                          isActive: activeIndex == 2,
                        ),
                      ),
                      Expanded(
                        flex: 10,
                        child: BottomTabButton(
                          icon: 'assets/svgs/profilebottom.svg',
                          onTap: () {
                            if (activeIndex == 3) return;
                            if (activeIndex == 0) {
                              Get.toNamed(Routes.myProfile);
                            } else {
                              Get.offAndToNamed(Routes.myProfile);
                            }
                          },
                          isActive: activeIndex == 3,
                          label: 'Profile',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.center,
              child: Positioned(
                left: 0,
                right: 0,
                child: Container(
                    width: 50,
                    height: 50,
                    alignment: Alignment.center,
                    child: SpeedDial(
                      marginBottom: 40,
                      icon: Icons.add,
                      activeIcon: Icons.close,
                      buttonSize: 56.0,
                      visible: true,
                      closeManually: false,
                      curve: Curves.bounceIn,
                      overlayColor: Colors.white,
                      overlayOpacity: 0.0,
                      onOpen: () => print('OPENING DIAL'),
                      onClose: () => print('DIAL CLOSED'),
                      tooltip: 'Speed Dial',
                      heroTag: 'speed-dial-hero-tag',
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      elevation: 8.0,
                      shape: const CircleBorder(),
                      gradientBoxShape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [primaryColorLT, primaryColorLT],
                      ),
                      children: [
                        SpeedDialChild(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SvgPicture.asset(
                              'assets/svgs/text.svg',
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: Colors.red,
                          label: 'Create Post',
                          labelStyle: const TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w700),
                          onTap: () {},
                          onLongPress: () => print('FIRST CHILD LONG PRESS'),
                        ),
                        SpeedDialChild(
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: SvgPicture.asset(
                              'assets/svgs/liveevent.svg',
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: Colors.black,
                          label: 'Start Event',
                          labelStyle: const TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w700),
                          onTap: () => print('SECOND CHILD'),
                          onLongPress: () => print('SECOND CHILD LONG PRESS'),
                        ),
                      ],
                    )
                    // child: FloatingActionButton(
                    //   child: const Icon(Icons.add),
                    //   onPressed: () async {
                    //     Get.toNamed(Routes.createPost);
                    //   },
                    // ),
                    ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
