import 'dart:async';
import 'dart:developer';
import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/customitem_model.dart';
import 'package:business_bosses_v2/bbpro/models/order_model.dart';
import 'package:business_bosses_v2/bbpro/models/product_model.dart';
import 'package:business_bosses_v2/bbpro/models/service_model.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/features/marketplace/models/suppliers_model.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:business_bosses_v2/bbpro/widgets/countrycodes.dart';

import '../../../common/models/user_model.dart';
import '../../home/repository/home_repository.dart';
import '../../marketplace/controllers/supplier_controller.dart';

class MarketController extends GetxController {
  // Marketplace Data
  RxList<Product> proProducts = <Product>[].obs;
  RxList<Service> proServices = <Service>[].obs;
  RxList<Object> proItems = <Object>[].obs;
  RxList<Product> featuredProducts = <Product>[].obs;
  RxList<Service> featuredServices = <Service>[].obs;
  RxList<Object> featuredItems = <Object>[].obs;
  RxList<Order> orders = <Order>[].obs;
  int currentOrderPage = 1;
  bool hasMoreOrders = true;
  // Server-reported total count of the user's orders (matches the backend's
  // findAndCountAll count, already filtered for deleted users/shops). Use this
  // for the displayed length so it's correct before pagination loads everything.
  RxInt totalOrderCount = 0.obs;

  // Filtering and search
  List<UserModel> searchedUsers = <UserModel>[];
  RxBool loadingSearch = false.obs;
  RxBool loadingPostSearch = false.obs;
  RxBool loadingServicesSearch = false.obs;
  RxInt paginationPage = 1.obs;
  RxBool isUserSearch = false.obs;
  RxBool isPostSearch = false.obs;
  RxBool isServiceSearch = false.obs;
  RxBool error = false.obs;
  RxBool loading = false.obs;
  RxBool oloading = false.obs;
  RxBool oerror = false.obs;
  RxBool loadingMore = false.obs;
  RxBool isJoined = false.obs;
  RxBool isfiltered = false.obs;
  RxBool showFloatingButton = false.obs;

  bool isLoading = true;

  // Filter & Sort fields
  String? selectedLocation;
  String? selectedLocationCode;
  String? selectedCategory;
  String searchQuery = '';
  List<Product> filteredProducts = <Product>[];
  List<Service> filteredServices = <Service>[];
  List<Object> allFilteredItems = <Object>[];
  RxBool hasOldData = false.obs;
  RxBool loadingMoreOrders = false.obs;

  // Controller dependencies
  final HomeController _homeController = Get.find();
  final ProfileController _profileController = Get.find();
  final SupplierController supplierController = Get.put(SupplierController());

  late List<String> connecteds =
      _profileController.myProfile.connecteds ?? <String>[];
  RxList<Product> searchedProducts = <Product>[].obs;
  RxList<Service> searchedServices = <Service>[].obs;
  RxBool isSearching = false.obs;
  RxBool searchLoading = false.obs;

  /// Holds items currently displayed in MarketsPage
  RxList<Object> activeMarketItems = <Object>[].obs;

  String marketDescription = '';
  String donationDescription = '';
  RxInt totalItemCount = 0.obs; // keeps the total number of products+services
  RxBool hasMoreItems = true.obs; // indicates if more items are available
  final GetStorage sandBox = GetStorage();
  bool _isInitializing = false;

  @override
  void onInit() {
    super.onInit();
    _initializeLocation();
    initMarket();
  }

  void _initializeLocation() {
    // Priority: Stored location > Profile location > Default
    // Using stored location first ensures that if a user manually changes location in the marketplace, it's remembered.
    final String? storedLocation = sandBox.read('selected_location');
    final String? storedLocationCode = sandBox.read('selected_location_code');

    if (storedLocation != null && storedLocationCode != null) {
      selectedLocation = storedLocation;
      selectedLocationCode = storedLocationCode;
    } else if (_profileController.myProfile.location != null &&
        _profileController.myProfile.location!.isNotEmpty) {
      selectedLocation = _profileController.myProfile.location;
      selectedLocationCode = CountryCodes.nameToCode[selectedLocation!] ?? 'GB';
    } else {
      selectedLocation = 'United Kingdom';
      selectedLocationCode = 'GB';
    }

    // Standardize GB to UK for consistency with visual requirements
    if (selectedLocationCode == 'GB') selectedLocationCode = 'UK';
  }

  // ============================
  // ===== Basic Utilities ======
  // ============================

  void clearFilter() {
    filteredProducts.clear();
    filteredServices.clear();
    allFilteredItems.clear();
    searchQuery = '';
    selectedCategory = null;
    update();

    // Restore proItems from original data - ensure no duplicates
    proItems.clear();
    final Set<int> itemIds = <int>{};
    for (final Product p in proProducts) {
      if (!itemIds.contains(p.id)) {
        proItems.add(p);
        itemIds.add(p.id);
      }
    }
    for (final Service s in proServices) {
      if (!itemIds.contains(s.id)) {
        proItems.add(s);
        itemIds.add(s.id);
      }
    }

    activeMarketItems
      ..clear()
      ..addAll(proItems);

    isSearching(false);
    isfiltered(false);

    update();
  }

  Future<void> changeLocation(String name, {String? code}) async {
    selectedLocation = name;
    if (code != null) {
      selectedLocationCode = code;
    } else {
      selectedLocationCode = CountryCodes.nameToCode[name];
    }

    // Standardize GB to UK for consistency with visual requirements
    if (selectedLocationCode == 'GB') selectedLocationCode = 'UK';

    sandBox.write('selected_location', selectedLocation);
    sandBox.write('selected_location_code', selectedLocationCode);

    // Update Profile Controller and Backend
    if (_profileController.myProfile.uid.isNotEmpty) {
      _profileController.myProfile =
          _profileController.myProfile.copyWith(location: name);
      _profileController.update();

      // Update backend
      await ApiService.put(
        path: 'users/${_profileController.myProfile.uid}',
        body: <String, dynamic>{'location': name},
      );
    }

    // Also update shop location if user has one
    final ShopController shopController = Get.find();
    if (shopController.shop != null) {
      await shopController.updateShop(
          shopController.shop!.id, <String, dynamic>{'location': name});
    }

    update();
  }

  void updateFiltered() {
    isfiltered(false);
  }

  Future<void> loadCategory(String? category) async {
    selectedCategory = category;
    isSearching(true);
    loading.value = true;
    update();
    searchedProducts.clear();
    searchedServices.clear();

    if (category == null || category.isEmpty) {
      // Restore normal marketplace items
      isSearching(false);
      loading(false);
      update();
      return;
    }

    try {
      String pathSuffix = '';
      if (selectedLocation != null && selectedLocation!.isNotEmpty) {
        pathSuffix = '&location=${Uri.encodeQueryComponent(selectedLocation!)}';
      }

      final List<ApiResponseModel> responses =
          await Future.wait(<Future<ApiResponseModel>>[
        ApiService.get(
            path:
                'goods/search?category=${Uri.encodeQueryComponent(category)}$pathSuffix'),
        ApiService.get(
            path:
                'services/search?category=${Uri.encodeQueryComponent(category)}$pathSuffix'),
      ]);

      final ApiResponseModel productRes = responses[0];
      final ApiResponseModel serviceRes = responses[1];

      searchedProducts.clear();
      searchedServices.clear();

      if (productRes.success) {
        searchedProducts.assignAll(
          (productRes.data['rows'] as List<dynamic>)
              .map<Product>(
                  (dynamic e) => Product.fromJson(e as Map<String, dynamic>))
              .toList(),
        );
      }

      if (serviceRes.success) {
        searchedServices.assignAll(
          (serviceRes.data['rows'] as List<dynamic>)
              .map<Service>(
                  (dynamic e) => Service.fromJson(e as Map<String, dynamic>))
              .toList(),
        );
      }

      // 🔥 THIS IS THE KEY
      activeMarketItems.assignAll(<Object>[...searchedProducts, ...searchedServices]);

      sortItems();

      hasMoreItems(false); // category search does not paginate
    } finally {
      loading.value = false;
      update();
    }
  }

  Future<void> searchMarketplace(String query) async {
    searchQuery = query.trim();

    if (searchQuery.isEmpty) {
      searchedProducts.clear();
      searchedServices.clear();

      // 🔥 Restore default marketplace items
      activeMarketItems
        ..clear()
        ..addAll(proItems);

      isSearching(false);
      searchLoading(false);
      update();
      return;
    }

    isSearching(true);
    searchLoading(true);
    update();

    try {
      String pathSuffix = '';
      if (selectedLocation != null && selectedLocation!.isNotEmpty) {
        pathSuffix = '&location=${Uri.encodeQueryComponent(selectedLocation!)}';
      }

      final List<ApiResponseModel> responses =
          await Future.wait(<Future<ApiResponseModel>>[
        ApiService.get(
          path:
              'goods/search?q=${Uri.encodeQueryComponent(searchQuery)}$pathSuffix',
        ),
        ApiService.get(
          path:
              'services/search?q=${Uri.encodeQueryComponent(searchQuery)}$pathSuffix',
        ),
      ]);

      searchedProducts.assignAll(
        (responses[0].data['rows'] as List<dynamic>)
            .map<Product>(
                (dynamic e) => Product.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

      searchedServices.assignAll(
        (responses[1].data['rows'] as List<dynamic>)
            .map<Service>(
                (dynamic e) => Service.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

      // ✅ single source of truth for UI
      activeMarketItems.assignAll(<Object>[...searchedProducts, ...searchedServices]);

      sortItems();
    } catch (e) {
      debugPrint('Search error: $e');
    } finally {
      searchLoading(false);
      update();
    }
  }

  void clearUserSearch() => isUserSearch(false);
  void clearPostSearch() => isPostSearch(false);
  void clearServiceSearch() => isServiceSearch(false);

  // ============================
  // ===== API Calls ============
  // ============================

  Future<void> initMarket() async {
    if (_isInitializing) return;
    _isInitializing = true;
    _initializeLocation(); // Sync with profile location
    try {
      // 1. Load cache immediately (Synchronous operations from GetStorage)
      final dynamic cachedProducts = sandBox.read('market_products');
      final dynamic cachedServices = sandBox.read('market_services');
      if (cachedProducts != null || cachedServices != null) {
        _processCachedItems(cachedProducts, cachedServices);
      }

      final dynamic cachedFeaturedProducts = sandBox.read('featured_products');
      final dynamic cachedFeaturedServices = sandBox.read('featured_services');
      if (cachedFeaturedProducts != null || cachedFeaturedServices != null) {
        _processFeaturedItems(cachedFeaturedProducts, cachedFeaturedServices);
      }

      // Show UI immediately if we have cache
      if (proItems.isNotEmpty || featuredItems.isNotEmpty) {
        loading(false);
      } else {
        loading(true);
      }
      error(false);
      update();

      // 2. Refresh from network in background
      await Future.wait(<Future<void>>[
        initProItems(isBackgroundRefresh: true),
        initFeaturedItems(isBackgroundRefresh: true),
      ]);
    } catch (e) {
      log('❌ initMarket error: ${e.toString()}');
      if (proItems.isEmpty) {
        error(true);
      }
    } finally {
      _isInitializing = false;
      loading(false);
      update();
    }
  }

  Future<void> initDescription() async {
    final dynamic cachedAdmin = sandBox.read('admin_data');
    if (cachedAdmin != null) {
      _processAdminData(cachedAdmin);
      update();
    }

    final List<ApiResponseModel> responses =
        await Future.wait(<Future<ApiResponseModel>>[
      HomeRepository.fetchMarketDescription(),
    ]);

    final ApiResponseModel description = responses.first;

    if (description.success) {
      await sandBox.write('admin_data', description.data);
      _processAdminData(description.data);
      update();
    } else {
      marketDescription = '';
    }
  }

  void _processAdminData(dynamic data) {
    final List<dynamic> rows = data['rows'] ?? <dynamic>[];
    final dynamic marketEntry = rows.firstWhere(
      (dynamic e) => e['title'] == 'market',
      orElse: () => null,
    );
    final dynamic donationEntry = rows.firstWhere(
      (dynamic e) => e['title'] == 'donation',
      orElse: () => null,
    );
    final dynamic popUpEntry = rows.firstWhere(
      (dynamic e) => e['id'] == 6,
      orElse: () => null,
    );

    marketDescription = marketEntry?['description'] ?? '';
    donationDescription = donationEntry?['description'] ?? '';
    _homeController.notificationStatus = popUpEntry?['title'] ?? '';
    _homeController.notificationDescription = popUpEntry?['description'] ?? '';
  }

  Future<void> initProItems(
      {int page = 1, int size = 10, bool isBackgroundRefresh = false}) async {
    error(false);
    if (!loadingMore.value && !isBackgroundRefresh) {
      if (page == 1) {
        final dynamic cachedProducts = sandBox.read('market_products');
        final dynamic cachedServices = sandBox.read('market_services');
        if (cachedProducts != null || cachedServices != null) {
          _processCachedItems(cachedProducts, cachedServices);
          loading(false);
          update();
        } else {
          loading(true);
        }
      } else {
        loading(true);
      }
    }

    try {
      String pathSuffix = '';
      if (selectedLocation != null && selectedLocation!.isNotEmpty) {
        pathSuffix = '&location=${Uri.encodeQueryComponent(selectedLocation!)}';
      }

      final List<ApiResponseModel> responses =
          await Future.wait(<Future<ApiResponseModel>>[
        ApiService.get(path: 'goods/all?page=$page&size=$size$pathSuffix'),
        ApiService.get(path: 'services/all?page=$page&size=$size$pathSuffix'),
      ]);

      final ApiResponseModel responseProducts = responses[0];
      final ApiResponseModel responseServices = responses[1];

      // Clear existing items only after successful fetch for first page
      if (page == 1) {
        // 🔥 Update cache only if successful
        if (responseProducts.success) {
          await sandBox.write('market_products', responseProducts.data);
        }
        if (responseServices.success) {
          await sandBox.write('market_services', responseServices.data);
        }

        if (responseProducts.success || responseServices.success) {
          proProducts.clear();
          proServices.clear();
          proItems.clear();
          hasMoreItems(true);
          paginationPage.value = 1;

          int count = 0;
          if (responseProducts.success && responseProducts.data is Map) {
            count += (responseProducts.data['count'] ?? 0) as int;
          }
          if (responseServices.success && responseServices.data is Map) {
            count += (responseServices.data['count'] ?? 0) as int;
          }
          totalItemCount.value = count;
        }
      }

      final List<Product> addedProducts = <Product>[];
      if (responseProducts.success) {
        final List<dynamic> productRows =
            responseProducts.data['rows'] ?? <dynamic>[];
        final List<Product> newProducts = productRows
            .map((dynamic e) => Product.fromJson(e as Map<String, dynamic>))
            .where((Product p) => p.isActive)
            .toList();

        // Prevent duplicates
        final Set<int> existingProductIds =
            proProducts.map((Product p) => p.id).toSet();
        addedProducts.addAll(newProducts
            .where((Product p) => !existingProductIds.contains(p.id))
            .toList());

        proProducts.addAll(addedProducts);
      }

      final List<Service> addedServices = <Service>[];
      if (responseServices.success) {
        final List<dynamic> serviceRows =
            responseServices.data['rows'] ?? <dynamic>[];
        final List<Service> newServices = serviceRows
            .map((dynamic e) => Service.fromJson(e as Map<String, dynamic>))
            .where((Service s) => s.isActive)
            .toList();

        // Prevent duplicates
        final Set<int> existingServiceIds =
            proServices.map((Service s) => s.id).toSet();
        addedServices.addAll(newServices
            .where((Service s) => !existingServiceIds.contains(s.id))
            .toList());

        proServices.addAll(addedServices);
      }

      // Update proItems and activeMarketItems atomically if first page
      if (page == 1 && (responseProducts.success || responseServices.success)) {
        final List<Object> combined = <Object>[];
        combined.addAll(proProducts);
        combined.addAll(proServices);
        proItems.assignAll(combined);

        if (!isSearching.value &&
            selectedCategory == null &&
            searchQuery.isEmpty) {
          activeMarketItems.assignAll(combined);
        }
        sortItems();
      } else if (page > 1) {
        // Append for pagination
        if (addedProducts.isNotEmpty || addedServices.isNotEmpty) {
          final List<Object> newItems = <Object>[];
          newItems.addAll(addedProducts);
          newItems.addAll(addedServices);

          proItems.addAll(newItems);
          if (!isSearching.value &&
              selectedCategory == null &&
              searchQuery.isEmpty) {
            activeMarketItems.addAll(newItems);
          }
        }
      }

      if (proItems.length >= totalItemCount.value) {
        hasMoreItems(false);
      } else {
        paginationPage.value = page;
      }
    } catch (e) {
      if (proItems.isEmpty) error(true);
      debugPrint('❌ initProItems error: $e');
    } finally {
      loading(false);
      update();
    }
  }

  Future<void> loadMore() async {
    if (!hasMoreItems.value || loadingMore.value) return;

    loadingMore(true);
    try {
      await initProItems(page: paginationPage.value + 1);
    } catch (e) {
      debugPrint('❌ Load more error: $e');
    } finally {
      loadingMore(false);
      update();
    }
  }

  Future<void> initOrder() async {
    // Yield to the event loop so the synchronous cache branch (and its
    // update()) never runs during the caller's build/initState phase.
    await Future<void>.delayed(Duration.zero);

    currentOrderPage = 1;
    hasMoreOrders = true;

    final String uid = _profileController.myProfile.uid;
    final dynamic cachedOrders = sandBox.read('user_orders_$uid');

    if (cachedOrders != null) {
      orders.clear();
      final List<Order> cachedList = (cachedOrders['rows'] as List<dynamic>)
          .map<Order>((dynamic json) => Order.fromJson(json))
          .toList();
      cachedList.sort((Order a, Order b) => b.createdAt.compareTo(a.createdAt));
      orders.addAll(cachedList);
      totalOrderCount.value = (cachedOrders['count'] ?? cachedList.length) as int;
      update();
    }

    final ApiResponseModel responseOrders =
        await ApiService.get(path: 'orders/user-orders/$uid?page=1&limit=15');
    if (responseOrders.success) {
      await sandBox.write('user_orders_$uid', responseOrders.data);
      orders.clear();
      final List<Order> responseList = (responseOrders.data['rows'] as List<dynamic>)
          .map<Order>((dynamic json) => Order.fromJson(json))
          .toList();
      responseList.sort((Order a, Order b) => b.createdAt.compareTo(a.createdAt));
      orders.addAll(responseList);
      totalOrderCount.value =
          (responseOrders.data['count'] ?? responseList.length) as int;
      update();
    }
  }

  Future<void> loadMoreMyOrders() async {
    if (loadingMoreOrders.value || !hasMoreOrders) return;
    loadingMoreOrders(true);
    update();

    final String uid = _profileController.myProfile.uid;
    int nextPage = currentOrderPage + 1;
    final ApiResponseModel responseOrders =
        await ApiService.get(path: 'orders/user-orders/$uid?page=$nextPage&limit=15');

    if (responseOrders.success) {
      List<dynamic> rows = responseOrders.data['rows'];
      if (rows.isEmpty) {
        hasMoreOrders = false;
      } else {
        currentOrderPage = nextPage;
        orders.addAll(rows
            .map<Order>((dynamic json) => Order.fromJson(json))
            .toList());
      }
    }
    loadingMoreOrders(false);
    update();
  }

  Future<bool> migrateOldMarketplaceData() async {
    final ApiResponseModel response = await ApiService.post(
      path: 'cronjob/migrate-marketplace-data',
      body: <String, dynamic>{'userId': _profileController.myProfile.uid},
    );
    if (response.success) {
      await initMarket();
      return true;
    }
    return false;
  }

  Future<bool> checkOldMarketplaceData() async {
    final ApiResponseModel response = await ApiService.get(
      path: 'markets/user/${_profileController.myProfile.uid}',
    );
    if (response.success && response.data['count'] > 0) {
      hasOldData(true);
      return true;
    }
    return false;
  }

  // ============================
  // ===== Filtering Logic ======
  // ============================

  void filterItems(String query) {
    searchQuery = query.trim().toLowerCase();

    // Reset filtered lists before filtering
    filteredProducts.clear();
    filteredServices.clear();
    allFilteredItems.clear();

    // If all filters are empty, reset state and return
    if (searchQuery.isEmpty &&
        (selectedCategory == null || selectedCategory!.isEmpty) &&
        (selectedLocation == null || selectedLocation!.isEmpty)) {
      clearFilter();
      return;
    }

    final String? normalizedCategory = selectedCategory?.toLowerCase().trim();

    // Filter Products
    for (final Product p in proProducts) {
      final bool matchesQuery = searchQuery.isEmpty ||
          p.name.toLowerCase().contains(searchQuery) ||
          p.description.toLowerCase().contains(searchQuery);

      final String pCat = p.category.toLowerCase().trim();
      final bool matchesCategory = normalizedCategory == null ||
          normalizedCategory.isEmpty ||
          pCat == normalizedCategory ||
          (pCat.isNotEmpty &&
              (pCat.contains(normalizedCategory) ||
                  normalizedCategory.contains(pCat)));

      if (matchesQuery && matchesCategory) {
        filteredProducts.add(p);
        allFilteredItems.add(p);
      }
    }

    // Filter Services
    for (final Service s in proServices) {
      final bool matchesQuery = searchQuery.isEmpty ||
          s.name.toLowerCase().contains(searchQuery) ||
          s.description.toLowerCase().contains(searchQuery);

      final String sCat = s.category?.toLowerCase().trim() ?? '';
      final bool matchesCategory = normalizedCategory == null ||
          normalizedCategory.isEmpty ||
          (sCat.isNotEmpty &&
              (sCat == normalizedCategory ||
                  sCat.contains(normalizedCategory) ||
                  normalizedCategory.contains(sCat)));

      if (matchesQuery && matchesCategory) {
        filteredServices.add(s);
        allFilteredItems.add(s);
      }
    }

    // ✅ Update GetX observables so UI rebuilds
    proProducts.refresh();
    proServices.refresh();
    // NOTE: Don't modify proItems here - MarketsPage uses isfiltered to choose display list

    // ✅ Apply sorting again for location/date
    sortItems();

    isfiltered(true);
    update();

    debugPrint(
        '🔍 Filtered: ${filteredProducts.length} products, ${filteredServices.length} services, total ${allFilteredItems.length}');
    if (filteredProducts.isNotEmpty || filteredServices.isNotEmpty) {
      hasMoreItems(false); // disable load more for filtered results
    }
  }

  // ============================
  // ===== Sorting Logic ========
  // ============================

  void sortItems() {
    final String? myLocation = selectedLocation?.toLowerCase();

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

      String aLoc = extractLocation(a).toLowerCase();
      String bLoc = extractLocation(b).toLowerCase();

      bool aIsMyLocation = myLocation != null &&
          (aLoc.contains(myLocation) || myLocation.contains(aLoc));
      bool bIsMyLocation = myLocation != null &&
          (bLoc.contains(myLocation) || myLocation.contains(bLoc));

      if (aIsMyLocation && !bIsMyLocation) return -1;
      if (!aIsMyLocation && bIsMyLocation) return 1;

      return bDate.compareTo(aDate);
    }

    int compareSuppliers(SuppliersModel a, SuppliersModel b) {
      String aLoc = a.location?.toLowerCase() ?? '';
      String bLoc = b.location?.toLowerCase() ?? '';

      bool aIsMyLocation = myLocation != null &&
          (aLoc.contains(myLocation) || myLocation.contains(aLoc));
      bool bIsMyLocation = myLocation != null &&
          (bLoc.contains(myLocation) || myLocation.contains(bLoc));

      if (aIsMyLocation && !bIsMyLocation) return -1;
      if (!aIsMyLocation && bIsMyLocation) return 1;

      return bLoc.compareTo(aLoc);
    }

    if (isfiltered.value) {
      filteredProducts.sort(compareItems);
      filteredServices.sort(compareItems);
      allFilteredItems.sort(compareItems);
    } else {
      proItems.sort(compareItems);
      proProducts.sort(compareItems);
      proServices.sort(compareItems);
      activeMarketItems.sort(compareItems);
      if (supplierController.suppliers.isNotEmpty) {
        supplierController.suppliers.sort(compareSuppliers);
      }
    }
  }

  String extractLocation(Object item) {
    if (item is Product) return item.location ?? '';
    if (item is Service) return item.location;
    if (item is Customitem) return item.shop?.location ?? '';
    return '';
  }

  // Extract createdAt from different types
  DateTime _getCreatedAt(Object item) {
    if (item is Product) return item.createdAt;
    if (item is Service) return item.createdAt;
    if (item is Customitem) return item.createdAt;
    throw Exception('Unknown item type: $item');
  }

  // ============================
  // ===== Migration Reminder ===
  // ============================

  Future<void> checkMigrationReminder() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String uid = _profileController.myProfile.uid;
    final int? remindTimestamp = prefs.getInt('migration_remind_$uid');

    if (remindTimestamp != null) {
      final DateTime remindDate =
          DateTime.fromMillisecondsSinceEpoch(remindTimestamp);
      if (DateTime.now().difference(remindDate) < const Duration(days: 30)) {
        return;
      }
    }
    hasOldData(true);
  }

  Future<void> updateMigrationReminder() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String uid = _profileController.myProfile.uid;
    final int now = DateTime.now().millisecondsSinceEpoch;
    await prefs.setInt('migration_remind_$uid', now);
  }

  void _processCachedItems(dynamic productsData, dynamic servicesData) {
    final List<Product> cachedProducts = <Product>[];
    final List<Service> cachedServices = <Service>[];

    if (productsData != null) {
      final List<dynamic> productRows = productsData['rows'] ?? <dynamic>[];
      cachedProducts.addAll(productRows
          .map((dynamic e) => Product.fromJson(e as Map<String, dynamic>))
          .where((Product p) => p.isActive));
    }

    if (servicesData != null) {
      final List<dynamic> serviceRows = servicesData['rows'] ?? <dynamic>[];
      cachedServices.addAll(serviceRows
          .map((dynamic e) => Service.fromJson(e as Map<String, dynamic>))
          .where((Service s) => s.isActive));
    }

    proProducts.assignAll(cachedProducts);
    proServices.assignAll(cachedServices);

    final List<Object> combined = <Object>[];
    combined.addAll(cachedProducts);
    combined.addAll(cachedServices);
    proItems.assignAll(combined);

    activeMarketItems.assignAll(combined);

    totalItemCount.value = ((productsData?['count'] ?? 0) as int) +
        ((servicesData?['count'] ?? 0) as int);
  }

  Future<void> initFeaturedItems({bool isBackgroundRefresh = false}) async {
    // 🔥 Check cache first
    dynamic cachedFeaturedProducts = sandBox.read('featured_products');
    dynamic cachedFeaturedServices = sandBox.read('featured_services');

    if (!isBackgroundRefresh) {
      if (cachedFeaturedProducts != null || cachedFeaturedServices != null) {
        _processFeaturedItems(cachedFeaturedProducts, cachedFeaturedServices);
        update();
      }
    }

    try {
      final List<ApiResponseModel> responses =
          await Future.wait(<Future<ApiResponseModel>>[
        ApiService.get(path: 'goods/featured'),
        ApiService.get(path: 'services/featured'),
      ]);

      final ApiResponseModel resProd = responses[0];
      final ApiResponseModel resServ = responses[1];

      if (resProd.success) {
        await sandBox.write('featured_products', resProd.data);
      }
      if (resServ.success) {
        await sandBox.write('featured_services', resServ.data);
      }

      _processFeaturedItems(
        resProd.success ? resProd.data : cachedFeaturedProducts,
        resServ.success ? resServ.data : cachedFeaturedServices,
      );

      update();
    } catch (e) {
      debugPrint('❌ initFeaturedItems error: $e');
    }
  }

  void _processFeaturedItems(dynamic productsData, dynamic servicesData) {
    final List<Product> newFeaturedProducts = <Product>[];
    final List<Service> newFeaturedServices = <Service>[];

    if (productsData != null) {
      final List<dynamic> productRows = productsData['rows'] ?? <dynamic>[];
      newFeaturedProducts.addAll(productRows
          .map((dynamic e) => Product.fromJson(e as Map<String, dynamic>))
          .where((Product p) => p.isActive));
    }

    if (servicesData != null) {
      final List<dynamic> serviceRows = servicesData['rows'] ?? <dynamic>[];
      newFeaturedServices.addAll(serviceRows
          .map((dynamic e) => Service.fromJson(e as Map<String, dynamic>))
          .where((Service s) => s.isActive));
    }

    featuredProducts.assignAll(newFeaturedProducts);
    featuredServices.assignAll(newFeaturedServices);

    final List<Object> combined = <Object>[];
    combined.addAll(newFeaturedProducts);
    combined.addAll(newFeaturedServices);
    combined.sort(
        (Object a, Object b) => _getCreatedAt(b).compareTo(_getCreatedAt(a)));

    featuredItems.assignAll(combined);
  }
}
