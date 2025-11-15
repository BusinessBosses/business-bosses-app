import 'package:business_bosses_v2/action/action.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/impact/controllers/impact_controller.dart';
import 'package:business_bosses_v2/features/impact/widgets/impactheadercard.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ReachScreen extends StatefulWidget {
  final UserModel user;
  const ReachScreen({super.key, required this.user});

  @override
  State<ReachScreen> createState() => _ReachScreenState();
}

class _ReachScreenState extends State<ReachScreen> {
  final ReachController controller = Get.put(ReachController());
  final ProfileController profileController = Get.find();
  late String _referralId;

  @override
  void initState() {
    super.initState();
    controller.loadData(widget.user.uid);
    _referralId = profileController.myProfile.inviteId!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        ),
        centerTitle: true,
        title: const Text(
          'Reach',
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          if (widget.user == profileController.myProfile)
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: GestureDetector(
                onTap: () {
                  _shareWithFriends();
                },
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: backgroundColor,
                  child: Icon(
                    LucideIcons.plus,
                    size: 20,
                    color: textColor,
                  ), // Invisible icon to maintain size'),
                ),
              ),
            )
        ],
      ),
      body: Obx(() {
        if (controller.loading.value) {
          return const SafetyModel();
        }

        final invites = controller.data['invitesThisWeek'] ?? 0;
        final rank = controller.data['rank'] ?? 12;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ReachHeaderCard(data: controller.data),

              /// Ambassador Challenge Sectionuser
              if (widget.user == profileController.myProfile)
                Container(
                  width: double.infinity,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        '🏆 Win Ambassador of the Week!',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Boost your Reach Score by getting more likes, views, and referrals this week to move up the leaderboard!',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Colors.black87,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Challenge + Progress
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: invites / 10,
                          minHeight: 8,
                          backgroundColor: Colors.grey.shade50,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '$invites / 10 invites completed',
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black87),
                      ),
                      const SizedBox(height: 8),

                      // Rank Display
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text(
                            'Your Rank:',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            '#$rank',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Text(
                                  'Invite friends to increase rank',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16),
                                ),
                                Text(
                                  'Invite ID : ${profileController.myProfile.inviteId!}',
                                  style: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w700),
                                )
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                _shareWithFriends();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 2, color: primaryColorLT),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    const Text(
                                      'Invite',
                                      style: TextStyle(
                                          color: primaryColorLT,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16),
                                    ),
                                    SizedBox(width: 5),
                                    SvgPicture.asset(
                                      'assets/svgs/invite.svg',
                                      color: primaryColorLT,
                                      height: 13,
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 15),
            ],
          ),
        );
      }),
    );
  }

  void _shareWithFriends() {
    // ignore: unnecessary_null_comparison
    if (_referralId == null) return;
    String message = 'Check out Business Bosses.\n'
        'An app to meet entrepreneurs and grow your business. Join now for FREE promotion\n'
        'https://businessbosses.onelink.me/xLWk/36a2ff16\n'
        'Invite id: $_referralId';
    socialShare(message);
  }
}
