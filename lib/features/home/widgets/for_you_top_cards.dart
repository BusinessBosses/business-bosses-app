import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/common/widgets/user_avatar_with_badge.dart';
import 'package:business_bosses_v2/features/forum/controller/challenge_controller.dart';
import 'package:business_bosses_v2/features/forum/controller/create_bossup_controller.dart';
import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:business_bosses_v2/features/forum/presentation/bossup_challenge.dart';
import 'package:business_bosses_v2/features/forum/presentation/create_bossup_screen.dart';
import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/partners/widgets/deals_section.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Top header for the "For you" feed:
/// 1. Boss of the Week tile with Follow and "Get Featured & Boost Reach" buttons
/// 2. Partners' Deals section placed right beneath it, before the first post
class ForYouTopCards extends StatelessWidget {
  const ForYouTopCards({super.key});

  static const String bossUpChallengeId = '-MsUOGcOT9oRXGakCcJv';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: const <Widget>[
        _BossOfTheWeekCard(),
        SizedBox(height: 8),
        DealsSection(),
        Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
      ],
    );
  }
}

class _BossOfTheWeekCard extends StatefulWidget {
  const _BossOfTheWeekCard();

  @override
  State<_BossOfTheWeekCard> createState() => _BossOfTheWeekCardState();
}

class _BossOfTheWeekCardState extends State<_BossOfTheWeekCard> {
  final ProfileController _profileController = Get.find<ProfileController>();
  late final ChallengeController _challengeController;

  @override
  void initState() {
    super.initState();
    _challengeController = Get.isRegistered<ChallengeController>()
        ? Get.find<ChallengeController>()
        : Get.put(ChallengeController());
  }

  Future<void> _connectToUser(UserModel boss) async {
    final bool isConnected = _profileController.myProfile.connecteds != null &&
        _profileController.myProfile.connecteds!.contains(boss.uid);

    _profileController.updateConnections(boss.uid);
    setState(() {});

    if (!isConnected) {
      await ApiService.post(
        path: 'connection/connect',
        body: <String, dynamic>{
          'userId': _profileController.myProfile.uid,
          'connectedId': boss.uid,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );
    } else {
      await ApiService.post(
        path: 'connection/disconnect',
        body: <String, dynamic>{
          'userId': _profileController.myProfile.uid,
          'connectedId': boss.uid,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );
    }
  }

  void _enterChallenge(BuildContext context) {
    if (_challengeController.categories.isEmpty) return;
    final Industry industry = _challengeController.categories[0];

    final int now = DateTime.now().millisecondsSinceEpoch;
    final int previousStamp =
        _profileController.myProfile.bossOfTheWeekTimeStamp ?? 0;

    if ((previousStamp + 1209600000) > now &&
        industry.industryId == ForYouTopCards.bossUpChallengeId) {
      showSnackbar(
        message:
            'You may have posted in Boss Up Challenge in the past 12 weeks. You can only post once in 12 weeks.',
        error: true,
      );
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

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (HomeController homeController) {
        final UserModel? boss = homeController.bossOfTheWeek;
        final bool hasBoss = boss != null && boss.uid.isNotEmpty;
        final bool isFollowing = hasBoss &&
            _profileController.myProfile.connecteds != null &&
            _profileController.myProfile.connecteds!.contains(boss.uid);

        return Container(
          color: backgroundColor,
          padding: const EdgeInsets.fromLTRB(15, 8, 15, 4),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Header row: Logo + "Boss of The Week" + Chevron
                GestureDetector(
                  onTap: () => Get.to(() => const BossupChallenge(ishome: false)),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 24.0,
                        height: 24.0,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          'assets/images/app_logo_2.png',
                          height: 24,
                          width: 24,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Boss of The Week',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(LucideIcons.chevronRight,
                          size: 18, color: Colors.black54),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Boss Info row: Avatar + Name & Bio
                GestureDetector(
                  onTap: () {
                    if (hasBoss) {
                      Get.toNamed(Routes.publicProfile, arguments: boss);
                    }
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (hasBoss)
                        UserAvatarWithBadge(
                          user: boss.copyWith(isRanked: true),
                          height: 48,
                          width: 48,
                          radius: 48,
                          avatarSize: 18,
                        )
                      else
                        const CircleAvatar(
                          radius: 24,
                          backgroundColor: Color(0xFFF3F4F6),
                          child: Icon(Icons.person,
                              size: 24, color: Colors.black38),
                        ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Flexible(
                                  child: Text(
                                    hasBoss
                                        ? ((boss.name ?? boss.username)
                                                .trim()
                                                .isEmpty
                                            ? '—'
                                            : (boss.name ?? boss.username))
                                        : '—',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                if (boss?.isSubscribed == true) ...<Widget>[
                                  const SizedBox(width: 5),
                                  SvgPicture.asset(
                                    'assets/svgs/premiumbadge.svg',
                                    height: 11,
                                    colorFilter: const ColorFilter.mode(
                                      primaryColorLT,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              boss?.bio ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.black54,
                                height: 1.25,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Action Buttons row: Follow / Following + "Get Featured & Boost Reach"
                Row(
                  children: <Widget>[
                    // Follow button
                    Expanded(
                      flex: 3,
                      child: SizedBox(
                        height: 36,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: primaryColorLT,
                            side: const BorderSide(
                              color: Color(0xFFFECACA),
                              width: 1.2,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: hasBoss ? () => _connectToUser(boss) : null,
                          child: FittedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  isFollowing
                                      ? LucideIcons.check
                                      : LucideIcons.userPlus,
                                  size: 14,
                                  color: primaryColorLT,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  isFollowing ? 'Following' : 'Follow',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                    color: primaryColorLT,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Get Featured & Boost Reach button
                    Expanded(
                      flex: 5,
                      child: SizedBox(
                        height: 36,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColorLT,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () => _enterChallenge(context),
                          child: const FittedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(LucideIcons.plus,
                                    size: 15, color: Colors.white),
                                SizedBox(width: 4),
                                Text(
                                  'Get Featured & Boost Reach',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
