// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Quote {
  int id;
  String by;
  String message;
  Quote({
    required this.id,
    required this.by,
    required this.message,
  });

  Quote copyWith({
    int? id,
    String? by,
    String? message,
  }) {
    return Quote(
      id: id ?? this.id,
      by: by ?? this.by,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'by': by,
      'message': message,
    };
  }

  factory Quote.fromMap(Map<String, dynamic> map) {
    return Quote(
      id: map['id'] as int,
      by: map['by'] as String,
      message: map['message'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Quote.fromJson(String source) =>
      Quote.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Quote(id: $id, by: $by, message: $message)';

  @override
  bool operator ==(covariant Quote other) {
    if (identical(this, other)) return true;

    return other.id == id && other.by == by && other.message == message;
  }

  @override
  int get hashCode => id.hashCode ^ by.hashCode ^ message.hashCode;
}
