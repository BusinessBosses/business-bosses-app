import 'package:flutter/material.dart';

// Your app's theme and model
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:business_bosses_v2/features/matching_feature/models/match_model.dart';

// --- CORRECTED AND STANDARDIZED IMPORT PATH ---
import 'package:business_bosses_v2/features/matching_feature/widgets/blurred_match_card.dart';

class PremiumPrompt extends StatelessWidget {
  final List<MatchModel> blurredMatches;
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
        const Row(
          children: <Widget>[
            Icon(Icons.visibility_outlined, color: textMedium),
            SizedBox(width: 8),
            Text(
              'More Matches Available',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: textMedium,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // This map function will now work correctly
        ...blurredMatches.map((MatchModel match) => Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: BlurredMatchCard(match: match),
            )),
        const SizedBox(height: 8),
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
          padding: const EdgeInsets.all(24),
          child: Column(
            children: <Widget>[
              const Icon(Icons.star, size: 32, color: Colors.white),
              const SizedBox(height: 12),
              const Text(
                'Unlock All Matches',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Get unlimited access to all matches, premium user priority, and advanced filtering',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _FeatureItem(text: 'Unlimited weekly matches'),
                  _FeatureItem(text: 'Priority in search results'),
                  _FeatureItem(text: 'Advanced match analytics'),
                  _FeatureItem(text: 'Direct contact information'),
                ],
              ),
              const SizedBox(height: 24),
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
      ],
    );
  }

  void _upgradeToPremium(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Upgrade to Premium'),
        content: const Text(
          'Get unlimited matches, priority placement, and advanced analytics.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Upgrade',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final String text;

  const _FeatureItem({required this.text});

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
