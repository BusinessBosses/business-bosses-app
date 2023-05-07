import 'dart:convert';
import 'dart:io';

import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:http/http.dart' as http;

class PostRepository {
  /// GET ALL POSTS LIMITED TO A SPECIFIC SIZE
  static Future<ApiResponseModel> fetchPosts(int page, int size) async {
    final ApiResponseModel response =
        await ApiService.get(path: '/post/get-posts?page=$page&size=$size');
    return response;
  }

  /// CREATE POST REPOSITORY
  static Future<ApiResponseModel> createPost(Map<String, dynamic> body) async {
    final ApiResponseModel response =
        await ApiService.post(path: '/post/create-post', body: body);

    return response;
  }

  static Future<dynamic> uploadFile(File image) async {
    String uploadUrl = 'http://44.210.87.234/upload.php';
    http.MultipartRequest request =
        http.MultipartRequest('POST', Uri.parse(uploadUrl));
    request.files.add(await http.MultipartFile.fromPath('file', image.path));
    try {
      final http.StreamedResponse streamedResponse = await request.send();

      Map<dynamic, dynamic> result =
          json.decode(await streamedResponse.stream.bytesToString());
      if (result['success']) {
        return result;
      } else {
        showSnackbar(message: result['message'], title: 'Error Occured');
        return null;
      }
    } catch (e) {
      showSnackbar(message: e.toString());
      return null;
    }
  }
}
