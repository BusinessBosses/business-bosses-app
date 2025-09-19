import 'package:business_bosses_v2/features/matching_feature/models/matchmodel.dart';
import 'package:business_bosses_v2/features/matching_feature/widgets/match_detail_modal.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class MatchCard extends StatelessWidget {
  final Match match;
  final String userType;
  final bool? showsavebutton;
  final void Function()? saveontap;

  const MatchCard({
    super.key,
    required this.match,
    required this.userType,
    this.showsavebutton,
    this.saveontap,
  });

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
        Row(
          children: <Widget>[
            if (match.verified) _buildPremiumBadge(),
          ],
        ),
        const Spacer(),
        Row(
          spacing: 5,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.green),
              child: Text(
                '90%',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            if (showsavebutton == true)
              GestureDetector(
                onTap: saveontap,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: textColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    LucideIcons.bookmark,
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

  Widget _buildVerifiedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: successGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.verified, size: 12, color: successGreen),
          SizedBox(width: 4),
          Text(
            'Verified',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: successGreen,
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
        Text(
          match.name,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
        ),
        Text(
          match.type,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: primaryBlue,
          ),
        ),
        Row(
          children: <Widget>[
            const Icon(Icons.star, size: 16, color: premiumGold),
            const SizedBox(width: 4),
            Text(
              match.rating.toString(),
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
              match.location,
              style: const TextStyle(
                fontSize: 14,
                color: textMedium,
              ),
            ),
          ],
        ),
        Text(
          match.description,
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
                  match.responseTime,
                  style: const TextStyle(
                    fontSize: 14,
                    color: textMedium,
                  ),
                ),
              ],
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
        if (showsavebutton != true) const SizedBox(width: 12),
        if (showsavebutton != true)
          SizedBox(
            height: 50,
            child: OutlinedButton.icon(
              onPressed: () => _saveOpportunity(context),
              icon: const Icon(LucideIcons.bookmark, size: 16),
              label: const Text('Save'),
              style: OutlinedButton.styleFrom(
                foregroundColor: primaryBlue,
                side: const BorderSide(color: primaryBlue),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Color _getMatchColor(int percentage) {
    if (percentage >= 90) return successGreen;
    if (percentage >= 80) return premiumGold;
    return textMedium;
  }

  void _showMatchDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) =>
          //  Prematchmodal()
          MatchDetailModal(match: match, userType: userType),
    );
  }

  void _sendProposal(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Proposal sent to ${match.name}!'),
        backgroundColor: successGreen,
      ),
    );
  }

  void _saveOpportunity(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opportunity saved!'),
        backgroundColor: successGreen,
      ),
    );
  }
}
