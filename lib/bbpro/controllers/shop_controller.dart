import 'package:business_bosses_v2/bbpro/models/shop_model.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:get/get.dart';

class ShopController extends GetxController {
  final ProfileController profileController = Get.find();
  RxList<Shop> shops = RxList<Shop>(<Shop>[]);
  RxBool loading = RxBool(true);

  Future<bool> initShop() async {
    ApiResponseModel response = await ApiService.get(
      path: 'shops/user-shops/${profileController.myProfile.uid}',
    );
    if (response.success) {
      for (int i = 0; i < response.data['rows'].length; i++) {
        shops.add(Shop.fromMap(response.data['rows'][i]));
      }
    }
    loading(false);
    if (shops.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> addShop(Map<String, dynamic> data) async {
    ApiResponseModel response =
        await ApiService.post(path: 'shops', body: data);
    if (response.success) {
      return true;
    } else {
      return false;
    }
  }
}
