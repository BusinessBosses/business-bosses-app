// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:business_bosses_v2/features/home/all_communities_screen.dart';
import 'package:business_bosses_v2/features/home/bottom_nav.dart';
import 'package:business_bosses_v2/features/home/widgets/buyer_requests_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:business_bosses_v2/features/chat/chat_screen.dart';
import 'package:business_bosses_v2/features/chat/controllers/chat_controller.dart';
import 'package:business_bosses_v2/features/chat/models/my_message.dart';
import 'package:business_bosses_v2/features/forum/controller/challenge_controller.dart';
import 'package:business_bosses_v2/features/home/marketplace_screen.dart';
import 'package:business_bosses_v2/features/home/sellProduct.dart';
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
                      // Home
                      Expanded(
                        flex: 10,
                        child: BottomTabButton(
                          icon: activeIndex == 0
                              ? 'assets/svgs/homeufilled.svg'
                              : 'assets/svgs/homeu.svg',
                          label: 'Home',
                          onTap: () {
                            if (activeIndex == 0) {
                              scrollControl?.call();
                              return;
                            }
                            Get.toNamed(Routes.home);
                          },
                          isActive: activeIndex == 0,
                        ),
                      ),

                      // Inbox
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
                                Get.to(() => const ChatScreen());
                              } else {
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
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(25.0),
                                ),
                              ),
                              builder: (BuildContext context) {
                                return Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      ListView.separated(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: 4,
                                        separatorBuilder:
                                            (BuildContext context, int index) =>
                                                const Divider(),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return ListTile(
                                            onTap: () {
                                              Navigator.pop(context);
                                              if (index == 0) {
                                                Get.toNamed(Routes.createPost);
                                              } else if (index == 1) {
                                                sellProduct(context);
                                              } else if (index == 2) {
                                                Get.to(BuyerRequests());
                                              } else if (index == 3) {
                                                Get.to(AllCommunitiesScreen());
                                              }
                                            },
                                            minVerticalPadding: 0,
                                            contentPadding:
                                                const EdgeInsets.only(left: 10),
                                            leading: index == 0
                                                ? SvgPicture.asset(
                                                    'assets/svgs/text.svg',
                                                    height: 25,
                                                    color: textColor.withValues(
                                                        alpha: 1),
                                                  )
                                                : index == 1
                                                    ? SvgPicture.asset(
                                                        'assets/svgs/sellicon.svg',
                                                        height: 25,
                                                        color: textColor
                                                            .withValues(
                                                                alpha: 1),
                                                      )
                                                    : index == 2
                                                        ? Icon(
                                                            LucideIcons.coins,
                                                            color: textColor
                                                                .withValues(
                                                                    alpha: 1),
                                                            size: 26,
                                                          )
                                                        : Icon(
                                                            LucideIcons.gift,
                                                            color: textColor
                                                                .withValues(
                                                                    alpha: 1),
                                                            size: 26,
                                                          ),
                                            title: Text(
                                              index == 0
                                                  ? 'Post content, discussion, etc'
                                                  : index == 1
                                                      ? 'Sell your product & service'
                                                      : index == 2
                                                          ? 'Create buyer request'
                                                          : 'Enter free promotion',
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          label: 'Post',
                          isActive: activeIndex == 2,
                        ),
                      ),

                      // Marketplace
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

                      // Profile
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
