import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:share_plus/share_plus.dart';

class ReachRankingCard extends StatelessWidget {
  final dynamic data;
  final int rank;
  final String industry;
  final String location;
  final VoidCallback onViewLeaderboard;
  final bool showShareButton;
  final bool isMe;

  const ReachRankingCard({
    super.key,
    required this.data,
    required this.rank,
    required this.industry,
    required this.location,
    required this.onViewLeaderboard,
    this.showShareButton = true,
    this.isMe = true,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasShop = data?['hasShop'] == true;

    final int? industryRank = data?['shopIndustryRank']?['industryRank'] ?? 0;

    final int? globalRank = data?['globalRank'] ?? 0;

    final int displayRank = hasShop ? (industryRank ?? 0) : (globalRank ?? 0);

    return Stack(children: <Widget>[
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              Colors.black54,
              Colors.black54.withValues(alpha: 0.8)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  isMe ? 'Your Ranking this week' : 'Weekly Rank',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (showShareButton)
                  IconButton(
                    onPressed: _shareRanking,
                    icon: const Icon(LucideIcons.share, color: Colors.white),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  displayRank > 0 ? '#$displayRank' : '--',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            const Icon(
                              LucideIcons.briefcase,
                              color: Colors.white70,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: ClipRect(
                                child: Text(
                                  industry,
                                  maxLines: 1,
                                  overflow: TextOverflow.clip,
                                  softWrap: false,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: <Widget>[
                            const Icon(
                              LucideIcons.mapPin,
                              color: Colors.white70,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              location,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onViewLeaderboard,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: primaryColorLT,
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/leaderboard.png',
                    height: 30,
                  ),
                  const SizedBox(width: 10),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'View Top Ranking',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: textColor),
                      ),
                      GestureDetector(
                        onTap: onViewLeaderboard,
                        child: Icon(
                          LucideIcons.chevronRight,
                          size: 18,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      Positioned(
        bottom: 0,
        right: 0,
        child: IgnorePointer(
          child: SvgPicture.asset(
            'assets/svgs/chart.svg',
            height: 150,
          ),
        ),
      ),
    ]);
  }

  void _shareRanking() {
    SharePlus.instance.share(
      ShareParams(
          text:
              'I just ranked #${data?['shopIndustryRank']?['industryRank'] ?? 0} on Business Bosses! 🚀 Check out my business reach.\nhttps://businessbosses.onelink.me/xLWk/36a2ff16'),
    );
  }
}
