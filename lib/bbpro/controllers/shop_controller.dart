import 'dart:developer';

import 'package:business_bosses_v2/bbpro/models/order_stats_model.dart';
import 'package:business_bosses_v2/bbpro/models/product_model.dart';
import 'package:business_bosses_v2/bbpro/models/service_model.dart';
import 'package:business_bosses_v2/bbpro/models/shop_model.dart';
import 'package:business_bosses_v2/bbpro/models/supplier_model.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:get/get.dart';

class ShopController extends GetxController {
  final ProfileController profileController = Get.find();
  Shop? shop;
  RxBool loading = RxBool(true);
  RxList<Product> products = RxList<Product>(<Product>[]);
  RxList<Service> services = RxList<Service>(<Service>[]);
  RxList<Vendor> suppliers = RxList<Vendor>(<Vendor>[]);
  OrderStats? orderStats;

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
      }
    } else {
      return false;
    }
    if (response.data['rows'].isNotEmpty) {
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

      ApiResponseModel vendorsReponse = await ApiService.get(
        path: 'vendors/user/${profileController.myProfile.uid}',
      );
      suppliers.clear();
      if (vendorsReponse.success) {
        for (int i = 0; i < vendorsReponse.data['rows'].length; i++) {
          suppliers.add(Vendor.fromMap(vendorsReponse.data['rows'][i]));
        }
      }
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
      return false;
    }
  }

  Future<bool> addProducts(Map<String, dynamic> data) async {
    ApiResponseModel response =
        await ApiService.post(path: 'goods', body: data);
    if (response.success) {
      products.add(Product.fromJson(response.data));
      update();
      return true;
    } else {
      log(response.toMap().toString());
      return false;
    }
  }

  Future<bool> updateProduct(int id, Map<String, dynamic> data) async {
    ApiResponseModel response =
        await ApiService.put(path: 'goods/$id', body: data);
    if (response.success) {
      final int productIndex =
          products.indexWhere((Product element) => element.id == id);
      products[productIndex] = Product.fromJson(response.data);
      update();
      return true;
    } else {
      log(response.toMap().toString());
      return false;
    }
  }

  Future<bool> addService(Map<String, dynamic> data) async {
    ApiResponseModel response =
        await ApiService.post(path: 'services', body: data);
    if (response.success) {
      services.add(Service.fromJson(response.data));
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
    ApiResponseModel ordersResponse = await ApiService.get(
      path: 'dashboard/shop-orders/${shop?.id}',
    );
    if (ordersResponse.success) {
      for (int i = 0; i < ordersResponse.data['rows'].length; i++) {
        orderStats = OrderStats.fromJson(ordersResponse.data);
      }
    }
  }
}
