import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:get/get.dart';

class ShopController extends GetxController {
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
