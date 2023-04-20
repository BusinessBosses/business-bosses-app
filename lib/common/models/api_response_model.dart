// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ApiResponseModel {
  final bool success;
  final String message;
  final dynamic data;
  ApiResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  ApiResponseModel copyWith({
    bool? success,
    String? message,
    dynamic data,
  }) {
    return ApiResponseModel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'success': success,
      'message': message,
      'data': data,
    };
  }

  factory ApiResponseModel.fromMap(Map<String, dynamic> map) {
    return ApiResponseModel(
      success: map['success'] as bool,
      message: map['message'] as String,
      data: map['data'] as dynamic,
    );
  }

  String toJson() => json.encode(toMap());

  factory ApiResponseModel.fromJson(String source) =>
      ApiResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ApiResponseModel(success: $success, message: $message, data: $data)';

  @override
  bool operator ==(covariant ApiResponseModel other) {
    if (identical(this, other)) return true;

    return other.success == success &&
        other.message == message &&
        other.data == data;
  }

  @override
  int get hashCode => success.hashCode ^ message.hashCode ^ data.hashCode;
}
