// Import your controllers and other necessary files
import 'package:business_bosses_v2/features/matching_feature/controllers/match_controller.dart';
import 'package:business_bosses_v2/features/matching_feature/models/match_model.dart';
import 'package:business_bosses_v2/features/matching_feature/widgets/banner.dart';
import 'package:business_bosses_v2/features/matching_feature/widgets/match_card.dart';
import 'package:business_bosses_v2/features/matching_feature/widgets/match_header.dart';
import 'package:business_bosses_v2/features/matching_feature/widgets/pre_match_modal.dart';
import 'package:business_bosses_v2/features/matching_feature/widgets/premium_prompt.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ExpandedMatchesScreen extends StatefulWidget {
  final bool? isMarketplace;

  const ExpandedMatchesScreen({super.key, this.isMarketplace});

  @override
  State<ExpandedMatchesScreen> createState() => _ExpandedMatchesScreenState();
}

class _ExpandedMatchesScreenState extends State<ExpandedMatchesScreen> {
  // Initialize or find your controllers
  final MatchController matchController = Get.put(MatchController());
  final ProfileController profileController =
      Get.put(ProfileController()); // Make sure this is initialized

  /// Builds the view for a subscribed user, showing all matches clearly.
  Widget buildSubscribedView(List<MatchModel> matches) {
    if (matches.isEmpty) {
      return const Center(child: Text('No matches to display.'));
    }
    return Obx(() {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: matches.length,
        itemBuilder: (BuildContext context, int index) {
          final MatchModel match = matches[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: MatchCard(
              match: match,
              userType: match.matchType ?? 'Not Specified',
              onBookmarkToggle: () {
                matchController.toggleBookmark(match);
                setState(() {});
              },
              isBookmarked: matchController.isBookmarked(match.id),
            ),
          );
        },
      );
    });
  }

  /// Builds the view for a non-subscribed user.
  /// Shows the first three matches clearly and blurs the rest.
  Widget buildFreeView(List<MatchModel> matches) {
    if (matches.isEmpty) {
      return const Center(child: Text('No matches to display.'));
    }

    // Get the first three matches
    final List<MatchModel> clearMatches = matches.take(2).toList();

    // Get the rest of the matches to be blurred
    final List<MatchModel> blurredMatches = matches.skip(2).toList();

    final MatchController matchController = Get.find<MatchController>();
    return Column(
      children: <Widget>[
        // 1. Show the first three matches clearly
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: clearMatches.length,
          itemBuilder: (BuildContext context, int index) {
            final MatchModel match = clearMatches[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: MatchCard(
                match: match,
                userType: match.matchType ?? 'Not Specified',
                onBookmarkToggle: () {
                  matchController.toggleBookmark(match);
                },
                isBookmarked: !matchController.isBookmarked(match.id),
              ),
            );
          },
        ),
        // 2. Show the rest as blurred cards within the PremiumPrompt
        if (blurredMatches.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: PremiumPrompt(
              blurredMatches: blurredMatches,
              userType: blurredMatches.first.matchType ?? 'Not Specified',
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isMarketplace == true
          ? null
          : AppBar(
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: CircleAvatar(
                  backgroundColor: backgroundColor,
                  child:
                      Icon(LucideIcons.arrowLeft, color: textColor, size: 20),
                ),
              ),
              centerTitle: true,
              title: const Text('Matches', textAlign: TextAlign.center),
              actions: <Widget>[
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (BuildContext context) => PreMatchModal());
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: CircleAvatar(
                      backgroundColor: backgroundColor,
                      child: Icon(LucideIcons.refreshCcw,
                          color: textColor, size: 20),
                    ),
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
                  child: const Text(
                    'Retry',
                    style: TextStyle(color: Colors.white),
                  ),
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

        // Calculate the average match quality of all matches
        final double totalQuality = matchController.matchList
            .fold(0.0, (double sum, MatchModel match) => sum + match.quality);
        final int averageQuality =
            (totalQuality / matchController.matchList.length).round();

        return SingleChildScrollView(
          child: Column(
            children: <Widget>[
              if (profileController.myProfile.matchType == null)
                PersonalizationBanner(
                  onSetupPressed: () => print('Setup pressed'),
                  onClosePressed: () => print('Close pressed'),
                ),
              Column(
                children: <Widget>[
                  if (widget.isMarketplace != true)
                    MatchHeader(
                      title:
                          'Your Top ${matchController.matchList.length} Matches',
                      subtitle: 'for this week based on your profile',
                      weeklyMatches: matchController.matchList.length,
                      totalMatches: matchController.matchList.length,
                      matchQuality: averageQuality,
                    ),
                  const SizedBox(height: 20),

                  // --- RENDER UI BASED ON SUBSCRIPTION ---
                  if (isSubscribed)
                    // SUBSCRIBED USER VIEW: Show all matches
                    buildSubscribedView(matchController.matchList)
                  else
                    // NON-SUBSCRIBED USER VIEW: Show first three clear, rest blurred
                    buildFreeView(matchController.matchList),
                ],
              ),
              SizedBox(
                height: 200,
              )
            ],
          ),
        );
      }),
    );
  }
}
