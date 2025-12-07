// Import your controllers and other necessary files
import 'package:business_bosses_v2/bbpro/presentation/proshopdealsscreen.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/donations/presentation/donations.dart';

import 'package:business_bosses_v2/features/marketplace/models/suppliers_model.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/buyer_requests_screen.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/suppliers_grid_tile.dart';
import 'package:business_bosses_v2/features/matching_feature/controllers/match_controller.dart';
import 'package:business_bosses_v2/features/matching_feature/widgets/banner.dart';
import 'package:business_bosses_v2/features/matching_feature/widgets/match_card.dart';
import 'package:business_bosses_v2/features/matching_feature/widgets/match_header.dart';
import 'package:business_bosses_v2/features/matching_feature/widgets/pre_match_modal.dart';
import 'package:business_bosses_v2/features/matching_feature/widgets/premium_prompt.dart';
import 'package:business_bosses_v2/features/partners/presentation/boss_up_partner.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
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
              title: const Text('Find My Match', textAlign: TextAlign.center),
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
                            color: primaryBlue,
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
          Obx(() {
            if (matchController.matchedSuppliers.isNotEmpty) {
              return Container(
                color: Colors.white,
                child: TabBar(
                  controller: tabController,
                  labelColor: Theme.of(context).colorScheme.primary,
                  unselectedLabelColor: Colors.grey,
                  tabs: const <Widget>[
                    Tab(text: 'Partners'),
                    Tab(text: 'Suppliers'),
                  ],
                ),
              );
            } else {
              return SizedBox();
            }
          }),

          const SizedBox(
            height: 16,
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: <Widget>[
                Obx(
                  () => profileController.currentMatchType.value == 'seller'
                      ? BuyerRequestsScreen()
                      : buildMatchesListSection(),
                ),
                if (matchController.matchedSuppliers.isNotEmpty) ...<Widget>[
                  buildSuppliersTab(),
                ]
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
        return 'Partner / Supplier Opportunities for you';
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
      final bool isInvestor =
          profileController.currentMatchType.value.toLowerCase() == 'investor';
      final bool isSeller =
          profileController.currentMatchType.value.toLowerCase() == 'seller';
      final bool isPartner =
          profileController.currentMatchType.value.toLowerCase() == 'partner';

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
          if (isInvestor || isPartner)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: GestureDetector(
                onTap: () {
                  if (isInvestor) {
                    Get.to(() => const DonationsPage(
                          ishome: false,
                        ));
                  } else {
                    Get.to(() => BossUpPartner());
                  }
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
                          LucideIcons.plus,
                          color: Colors.green.shade700,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          isInvestor
                              ? 'Create a Crowdfund to get funding for your projects'
                              : 'Checkout partner deals',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade900,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      const Icon(LucideIcons.arrowRight, size: 18),
                    ],
                  ),
                ),
              ),
            ),
          if (isSeller)
            Column(
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: GestureDetector(
                    onTap: () {
                      Get.to(() => ProshopdealsScreen());
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
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
                            child: SvgPicture.asset(
                              'assets/svgs/marketplace.svg',
                              color: Colors.green.shade700,
                              width: 20,
                              height: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'List your products/services in featured listing, get more customers',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade900,
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          const Icon(LucideIcons.arrowRight, size: 18),
                        ],
                      ),
                    ),
                  ),
                ),
                Text('Showing buyers looking for sellers',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    )),
              ],
            ),
        ],
      );
    });
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
