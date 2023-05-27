import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/services/api_service.dart';

class PostRepository {
  /// GET ALL POSTS LIMITED TO A SPECIFIC SIZE
  static Future<ApiResponseModel> fetchPosts(int page, int size) async {
    final ApiResponseModel response =
        await ApiService.get(path: 'post/get-posts?page=$page&size=$size');
    return response;
  }

  /// CREATE POST REPOSITORY
  static Future<ApiResponseModel> createPost(Map<String, dynamic> body) async {
    final ApiResponseModel response =
        await ApiService.post(path: 'post/create-post', body: body);

    return response;
  }
}
