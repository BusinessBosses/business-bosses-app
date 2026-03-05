import 'dart:developer';

import 'package:business_bosses_v2/bbpro/models/customitem_model.dart';
import 'package:business_bosses_v2/bbpro/models/order_stats_model.dart';
import 'package:business_bosses_v2/bbpro/models/product_model.dart';
import 'package:business_bosses_v2/bbpro/models/service_model.dart';
import 'package:business_bosses_v2/bbpro/models/shop_graph_model.dart';
import 'package:business_bosses_v2/bbpro/models/shop_model.dart';
import 'package:business_bosses_v2/bbpro/models/shop_stats_model.dart';
import 'package:business_bosses_v2/bbpro/models/supplier_model.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/market_controller.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ShopController extends GetxController {
  final ProfileController profileController = Get.find();
  final MarketController marketController = Get.put(MarketController());
  Shop? shop;
  Shop? userShop;
  RxBool loading = RxBool(true);
  RxBool loadingData = RxBool(true);
  RxBool supploerAddLoading = RxBool(false);
  RxList<Product> products = RxList<Product>(<Product>[]);
  RxList<Service> services = RxList<Service>(<Service>[]);
  RxList<Customitem> customItems = RxList<Customitem>(<Customitem>[]);
  RxList<Object> items = RxList<Object>(<Object>[]);
  RxList<Product> userProducts = RxList<Product>(<Product>[]);
  RxList<Service> userServices = RxList<Service>(<Service>[]);
  RxList<Customitem> userCustomItems = RxList<Customitem>(<Customitem>[]);
  RxList<Object> userItems = RxList<Object>(<Object>[]);
  RxList<Vendor> suppliers = RxList<Vendor>(<Vendor>[]);
  OrderStats? orderStats;
  ShopStats? shopStats;
  ShopGraphData? shopGraph;
  ApiResponseModel? error;
  final GetStorage sandBox = GetStorage();

  Future<bool> initShop() async {
    final String uid = profileController.myProfile.uid;
    final dynamic cachedShop = sandBox.read('user_shop_$uid');
    if (cachedShop != null) {
      shop = Shop.fromMap(<String, dynamic>{
        ...cachedShop,
        'user': profileController.myProfile.toMap(),
      });
      loading.value = false;
      update();
    }

    try {
      final ApiResponseModel response = await ApiService.get(
        path: 'shops/user-shops/$uid',
      );

      if (!response.success || response.data['rows'].isEmpty) return false;

      final dynamic shopData = response.data['rows'][0];
      await sandBox.write('user_shop_$uid', shopData);

      shop = Shop.fromMap(<String, dynamic>{
        ...shopData,
        'user': profileController.myProfile.toMap(),
      });

      update();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> initShopData() async {
    try {
      final String uid = profileController.myProfile.uid;

      // Synchronously load shop from cache if possible
      final dynamic cachedShop = sandBox.read('user_shop_$uid');
      if (cachedShop != null) {
        shop = Shop.fromMap(<String, dynamic>{
          ...cachedShop,
          'user': profileController.myProfile.toMap(),
        });
      }

      // 🔥 Check cache first
      final dynamic cachedProducts = sandBox.read('user_products_$uid');
      final dynamic cachedServices = sandBox.read('user_services_$uid');
      final dynamic cachedCustomItems = sandBox.read('user_custom_items_$uid');
      final dynamic cachedVendors = sandBox.read('user_vendors_$uid');

      if (cachedProducts != null ||
          cachedServices != null ||
          cachedCustomItems != null ||
          cachedVendors != null) {
        _processCachedShopData(
            cachedProducts, cachedServices, cachedCustomItems, cachedVendors);
        loading.value = false;
        update();
      }

      final bool hasShop = await initShop();
      if (!hasShop) return false;

      // Fetch data in parallel
      final List<Future<ApiResponseModel>> requests =
          <Future<ApiResponseModel>>[
        ApiService.get(path: 'goods/user-products/$uid'),
        ApiService.get(path: 'services/user-services/$uid'),
        ApiService.get(path: 'custom-items/user/$uid'),
        ApiService.get(path: 'vendors/user/$uid'),
      ];

      final List<ApiResponseModel> responses = await Future.wait(requests);

      final ApiResponseModel productResponse = responses[0];
      final ApiResponseModel servicesResponse = responses[1];
      final ApiResponseModel customResponse = responses[2];
      final ApiResponseModel vendorsResponse = responses[3];

      // 🔥 Update cache
      if (productResponse.success) {
        await sandBox.write('user_products_$uid', productResponse.data);
      }
      if (servicesResponse.success) {
        await sandBox.write('user_services_$uid', servicesResponse.data);
      }
      if (customResponse.success) {
        await sandBox.write('user_custom_items_$uid', customResponse.data);
      }
      if (vendorsResponse.success) {
        await sandBox.write('user_vendors_$uid', vendorsResponse.data);
      }

      _processCachedShopData(
        productResponse.success ? productResponse.data : null,
        servicesResponse.success ? servicesResponse.data : null,
        customResponse.success ? customResponse.data : null,
        vendorsResponse.success ? vendorsResponse.data : null,
      );

      update();
      return true;
    } catch (e) {
      return false;
    }
  }

  void _processCachedShopData(dynamic productData, dynamic servicesData,
      dynamic customData, dynamic vendorsData) {
    // Map products
    if (productData != null) {
      products
        ..clear()
        ..addAll(
          _parseRowsFromData<Product>(
            data: productData,
            fromMap: (dynamic data) => Product.fromJson(data),
          ),
        );
    }

    // Map services
    if (servicesData != null) {
      services
        ..clear()
        ..addAll(
          _parseRowsFromData<Service>(
            data: servicesData,
            fromMap: (dynamic data) => Service.fromJson(data),
          ),
        );
    }

    // Map custom items
    if (customData != null) {
      customItems
        ..clear()
        ..addAll(
          _parseAnyListFromData<Customitem>(
            data: customData,
            fromMap: (dynamic data) => Customitem.fromJson(data),
          ),
        );
    }

    // Combine items and sort
    items
      ..clear()
      ..addAll(<Object>[...products, ...services, ...customItems])
      ..sort(
          (Object a, Object b) => _getCreatedAt(b).compareTo(_getCreatedAt(a)));

    // Map vendors
    if (vendorsData != null) {
      suppliers
        ..clear()
        ..addAll(
          _parseRowsFromData<Vendor>(
            data: vendorsData,
            fromMap: (dynamic data) => Vendor.fromMap(data),
          ),
        );
    }
  }

  List<T> _parseRowsFromData<T>({
    required dynamic data,
    required T Function(dynamic) fromMap,
  }) {
    if (data != null && data['rows'] is List) {
      return (data['rows'] as List<dynamic>)
          .map((dynamic item) => fromMap(item))
          .toList();
    }
    return <T>[];
  }

  List<T> _parseAnyListFromData<T>({
    required dynamic data,
    required T Function(dynamic) fromMap,
  }) {
    if (data != null && data is List) {
      return (data).map((dynamic item) => fromMap(item)).toList();
    }
    return <T>[];
  }

// Parse rows under 'data['rows']'

// Parse any List under data, useful for custom items

// Extract createdAt from different types
  DateTime _getCreatedAt(Object item) {
    if (item is Product) return item.createdAt;
    if (item is Service) return item.createdAt;
    if (item is Customitem) return item.createdAt;
    throw Exception('Unknown item type: $item');
  }

  Future<bool> initUserShop(UserModel user) async {
    try {
      userShop = null;
      userProducts.clear();
      userServices.clear();
      userCustomItems.clear();
      userItems.clear();

      // Fetch the shop
      final ApiResponseModel shopResponse = await ApiService.get(
        path: 'shops/user-shops/${user.uid}',
      );

      if (!shopResponse.success || shopResponse.data['rows'].isEmpty) {
        return false;
      }

      // Map and assign shop details
      final Map<String, dynamic> shopData = shopResponse.data['rows'][0];
      userShop = Shop.fromMap(<String, dynamic>{
        ...shopData,
        'user': user.toMap(),
      });

      // Fetch products, services, and custom items in parallel
      final List<Future<ApiResponseModel>> futures = <Future<ApiResponseModel>>[
        ApiService.get(path: 'goods/user-products/${user.uid}'),
        ApiService.get(path: 'services/user-services/${user.uid}'),
        ApiService.get(path: 'custom-items/user/${user.uid}'),
      ];

      final List<ApiResponseModel> responses = await Future.wait(futures);
      final ApiResponseModel productResponse = responses[0];
      final ApiResponseModel servicesResponse = responses[1];
      final ApiResponseModel customResponse = responses[2];

      // Assign products
      if (productResponse.success) {
        userProducts.addAll(
          (productResponse.data['rows'] as List<dynamic>)
              .map((dynamic item) => Product.fromJson(item))
              .where((Product product) => product.isActive),
        );
      }

      // Assign services
      if (servicesResponse.success) {
        userServices.addAll(
          (servicesResponse.data['rows'] as List<dynamic>)
              .map((dynamic item) => Service.fromJson(item))
              .where((Service service) => service.isActive),
        );
      }

      // Assign custom items
      if (customResponse.success) {
        userCustomItems.addAll(
          (customResponse.data as List<dynamic>)
              .map((dynamic item) => Customitem.fromJson(item)),
        );
      }

      // Combine and sort all items
      userItems.value = <Object>[
        ...userProducts,
        ...userServices,
        ...userCustomItems
      ];
      userItems.sort((Object a, Object b) =>
          getItemCreatedAt(b).compareTo(getItemCreatedAt(a)));
// Increment views asynchronously (don't block)
      ApiService.put(
        path: 'shops/${userShop!.id}',
        body: <String, dynamic>{'views': userShop!.views + 1},
      );
      return true; // Everything successful
    } catch (e) {
      return false;
    }
  }

// Helper to safely get createdAt for any item
  DateTime getItemCreatedAt(Object item) {
    if (item is Product) return item.createdAt;
    if (item is Service) return item.createdAt;
    if (item is Customitem) return item.createdAt;
    throw Exception('Unknown item type');
  }

  Future<bool> addShop(Map<String, dynamic> data) async {
    ApiResponseModel response =
        await ApiService.post(path: 'shops', body: data);
    if (response.success) {
      shop = Shop.fromMap(<String, dynamic>{
        ...response.data,
        'user': profileController.myProfile.toMap()
      });
      update();
      return true;
    } else {
      error = response;
      return false;
    }
  }

  Future<bool> updateShop(String id, Map<String, dynamic> data) async {
    ApiResponseModel response =
        await ApiService.put(path: 'shops/$id', body: data);
    if (response.success) {
      shop = Shop.fromMap(<String, dynamic>{
        ...response.data,
        'user': profileController.myProfile.toMap()
      });
      update();
      return true;
    } else {
      error = response;
      return false;
    }
  }

  Future<ProductAddResult> addProducts(Map<String, dynamic> data) async {
    ApiResponseModel response =
        await ApiService.post(path: 'goods', body: data);
    if (response.success) {
      products.add(Product.fromJson(response.data));
      items.add(Product.fromJson(response.data));
      marketController.proItems.add(Product.fromJson(response.data));
      marketController.proProducts.add(Product.fromJson(response.data));
      update();
      marketController.update();
      return ProductAddResult(
          success: true, product: Product.fromJson(response.data));
    } else {
      log(response.toMap().toString());
      return ProductAddResult(success: false);
    }
  }

  Future<bool> updateProduct(int id, Map<String, dynamic> data) async {
    ApiResponseModel response =
        await ApiService.put(path: 'goods/$id', body: data);
    if (response.success) {
      if (products.isNotEmpty) {
        final int productIndex =
            products.indexWhere((Product element) => element.id == id);
        products[productIndex] = Product.fromJson(response.data);
      }
      if (items.isNotEmpty) {
        final int objectIndex = items.indexWhere((Object element) {
          if (element is Product) return element.id == id;
          return false;
        });
        items[objectIndex] = Product.fromJson(response.data);
      }
      // Update in marketController
      final int proItemIndex = marketController.proItems
          .indexWhere((Object item) => item is Product && item.id == id);
      if (proItemIndex != -1) {
        marketController.proItems[proItemIndex] =
            Product.fromJson(response.data);
      }

      final int proProductIndex = marketController.proProducts
          .indexWhere((Product product) => product.id == id);
      if (proProductIndex != -1) {
        marketController.proProducts[proProductIndex] =
            Product.fromJson(response.data);
      }
      update();
      marketController.update();
      return true;
    } else {
      log(response.toMap().toString());
      return false;
    }
  }

  Future<ServiceAddResult> addService(Map<String, dynamic> data) async {
    ApiResponseModel response =
        await ApiService.post(path: 'services', body: data);
    if (response.success) {
      services.add(Service.fromJson(response.data));
      items.add(Service.fromJson(response.data));
      marketController.proItems.add(Service.fromJson(response.data));
      marketController.proServices.add(Service.fromJson(response.data));
      update();
      marketController.update();
      return ServiceAddResult(
          success: true, service: Service.fromJson(response.data));
    } else {
      log(response.toMap().toString());
      return ServiceAddResult(success: false);
    }
  }

  Future<bool> addCustomItem(Map<String, dynamic> data) async {
    ApiResponseModel response =
        await ApiService.post(path: 'custom-items', body: data);
    if (response.success) {
      customItems.add(Customitem.fromJson(response.data));
      items.add(Customitem.fromJson(response.data));
      update();
      return true;
    } else {
      log(response.toMap().toString());
      return false;
    }
  }

  Future<ApiResponseModel> shareEarn(dynamic postId, String type) async {
    Map<String, dynamic> data = <String, dynamic>{
      'postId': postId,
      'userId': profileController.myProfile.uid,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'type': type,
    };
    ApiResponseModel response =
        await ApiService.post(path: 'coins/listing', body: data);
    return response;
  }

  Future<bool> updateCustomItem(int id, Map<String, dynamic> data) async {
    ApiResponseModel response =
        await ApiService.put(path: 'custom-items/$id', body: data);
    if (response.success) {
      if (customItems.isNotEmpty) {
        final int itemIndex =
            customItems.indexWhere((Customitem element) => element.id == id);
        if (itemIndex != -1) {
          customItems[itemIndex] = Customitem.fromJson(response.data);
        }
      }
      // Update items list if not empty and valid index exists
      if (items.isNotEmpty) {
        final int objectIndex = items.indexWhere((Object element) {
          if (element is Customitem) return element.id == id;
          return false;
        });
        if (objectIndex != -1) {
          items[objectIndex] = Customitem.fromJson(response.data);
        }
      }
      final int proItemIndex = marketController.proItems
          .indexWhere((Object item) => item is Customitem && item.id == id);
      if (proItemIndex != -1) {
        marketController.proItems[proItemIndex] =
            Customitem.fromJson(response.data);
      }

      update();
      marketController.update();
      return true;
    } else {
      log(response.toMap().toString());
      return false;
    }
  }

  Future<bool> updateService(int id, Map<String, dynamic> data) async {
    ApiResponseModel response =
        await ApiService.put(path: 'services/$id', body: data);
    if (response.success) {
      if (services.isNotEmpty) {
        final int serviceIndex =
            services.indexWhere((Service element) => element.id == id);
        if (serviceIndex != -1) {
          services[serviceIndex] = Service.fromJson(response.data);
        }
      }
      // Update items list if not empty and index exists
      if (items.isNotEmpty) {
        final int objectIndex = items.indexWhere((Object element) {
          if (element is Service) return element.id == id;
          return false;
        });
        if (objectIndex != -1) {
          items[objectIndex] = Service.fromJson(response.data);
        }
      }
      final int proItemIndex = marketController.proItems
          .indexWhere((Object item) => item is Service && item.id == id);
      if (proItemIndex != -1) {
        marketController.proItems[proItemIndex] =
            Service.fromJson(response.data);
      }

      final int proServiceIndex = marketController.proServices
          .indexWhere((Service service) => service.id == id);
      if (proServiceIndex != -1) {
        marketController.proServices[proServiceIndex] =
            Service.fromJson(response.data);
      }
      update();
      marketController.update();
      return true;
    } else {
      log(response.toMap().toString());
      return false;
    }
  }

  Future<bool> addSupplier(Map<String, dynamic> data) async {
    ApiResponseModel response =
        await ApiService.post(path: 'vendors', body: data);
    if (response.success) {
      suppliers.add(Vendor.fromMap(response.data));
      update();
      return true;
    } else {
      log(response.toMap().toString());
      return false;
    }
  }

  Future<bool> updateSupplier(String id, Map<String, dynamic> data) async {
    ApiResponseModel response =
        await ApiService.put(path: 'vendors/$id', body: data);
    if (response.success) {
      final int vendorIndex =
          suppliers.indexWhere((Vendor element) => element.id == id);
      suppliers[vendorIndex] = Vendor.fromMap(response.data);
      update();
      return true;
    } else {
      log(response.toMap().toString());
      return false;
    }
  }

// Delete Product
  Future<bool> deleteProduct(int id) async {
    ApiResponseModel response = await ApiService.delete(path: 'goods/$id');
    if (response.success) {
      products.removeWhere((Product element) => element.id == id);
      items.removeWhere((Object element) =>
          element is Product &&
          element.id == id); // Remove from marketController lists
      marketController.proItems
          .removeWhere((Object item) => item is Product && item.id == id);
      marketController.proProducts
          .removeWhere((Product product) => product.id == id);
      update(); // Update the UI
      marketController.update();
      return true;
    } else {
      log(response.toMap().toString());
      return false;
    }
  }

// Delete Service
  Future<bool> deleteService(int id) async {
    ApiResponseModel response = await ApiService.delete(path: 'services/$id');
    if (response.success) {
      services.removeWhere((Service element) => element.id == id);
      items.removeWhere((Object element) =>
          element is Service &&
          element.id == id); // Remove from marketController lists
      marketController.proItems
          .removeWhere((Object item) => item is Service && item.id == id);
      marketController.proServices
          .removeWhere((Service service) => service.id == id);
      update(); // Update the UI
      marketController.update();
      return true;
    } else {
      log(response.toMap().toString());
      return false;
    }
  }

  // Delete Custom Item
  Future<bool> deleteCustomItem(int id) async {
    ApiResponseModel response =
        await ApiService.delete(path: 'custom-items/$id');
    if (response.success) {
      customItems.removeWhere((Customitem element) => element.id == id);
      items.removeWhere((Object element) =>
          element is Customitem &&
          element.id == id); // Remove from marketController lists
      update(); // Update the UI
      return true;
    } else {
      log(response.toMap().toString());
      return false;
    }
  }

// Delete Supplier
  Future<bool> deleteSupplier(String id) async {
    ApiResponseModel response = await ApiService.delete(path: 'vendors/$id');
    if (response.success) {
      suppliers.removeWhere((Vendor element) => element.id == id);
      update(); // Update the UI
      return true;
    } else {
      log(response.toMap().toString());
      return false;
    }
  }

  Future<void> loadStatistics() async {
    final String? shopId = shop?.id;
    if (shopId != null) {
      final dynamic cachedOrderStats = sandBox.read('order_stats_$shopId');
      final dynamic cachedShopStats =
          sandBox.read('shop_stats_${profileController.myProfile.uid}');
      final dynamic cachedShopGraph = sandBox.read('shop_graph_$shopId');

      if (cachedOrderStats != null) {
        orderStats = OrderStats.fromJson(cachedOrderStats);
      }
      if (cachedShopStats != null) {
        shopStats = ShopStats.fromMap(cachedShopStats);
      }
      if (cachedShopGraph != null) {
        shopGraph = ShopGraphData.fromJson(cachedShopGraph);
      }

      if (orderStats != null || shopStats != null || shopGraph != null) {
        loadingData(false);
        update();
      }
    }

    await loadOrderData();
    await loadShopData();
    await loadShopGraph();

    if (shop?.id != null) {
      if (orderStats != null) {
        await sandBox.write('order_stats_${shop!.id}', orderStats!.toJson());
      }
      if (shopStats != null) {
        await sandBox.write('shop_stats_${profileController.myProfile.uid}',
            shopStats!.toMap());
      }
      if (shopGraph != null) {
        await sandBox.write('shop_graph_${shop!.id}', shopGraph!.toJson());
      }
    }

    loadingData(false);
    update();
  }

  Future<void> loadOrderData({String? date}) async {
    ApiResponseModel ordersResponse;
    if (date != null) {
      ordersResponse = await ApiService.get(
        path: 'dashboard/shop-orders/${shop?.id}?date=$date',
      );
    } else {
      ordersResponse = await ApiService.get(
        path: 'dashboard/shop-orders/${shop?.id}',
      );
    }
    if (ordersResponse.success) {
      orderStats = OrderStats.fromJson(ordersResponse.data);
    }
  }

  Future<void> loadShopData() async {
    ApiResponseModel shopDataResponse = await ApiService.get(
      path: 'dashboard/shop-statistics/${profileController.myProfile.uid}',
    );
    if (shopDataResponse.success) {
      shopStats = ShopStats.fromMap(shopDataResponse.data);
    }
  }

  Future<void> loadShopGraph({String? date}) async {
    ApiResponseModel shopGraphResponse;
    if (date != null) {
      shopGraphResponse = await ApiService.get(
        path: 'dashboard/shop-graph-data/${shop?.id}?date=$date',
      );
    } else {
      shopGraphResponse = await ApiService.get(
        path: 'dashboard/shop-graph-data/${shop?.id}',
      );
    }
    if (shopGraphResponse.success) {
      shopGraph = ShopGraphData.fromJson(shopGraphResponse.data);
    }
  }

  Future<void> filterData(String date) async {
    loadingData(true);
    update();
    if (date == 'all_time') {
      await loadOrderData();
      await loadShopGraph();
    } else {
      await loadOrderData(date: date);
      await loadShopGraph(date: date);
    }
    loadingData(false);
    update();
  }
}

class ProductAddResult {
  final bool success;
  final Product? product; // Change to String? if using Firebase document ID

  ProductAddResult({required this.success, this.product});
}

class ServiceAddResult {
  final bool success;
  final Service? service; // Change to String? if using Firebase document ID

  ServiceAddResult({required this.success, this.service});
}
