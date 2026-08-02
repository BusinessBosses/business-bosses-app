// Import your controllers and other necessary files
import 'package:business_bosses_v2/bbpro/presentation/proshopdealsscreen.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/courses/presentation/create_course.dart';
import 'package:business_bosses_v2/features/donations/presentation/donations.dart';
import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:business_bosses_v2/features/home/controller/commumities_controller.dart';
import 'package:business_bosses_v2/features/home/widgets/all_learning_posts.dart';
import 'package:business_bosses_v2/features/marketplace/models/buyer_request_model.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/buyer_requests_form.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/buyer_requests_screen.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/requests_controller.dart';
import 'package:business_bosses_v2/features/matching_feature/controllers/match_controller.dart';

import 'package:business_bosses_v2/features/matching_feature/widgets/banner.dart';
import 'package:business_bosses_v2/features/matching_feature/widgets/match_card.dart';
import 'package:business_bosses_v2/features/matching_feature/widgets/match_header.dart';
import 'package:business_bosses_v2/features/matching_feature/widgets/pre_match_modal.dart';
import 'package:business_bosses_v2/features/matching_feature/widgets/premium_prompt.dart';
import 'package:business_bosses_v2/features/partners/presentation/boss_up_partner.dart';
import 'package:business_bosses_v2/features/premium/premium_paywall_sheet.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/constants/constants.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ExpandedMatchesScreen extends StatefulWidget {
  final bool? isMarketplace;

  const ExpandedMatchesScreen({super.key, this.isMarketplace});

  @override
  State<ExpandedMatchesScreen> createState() => _ExpandedMatchesScreenState();
}

class _ExpandedMatchesScreenState extends State<ExpandedMatchesScreen> {
  final MatchController matchController = Get.put(MatchController());
  final ProfileController profileController = Get.find();
  final BuyerRequestController buyerRequestController =
      Get.put(BuyerRequestController());

  @override
  void initState() {
    super.initState();

    // Always refresh so the displayed matches reflect the CURRENT match type.
    // Relying on `matchList.isEmpty` left stale results from a previously
    // selected type (the controller is a singleton that persists across screens).
    matchController.fetchMatches();
  }

  /// Builds the view for a subscribed user
  Widget buildSubscribedView(List<UserModel> matches) {
    if (matches.isEmpty) {
      return const Padding(
          padding: EdgeInsets.only(top: 200),
          child: SafetyModel(
            icon: Icon(Icons.warning),
            title: 'No matches to display.',
            isLoading: false,
          ));
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: matches.length,
      itemBuilder: (BuildContext context, int index) {
        final UserModel match = matches[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: MatchCard(
            match: match,
            userType: match.matchType ?? 'Not Specified',
            onBookmarkToggle: () {
              setState(() {});
            },
            isBookmarked: matchController.isBookmarked(match.uid),
          ),
        );
      },
    );
  }

  /// Free subscription match view
  Widget buildFreeView(List<UserModel> matches) {
    if (matches.isEmpty) {
      return const Center(child: Text('No matches to display.'));
    }

    final List<UserModel> clearMatches = matches.take(2).toList();
    final List<UserModel> blurredMatches = matches.skip(2).toList();

    return Column(
      children: <Widget>[
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: clearMatches.length,
          itemBuilder: (BuildContext context, int index) {
            final UserModel match = clearMatches[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: MatchCard(
                match: match,
                userType: match.matchType ?? 'Not Specified',
                onBookmarkToggle: () {},
                isBookmarked: !matchController.isBookmarked(match.uid),
              ),
            );
          },
        ),
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
              title: const Text('Find Your Match', textAlign: TextAlign.center),
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
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      decoration: BoxDecoration(
                        color: primaryBlue.withAlpha(30),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: <Widget>[
                          SvgPicture.asset(
                            'assets/svgs/preferences.svg',
                            colorFilter: const ColorFilter.mode(
                                primaryBlue, BlendMode.srcIn),
                            height: 20,
                          ),
                          const SizedBox(width: 5),
                          Text('Filter',
                              style: TextStyle(
                                  color: primaryBlue,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
      body: Column(
        children: <Widget>[
          /// MATCHHEADER ALWAYS ON TOP
          buildTopSection(),
          Expanded(
            child: Obx(
              () {
                final String matchType =
                    profileController.currentMatchType.value.toLowerCase();
                if (matchType == 'seller') {
                  return BuyerRequestsScreen(
                    showAppBar: false,
                    filterByIndustry: profileController.myProfile.industry,
                    filterByLocation: profileController.myProfile.location,
                    gateForFreeUsers: true,
                  );
                } else if (matchType == 'partner') {
                  return buildCategorizedMatches();
                } else {
                  return buildMatchesListSection();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getMatchHeaderTitle(String matchType) {
    switch (matchType.toLowerCase()) {
      case 'investor':
        return 'Funding opportunities for you';
      case 'partner':
        return 'Partner Opportunities for you';
      case 'seller':
        return 'Job Opportunities for you';
      case 'mentor':
        return 'Mentorship opportunities for you';
      default:
        return '${matchType.capitalize} matches for you';
    }
  }

  /// TOP SECTION WITH MATCH HEADER!!
  Widget buildTopSection() {
    return Obx(() {
      final String matchType =
          profileController.currentMatchType.value.toLowerCase();
      final bool isInvestor = matchType == 'investor';
      final bool isSeller = matchType == 'seller';
      final bool isPartner = matchType == 'partner';
      // Default to Mentor if none of the above
      final bool isMentor = !isSeller && !isInvestor && !isPartner;

      return Column(
        children: <Widget>[
          if (profileController.myProfile.matchType == null)
            PersonalizationBanner(
              onSetupPressed: () => debugPrint('Setup pressed'),
              onClosePressed: () => debugPrint('Close pressed'),
            ),
          MatchHeader(
            title:
                _getMatchHeaderTitle(profileController.currentMatchType.value),
            subtitle: 'based on your profile and filter selection',
            weeklyMatches: 0,
            totalMatches: 0,
            matchQuality: 0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: <Widget>[
                if (isPartner) ...<Widget>[
                  Expanded(
                    child: _buildActionCard(
                      title: 'Claim Partners Deals',
                      icon: LucideIcons.heartHandshake,
                      color: Colors.green,
                      onTap: () => Get.to(() => BossUpPartner()),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildActionCard(
                      title: 'Get Listing Featured',
                      icon: LucideIcons.star,
                      color: Colors.amber,
                      onTap: () => _openFeaturedListing(),
                    ),
                  ),
                ] else if (isSeller) ...<Widget>[
                  // Jobs: post a job rather than the old seller actions.
                  Expanded(child: _buildPostAJobBanner()),
                ] else if (isInvestor) ...<Widget>[
                  Expanded(
                    child: _buildActionCard(
                      title: 'Create Crowdfund',
                      icon: LucideIcons.coins,
                      color: Colors.green,
                      onTap: () => Get.toNamed(Routes.createdonationsscreen),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildActionCard(
                      title: 'Support a Project',
                      icon: LucideIcons.heart,
                      color: Colors.red,
                      onTap: () => Get.to(() => const DonationsPage(
                            ishome: false,
                          )),
                    ),
                  ),
                ] else ...<Widget>[
                  // Mentor
                  Expanded(
                    child: _buildActionCard(
                      title: 'Learn new skill',
                      icon: LucideIcons.bookOpen,
                      color: Colors.blue,
                      onTap: () => Get.to(() =>
                          const AllLearningPostsScreen(isCoursesTile: false)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildActionCard(
                      title: 'Share expertise',
                      icon: LucideIcons.graduationCap,
                      color: Colors.purple,
                      onTap: _showIndustrySelectionBottomSheet,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (isInvestor)
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Text('Showing backers funding entrepreneurs',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  )),
            ),
          if (isPartner)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text('Showing users looking for partnership',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  )),
            ),
          if (isMentor)
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text('Showing coaches available for mentorship',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  )),
            ),
          if (isSeller &&
              buyerRequestController.buyerRequests.any((BuyerRequestModel r) =>
                  r.category.toLowerCase() ==
                  profileController.myProfile.industry?.toLowerCase()))
            Padding(
              padding: const EdgeInsets.only(bottom: 0.0),
              child: Text('Showing matched Job Opportunities',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  )),
            ),
        ],
      );
    });
  }

  Widget buildCategorizedMatches() {
    return Obx(() {
      if (matchController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildSectionHeader('Suppliers in your industry'),
            if (matchController.suppliers.isEmpty)
              _buildEmptyState('No suppliers found in your area.')
            else
              _buildHorizontalList(matchController.suppliers),
            const SizedBox(height: 25),
            _buildSectionHeader('Looking For Partners'),
            if (matchController.partners.isEmpty)
              _buildEmptyState('No partners found in your area.')
            else
              _buildHorizontalList(matchController.partners),
            const SizedBox(height: 150),
          ],
        ),
      );
    });
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Text(
        message,
        style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
      ),
    );
  }

  Widget _buildHorizontalList(List<UserModel> users) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: users.length,
        itemBuilder: (BuildContext context, int index) {
          final UserModel user = users[index];
          return Container(
            width: 300,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: MatchCard(
              isExpanded: false,
              match: user,
              userType: user.matchType ?? 'Not Specified',
              onBookmarkToggle: () => setState(() {}),
              isBookmarked: matchController.isBookmarked(user.uid),
            ),
          );
        },
      ),
    );
  }

  /// Featured listing is a Pro/shop feature — non-shop users see the paywall.
  void _openFeaturedListing() {
    if (profileController.myProfile.hasShop) {
      Get.to(() => const ProshopdealsScreen());
    } else {
      showPremiumPaywall();
    }
  }

  /// Banner above the job matches: post a job of your own.
  Widget _buildPostAJobBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: <Widget>[
          const Expanded(
            child: Text(
              'List work or job position and connect with active job seekers.',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColorLT,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Get.to(() => const AddBuyerRequests()),
            child: const Text(
              'Post a Job',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.white,
        ),
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: 0.15),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade900,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// CONTENT SEPARATE FROM HEADER
  Widget buildMatchesListSection() {
    final bool isSubscribed = profileController.myProfile.isSubscribed;

    return Obx(() {
      if (matchController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (matchController.errorMessage.value.isNotEmpty) {
        return Center(child: Text(matchController.errorMessage.value));
      }
      return SingleChildScrollView(
        child: Column(
          children: <Widget>[
            if (isSubscribed)
              buildSubscribedView(matchController.matchList)
            else
              buildFreeView(matchController.matchList),
            const SizedBox(
              height: 200,
            )
          ],
        ),
      );
    });
  }

  /// Show bottom sheet with industry selection
  void _showIndustrySelectionBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => _buildIndustrySelectionBottomSheet(),
    );
  }

  /// Build the industry selection bottom sheet
  Widget _buildIndustrySelectionBottomSheet() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: <Widget>[
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Expanded(
                  child: Text(
                    'Where do you want to share your expertise?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Industry list
          Expanded(
            child: GetBuilder<CommunitiesController>(
              builder: (CommunitiesController controller) {
                if (controller.loading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.error.value) {
                  return const Center(
                    child: Text('Error loading industries'),
                  );
                }

                // Get only learning industries and filter out specific ones
                final List<Industry> learningIndustries = controller
                    .getCategoryIndustries(Constants.LEARNINGID)
                    .where((Industry industry) =>
                        // Hide "Courses & Tutorial" and "Groups & Community"
                        industry.industryId !=
                            '4acc0db7-7c89-4122-b15d-7552f590af23' &&
                        industry.industryId !=
                            '6bfb3524-f05e-4148-b4b2-a7a47b768b56')
                    .toList();

                if (learningIndustries.isEmpty) {
                  return const Center(
                    child: Text('No learning topics available'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: learningIndustries.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Industry industry = learningIndustries[index];
                    return _buildIndustryTile(industry);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Build individual industry tile
  Widget _buildIndustryTile(Industry industry) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context); // Close bottom sheet
        Get.to(
          () => CreateCourseScreen(
            industryId: industry.industryId ?? '',
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            // Industry image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: industry.photo != null && industry.photo!.isNotEmpty
                  ? Image.network(
                      industry.photo!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context, Object error,
                          StackTrace? stackTrace) {
                        return _buildPlaceholderImage();
                      },
                    )
                  : _buildPlaceholderImage(),
            ),
            const SizedBox(width: 12),
            // Industry name and description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    industry.industry ?? 'Unknown Industry',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (industry.description != null &&
                      industry.description!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        industry.description!,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
            // Arrow icon
            Icon(
              LucideIcons.chevronRight,
              color: Colors.grey.shade400,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  /// Build placeholder image for industries without photos
  Widget _buildPlaceholderImage() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: primaryBlue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(
        LucideIcons.briefcase,
        color: primaryBlue,
        size: 30,
      ),
    );
  }
}
