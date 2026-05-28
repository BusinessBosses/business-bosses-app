import 'dart:async';

import 'package:business_bosses_v2/bbpro/models/product_model.dart';
import 'package:business_bosses_v2/bbpro/models/service_model.dart';
import 'package:business_bosses_v2/bbpro/widgets/inventorycard.dart';
import 'package:business_bosses_v2/bbpro/widgets/servicecard.dart';
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/home/widgets/buyer_request_item.dart';
import 'package:business_bosses_v2/features/search/controller/search_controller.dart';
import 'package:business_bosses_v2/features/search/widgets/people_tab.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/market_controller.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/requests_controller.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/supplier_controller.dart';
import 'package:business_bosses_v2/features/marketplace/models/buyer_request_model.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import '../../impact/presentation/leaderboard_screen.dart';

class MarketplaceSearchScreen extends StatefulWidget {
  const MarketplaceSearchScreen({super.key});

  @override
  State<MarketplaceSearchScreen> createState() =>
      _MarketplaceSearchScreenState();
}

class _MarketplaceSearchScreenState extends State<MarketplaceSearchScreen> {
  final MarketController _marketController = Get.find();
  final ProfileController _profileController = Get.find();
  final SupplierController _supplierController = Get.find();
  final CompleteSearchController _peopleSearchController =
      Get.put(CompleteSearchController());
  final BuyerRequestController _buyerRequestController =
      Get.put(BuyerRequestController());
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  Timer? _debounce;

  int _selectedTab = 0;
  final List<String> _tabs = <String>[
    'People',
    'Products',
    'Services',
    'I Need',
    'Ranking Business'
  ];

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
    'Transport & Logistics',
    'Travel & Hospitality',
    'Business Services & Consulting',
  ];

  @override
  void initState() {
    super.initState();
    // Pre-fill search field if there's an existing query
    _searchController.text = _marketController.searchQuery;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 450), () {
      if (query.isNotEmpty) {
        if (_selectedTab == 0) {
          _peopleSearchController.query.value = query;
          _peopleSearchController.search();
        } else if (_selectedTab == 1 || _selectedTab == 2) {
          _marketController.searchMarketplace(query);
        } else if (_selectedTab == 3) {
          _buyerRequestController.initBuyerRequests(
              location: _marketController.selectedLocation, query: query);
        }
        _supplierController.searchSuppliers(query);
      } else {
        _marketController.clearFilter();
        _peopleSearchController.clearUserSearch();
        _buyerRequestController.filterBuyerRequests('');
      }
      setState(() {});
    });
  }

  // void _showFilterSheet() {
  //   showModalBottomSheet(
  //     context: context,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
  //     ),
  //     builder: (_) => StatefulBuilder(
  //       builder: (BuildContext context, StateSetter setState) {
  //         return SizedBox(
  //           height: MediaQuery.of(context).size.height * 0.8,
  //           child: Padding(
  //             padding: const EdgeInsets.all(15.0),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: <Widget>[
  //                 const Padding(
  //                   padding: EdgeInsets.only(left: 10.0, top: 5),
  //                   child: Text(
  //                     'Filter results',
  //                     style: TextStyle(
  //                       fontSize: 18,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                 ),
  //                 const SizedBox(height: 20),
  //                 Padding(
  //                   padding: const EdgeInsets.symmetric(horizontal: 10.0),
  //                   child: CountryListPick(
  //                     appBar: AppBar(
  //                       leading: IconButton(
  //                         onPressed: () {
  //                           Navigator.pop(context);
  //                         },
  //                         icon: const Icon(Icons.arrow_back),
  //                       ),
  //                       centerTitle: true,
  //                       title: const Text(
  //                         'Select Location',
  //                         textAlign: TextAlign.center,
  //                         style: TextStyle(
  //                           fontSize: 16,
  //                         ),
  //                       ),
  //                     ),
  //                     initialSelection: _locationController.text.isNotEmpty
  //                         ? CountryCodes.nameToCode[_locationController.text] ??
  //                             '+234'
  //                         : (_profileController.myProfile.location != null
  //                             ? CountryCodes.nameToCode[
  //                                     _profileController.myProfile.location] ??
  //                                 '+234'
  //                             : '+234'),
  //                     pickerBuilder:
  //                         (BuildContext context, CountryCode? countryCode) {
  //                       return Container(
  //                         padding: const EdgeInsets.symmetric(
  //                             horizontal: 10, vertical: 12),
  //                         decoration: BoxDecoration(
  //                           border: Border.all(color: Colors.grey.shade400),
  //                           borderRadius: BorderRadius.circular(10),
  //                         ),
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: <Widget>[
  //                             Text(
  //                               countryCode?.name ??
  //                                   (_locationController.text.isNotEmpty
  //                                       ? _locationController.text
  //                                       : (_profileController
  //                                               .myProfile.location ??
  //                                           'Select Location')),
  //                               style: const TextStyle(fontSize: 16),
  //                             ),
  //                             const Icon(Icons.arrow_drop_down),
  //                           ],
  //                         ),
  //                       );
  //                     },
  //                     onChanged: (CountryCode? code) {
  //                       if (code != null && code.name != null) {
  //                         setState(() {
  //                           _locationController.text = code.name!;
  //                         });
  //                         _marketController.changeLocation(code.name!);
  //                         _supplierController.filterLocation.value = code.name!;
  //                         _buyerRequestController.filterLocation.value =
  //                             code.name!;
  //                       }
  //                     },
  //                     useSafeArea: false,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 10),
  //                 Expanded(
  //                   child: ListView(
  //                     children: categories.map((String category) {
  //                       return ListTile(
  //                         title: Text(category),
  //                         onTap: () {
  //                           setState(() {
  //                             _marketController.selectedCategory = category;
  //                             _supplierController.filterCategory.value =
  //                                 category;
  //                             _buyerRequestController.filterCategory.value =
  //                                 category;
  //                           });
  //                         },
  //                         trailing:
  //                             _marketController.selectedCategory == category
  //                                 ? const Icon(
  //                                     Icons.check,
  //                                     size: 20,
  //                                     color: primaryColorLT,
  //                                   )
  //                                 : null,
  //                       );
  //                     }).toList(),
  //                   ),
  //                 ),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.end,
  //                   children: <Widget>[
  //                     OutlinedButton(
  //                       onPressed: () {
  //                         // Allow internal reset
  //                         setState(() {
  //                           _marketController.selectedCategory = null;
  //                           _marketController.selectedLocation = null;
  //                           _supplierController.filterCategory.value = '';
  //                           _supplierController.filterLocation.value = '';
  //                           _buyerRequestController.filterCategory.value = '';
  //                           _buyerRequestController.filterLocation.value = '';
  //                           _locationController.clear();
  //                         });
  //                         // Apply clear globally
  //                         _marketController.clearFilter();
  //                         _marketController.sortItems();
  //                         _searchController.clear();
  //                         _buyerRequestController.filterBuyerRequests('');
  //                         _supplierController.searchSuppliers('');
  //                         Navigator.pop(context);
  //                       },
  //                       child: const Text('Reset'),
  //                     ),
  //                     const SizedBox(width: 10),
  //                     ElevatedButton(
  //                       onPressed: () {
  //                         // Apply filter based on current tab if needed or just general
  //                         _marketController.filterItems(_searchController.text);
  //                         _supplierController
  //                             .searchSuppliers(_searchController.text);
  //                         _buyerRequestController
  //                             .filterBuyerRequests(_searchController.text);
  //                         Navigator.pop(context);
  //                       },
  //                       child: const Text(
  //                         'Apply Filter',
  //                         style: TextStyle(color: Colors.white),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   ).then((_) {
  //     setState(() {}); // Rebuild screen to reflect filter changes
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        titleSpacing: 0,
        title: Container(
          height: 44,
          margin: const EdgeInsets.only(right: 16),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  onChanged: _onSearchChanged,
                  decoration: const InputDecoration(
                    hintText: 'Search...',
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              if (_searchController.text.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    _searchController.clear();
                    _marketController.filterItems('');
                    _peopleSearchController.clearUserSearch();
                    _buyerRequestController.filterBuyerRequests('');
                  },
                  child:
                      Icon(Icons.close, color: Colors.grey.shade600, size: 20),
                ),
            ],
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          // Tabs
          Container(
            height: 50,
            color: Colors.white,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _tabs.length,
              itemBuilder: (BuildContext context, int index) {
                final bool isSelected = _selectedTab == index;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: FilterChip(
                    label: Text(
                      _tabs[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (bool value) {
                      setState(() {
                        _selectedTab = index;
                        final String query = _searchController.text;
                        if (query.isNotEmpty) {
                          if (_selectedTab == 0) {
                            _peopleSearchController.search();
                          } else if (_selectedTab == 3) {
                            _buyerRequestController.initBuyerRequests(
                              location: _marketController.selectedLocation,
                              query: query,
                            );
                          } else if (_selectedTab == 1 || _selectedTab == 2) {
                            _marketController.searchMarketplace(query);
                          }
                        }
                      });
                    },
                    backgroundColor: Colors.grey.shade100,
                    selectedColor: primaryColorLT,
                    checkmarkColor: Colors.white,
                    side: BorderSide.none,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          // Content
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    // 0: People, 1: Products, 2: Services, 3: I Need, 4: Ranking Business
    if (_selectedTab == 0) {
      return PeopleTab(
        controller: _peopleSearchController,
        filterTitle: '',
      );
    } else if (_selectedTab == 3) {
      // I Need (Buyer Requests)
      return Obx(() {
        final List<BuyerRequestModel> requests =
            _buyerRequestController.buyerRequests;
        if (_buyerRequestController.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (requests.isEmpty) {
          if (_searchController.text.isEmpty) {
            return const Center(
              child: Text('Enter a search term to find buyer requests'),
            );
          }
          return const SafetyModel(
              isLoading: false, title: 'No Buyer Requests Found');
        }
        return MasonryGridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          itemCount: requests.length,
          itemBuilder: (BuildContext context, int index) {
            final BuyerRequestModel request = requests[index];
            return BuyerRequestItem(
              request: request,
              onTap: () {},
            );
          },
        );
      });
    } else if (_selectedTab == 4) {
      // Ranking Business (Suppliers)
      return LeaderboardScreen(isMarketplace: true);
    } else {
      // Products, or Services
      return GetX<MarketController>(
        builder: (MarketController controller) {
          if (controller.searchLoading.value || controller.loading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          List<Object> items = controller.activeMarketItems;

          // Tabs filter LOCAL only
          if (_selectedTab == 1) {
            items = items.whereType<Product>().toList();
          } else if (_selectedTab == 2) {
            items = items.whereType<Service>().toList();
          }

          if (items.isEmpty && controller.searchQuery.isNotEmpty) {
            return const SafetyModel(
              isLoading: false,
              title: 'No Items Found',
            );
          }

          if (items.isEmpty && controller.searchQuery.isEmpty) {
            return const Center(
              child: Text('Enter a search term to find products or services'),
            );
          }

          return MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              final Object item = items[index];

              if (item is Product) {
                return InventoryCard(
                  marketplace: true,
                  product: item,
                  shop: item.shop!,
                  myShop: item.user!.uid == _profileController.myProfile.uid,
                );
              }

              if (item is Service) {
                return ServiceCard(
                  marketplace: true,
                  service: item,
                  shop: item.shop!,
                  myShop: item.user!.uid == _profileController.myProfile.uid,
                );
              }

              return const SizedBox.shrink();
            },
          );
        },
      );
    }
  }
}
