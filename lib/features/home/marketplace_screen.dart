import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/customitem_model.dart';
import 'package:business_bosses_v2/bbpro/models/product_model.dart';
import 'package:business_bosses_v2/bbpro/models/service_model.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_product.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_service.dart';
import 'package:business_bosses_v2/bbpro/presentation/my_orders_screen.dart';
import 'package:business_bosses_v2/bbpro/widgets/button.dart';
import 'package:business_bosses_v2/bbpro/widgets/proseardwidget.dart';
import 'package:business_bosses_v2/features/chat/chat_screen.dart';
import 'package:business_bosses_v2/features/donations/presentation/filtersuppliers.dart';
import 'package:business_bosses_v2/features/home/widgets/bottom_bar.dart';
import 'package:business_bosses_v2/features/home/widgets/floatingbutton.dart';

import 'package:business_bosses_v2/features/marketplace/controllers/supplier_controller.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/add_supplier.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/add_supplier_shop.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/filtermarketplaceposts.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/filtermarketproducts.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/filtermarketservices.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/supplierspage.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/markets.dart';
import 'package:business_bosses_v2/features/marketplace/models/suppliers_model.dart';

import 'package:business_bosses_v2/features/marketplace/widgets/products.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/services.dart';
import 'package:business_bosses_v2/features/moreinfoscreens/bossuppartner.dart';
import 'package:business_bosses_v2/features/premium/proscreen.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/features/search/widgets/search_bar.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
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
    'Vehicle & Transportation'
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

  @override
  void initState() {
    super.initState();
    _marketplacesearchTabController = TabController(length: 4, vsync: this);
    _marketplaceTabController = TabController(length: 5, vsync: this);

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
    supplierController.initSuppliers();
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
        _profileController.myProfile.location ??
        'Nigeria';
    sortItems();
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
                        if (!_profileController.myProfile.hasShop) {
                          Get.bottomSheet(
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                              ),
                            ),
                            SizedBox(
                              height: Get.height * 0.9,
                              child: const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: 0.0, top: 0, bottom: 10),
                                        child: ProSubscribeSection(
                                          isGrow: true,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                            backgroundColor: Colors.white,
                          );
                          return;
                        }
                        _marketplaceTabController.index == 4
                            ? launchUrl(Uri.parse(
                                'https://businessbosses.co.uk/landingpageforpartners'))
                            : _marketplaceTabController.index == 3
                                ? _profileController.myProfile.hasShop
                                    ? supplierController.suppliers.any(
                                            (SuppliersModel supplier) =>
                                                supplier.name ==
                                                shopController.shop?.name)
                                        ? Get.to(
                                            () => const AddSupplierScreen())
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
                                                                        AddSupplierShopScreen(
                                                                          shop:
                                                                              shopController.shop!,
                                                                        ))
                                                                    : Get.to(() =>
                                                                        const AddSupplierScreen());
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
                                                                color: textColor
                                                                    .withOpacity(
                                                                        1),
                                                              ),
                                                              title: Text(
                                                                index == 0
                                                                    ? 'Add My Biz-Center To Supplier'
                                                                    : 'Add New Supplier',
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
                                            })
                                    : Get.to(() => const AddSupplierScreen())
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
                                          padding: const EdgeInsets.all(15.0),
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
                                                      onTap: () {
                                                        Navigator.pop(context);
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
                                                        color: textColor
                                                            .withOpacity(1),
                                                      ),
                                                      title: Text(
                                                        index == 0
                                                            ? 'Sell your product'
                                                            : 'Sell your service',
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
                                    });
                      },
                      text: _marketplaceTabController.index == 4
                          ? 'Add Deals'
                          : _marketplaceTabController.index != 3
                              ? 'Sell'
                              : 'Add a Supplier',
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
                        radius: 8,
                        contentPadding: 10,
                        hasSearchIcon: true,
                        backgroundColor: backgroundColor,
                        hintText: 'Search Marketplace',
                        autofocus: false,
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
                              ? 'Search'
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
                          // Tab(text: 'BoosUp'),
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
                                      color: textColor,
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
                                          isScrollable: true,
                                          onTap: (int index) {
                                            setState(() {});
                                          },
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
                                            Tab(
                                              child: FittedBox(
                                                child: Text(
                                                  'Deals',
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
                                                  Bossuppartner(
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
                            ? const Icon(Icons.check, color: Colors.blue)
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
      _marketController.proItemsWithImages.sort(compareItems);
      _marketController.proProducts.sort(compareItems);
      _marketController.proServices.sort(compareItems);
      supplierController.suppliers.sort(compareSuppliers);
    }
    if (mounted) {
      setState(() {});
    } // Ensure UI updates
  }
}
