class Quote {
  String id;
  int expireIn;
  int timestamp;
  String by;
  String message;

  Quote({
    this.id = '',
    this.expireIn = 0,
    this.timestamp = 0,
    this.by = '',
    this.message = '',
  });

  Map<dynamic, dynamic> toMap() {
    return {
      'id': id,
      'expireIn': expireIn,
      'timestamp': timestamp,
      'by': by,
      'message': message,
    };
  }

  factory Quote.fromMap(Map<dynamic, dynamic> map) {
    return Quote(
      id: map['id'].toString(),
      expireIn: map['expireIn'] as int,
      timestamp: map['timestamp'] as int,
      by: map['by'] as String,
      message: map['message'] as String,
    );
  }
}
