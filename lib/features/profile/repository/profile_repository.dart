import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/services/api_service.dart';

class ProfileRepository {
  /// GET ALL POSTS LIMITED TO A SPECIFIC SIZE
  static Future<ApiResponseModel> fetchData(
      int page, int size, String userId) async {
    final ApiResponseModel response = await ApiService.get(
        path: 'post/get-user-posts/$userId?page=$page&size=$size');
    return response;
  }

  static Future<ApiResponseModel> fetchUserMarket(
      int page, int size, String userId) async {
    final ApiResponseModel response = await ApiService.get(
        path: 'markets/user/$userId?page=$page&size=$size');
    return response;
  }

  /// GET BOSS OF THE WEEK
  static Future<ApiResponseModel> fetchBoss() async {
    final ApiResponseModel response =
        await ApiService.get(path: 'users/bossup');
    return response;
  }
}
