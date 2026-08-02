import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/presentation/expanded_order_load.dart';
import 'package:business_bosses_v2/bbpro/presentation/orders_and_invoices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_product.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_service.dart';
import 'package:business_bosses_v2/bbpro/widgets/proshopdeals.dart';
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/home/controller/commumities_controller.dart';
import 'package:business_bosses_v2/features/home/controller/home_controller.dart';

import 'package:business_bosses_v2/features/home/widgets/bottom_bar.dart';
import 'package:business_bosses_v2/features/home/widgets/for_you_top_cards.dart';
import 'package:business_bosses_v2/features/home/widgets/list_items.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/requests_controller.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/supplier_controller.dart';

import 'package:business_bosses_v2/features/marketplace/presentation/buyer_requests_form.dart';
import 'package:business_bosses_v2/features/matching_feature/widgets/pre_match_modal.dart';
import 'package:business_bosses_v2/features/partners/controllers/partners_controller.dart';
import 'package:business_bosses_v2/features/premium/premium_paywall_sheet.dart';
import 'package:business_bosses_v2/features/partners/presentation/become_a_partner_screen.dart';
import 'package:business_bosses_v2/features/partners/presentation/boss_up_partner.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/buyer_requests_screen.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/markets.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/features/profile/presentation/my_profile_screen.dart';
import 'package:business_bosses_v2/bbpro/widgets/drawercontent.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/products.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../utils/theme/theme.dart';
import '../marketplace/controllers/market_controller.dart';
import '../marketplace/presentation/marketplace_search_screen.dart';
import 'package:business_bosses_v2/features/matching_feature/controllers/match_controller.dart';
import 'package:business_bosses_v2/features/impact/controllers/impact_controller.dart';
import 'dart:async';

/// Home screen: "For you" feed, Marketplace, Jobs and Deals in one place.
///
/// Tab indexes: 0 = For you (boss up feed), 1 = Marketplace (products &
/// services), 2 = Jobs (buyer requests), 3 = Deals (partner deals).
class MarketplaceScreen extends StatefulWidget {
  final int initialIndex;
  const MarketplaceScreen({super.key, this.initialIndex = 0});

  /// Tab indexes, so callers don't hard-code magic numbers.
  static const int forYouTab = 0;
  static const int marketplaceTab = 1;
  static const int jobsTab = 2;
  static const int dealsTab = 3;

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen>
    with TickerProviderStateMixin {
  final AdvancedDrawerController _advancedDrawerController =
      AdvancedDrawerController();
  final MarketController _marketController = Get.find();
  final ShopController shopController = Get.find();
  final PartnerController partnerController = Get.put(PartnerController());
  final SupplierController supplierController = Get.put(SupplierController());
  final BuyerRequestController buyerRequestController = Get.put(
    BuyerRequestController(),
  );
  final ProfileController _profileController = Get.find();
  final HomeController homeController = Get.find<HomeController>();
  final CommunitiesController _communitiesController =
      Get.find<CommunitiesController>();
  final MatchController _matchController = Get.put(MatchController());

  late final TabController _marketplaceTabController;
  int _currentTabIndex = 0;

  /// Feed scroll controller for the "For you" tab.
  final ScrollController _feedScrollController = ScrollController();

  // Keep the loading screen up for a minimum window on the FIRST app entry so
  // it always shows briefly, even when content is served instantly from cache.
  // Static so it only happens once per app session — not on every time the
  // user returns to the home tab from Profile/Inbox/etc.
  static bool _initialLoadShown = false;
  bool _minLoadElapsed = false;
  Timer? _minLoadTimer;

  bool hasOldData = false;

  final List<String> categories = const <String>[
    'Agriculture, Food & Beverage',
    'Learning & Education',
    'Construction & Real Estate',
    'Fashion & Beauty',
    'Finance & Legal',
    'Healthcare & Wellness',
    'Home, Gardens & Outdoors',
    'Jewellery & Timepieces',
    'Media & Entertainment',
    'Security, Safety & Equipment',
    'Technology, Games & Electronic',
    'Vehicle & Transportation',
    'Business Services & Consulting',
  ];
  final ScrollController _categoryScrollController = ScrollController();
  bool _showRightChevron = true;

  @override
  void initState() {
    super.initState();
    _currentTabIndex = widget.initialIndex;
    _marketplaceTabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: widget.initialIndex,
    );

    // Only enforce the minimum loader once per app session (first entry).
    // On later returns to the home tab, skip it so the marketplace shows
    // immediately from cache.
    if (_initialLoadShown) {
      _minLoadElapsed = true;
    } else {
      _initialLoadShown = true;
      _minLoadTimer = Timer(const Duration(seconds: 2), () {
        if (mounted) setState(() => _minLoadElapsed = true);
      });
    }

    _categoryScrollController.addListener(() {
      if (!_categoryScrollController.hasClients) return;

      final double maxScroll =
          _categoryScrollController.position.maxScrollExtent;
      final double current = _categoryScrollController.offset;

      setState(() {
        _showRightChevron = current < maxScroll - 10;
      });
    });
    _marketplaceTabController.addListener(() {
      final int index = _marketplaceTabController.index;

      if (index != _currentTabIndex) {
        if (_marketplaceTabController.indexIsChanging) {
          if (index == MarketplaceScreen.marketplaceTab) {
            // Reset buyer requests fully
            buyerRequestController.filterCategory.value = '';
            buyerRequestController.filterLocation.value = '';
            buyerRequestController.filterBuyerRequests('');

            _marketController.selectedCategory = null;
            _marketController.isSearching(false);
            _marketController.clearFilter();
            _marketController.sortItems();
          }

          if (index == MarketplaceScreen.dealsTab) {
            partnerController.selectedCategory.value = 'All';
          }
        }

        setState(() {
          _currentTabIndex = index;
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Resume a pending order the user paid for outside the app.
      checkOrderVisit();

      _marketController.selectedCategory = null;
      _marketController.isSearching(false);
      _marketController.clearFilter();
      _marketController.sortItems();

      // Always refresh market data when entering the screen
      await _marketController.initMarket();
      _marketController.sortItems();

      // Load reach data for the current user
      Get.find<ReachController>().loadData(
        _profileController.myProfile.uid,
        _profileController.myProfile.uid,
      );

      // Fetch matches if not already fetched
      if (_matchController.matchList.isEmpty) {
        _matchController.fetchMatches();
      }

      // "Matches" on the performance card = buyer requests in my industry &
      // location (same dataset as the dashboard "Matched Buyer" tile and
      // "Find my match → I need customers").
      buyerRequestController.fetchMatchCount(
        category: _profileController.myProfile.industry,
      );

      if (shopController.shop == null && _profileController.myProfile.hasShop) {
        await shopController.initShop();
      }

      if (supplierController.suppliers.isEmpty) {
        await supplierController.initSuppliers();
      }

      final bool oldData = await _marketController.checkOldMarketplaceData();
      if (oldData) {
        setState(() => hasOldData = true);
        await _marketController.checkMigrationReminder();
      }
    });
  }

  @override
  void dispose() {
    _minLoadTimer?.cancel();
    _feedScrollController.dispose();
    _marketplaceTabController.dispose();
    _advancedDrawerController.dispose();
    super.dispose();
  }

  /// Opens the order screen when the user returns from an external payment.
  void checkOrderVisit() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? visit = prefs.getBool('visited');
    final String? orderId = prefs.getString('orderId');
    // Both flags must be present — a stale 'visited' without an order id would
    // otherwise blow up on the landing screen.
    if (visit == false && orderId != null && orderId.isNotEmpty) {
      Get.to(() => ExpandedOrdersView(order: orderId));
    }
  }

  void selectedLocationChanged(String? name, String? code) {
    _marketController.changeLocation(name ?? '', code: code);

    // If we have an active category or search query, re-fetch data
    if (_marketController.selectedCategory != null) {
      _marketController.loadCategory(_marketController.selectedCategory);
    } else if (_marketController.searchQuery.isNotEmpty) {
      _marketController.searchMarketplace(_marketController.searchQuery);
    } else {
      _marketController.initMarket();
    }

    _marketController.sortItems();
    setState(() {});
  }

  Future<void> refreshData() async {
    await _marketController.initMarket();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool shouldDisableDrawer = homeController.loading.value ||
          homeController.noConnection.value ||
          homeController.error.value;
      return AdvancedDrawer(
        backdrop: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Colors.white,
                Colors.white.withValues(alpha: 0.2)
              ],
            ),
          ),
        ),
        controller: _advancedDrawerController,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        rtlOpening: false,
        disabledGestures: shouldDisableDrawer,
        childDecoration: const BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(color: Colors.black12, blurRadius: 3)
          ],
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        drawer: DrawerContent(
          oncloseclick: () {
            _advancedDrawerController.hideDrawer();
          },
          currentuser: _profileController.myProfile,
          hasUnreadNotification:
              _profileController.myProfile.unReadCount != null &&
                  _profileController.myProfile.unReadCount! > 0,
        ),
        child: UpgradeAlert(
          upgrader: Upgrader(
            durationUntilAlertAgain: const Duration(minutes: 1),
          ),
          child: Scaffold(
            backgroundColor: backgroundColor,
            body: Obx(() {
              if (homeController.loading.value || !_minLoadElapsed) {
                return _buildLoading();
              } else if (homeController.noConnection.value) {
                return _buildNoConnection();
              } else if (homeController.error.value) {
                return _buildError();
              } else {
                return _buildMainContent();
              }
            }),
          ),
        ),
      );
    });
  }

  Widget _buildMainContent() {
    return Stack(
      children: <Widget>[
        NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              // Sticky AppBar with search bar
              SliverAppBar(
                pinned: true,
                floating: false,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                elevation: 0,
                // Only Marketplace renders the second row (location + Sales &
                // Leads). Every other tab needs the short bar, otherwise the
                // header leaves a blank strip where that row used to be.
                toolbarHeight: _currentTabIndex ==
                        MarketplaceScreen.marketplaceTab
                    ? 120
                    : 62,
                flexibleSpace: FlexibleSpaceBar(
                  background: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: _buildCombinedHeader(),
                    ),
                  ),
                ),
              ),
              // Tabs - collapses when scrolling
              SliverToBoxAdapter(child: _buildMainTabs()),

              // Featured listing only belongs to the Marketplace tab; the
              // "For you" tab carries its own cards inside the feed.
              if (_currentTabIndex == MarketplaceScreen.marketplaceTab)
                SliverToBoxAdapter(child: _buildFeaturedListingSlide()),

              if (_currentTabIndex == MarketplaceScreen.jobsTab)
                SliverToBoxAdapter(child: _buildJobsBanner()),

              if (_currentTabIndex == MarketplaceScreen.dealsTab)
                SliverToBoxAdapter(child: _buildDealsBanner()),

              if (_currentTabIndex != MarketplaceScreen.forYouTab)
                SliverToBoxAdapter(child: _buildCategoryChips()),
            ];
          },
          body: TabBarView(
            controller: _marketplaceTabController,
            children: <Widget>[
              // Tab 0: For you — the boss up feed (incl. boosted posts)
              _buildForYouFeed(),
              // Tab 1: Product & service listings
              const MarketsPage(),
              // Tab 2: Jobs / buyer requests
              const BuyerRequestsScreen(showAppBar: false),
              // Tab 3: Partner deals
              const BossUpPartner(isMarketplace: true),
            ],
          ),
        ),
        // Bottom Bar
        BottomBar(activeIndex: 0),
      ],
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 120.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/app/app_logo_2.png',
                      height: 40,
                      width: 40,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 45,
                  height: 45,
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text(
                'One Reach Score. More opportunities.',
                style: TextStyle(fontSize: 16),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildNoConnection() {
    return SafetyModel(
      isLoading: false,
      title: 'Error While Loading Data\nCheck your Internet Connection',
      subTitle: 'Try Reloading Again',
      clickableText: 'Refresh',
      onTap: () {
        homeController.loadData();
        _profileController.fetchData();
        _communitiesController.fetchIndustries();
      },
      icon: const Icon(
        Icons.warning,
        size: 60,
      ),
    );
  }

  Widget _buildError() {
    return SafetyModel(
      isLoading: false,
      title: 'Error While Loading Data',
      subTitle: 'Try Reloading Again',
      clickableText: 'Refresh',
      onTap: () {
        homeController.loadData();
        _profileController.fetchData();
        _communitiesController.fetchIndustries();
      },
      icon: const Icon(
        Icons.warning,
        size: 60,
      ),
    );
  }

  Widget _buildCombinedHeader() {
    return GetBuilder<ProfileController>(builder: (_) {
      return GetBuilder<MarketController>(builder: (_) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            children: <Widget>[
              // Row 1: Search bar, Shopping Bag, Red Plus, Menu
              Row(
                children: <Widget>[
                  // 1. Search Bar (Rounded)
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () =>
                          Get.to(() => const MarketplaceSearchScreen()),
                      child: Container(
                        height: 38,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.black, width: 1.2),
                        ),
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Search',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                              ),
                            ),
                            const Spacer(),
                            const Icon(LucideIcons.search,
                                size: 18, color: Colors.black),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // 2. Coin Icon
                  GestureDetector(
                    onTap: () => Get.toNamed(Routes.promotionscreen),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(
                        color: backgroundcolorinterface,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: <Widget>[
                          SvgPicture.asset('assets/svgs/coin.svg', height: 22),
                          const SizedBox(width: 4),
                          Text(
                            formatCount(
                                _profileController.myProfile.coinsCount),
                            style: const TextStyle(
                              color: textColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // 3. Red Square + Button (Marketplace only — Jobs and Deals
                  // have their own banner actions, For you has the FAB).
                  if (_currentTabIndex == MarketplaceScreen.marketplaceTab) ...<Widget>[
                    GestureDetector(
                      onTap: () => _handleCreateButton(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF1E39),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: const <Widget>[
                            Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 2),
                            Text(
                              'Sell',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],

                  // 4. Menu Icon
                  GestureDetector(
                    onTap: () => _advancedDrawerController.showDrawer(),
                    child: const Icon(LucideIcons.menu,
                        size: 24, color: Colors.black),
                  ),
                ],
              ),
              // Row 2: Location + Sales & Leads — Marketplace only. The feed,
              // Jobs and Deals tabs are not location filtered.
              if (_currentTabIndex ==
                  MarketplaceScreen.marketplaceTab) ...<Widget>[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // Location Picker Section
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Icon(Icons.place,
                            size: 18, color: Color(0xFFFF1E39)),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Flexible(
                                child: CountryListPick(
                                  appBar: AppBar(
                                    leading: IconButton(
                                      onPressed: () => Navigator.pop(context),
                                      icon: SvgPicture.asset(
                                          'assets/svgs/backbutton.svg'),
                                    ),
                                    centerTitle: true,
                                    title: const Text('Select Location'),
                                  ),
                                  initialSelection: (_marketController
                                              .selectedLocationCode?.isNotEmpty ??
                                          false)
                                      ? (_marketController.selectedLocationCode ==
                                              'UK'
                                          ? 'GB'
                                          : _marketController.selectedLocationCode)
                                      : 'GB',
                                  onChanged: (CountryCode? code) {
                                    selectedLocationChanged(code?.name, code?.code);
                                  },
                                  pickerBuilder:
                                      (BuildContext context, CountryCode? code) =>
                                          Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Flexible(
                                        child: Text(
                                          (code?.name ?? 'United Kingdom'),
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 2),
                                      const Icon(
                                        Icons.keyboard_arrow_down,
                                        size: 16,
                                        color: Colors.black54,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Sales & Leads
                  GestureDetector(
                    onTap: () => Get.to(() => const OrdersScreen()),
                    child: const Text(
                      'Leads & Orders',
                      style: TextStyle(
                        color: Color(0xFFFF1E39),
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                        decorationColor: Color(0xFFFF1E39),
                      ),
                    ),
                  ),
                ],
              ),
              ],
            ],
          ),
        );
      });
    });
  }

  /// Main tabs: For you, Marketplace, Jobs, Deals — plus the Find Match link.
  Widget _buildMainTabs() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TabBar(
              controller: _marketplaceTabController,
              // Scrollable so every label renders at the same font size. With
              // equal-width (non-scrollable) tabs the longer "Marketplace" label
              // was shrunk by the FittedBox and looked smaller than "Jobs".
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelPadding: const EdgeInsets.symmetric(horizontal: 10),
              // Selected reads dark + heavy; unselected sits back in grey at a
              // medium weight, so the active tab is obvious at a glance.
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black54,
              labelStyle:
                  const TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              indicatorColor: primaryColorLT,
              indicatorWeight: 3,
              tabs: const <Widget>[
                Tab(child: _TabLabel('For you')),
                Tab(child: _TabLabel('Marketplace')),
                Tab(child: _TabLabel('Jobs')),
                Tab(child: _TabLabel('Deals')),
              ],
            ),
          ),
          // Find Match sits beside the tabs — it opens the matching flow
          // instead of switching tabs.
          GestureDetector(
            onTap: () {
              Get.bottomSheet(
                PreMatchModal(),
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
              );
            },
            child: const Padding(
              padding: EdgeInsets.only(left: 6, right: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Find Match',
                    style: TextStyle(
                      color: Color(0xFF5B4DFF),
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                    ),
                  ),
                  Icon(Icons.chevron_right,
                      color: Color(0xFF5B4DFF), size: 14),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// "For you" tab — the boss up feed, with the performance / boss of the
  /// week cards as its header. Boosted (promoted) posts are part of this feed.
  Widget _buildForYouFeed() {
    return RefreshIndicator(
      onRefresh: () async {
        await homeController.loadData();
      },
      child: PostsWidget(
        scrollController: _feedScrollController,
        header: const ForYouTopCards(),
        showHero: false,
      ),
    );
  }

  /// Banner above the Jobs tab.
  Widget _buildJobsBanner() {
    return _buildActionBanner(
      message:
          'List work or job position and connect with active job seekers.',
      actionLabel: 'Post a Job',
      onTap: () => Get.to(() => AddBuyerRequests()),
    );
  }

  /// Banner above the Deals tab.
  Widget _buildDealsBanner() {
    return _buildActionBanner(
      message:
          'Become a partner, list deals, get featured & more customers.',
      actionLabel: 'Post a Deal',
      onTap: () {
        if (!_profileController.myProfile.isSubscribed) {
          showPremiumPaywall();
        } else {
          Get.to(() => const BecomeaPartnerScreen());
        }
      },
    );
  }

  Widget _buildActionBanner({
    required String message,
    required String actionLabel,
    required VoidCallback onTap,
  }) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF1E39),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: onTap,
            child: Text(
              actionLabel,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Category filter chips
  Widget _buildCategoryChips() {
    // We add "All" to the display categories
    final List<String> displayCategories = <String>['All', ...categories];

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              // Category chips scroll view
              Expanded(
                child: SingleChildScrollView(
                  controller: _categoryScrollController,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: displayCategories.map((String category) {
                      // Check selection
                      // If selectedCategory is null, 'All' is selected.
                      final int tabIndex = _marketplaceTabController.index;

                      bool isSelected;

                      if (tabIndex == MarketplaceScreen.marketplaceTab) {
                        // Seller
                        isSelected = (_marketController.selectedCategory ==
                                    null &&
                                category == 'All') ||
                            (_marketController.selectedCategory == category);
                      } else if (tabIndex == MarketplaceScreen.dealsTab) {
                        // Partner deals
                        isSelected =
                            (partnerController.selectedCategory.value ==
                                category);
                      } else {
                        // Buyer request
                        isSelected = (buyerRequestController
                                    .filterCategory.value.isEmpty &&
                                category == 'All') ||
                            (buyerRequestController.filterCategory.value ==
                                category);
                      }

                      return GestureDetector(
                        onTap: () {
                          final int tabIndex = _marketplaceTabController.index;

                          setState(() {
                            if (tabIndex == MarketplaceScreen.marketplaceTab) {
                              // 🔵 SELLER LISTING (MarketController)

                              if (category == 'All') {
                                _marketController.selectedCategory = null;
                                _marketController.isSearching(false);
                                _marketController.clearFilter();
                                _marketController.sortItems();
                              } else {
                                _marketController.loadCategory(category);
                              }
                            } else if (tabIndex == MarketplaceScreen.jobsTab) {
                              // 🟢 BUYER REQUEST (BuyerRequestController)

                              if (category == 'All') {
                                buyerRequestController.filterCategory('');
                              } else {
                                buyerRequestController.filterCategory(category);
                              }

                              buyerRequestController.filterBuyerRequests('');
                            } else if (tabIndex ==
                                MarketplaceScreen.dealsTab) {
                              // 🟡 PARTNER DEALS
                              partnerController.selectedCategory.value =
                                  category;
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFEEEEEE) // Grey for Selected
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            // No border typically for these chips in design, or subtle
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              // Dropdown arrow for more
              if (_showRightChevron)
                GestureDetector(
                  onTap: () {
                    _categoryScrollController.animateTo(
                      _categoryScrollController.offset + 150,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Icon(
                      LucideIcons.chevronRight,
                      color: Colors.black54,
                      size: 15,
                    ),
                  ),
                ),
            ],
          ),
          const Divider(height: 1),
        ],
      ),
    );
  }

  /// Handles the header "+ Sell" button (Marketplace tab only).
  void _handleCreateButton(BuildContext context) async {
    // Selling requires a shop first.
    if (!_profileController.myProfile.hasShop) {
      Get.to(() => const MyProfileScreen(currentIndex: 1));
      return;
    }

    _showSellOptions(context);
  }


  Widget _buildFeaturedListingSlide() {
    return Obx(() {
      return ProshopdealsWidget(
        isHome: false,
        caption: 'Featured Listing',
        combinedList: _marketController.featuredItems.take(10).toList(),
      );
    });
  }

  void _showSellOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (_) => SizedBox(
        height: 200,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: ListView.separated(
                  itemCount: 2,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (_, int index) => ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      if (index == 0) {
                        Get.to(
                          () => const CreateProductListing(isMarketplace: true),
                        );
                      } else {
                        Get.to(
                          () => const CreateServiceListing(isMarketplace: true),
                        );
                      }
                    },
                    leading: SvgPicture.asset(
                      index == 0
                          ? 'assets/svgs/addproduct.svg'
                          : 'assets/svgs/addservice.svg',
                      height: 25,
                      colorFilter: ColorFilter.mode(
                        textColor.withValues(alpha: 1),
                        BlendMode.srcIn,
                      ),
                    ),
                    title: Text(
                      index == 0 ? 'Sell your product' : 'Sell your service',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Single-line tab label used by the home tab bar.
class _TabLabel extends StatelessWidget {
  const _TabLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        text,
        textAlign: TextAlign.center,
        maxLines: 1,
        style: const TextStyle(height: 1.2, fontSize: 12),
      ),
    );
  }
}
