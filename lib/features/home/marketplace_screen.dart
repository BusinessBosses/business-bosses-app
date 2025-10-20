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
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/features/chat/chat_screen.dart';
import 'package:business_bosses_v2/features/donations/presentation/filtersuppliers.dart';
import 'package:business_bosses_v2/features/home/widgets/bottom_bar.dart';
import 'package:business_bosses_v2/features/home/widgets/buyerrequestsform.dart';
import 'package:business_bosses_v2/features/home/widgets/buyerrequestsscreen.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/supplier_controller.dart';
import 'package:business_bosses_v2/features/marketplace/models/suppliers_model.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/add_supplier.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/filtermarketplaceposts.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/filtermarketproducts.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/filtermarketservices.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/supplierspage.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/markets.dart';
import 'package:business_bosses_v2/features/matching_feature/presentation/expanded_matches_screen.dart';
import 'package:business_bosses_v2/features/premium/proscreen.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/features/profile/presentation/my_profile_screen.dart';
import 'package:business_bosses_v2/features/search/widgets/search_bar.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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
  final List<String> categories = <String>[
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
  final ScrollController _scrollController = ScrollController();
  bool showFloatingButton = false;
  bool _ismarketplaceSearching = false;
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
  bool hasOldData = false;

  @override
  void initState() {
    super.initState();
    _marketplacesearchTabController = TabController(length: 4, vsync: this);
    _marketplaceTabController = TabController(length: 4, vsync: this);

    // _marketplaceTabController.addListener(() {
    //   if (_marketplaceTabController.index == 2) {
    //     setState(() {
    //       databool = false;
    //     });
    //   }
    // });

    _marketplaceTabController.addListener(() {
      if (!_marketplaceTabController.indexIsChanging) {
        setState(() {});
      }
    });

    _marketplacesearchTabController.addListener(_handleTabSelection);
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
    if (shopController.shop == null) {
      shopController.initShop();
    }
    if (supplierController.suppliers.isEmpty) {
      supplierController.initSuppliers();
    }
    _marketController.checkOldMarketplaceData().then((bool value) {
      if (value) {
        if (mounted) {
          setState(() {
            hasOldData = true;
          });
        }
      }
    });
  }

  Future<void> _checkMigrationReminder() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String uid = _profileController.myProfile.uid;
    final int? remindTimestamp = prefs.getInt('migration_remind_$uid');
    if (remindTimestamp != null) {
      final DateTime remindDate =
          DateTime.fromMillisecondsSinceEpoch(remindTimestamp);
      // If within 30 days, do not show the migration dialog.
      if (DateTime.now().difference(remindDate) < const Duration(days: 30)) {
        return;
      }
    }
    // Otherwise, show the migration dialog.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showMigrationDialog();
    });
  }

  void _showMigrationDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        title: const Text('Migrate Old Marketplace Data'),
        content:
            const Text('Would you like to migrate your old marketplace data?'),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              // Save the current timestamp for this UID so the dialog won’t show for 30 days
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              final String uid = _profileController.myProfile.uid;
              final int now = DateTime.now().millisecondsSinceEpoch;
              await prefs.setInt('migration_remind_$uid', now);
              Navigator.pop(Get.context!); // dismiss migration dialog
            },
            child: const Text('Remind Me Later'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context); // close migration dialog
              // Show loader dialog
              Get.dialog(
                const AlertDialog(
                  content: Row(
                    children: <Widget>[
                      CircularProgressIndicator(),
                      SizedBox(width: 20),
                      Text('Migrating data...'),
                    ],
                  ),
                ),
                barrierDismissible: false,
              );
              // Perform migration
              bool response =
                  await _marketController.migrateOldMarketplaceData();
              if (response) {
                showSnackbar(message: 'Migration Successful!');
              } else {
                showSnackbar(
                  message: 'Error Migrating Data',
                  error: true,
                );
              }
              // Dismiss the loader dialog
              if (Get.isDialogOpen ?? false) {
                Navigator.pop(Get.context!);
              }
            },
            child: const Text('Migrate'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void _handleTabSelection() {
    setState(() {});
  }

  void selectedCategoryChanged(String? newValue) {
    setState(() {
      _marketController.selectedCategory = newValue;
      supplierController.filterCategory.value = newValue!;
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
    _marketController.selectedLocation = _marketController.selectedLocation ??
        _profileController.myProfile.location;
    sortItems();
    // Show migration dialog after the first frame is rendered.
    // Inside your initState post-fra me callback:
    if (hasOldData) {
      _checkMigrationReminder();
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 50),
        child: Column(
          children: <Widget>[
            if (!_ismarketplaceSearching) ...<Widget>{
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
                    initialSelection:
                        _marketController.selectedLocation ?? 'United Kingdom',
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
                            _marketController.selectedLocation != null
                                ? _marketController.selectedLocation!.length >
                                        20
                                    ? '${_marketController.selectedLocation!.substring(0, 20)}...'
                                    : _marketController.selectedLocation ?? ''
                                : '',
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
                          height: 22,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 8.0,
                      bottom: 8,
                      right: 15,
                    ),
                    child: ProCustomButton(
                      padding: 0.0,
                      icon: SvgPicture.asset('assets/svgs/startatopic.svg'),
                      color: primaryColorLT,
                      onPressed: () {
                        setState(() {});
                        if (!_profileController.myProfile.hasShop &&
                            _marketplaceTabController.index < 4) {
                          Get.to(() => const MyProfileScreen(
                                currentIndex: 1,
                              ));
                          return;
                        }
                        _marketplaceTabController.index == 4
                            ? launchUrl(Uri.parse(
                                'https://businessbosses.co.uk/landingpageforpartners'))
                            : _marketplaceTabController.index == 3
                                ? supplierController.allSuppliers.any(
                                        (SuppliersModel supplier) =>
                                            supplier.name ==
                                            shopController.shop?.name)
                                    ? Get.to(() => const AddSupplierScreen())
                                    : showModalBottomSheet(
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
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Expanded(
                                                    child: ListView.separated(
                                                      itemCount: 2,
                                                      separatorBuilder:
                                                          (BuildContext context,
                                                                  int index) =>
                                                              const Divider(),
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return ListTile(
                                                          horizontalTitleGap: 0,
                                                          onTap: () async {
                                                            Navigator.pop(
                                                                context);
                                                            if (index == 0) {
                                                              if (!_profileController
                                                                  .myProfile
                                                                  .hasShop) {
                                                                Get.bottomSheet(
                                                                  isScrollControlled:
                                                                      true,
                                                                  shape:
                                                                      const RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .only(
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              20.0),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              20.0),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height:
                                                                        Get.height *
                                                                            0.9,
                                                                    child:
                                                                        const Center(
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: <Widget>[
                                                                          Padding(
                                                                              padding: EdgeInsets.only(left: 0.0, top: 0, bottom: 10),
                                                                              child: ProSubscribeSection(
                                                                                isGrow: true,
                                                                              )),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                );
                                                                return;
                                                              }
                                                              // Show loader dialog similar to the migration loader
                                                              Get.dialog(
                                                                const AlertDialog(
                                                                  content: Row(
                                                                    children: <Widget>[
                                                                      CircularProgressIndicator(),
                                                                      SizedBox(
                                                                          width:
                                                                              20),
                                                                      Text(
                                                                          'Adding Biz-Center to Supplier...'),
                                                                    ],
                                                                  ),
                                                                ),
                                                                barrierDismissible:
                                                                    false,
                                                              );

                                                              // Execute your async logic (replace with your actual function)
                                                              final dynamic
                                                                  data =
                                                                  <String,
                                                                      Object?>{
                                                                'category':
                                                                    shopController
                                                                        .shop!
                                                                        .category,
                                                                'location':
                                                                    shopController
                                                                        .shop!
                                                                        .location,
                                                                'description':
                                                                    shopController
                                                                        .shop!
                                                                        .description,
                                                                'userId':
                                                                    _profileController
                                                                        .myProfile
                                                                        .uid,
                                                                'name':
                                                                    shopController
                                                                        .shop!
                                                                        .name,
                                                                'email':
                                                                    shopController
                                                                        .shop!
                                                                        .email,
                                                                'phone':
                                                                    shopController
                                                                        .shop!
                                                                        .phone,
                                                                'url':
                                                                    shopController
                                                                        .shop!
                                                                        .url,
                                                                'images':
                                                                    <String?>[
                                                                  shopController
                                                                      .shop!
                                                                      .image
                                                                ],
                                                                'isBiz': true,
                                                                'shopId':
                                                                    shopController
                                                                        .shop!
                                                                        .id,
                                                              };
                                                              ApiResponseModel
                                                                  response =
                                                                  await supplierController
                                                                      .addSupplier(
                                                                          data);
                                                              Get.back();
                                                              // Show a snackbar or perform additional actions based on success/failure
                                                              if (response
                                                                  .success) {
                                                                await Get
                                                                    .dialog(
                                                                  AlertDialog(
                                                                    title: const Text(
                                                                        'Supplier Added Succesfully!'),
                                                                    content:
                                                                        const Text(
                                                                            'It will show in marketplace when the admin approves it.'),
                                                                    actions: <Widget>[
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Get.back(); // Use Get.back() instead of Navigator.pop(context)
                                                                        },
                                                                        child: const Text(
                                                                            'Close'),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              } else {
                                                                showSnackbar(
                                                                    message:
                                                                        'Error adding Biz-Center to supplier.',
                                                                    error:
                                                                        true);
                                                              }
                                                            } else {
                                                              Get.to(() =>
                                                                  const AddSupplierScreen());
                                                            }
                                                          },
                                                          minVerticalPadding: 0,
                                                          contentPadding:
                                                              const EdgeInsets
                                                                  .only(
                                                            left: 10,
                                                          ),
                                                          leading:
                                                              SvgPicture.asset(
                                                            index == 0
                                                                ? 'assets/svgs/addclient.svg'
                                                                : 'assets/svgs/addclient.svg',
                                                            height: 25,
                                                            colorFilter:
                                                                ColorFilter.mode(
                                                                    textColor.withValues(
                                                                        alpha:
                                                                            1),
                                                                    BlendMode
                                                                        .srcIn),
                                                          ),
                                                          title: Text(
                                                            index == 0
                                                                ? 'Add My Biz-Center To Supplier List'
                                                                : 'Add a New Supplier',
                                                            style: const TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                : _marketplaceTabController.index == 1
                                    ? Get.to(BuyerRequests(
                                        onSubmit: (BuyerRequestsData p1) {},
                                      ))
                                    : _marketplaceTabController.index == 2
                                        ? Get.to(
                                            () => const CreateServiceListing(
                                                  isMarketplace: true,
                                                ))
                                        : showModalBottomSheet(
                                            context: context,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                top: Radius.circular(25.0),
                                              ),
                                            ),
                                            builder: (BuildContext context) {
                                              return SizedBox(
                                                height: 200,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      15.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      Expanded(
                                                        child:
                                                            ListView.separated(
                                                          itemCount: 2,
                                                          separatorBuilder:
                                                              (BuildContext
                                                                          context,
                                                                      int index) =>
                                                                  const Divider(),
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index) {
                                                            return ListTile(
                                                              onTap: () {
                                                                Navigator.pop(
                                                                    context);
                                                                index == 0
                                                                    ? Get.to(() =>
                                                                        const CreateProductListing(
                                                                          isMarketplace:
                                                                              true,
                                                                        ))
                                                                    : Get.to(() =>
                                                                        const CreateServiceListing(
                                                                          isMarketplace:
                                                                              true,
                                                                        ));
                                                              },
                                                              minVerticalPadding:
                                                                  0,
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                left: 10,
                                                              ),
                                                              leading:
                                                                  SvgPicture
                                                                      .asset(
                                                                index == 0
                                                                    ? 'assets/svgs/addproduct.svg'
                                                                    : 'assets/svgs/addservice.svg',
                                                                height: 25,
                                                                colorFilter: ColorFilter.mode(
                                                                    textColor.withValues(
                                                                        alpha:
                                                                            1),
                                                                    BlendMode
                                                                        .srcIn),
                                                              ),
                                                              title: Text(
                                                                index == 0
                                                                    ? 'Sell your product'
                                                                    : 'Sell your service',
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
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
                      text: _marketplaceTabController.index == 2
                          ? 'Add'
                          : _marketplaceTabController.index == 1
                              ? 'Create request'
                              : 'Sell',
                    ),
                  )
                ],
              ),
              Container(
                padding: const EdgeInsets.only(left: 15, right: 15),
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: ProSearchbar(
                        onTap: () {
                          _ismarketplaceSearching = !_ismarketplaceSearching;
                          setState(() {});
                        },
                        onfiltertap: () {
                          setState(() {
                            _ismarketplaceSearching = true;
                          });
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
                        radius: 10,
                        contentPadding: 10,
                        hasSearchIcon: true,
                        backgroundColor: backgroundColor,
                        hintText: 'Search Marketplace',
                        autofocus: false,
                      ),
                    ),
                  ],
                ),
              ),
            },
            Expanded(
              child: AppBar(
                backgroundColor: Colors.white,
                automaticallyImplyLeading: false,
                title: _ismarketplaceSearching
                    ? SizedBox(
                        height: 42,
                        child: Searchbar(
                          hintText: _marketplacesearchTabController.index == 0
                              ? 'Search Marketplace'
                              : _marketplacesearchTabController.index == 1
                                  ? 'Search Products'
                                  : _marketplacesearchTabController.index == 2
                                      ? 'Search Services'
                                      : 'Find Suppliers for your Business',
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
                          onChange: (String query) {
                            if (query.isEmpty) {
                              _marketplacesearchTabController.index == 2
                                  ? supplierController.clearSupplierSearch()
                                  : _marketController.clearFilter();
                            } else {
                              _marketController.filterItems(query);
                              supplierController.searchSuppliers(query);
                            }
                            setState(() {});
                          },
                          onSubmit: (String query) {
                            supplierController.searchSuppliers(query);
                            _marketController.filterItems(query);
                            setState(() {});
                          },
                        ),
                      )
                    : ProSearchbar(
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
                bottom: _ismarketplaceSearching
                    ? TabBar(
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
                              _ismarketplaceSearching =
                                  !_ismarketplaceSearching;

                              _marketController.clearFilter();
                              supplierController.searchedSuppliers.clear();
                            });
                          },
                        ),
                      ]
                    : <Widget>[
                        if (!_ismarketplaceSearching)
                          GestureDetector(
                            onTap: () {
                              Get.to(() => const MyOrdersScreen());
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
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
                        if (!_ismarketplaceSearching)
                          GestureDetector(
                            onTap: () {
                              Get.to(() => const ChatScreen());
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                right: 10.0,
                              ),
                              child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: backgroundColor,
                                  child: SvgPicture.asset(
                                    'assets/svgs/prochat.svg',
                                    height: 15,
                                  )),
                            ),
                          ),
                        GestureDetector(
                          onTap: () {
                            _ismarketplaceSearching = !_ismarketplaceSearching;
                            setState(() {});
                            _marketController.clearFilter();
                            supplierController.searchedSuppliers.clear();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 10.0,
                            ),
                            child: _ismarketplaceSearching
                                ? const Icon(Icons.close)
                                : CircleAvatar(
                                    radius: 20,
                                    backgroundColor: backgroundColor,
                                    child: SvgPicture.asset(
                                      'assets/svgs/homesearch.svg',
                                      height: 20,
                                      colorFilter: ColorFilter.mode(
                                          textColor, BlendMode.srcIn),
                                    )),
                          ),
                        ),
                      ],
              ),
            ),
          ],
        ),
      ),
      body: _marketController.isLoading
          ? const CircularProgressIndicator()
          : _ismarketplaceSearching
              ? Column(
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
                                  length: 5, // Number of tabs
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        constraints:
                                            const BoxConstraints.expand(
                                                height: 45),
                                        child: TabBar(
                                          tabAlignment: TabAlignment.start,
                                          padding: EdgeInsets.zero,
                                          unselectedLabelColor:
                                              textColor.withValues(alpha: 0.8),
                                          labelStyle: const TextStyle(
                                              fontWeight: FontWeight.w400),
                                          controller: _marketplaceTabController,
                                          isScrollable: true,
                                          onTap: (int index) {
                                            setState(() {});
                                          },
                                          labelPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 15.0),
                                          tabs: const <Widget>[
                                            Tab(
                                              child: Text(
                                                'Listing',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 14),
                                              ),
                                            ),
                                            Tab(
                                              child: Text(
                                                'Requests',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 14),
                                              ),
                                            ),
                                            Tab(
                                              child: Text(
                                                'Suppliers',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 14),
                                              ),
                                            ),
                                            Tab(
                                              child: Text(
                                                'Find My Match',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 14),
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
                                                  BuyerRequestsScreen(),
                                                  SuppliersPage(),
                                                  ExpandedMatchesScreen(
                                                    isMarketplace: true,
                                                  ),
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
                      BottomBar(
                        activeIndex: 3,
                      ),
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
                const Padding(
                  padding: EdgeInsets.only(left: 10.0, top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Filter results',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
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
                            ? const Icon(Icons.check,
                                size: 20, color: primaryColorLT)
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

    int compareSuppliers(SuppliersModel a, SuppliersModel b) {
      String? aLocation = a.location;
      String? bLocation = b.location;

      String aLoc = aLocation?.toLowerCase() ?? '';
      String bLoc = bLocation?.toLowerCase() ?? '';

      // Step 1: Prioritize items matching the selected location
      bool aIsMyLocation = aLoc == myLocation;
      bool bIsMyLocation = bLoc == myLocation;

      if (aIsMyLocation && !bIsMyLocation) return -1; // a goes up
      if (!aIsMyLocation && bIsMyLocation) return 1; // b goes up

      // Step 2: Sort by date (newest first)
      return bLocation!.compareTo(aLocation!);
    }

    if (_marketController.isfiltered.value) {
      // Sort filtered lists
      _marketController.filteredProducts.sort(compareItems);
      _marketController.filteredServices.sort(compareItems);
      _marketController.allFilteredItems.sort(compareItems);
    } else {
      // Sort all items when no filter is applied
      _marketController.proItems.sort(compareItems);
      _marketController.proProducts.sort(compareItems);
      _marketController.proServices.sort(compareItems);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (supplierController.suppliers.isNotEmpty) {
          supplierController.suppliers.sort(compareSuppliers);
        }
      });
    } // Ensure UI updates
  }
}
