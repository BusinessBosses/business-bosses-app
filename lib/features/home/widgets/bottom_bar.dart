import 'package:business_bosses_v2/features/marketplace/presentation/buyer_requests_form.dart';
import 'package:business_bosses_v2/features/chat/chat_screen.dart';
import 'package:business_bosses_v2/features/chat/controllers/chat_controller.dart';
import 'package:business_bosses_v2/features/chat/models/my_message.dart';
import 'package:business_bosses_v2/features/forum/controller/challenge_controller.dart';
import 'package:business_bosses_v2/features/forum/controller/create_bossup_controller.dart';
import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:business_bosses_v2/features/forum/presentation/create_bossup_screen.dart';
import 'package:business_bosses_v2/features/home/bottom_nav.dart';
import 'package:business_bosses_v2/features/aipromote/ai_promote_sheet.dart';
import 'package:business_bosses_v2/features/home/sell_product.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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

  void _showPostOptionsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 30),

              // Post with AI
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (BuildContext context) => const AIPromoteSheet(),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color(0xFF0D47A1), width: 1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: SvgPicture.asset(
                          'assets/svgs/ai_pencil.svg',
                          height: 30,
                          width: 30,
                          placeholderBuilder: (BuildContext context) =>
                              const Icon(Icons.auto_awesome,
                                  color: Color(0xFF0D47A1), size: 30),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                const Text(
                                  'Post with AI ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFD54F),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: const Text(
                                    'Get Matched',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Get featured, get match, and discover new opportunities faster.',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Sell my product or service
              _buildOptionItem(
                iconPath: 'assets/svgs/sell_bag.svg',
                iconData: Icons.shopping_bag_outlined,
                iconColor: const Color(0xFFF8BBD0),
                title: 'Sell my product or service',
                subtitle:
                    'Showcase what you offer to buyers searching right now',
                onTap: () {
                  Navigator.pop(context);
                  sellProduct(context);
                },
              ),
              const SizedBox(height: 15),

              // Need a Product or Service
              _buildOptionItem(
                iconPath: 'assets/svgs/need_doc.svg',
                iconData: Icons.description_outlined,
                iconColor: const Color(0xFFE8F5E9),
                title: 'Need a Product or Service',
                subtitle:
                    'Post what you need and get matched with the right supplier',
                onTap: () {
                  Navigator.pop(context);
                  Get.to(() => const AddBuyerRequests());
                },
              ),
              const SizedBox(height: 15),

              // Start a conversation
              _buildOptionItem(
                iconPath: 'assets/svgs/chat_bubble.svg',
                iconData: Icons.chat_bubble_outline,
                iconColor: const Color(0xFFFFF9C4),
                title: 'Start a conversation',
                subtitle:
                    'Share content, updates, announcements, or discussion.',
                onTap: () {
                  Navigator.pop(context);
                  Get.toNamed(Routes.createPost);
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOptionItem({
    required String iconPath,
    required IconData iconData,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[200]!, width: 1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SvgPicture.asset(
                iconPath,
                height: 24,
                width: 24,
                placeholderBuilder: (BuildContext context) => Icon(iconData,
                    color: iconColor.withValues(alpha: 1.0), size: 24),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ProfileController profileController = Get.find();
    ChatController chatController = Get.find();

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
                          onTap: () => _showPostOptionsSheet(context),
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
