class MyResponse {
  bool success;
  String message;
  dynamic data;

  MyResponse({
    this.success = false,
    this.message = 'No data',
    this.data,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'success': success,
      'message': message,
      'data': data,
    };
  }

  factory MyResponse.fromMap(Map<String, dynamic> map) {
    return MyResponse(
      success: map['success'] as bool,
      message: map['message'] as String,
      data: map['data'],
    );
  }
}
