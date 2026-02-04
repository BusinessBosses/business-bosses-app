import 'dart:async';
import 'dart:developer';
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
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/models/user_model.dart';
import '../../home/repository/home_repository.dart';
import '../../marketplace/controllers/supplier_controller.dart';

class MarketController extends GetxController {
  // Marketplace Data
  RxList<Product> proProducts = <Product>[].obs;
  RxList<Service> proServices = <Service>[].obs;
  RxList<Object> proItems = <Object>[].obs;
  RxList<Order> orders = <Order>[].obs;

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
  String? selectedCategory;
  String searchQuery = '';
  List<Product> filteredProducts = <Product>[];
  List<Service> filteredServices = <Service>[];
  List<Object> allFilteredItems = <Object>[];
  RxBool hasOldData = false.obs;

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

  // ============================
  // ===== Basic Utilities ======
  // ============================

  void clearFilter() {
    filteredProducts.clear();
    filteredServices.clear();
    allFilteredItems.clear();
    searchQuery = '';
    selectedCategory = null;

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

  void changeLocation(String name) {
    selectedLocation = name;
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
      final List<ApiResponseModel> responses =
          await Future.wait(<Future<ApiResponseModel>>[
        ApiService.get(
            path:
                'goods/search?category=${Uri.encodeQueryComponent(category)}'),
        ApiService.get(
            path:
                'services/search?category=${Uri.encodeQueryComponent(category)}'),
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
      activeMarketItems
        ..clear()
        ..addAll(searchedProducts)
        ..addAll(searchedServices);

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
      final List<ApiResponseModel> responses =
          await Future.wait(<Future<ApiResponseModel>>[
        ApiService.get(
          path: 'goods/search?q=${Uri.encodeQueryComponent(searchQuery)}',
        ),
        ApiService.get(
          path: 'services/search?q=${Uri.encodeQueryComponent(searchQuery)}',
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
      activeMarketItems
        ..clear()
        ..addAll(searchedProducts)
        ..addAll(searchedServices);
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
    try {
      loading(true);
      error(false);
      await initProItems();
    } catch (e) {
      log(e.toString());
      error(true);
    } finally {
      loading(false);
    }
  }

  Future<void> initDescription() async {
    final List<ApiResponseModel> responses =
        await Future.wait(<Future<ApiResponseModel>>[
      HomeRepository.fetchMarketDescription(),
    ]);

    final ApiResponseModel description = responses.first;

    if (description.success) {
      final List<dynamic> rows = description.data['rows'];
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
      _homeController.notificationDescription =
          popUpEntry?['description'] ?? '';
    } else {
      marketDescription = '';
    }
  }

  Future<void> initProItems({int page = 1, int size = 10}) async {
    error(false);
    if (!loadingMore.value) {
      loading(true);
    }

    try {
      final List<ApiResponseModel> responses =
          await Future.wait(<Future<ApiResponseModel>>[
        ApiService.get(path: 'goods/all?page=$page&size=$size'),
        ApiService.get(path: 'services/all?page=$page&size=$size'),
      ]);

      final ApiResponseModel responseProducts = responses[0];
      final ApiResponseModel responseServices = responses[1];

      // Clear existing items only after successful fetch for first page
      if (page == 1) {
        proProducts.clear();
        proServices.clear();
        proItems.clear();
        hasMoreItems(true);
        paginationPage.value = 1;
        totalItemCount.value = (responseProducts.data['count'] ?? 0) +
            (responseServices.data['count'] ?? 0);
      }

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
        final List<Product> uniqueProducts = newProducts
            .where((Product p) => !existingProductIds.contains(p.id))
            .toList();

        proProducts.addAll(uniqueProducts);
        if (!isfiltered.value) {
          proItems.addAll(uniqueProducts);
        }
      }

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
        final List<Service> uniqueServices = newServices
            .where((Service s) => !existingServiceIds.contains(s.id))
            .toList();

        proServices.addAll(uniqueServices);
        if (!isfiltered.value) {
          proItems.addAll(uniqueServices);
        }

        if (!isSearching.value) {
          activeMarketItems
            ..clear()
            ..addAll(proItems);
        }
      }

      if (proItems.length >= totalItemCount.value) {
        hasMoreItems(false);
      } else {
        paginationPage.value = page;
      }
    } catch (e) {
      error(true);
      debugPrint('❌ initProItems error: $e');
    } finally {
      loading(false);
      update(); // Ensure UI is updated
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
    orders.clear();
    final ApiResponseModel responseOrders = await ApiService.get(
        path: 'orders/user-orders/${_profileController.myProfile.uid}');
    if (responseOrders.success) {
      orders.addAll(responseOrders.data['rows']
          .map<Order>((dynamic json) => Order.fromJson(json))
          .toList());
    } else {
      throw Exception('Failed to fetch orders.');
    }
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

      bool aIsMyLocation = aLoc == myLocation;
      bool bIsMyLocation = bLoc == myLocation;

      if (aIsMyLocation && !bIsMyLocation) return -1;
      if (!aIsMyLocation && bIsMyLocation) return 1;

      return bDate.compareTo(aDate);
    }

    int compareSuppliers(SuppliersModel a, SuppliersModel b) {
      String aLoc = a.location?.toLowerCase() ?? '';
      String bLoc = b.location?.toLowerCase() ?? '';

      bool aIsMyLocation = aLoc == myLocation;
      bool bIsMyLocation = bLoc == myLocation;

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
}
