import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/features/home/widgets/winnercard.dart';
import 'package:business_bosses_v2/features/withdrawal/presentation/deposit_screen.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

class MatchCard extends StatefulWidget {
  final UserModel match;
  final String userType;
  final bool isBookmarked;
  final void Function()? onBookmarkToggle;
  final bool isExpanded;

  const MatchCard({
    super.key,
    required this.match,
    required this.userType,
    required this.isBookmarked,
    this.onBookmarkToggle,
    this.isExpanded = true,
  });

  @override
  State<MatchCard> createState() => _MatchCardState();
}

class _MatchCardState extends State<MatchCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.publicProfile, arguments: widget.match);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 15, top: 8, bottom: 8, right: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  spacing: 10,
                  children: <Widget>[
                    NetworkImageWithPlaceHolder(
                      imageUrl: widget.match.photoUrl,
                      height: 40,
                      width: 40,
                      radius: 50,
                      cacheHeight: 256,
                      cacheWidth: 256,
                      placeHolder: Icons.person,
                      iconSize: 24,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Flexible(
                                child: Text(
                                  widget.match.name ?? widget.match.username,
                                  maxLines: isExpanded ? 100 : 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: textDark,
                                  ),
                                ),
                              ),
                              if (widget.match.isSubscribed) ...<Widget>[
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.verified,
                                  size: 15,
                                  color: primaryColorLT,
                                ),
                              ],
                            ],
                          ),
                          if (widget.match.matchType != null &&
                              widget.match.matchType != '')
                            Text(
                              widget.match.matchType == 'partner'
                                  ? 'Partner with me'
                                  : widget.match.matchType ?? '',
                              maxLines: isExpanded ? 100 : 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: primaryBlue,
                              ),
                            ),
                          if (widget.match.mentorCount! > 0)
                            IntrinsicWidth(
                              child: WinnerCard(
                                  isMatchCard: true,
                                  type: WinnerType.mentor,
                                  winCount: widget.match.mentorCount!),
                            ),
                          if (widget.match.backerCount! > 0)
                            IntrinsicWidth(
                              child: WinnerCard(
                                  isMatchCard: true,
                                  type: WinnerType.backer,
                                  winCount: widget.match.backerCount!),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: <Widget>[
                    const Icon(Icons.star, size: 16, color: premiumGold),
                    const SizedBox(width: 4),
                    Text(
                      widget.match.averageRating.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textDark,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(LucideIcons.mapPin, size: 14, color: textMedium),
                    const SizedBox(width: 4),
                    Text(
                      widget.match.location ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        color: textMedium,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.end,
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: <Widget>[
                    //     Text(
                    //       '${widget.match.weeklyRank}% Match',
                    //       style: const TextStyle(
                    //         color: Colors.green,
                    //         fontWeight: FontWeight.bold,
                    //         fontSize: 12,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
                Text(
                  widget.match.bio ?? '',
                  maxLines: isExpanded ? 100 : 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    color: textMedium,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          Icon(LucideIcons.chevronRight, color: textMedium, size: 18),
        ],
      ),
    );
  }
}
