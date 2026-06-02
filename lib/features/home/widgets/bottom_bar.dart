import 'package:business_bosses_v2/features/home/utils/post_options_sheet.dart';
import 'package:business_bosses_v2/features/chat/chat_screen.dart';
import 'package:business_bosses_v2/features/chat/controllers/chat_controller.dart';
import 'package:business_bosses_v2/features/chat/models/my_message.dart';
import 'package:business_bosses_v2/features/forum/controller/challenge_controller.dart';
import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:business_bosses_v2/features/home/bottom_nav.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({
    super.key,
    required this.activeIndex,
    this.scrollControl,
  });

  final int activeIndex;
  final VoidCallback? scrollControl;

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  final ChallengeController controller = Get.put(ChallengeController());
  final String urlString = 'https://google.com';

  late Industry industry;

  @override
  void initState() {
    super.initState();
    if (controller.categories.isNotEmpty) {
      industry = controller.categories[0];
    } else {
      industry = Industry(
        industryId: '',
        industry: '',
        categoryId: '',
        description: '',
      );
    }
  }

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
              color: Colors.black.withValues(alpha: 0.08),
              spreadRadius: 10,
              blurRadius: 50,
              offset: const Offset(0, 7),
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
                      // Home (formerly Marketplace)
                      Expanded(
                        flex: 10,
                        child: BottomTabButton(
                          label: 'Home',
                          icon: widget.activeIndex == 0
                              ? 'assets/svgs/homeufilled.svg'
                              : 'assets/svgs/homeu.svg',
                          onTap: () {
                            if (widget.activeIndex == 0) return;
                            Get.toNamed(Routes.marketPlace);
                          },
                          isActive: widget.activeIndex == 0,
                        ),
                      ),

                      // Inbox
                      Expanded(
                        flex: 10,
                        child: Stack(children: <Widget>[
                          BottomTabButton(
                            icon: widget.activeIndex == 1
                                ? 'assets/svgs/messagefilled.svg'
                                : 'assets/svgs/bottombarchat.svg',
                            label: 'Inbox',
                            onTap: () {
                              if (widget.activeIndex == 1) return;
                              if (widget.activeIndex == 0) {
                                Get.to(() => const ChatScreen());
                              } else {
                                Get.off(() => const ChatScreen());
                              }
                            },
                            isActive: widget.activeIndex == 1,
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
                                    color: Colors.white,
                                    width: 2.0,
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

                      // Post (+ button)
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
                          onTap: () => PostOptionsBottomSheet.show(context),
                          label: 'Post',
                          isActive: widget.activeIndex == 2,
                        ),
                      ),

                      // Home
                      Expanded(
                        flex: 10,
                        child: BottomTabButton(
                          icon: widget.activeIndex == 3
                              ? 'assets/svgs/bossupu.svg'
                              : 'assets/svgs/bossup.svg',
                          label: 'Boss Up',
                          onTap: () {
                            if (widget.activeIndex == 3) {
                              widget.scrollControl?.call();
                              return;
                            }
                            if (widget.activeIndex == 0) {
                              Get.toNamed(Routes.home);
                            } else {
                              Get.offAndToNamed(Routes.home);
                            }
                          },
                          isActive: widget.activeIndex == 3,
                        ),
                      ),

                      // Profile
                      Expanded(
                        flex: 10,
                        child: BottomTabButton(
                          icon: '',
                          onTap: () {
                            if (widget.activeIndex == 4) return;
                            if (widget.activeIndex == 0) {
                              Get.toNamed(Routes.myProfile);
                            } else {
                              Get.offAndToNamed(Routes.myProfile);
                            }
                          },
                          isActive: widget.activeIndex == 4,
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
