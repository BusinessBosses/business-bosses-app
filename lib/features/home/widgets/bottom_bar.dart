// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:business_bosses_v2/features/aipromote/ai_promote_sheet.dart';
import 'package:business_bosses_v2/features/chat/chat_screen.dart';
import 'package:business_bosses_v2/features/chat/controllers/chat_controller.dart';
import 'package:business_bosses_v2/features/chat/models/my_message.dart';
import 'package:business_bosses_v2/features/forum/controller/challenge_controller.dart';
import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:business_bosses_v2/features/forum/presentation/bossup_screen.dart';
import 'package:business_bosses_v2/features/home/bottom_nav.dart';
import 'package:business_bosses_v2/features/home/marketplace_screen.dart';
import 'package:business_bosses_v2/features/home/sellProduct.dart';
import 'package:business_bosses_v2/features/posts/presentation/create_poll_screen.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';

class BottomBar extends StatelessWidget {
  BottomBar({
    super.key,
    required this.activeIndex,
    this.scrollControl,
  });
  final int activeIndex;
  final VoidCallback? scrollControl;
  final ChallengeController controller = Get.put(ChallengeController());

  @override
  Widget build(BuildContext context) {
    void showPromoteSheet() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) => AIPromoteSheet(),
      );
    }

    final Industry category = controller.categories[0];
    ProfileController profileController = Get.find();
    ChatController chatController = Get.find();
    return Align(
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
                          icon: activeIndex == 0
                              ? 'assets/svgs/homeufilled.svg'
                              : 'assets/svgs/homeu.svg',
                          label: 'Home',
                          onTap: () {
                            if (activeIndex == 0) {
                              scrollControl;
                              return;
                            }
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
                                : 'assets/svgs/bottombarchat.svg',
                            label: 'Inbox',
                            onTap: () {
                              if (activeIndex == 1) return;

                              if (activeIndex == 0) {
                                //   profileController.myProfile.isSubscribed
                                //       ? Get.to(() =>const Bottomnavscreen(noBack: false))
                                Get.to(() => const ChatScreen());
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
                              top: 6,
                              right: 22,
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
                          widget: const CircleAvatar(
                            radius: 18,
                            backgroundColor: primaryColorLT,
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                          // icon: activeIndex == 2
                          //     ? 'assets/svgs/bossupufilled.svg'
                          //     : 'assets/svgs/bossupu.svg',
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(25.0),
                                ),
                              ),
                              builder: (BuildContext context) {
                                return Stack(
                                  children: <Widget>[
                                    SizedBox(
                                      height:
                                          380, // Increased height to accommodate the new item
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Expanded(
                                              child: ListView.separated(
                                                itemCount:
                                                    5, // Changed to 5 items
                                                separatorBuilder:
                                                    (BuildContext context,
                                                            int index) =>
                                                        const Divider(),
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return ListTile(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      if (index == 0) {
                                                        showPromoteSheet();
                                                      } else if (index == 1) {
                                                        Get.toNamed(
                                                            Routes.createPost);
                                                      } else if (index == 2) {
                                                        sellProduct(context);
                                                      } else if (index == 3) {
                                                        Get.toNamed(
                                                            Routes.createevent);
                                                      } else if (index == 4) {
                                                        Get.to(() =>
                                                            const CreatePollScreen());
                                                      }
                                                    },
                                                    minVerticalPadding: 0,
                                                    contentPadding:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    leading: index == 4
                                                        ? const Icon(
                                                            Icons.poll,
                                                            color: textColor,
                                                          )
                                                        : index == 0
                                                            ? Container(
                                                                width: 30,
                                                                height: 30,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              30),
                                                                  gradient:
                                                                      LinearGradient(
                                                                    colors: <Color>[
                                                                      Color(
                                                                          0xFF6366F1),
                                                                      Color(
                                                                          0xFF818CF8)
                                                                    ],
                                                                    begin: Alignment
                                                                        .topLeft,
                                                                    end: Alignment
                                                                        .bottomRight,
                                                                  ),
                                                                ),
                                                                child: Material(
                                                                  color: Colors
                                                                      .transparent,
                                                                  child:
                                                                      InkWell(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            30),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .star,
                                                                        color: Colors
                                                                            .white,
                                                                        size:
                                                                            24,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            : SvgPicture.asset(
                                                                index == 1
                                                                    ? 'assets/svgs/text.svg'
                                                                    : index == 2
                                                                        ? 'assets/svgs/sellicon.svg'
                                                                        : 'assets/svgs/eventu.svg',
                                                                height: index ==
                                                                        1
                                                                    ? 25
                                                                    : index == 2
                                                                        ? 30
                                                                        : 22,
                                                                color: textColor
                                                                    .withValues(
                                                                        alpha:
                                                                            1),
                                                              ),
                                                    title: Text(
                                                      index == 0
                                                          ? 'Enter Free Business Promotion'
                                                          : index == 1
                                                              ? 'Post content, discussion, etc'
                                                              : index == 2
                                                                  ? 'Sell your product & service'
                                                                  : index == 3
                                                                      ? 'Create an event'
                                                                      : 'Create polls & surveys',
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Positioned(
                                    //     bottom: 25,
                                    //     right: 15,
                                    //     child: Container(
                                    //       width: 60,
                                    //       height: 60,
                                    //       decoration: BoxDecoration(
                                    //         borderRadius:
                                    //             BorderRadius.circular(30),
                                    //         gradient: LinearGradient(
                                    //           colors: <Color>[
                                    //             Color(0xFF6366F1),
                                    //             Color(0xFF818CF8)
                                    //           ],
                                    //           begin: Alignment.topLeft,
                                    //           end: Alignment.bottomRight,
                                    //         ),
                                    //         boxShadow: <BoxShadow>[
                                    //           BoxShadow(
                                    //             color: Colors.black
                                    //                 .withValues(alpha: 0.3),
                                    //             offset: Offset(0, 4),
                                    //             blurRadius: 8,
                                    //           ),
                                    //         ],
                                    //       ),
                                    //       child: Material(
                                    //         color: Colors.transparent,
                                    //         child: InkWell(
                                    //           borderRadius:
                                    //               BorderRadius.circular(30),
                                    //           onTap: showPromoteSheet,
                                    //           child: Center(
                                    //             child: Icon(
                                    //               Icons.auto_fix_high,
                                    //               color: Colors.white,
                                    //               size: 24,
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     )),
                                  ],
                                );
                              },
                            );
                          },
                          label: 'Post',
                          isActive: activeIndex == 2,
                        ),
                      ),
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
                              Get.to(() => const MarketplaceScreen());
                            } else {
                              Get.off(() => const MarketplaceScreen());
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
