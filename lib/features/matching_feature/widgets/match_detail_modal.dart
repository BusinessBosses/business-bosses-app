import 'package:business_bosses_v2/features/chat/chat_room_screen.dart';
import 'package:business_bosses_v2/features/matching_feature/controllers/match_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

// Your app's theme and the standardized Match model
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:business_bosses_v2/features/matching_feature/models/match_model.dart';

class MatchDetailModal extends StatefulWidget {
  // UPDATED: Now uses the correct 'Match' model
  final MatchModel match;
  final String userType;

  const MatchDetailModal({
    super.key,
    required this.match,
    required this.userType,
  });

  @override
  State<MatchDetailModal> createState() => _MatchDetailModalState();
}

class _MatchDetailModalState extends State<MatchDetailModal> {
  final MatchController matchController = Get.find<MatchController>();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: <Widget>[
              _buildHandle(),
              _buildHeader(context),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _buildMatchInfo(),
                        const SizedBox(height: 24),
                        if (widget.match.services.isNotEmpty) ...<Widget>[
                          _buildServices(),
                          const SizedBox(height: 24),
                        ],
                        _buildDetails(),
                        const SizedBox(height: 32),
                        _buildActionSection(context),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Text(
            'Match Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: backgroundColor,
              child: const Icon(LucideIcons.x, size: 20, color: textColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // UPDATED: Now only shows the 'Verified' badge based on the model
            if (widget.match.verified) _buildVerifiedBadge(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                // UPDATED: Color is now dynamic based on quality
                color: _getMatchColor(widget.match.quality),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                // UPDATED: Text is now dynamic from match.quality
                '${widget.match.quality}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: <Widget>[
            Text(
              // UPDATED: Displays actual data
              widget.match.name,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: textDark,
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
        const SizedBox(height: 4),
        Text(
          // UPDATED: Displays actual data
          widget.match.type,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: primaryBlue,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: <Widget>[
            const Icon(Icons.star, size: 20, color: premiumGold),
            const SizedBox(width: 6),
            Text(
              // UPDATED: Displays actual data
              widget.match.rating.toString(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textDark,
              ),
            ),
            const SizedBox(width: 16),
            const Icon(LucideIcons.mapPin, size: 16, color: textMedium),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                // UPDATED: Displays actual data
                widget.match.location,
                style: const TextStyle(fontSize: 16, color: textMedium),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          // UPDATED: Displays actual data
          widget.match.description,
          style: const TextStyle(
            fontSize: 16,
            color: textMedium,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildServices() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Services', // Changed from 'Services Offered' for brevity
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.match.services
              .map((String service) => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: primaryBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      service,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: primaryBlue,
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: <Widget>[
            Expanded(
              // UPDATED: Passes actual data and handles nulls
              child:
                  _buildDetailCard('Response Time', widget.match.responseTime),
            ),
            const SizedBox(width: 12),
            Expanded(
              // UPDATED: Passes actual data and handles nulls
              child: _buildDetailCard(
                  'Budget Range', widget.match.budget ?? 'Not Specified'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundGray,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: textMedium),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionSection(BuildContext context) {
    final bool isBookmarked = matchController.isBookmarked(widget.match.id);
    // Determine the button text, icon, and colors based on the bookmark status
    return Column(
      children: <Widget>[
        const Text(
          'Ready to Connect?',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: textDark),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const Text(
          'Send a proposal or save this opportunity for later',
          style: TextStyle(fontSize: 16, color: textMedium),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton.icon(
            onPressed: () => _sendProposal(context),
            icon: const Icon(LucideIcons.messageCircle, size: 16),
            label: const Text('Send Message'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10),
            ),
          ),
        ),
      ],
    );
  }

  // This badge is no longer needed as the model doesn't support 'isPremium'
  Widget _buildVerifiedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: successGreen.withValues(alpha: 0.1),
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
                fontSize: 12, fontWeight: FontWeight.w600, color: successGreen),
          ),
        ],
      ),
    );
  }

  Color _getMatchColor(int percentage) {
    if (percentage >= 90) return successGreen;
    if (percentage >= 80) return premiumGold;
    return textMedium;
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
