import 'package:business_bosses_v2/features/matchingfeature/models/matchmodel.dart';
import 'package:business_bosses_v2/features/matchingfeature/widgets/blurredmatchcard.dart';
import 'package:business_bosses_v2/features/matchingfeature/widgets/matchcard.dart';
import 'package:business_bosses_v2/features/matchingfeature/widgets/matchheader.dart';
import 'package:business_bosses_v2/features/matchingfeature/widgets/opportunityprediction.dart';
import 'package:business_bosses_v2/features/matchingfeature/widgets/premiumprompt.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ExpandedMatchesScreen extends StatefulWidget {
  const ExpandedMatchesScreen({super.key});

  @override
  State<ExpandedMatchesScreen> createState() => _ExpandedMatchesScreenState();
}

class _ExpandedMatchesScreenState extends State<ExpandedMatchesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: CircleAvatar(
              backgroundColor: backgroundColor,
              child: Icon(
                LucideIcons.arrowLeft,
                color: textColor,
                size: 20,
              )),
        ),
        centerTitle: true,
        title: const Text(
          'Matches',
          textAlign: TextAlign.center,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const MatchHeader(
              title: 'title',
              subtitle: 'subtitle',
              weeklyMatches: 0,
              totalMatches: 0,
            ),
            const SizedBox(height: 20),
            OpportunityPrediction(predictions: <String>[
              'Sample prediction 1',
              'Sample prediction 2',
              'Sample prediction 3',
            ]),
            const SizedBox(height: 20),
            MatchCard(
              match: Matches(
                id: '2',
                name: 'Beta Solutions',
                type: 'Buyer',
                description: 'Innovative buyer seeking tech solutions.',
                rating: 4.2,
                location: 'San Francisco, CA',
                services: <String>['Procurement', 'IT Consulting'],
                responseTime: '2 hours',
                budget: '\$20,000 - \$100,000',
                isPremium: false,
                isVerified: true,
                matchPercentage: 88,
              ),
              userType: 'buyer',
            ),
            const SizedBox(height: 20),
            BlurredMatchCard(
              match: Matches(
                id: '1',
                name: 'Acme Corp',
                type: 'Seller',
                description: 'Leading provider of business solutions.',
                rating: 4.5,
                location: 'New York, NY',
                services: <String>['Consulting', 'Cloud Services', 'Support'],
                responseTime: '1 hour',
                budget: '\$10,000 - \$50,000',
                isPremium: true,
                isVerified: true,
                matchPercentage: 92,
              ),
            ), // Provide a valid Matches instance here
          ],
        ),
      ),
    );
  }
}

Widget buildMatchesTab(BuildContext context, String userType) {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        MatchHeader(
          title: getTabTitle(userType),
          subtitle: getTabSubtitle(userType),
          weeklyMatches: 22,
          totalMatches: 30,
        ),
        const SizedBox(height: 20),
        OpportunityPrediction(
          predictions: getPredictions(userType),
        ),
        const SizedBox(height: 20),
        Text(
          'Your Top Matches This Week',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
        ),
        const SizedBox(height: 16),
        // Uncomment and provide matches from your provider
        // ...matchProvider.matches.map(
        //   (match) => MatchCard(
        //     match: match,
        //     userType: userType,
        //   ),
        // ),
        const SizedBox(height: 20),
        PremiumPrompt(
          blurredMatches: <Matches>[], // matchProvider.blurredMatches,
          userType: userType,
        ),
      ],
    ),
  );
}

String getTabTitle(String userType) {
  switch (userType) {
    case 'buyer':
      return 'Seller Matches';
    case 'seller':
      return 'Buyer Matches';
    case 'entrepreneur':
      return 'Supplier & Partner Matches';
    case 'investor':
      return 'Startup Matches';
    default:
      return 'Matches';
  }
}

String getTabSubtitle(String userType) {
  switch (userType) {
    case 'buyer':
      return 'Connecting you with top sellers in your industry';
    case 'seller':
      return 'Connecting you with qualified buyers seeking your services';
    case 'entrepreneur':
      return 'Find verified suppliers and strategic partners for growth';
    case 'investor':
      return 'Discover high-potential startups seeking strategic investment';
    default:
      return 'Find your perfect match';
  }
}

List<String> getPredictions(String userType) {
  switch (userType) {
    case 'buyer':
      return <String>[
        'SaaS companies in your region show 73% higher engagement',
        'Enterprise clients are actively seeking cloud solutions',
        'Q2 budget cycles favor technology investments',
      ];
    case 'seller':
      return <String>[
        'Enterprise clients show 68% higher conversion rates',
        'Q2 procurement cycles are starting early this year',
        'Healthcare sector is prioritizing digital transformation',
      ];
    case 'entrepreneur':
      return <String>[
        'Verified suppliers reduce procurement risk by 45%',
        'Strategic partnerships accelerate growth by 2.3x',
        'Q2 is optimal for supplier negotiations',
      ];
    case 'investor':
      return <String>[
        'AI startups show 156% higher growth potential',
        'Series A rounds are 23% larger this quarter',
        'Healthcare and cleantech sectors lead investment activity',
      ];
    default:
      return <String>['Market opportunities are increasing'];
  }
}
