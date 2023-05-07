import 'dart:convert';

import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/utils/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../common/models/user_model.dart';
import '../navigation/routes.dart';

/// SERVER BASE URL
const String baseUrl = 'https://businessbosses-api.vercel.app/api/v1';

/// LOCAL STORAGE SANDBOX
final GetStorage sandBox = GetStorage();

/// API CALLS
class ApiService {
  /// LOGIN POINT
  // Future<dynamic> login(String email, String password) async {
  //   final http.Response response = await http.post(
  //     Uri.parse('$baseUrl/auth/sign-in'),
  //     headers: {'Content-Type': 'application/x-www-form-urlencoded'},
  //     body: <String, String>{'email': email, 'password': password},
  //   );
  //   if (response.statusCode == 200) {
  //     final jsonResponse = json.decode(response.body);
  //     sandBox.write(
  //         Constants.ACCESS_TOKEN, jsonResponse['data']['accessToken']);
  //     Get.toNamed(Routes.bottomNavigation);
  //     debugPrint(sandBox.read(Constants.ACCESS_TOKEN));
  //     return jsonResponse;
  //   } else {
  //     final jsonResponse = response.body;
  //     debugPrint(jsonResponse);
  //     return;
  //   }
  // }

  ///LOGOUT
  Future<void> logout() async {
    await sandBox.remove(Constants.ACCESS_TOKEN);
  }

  /// HTTP POST CALL
  static Future<ApiResponseModel> post({
    required String path,
    required Map<String, dynamic> body,
  }) async {
    final String token = sandBox.read(Constants.ACCESS_TOKEN);
    try {
      final http.Response response = await http.post(
        Uri.parse('$baseUrl/$path'),
        body: body,
        headers: <String, String>{
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'bearer $token'
        },
      );
      return ApiResponseModel.fromMap(jsonDecode(response.body));
    } catch (e) {
      throw e.toString();
    }
  }

  /// HTTP GET CALL
  static Future<ApiResponseModel> get({
    required String path,
  }) async {
    final String token = sandBox.read(Constants.ACCESS_TOKEN);
    try {
      final http.Response response = await http.get(
        Uri.parse('$baseUrl/$path'),
        headers: <String, String>{
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'bearer $token'
        },
      );

      return ApiResponseModel.fromMap(jsonDecode(response.body));
    } catch (e) {
      throw e.toString();
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
        Uri.parse('$baseUrl/$path'),
        body: body,
        headers: <String, String>{
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'bearer $token'
        },
      );
      return ApiResponseModel.fromMap(jsonDecode(response.body));
    } catch (e) {
      throw e.toString();
    }
  }

  /// HTTP DELETE CALL
  static Future<ApiResponseModel> delete({
    required String path,
    required Map<String, dynamic> body,
  }) async {
    final String token = sandBox.read(Constants.ACCESS_TOKEN);
    try {
      final http.Response response = await http.delete(
        Uri.parse('$baseUrl/$path'),
        body: body,
        headers: <String, String>{
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'bearer $token'
        },
      );
      return ApiResponseModel.fromMap(jsonDecode(response.body));
    } catch (e) {
      throw e.toString();
    }
  }
}
