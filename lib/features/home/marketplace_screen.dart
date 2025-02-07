import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/customitem_model.dart';
import 'package:business_bosses_v2/bbpro/models/product_model.dart';
import 'package:business_bosses_v2/bbpro/models/service_model.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_product.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_service.dart';
import 'package:business_bosses_v2/bbpro/presentation/my_orders_screen.dart';
import 'package:business_bosses_v2/bbpro/widgets/button.dart';
import 'package:business_bosses_v2/bbpro/widgets/proseardwidget.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/features/donations/presentation/filtersuppliers.dart';
import 'package:business_bosses_v2/features/home/widgets/bottom_bar.dart';
import 'package:business_bosses_v2/features/home/widgets/floatingbutton.dart';

import 'package:business_bosses_v2/features/marketplace/controllers/supplier_controller.dart';
import 'package:business_bosses_v2/features/marketplace/models/market_model.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/filtermarketplaceposts.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/filtermarketproducts.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/filtermarketservices.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/supplierspage.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/marketplace_item.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/markets.dart';

import 'package:business_bosses_v2/features/marketplace/widgets/products.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/service_item.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/services.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../common/widgets/safety_model.dart';

import '../../utils/theme/theme.dart';
import '../marketplace/controllers/market_controller.dart';
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
  final MarketController _marketController = Get.find();
  final HomeController hmeController = Get.find();
  final ShopController shopController = Get.find();
  String? filterCode;
  String? filterLocation;
  String? filterCategory;
  int pageSize = 20;
  String? filteredCategory;
  bool isScrolled = true;
  final ScrollController _scrollController = ScrollController();
  bool showFloatingButton = false;
  final bool _ismarketplaceSearching = false;
  late final TabController _marketplacesearchTabController;
  late final TabController _marketplaceTabController;
  bool isfiltervisible = true;
  bool databool = true;
  bool loadingData = true;
  final SupplierController supplierController = Get.put(SupplierController());
  final TextEditingController minpricecontroller = TextEditingController();
  final TextEditingController maxpricecontroller = TextEditingController();
  final ProfileController _profileController = Get.find();
  // State to manage which filter is currently selected
  String selectedFilter = 'none'; // 'none', 'price', 'category', 'date'

  @override
  void initState() {
    super.initState();
    _marketplacesearchTabController = TabController(length: 4, vsync: this);
    _marketplaceTabController = TabController(length: 4, vsync: this);
    _marketController.error(false);
    _scrollController.addListener(() {
      double percentageScrolled =
          _scrollController.offset / _scrollController.position.maxScrollExtent;

      if (percentageScrolled >= 0.3) {
        if (mounted) {
          setState(() {
            showFloatingButton = true;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            showFloatingButton = false;
          });
        }
      }
    });

    shopController.initShop();
    supplierController.initSuppliers();
  }

  void _handleTabSelection() {
    setState(() {});
  }

  void selectedCategoryChanged(String? newValue) {
    setState(() {
      _marketController.selectedCategory = newValue;
    });
  }

  void selectedLocationChanged(String? name, String? code) {
    _marketController.changeLocation(name!);
    filterCode = code;
    sortItems();
    setState(() {});
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

    _marketController.selectedLocation = _marketController.selectedLocation ??
        _profileController.myProfile.location ??
        'Nigeria';
    sortItems();
    print(_marketController.allFilteredItems.toString());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 50),
        child: Column(
          children: <Widget>[
            AppBar(
              automaticallyImplyLeading: false,
              title: CountryListPick(
                  appBar: AppBar(
                    leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
                    ),
                    centerTitle: true,
                    title: const Text(
                      'Select Location',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  initialSelection: _marketController.selectedLocation,
                  onChanged: (CountryCode? code) async {
                    setState(() {
                      selectedLocationChanged(code!.name, code.code);
                    });
                  },
                  useSafeArea: false,
                  pickerBuilder:
                      (BuildContext context, CountryCode? countryCode) {
                    return Row(
                      children: <Widget>[
                        const Icon(
                          Icons.place,
                          size: 18,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          _marketController.selectedLocation!.length > 20
                              ? '${_marketController.selectedLocation!.substring(0, 20)}...'
                              : _marketController.selectedLocation!,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        SvgPicture.asset('assets/svgs/dropdown.svg')
                      ],
                    );
                  }),
              actions: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.only(top: 8.0, bottom: 8, right: 10),
                  child: ProCustomButton(
                    padding: 0.0,
                    icon: SvgPicture.asset('assets/svgs/startatopic.svg'),
                    color: primaryColorLT,
                    onPressed: () {
                      setState(() {});
                      if (shopController.shop == null) {
                        showSnackbar(
                          message: 'Create a Biz-Center First',
                          error: true,
                        );
                        return;
                      }
                      showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(25.0),
                            ),
                          ),
                          builder: (BuildContext context) {
                            return SizedBox(
                              height: 200,
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Expanded(
                                      child: ListView.separated(
                                        itemCount: 2,
                                        separatorBuilder:
                                            (BuildContext context, int index) =>
                                                const Divider(),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return ListTile(
                                            onTap: () {
                                              Navigator.pop(context);
                                              index == 0
                                                  ? Get.to(() =>
                                                      const CreateProductListing(
                                                        isMarketplace: true,
                                                      ))
                                                  : Get.to(() =>
                                                      const CreateServiceListing(
                                                        isMarketplace: true,
                                                      ));
                                            },
                                            minVerticalPadding: 0,
                                            contentPadding:
                                                const EdgeInsets.only(
                                              left: 10,
                                            ),
                                            leading: SvgPicture.asset(
                                              index == 0
                                                  ? 'assets/svgs/addproduct.svg'
                                                  : 'assets/svgs/addservice.svg',
                                              height: 25,
                                              color: textColor.withOpacity(1),
                                            ),
                                            title: Text(
                                              index == 0
                                                  ? 'Sell your product'
                                                  : 'Sell your service',
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                    text: 'Sell',
                  ),
                )
              ],
            ),
            Container(
              padding: const EdgeInsets.only(left: 15),
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ProSearchbar(
                      onfiltertap: () {
                        showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(25.0),
                            ),
                          ),
                          builder: (BuildContext context) {
                            return filterWidget();
                          },
                        );
                      },
                      ismarketplace: true,
                      radius: 8,
                      contentPadding: 10,
                      hasSearchIcon: true,
                      backgroundColor: backgroundColor,
                      hintText: 'Search Marketplace',
                      autofocus: false,
                      onChange: (String query) {
                        _marketController.searchQuery = query;
                        if (query.isNotEmpty) {
                          _marketController.filterItems(query);
                        } else {
                          _marketController.clearFilter();
                          _marketController.selectedCategory = null;
                          sortItems();
                        }
                        setState(() {}); // Ensure UI updates
                      },
                      onSubmit: (String query) {
                        _marketController.searchQuery = query;
                        if (query.isNotEmpty) {
                          _marketController.filterItems(query);
                          supplierController.searchSuppliers(query);
                        } else {
                          _marketController.clearFilter();
                          _marketController.selectedCategory = null;
                          supplierController.clearSupplierSearch();
                          sortItems();
                        }
                        setState(() {});
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const MyOrdersScreen());
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10.0,
                      ),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: backgroundColor,
                        child: SvgPicture.asset(
                          'assets/svgs/shoppingcart.svg',
                          height: 19,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Expanded(
            //   child: AppBar(
            //     backgroundColor: Colors.white,
            //     automaticallyImplyLeading: false,
            //     title: _ismarketplaceSearching
            //         ? SizedBox(
            //             height: 42,
            //             child: Searchbar(
            //               hintText: _marketplacesearchTabController.index == 0
            //                   ? 'Search Products'
            //                   : _marketplacesearchTabController.index == 1
            //                       ? 'Search Services'
            //                       : 'Find Suppliers for your Business',
            //               onChange: (String query) {
            //                 if (query.isEmpty) {
            //                   _marketplacesearchTabController.index == 2
            //                       ? supplierController.clearSupplierSearch()
            //                       : _marketController.clearFilter();
            //                 } else {
            //                   _marketController.filterItems(query);
            //                   supplierController.searchSuppliers(query);
            //                 }
            //                 setState(() {});
            //               },
            //               onSubmit: (String query) {
            //                 supplierController.searchSuppliers(query);
            //                 _marketController.filterItems(query);
            //                 setState(() {});
            //               },
            //             ),
            //           )
            //         : ProSearchbar(
            //             radius: 8,
            //             contentPadding: 10,
            //             hasSearchIcon: true,
            //             backgroundColor: backgroundColor,
            //             hintText: 'Search Marketplace',
            //             autofocus: false,
            //             onChange: (String query) {
            //               // _performSearch(query);
            //             },
            //             onSubmit: (String query) {},
            //           ),
            //     bottom: _ismarketplaceSearching
            //         ? TabBar(
            //             controller: _marketplacesearchTabController,
            //             labelStyle:
            //                 const TextStyle(fontWeight: FontWeight.w500),
            //             labelColor: Colors.black,
            //             indicatorColor: primaryColorLT,
            //             tabs: const <Widget>[
            //               Tab(text: 'All'),
            //               Tab(text: 'Products'),
            //               Tab(text: 'Services'),
            //               Tab(text: 'Suppliers'),
            //             ],
            //           )
            //         : const PreferredSize(
            //             preferredSize: Size.fromHeight(0.0),
            //             child: SizedBox(height: 0),
            //           ),
            //     actions: _ismarketplaceSearching
            //         ? <Widget>[
            //             IconButton(
            //               icon: const Icon(Icons.close),
            //               onPressed: () {
            //                 setState(() {
            //                   _ismarketplaceSearching =
            //                       !_ismarketplaceSearching;

            //                   _marketController.clearFilter();
            //                   supplierController.searchedSuppliers.clear();
            //                 });
            //               },
            //             ),
            //           ]
            //         : <Widget>[
            //             if (!_ismarketplaceSearching)
            //               GestureDetector(
            //                 onTap: () {
            //                   Get.to(() => const MyOrdersScreen());
            //                 },
            //                 child: Padding(
            //                   padding: const EdgeInsets.only(
            //                     right: 10.0,
            //                   ),
            //                   child: CircleAvatar(
            //                       radius: 20,
            //                       backgroundColor: backgroundColor,
            //                       child: SvgPicture.asset(
            //                         'assets/svgs/shoppingcart.svg',
            //                         height: 19,
            //                       )),
            //                 ),
            //               ),
            //             if (!_ismarketplaceSearching)
            //               GestureDetector(
            //                 onTap: () {
            //                   Get.to(() => const ChatScreen());
            //                 },
            //                 child: Padding(
            //                   padding: const EdgeInsets.only(
            //                     right: 10.0,
            //                   ),
            //                   child: CircleAvatar(
            //                       radius: 20,
            //                       backgroundColor: backgroundColor,
            //                       child: SvgPicture.asset(
            //                         'assets/svgs/prochat.svg',
            //                         height: 15,
            //                       )),
            //                 ),
            //               ),
            //             GestureDetector(
            //               onTap: () {
            //                 _ismarketplaceSearching = !_ismarketplaceSearching;
            //                 setState(() {});
            //                 _marketController.clearFilter();
            //                 supplierController.searchedSuppliers.clear();
            //               },
            //               child: Padding(
            //                 padding: const EdgeInsets.only(
            //                   right: 10.0,
            //                 ),
            //                 child: _ismarketplaceSearching
            //                     ? const Icon(Icons.close)
            //                     : CircleAvatar(
            //                         radius: 20,
            //                         backgroundColor: backgroundColor,
            //                         child: SvgPicture.asset(
            //                           'assets/svgs/homesearch.svg',
            //                           height: 20,
            //                           color: textColor,
            //                         )),
            //               ),
            //             ),
            //           ],
            //   ),
            // ),
          ],
        ),
      ),
      body: _marketController.isLoading
          ? const CircularProgressIndicator()
          : _ismarketplaceSearching
              ? TabBarView(
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
                              return SafetyModel(
                                isLoading: false,
                                title: 'Error While Loading Data',
                                subTitle: 'Try Reloading Again',
                                icon: const Icon(
                                  Icons.warning,
                                  size: 60,
                                ),
                                clickableText: 'Reload',
                                onTap: () {
                                  setState(() {
                                    _marketController.initMarket();
                                  });
                                },
                              );
                            } else {
                              return RefreshIndicator(
                                onRefresh: refreshData,
                                child: DefaultTabController(
                                  length: 4, // Number of tabs
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        constraints:
                                            const BoxConstraints.expand(
                                                height: 45),
                                        child: TabBar(
                                          labelStyle: const TextStyle(
                                              fontWeight: FontWeight.w400),
                                          controller: _marketplaceTabController,
                                          isScrollable: false,
                                          labelPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 20.0),
                                          tabs: const <Widget>[
                                            Tab(
                                              icon: Icon(
                                                Icons.dashboard,
                                                size: 15,
                                              ),
                                            ),
                                            Tab(
                                              child: FittedBox(
                                                child: Text(
                                                  'Products',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 14),
                                                ),
                                              ),
                                            ),
                                            Tab(
                                              child: FittedBox(
                                                child: Text(
                                                  'Services',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 14),
                                                ),
                                              ),
                                            ),
                                            Tab(
                                              child: FittedBox(
                                                child: Text(
                                                  'Suppliers',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 14),
                                                ),
                                              ),
                                            ),
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

  Widget filterWidget() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Filter by Category',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView(
                    children: <String>[
                      'Home, Garden & Outdoors',
                      'Fashion & Beauty',
                      'Sports & Entertainment',
                      'Books & Education',
                      'Jewellery & Timepieces',
                      'Security, Safety & Equipment',
                      'Video Games & Electronics',
                      'Agriculture, Food, Beverage',
                      'Construction & Real Estate',
                      'Vehicle & Transportation',
                      'Business Services & Events',
                      'Other',
                    ].map((String category) {
                      return ListTile(
                        title: Text(category),
                        onTap: () {
                          setState(() {
                            _marketController.selectedCategory = category;
                          });
                        },
                        trailing: _marketController.selectedCategory == category
                            ? const Icon(Icons.check, color: Colors.blue)
                            : null,
                      );
                    }).toList(),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _marketController.selectedCategory = null;
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
                      },
                      child: const Text('Apply Filter'),
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

  void sortItems() {
    String? myLocation = _marketController.selectedLocation?.toLowerCase();

    // Define a reusable sorting function
    int compareItems(Object a, Object b) {
      DateTime aDate = (a is Product)
          ? a.createdAt
          : (a is Service)
              ? a.createdAt
              : (a as Customitem).createdAt;
      DateTime bDate = (b is Product)
          ? b.createdAt
          : (b is Service)
              ? b.createdAt
              : (b as Customitem).createdAt;

      String? aLocation = (a is Product)
          ? a.location
          : (a is Service)
              ? a.location
              : (a as Customitem).shop?.location;
      String? bLocation = (b is Product)
          ? b.location
          : (b is Service)
              ? b.location
              : (b as Customitem).shop?.location;

      String aLoc = aLocation?.toLowerCase() ?? '';
      String bLoc = bLocation?.toLowerCase() ?? '';

      // Step 1: Prioritize items matching the selected location
      bool aIsMyLocation = aLoc == myLocation;
      bool bIsMyLocation = bLoc == myLocation;

      if (aIsMyLocation && !bIsMyLocation) return -1; // a goes up
      if (!aIsMyLocation && bIsMyLocation) return 1; // b goes up

      // Step 2: Sort by date (newest first)
      return bDate.compareTo(aDate);
    }

    if (_marketController.isfiltered.value) {
      // Sort filtered lists
      _marketController.filteredProducts.sort(compareItems);
      _marketController.filteredServices.sort(compareItems);
      _marketController.allFilteredItems.sort(compareItems);
    } else {
      // Sort all items when no filter is applied
      _marketController.proItems.sort(compareItems);
      _marketController.proItemsWithImages.sort(compareItems);
      _marketController.proProducts.sort(compareItems);
      _marketController.proServices.sort(compareItems);
    }

    _marketController.update(); // Refresh UI
    setState(() {}); // Ensure UI updates
  }
}
