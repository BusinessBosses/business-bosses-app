import 'package:business_bosses_v2/features/matching_feature/widgets/match_header.dart';
import 'package:business_bosses_v2/features/matching_feature/widgets/premium_prompt.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

// Import your controllers and other necessary files
import 'package:business_bosses_v2/features/matching_feature/controllers/match_controller.dart'; // Import profile controller
import 'package:business_bosses_v2/features/matching_feature/models/matchmodel.dart';
import 'package:business_bosses_v2/features/matching_feature/presentation/bookmarked_matches.dart';
import 'package:business_bosses_v2/features/matching_feature/widgets/banner.dart';
import 'package:business_bosses_v2/features/matching_feature/widgets/match_card.dart'; // Import PremiumPrompt
import 'package:business_bosses_v2/utils/theme/theme.dart';

class ExpandedMatchesScreen extends StatelessWidget {
  const ExpandedMatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize or find your controllers
    final MatchController matchController = Get.put(MatchController());
    final ProfileController profileController =
        Get.put(ProfileController()); // Make sure this is initialized

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
      body: Obx(() {
        // Loading and Error states remain the same
        if (matchController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (matchController.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(matchController.errorMessage.value),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => matchController.fetchMatches(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        if (matchController.matchList.isEmpty) {
          return const Center(child: Text('No matches found.'));
        }

        // --- NEW: Logic to check subscription status ---
        final bool isSubscribed = profileController.myProfile.isSubscribed;

        return SingleChildScrollView(
          child: Column(
            children: <Widget>[
              PersonalizationBanner(
                onSetupPressed: () => print('Setup pressed'),
                onClosePressed: () => print('Close pressed'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  children: <Widget>[
                    MatchHeader(
                      title: 'Your Top Matches',
                      subtitle: 'Based on your profile and industry',
                      weeklyMatches: matchController.matchList.length,
                      totalMatches: matchController.matchList.length,
                    ),
                    const SizedBox(height: 20),

                    // --- RENDER UI BASED ON SUBSCRIPTION ---
                    if (isSubscribed)
                      // SUBSCRIBED USER VIEW: Show all matches
                      _buildSubscribedView(matchController.matchList)
                    else
                      // NON-SUBSCRIBED USER VIEW: Show one clear, rest blurred
                      _buildFreeView(matchController.matchList),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  /// Builds the view for a subscribed user, showing all matches clearly.
  Widget _buildSubscribedView(List<Match> matches) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: matches.length,
      itemBuilder: (BuildContext context, int index) {
        final Match match = matches[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: MatchCard(
            match: match,
            userType: 'buyer',
          ),
        );
      },
    );
  }

  /// Builds the view for a non-subscribed user.
  Widget _buildFreeView(List<Match> matches) {
    // Separate the first match from the rest
    final Match firstMatch = matches.first;
    final List<Match> blurredMatches = matches.skip(1).toList();

    return Column(
      children: <Widget>[
        // 1. Show the first match clearly
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: MatchCard(
            match: firstMatch,
            userType: 'buyer',
          ),
        ),
        // 2. Show the rest as blurred cards within the PremiumPrompt
        if (blurredMatches.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: PremiumPrompt(
              blurredMatches: blurredMatches,
              userType: 'buyer',
            ),
          ),
      ],
    );
  }
}
