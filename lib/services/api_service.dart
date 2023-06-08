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
class ApiService {
  /// LOGIN POINT
  Future<dynamic> login(String email, String password) async {
    /// Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> data = {
      'email': email,
      'password': password,
    };
    final http.Response response = await http.post(
      Uri.parse('${Constants.baseUrl}/auth/sign-in'),
      headers: {'Content-Type': 'application/json'},
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

  /// LOGIN POINT
  Future<dynamic> register(
      String email, String password, String username, String? inviteId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> data = {
      'username': username,
      'email': email,
      'password': password,
      'inviteId': inviteId
    };
    final http.Response response = await http.post(
      Uri.parse('${Constants.baseUrl}/auth/sign-up'),
      headers: {'Content-Type': 'application/json'},
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
    Map<String, dynamic> data = {
      'email': email,
      'newPassword': password,
    };
    final http.Response response = await http.post(
      Uri.parse('${Constants.baseUrl}/auth/reset-password'),
      headers: {'Content-Type': 'application/json'},
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

  /// VERIFY USERNAME OR EMAIL DURING SIGNUP
  Future<bool?> verifyUnique(String username, String email) async {
    Map<String, dynamic> data = {
      'username': username,
      'email': email,
    };
    final http.Response response = await http.post(
      Uri.parse('${Constants.baseUrl}/auth/email-exist'),
      headers: {'Content-Type': 'application/json'},
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
      throw e.toString();
    }
  }

  /// HTTP GET CALL
  static Future<ApiResponseModel> get({
    required String path,
  }) async {
    final String? token = sandBox.read(Constants.ACCESS_TOKEN);
    log(token!);
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
      rethrow;
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
      log(response.body.toString());

      return ApiResponseModel.fromMap(jsonDecode(response.body));
    } catch (e) {
      throw e.toString();
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
      throw e.toString();
    }
  }
}
