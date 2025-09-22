import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class OpportunityPrediction extends StatelessWidget {
  final List<String> predictions;

  const OpportunityPrediction({
    super.key,
    required this.predictions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Row(
            children: <Widget>[
              Icon(
                Icons.trending_up,
                color: accentPurple,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Opportunity Insights',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Based on your profile and market trends, here are key insights:',
            style: TextStyle(
              fontSize: 14,
              color: textMedium,
            ),
          ),
          const SizedBox(height: 16),
          ...predictions.map((String prediction) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Icon(
                      Icons.lightbulb_outline,
                      color: premiumGold,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        prediction,
                        style: const TextStyle(
                          fontSize: 14,
                          color: textDark,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
