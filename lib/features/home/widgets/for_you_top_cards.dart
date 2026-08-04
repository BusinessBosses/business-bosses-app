import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/common/widgets/user_avatar_with_badge.dart';
import 'package:business_bosses_v2/features/forum/controller/challenge_controller.dart';
import 'package:business_bosses_v2/features/forum/controller/create_bossup_controller.dart';
import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:business_bosses_v2/features/forum/presentation/create_bossup_screen.dart';
import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/impact/controllers/impact_controller.dart';
import 'package:business_bosses_v2/features/impact/presentation/impact_screen.dart';
import 'package:business_bosses_v2/features/posts/presentation/boost_post_picker_screen.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The two cards that sit at the top of the "For you" home tab:
/// "My Performance" (with Boost Visibility) and "Boss of The Week"
/// (with Get Featured).
class ForYouTopCards extends StatelessWidget {
  const ForYouTopCards({super.key});

  static const String bossUpChallengeId = '-MsUOGcOT9oRXGakCcJv';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.fromLTRB(15, 8, 15, 10),
      child: Column(
        children: <Widget>[
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const <Widget>[
                Expanded(child: _PerformanceCard()),
                SizedBox(width: 10),
                Expanded(child: _BossOfTheWeekCard()),
              ],
            ),
          ),
          const SizedBox(height: 6),
          // Explains the Reach Score; spans both tiles.
          Text(
            'One score. Ranks you everywhere',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              // Grey enough to read as a caption — at black87 it competed with
              // the post title directly beneath it.
              color: Color(0xFF616161),
            ),
          ),
        ],
      ),
    );
  }
}

class _PerformanceCard extends StatelessWidget {
  const _PerformanceCard();

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find<ProfileController>();

    return GestureDetector(
      onTap: () => Get.to(() => ReachScreen(user: profileController.myProfile)),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: const <Widget>[
                Expanded(
                  child: Text(
                    'My Reach Score',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(Icons.chevron_right, size: 18, color: Colors.black54),
              ],
            ),
            const SizedBox(height: 8),
            GetBuilder<ReachController>(
              builder: (ReachController reach) {
                final Map<String, dynamic> data =
                    reach.myReach ?? <String, dynamic>{};
                final dynamic indRank =
                    data['shopIndustryRank']?['industryRank'];
                final dynamic globRank = data['globalRank'];
                final String ranking = (indRank != null && indRank != 0)
                    ? '#$indRank'
                    : (globRank != null && globRank != 0)
                        ? '#$globRank'
                        : 'N/A';

                return Row(
                  children: <Widget>[
                    Expanded(
                      child: _metric(
                        'Reach',
                        _formatScore(data['totalReachPoints'] as num? ?? 0),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(child: _metric('Rank', ranking)),
                  ],
                );
              },
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 34,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: primaryColorLT,
                  elevation: 0,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Color(0xFFFECACA)),
                  ),
                ),
                // Open to everyone — free users can boost too, they pay for
                // the boost itself on the next screen.
                onPressed: () => Get.to(() => const BoostPostPickerScreen()),
                child: const FittedBox(
                  child: Text(
                    'Boost Visibility',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _metric(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F5F8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: <Widget>[
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: Color(0xFFB91C1C),
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Color(0xFFEF4444),
            ),
          ),
        ],
      ),
    );
  }

  String _formatScore(num value) {
    if (value >= 1000) {
      final double formatted = value / 1000;
      return '${formatted.toStringAsFixed(formatted % 1 == 0 ? 0 : 1)}k';
    }
    return value.toString();
  }
}

class _BossOfTheWeekCard extends StatelessWidget {
  const _BossOfTheWeekCard();

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find<ProfileController>();
    // The card can be built before HomeBinding's lazy controller is touched,
    // so register it here rather than assuming it exists.
    final ChallengeController challengeController =
        Get.isRegistered<ChallengeController>()
            ? Get.find<ChallengeController>()
            : Get.put(ChallengeController());

    return GetBuilder<HomeController>(
      builder: (HomeController homeController) {
        final UserModel? boss = homeController.bossOfTheWeek;
        final bool hasBoss = boss != null && boss.uid.isNotEmpty;

        return GestureDetector(
          onTap: () {
            if (hasBoss) {
              Get.toNamed(Routes.publicProfile, arguments: boss);
            }
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: const <Widget>[
                    Expanded(
                      child: Text(
                        'Boss of The Week',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(Icons.chevron_right, size: 18, color: Colors.black54),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (hasBoss)
                      UserAvatarWithBadge(
                        user: boss.copyWith(isRanked: true),
                        height: 34,
                        width: 34,
                        radius: 34,
                        avatarSize: 14,
                      )
                    else
                      const CircleAvatar(
                        radius: 17,
                        backgroundColor: Color(0xFFF3F4F6),
                        child: Icon(Icons.person,
                            size: 18, color: Colors.black38),
                      ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            hasBoss
                                ? ((boss.name ?? boss.username).trim().isEmpty
                                    ? '—'
                                    : (boss.name ?? boss.username))
                                : '—',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            boss?.bio ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 34,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColorLT,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => _enterChallenge(
                      context,
                      challengeController,
                      profileController,
                    ),
                    child: const FittedBox(
                      child: Text(
                        'Get Featured',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Same entry rules as the hero card: the Boss Up Challenge can only be
  /// entered once every 12 weeks.
  void _enterChallenge(
    BuildContext context,
    ChallengeController challengeController,
    ProfileController profileController,
  ) {
    if (challengeController.categories.isEmpty) return;
    final Industry industry = challengeController.categories[0];

    final int now = DateTime.now().millisecondsSinceEpoch;
    final int previousStamp =
        profileController.myProfile.bossOfTheWeekTimeStamp ?? 0;

    if ((previousStamp + 1209600000) > now &&
        industry.industryId == ForYouTopCards.bossUpChallengeId) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 4),
          content: Text('You may have posted in Boss Up Challenge'
              ' in the past 12 weeks. You can only post once in 12 weeks.'),
        ),
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
}
