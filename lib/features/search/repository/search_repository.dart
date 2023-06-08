import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/services/api_service.dart';

class SearchRepository {
  static Future<ApiResponseModel> getData(int page) async {
    final ApiResponseModel response =
        await ApiService.get(path: '/users?page=$page&size=100');

    return response;
  }

  static Future<ApiResponseModel> searchUsers(String query) async {
    final ApiResponseModel response =
        await ApiService.get(path: '/users/name/$query');

    return response;
  }

  static Future<ApiResponseModel> searchPosts(String query) async {
    final ApiResponseModel response =
        await ApiService.get(path: '/post/search/$query');

    return response;
  }
}
