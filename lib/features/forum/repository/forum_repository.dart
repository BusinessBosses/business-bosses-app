import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/services/api_service.dart';

class ForumRepository {
  static Future<ApiResponseModel> getForums(int page, String industryId) async {
    final ApiResponseModel response = await ApiService.get(
        path: 'forum/get-industry-forums/$industryId?size=100&page=$page');
    return response;
  }

  static Future<ApiResponseModel> getForum(String id) async {
    final ApiResponseModel response =
        await ApiService.get(path: 'forum/get/$id');
    return response;
  }

  static Future<ApiResponseModel> getForumMembers(
      int page, String industryId) async {
    final ApiResponseModel response = await ApiService.get(
        path: 'industry/get-joined-users/$industryId?size=1000&page=$page');
    return response;
  }

  /// CREATE POST REPOSITORY
  static Future<ApiResponseModel> createForum(Map<String, dynamic> body) async {
    final ApiResponseModel response =
        await ApiService.post(path: 'forum/create', body: body);

    return response;
  }

  /// DELETE FORUM
  static Future<ApiResponseModel> deleteForum(String forumId) async {
    final ApiResponseModel response = await ApiService.delete(
      path: 'forum/delete/$forumId',
    );

    return response;
  }

  /// EDIT POST REPOSITORY
  static Future<ApiResponseModel> editForum(Map<String, dynamic> body) async {
    final ApiResponseModel response = await ApiService.put(
        path: 'forum/update/${body['forumId']}', body: body);

    return response;
  }

  /// CREATE POST REPOSITORY
  static Future<ApiResponseModel> createMarket(
      Map<String, dynamic> body) async {
    final ApiResponseModel response =
        await ApiService.post(path: 'markets', body: body);

    return response;
  }

  /// EDIT FORUM REPOSITORY
  static Future<ApiResponseModel> editListing(Map<String, dynamic> body) async {
    final ApiResponseModel response =
        await ApiService.put(path: 'markets/${body['marketId']}', body: body);

    return response;
  }
}
