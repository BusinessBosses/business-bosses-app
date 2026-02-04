import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/service_model.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_product.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_service.dart';
import 'package:business_bosses_v2/bbpro/presentation/my_orders_screen.dart';
import 'package:business_bosses_v2/bbpro/widgets/proshopdeals.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/features/home/widgets/bottom_bar.dart';
import 'package:business_bosses_v2/features/impact/presentation/leaderboard_screen.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/requests_controller.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/supplier_controller.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/add_supplier.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/buyer_requests_form.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/buyer_requests_screen.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/markets.dart';
import 'package:business_bosses_v2/features/matching_feature/presentation/expanded_matches_screen.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/features/profile/presentation/my_profile_screen.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../bbpro/models/product_model.dart';
import '../../utils/theme/theme.dart';
import '../marketplace/controllers/market_controller.dart';
import '../marketplace/presentation/marketplace_search_screen.dart';

/// Marketplace main screen
class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen>
    with TickerProviderStateMixin {
  final MarketController _marketController = Get.find();
  final ShopController shopController = Get.find();
  final SupplierController supplierController = Get.put(SupplierController());
  final BuyerRequestController buyerRequestController =
      Get.put(BuyerRequestController());
  final ProfileController _profileController = Get.find();

  late final TabController _marketplaceTabController;

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
    'Business Services & Consulting'
  ];

  @override
  void initState() {
    super.initState();
    _marketplaceTabController = TabController(length: 3, vsync: this);
    _marketplaceTabController.addListener(() {
      setState(() {}); // Rebuild when tab changes to show/hide category chips
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _marketController.selectedCategory = null;
      _marketController.isSearching(false);
      _marketController.clearFilter();
      _marketController.sortItems();
      if (_marketController.proItems.isEmpty) {
        await _marketController.initMarket();
        _marketController.sortItems();
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
    _marketplaceTabController.dispose();
    super.dispose();
  }

  void selectedLocationChanged(String? name, String? code) {
    _marketController.changeLocation(name ?? '');
    _marketController.sortItems();
    setState(() {});
  }

  Future<void> refreshData() async {
    await _marketController.initMarket();
  }

  @override
  Widget build(BuildContext context) {
    _marketController.selectedLocation ??=
        _profileController.myProfile.location;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: <Widget>[
          NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                // Sticky AppBar with search bar
                SliverAppBar(
                  pinned: true,
                  floating: false,
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.white,
                  elevation: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Align(
                      alignment: Alignment.bottomCenter,
                      child: _buildTopHeader(),
                    ),
                  ),
                ),
                // Location row - collapses when scrolling
                SliverToBoxAdapter(
                  child: _buildLocationRow(),
                ),
                // Tabs - collapses when scrolling
                SliverToBoxAdapter(
                  child: _buildMainTabs(),
                ),
                // Category chips - only for first tab
                if (_marketplaceTabController.index == 0)
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                      child: ProshopdealsWidget(
                        title: 'NEW',
                        combinedList: _marketController.proItems
                            .where((Object item) {
                              if (item is Product) {
                                return item.images != null &&
                                    item.images!.isNotEmpty &&
                                    item.images!.first.isNotEmpty &&
                                    item.user!.isSubscribed;
                              } else {
                                final Service service = item as Service;
                                return service.images != null &&
                                    service.images!.isNotEmpty &&
                                    service.images![0].isNotEmpty &&
                                    service.user!.isSubscribed;
                              }
                            })
                            .take(10)
                            .toList(),
                      ),
                    ),
                  ),
                if (_marketplaceTabController.index == 0)
                  SliverToBoxAdapter(
                    child: _buildCategoryChips(),
                  ),
              ];
            },
            body: TabBarView(
              controller: _marketplaceTabController,
              children: <Widget>[
                // Tab 1: Marketplace Listings
                const MarketsPage(),
                const BuyerRequestsScreen(),
                const LeaderboardScreen(isMarketplace: true),
              ],
            ),
          ),
          // Bottom Bar
          BottomBar(activeIndex: 3),
        ],
      ),
    );
  }

  /// Top header with search bar, cart icon, and sell button
  Widget _buildTopHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: <Widget>[
          // Search bar
          Expanded(
            child: GestureDetector(
              onTap: () {
                Get.to(() => const MarketplaceSearchScreen());
              },
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.black87, width: 1.5),
                ),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Search',
                      style: TextStyle(
                        color: Colors.black.withValues(alpha: 0.7),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      LucideIcons.search,
                      color: Colors.black87,
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Shopping bag icon
          GestureDetector(
            onTap: () => Get.to(() => const MyOrdersScreen()),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.transparent, // Transparent as per design image
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                LucideIcons.shoppingBag,
                color: Colors.black87,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // + Sell button
          GestureDetector(
            onTap: () => _handleCreateButton(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFFF1E39), // Vibrant Red
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: <Widget>[
                  const Icon(Icons.add, color: Colors.white, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    _marketplaceTabController.index == 2
                        ? 'Add'
                        : _marketplaceTabController.index == 1
                            ? 'Create'
                            : 'Sell',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Location dropdown and Find Your Match link
  Widget _buildLocationRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.15)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // Location picker
          Flexible(
            child: CountryListPick(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
                ),
                centerTitle: true,
                title: const Text('Select Location'),
              ),
              initialSelection:
                  _marketController.selectedLocation ?? 'United Kingdom',
              onChanged: (CountryCode? code) {
                selectedLocationChanged(code?.name, code?.code);
              },
              pickerBuilder: (BuildContext context, CountryCode? code) => Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(Icons.place, size: 20, color: Color(0xFFFF1E39)),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Text(
                      _truncateLocation(
                          _marketController.selectedLocation ?? ''),
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.keyboard_arrow_down,
                      size: 20, color: Colors.grey.shade600),
                ],
              ),
            ),
          ),
          // Find Your Match link
          GestureDetector(
            onTap: () => Get.to(() => const ExpandedMatchesScreen()),
            child: const Row(
              children: <Widget>[
                Text(
                  'Find Your Match',
                  style: TextStyle(
                    color: Color.fromARGB(255, 9, 93, 237),
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                SizedBox(width: 4),
                Icon(Icons.chevron_right, color: Colors.blue, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _truncateLocation(String location) {
    if (location.length > 20) {
      return '${location.substring(0, 18)}...';
    }
    return location;
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
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        indicatorColor: primaryColorLT,
        indicatorWeight: 3,
        tabs: <Widget>[
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: const <Widget>[
                Icon(Icons.grid_view, color: Colors.deepOrange, size: 20),
                SizedBox(width: 6),
                Text(
                  'Seller\nListing',
                  textAlign: TextAlign.center,
                  style: TextStyle(height: 1.2),
                ),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: const <Widget>[
                Icon(LucideIcons.target, size: 20, color: Colors.deepOrange),
                SizedBox(width: 6),
                Text(
                  'Buyer\nRequest',
                  textAlign: TextAlign.center,
                  style: TextStyle(height: 1.2),
                ),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: const <Widget>[
                Icon(LucideIcons.trophy, size: 20, color: Colors.deepOrange),
                SizedBox(width: 6),
                Text(
                  'Ranking\nBusiness',
                  textAlign: TextAlign.center,
                  style: TextStyle(height: 1.2),
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
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: displayCategories.map((String category) {
                      // Check selection
                      // If selectedCategory is null, 'All' is selected.
                      final bool isSelected =
                          (_marketController.selectedCategory == null &&
                                  category == 'All') ||
                              (_marketController.selectedCategory == category);

                      return GestureDetector(
                        onTap: () async {
                          setState(() {
                            if (category == 'All') {
                              _marketController.selectedCategory = null;
                              _marketController.isSearching(false);
                              _marketController.clearFilter();
                              _marketController.sortItems();
                            } else {
                              _marketController.loadCategory(category);
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
                            category.length > 20
                                ? '${category.substring(0, 18)}...'
                                : category,
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
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(25.0)),
                    ),
                    builder: (_) => _buildFilterWidget(),
                  ).then((_) {
                    // Rebuild to update chips when filter sheet closes
                    setState(() {});
                  });
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

  /// Filter BottomSheet widget
  Widget _buildFilterWidget() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(left: 10.0, top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Filter results',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      // Add "All" option at the top
                      ListTile(
                        title: const Text('All'),
                        onTap: () {
                          setState(() {
                            _marketController.selectedCategory = null;
                            supplierController.filterCategory.value = '';
                          });
                        },
                        trailing: _marketController.selectedCategory == null
                            ? const Icon(
                                Icons.check,
                                size: 20,
                                color: primaryColorLT,
                              )
                            : null,
                      ),
                      const Divider(),
                      ...categories.map((String category) {
                        return ListTile(
                          title: Text(category),
                          onTap: () {
                            setState(() {
                              _marketController.selectedCategory = category;
                              supplierController.filterCategory.value =
                                  category;
                            });
                          },
                          trailing:
                              _marketController.selectedCategory == category
                                  ? const Icon(
                                      Icons.check,
                                      size: 20,
                                      color: primaryColorLT,
                                    )
                                  : null,
                        );
                      }),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    OutlinedButton(
                      onPressed: () {
                        _marketController.selectedCategory = null;
                        supplierController.filterCategory.value = '';
                        _marketController.clearFilter();
                        _marketController.sortItems(); // Restore all items
                        Navigator.pop(context);
                        setState(() {}); // Update UI after closing
                      },
                      child: const Text('Reset'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _marketController
                            .filterItems(_marketController.searchQuery);
                        supplierController
                            .searchSuppliers(_marketController.searchQuery);
                        setState(() {}); // Update UI after closing
                      },
                      child: const Text(
                        'Apply Filter',
                        style: TextStyle(color: Colors.white),
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

  /// Handles creation button press logic (moved from big nested ifs)
  void _handleCreateButton(BuildContext context) async {
    final int index = _marketplaceTabController.index;
    if (!_profileController.myProfile.hasShop && index != 1 && index < 4) {
      Get.to(() => const MyProfileScreen(currentIndex: 1));
      return;
    }

    if (index == 1) {
      Get.to(() => AddBuyerRequests());
    } else if (index == 2) {
      _showSupplierOptions(context);
    } else {
      _showSellOptions(context);
    }
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
                        Get.to(() => const CreateProductListing(
                              isMarketplace: true,
                            ));
                      } else {
                        Get.to(() => const CreateServiceListing(
                              isMarketplace: true,
                            ));
                      }
                    },
                    leading: SvgPicture.asset(
                      index == 0
                          ? 'assets/svgs/addproduct.svg'
                          : 'assets/svgs/addservice.svg',
                      height: 25,
                      colorFilter: ColorFilter.mode(
                          textColor.withValues(alpha: 1), BlendMode.srcIn),
                    ),
                    title: Text(
                      index == 0 ? 'Sell your product' : 'Sell your service',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w700),
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

  void _showSupplierOptions(BuildContext context) {
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
                        Get.to(() => const AddSupplierScreen());
                      } else {
                        if (shopController.shop != null) {
                          Get.to(() =>
                              AddSupplierScreen(shop: shopController.shop));
                        } else {
                          showSnackbar(
                              message:
                                  "You don't have a shop in Biz Center yet!",
                              error: true);
                        }
                      }
                    },
                    leading: SvgPicture.asset(
                      index == 0
                          ? 'assets/svgs/addproduct.svg'
                          : 'assets/svgs/addservice.svg',
                      height: 25,
                      colorFilter: ColorFilter.mode(
                          textColor.withValues(alpha: 1), BlendMode.srcIn),
                    ),
                    title: Text(
                      index == 0 ? 'Add New Business' : 'Add from Biz Center',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w700),
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
