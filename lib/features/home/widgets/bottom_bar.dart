import 'package:business_bosses_v2/features/chat/chat_screen.dart';
import 'package:business_bosses_v2/features/chat/controllers/chat_controller.dart';
import 'package:business_bosses_v2/features/chat/models/my_message.dart';
import 'package:business_bosses_v2/features/forum/controller/challenge_controller.dart';
import 'package:business_bosses_v2/features/forum/controller/create_bossup_controller.dart';
import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:business_bosses_v2/features/forum/presentation/create_bossup_screen.dart';
import 'package:business_bosses_v2/features/home/bottom_nav.dart';
import 'package:business_bosses_v2/features/home/marketplace_screen.dart';
import 'package:business_bosses_v2/features/home/sellProduct.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

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
    industry = controller.categories[0];
  }

  @override
  Widget build(BuildContext context) {
    ProfileController profileController = Get.find();
    ChatController chatController = Get.find();
    final Uri url = Uri.parse(urlString);

    void enterChallenge() {
      int now = DateTime.now().millisecondsSinceEpoch;
      int previousStamp =
          profileController.myProfile.bossOfTheWeekTimeStamp ?? 0;

      if ((previousStamp + 1209600000) > now &&
          industry.industryId == '-MsUOGcOT9oRXGakCcJv') {
        const SnackBar snackBar = SnackBar(
          duration: Duration(seconds: 4),
          content: Text(
            'You may have posted in Boss Up Challenge'
            ' in the past 12 weeks. You can only post once in 12 weeks.',
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        if (industry.industryId == '-MsUOGcOT9oRXGakCcJv') {
          Get.to(
            () => CreateBossUpScreen(industryModel: industry),
            arguments: <String, Object?>{
              'isBossUp': true,
              'industryId': industry.industryId,
            },
            binding: BindingsBuilder<CreateBossUpController>.put(
                () => CreateBossUpController()),
          );
        } else {
          if (profileController.myProfile.postChallenges!
              .contains(industry.industryId)) {
            const SnackBar snackBar = SnackBar(
              duration: Duration(seconds: 4),
              content: Text('You can only post once in a challenge'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            return;
          }
          Get.to(
            () => CreateBossUpScreen(industryModel: industry),
            arguments: <String, Object?>{
              'isBossUp': true,
              'industryId': industry.industryId,
            },
            binding: BindingsBuilder<CreateBossUpController>.put(
              () => CreateBossUpController(),
            ),
          );
        }
      }
    }

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
                          icon: widget.activeIndex == 0
                              ? 'assets/svgs/homeufilled.svg'
                              : 'assets/svgs/homeu.svg',
                          label: 'Home',
                          onTap: () {
                            if (widget.activeIndex == 0) {
                              widget.scrollControl?.call();
                              return;
                            }
                            Get.toNamed(Routes.home);
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
                                            onTap: () async {
                                              Navigator.pop(context);
                                              if (index == 0) {
                                                enterChallenge();
                                              } else if (index == 1) {
                                                sellProduct(context);
                                              } else if (index == 2) {
                                                Get.toNamed(Routes.createPost);
                                              } else if (index == 3) {
                                                if (!await launchUrl(url,
                                                    mode: LaunchMode
                                                        .platformDefault)) {
                                                  throw Exception(
                                                      'Could not launch $urlString');
                                                }
                                              }
                                            },
                                            minVerticalPadding: 0,
                                            contentPadding:
                                                const EdgeInsets.only(left: 10),
                                            leading: index == 0
                                                ? Icon(
                                                    LucideIcons.trophy,
                                                    color: textColor.withValues(
                                                        alpha: 1),
                                                    size: 26,
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
                                                        ? SvgPicture.asset(
                                                            'assets/svgs/text.svg',
                                                            height: 25,
                                                            color: textColor
                                                                .withValues(
                                                                    alpha: 1),
                                                          )
                                                        : Icon(
                                                            LucideIcons.globe,
                                                            color: textColor
                                                                .withValues(
                                                                    alpha: 1),
                                                            size: 26,
                                                          ),
                                            title: Text(
                                              index == 0
                                                  ? 'Share business, get featured'
                                                  : index == 1
                                                      ? 'Sell your product & service'
                                                      : index == 2
                                                          ? 'Post content, requests, etc'
                                                          : 'Create press release',
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
                          isActive: widget.activeIndex == 2,
                        ),
                      ),

                      // Marketplace
                      Expanded(
                        flex: 10,
                        child: BottomTabButton(
                          label: 'Marketplace',
                          icon: widget.activeIndex == 3
                              ? 'assets/svgs/cartufilled.svg'
                              : 'assets/svgs/cartu.svg',
                          onTap: () {
                            if (widget.activeIndex == 3) return;
                            if (widget.activeIndex == 0) {
                              Get.to(() => const MarketplaceScreen());
                            } else {
                              Get.off(() => const MarketplaceScreen());
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
