
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:business_bosses_v2/utils/constants/constants.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthRepository {
  /// LOGIN REPOSITORY
  static Future<void> login(Map<String, dynamic> body) async {
    final GetStorage sandBox = GetStorage();
    final ApiResponseModel response =
        await ApiService.post(path: '/auth/sign-in', body: body);
    if (response.success) {
      sandBox.write(Constants.ACCESS_TOKEN, response.data['accessToken']);
      if (response.data['hasUpdatedProfile']) {
        Get.toNamed(Routes.bottomNavigation);
      } else {
        Get.toNamed(Routes.updateProfile, arguments: response.data);
      }
    } else {
      throw 'Check login repository';
    }
  }
}
