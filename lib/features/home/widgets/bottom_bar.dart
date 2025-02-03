import 'package:business_bosses_v2/bbpro/presentation/bottom_nav_screen.dart';
import 'package:business_bosses_v2/features/chat/chat_screen.dart';
import 'package:business_bosses_v2/features/chat/controllers/chat_controller.dart';
import 'package:business_bosses_v2/features/chat/models/my_message.dart';
import 'package:business_bosses_v2/features/home/bottom_nav.dart';
import 'package:business_bosses_v2/features/premium/proscreen.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({
    Key? key,
    required this.activeIndex,
  }) : super(key: key);
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    ProfileController profileController = Get.find();
    ChatController chatController = Get.find();
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
                          icon: activeIndex == 0
                              ? 'assets/svgs/homeufilled.svg'
                              : 'assets/svgs/homeu.svg',
                          label: 'Home',
                          onTap: () {
                            if (activeIndex == 0) return;
                            Get.toNamed(Routes.home);
                          },
                          isActive: activeIndex == 0,
                        ),
                      ),

                      Expanded(
                        flex: 10,
                        child: Stack(children: <Widget>[
                          BottomTabButton(
                            icon: activeIndex == 1
                                ? 'assets/svgs/messagefilled.svg'
                                : 'assets/svgs/prochat.svg',
                            label: 'Inbox',
                            onTap: () {
                              if (activeIndex == 1) return;

                              if (activeIndex == 0) {
                                //   profileController.myProfile.isSubscribed
                                //       ? Get.to(const Bottomnavscreen(noBack: false))
                                Get.to(const ChatScreen());
                              } else {
                                // profileController.myProfile.isSubscribed
                                //     ? Get.to(const Bottomnavscreen(noBack: false))

                                Get.off(() => const ChatScreen());
                              }
                            },
                            isActive: activeIndex == 1,
                          ),
                          if (chatController.chats
                              .where((MessageModel element) =>
                                  element.receiverUid ==
                                      profileController.myProfile.uid &&
                                  !element.seen)
                              .toList()
                              .isNotEmpty)
                            Positioned(
                              top: 5,
                              right: 21,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white, // Border color
                                    width: 2.0, // Border width
                                  ),
                                ),
                                child: const CircleAvatar(
                                  backgroundColor: primaryColorLT,
                                  radius: 5,
                                ),
                              ),
                            )
                        ]),
                      ),

                      Expanded(
                        flex: 10,
                        child: BottomTabButton(
                          icon: activeIndex == 2
                              ? 'assets/svgs/bossupufilled.svg'
                              : 'assets/svgs/bossupu.svg',
                          onTap: () {
                            if (activeIndex == 2) return;
                            if (activeIndex == 0) {
                              Get.toNamed(Routes.allCommunitiesScreen);
                            } else {
                              Get.offAndToNamed(Routes.allCommunitiesScreen);
                            }
                          },
                          label: 'Boss Up',
                          isActive: activeIndex == 2,
                        ),
                      ),
                      // Expanded(
                      //     flex: 10,
                      //     child: GestureDetector(
                      //       onTap: () {
                      //         showModalBottomSheet(
                      //           context: context,
                      //           shape: const RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.vertical(
                      //               top: Radius.circular(25.0),
                      //             ),
                      //           ),
                      //           builder: (BuildContext context) {
                      //             return SizedBox(
                      //               height: 310,
                      //               child: Padding(
                      //                 padding: const EdgeInsets.all(15.0),
                      //                 child: Column(
                      //                   crossAxisAlignment:
                      //                       CrossAxisAlignment.start,
                      //                   mainAxisSize: MainAxisSize.min,
                      //                   children: <Widget>[
                      //                     Expanded(
                      //                       // Set a specific height
                      //                       child: ListView.separated(
                      //                         itemCount: 4,
                      //                         separatorBuilder:
                      //                             (BuildContext context,
                      //                                     int index) =>
                      //                                 const Divider(),
                      //                         itemBuilder:
                      //                             (BuildContext context,
                      //                                 int index) {
                      //                           return ListTile(
                      //                             onTap: () {
                      //                               Navigator.pop(
                      //                                   context); // Close the drawer or navigate back
                      //                               if (index == 0) {
                      //                                 Get.toNamed(Routes
                      //                                     .createPost); // Navigate to "createPost" route
                      //                               } else if (index == 1) {
                      //                                 sellProduct(
                      //                                     context); // Call sellProduct function
                      //                               } else if (index == 2) {
                      //                                 Get.toNamed(Routes
                      //                                     .createevent); // Navigate to "createevent" route
                      //                               } else if (index == 3) {
                      //                                 Get.to(() =>
                      //                                     const CreatePollScreen()); // Navigate to "createPollSurvey" route
                      //                               }
                      //                             },
                      //                             minVerticalPadding: 0,
                      //                             contentPadding:
                      //                                 const EdgeInsets.only(
                      //                                     left: 10),
                      //                             leading: index == 3
                      //                                 ? const Icon(
                      //                                     Icons.poll,
                      //                                     color: Colors.black,
                      //                                   )
                      //                                 : SvgPicture.asset(
                      //                                     index == 0
                      //                                         ? 'assets/svgs/text.svg'
                      //                                         : index == 1
                      //                                             ? 'assets/svgs/sellicon.svg'
                      //                                             : 'assets/svgs/liveevent.svg', // Assuming you have a "polls.svg" asset
                      //                                     height: index == 0
                      //                                         ? 25
                      //                                         : index == 1
                      //                                             ? 30
                      //                                             : index == 2
                      //                                                 ? 22
                      //                                                 : 22, // Adjust the height as needed
                      //                                     // ignore: deprecated_member_use
                      //                                     color: textColor
                      //                                         .withOpacity(1),
                      //                                   ),
                      //                             title: Text(
                      //                               index == 0
                      //                                   ? 'Create a Post'
                      //                                   : index == 1
                      //                                       ? 'Sell your product & service'
                      //                                       : index == 2
                      //                                           ? 'Create a Live Event'
                      //                                           : 'Create Polls & Surveys',
                      //                               style: const TextStyle(
                      //                                 fontSize: 18,
                      //                                 fontWeight:
                      //                                     FontWeight.w700,
                      //                               ),
                      //                             ),
                      //                           );
                      //                         },
                      //                       ),
                      //                     )
                      //                   ],
                      //                 ),
                      //               ),
                      //             );
                      //           },
                      //         );
                      //       },
                      //       child: CircleAvatar(
                      //         backgroundColor: backgroundColor,
                      //         radius: 25,
                      //         child: Icon(
                      //           Icons.add,
                      //           color: primaryColorLT,
                      //         ),
                      //       ),
                      //     )),

                      Expanded(
                        flex: 10,
                        child: BottomTabButton(
                          label: 'Marketplace',
                          icon: activeIndex == 3
                              ? 'assets/svgs/cartufilled.svg'
                              : 'assets/svgs/cartu.svg',
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
          ],
        ),
      ),
    );
  }
}
