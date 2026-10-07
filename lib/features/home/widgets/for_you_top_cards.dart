import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/common/widgets/user_avatar_with_badge.dart';
import 'package:business_bosses_v2/features/forum/controller/challenge_controller.dart';
import 'package:business_bosses_v2/features/forum/controller/create_bossup_controller.dart';
import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:business_bosses_v2/features/forum/presentation/bossup_challenge.dart';
import 'package:business_bosses_v2/features/forum/presentation/bossup_screen.dart';
import 'package:business_bosses_v2/features/forum/presentation/create_bossup_screen.dart';
import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/partners/widgets/deals_section.dart';
import 'package:business_bosses_v2/features/forum/presentation/get_featured_sheet.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
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
  late final ChallengeController _challengeController;

  @override
  void initState() {
    super.initState();
    _challengeController = Get.isRegistered<ChallengeController>()
        ? Get.find<ChallengeController>()
        : Get.put(ChallengeController());
  }





  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (HomeController homeController) {
        final UserModel? boss = homeController.bossOfTheWeek;
        final bool hasBoss = boss != null && boss.uid.isNotEmpty;

        return Container(
          color: backgroundColor,
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F4),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Header row: Logo + "Boss of The Week" + Chevron
                GestureDetector(
                  onTap: () {
                    if (_challengeController.categories.isNotEmpty) {
                      final Industry category = _challengeController.categories[0];
                      Get.to(() => BossUpSection(
                            industry: category,
                            bossUp: category,
                          ));
                    } else {
                      Get.to(() => const BossupChallenge(ishome: false));
                    }
                  },
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 26.0,
                        height: 26.0,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          'assets/images/app_logo_2.png',
                          height: 26,
                          width: 26,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Boss of The Week',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(LucideIcons.chevronRight,
                          size: 20, color: Colors.black54),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Boss Info row: Avatar + Name & Bio
                GestureDetector(
                  onTap: () {
                    if (hasBoss) {
                      Get.toNamed(Routes.publicProfile, arguments: boss);
                    }
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      if (hasBoss)
                        UserAvatarWithBadge(
                          user: boss.copyWith(isRanked: true),
                          height: 58,
                          width: 58,
                          radius: 58,
                          avatarSize: 22,
                        )
                      else
                        const CircleAvatar(
                          radius: 29,
                          backgroundColor: Color(0xFFE5E7EB),
                          child: Icon(Icons.person,
                              size: 30, color: Colors.black38),
                        ),
                      const SizedBox(width: 12),
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
                                        : 'MOSES MUTUA',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ),
                                if (boss?.isSubscribed == true) ...<Widget>[
                                  const SizedBox(width: 6),
                                  SvgPicture.asset(
                                    'assets/svgs/premiumbadge.svg',
                                    height: 14,
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
                              boss?.bio != null && boss!.bio!.trim().isNotEmpty
                                  ? boss.bio!
                                  : 'marketing shoes and more',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF666666),
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Action Buttons row: Boost Reach (white pill) + Get Featured (red pill)
                Row(
                  children: <Widget>[
                    // Boost Reach button (replaces Follow button area)
                    Expanded(
                      flex: 4,
                      child: SizedBox(
                        height: 42,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: primaryColorLT,
                            side: const BorderSide(
                              color: Colors.transparent,
                              width: 0,
                            ),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                            ),
                          ),
                          onPressed: () {
                            if (_challengeController.categories.isNotEmpty) {
                              final Industry industry = _challengeController.categories[0];
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
                            } else {
                              Get.to(() => const BossupChallenge(ishome: false));
                            }
                          },
                          child: const Text(
                            'Boost Reach',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                              color: primaryColorLT,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // + Get Featured button (solid red pill)
                    Expanded(
                      flex: 5,
                      child: SizedBox(
                        height: 42,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColorLT,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                            ),
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (BuildContext _) => const GetFeaturedSheet(),
                            );
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(LucideIcons.plus,
                                  size: 16, color: Colors.white),
                              SizedBox(width: 4),
                              Text(
                                'Get Featured',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ],
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
