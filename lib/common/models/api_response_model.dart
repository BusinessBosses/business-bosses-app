// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ApiResponseModel {
  final bool success;
  final String message;
  final dynamic data;
  final String? errorMessage;
  ApiResponseModel({
    required this.success,
    required this.message,
    required this.data,
    this.errorMessage,
  });

  ApiResponseModel copyWith({
    bool? success,
    String? message,
    dynamic data,
    String? errorMessage,
  }) {
    return ApiResponseModel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
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

  factory ApiResponseModel.fromMap(Map<String, dynamic> map) {
    return ApiResponseModel(
      success: map['success'] as bool,
      message: map['error'] != null
          ? map['error'] as String
          : map['message'] as String,
      data: map['data'] as dynamic,
      errorMessage: map['message'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ApiResponseModel.fromJson(String source) =>
      ApiResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
