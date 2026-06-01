// ignore_for_file: public_member_api_docs, sort_constructors_first, unused_element
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:flutter/material.dart';

import 'package:business_bosses_v2/features/premium/premium_paywall_sheet.dart';

// Your app's theme and model
import 'package:business_bosses_v2/utils/theme/theme.dart';

// --- CORRECTED AND STANDARDIZED IMPORT PATH ---
import 'package:business_bosses_v2/features/matching_feature/widgets/blurred_match_card.dart';

class PremiumPrompt extends StatelessWidget {
  final List<UserModel> blurredMatches;
  final String userType;

  const PremiumPrompt({
    super.key,
    required this.blurredMatches,
    required this.userType,
  });

  @override
  Widget build(BuildContext context) {
    if (blurredMatches.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: <Color>[premiumGold, Color(0xFFD97706)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              const Text(
                'Unlock All Matches',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _upgradeToPremium(context),
                  icon: const Icon(Icons.arrow_upward, size: 18),
                  label: const Text('Upgrade to Premium'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: premiumGold,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 5,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        // This map function will now work correctly
        ...blurredMatches
            .map((UserModel match) => BlurredMatchCard(match: match)),
        const SizedBox(height: 8),
      ],
    );
  }

  void _upgradeToPremium(BuildContext context) {
    showPremiumPaywall();
  }
}

class _FeatureItem extends StatelessWidget {
  final String text;

  const _FeatureItem({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            '• ',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
