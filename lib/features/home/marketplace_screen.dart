import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_product.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_service.dart';
import 'package:business_bosses_v2/bbpro/presentation/my_orders_screen.dart';
import 'package:business_bosses_v2/bbpro/widgets/button.dart';
import 'package:business_bosses_v2/bbpro/widgets/proseardwidget.dart';
import 'package:business_bosses_v2/features/donations/presentation/filtersuppliers.dart';
import 'package:business_bosses_v2/features/home/widgets/bottom_bar.dart';
import 'package:business_bosses_v2/features/home/widgets/buyer_requests_form.dart';
import 'package:business_bosses_v2/features/home/widgets/buyer_requests_screen.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/requests_controller.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/supplier_controller.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/filtermarketplaceposts.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/filtermarketproducts.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/filtermarketservices.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/supplierspage.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/markets.dart';
import 'package:business_bosses_v2/features/matching_feature/presentation/expanded_matches_screen.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/features/profile/presentation/my_profile_screen.dart';
import 'package:business_bosses_v2/features/search/widgets/search_bar.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../common/widgets/safety_model.dart';
import '../../utils/theme/theme.dart';
import '../marketplace/controllers/market_controller.dart';

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

  final ScrollController _scrollController = ScrollController();
  late final TabController _marketplacesearchTabController;
  late final TabController _marketplaceTabController;

  bool _ismarketplaceSearching = false;
  bool hasOldData = false;

  final List<String> categories = const <String>[
    'Agriculture, Food & Beverage',
    'Books & Education',
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
    'Other'
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_marketController.proItems.isEmpty) {
        await _marketController.initMarket();
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

    _marketplacesearchTabController = TabController(length: 4, vsync: this);
    _marketplaceTabController = TabController(length: 4, vsync: this);

    _marketplaceTabController.addListener(() {
      if (!_marketplaceTabController.indexIsChanging) {
        setState(() {});
      }
    });

    _scrollController.addListener(() {
      final double percentageScrolled =
          _scrollController.offset / _scrollController.position.maxScrollExtent;
      _marketController.showFloatingButton(percentageScrolled >= 0.3);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _marketplacesearchTabController.dispose();
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

    // Sort only once after initial data load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _marketController.sortItems();
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 50),
        child: Column(
          children: <Widget>[
            if (!_ismarketplaceSearching)
              _buildMainAppBar(
                  context), // ✅ Always show your location + actions bar

            // ✅ Below it, show either the searchbar or the tabbed search mode
            _ismarketplaceSearching
                ? SafeArea(
                    top: true,
                    bottom: false,
                    child: Column(
                      children: <Widget>[
                        // ✅ Top search + filter + close bar
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 8),
                          child: Row(
                            children: <Widget>[
                              // 🔍 Search bar
                              Expanded(
                                child: Searchbar(
                                  hintText: _marketplacesearchTabController
                                              .index ==
                                          0
                                      ? 'Search Marketplace'
                                      : _marketplacesearchTabController.index ==
                                              1
                                          ? 'Search Products'
                                          : _marketplacesearchTabController
                                                      .index ==
                                                  2
                                              ? 'Search Services'
                                              : 'Find Suppliers for your Business',
                                  ismarketplace: true,
                                  onChange: (String query) {
                                    if (query.trim().isEmpty) {
                                      supplierController.clearSupplierSearch();
                                      _marketController.clearFilter();
                                    } else {
                                      _marketController.filterItems(query);
                                      supplierController.searchSuppliers(query);
                                    }
                                    setState(() {});
                                  },
                                  onSubmit: (String query) {
                                    _marketController.filterItems(query);
                                    supplierController.searchSuppliers(query);
                                  },
                                ),
                              ),

                              const SizedBox(width: 8),

                              // ⚙️ Filter button
                              IconButton(
                                icon: const Icon(Icons.filter_alt_outlined,
                                    color: Colors.black87),
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(25.0)),
                                    ),
                                    builder: (_) => _buildFilterWidget(),
                                  );
                                },
                              ),

                              // ❌ Close button
                              IconButton(
                                icon: const Icon(Icons.close,
                                    color: Colors.black87),
                                onPressed: () {
                                  setState(() {
                                    _ismarketplaceSearching = false;
                                    _marketController.clearFilter();
                                    supplierController.searchedSuppliers
                                        .clear();
                                  });
                                },
                              ),
                            ],
                          ),
                        ),

                        // ✅ Tabs under search
                        Container(
                          color: Colors.white,
                          child: TabBar(
                            controller: _marketplacesearchTabController,
                            labelStyle:
                                const TextStyle(fontWeight: FontWeight.w500),
                            labelColor: Colors.black,
                            indicatorColor: primaryColorLT,
                            tabs: const <Widget>[
                              Tab(text: 'All'),
                              Tab(text: 'Products'),
                              Tab(text: 'Services'),
                              Tab(text: 'Suppliers'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : _buildSearchBar(context),
// ✅ The normal search bar below AppBar
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          // Main content (loading, search, or normal view)
          Obx(() {
            if (_marketController.loading.value) {
              // Still show the bottom bar beneath the loader
              return const SafetyModel();
            }

            // Search mode
            if (_ismarketplaceSearching) {
              return Column(
                children: <Widget>[
                  Expanded(
                    child: TabBarView(
                      controller: _marketplacesearchTabController,
                      children: <Widget>[
                        const FilterMarketplacePosts(),
                        const FilterMarketplaceProducts(),
                        const FilterMarketServices(),
                        Obx(
                          () => FilterSuppliers(
                            members: supplierController.suppliers,
                            filterItems: supplierController.searchedSuppliers,
                            isLoading: supplierController.loading.value ||
                                supplierController.loadingSearch.value,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            // Default main content
            return _buildMainContent();
          }),

          // ✅ Persistent bottom bar (always visible)
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomBar(activeIndex: 3),
          ),
        ],
      ),
    );
  }

  /// Builds the main marketplace app bar with location picker & actions
  Widget _buildMainAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: CountryListPick(
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
          children: <Widget>[
            const Icon(Icons.place, size: 18),
            const SizedBox(width: 5),
            Text(
              _marketController.selectedLocation ?? '',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 5),
            SvgPicture.asset('assets/svgs/dropdown.svg'),
          ],
        ),
      ),
      actions: <Widget>[
        _buildAppBarIcons(context),
      ],
    );
  }

  Widget _buildAppBarIcons(BuildContext context) {
    return Row(
      children: <Widget>[
        GestureDetector(
          onTap: () => Get.to(() => const MyOrdersScreen()),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: backgroundColor,
            child: SvgPicture.asset('assets/svgs/shoppingcart.svg', height: 22),
          ),
        ),
        const SizedBox(width: 10),
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: ProCustomButton(
            padding: 0,
            icon: SvgPicture.asset('assets/svgs/startatopic.svg'),
            color: primaryColorLT,
            onPressed: () {
              _handleCreateButton(context);
            },
            text: _marketplaceTabController.index == 2
                ? 'Add'
                : _marketplaceTabController.index == 1
                    ? 'Create request'
                    : 'Sell',
          ),
        ),
      ],
    );
  }

  /// Searchbar & filtering
  Widget _buildSearchBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Expanded(
            child: ProSearchbar(
              hintText: 'Search Marketplace',
              hasSearchIcon: true,
              backgroundColor: backgroundColor,
              radius: 10,
              autofocus: false,

              // 🔍 when the user taps into search mode
              onTap: () {
                setState(() {
                  _ismarketplaceSearching = true;
                });
              },

              // ⚙️ when they press the filter icon
              onfiltertap: () {
                setState(() {
                  _ismarketplaceSearching = true;
                });
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(25)),
                  ),
                  builder: (BuildContext context) {
                    return _buildFilterWidget();
                  },
                );
              },

              // ✅ called as user types
              onChange: (String query) {
                if (query.trim().isEmpty) {
                  _marketController.clearFilter();
                  supplierController.clearSupplierSearch();
                } else {
                  _marketController.filterItems(query);
                  supplierController.searchSuppliers(query);
                }
              },

              // ✅ called when user presses “search” on keyboard
              onSubmit: (String query) {
                _marketController.filterItems(query);
                supplierController.searchSuppliers(query);
              },
            ),
          ),
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
                    children: categories.map((String category) {
                      return ListTile(
                        title: Text(category),
                        onTap: () {
                          setState(() {
                            _marketController.selectedCategory = category;
                            supplierController.filterCategory.value = category;
                          });
                        },
                        trailing: _marketController.selectedCategory == category
                            ? const Icon(
                                Icons.check,
                                size: 20,
                                color: primaryColorLT,
                              )
                            : null,
                      );
                    }).toList(),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _marketController.selectedCategory = null;
                          supplierController.filterCategory.value = '';
                          _marketController
                              .filterItems(_marketController.searchQuery);
                        });
                        Navigator.pop(context);
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

  /// Main marketplace content with tabs
  Widget _buildMainContent() {
    return Stack(
      children: <Widget>[
        NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (_, __) => <Widget>[],
          body: Obx(() {
            if (_marketController.loading.value) {
              return const Center(child: CircularProgressIndicator());
            } else if (_marketController.error.value) {
              return SafetyModel(
                isLoading: false,
                title: 'Error While Loading Data',
                subTitle: 'Try Reloading Again',
                icon: const Icon(Icons.warning, size: 60),
                clickableText: 'Reload',
                onTap: () => _marketController.initMarket(),
              );
            } else {
              return RefreshIndicator(
                onRefresh: refreshData,
                child: DefaultTabController(
                  length: 4,
                  child: Column(
                    children: <Widget>[
                      _buildMarketplaceTabs(),
                      Expanded(
                        child: TabBarView(
                          controller: _marketplaceTabController,
                          children: const <Widget>[
                            MarketsPage(),
                            BuyerRequestsScreen(),
                            SuppliersPage(),
                            ExpandedMatchesScreen(isMarketplace: true),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
        ),
        BottomBar(activeIndex: 3),
      ],
    );
  }

  Widget _buildMarketplaceTabs() {
    return Container(
      constraints: const BoxConstraints.expand(height: 45),
      child: TabBar(
        tabAlignment: TabAlignment.start,
        isScrollable: true,
        controller: _marketplaceTabController,
        labelPadding: const EdgeInsets.symmetric(horizontal: 15),
        labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        unselectedLabelColor: textColor.withOpacity(0.7),
        tabs: const <Widget>[
          Tab(text: 'Listing'),
          Tab(text: 'Requests'),
          Tab(text: 'Suppliers'),
          Tab(text: 'Find My Match'),
        ],
      ),
    );
  }

  /// Handles creation button press logic (moved from big nested ifs)
  void _handleCreateButton(BuildContext context) async {
    final int index = _marketplaceTabController.index;
    if (!_profileController.myProfile.hasShop && index < 4) {
      Get.to(() => const MyProfileScreen(currentIndex: 1));
      return;
    }

    if (index == 1) {
      Get.to(() => BuyerRequests());
    } else if (index == 2) {
      Get.to(() => const CreateServiceListing(isMarketplace: true));
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
                          textColor.withOpacity(1), BlendMode.srcIn),
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
}
