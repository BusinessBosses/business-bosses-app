import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:http/http.dart' as http;

/// API CALLS

class ApiService {
  final String _url = 'http://localhost:5000';

  final String _token = '';

  /// HTTP POST CALL
  Future<ApiResponseModel> post(
      {required String path,
      required Map<String, dynamic> body,
      bool useToken = false}) async {
    if (useToken) {
      final http.Response response = await http.post(
        Uri.parse('$_url/$path'),
        body: body,
        headers: <String, String>{'Authorization': _token},
      );
      return ApiResponseModel.fromMap(response.body as Map<String, dynamic>);
    } else {
      final http.Response response =
          await http.post(Uri.parse('$_url/$path'), body: body);

      return ApiResponseModel.fromMap(response.body as Map<String, dynamic>);
    }
  }

  /// HTTP GET CALL
  Future<ApiResponseModel> get(
      {required String path, bool useToken = false}) async {
    if (useToken) {
      final http.Response response = await http.get(
        Uri.parse('$_url/$path'),
        headers: <String, String>{'Authorization': _token},
      );

      return ApiResponseModel.fromMap(response.body as Map<String, dynamic>);
    } else {
      final http.Response response = await http.get(Uri.parse('$_url/$path'));

      return ApiResponseModel.fromMap(response.body as Map<String, dynamic>);
    }
  }

  /// HTTP PUT CALL
  Future<ApiResponseModel> put(
      {required String path,
      required Map<String, dynamic> body,
      bool useToken = false}) async {
    if (useToken) {
      final http.Response response = await http.put(
        Uri.parse('$_url/$path'),
        body: body,
        headers: <String, String>{'Authorization': _token},
      );
      return ApiResponseModel.fromMap(response.body as Map<String, dynamic>);
    } else {
      final http.Response response =
          await http.put(Uri.parse('$_url/$path'), body: body);

      return ApiResponseModel.fromMap(response.body as Map<String, dynamic>);
    }
  }

  /// HTTP DELETE CALL
  Future<ApiResponseModel> delete(
      {required String path,
      required Map<String, dynamic> body,
      bool useToken = false}) async {
    if (useToken) {
      final http.Response response = await http.delete(
        Uri.parse('$_url/$path'),
        body: body,
        headers: <String, String>{'Authorization': _token},
      );
      return ApiResponseModel.fromMap(response.body as Map<String, dynamic>);
    } else {
      final http.Response response =
          await http.delete(Uri.parse('$_url/$path'), body: body);

      return ApiResponseModel.fromMap(response.body as Map<String, dynamic>);
    }
  }
}
