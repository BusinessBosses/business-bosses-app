// Import your controllers and other necessary files
import 'package:business_bosses_v2/bbpro/presentation/create_product.dart';
import 'package:business_bosses_v2/bbpro/presentation/proshopdealsscreen.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/courses/presentation/create_course.dart';
import 'package:business_bosses_v2/features/donations/presentation/donations.dart';
import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:business_bosses_v2/features/home/controller/commumities_controller.dart';
import 'package:business_bosses_v2/features/home/widgets/all_learning_posts.dart';
import 'package:business_bosses_v2/features/marketplace/models/buyer_request_model.dart';
import 'package:business_bosses_v2/features/marketplace/models/suppliers_model.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/buyer_requests_form.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/buyer_requests_screen.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/suppliers_grid_tile.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/requests_controller.dart';
import 'package:business_bosses_v2/features/matching_feature/controllers/match_controller.dart';

import 'package:business_bosses_v2/features/matching_feature/widgets/banner.dart';
import 'package:business_bosses_v2/features/matching_feature/widgets/match_card.dart';
import 'package:business_bosses_v2/features/matching_feature/widgets/match_header.dart';
import 'package:business_bosses_v2/features/matching_feature/widgets/pre_match_modal.dart';
import 'package:business_bosses_v2/features/matching_feature/widgets/premium_prompt.dart';
import 'package:business_bosses_v2/features/partners/presentation/boss_up_partner.dart';
import 'package:business_bosses_v2/features/premium/proscreen.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/constants/constants.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ExpandedMatchesScreen extends StatefulWidget {
  final bool? isMarketplace;

  const ExpandedMatchesScreen({super.key, this.isMarketplace});

  @override
  State<ExpandedMatchesScreen> createState() => _ExpandedMatchesScreenState();
}

class _ExpandedMatchesScreenState extends State<ExpandedMatchesScreen>
    with TickerProviderStateMixin {
  final MatchController matchController = Get.put(MatchController());
  final ProfileController profileController = Get.find();
  final BuyerRequestController buyerRequestController =
      Get.put(BuyerRequestController());

  late TabController tabController;
  int selectedTabIndex = 0;
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();

    final int length = matchController.matchedSuppliers.isNotEmpty ? 2 : 1;

    tabController = TabController(length: length, vsync: this);

    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        setState(() {
          selectedTabIndex = tabController.index;
        });
      }
    });

    ever(matchController.matchedSuppliersListenable, (_) {
      _resetTabController();
    });

    if (matchController.matchList.isNotEmpty) {
      matchController.fetchMatches();
    }
  }

  void _resetTabController() {
    int newLength = matchController.matchedSuppliers.isNotEmpty ? 3 : 1;

    tabController.dispose();
    tabController = TabController(length: newLength, vsync: this);

    if (selectedTabIndex >= newLength) {
      selectedTabIndex = 0;
    }

    tabController.index = selectedTabIndex;

    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        setState(() {
          selectedTabIndex = tabController.index;
        });
      }
    });

    setState(() {});
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
    return Obx(() {
      // Sort matches by industry - same industry first
      final String? myIndustry = profileController.myProfile.industry;
      final List<UserModel> sortedMatches =
          _sortMatchesByIndustry(matches, myIndustry);

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: sortedMatches.length,
        itemBuilder: (BuildContext context, int index) {
          final UserModel match = sortedMatches[index];
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
    });
  }

  /// Free subscription match view
  Widget buildFreeView(List<UserModel> matches) {
    if (matches.isEmpty) {
      return const Center(child: Text('No matches to display.'));
    }

    // Sort matches by industry - same industry first
    final String? myIndustry = profileController.myProfile.industry;
    final List<UserModel> sortedMatches =
        _sortMatchesByIndustry(matches, myIndustry);

    final List<UserModel> clearMatches = sortedMatches.take(2).toList();
    final List<UserModel> blurredMatches = sortedMatches.skip(2).toList();

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

  /// Supplier tab content
  Widget buildSupplierView() {
    final RxList<SuppliersModel> suppliers = matchController.matchedSuppliers;

    if (suppliers.isEmpty) {
      return const Center(child: Text('No suppliers found.'));
    }

    return MasonryGridView.count(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10),
      crossAxisCount: 2,
      crossAxisSpacing: 8.0,
      mainAxisSpacing: 8.0,
      controller: _controller,
      shrinkWrap: true,
      itemCount: suppliers.length,
      itemBuilder: (BuildContext context, int index) {
        final SuppliersModel supplier = suppliers[index];
        return SuppliersGridTile(
          supplier: supplier,
        );
      },
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

          /// TABBAR BELOW MATCHHEADER

          // const SizedBox(
          //   height: 16,
          // ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: <Widget>[
                Obx(
                  () => profileController.currentMatchType.value == 'seller'
                      ? BuyerRequestsScreen(
                          showAppBar: false,
                          filterByIndustry:
                              profileController.myProfile.industry,
                        )
                      : buildMatchesListSection(),
                ),
              ],
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
        return 'Customer opportunities for you';
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
                      title: 'Create buying Request',
                      icon: LucideIcons.shoppingCart,
                      color: Colors.orange,
                      onTap: () => Get.to(() => AddBuyerRequests()),
                    ),
                  ),
                ] else if (isSeller) ...<Widget>[
                  Expanded(
                    child: _buildActionCard(
                      title: 'Reach More Buyers',
                      icon: LucideIcons.users,
                      color: Colors.blue,
                      onTap: () => Get.to(() => CreateProductListing()),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildActionCard(
                      title: 'Get Listing Featured',
                      icon: LucideIcons.star,
                      color: Colors.amber,
                      onTap: () {
                        // Check if user has Pro/BizCenter
                        if (profileController.myProfile.hasShop) {
                          // User has Pro - go to featured listings screen
                          Get.to(() => const ProshopdealsScreen());
                        } else {
                          // User doesn't have Pro - go to upgrade screen
                          Get.to(() => const ProScreen());
                        }
                      },
                    ),
                  ),
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
              child: Text('Showing buyer requests from your industry',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  )),
            ),
        ],
      );
    });
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
                  fontSize: 12,
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

  Widget buildSuppliersTab() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          buildSupplierView(),
          const SizedBox(height: 200),
        ],
      ),
    );
  }

  /// Helper method to sort matches by industry
  /// Users with the same industry as the current user appear first
  List<UserModel> _sortMatchesByIndustry(
      List<UserModel> matches, String? myIndustry) {
    if (myIndustry == null || myIndustry.isEmpty) {
      return matches; // Return unsorted if user has no industry
    }

    final List<UserModel> sameIndustry = <UserModel>[];
    final List<UserModel> otherIndustry = <UserModel>[];

    for (final UserModel match in matches) {
      if (match.industry?.toLowerCase() == myIndustry.toLowerCase()) {
        sameIndustry.add(match);
      } else {
        otherIndustry.add(match);
      }
    }

    return <UserModel>[...sameIndustry, ...otherIndustry];
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
