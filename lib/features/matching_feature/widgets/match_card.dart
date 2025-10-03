import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/common/widgets/user_avatar_with_badge.dart';
import 'package:business_bosses_v2/features/matching_feature/models/matchmodel.dart';
import 'package:business_bosses_v2/features/matching_feature/widgets/match_detail_modal.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class MatchCard extends StatefulWidget {
  final Match match;
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
              _buildHeader(),
              const SizedBox(height: 12),
              _buildContent(),
              const SizedBox(height: 16),
              _buildActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        if (widget.match.verified) _buildPremiumBadge(),
        const Spacer(),
        Row(
          spacing: 5,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
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
            // Always show bookmark icon, but toggle style
            GestureDetector(
              onTap: widget.onBookmarkToggle,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: widget.isBookmarked ? primaryBlue : textColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.isBookmarked
                      ? LucideIcons.bookMarked
                      : LucideIcons.bookmark,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPremiumBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: premiumGold.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.star, size: 12, color: premiumGold),
          SizedBox(width: 4),
          Text(
            'Premium',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: premiumGold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Column(
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.match.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
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
          ],
        ),
        SizedBox(height: 12),
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
        Text(
          widget.match.description,
          style: const TextStyle(
            fontSize: 15,
            color: textMedium,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                const Icon(Icons.access_time, size: 14, color: textMedium),
                const SizedBox(width: 4),
                Text(
                  widget.match.responseTime,
                  style: const TextStyle(
                    fontSize: 14,
                    color: textMedium,
                  ),
                ),
              ],
            ),
            if (widget.match.matchType != null &&
                widget.match.matchType!.isNotEmpty)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: primaryBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  widget.match.matchType!.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () => _sendProposal(context),
              icon: const Icon(LucideIcons.send, size: 16),
              label: const Text('Send Proposal'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          height: 50,
          child: OutlinedButton.icon(
            onPressed: widget.onBookmarkToggle,
            icon: Icon(
              widget.isBookmarked
                  ? LucideIcons.bookMarked
                  : LucideIcons.bookmark,
              size: 16,
            ),
            label: Text(widget.isBookmarked ? 'Saved' : 'Save'),
            style: OutlinedButton.styleFrom(
              foregroundColor: widget.isBookmarked ? successGreen : primaryBlue,
              side: BorderSide(
                  color: widget.isBookmarked ? successGreen : primaryBlue),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Proposal sent to ${widget.match.name}!'),
        backgroundColor: successGreen,
      ),
    );
  }
}
