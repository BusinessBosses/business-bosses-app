import 'package:business_bosses_v2/features/matchingfeature/widgets/matchheader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Assuming you use GetX for navigation
import 'package:lucide_icons/lucide_icons.dart';

// Import your custom widgets and the model
import 'package:business_bosses_v2/features/matching_feature/models/matchmodel.dart';
import 'package:business_bosses_v2/features/matching_feature/presentation/bookmarked_matches.dart';
import 'package:business_bosses_v2/features/matching_feature/widgets/banner.dart';
import 'package:business_bosses_v2/features/matching_feature/widgets/blurred_match_card.dart';
import 'package:business_bosses_v2/features/matching_feature/widgets/match_card.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart'; // Your app's theme

class ExpandedMatchesScreen extends StatefulWidget {
  const ExpandedMatchesScreen({super.key});

  @override
  State<ExpandedMatchesScreen> createState() => _ExpandedMatchesScreenState();
}

class _ExpandedMatchesScreenState extends State<ExpandedMatchesScreen> {
  @override
  Widget build(BuildContext context) {
    // --- Sample Data using the correct 'Match' model ---
    // In a real app, this data would come from your state management solution.
    final Match sampleMatch = Match(
      id: '2',
      name: 'Beta Solutions',
      type: 'Buyer',
      description:
          'Innovative buyer seeking tech solutions in the AI and cloud space.',
      rating: 4.2,
      location: 'San Francisco, CA',
      responseTime: 'Within an hour',
      budget: r'$20,000 - $100,000',
      quality: 88,
      verified: true,
      photoUrl: 'https://businessbosses.com.ng/appfiles/sample_photo_1.jpg',
      services: <String>['Procurement', 'IT Consulting', 'AI Integration'],
    );

    final Match blurredSampleMatch = Match(
      id: '1',
      name: 'Acme Corp',
      type: 'Seller',
      description:
          'Leading provider of business solutions for enterprise clients.',
      rating: 4.5,
      location: 'New York, NY',
      responseTime: 'In a few minutes',
      budget: r'$10,000 - $50,000',
      quality: 92,
      verified: true,
      photoUrl: 'https://businessbosses.com.ng/appfiles/sample_photo_2.jpg',
      services: <String>['Cloud Services', 'Support', 'Consulting'],
    );
    // --- End of Sample Data ---

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CircleAvatar(
            backgroundColor: backgroundColor,
            child: Icon(LucideIcons.arrowLeft, color: textColor, size: 20),
          ),
        ),
        centerTitle: true,
        title: const Text('Matches', textAlign: TextAlign.center),
        actions: <Widget>[
          IconButton(
            onPressed: () => Get.to(() => const BookmarkedMatches()),
            icon: CircleAvatar(
              backgroundColor: backgroundColor,
              child: Icon(LucideIcons.bookmark, color: textColor, size: 20),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            PersonalizationBanner(
              onSetupPressed: () => print('Setup pressed'),
              onClosePressed: () => print('Close pressed'),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Column(
                children: <Widget>[
                  const MatchHeader(
                    title: 'Your Top Matches',
                    subtitle: 'Based on your profile and industry',
                    weeklyMatches: 5,
                    totalMatches: 25,
                  ),
                  const SizedBox(height: 20),
                  MatchCard(
                    match: sampleMatch,
                    userType: 'buyer',
                  ),
                  const SizedBox(height: 20),
                  BlurredMatchCard(
                    match: blurredSampleMatch,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
