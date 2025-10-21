import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/features/chat/chat_room_screen.dart';
import 'package:business_bosses_v2/features/matching_feature/models/match_model.dart';
import 'package:business_bosses_v2/features/matching_feature/widgets/match_detail_modal.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

class MatchCard extends StatefulWidget {
  final MatchModel match;
  final String userType;
  final bool isBookmarked;
  final void Function()? onBookmarkToggle;

  const MatchCard({
    super.key,
    required this.match,
    required this.userType,
    required this.isBookmarked,
    this.onBookmarkToggle,
  });

  @override
  State<MatchCard> createState() => _MatchCardState();
}

class _MatchCardState extends State<MatchCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showMatchDetails(context),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.publicProfile,
                        arguments: widget.match.user);
                  },
                  child: Row(
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
                                    widget.match.name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: textDark,
                                    ),
                                  ),
                                ),
                                if (widget.match.verified) ...<Widget>[
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.verified,
                                    size: 15,
                                    color: primaryColorLT,
                                  ),
                                ],
                              ],
                            ),
                            Text(
                              widget.match.type,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: primaryBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: <Widget>[
                    const Icon(Icons.star, size: 16, color: premiumGold),
                    const SizedBox(width: 4),
                    Text(
                      widget.match.rating.toString(),
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
                      widget.match.location,
                      style: const TextStyle(
                        fontSize: 14,
                        color: textMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  widget.match.description,
                  style: const TextStyle(
                    fontSize: 15,
                    color: textMedium,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.green,
                ),
                child: Text(
                  '${widget.match.quality}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const Spacer(),
              OutlinedButton.icon(
                onPressed: () => _sendProposal(context),
                icon: const Icon(LucideIcons.messageCircle, size: 16),
                label: const Text('Send Message'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showMatchDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) =>
          MatchDetailModal(match: widget.match, userType: widget.userType),
    );
  }

  void _sendProposal(BuildContext context) {
    Get.to(
      () => const ChatRoomScreen(
        frommarketplace: false,
      ),
      arguments: widget.match.user,
    );
  }
}
