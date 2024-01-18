import 'package:business_bosses_v2/features/home/bottom_nav.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/sell_services.dart';
import 'package:flutter/material.dart';
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
                      Expanded(
                        flex: 10,
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
                      // Container(
                      //   width: 72.0,
                      //   height: double.infinity,
                      //   color: Colors.white,
                      // ),
                      Expanded(
                        flex: 10,
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
            Align(
              alignment: Alignment.topRight,
              child: Stack(children: [
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 50,
                  child: Container(
                    width: 50,
                    height: 50,
                    alignment: Alignment.center,
                    child: FloatingActionButton(
                      child: const Icon(Icons.add),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Expanded(
                                        // Set a specific height
                                        child: ListView.separated(
                                          itemCount: 3,
                                          separatorBuilder:
                                              (BuildContext context,
                                                      int index) =>
                                                  const Divider(),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return ListTile(
                                              onTap: () {
                                                Navigator.pop(context);
                                                index == 0
                                                    ? Get.toNamed(
                                                        Routes.createPost)
                                                    : index == 1
                                                        ? sellProduct(context)
                                                        : Get.toNamed(
                                                            Routes.createevent);
                                              },
                                              minVerticalPadding: 0,
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 10),
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
                                                    fontWeight:
                                                        FontWeight.w700),
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
                    ),
                  ),
                  // child: Container(
                  //   width: 55,
                  //   height: 55,
                  //   alignment: Alignment.center,
                  //   child: SpeedDial(
                  //     icon: Icons.add,
                  //     activeIcon: Icons.close,
                  //     spacing: 3,
                  //     switchLabelPosition: true,
                  //     childPadding: const EdgeInsets.all(5),
                  //     spaceBetweenChildren: 4,
                  //     visible: true,
                  //     direction: SpeedDialDirection.up,
                  //     closeManually: false,
                  //     renderOverlay: true,
                  //     overlayColor: Colors.black,
                  //     overlayOpacity: 0.8,
                  //     useRotationAnimation: true,
                  //     tooltip: 'Open Speed Dial',
                  //     heroTag: 'speed-dial-hero-tag',
                  //     elevation: 3.0,
                  //     animationCurve: Curves.elasticInOut,
                  //     isOpenOnStart: false,
                  //     shape: const CircleBorder(),
                  //     children: [
                  //       SpeedDialChild(
                  //           child: Padding(
                  //             padding: const EdgeInsets.all(10.0),
                  //             child: SvgPicture.asset(
                  //               'assets/svgs/text.svg',
                  //               color: Colors.white,
                  //             ),
                  //           ),
                  //           backgroundColor: Colors.red,
                  //           label: 'Create a Post',
                  //           labelStyle: const TextStyle(
                  //               fontSize: 18.0, fontWeight: FontWeight.w700),
                  //           onTap: () =>
                  //               Get.toNamed(Routes.createPost, arguments: {
                  //                 'sharemessage': '',
                  //                 'title': '',
                  //               })),
                  //       SpeedDialChild(
                  //           child: Padding(
                  //             padding: const EdgeInsets.all(14.0),
                  //             child: SvgPicture.asset(
                  //               'assets/svgs/liveevent.svg',
                  //               color: Colors.white,
                  //             ),
                  //           ),
                  //           backgroundColor: Colors.black,
                  //           label: 'Create an Event',
                  //           labelStyle: const TextStyle(
                  //               fontSize: 18.0, fontWeight: FontWeight.w700),
                  //           onTap: () => Get.toNamed(Routes.createevent)),
                  //       SpeedDialChild(
                  //           child: Padding(
                  //             padding: const EdgeInsets.all(0.0),
                  //             child: SvgPicture.asset(
                  //               'assets/svgs/sellicon.svg',
                  //               color: Colors.white,
                  //               height: 30,
                  //             ),
                  //           ),
                  //           backgroundColor: Colors.green,
                  //           label: 'Sell a Product',
                  //           labelStyle: const TextStyle(
                  //               fontSize: 18.0, fontWeight: FontWeight.w700),
                  //           onTap: () => Get.toNamed(Routes.sellscreen)),
                  //     ],
                  //   ),
                  // ),
                ),
              ]),
            )
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
