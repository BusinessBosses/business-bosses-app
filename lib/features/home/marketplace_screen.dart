import 'package:business_bosses_v2/features/donations/presentation/filtersuppliers.dart';
import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:business_bosses_v2/features/home/widgets/bottom_bar.dart';
import 'package:business_bosses_v2/features/home/widgets/floatingbutton.dart';
import 'package:business_bosses_v2/features/live_event/presentation/live_event.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/supplier_controller.dart';
import 'package:business_bosses_v2/features/marketplace/models/market_model.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/filtermarketplaceposts.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/sell_screen.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/supplierspage.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/marketplace_item.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/markets.dart';

import 'package:business_bosses_v2/features/marketplace/widgets/products.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/service_item.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/services.dart';
import 'package:business_bosses_v2/features/search/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../common/models/user_model.dart';
import '../../common/widgets/buttons/my_outlined_button.dart';
import '../../common/widgets/safety_model.dart';
import '../../services/api_service.dart';
import '../../utils/constants/constants.dart';
import '../../utils/theme/theme.dart';
import '../marketplace/controllers/market_controller.dart';
import '../profile/controller/profile_controller.dart';
import 'controller/home_controller.dart';

/// Buying and Selling screen
class MarketplaceScreen extends StatefulWidget {
  /// Mrketplace constructor
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen>
    with TickerProviderStateMixin {
  final ProfileController _profileController = Get.find();
  final MarketController _marketController = Get.find();
  final HomeController hmeController = Get.find();
  String? _selectedCategory;
  String? _selectedLocation;
  String? filterCode;
  String? filterLocation;
  String? filterCategory;
  int pageSize = 20;
  String? filteredCategory;
  bool isScrolled = true;
  final ScrollController _scrollController = ScrollController();
  bool showFloatingButton = false;
  bool _ismarketplaceSearching = false;
  late final TabController _marketplacesearchTabController;
  late final TabController _marketplaceTabController;
  bool isfiltervisible = true;
  bool databool = true;
  final SupplierController supplierController = Get.put(SupplierController());

  @override
  void initState() {
    super.initState();
    _marketplacesearchTabController = TabController(length: 3, vsync: this);
    _marketplaceTabController = TabController(length: 4, vsync: this);

    supplierController.initSuppliers();
    _scrollController.addListener(() {
      double percentageScrolled =
          _scrollController.offset / _scrollController.position.maxScrollExtent;

      if (percentageScrolled >= 0.3) {
        setState(() {
          showFloatingButton = true;
        });
      } else {
        setState(() {
          showFloatingButton = false;
        });
      }
    });
  }

  void _handleTabSelection() {
    setState(() {});
  }

  void selectedCategoryChanged(String? newValue) {
    setState(() {
      _selectedCategory = newValue;
    });
  }

  void selectedLocationChanged(String? name, String? code) {
    setState(
      () {
        _selectedLocation = name;
        filterCode = code;
      },
    );
  }

  String formatCount(int count) {
    if (count >= 1000) {
      double countInK = count / 1000;
      if (countInK >= 1000) {
        return '${(countInK / 1000).toStringAsFixed(1)}M';
      } else {
        return '${countInK.toStringAsFixed(1)}K';
      }
    } else {
      return count.toString();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _marketplaceTabController.addListener(() {
        if (_marketplaceTabController.index == 2) {
          setState(() {
            databool = false;
          });
        }
      });
    });

    //int userCount = _marketController.users.length;
    //String formattedUserCount = formatCount(userCount);
    _marketplacesearchTabController.addListener(_handleTabSelection);

    return Scaffold(
      backgroundColor: backgroundcolorinterface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: _ismarketplaceSearching
            ? SizedBox(
                height: 42,
                child: Searchbar(
                  hintText: _marketplacesearchTabController.index == 0
                      ? 'Search Products'
                      : _marketplacesearchTabController.index == 1
                          ? 'Search Services'
                          : 'Find Suppliers for your Business',
                  onChange: (String query) {
                    if (query.isEmpty) {
                      _marketplacesearchTabController.index == 2
                          ? supplierController.clearSupplierSearch()
                          : _marketplacesearchTabController.index == 1
                              ? _marketController.clearPostSearch()
                              : _marketController.clearServiceSearch();
                    }
                    setState(() {});
                  },
                  onSubmit: (String query) {
                    supplierController.searchSuppliers(query);
                    _marketController.searchServices(query);
                    _marketController.searchPosts(
                      query,
                    );
                    setState(() {});
                  },
                ),
              )
            : const Text('Marketplace'),
        bottom: _ismarketplaceSearching
            ? TabBar(
                controller: _marketplacesearchTabController,
                labelStyle: const TextStyle(fontWeight: FontWeight.w500),
                labelColor: Colors.black,
                indicatorColor: primaryColorLT,
                tabs: const <Widget>[
                  Tab(text: 'Products'),
                  Tab(text: 'Services'),
                  Tab(text: 'Suppliers'),
                ],
              )
            : const PreferredSize(
                preferredSize: Size.fromHeight(0.0),
                child: SizedBox(height: 0),
              ),
        actions: _ismarketplaceSearching
            ? <Widget>[
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _ismarketplaceSearching = !_ismarketplaceSearching;
                      _marketController.searchedPosts.clear();
                      _marketController.searchedServices.clear();
                      supplierController.searchedSuppliers.clear();
                    });
                  },
                ),
              ]
            : <Widget>[
                if (!_ismarketplaceSearching)
                  IconButton(
                    onPressed: () {
                      Get.to(() => const LiveEvent());
                    },
                    icon: const Icon(Icons.calendar_month),
                  ),
                IconButton(
                  icon: _ismarketplaceSearching
                      ? const Icon(Icons.close)
                      : SvgPicture.asset('assets/svgs/search.svg'),
                  onPressed: () {
                    _ismarketplaceSearching = !_ismarketplaceSearching;
                    setState(() {});
                    _marketController.searchedPosts.clear();
                    _marketController.searchedServices.clear();
                    supplierController.searchedSuppliers.clear();
                  },
                )
              ],
      ),
      body: _marketController.isLoading
          ? const CircularProgressIndicator()
          : _ismarketplaceSearching
              ? TabBarView(
                  controller: _marketplacesearchTabController,
                  children: <Widget>[
                    Obx(
                      () {
                        final List<MarketModel> filteredMarkets =
                            _marketController.searchedPosts
                                .where((MarketModel market) {
                          bool matchesLocation = true;
                          bool matchesCategory = true;

                          if (_selectedLocation != null &&
                              _selectedLocation!.isNotEmpty) {
                            matchesLocation =
                                market.location == _selectedLocation;
                          }

                          if (_selectedCategory != null &&
                              _selectedCategory!.isNotEmpty) {
                            matchesCategory =
                                market.category == _selectedCategory;
                          }

                          return matchesLocation && matchesCategory;
                        }).toList();

                        return FilterMarketplacePosts(
                          isPostssearch: true,
                          selectedLocation: _selectedLocation,
                          selectedCategory: _selectedCategory,
                          selectedCategoryChanged: selectedCategoryChanged,
                          selectedLocationChanged: selectedLocationChanged,
                          filterItems: filteredMarkets,
                          isLoading: _marketController.loading.value ||
                              _marketController.loadingPostSearch.value,
                        );
                      },
                    ),
                    Obx(
                      () => FilterMarketplacePosts(
                        isPostssearch: false,
                        filterItems: _marketController.searchedServices,
                        isLoading: _marketController.loading.value ||
                            _marketController.loadingServicesSearch.value,
                      ),
                    ),
                    Obx(() => FilterSuppliers(
                          members: supplierController.suppliers,
                          filterItems: supplierController.searchedSuppliers,
                          isLoading: supplierController.loading.value ||
                              supplierController.loadingSearch.value,
                        )),
                  ],
                )
              : SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white,
                        child: NestedScrollView(
                          controller: _scrollController,
                          headerSliverBuilder:
                              (BuildContext context, bool innerBoxIsScrolled) {
                            return <Widget>[];
                          },
                          body: Obx(() {
                            if (_marketController.loading.value) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (_marketController.error.value) {
                              return const SafetyModel(
                                isLoading: false,
                                title: 'Error While Loading Data',
                                subTitle: 'Try Reloading Again',
                                icon: Icon(
                                  Icons.warning,
                                  size: 60,
                                ),
                              );
                            } else {
                              return _marketController.products.isEmpty &&
                                      !_marketController.isfiltered.value
                                  ? SafetyModel(
                                      isLoading: false,
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.grey,
                                        size: 80.0,
                                      ),
                                      title:
                                          'Be the first one to Sell your Item',
                                      // subTitle: '',
                                      clickableText: 'Post an item',
                                      onTap: () {
                                        Get.to(
                                          () => const CreateSellingitemScreen(
                                            isUpd: false,
                                          ),
                                        );
                                      },
                                    )
                                  : _marketController.searchResult.isEmpty &&
                                          _marketController.isfiltered.value
                                      ? SafetyModel(
                                          isLoading: false,
                                          icon: const Icon(
                                            Icons.shopping_cart,
                                            color: Colors.grey,
                                            size: 80.0,
                                          ),
                                          title:
                                              'No Items Available For This Search',
                                          // subTitle: '',
                                          clickableText: 'View All',
                                          onTap: () {
                                            setState(
                                              () {
                                                filterLocation = null;
                                                filterCode = null;
                                                filterCategory = null;
                                                _selectedLocation = null;
                                                _selectedCategory = null;
                                                _marketController
                                                    .updateFiltered();
                                                _marketController.initMarket();
                                              },
                                            );
                                          },
                                        )
                                      : RefreshIndicator(
                                          onRefresh: refreshData,
                                          child: _marketController
                                                  .isfiltered.value
                                              ? NotificationListener<
                                                  ScrollNotification>(
                                                  onNotification:
                                                      (ScrollNotification
                                                          notification) {
                                                    if (notification
                                                        is ScrollUpdateNotification) {
                                                      if (notification
                                                                  .dragDetails !=
                                                              null &&
                                                          notification
                                                                  .dragDetails!
                                                                  .primaryDelta !=
                                                              null) {
                                                        double primaryDelta =
                                                            notification
                                                                .dragDetails!
                                                                .primaryDelta!;

                                                        if (primaryDelta > 0) {
                                                          // Scrolling downward
                                                          setState(() {
                                                            isScrolled = true;
                                                          });
                                                        } else if (primaryDelta <
                                                            0) {
                                                          // Scrolling upward
                                                          setState(() {
                                                            isScrolled = false;
                                                          });
                                                        }
                                                      }
                                                    }

                                                    return true;
                                                  },
                                                  child: ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount: _marketController
                                                            .isfiltered.value
                                                        ? _marketController
                                                            .searchResult.length
                                                        : _marketController
                                                                .markets
                                                                .length +
                                                            1,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      if (index <
                                                          (_marketController
                                                                  .isfiltered
                                                                  .value
                                                              ? _marketController
                                                                  .searchResult
                                                                  .length
                                                              : _marketController
                                                                  .markets
                                                                  .length)) {
                                                        final MarketModel
                                                            market =
                                                            _marketController
                                                                    .isfiltered
                                                                    .value
                                                                ? _marketController
                                                                        .searchResult[
                                                                    index]
                                                                : _marketController
                                                                        .markets[
                                                                    index];
                                                        return VisibilityDetector(
                                                          key: Key(
                                                              index.toString()),
                                                          onVisibilityChanged:
                                                              (VisibilityInfo
                                                                  info) {
                                                            final bool
                                                                hasIncrementedView =
                                                                hmeController
                                                                    .itemsWithIncrementedViews
                                                                    .contains(_marketController
                                                                        .markets[
                                                                            index]
                                                                        .marketId);
                                                            if (info.visibleFraction ==
                                                                    1.0 &&
                                                                !hasIncrementedView) {
                                                              _marketController
                                                                  .updatemarketViews(
                                                                      _marketController
                                                                              .markets[
                                                                          index]);
                                                              setState(() {
                                                                hmeController
                                                                    .itemsWithIncrementedViews
                                                                    .add(_marketController
                                                                        .markets[
                                                                            index]
                                                                        .marketId); // Set the flag to prevent further increments
                                                              });
                                                            }
                                                          },
                                                          child:
                                                              _marketController
                                                                      .markets[
                                                                          index]
                                                                      .isProduct
                                                                  ? MarketTile(
                                                                      post:
                                                                          market,
                                                                      controller:
                                                                          _marketController,
                                                                      key: ValueKey<String>(_marketController
                                                                          .markets[
                                                                              index]
                                                                          .marketId),
                                                                    )
                                                                  : ServiceTile(
                                                                      post:
                                                                          market,
                                                                      controller:
                                                                          _marketController,
                                                                      key: ValueKey<String>(_marketController
                                                                          .markets[
                                                                              index]
                                                                          .marketId),
                                                                    ),
                                                        );
                                                      } else {
                                                        // Display a loading indicator at the end of the list
                                                        if (_marketController
                                                            .loadingMore
                                                            .value) {
                                                          return const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            child: Center(
                                                              child:
                                                                  CircularProgressIndicator(),
                                                            ),
                                                          );
                                                        } else {
                                                          return const SizedBox
                                                              .shrink();
                                                        }
                                                      }
                                                    },
                                                  ),
                                                )
                                              : DefaultTabController(
                                                  length: 4, // Number of tabs
                                                  child: Column(
                                                    children: <Widget>[
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                bottom: 10,
                                                                left: 16),
                                                        constraints:
                                                            const BoxConstraints
                                                                .expand(
                                                                height: 40),
                                                        child: TabBar(
                                                          labelStyle:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                          controller:
                                                              _marketplaceTabController,
                                                          isScrollable: true,
                                                          indicator:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50), // Creates border
                                                            color: Colors
                                                                .black87
                                                                .withAlpha(180),
                                                          ),
                                                          unselectedLabelColor:
                                                              Colors.grey,
                                                          labelColor:
                                                              Colors.white,
                                                          labelPadding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      20.0),
                                                          tabs: const <Widget>[
                                                            Tab(
                                                              icon: Icon(
                                                                Icons.dashboard,
                                                                size: 15,
                                                              ),
                                                            ),
                                                            Tab(
                                                                text:
                                                                    'Products'),
                                                            Tab(
                                                                text:
                                                                    'Services'),
                                                            Tab(
                                                                text:
                                                                    'Suppliers'),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          children: <Widget>[
                                                            Expanded(
                                                              child: TabBarView(
                                                                controller:
                                                                    _marketplaceTabController,
                                                                children: const <Widget>[
                                                                  MarketsPage(),
                                                                  ProductsPage(),
                                                                  ServicesPage(),
                                                                  SuppliersPage(),
                                                                ],
                                                              ),
                                                            ),
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
                      ),
                      const BottomBar(
                        activeIndex: 3,
                      ),
                      showFloatingButton ? const Floatingbutton() : Container(),
                    ],
                  ),
                ),
    );
  }

  Future<void> loadData() async {
    setState(() {});

    // Call the loadPosts() function from the PostsController
    // await Get.find<PostsController>().loadPosts();
    await Get.find<MarketController>().initMarket();
  }

  Future<void> refreshData() async {
    await loadData(); // Trigger data reload
  }

  Widget joinedButton() {
    return GestureDetector(
      onTap: () async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final String? userId = prefs.getString(Constants.USER_ID);

        setState(() {
          if (_marketController.isJoined.value) {
            _marketController.users
                .removeWhere((UserModel user) => user.uid == userId);
          } else {
            _marketController.users.add(_profileController.myProfile);
          }
          _marketController.isJoined.value = !_marketController.isJoined.value;
        });
        final Map<String, dynamic> marketData = <String, dynamic>{
          'industryId': 'market_place_id',
          'categoryId': Constants.MARKET_PLACE_CATEGORY_ID,
          'description': '- Sell your products and services \n - Find Supplies',
          'industry': 'Market Place',
          'photo':
              'https://businessbosses.com.ng/learningImages/marketplace.jpg',
          'active': true,
          'timestamp': DateTime.now().millisecondsSinceEpoch
        };
        _profileController.toggleInterests(Industry.toObject(marketData));
        await ApiService.post(path: 'members', body: <String, dynamic>{
          'type': 'marketplace',
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
        ),
        alignment: Alignment.center,
        child: SizedBox(
          height: 38,
          width: 75,
          child: Obx(
            () => !_marketController.isJoined.value
                ? const MCustomButton(
                    child: Text(
                      'Join',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: primaryColorLT,
                      ),
                    ),
                  )
                : const MCustomButton(
                    buttonType: ButtonType.outlinegrey,
                    child: Text(
                      'Leave',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF777777),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
