import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_product.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_service.dart';
import 'package:business_bosses_v2/bbpro/widgets/proshopdeals.dart';
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/home/controller/commumities_controller.dart';
import 'package:business_bosses_v2/features/home/controller/home_controller.dart';

import 'package:business_bosses_v2/features/home/widgets/bottom_bar.dart';
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
import 'package:business_bosses_v2/features/impact/presentation/impact_screen.dart';
import 'package:business_bosses_v2/bbpro/presentation/orders_and_invoices.dart';
import 'dart:async';

/// Marketplace main screen
class MarketplaceScreen extends StatefulWidget {
  final int initialIndex;
  const MarketplaceScreen({super.key, this.initialIndex = 0});

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

  final PageController _sliderPageController = PageController();
  int _sliderIndex = 0;
  Timer? _sliderTimer;

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
      length: 3,
      vsync: this,
      initialIndex: widget.initialIndex,
    );

    _sliderTimer = Timer.periodic(const Duration(seconds: 9), (Timer timer) {
      if (_sliderPageController.hasClients) {
        int nextIndex = (_sliderIndex + 1) % 2;
        _sliderPageController.animateToPage(
          nextIndex,
          duration: const Duration(seconds: 9),
          curve: Curves.easeInOut,
        );
      }
    });

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
          if (index == 0) {
            // Reset buyer requests fully
            buyerRequestController.filterCategory.value = '';
            buyerRequestController.filterLocation.value = '';
            buyerRequestController.filterBuyerRequests('');
          }

          if (index == 1) {
            _marketController.selectedCategory = null;
            _marketController.isSearching(false);
            _marketController.clearFilter();
            _marketController.sortItems();
          }

          if (index == 2) {
            partnerController.selectedCategory.value = 'All';
          }
        }

        setState(() {
          _currentTabIndex = index;
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
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
    _sliderTimer?.cancel();
    _sliderPageController.dispose();
    _marketplaceTabController.dispose();
    _advancedDrawerController.dispose();
    super.dispose();
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
        child: Scaffold(
          backgroundColor: backgroundColor,
          body: Obx(() {
            if (homeController.loading.value) {
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
                toolbarHeight: 120,
                flexibleSpace: FlexibleSpaceBar(
                  background: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: _buildCombinedHeader(),
                    ),
                  ),
                ),
              ),
              // Tabs - collapses when scrolling
              SliverToBoxAdapter(child: _buildMainTabs()),
              // Slider at the top of Marketplace
              SliverToBoxAdapter(child: _buildTopSlider()),

              if (_marketplaceTabController.index == 0 ||
                  _marketplaceTabController.index == 1 ||
                  _marketplaceTabController.index == 2)
                SliverToBoxAdapter(child: _buildCategoryChips()),
            ];
          },
          body: TabBarView(
            controller: _marketplaceTabController,
            children: <Widget>[
              // Tab 1: Marketplace Listings
              const MarketsPage(),
              const BuyerRequestsScreen(showAppBar: false),
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
                'Access Business Opportunities Worldwide',
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

                  // 3. Red Square + Button
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
                        children: <Widget>[
                          const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            _marketplaceTabController.index == 1
                                ? 'Need'
                                : _marketplaceTabController.index == 2
                                    ? 'Deal'
                                    : 'Sell',
                            style: const TextStyle(
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

                  // 4. Menu Icon
                  GestureDetector(
                    onTap: () => _advancedDrawerController.showDrawer(),
                    child: const Icon(LucideIcons.menu,
                        size: 24, color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Row 2: Location Picker and Find Your Match
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
                                    code?.name ?? 'United Kingdom',
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

                  const SizedBox(width: 12),

                  // Find Your Match Section
                  GestureDetector(
                    onTap: () {
                      Get.bottomSheet(
                        PreMatchModal(),
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const <Widget>[
                        Text(
                          'Find Your Match',
                          style: TextStyle(
                            color: Color(0xFF5B4DFF),
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.chevron_right,
                            color: Color(0xFF5B4DFF), size: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      });
    });
  }

  /// Main tabs: Seller Listing, Buyer Request, Ranking Business
  Widget _buildMainTabs() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
        ),
      ),
      child: TabBar(
        controller: _marketplaceTabController,
        isScrollable: false,
        labelColor: Colors.black87,
        unselectedLabelColor: Colors.black87,
        labelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 13,
        ),
        indicatorColor: primaryColorLT,
        indicatorWeight: 3,
        tabs: <Widget>[
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: const <Widget>[
                Icon(Icons.grid_view, color: Color(0xFFF27121), size: 20),
                SizedBox(width: 6),
                Text(
                  'I Sell',
                  textAlign: TextAlign.center,
                  style: TextStyle(height: 1.2, fontSize: 13),
                ),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: const <Widget>[
                Icon(Icons.gps_fixed, size: 20, color: Color(0xFFF27121)),
                SizedBox(width: 6),
                Text(
                  'I Need',
                  textAlign: TextAlign.center,
                  style: TextStyle(height: 1.2, fontSize: 13),
                ),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: const <Widget>[
                Icon(LucideIcons.trophy, size: 20, color: Color(0xFFF27121)),
                SizedBox(width: 6),
                Text(
                  'Top Deals',
                  textAlign: TextAlign.center,
                  style: TextStyle(height: 1.2, fontSize: 13),
                ),
              ],
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

                      if (tabIndex == 0) {
                        // Seller
                        isSelected = (_marketController.selectedCategory ==
                                    null &&
                                category == 'All') ||
                            (_marketController.selectedCategory == category);
                      } else if (tabIndex == 2) {
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
                            if (tabIndex == 0) {
                              // 🔵 SELLER LISTING (MarketController)

                              if (category == 'All') {
                                _marketController.selectedCategory = null;
                                _marketController.isSearching(false);
                                _marketController.clearFilter();
                                _marketController.sortItems();
                              } else {
                                _marketController.loadCategory(category);
                              }
                            } else if (tabIndex == 1) {
                              // 🟢 BUYER REQUEST (BuyerRequestController)

                              if (category == 'All') {
                                buyerRequestController.filterCategory('');
                              } else {
                                buyerRequestController.filterCategory(category);
                              }

                              buyerRequestController.filterBuyerRequests('');
                            } else if (tabIndex == 2) {
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

  /// Handles creation button press logic (moved from big nested ifs)
  void _handleCreateButton(BuildContext context) async {
    final int index = _marketplaceTabController.index;

    // Redirect only for index 0 and 3 (example)
    if (!_profileController.myProfile.hasShop && (index == 0 || index == 3)) {
      Get.to(() => const MyProfileScreen(currentIndex: 1));
      return;
    }

    if (index == 1) {
      Get.to(() => AddBuyerRequests());
    } else if (index == 2) {
      if (!_profileController.myProfile.isSubscribed) {
        showPremiumPaywall();
      } else {
        Get.to(() => const BecomeaPartnerScreen());
      }
    } else {
      _showSellOptions(context);
    }
  }

  Widget _buildTopSlider() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 205,
          child: PageView(
            controller: _sliderPageController,
            onPageChanged: (int index) => setState(() => _sliderIndex = index),
            children: <Widget>[
              _buildInsightSlide(),
              _buildFeaturedListingSlide(),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(2, (int index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    _sliderIndex == index ? Colors.black : Colors.grey.shade300,
              ),
            );
          }),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildInsightSlide() {
    return GetBuilder<ReachController>(
      builder: (ReachController reach) {
        final Map<String, dynamic> data = reach.myReach ?? <String, dynamic>{};
        final String reachScore =
            _formatReachScore(data['totalReachPoints'] ?? 0);
        final String matchesCount = '${_matchController.matchList.length}';

        // Prioritize industry rank, then global rank
        String ranking = 'N/A';
        final dynamic shopIndustryRank = data['shopIndustryRank'];
        final dynamic indRank = shopIndustryRank?['industryRank'];
        final dynamic globRank = data['globalRank'];

        if (indRank != null && indRank != 0) {
          ranking = '#$indRank';
        } else if (globRank != null && globRank != 0) {
          ranking = '#$globRank';
        }

        return GestureDetector(
          onTap: () =>
              Get.to(() => ReachScreen(user: _profileController.myProfile)),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text('View Insight',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const Icon(Icons.chevron_right, size: 20),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _buildInsightMetric('Reach Score', reachScore),
                    _buildInsightMetric('Matches', matchesCount),
                    _buildInsightMetric('Ranking', ranking),
                  ],
                ),
                const Spacer(),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.red,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: Color(0xFFFECACA)),
                          ),
                        ),
                        onPressed: () => Get.to(() => const OrdersScreen()),
                        child: const Text('Leads & Orders',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          if (_profileController.myProfile.isSubscribed) {
                            Get.to(() => ReachScreen(
                                user: _profileController.myProfile));
                          } else {
                            showPremiumPaywall();
                          }
                        },
                        child: const Text('Boost Visibility',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatReachScore(num value) {
    if (value >= 1000) {
      double formatted = value / 1000;
      return '${formatted.toStringAsFixed(formatted % 1 == 0 ? 0 : 1)}k';
    }
    return value.toString();
  }

  Widget _buildInsightMetric(String label, String value) {
    return Container(
      width: (Get.width - 70) / 3,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: <Widget>[
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xFFB91C1C),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFFEF4444),
            ),
          ),
        ],
      ),
    );
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
