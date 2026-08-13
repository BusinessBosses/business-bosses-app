// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ApiResponseModel {
  final bool success;
  final String message;
  final dynamic data;
  final String? errorMessage;

  /// HTTP status of the response, or null when the request never completed.
  final int? statusCode;

  /// True when the request failed at the transport layer (no connectivity,
  /// DNS failure, timeout) rather than being rejected by the backend. Lets
  /// the UI tell "you're offline" apart from "the server said no".
  final bool isNetworkError;

  /// True when the backend replied with something we could not parse — an
  /// empty body or an HTML error page rather than JSON.
  final bool isMalformed;

  ApiResponseModel({
    required this.success,
    required this.message,
    required this.data,
    this.errorMessage,
    this.statusCode,
    this.isNetworkError = false,
    this.isMalformed = false,
  });

  /// The call never produced a usable answer, as opposed to the backend
  /// deliberately returning `success: false`. Callers that render their own
  /// error UI only want to surface a generic toast for this case.
  bool get isTransportFailure => isNetworkError || isMalformed;

  /// True when the backend rejected our credentials and the session needs
  /// to be re-established.
  bool get isUnauthorized =>
      statusCode == 401 ||
      statusCode == 403 ||
      message.toLowerCase().contains('send a valid token');

  ApiResponseModel copyWith({
    bool? success,
    String? message,
    dynamic data,
    String? errorMessage,
    int? statusCode,
    bool? isNetworkError,
    bool? isMalformed,
  }) {
    return ApiResponseModel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
      statusCode: statusCode ?? this.statusCode,
      isNetworkError: isNetworkError ?? this.isNetworkError,
      isMalformed: isMalformed ?? this.isMalformed,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'success': success,
      'message': message,
      'data': data,
      'errorMessage': errorMessage,
    };
  }

  factory ApiResponseModel.fromMap(Map<String, dynamic> map,
      {int? statusCode}) {
    return ApiResponseModel(
      success: map['success'] == true,
      message: map['error']?.toString() ?? map['message']?.toString() ?? '',
      data: map['data'],
      errorMessage: map['message']?.toString(),
      statusCode: statusCode,
    );
  }

  /// The request never reached the backend.
  factory ApiResponseModel.networkFailure(String message) => ApiResponseModel(
        success: false,
        message: message,
        data: <dynamic, dynamic>{},
        isNetworkError: true,
      );

  /// The backend replied, but not with usable JSON.
  factory ApiResponseModel.badResponse(int statusCode, String message) =>
      ApiResponseModel(
        success: false,
        message: message,
        data: <dynamic, dynamic>{},
        statusCode: statusCode,
        isMalformed: true,
      );

  String toJson() => json.encode(toMap());

  factory ApiResponseModel.fromJson(String source) =>
      ApiResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
