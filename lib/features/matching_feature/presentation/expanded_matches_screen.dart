// Import your controllers and other necessary files
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/home/all_communities_screen.dart';
import 'package:business_bosses_v2/features/marketplace/models/suppliers_model.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/buyer_requests_screen.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/suppliers_grid_tile.dart';
import 'package:business_bosses_v2/features/matching_feature/controllers/match_controller.dart';
import 'package:business_bosses_v2/features/matching_feature/widgets/banner.dart';
import 'package:business_bosses_v2/features/matching_feature/widgets/match_card.dart';
import 'package:business_bosses_v2/features/matching_feature/widgets/match_header.dart';
import 'package:business_bosses_v2/features/matching_feature/widgets/pre_match_modal.dart';
import 'package:business_bosses_v2/features/matching_feature/widgets/premium_prompt.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
  final ProfileController profileController = Get.put(ProfileController());

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
  }

  void _resetTabController() {
    int newLength = matchController.matchedSuppliers.isNotEmpty ? 2 : 1;

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
    });
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

  /// Supplier tab content
  Widget buildSupplierView() {
    final RxList<SuppliersModel> suppliers = matchController.matchedSuppliers;

    if (suppliers.isEmpty) {
      return const Center(child: Text('No suppliers found.'));
    }

    return MasonryGridView.count(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
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
    final bool suppliersExist = matchController.matchedSuppliers.isNotEmpty;

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
                          color: textColor, size: 18),
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
          if (suppliersExist)
            Container(
              color: Colors.white,
              child: TabBar(
                controller: tabController,
                labelColor: Theme.of(context).colorScheme.primary,
                unselectedLabelColor: Colors.grey,
                tabs: const <Widget>[
                  Tab(text: 'Users'),
                  Tab(text: 'Suppliers'),
                ],
              ),
            ),
          SizedBox(
            height: 16,
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: <Widget>[
                if (profileController.myProfile.matchType == 'seller') ...{
                  BuyerRequestsScreen(),
                } else ...{
                  buildMatchesListSection(),
                },
                if (suppliersExist) buildSuppliersTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// TOP SECTION WITH MATCH HEADER!!
  Widget buildTopSection() {
    final bool isInvestor =
        profileController.myProfile.matchType?.toLowerCase() == 'investor';

    return Column(
      children: <Widget>[
        if (profileController.myProfile.matchType == null)
          PersonalizationBanner(
            onSetupPressed: () => debugPrint('Setup pressed'),
            onClosePressed: () => debugPrint('Close pressed'),
          ),
        MatchHeader(
          title: 'Top Matches',
          subtitle: 'opportunities for you based on your profile',
          weeklyMatches: 0,
          totalMatches: 0,
          matchQuality: 0,
        ),
        if (isInvestor)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: GestureDetector(
              onTap: () {
                /// 🔥 navigate to screen
                Get.to(() => AllCommunitiesScreen());
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green.shade50,
                      ),
                      child: Icon(
                        LucideIcons.trendingUp,
                        color: Colors.green.shade700,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Create a Crowdfund to Get Donation From Users',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade900,
                        ),
                      ),
                    ),
                    const Icon(LucideIcons.arrowRight, size: 18),
                  ],
                ),
              ),
            ),
          ),
      ],
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
}
