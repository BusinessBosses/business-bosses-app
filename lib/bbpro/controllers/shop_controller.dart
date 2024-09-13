import 'package:business_bosses_v2/bbpro/models/product_model.dart';
import 'package:business_bosses_v2/bbpro/models/service_model.dart';
import 'package:business_bosses_v2/bbpro/models/shop_model.dart';
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

  Future<bool> initShop() async {
    ApiResponseModel response = await ApiService.get(
      path: 'shops/user-shops/${profileController.myProfile.uid}',
    );
    if (response.success) {
      if (response.data['rows'].isEmpty) {
        loading(false);
        update();
        return false;
      } else {
        shop = Shop.fromMap(response.data['rows'][0]);
      }
    } else {
      loading(false);
      update();
      return false;
    }
    if (response.data['rows'].isNotEmpty) {
      ApiResponseModel productResponse = await ApiService.get(
        path: 'goods/user-products/${profileController.myProfile.uid}',
      );
      if (productResponse.success) {
        for (int i = 0; i < productResponse.data['rows'].length; i++) {
          products.add(Product.fromJson(productResponse.data['rows'][i]));
        }
      }
      ApiResponseModel servicesResponse = await ApiService.get(
        path: 'services/user-services/${profileController.myProfile.uid}',
      );
      if (servicesResponse.success) {
        for (int i = 0; i < servicesResponse.data['rows'].length; i++) {
          services.add(Service.fromJson(servicesResponse.data['rows'][i]));
        }
      }
      loading(false);
      update();
      return true;
    } else {
      loading(false);
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
      return true;
    } else {
      return false;
    }
  }
}
