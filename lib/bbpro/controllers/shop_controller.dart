import 'package:business_bosses_v2/bbpro/models/shop_model.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:get/get.dart';

class ShopController extends GetxController {
  final ProfileController profileController = Get.find();
  Shop? shop;
  RxBool loading = RxBool(true);

  Future<bool> initShop() async {
    ApiResponseModel response = await ApiService.get(
      path: 'shops/user-shops/${profileController.myProfile.uid}',
    );
    if (response.success) {
      shop = Shop.fromMap(response.data['rows'][0]);
      if (response.data['rows'][0] != null) {
      } else {
        loading(false);
        update();
        return false;
      }
    } else {
      loading(false);
      update();
      return false;
    }
    loading(false);
    update();
    if (response.data['rows'][0] != null) {
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
}
