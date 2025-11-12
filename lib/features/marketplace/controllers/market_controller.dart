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

  String marketDescription = '';
  String donationDescription = '';

  // ============================
  // ===== Basic Utilities ======
  // ============================

  void clearFilter() {
    filteredProducts.clear();
    filteredServices.clear();
    allFilteredItems.clear();
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

      final List<ApiResponseModel> responses =
          await Future.wait(<Future<ApiResponseModel>>[
        HomeRepository.fetchMarketDescription(),
      ]);

      final ApiResponseModel description = responses.first;
      await initProItems();

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
    } catch (e) {
      log(e.toString());
      error(true);
    } finally {
      loading(false);
    }
  }

  Future<void> initProItems() async {
    error(false);
    loading(true);
    proProducts.clear();
    proServices.clear();
    proItems.clear();

    try {
      final List<ApiResponseModel> responses =
          await Future.wait(<Future<ApiResponseModel>>[
        ApiService.get(path: 'goods/all'),
        ApiService.get(path: 'services/all'),
      ]);

      final ApiResponseModel responseProducts = responses[0];
      final ApiResponseModel responseServices = responses[1];

      // ✅ Safely parse and filter products
      if (responseProducts.success && responseProducts.data['rows'] is List) {
        final List<dynamic> productRows =
            responseProducts.data['rows'] as List<dynamic>;

        final List<Product> mappedProducts = productRows
            .map((dynamic e) => Product.fromJson(e as Map<String, dynamic>))
            .toList();

        proProducts
            .addAll(mappedProducts.where((Product p) => p.isActive).toList());
      }

      // ✅ Safely parse and filter services
      if (responseServices.success && responseServices.data['rows'] is List) {
        final List<dynamic> serviceRows =
            responseServices.data['rows'] as List<dynamic>;

        final List<Service> mappedServices = serviceRows
            .map((dynamic e) => Service.fromJson(e as Map<String, dynamic>))
            .toList();

        proServices
            .addAll(mappedServices.where((Service s) => s.isActive).toList());
      }

      // ✅ Combine into a single marketplace list
      proItems.addAll(<Object>[...proProducts, ...proServices]);

      // ✅ No error if data loaded successfully
      if (proItems.isNotEmpty) {
        error(false);
      }
    } catch (e) {
      error(true);
      debugPrint('❌ initProItems error: $e');
    } finally {
      loading(false);
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

    // If query is empty, reset state and return
    if (searchQuery.isEmpty &&
        (selectedCategory == null || selectedCategory!.isEmpty)) {
      isfiltered(false);
      update();
      return;
    }

    final String? normalizedCategory = selectedCategory?.toLowerCase().trim();

    // Filter Products
    for (final Product p in proProducts) {
      final bool matchesQuery = searchQuery.isEmpty ||
          p.name.toLowerCase().contains(searchQuery) ||
          p.description.toLowerCase().contains(searchQuery);

      final bool matchesCategory = normalizedCategory == null ||
          p.category.toLowerCase().trim() == normalizedCategory;

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

      final bool matchesCategory = normalizedCategory == null ||
          (s.category?.toLowerCase().trim() == normalizedCategory);

      if (matchesQuery && matchesCategory) {
        filteredServices.add(s);
        allFilteredItems.add(s);
      }
    }

    // ✅ Update GetX observables so UI rebuilds
    proProducts.refresh();
    proServices.refresh();
    proItems.assignAll(allFilteredItems);

    // ✅ Apply sorting again for location/date
    sortItems();

    isfiltered(true);
    update();

    debugPrint(
        '🔍 Filtered: ${filteredProducts.length} products, ${filteredServices.length} services, total ${allFilteredItems.length}');
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

      String aLoc = _extractLocation(a).toLowerCase();
      String bLoc = _extractLocation(b).toLowerCase();

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

  String _extractLocation(Object item) {
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
