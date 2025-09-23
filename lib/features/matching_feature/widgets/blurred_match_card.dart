import 'package:business_bosses_v2/features/matching_feature/models/matchmodel.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:lucide_icons/lucide_icons.dart';

class BlurredMatchCard extends StatelessWidget {
  final Match match;

  const BlurredMatchCard({
    super.key,
    required this.match,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          // if (match.isPremium) _buildPremiumBadge(),
                          // if (match.isPremium && match.isVerified)
                          //   const SizedBox(width: 8),
                          // if (match.isVerified) _buildVerifiedBadge(),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          // color: _getMatchColor(match.matchPercentage),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          match.rating.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    match.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    match.type,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'High-quality opportunity matching your criteria...',
                    style: TextStyle(
                      fontSize: 14,
                      color: textMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          LucideIcons.crown,
                          size: 25,
                          color: premiumGold,
                        ),
                        Text(
                          'Premium Match',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textDark,
                          ),
                        ),
                        Text(
                          'Upgrade to view details',
                          style: TextStyle(
                            fontSize: 14,
                            color: textMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
