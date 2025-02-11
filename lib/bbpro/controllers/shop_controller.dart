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

class ShopController extends GetxController {
  final ProfileController profileController = Get.put(ProfileController());
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

  Future<bool> initShop() async {
    ApiResponseModel response = await ApiService.get(
      path: 'shops/user-shops/${profileController.myProfile.uid}',
    );
    if (response.success) {
      if (response.data['rows'].isEmpty) {
        return false;
      } else {
        shop = Shop.fromMap(<String, dynamic>{
          ...response.data['rows'][0],
          'user': profileController.myProfile.toMap()
        });
        update();
        return true;
      }
    } else {
      return false;
    }
  }

  Future<bool> initShopData() async {
    final bool response = await initShop();
    if (response) {
      ApiResponseModel productResponse = await ApiService.get(
        path: 'goods/user-products/${profileController.myProfile.uid}',
      );
      products.clear();
      if (productResponse.success) {
        for (int i = 0; i < productResponse.data['rows'].length; i++) {
          products.add(Product.fromJson(productResponse.data['rows'][i]));
        }
      }
      ApiResponseModel servicesResponse = await ApiService.get(
        path: 'services/user-services/${profileController.myProfile.uid}',
      );
      services.clear();
      if (servicesResponse.success) {
        for (int i = 0; i < servicesResponse.data['rows'].length; i++) {
          services.add(Service.fromJson(servicesResponse.data['rows'][i]));
        }
      }
      ApiResponseModel customReponse = await ApiService.get(
        path: 'custom-items/user/${profileController.myProfile.uid}',
      );
      customItems.clear();
      if (customReponse.success) {
        if (customReponse.data.isNotEmpty) {
          for (int i = 0; i < customReponse.data.length; i++) {
            customItems.add(Customitem.fromJson(customReponse.data[i]));
          }
        }
      }
      items.clear();
      items.addAll(<Object>[...products, ...services, ...customItems]);
      items.sort((Object a, Object b) {
        // Assuming both Product and Service have a createdAt property.
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
        return bDate.compareTo(aDate);
      });

      ApiResponseModel vendorsReponse = await ApiService.get(
        path: 'vendors/user/${profileController.myProfile.uid}',
      );
      suppliers.clear();
      if (vendorsReponse.success) {
        for (int i = 0; i < vendorsReponse.data['rows'].length; i++) {
          suppliers.add(Vendor.fromMap(vendorsReponse.data['rows'][i]));
        }
      }
      update();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> initUserShop(UserModel user) async {
    userShop = null;
    ApiResponseModel response = await ApiService.get(
      path: 'shops/user-shops/${user.uid}',
    );
    if (response.success) {
      if (response.data['rows'].isEmpty) {
        return false;
      } else {
        userShop = Shop.fromMap(<String, dynamic>{
          ...response.data['rows'][0],
          'user': user.toMap()
        });
        ApiService.put(
          path: 'shops/${userShop!.id}',
          body: <String, dynamic>{
            'views': userShop!.views + 1,
          },
        );
      }
    } else {
      return false;
    }
    if (response.data['rows'].isNotEmpty) {
      ApiResponseModel productResponse = await ApiService.get(
        path: 'goods/user-products/${user.uid}',
      );
      userProducts.clear();
      if (productResponse.success) {
        for (int i = 0; i < productResponse.data['rows'].length; i++) {
          userProducts.add(Product.fromJson(productResponse.data['rows'][i]));
        }
      }
      ApiResponseModel servicesResponse = await ApiService.get(
        path: 'services/user-services/${user.uid}',
      );
      userServices.clear();
      if (servicesResponse.success) {
        for (int i = 0; i < servicesResponse.data['rows'].length; i++) {
          userServices.add(Service.fromJson(servicesResponse.data['rows'][i]));
        }
      }
      ApiResponseModel customResponse = await ApiService.get(
        path: 'custom-items/user/${user.uid}',
      );
      userCustomItems.clear();
      if (customResponse.success) {
        for (int i = 0; i < customResponse.data.length; i++) {
          userCustomItems.add(Customitem.fromJson(customResponse.data[i]));
        }
      }
      userItems.clear();
      userItems.addAll(<Object>[
        ...userProducts.where((Product item) => item.isActive).toList(),
        ...userServices.where((Service item) => item.isActive).toList(),
        ...userCustomItems,
      ]);
      userItems.sort((Object a, Object b) {
        // Assuming both Product and Service have a createdAt property.
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
        return bDate.compareTo(aDate);
      });

      return true;
    } else {
      return false;
    }
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
      final int productIndex =
          products.indexWhere((Product element) => element.id == id);
      products[productIndex] = Product.fromJson(response.data);
      final int objectIndex = items.indexWhere((Object element) {
        if (element is Product) return element.id == id;
        return false;
      });
      items[objectIndex] = Product.fromJson(response.data);
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

  Future<bool> updateCustomItem(int id, Map<String, dynamic> data) async {
    ApiResponseModel response =
        await ApiService.put(path: 'custom-items/$id', body: data);
    if (response.success) {
      final int itemIndex =
          customItems.indexWhere((Customitem element) => element.id == id);
      customItems[itemIndex] = Customitem.fromJson(response.data);
      final int objectIndex = items.indexWhere((Object element) {
        if (element is Customitem) return element.id == id;
        return false;
      });
      items[objectIndex] = Customitem.fromJson(response.data);

      final int proItemIndex = marketController.proItems
          .indexWhere((Object item) => item is Customitem && item.id == id);
      if (proItemIndex != -1) {
        marketController.proItems[proItemIndex] =
            Customitem.fromJson(response.data);
      }

      update();
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
      final int serviceIndex =
          services.indexWhere((Service element) => element.id == id);
      services[serviceIndex] = Service.fromJson(response.data);
      final int objectIndex = items.indexWhere((Object element) {
        if (element is Service) return element.id == id;
        return false;
      });
      items[objectIndex] = Service.fromJson(response.data);

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
    await loadOrderData();
    await loadShopData();
    await loadShopGraph();
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
