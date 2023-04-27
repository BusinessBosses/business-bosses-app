import 'dart:convert';

import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/utils/constants/constants.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

/// SERVER BASE URL
const String baseUrl = 'https://business-bosses.com/api/v2';

/// LOCAL STORAGE SANDBOX
final GetStorage sandBox = GetStorage();

/// API CALLS
class ApiService {
  /// HTTP POST CALL
  static Future<ApiResponseModel> post({
    required String path,
    required Map<String, dynamic> body,
  }) async {
    final dynamic token = sandBox.read(Constants.ACCESS_TOKEN);
    if (token == null) throw 'No access Token';
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
  }

  /// HTTP GET CALL
  static Future<ApiResponseModel> get({
    required String path,
  }) async {
    final dynamic token = sandBox.read(Constants.ACCESS_TOKEN);
    if (token == null) throw 'No access Token';
    final http.Response response = await http.get(
      Uri.parse('$baseUrl/$path'),
      headers: <String, String>{
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'bearer $token'
      },
    );

    return ApiResponseModel.fromMap(jsonDecode(response.body));
  }

  /// HTTP PUT CALL
  static Future<ApiResponseModel> put({
    required String path,
    required Map<String, dynamic> body,
  }) async {
    final dynamic token = sandBox.read(Constants.ACCESS_TOKEN);
    if (token == null) throw 'No access Token';
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
  }

  /// HTTP DELETE CALL
  static Future<ApiResponseModel> delete({
    required String path,
    required Map<String, dynamic> body,
  }) async {
    final dynamic token = sandBox.read(Constants.ACCESS_TOKEN);
    if (token == null) throw 'No access Token';
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
  }
}
