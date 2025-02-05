import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_product.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_service.dart';
import 'package:business_bosses_v2/bbpro/presentation/my_orders_screen.dart';
import 'package:business_bosses_v2/bbpro/widgets/button.dart';
import 'package:business_bosses_v2/bbpro/widgets/edit_text.dart';
import 'package:business_bosses_v2/bbpro/widgets/proseardwidget.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/features/chat/chat_screen.dart';
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
import 'package:business_bosses_v2/features/search/widgets/search_bar.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  String? _selectedCategory;
  String? _selectedLocation;
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
                  initialSelection: _selectedLocation,
                  onChanged: (CountryCode? code) async {
                    setState(() {
                      _selectedLocation = code!.name;
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
                          shopController.shop!.location.length > 20
                              ? '${shopController.shop!.location.substring(0, 20)}...'
                              : shopController.shop!.location,
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 16),
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
                                                      const CreateProductListing())
                                                  : Get.to(() =>
                                                      const CreateServiceListing());
                                            },
                                            minVerticalPadding: 0,
                                            contentPadding:
                                                const EdgeInsets.only(
                                              left: 10,
                                            ),
                                            leading: SvgPicture.asset(
                                              index == 0
                                                  ? 'assets/svgs/sellicon.svg'
                                                  : 'assets/svgs/sellicon.svg',
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
                            // State to manage which filter is currently selected
                            String selectedFilter =
                                'none'; // 'none', 'price', 'category', 'date'
                            String? selectedPriceRange;
                            String? selectedCategory;
                            String? selectedDateRange;

                            return StatefulBuilder(
                              builder:
                                  (BuildContext context, StateSetter setState) {
                                return SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.8,
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        if (selectedFilter ==
                                            'none') ...<Widget>[
                                          const Text(
                                            'Filters',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 10),
                                          ListTile(
                                            trailing:
                                                const Icon(Icons.chevron_right),
                                            horizontalTitleGap: 0,
                                            contentPadding: EdgeInsets.zero,
                                            leading:
                                                const Icon(Icons.attach_money),
                                            title:
                                                const Text('Filter by Price'),
                                            subtitle: Text(selectedPriceRange ??
                                                'No price range selected'),
                                            onTap: () {
                                              setState(() {
                                                selectedFilter =
                                                    'price'; // Show price filter options
                                              });
                                            },
                                          ),
                                          ListTile(
                                            trailing:
                                                const Icon(Icons.chevron_right),
                                            horizontalTitleGap: 0,
                                            contentPadding: EdgeInsets.zero,
                                            leading: const Icon(Icons.category),
                                            title: const Text(
                                                'Filter by Category'),
                                            subtitle: Text(selectedCategory ??
                                                'No category selected'),
                                            onTap: () {
                                              setState(() {
                                                selectedFilter =
                                                    'category'; // Show category filter options
                                              });
                                            },
                                          ),
                                          ListTile(
                                            trailing:
                                                const Icon(Icons.chevron_right),
                                            horizontalTitleGap: 0,
                                            contentPadding: EdgeInsets.zero,
                                            leading:
                                                const Icon(Icons.date_range),
                                            title: const Text('Filter by Date'),
                                            subtitle: Text(selectedDateRange ??
                                                'No date range selected'),
                                            onTap: () {
                                              setState(() {
                                                selectedFilter =
                                                    'date'; // Show date filter options
                                              });
                                            },
                                          ),
                                        ],

                                        // Price Filter Options
                                        if (selectedFilter ==
                                            'price') ...<Widget>[
                                          const Text(
                                            'Set Price Range',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          CustomEditText(
                                            padding: 0,
                                            iscurrencyfield: true,
                                            caption: 'Minimum Price',
                                            hintText: '0.00',
                                            controller: minpricecontroller,
                                          ),
                                          const SizedBox(height: 10),
                                          CustomEditText(
                                            padding: 0,
                                            iscurrencyfield: true,
                                            caption: 'Maximum Price',
                                            hintText: '0.00',
                                            controller: maxpricecontroller,
                                          ),
                                          const SizedBox(height: 20),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    selectedFilter =
                                                        'none'; // Go back to main filters
                                                  });
                                                },
                                                child: const Text('Back'),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  // Handle price filter logic here
                                                  setState(() {
                                                    selectedPriceRange =
                                                        'Selected Price Range';
                                                    selectedFilter = 'none';
                                                  });
                                                },
                                                child: const Text('Apply'),
                                              ),
                                            ],
                                          ),
                                        ],

                                        // Category Filter Options
                                        if (selectedFilter ==
                                            'category') ...<Widget>[
                                          const Text(
                                            'Select Category',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 10),
                                          Expanded(
                                            child: ListView(
                                              children: <String>[
                                                'Electronics',
                                                'Clothing',
                                                'Home & Kitchen',
                                                'Books',
                                                'Sports',
                                                'Others',
                                              ].map((String category) {
                                                return ListTile(
                                                  title: Text(category),
                                                  onTap: () {
                                                    setState(() {
                                                      selectedCategory =
                                                          category;
                                                      selectedFilter = 'none';
                                                    });
                                                  },
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                selectedFilter =
                                                    'none'; // Go back to main filters
                                              });
                                            },
                                            child: const Text('Back'),
                                          ),
                                        ],

                                        // Date Filter Options
                                        if (selectedFilter ==
                                            'date') ...<Widget>[
                                          const Text(
                                            'Select Date Range',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 10),
                                          Expanded(
                                            child: ListView(
                                              children: <String>[
                                                'Any',
                                                'Last 24 Hours',
                                                'Last 7 Days',
                                                'Last 30 Days',
                                              ].map((String dateOption) {
                                                return ListTile(
                                                  title: Text(dateOption),
                                                  onTap: () {
                                                    setState(() {
                                                      selectedDateRange =
                                                          dateOption;
                                                      selectedFilter = 'none';
                                                    });
                                                  },
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                selectedFilter =
                                                    'none'; // Go back to main filters
                                              });
                                            },
                                            child: const Text('Back'),
                                          ),
                                        ],
                                        const SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            ElevatedButton(
                                              style: ButtonStyle(
                                                  textStyle:
                                                      MaterialStateProperty.all<
                                                              TextStyle>(
                                                          const TextStyle(
                                                              color: Colors
                                                                  .black)),
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          backgroundColor)),
                                              onPressed: () {
                                                setState(() {
                                                  selectedPriceRange = null;
                                                  selectedCategory = null;
                                                  selectedDateRange = null;
                                                });
                                              },
                                              child: const Text(
                                                'Reset',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                // Apply the filters
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
                        // _performSearch(query);
                      },
                      onSubmit: (String query) {},
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
                          )),
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
                              return _marketController.searchResult.isEmpty &&
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
                                            _marketController.updateFiltered();
                                            _marketController.initMarket();
                                          },
                                        );
                                      },
                                    )
                                  : RefreshIndicator(
                                      onRefresh: refreshData,
                                      child: _marketController.isfiltered.value
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
                                                      notification.dragDetails!
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
                                                            .markets.length +
                                                        1,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  if (index <
                                                      (_marketController
                                                              .isfiltered.value
                                                          ? _marketController
                                                              .searchResult
                                                              .length
                                                          : _marketController
                                                              .markets
                                                              .length)) {
                                                    final MarketModel market =
                                                        _marketController
                                                                .isfiltered
                                                                .value
                                                            ? _marketController
                                                                    .searchResult[
                                                                index]
                                                            : _marketController
                                                                .markets[index];
                                                    return VisibilityDetector(
                                                      key:
                                                          Key(index.toString()),
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
                                                      child: _marketController
                                                              .markets[index]
                                                              .isProduct
                                                          ? MarketTile(
                                                              post: market,
                                                              controller:
                                                                  _marketController,
                                                              key: ValueKey<
                                                                      String>(
                                                                  _marketController
                                                                      .markets[
                                                                          index]
                                                                      .marketId),
                                                            )
                                                          : ServiceTile(
                                                              post: market,
                                                              controller:
                                                                  _marketController,
                                                              key: ValueKey<
                                                                      String>(
                                                                  _marketController
                                                                      .markets[
                                                                          index]
                                                                      .marketId),
                                                            ),
                                                    );
                                                  } else {
                                                    // Display a loading indicator at the end of the list
                                                    if (_marketController
                                                        .loadingMore.value) {
                                                      return const Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
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
                                                    constraints:
                                                        const BoxConstraints
                                                            .expand(height: 45),
                                                    child: TabBar(
                                                      labelStyle:
                                                          const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                      controller:
                                                          _marketplaceTabController,
                                                      isScrollable: false,
                                                      labelPadding:
                                                          const EdgeInsets
                                                              .symmetric(
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
                                                                      FontWeight
                                                                          .w700,
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
                                                                      FontWeight
                                                                          .w700,
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
                                                                      FontWeight
                                                                          .w700,
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
}
