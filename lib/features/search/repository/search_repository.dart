import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/services/api_service.dart';

class SearchRepository {
  static Future<ApiResponseModel> getData({String? title, int page = 0}) async {
    String path = '/search/get-recommended-data-with-category?page=$page';

    if (title != null && title.isNotEmpty) {
      path += '&title=$title';
    }

    final ApiResponseModel response = await ApiService.get(path: path);
    return response;
  }
  // static Future<ApiResponseModel> searchUsers(String query) async {
  //   final ApiResponseModel response =
  //       await ApiService.get(path: '/users/name/$query');

  //   return response;
  // }

  // static Future<ApiResponseModel> searchPosts(String query) async {
  // String searchQuery = '';
  // if (query.contains('#')) {
  //   searchQuery = '%23${query.split('#')[1]}';
  // } else {
  //   searchQuery = query;
  // }
  // final ApiResponseModel response =
  //     await ApiService.get(path: 'post/search/$searchQuery');

  // return response;
  // }

  static Future<ApiResponseModel> search(String query) async {
    String searchQuery = '';
    if (query.contains('#')) {
      searchQuery = '%23${query.split('#')[1]}';
    } else {
      searchQuery = query;
    }
    final ApiResponseModel response =
        await ApiService.get(path: 'search/$searchQuery');

    return response;
  }
}
