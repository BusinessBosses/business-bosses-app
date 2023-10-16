import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/utils/validators/validator.dart';
import 'package:business_bosses_v2/utils/constants/constants.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../navigation/routes.dart';

/// SERVER BASE URL
// const String {Constants.baseUrl} = 'https://businessbosses-api.vercel.app/api/v1';
// const String {Constants.baseUrl} = 'http://192.168.1.176:3000/api/v1';

/// LOCAL STORAGE SANDBOX
final GetStorage sandBox = GetStorage();

/// API CALLS

class MediaUploadResult {
  final String videoUrl;
  final String thumbnailUrl;

  MediaUploadResult(this.videoUrl, this.thumbnailUrl);
}

class MediaUploadException implements Exception {
  final String message;
  MediaUploadException(this.message);
}

class ApiService {
  /// LOGIN POINT
  Future<dynamic> login(String email, String password) async {
    /// Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> data = <String, dynamic>{
      'email': email,
      'password': password,
    };
    final http.Response response = await http.post(
      Uri.parse('${Constants.baseUrl}/auth/sign-in'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      final dynamic jsonResponse = json.decode(response.body);
      await sandBox.write(
          Constants.ACCESS_TOKEN, jsonResponse['data']['accessToken']);
      await prefs.setString(
          Constants.USER_ID, jsonResponse['data']['uid'].toString());
      // sandBox.write(Constants.USER_ID, jsonResponse['data']['uid'].toString());
      return jsonResponse;
    } else {
      final dynamic jsonResponse = json.decode(response.body);
      return jsonResponse;
    }
  }

  // LOGIN POINT
  Future<dynamic> googleLogin(String email, String token) async {
    /// Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> data = <String, dynamic>{
      'email': email,
      'token': token,
    };
    final http.Response response = await http.post(
      Uri.parse('${Constants.baseUrl}/auth/google-sign-in'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      final dynamic jsonResponse = json.decode(response.body);
      await sandBox.write(
          Constants.ACCESS_TOKEN, jsonResponse['data']['accessToken']);
      await prefs.setString(
          Constants.USER_ID, jsonResponse['data']['uid'].toString());
      // sandBox.write(Constants.USER_ID, jsonResponse['data']['uid'].toString());
      return jsonResponse;
    } else {
      final dynamic jsonResponse = json.decode(response.body);
      return jsonResponse;
    }
  }

  /// UPLOAD FILE
  static Future<dynamic> uploadFile(File image) async {
    String uploadUrl = 'http://44.210.87.234/upload.php';
    http.MultipartRequest request =
        http.MultipartRequest('POST', Uri.parse(uploadUrl));
    request.files.add(await http.MultipartFile.fromPath('file', image.path));
    print("image url ========${image.path}");
    try {
      final http.StreamedResponse streamedResponse = await request.send();

      Map<dynamic, dynamic> result =
          json.decode(await streamedResponse.stream.bytesToString());
      if (result['success']) {
        return result;
      } else {
        showSnackbar(
            title: 'OOPS!',
            message: 'An error occurred, please try again!',
            error: true);
        return null;
      }
    } catch (e) {
      showSnackbar(
          title: 'OOPS!',
          message: 'An error occurred, please try again!',
          error: true);
      return null;
    }
  }

  /// UPLOAD FILE
  static Future<MediaUploadResult> uploadMediaFiles(
      File video, File thumbnail) async {
    String uploadUrl = 'http://44.210.87.234/upload-video.php';
    http.MultipartRequest request =
        http.MultipartRequest('POST', Uri.parse(uploadUrl));
    request.files.add(await http.MultipartFile.fromPath('video', video.path));
    request.files
        .add(await http.MultipartFile.fromPath('thumbnail', thumbnail.path));
    try {
      final http.StreamedResponse streamedResponse = await request.send();

      Map<dynamic, dynamic> result =
          json.decode(await streamedResponse.stream.bytesToString());
      if (result['success']) {
        final videoUrl = result['video_url'];
        final thumbnailUrl = result['thumbnail_url'];
        return MediaUploadResult(videoUrl, thumbnailUrl);
      } else {
        showSnackbar(
            title: 'OOPS!',
            message: 'An error occurred, please try again!',
            error: true);
        throw MediaUploadException('Upload failed: ${result['error']}');
      }
    } catch (e) {
      showSnackbar(
          title: 'OOPS!',
          message: 'An error occurred, please try again!',
          error: true);
      throw MediaUploadException('An error occurred during media upload: $e');
    }
  }

  /// LOGIN POINT
  Future<dynamic> register(
      String email, String password, String username, String? inviteId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> data = <String, dynamic>{
      'username': username,
      'email': email,
      'password': password,
      'inviteId': inviteId
    };
    final http.Response response = await http.post(
      Uri.parse('${Constants.baseUrl}/auth/sign-up'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode == 201) {
      final dynamic jsonResponse = json.decode(response.body);
      sandBox.write(
          Constants.ACCESS_TOKEN, jsonResponse['data']['accessToken']);
      await prefs.setString(
          Constants.USER_ID, jsonResponse['data']['uid'].toString());
      return jsonResponse;
    } else {
      final dynamic jsonResponse = json.decode(response.body);
      return jsonResponse;
    }
  }

  /// CHANGE PASSWORD
  Future<dynamic> changePassword(String email, String password) async {
    Map<String, dynamic> data = <String, dynamic>{
      'email': email,
      'newPassword': password,
    };
    final http.Response response = await http.post(
      Uri.parse('${Constants.baseUrl}/auth/reset-password'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      final dynamic jsonResponse = json.decode(response.body);
      return jsonResponse;
    } else {
      final dynamic jsonResponse = json.decode(response.body);
      return jsonResponse;
    }
  }

  // Future<String?> checkIfEmailExist (String email) async {
  //   final ApiResponseModel response = await
  // }

  /// VERIFY USERNAME OR EMAIL DURING SIGNUP
  Future<bool?> verifyUnique(String username, String email) async {
    Map<String, dynamic> data = <String, dynamic>{
      'username': username,
      'email': email,
    };
    final http.Response response = await http.post(
      Uri.parse('${Constants.baseUrl}/auth/email-exist'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      dynamic jsonResponse = json.decode(response.body);
      jsonResponse = jsonResponse['success'];
      if (username == '') {
        dynamic response =
            Validator.emailValidatorExists(email, isUnique: jsonResponse);
        return response;
      }
      return jsonResponse;
    } else {
      dynamic jsonResponse = json.decode(response.body);
      jsonResponse = jsonResponse['success'];
      return jsonResponse;
    }
  }

  ///LOGOUT
  Future<void> logout() async {
    await get(path: 'auth/logout');
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await sandBox.remove(Constants.ACCESS_TOKEN);
    await prefs.remove(Constants.USER_ID);
    Get.offAllNamed(Routes.login);
  }

  /// HTTP POST CALL
  static Future<ApiResponseModel> post({
    required String path,
    required Map<String, dynamic> body,
    dynamic data,
  }) async {
    // log(body.toString());
    final String token = sandBox.read(Constants.ACCESS_TOKEN);
    // log(token);
    try {
      final http.Response response = await http.post(
        Uri.parse('${Constants.baseUrl}/$path'),
        body: jsonEncode(body),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'bearer $token'
        },
      );
      log(response.body);
      return ApiResponseModel.fromMap(jsonDecode(response.body));
    } catch (e) {
      showSnackbar(
          title: 'OOPS!',
          message: 'An error occurred, please try again!',
          error: true);
      return ApiResponseModel(
          success: false, message: e.toString(), data: <dynamic, dynamic>{});
    }
  }

  /// HTTP GET CALL
  static Future<ApiResponseModel> get({
    required String path,
  }) async {
    final String? token = sandBox.read(Constants.ACCESS_TOKEN);
    log(token ?? '');
    try {
      final http.Response response = await http.get(
        Uri.parse('${Constants.baseUrl}/$path'),
        headers: <String, String>{
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'bearer $token'
        },
      );

      log(response.body.toString());

      return ApiResponseModel.fromMap(jsonDecode(response.body));
    } catch (e) {
      // showSnackbar(
      //     title: 'OOPS!',
      //     message: 'An error occurred, please try again!',
      //     error: true);
      return ApiResponseModel(
          success: false, message: e.toString(), data: <dynamic, dynamic>{});
    }
  }

  /// HTTP PUT CALL
  static Future<ApiResponseModel> put({
    required String path,
    required Map<String, dynamic> body,
  }) async {
    final String token = sandBox.read(Constants.ACCESS_TOKEN);
    try {
      final http.Response response = await http.put(
        Uri.parse('${Constants.baseUrl}/$path'),
        body: jsonEncode(body),
        headers: <String, String>{
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'bearer $token'
        },
      );

      log(response.body);

      return ApiResponseModel.fromMap(jsonDecode(response.body));
    } catch (e) {
      // showSnackbar(
      //     title: 'OOPS!',
      //     message: 'An error occurred, please try again!',
      //     error: true);
      return ApiResponseModel(
          success: false, message: e.toString(), data: <dynamic, dynamic>{});
    }
  }

  /// HTTP DELETE CALL
  static Future<ApiResponseModel> delete({
    required String path,
  }) async {
    final String token = sandBox.read(Constants.ACCESS_TOKEN);
    try {
      final http.Response response = await http.delete(
        Uri.parse('${Constants.baseUrl}/$path'),
        headers: <String, String>{
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'bearer $token'
        },
      );
      log(response.body);
      return ApiResponseModel.fromMap(jsonDecode(response.body));
    } catch (e) {
      showSnackbar(
          title: 'OOPS!',
          message: 'An error occurred, please try again!',
          error: true);
      return ApiResponseModel(
          success: false, message: e.toString(), data: <dynamic, dynamic>{});
    }
  }
}

/// Add Subscription
Future<dynamic> addSubscription(
    String plan, String price, bool isSubscribed) async {
  Map<String, dynamic> data = <String, dynamic>{
    'plan': plan,
    'price': price,
    'isSubscribed': isSubscribed
  };
  final http.Response response = await http.post(
    Uri.parse('${Constants.baseUrl}/subscription'),
    headers: <String, String>{'Content-Type': 'application/json'},
    body: jsonEncode(data),
  );
  if (response.statusCode == 200) {
    final dynamic jsonResponse = json.decode(response.body);
    return jsonResponse;
  } else {
    final dynamic jsonResponse = json.decode(response.body);
    return jsonResponse;
  }
}
