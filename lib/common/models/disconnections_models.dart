// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DisconnectionsModel {
  final String id;
  final String userId;
  final int timeStamp;
  DisconnectionsModel({
    required this.id,
    required this.userId,
    required this.timeStamp,
  });

  DisconnectionsModel copyWith({
    String? id,
    String? userId,
    int? timeStamp,
  }) {
    return DisconnectionsModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      timeStamp: timeStamp ?? this.timeStamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'timeStamp': timeStamp,
    };
  }

  factory DisconnectionsModel.fromMap(Map<String, dynamic> map) {
    return DisconnectionsModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      timeStamp: map['timeStamp'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory DisconnectionsModel.fromJson(String source) =>
      DisconnectionsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'DisconnectionsModel(id: $id, userId: $userId, timeStamp: $timeStamp)';

  @override
  bool operator ==(covariant DisconnectionsModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        other.timeStamp == timeStamp;
  }

  @override
  int get hashCode => id.hashCode ^ userId.hashCode ^ timeStamp.hashCode;
}
