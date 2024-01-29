import 'package:business_bosses_v2/features/home/bottom_nav.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/sell_services.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({
    Key? key,
    required this.activeIndex,
    required this.homePageKey,
    required this.bossupPageKey,
    required this.liveEventPageKey,
    required this.marketPlacePageKey,
    required this.profilePageKey,
  }) : super(key: key);
  final int activeIndex;
  final GlobalKey<NavigatorState> homePageKey;
  final GlobalKey<NavigatorState> bossupPageKey;
  final GlobalKey<NavigatorState> liveEventPageKey;
  final GlobalKey<NavigatorState> marketPlacePageKey;
  final GlobalKey<NavigatorState> profilePageKey;

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
                        key: homePageKey,
                        child: BottomTabButton(
                          icon: 'assets/svgs/hom.svg',
                          label: 'Home',
                          onTap: () {
                            if (activeIndex == 0) return;
                            Get.toNamed(Routes.home);
                          },
                          isActive: activeIndex == 0,
                        ),
                      ),
                      Expanded(
                        key: bossupPageKey,
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
                      Expanded(
                        flex: 10,
                        key: liveEventPageKey,
                        child: BottomTabButton(
                          icon: 'assets/svgs/liveevent.svg',
                          label: 'Live Events',
                          onTap: () {
                            if (activeIndex == 2) return;

                            if (activeIndex == 0) {
                              Get.toNamed(Routes.liveEvents);
                            } else {
                              Get.offAndToNamed(Routes.liveEvents);
                            }
                          },
                          isActive: activeIndex == 2,
                        ),
                      ),
                      Expanded(
                        flex: 10,
                        key: marketPlacePageKey,
                        child: BottomTabButton(
                          label: 'Marketplace',
                          icon: 'assets/svgs/marketplace.svg',
                          onTap: () {
                            if (activeIndex == 3) return;
                            if (activeIndex == 0) {
                              Get.toNamed(Routes.marketPlace);
                            } else {
                              Get.offAndToNamed(Routes.marketPlace);
                            }
                          },
                          isActive: activeIndex == 3,
                        ),
                      ),
                      Expanded(
                        flex: 10,
                        key: profilePageKey,
                        child: BottomTabButton(
                          icon: '',
                          onTap: () {
                            if (activeIndex == 4) return;
                            if (activeIndex == 0) {
                              Get.toNamed(Routes.myProfile);
                            } else {
                              Get.offAndToNamed(Routes.myProfile);
                            }
                          },
                          isActive: activeIndex == 4,
                          label: 'Profile',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void sellProduct(BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
        ),
        builder: (BuildContext context) {
          return SizedBox(
            height: 200,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    // Set a specific height
                    child: ListView.separated(
                      itemCount: 2,
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          onTap: () {
                            Navigator.pop(context);
                            index == 0
                                ? Get.toNamed(Routes.sellscreen)
                                : Get.to(() =>
                                    const CreateServiceScreen(isUpd: false));
                          },
                          minVerticalPadding: 0,
                          contentPadding: const EdgeInsets.only(left: 10),
                          leading: SvgPicture.asset(
                            index == 0
                                ? 'assets/svgs/sellicon.svg'
                                : 'assets/svgs/sellicon.svg',
                            height: index == 0
                                ? 25
                                : index == 1
                                    ? 30
                                    : 22,
                            color: textColor.withOpacity(1),
                          ),
                          title: Text(
                            index == 0
                                ? 'Sell your product'
                                : 'Sell your service',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700),
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
  }
}
