import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/utils/validators/validator.dart';
import 'package:business_bosses_v2/utils/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../navigation/routes.dart';

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
  /// Shape every auth failure the same way the login forms expect:
  /// `{'success': false, 'error': <human readable>}`.
  static Map<String, dynamic> _authFailure(String message) =>
      <String, dynamic>{'success': false, 'error': message};

  /// Decode an auth response body, tolerating the empty/HTML bodies that
  /// gateways return on 502/504 instead of throwing FormatException.
  static Map<String, dynamic>? _decodeAuthBody(http.Response response) {
    if (response.body.trim().isEmpty) {
      return null;
    }
    try {
      final dynamic decoded = json.decode(response.body);
      return decoded is Map<String, dynamic> ? decoded : null;
    } on FormatException catch (e) {
      debugPrint('Auth response was not JSON (${response.statusCode}): $e');
      return null;
    }
  }

  /// Persist the credentials from a successful auth response. Returns false
  /// when the payload is missing a token, so callers do not treat a
  /// malformed 200 as a completed login.
  static Future<bool> _storeSession(Map<String, dynamic> jsonResponse) async {
    final dynamic data = jsonResponse['data'];
    if (data is! Map) {
      return false;
    }
    final String? accessToken = data['accessToken']?.toString();
    if (accessToken == null || accessToken.isEmpty) {
      return false;
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(Constants.ACCESS_TOKEN, accessToken);
    await prefs.setString(Constants.USER_ID, data['uid'].toString());
    return true;
  }

  Future<dynamic> _authenticate({
    required String path,
    required Map<String, dynamic> body,
  }) async {
    final http.Response response;
    try {
      response = await http.post(
        Uri.parse('${Constants.baseUrl}/$path'),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
    } on SocketException catch (e) {
      debugPrint('$path: no connection: $e');
      return _authFailure(
          'Could not reach the server. Check your internet connection and try again.');
    } on HttpException catch (e) {
      debugPrint('$path: connection failed: $e');
      return _authFailure(
          'Could not reach the server. Please try again in a moment.');
    } catch (e) {
      debugPrint('$path: request failed: $e');
      return _authFailure('Something went wrong. Please try again.');
    }

    final Map<String, dynamic>? jsonResponse = _decodeAuthBody(response);

    // Empty or non-JSON body — a gateway timeout or a crashed backend.
    // Decoding it blind used to throw FormatException and kill the app.
    if (jsonResponse == null) {
      return _authFailure(response.statusCode >= 500
          ? 'The server is temporarily unavailable. Please try again shortly.'
          : 'Something went wrong. Please try again.');
    }

    if (response.statusCode == 200) {
      if (!await _storeSession(jsonResponse)) {
        return _authFailure(
            'Sign in did not complete. Please try again in a moment.');
      }
      return jsonResponse;
    }

    // Preserve the backend's own message where it sent one.
    final String message = jsonResponse['error']?.toString() ??
        jsonResponse['message']?.toString() ??
        'Sign in failed. Please check your details and try again.';
    return <String, dynamic>{...jsonResponse, 'success': false, 'error': message};
  }

  /// LOGIN POINT
  Future<dynamic> login(String email, String password) async {
    return _authenticate(
      path: 'auth/sign-in',
      body: <String, dynamic>{'email': email, 'password': password},
    );
  }

  /// GOOGLE LOGIN POINT
  Future<dynamic> googleLogin(String email, String token) async {
    return _authenticate(
      path: 'auth/google-sign-in',
      body: <String, dynamic>{'email': email, 'token': token},
    );
  }

  /// UPLOAD FILE
  static Future<dynamic> uploadFile(File image) async {
    String uploadUrl = 'https://businessbosses.com.ng/upload.php';
    http.MultipartRequest request =
        http.MultipartRequest('POST', Uri.parse(uploadUrl));
    request.files.add(await http.MultipartFile.fromPath('file', image.path));
    log(image.path);
    try {
      final http.StreamedResponse streamedResponse = await request.send();

      Map<dynamic, dynamic> result =
          json.decode(await streamedResponse.stream.bytesToString());
      if (result['success']) {
        log(result.toString());
        return result;
      } else {
        debugPrint(result.toString());
        showSnackbar(
            title: 'OOPS!',
            message: 'An error occurred, please try again!',
            error: true);
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      showSnackbar(
          title: 'OOPS!',
          message: 'An error occurred, please try again!',
          error: true);
      return null;
    }
  }

  /// UPLOAD MEDIA FILES
  static Future<MediaUploadResult> uploadMediaFiles(
      File video, File thumbnail) async {
    String uploadUrl = 'https://businessbosses.com.ng/upload-video.php';
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
        final dynamic videoUrl = result['video_url'];
        final dynamic thumbnailUrl = result['thumbnail_url'];
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

  /// REGISTER
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
      await prefs.setString(
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

  /// VERIFY USERNAME OR EMAIL DURING SIGNUP
  Future<bool?> verifyUnique(String username, String email) async {
    Map<String, dynamic> data = <String, dynamic>{
      'username': username,
      'email': email,
    };
    final http.Response response;
    try {
      response = await http.post(
        Uri.parse('${Constants.baseUrl}/auth/email-exist'),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
    } catch (e) {
      // A dropped connection here is a normal network failure, not a crash —
      // tell the user and let them retry.
      debugPrint('verifyUnique failed: $e');
      showSnackbar(
        title: 'No connection',
        message: 'Could not reach the server. Please try again.',
        error: true,
      );
      return null;
    }

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

  /// Drop the stored credentials without calling the backend. Used when the
  /// session is already invalid, so there is nothing to log out of.
  Future<void> clearSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(Constants.ACCESS_TOKEN);
    await prefs.remove(Constants.USER_ID);
  }

  /// LOGOUT
  Future<void> logout() async {
    await get(path: 'auth/logout');
    await clearSession();
    Get.offAllNamed(Routes.login);
  }

  /// Run an authenticated request and turn whatever comes back — including
  /// empty bodies, HTML error pages and dropped connections — into an
  /// [ApiResponseModel] that says which of those actually happened.
  static Future<ApiResponseModel> _send(
    String method,
    String url,
    Map<String, dynamic>? body,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString(Constants.ACCESS_TOKEN) ?? '';
    final Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'bearer $token',
    };
    final Uri uri = Uri.parse(url);
    final String? encoded = body == null ? null : jsonEncode(body);

    final http.Response response;
    try {
      switch (method) {
        case 'GET':
          response = await http.get(uri, headers: headers);
          break;
        case 'POST':
          response = await http.post(uri, headers: headers, body: encoded);
          break;
        case 'PUT':
          response = await http.put(uri, headers: headers, body: encoded);
          break;
        case 'DELETE':
          response = await http.delete(uri, headers: headers);
          break;
        default:
          throw ArgumentError('Unsupported method $method');
      }
    } on SocketException catch (e) {
      debugPrint('$method $url: no connection: $e');
      return ApiResponseModel.networkFailure(
          'Could not reach the server. Check your internet connection.');
    } on HttpException catch (e) {
      debugPrint('$method $url: connection failed: $e');
      return ApiResponseModel.networkFailure(
          'The connection was interrupted. Please try again.');
    } on TimeoutException catch (e) {
      debugPrint('$method $url: timed out: $e');
      return ApiResponseModel.networkFailure(
          'The server took too long to respond. Please try again.');
    } catch (e) {
      debugPrint('$method $url: request failed: $e');
      return ApiResponseModel.networkFailure(
          'Could not reach the server. Please try again.');
    }

    // The backend answered, so any failure from here is its fault, not the
    // network's — keep the status code so callers can react to 401 vs 500.
    if (response.body.trim().isEmpty) {
      debugPrint('$method $url: empty body (${response.statusCode})');
      return ApiResponseModel.badResponse(
        response.statusCode,
        response.statusCode >= 500
            ? 'The server is temporarily unavailable (${response.statusCode}).'
            : 'The server returned an empty response (${response.statusCode}).',
      );
    }

    try {
      final dynamic decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        return ApiResponseModel.badResponse(
            response.statusCode, 'Unexpected response from the server.');
      }
      return ApiResponseModel.fromMap(decoded, statusCode: response.statusCode);
    } on FormatException catch (e) {
      // Typically an HTML error page from a proxy in front of the API.
      debugPrint('$method $url: body was not JSON (${response.statusCode}): $e');
      return ApiResponseModel.badResponse(
        response.statusCode,
        'The server is temporarily unavailable (${response.statusCode}).',
      );
    }
  }

  /// HTTP POST CALL
  static Future<ApiResponseModel> post({
    required String path,
    required Map<String, dynamic> body,
    dynamic data,
  }) async {
    final ApiResponseModel response =
        await _send('POST', '${Constants.baseUrl}/$path', body);
    // Only when the call produced no usable answer. A backend that
    // deliberately returned success:false is reported by the caller, which
    // has the context to word it properly.
    if (response.isTransportFailure) {
      showSnackbar(title: 'OOPS!', message: response.message, error: true);
    }
    return response;
  }

  static Future<ApiResponseModel> initPost({
    required String path,
    required Map<String, dynamic> body,
    dynamic data,
  }) async {
    final ApiResponseModel response =
        await _send('POST', '${Constants.initUrl}/$path', body);
    if (response.isTransportFailure) {
      showSnackbar(title: 'OOPS!', message: response.message, error: true);
    }
    return response;
  }

  /// HTTP GET CALL
  static Future<ApiResponseModel> get({
    required String path,
  }) async {
    return _send('GET', '${Constants.baseUrl}/$path', null);
  }

  /// HTTP PUT CALL
  static Future<ApiResponseModel> put({
    required String path,
    required Map<String, dynamic> body,
  }) async {
    return _send('PUT', '${Constants.baseUrl}/$path', body);
  }

  /// HTTP DELETE CALL
  static Future<ApiResponseModel> delete({
    required String path,
  }) async {
    final ApiResponseModel response =
        await _send('DELETE', '${Constants.baseUrl}/$path', null);
    if (response.isTransportFailure) {
      showSnackbar(title: 'OOPS!', message: response.message, error: true);
    }
    return response;
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
