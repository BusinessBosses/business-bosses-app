import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/profile/presentation/update_profile_screen.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:business_bosses_v2/utils/constants/constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  /// LOGIN REPOSITORY
  static Future<void> login(Map<String, dynamic> body) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final ApiResponseModel response =
        await ApiService.post(path: 'auth/sign-in', body: body);
    if (response.success) {
      await prefs.setString(
          Constants.ACCESS_TOKEN, response.data['accessToken']);
      await prefs.setString(Constants.USER_ID, response.data['uid'].toString());

      if (response.data['hasUpdatedProfile']) {
        Get.toNamed(Routes.marketPlace);
      } else {
        Get.off(
            () => UpdateProfileScreen(user: UserModel.fromMap(response.data)));
      }
    } else {
      throw 'Check login repository';
    }
  }
}
