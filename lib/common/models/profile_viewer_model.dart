// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ProfileViewerModel {
  final String uid;
  final int timestamp;
  ProfileViewerModel({
    required this.uid,
    required this.timestamp,
  });

  ProfileViewerModel copyWith({
    String? uid,
    int? timestamp,
  }) {
    return ProfileViewerModel(
      uid: uid ?? this.uid,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'timestamp': timestamp,
    };
  }

  factory ProfileViewerModel.fromMap(Map<String, dynamic> map) {
    return ProfileViewerModel(
      uid: map['uid'] as String,
      timestamp: map['timestamp'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfileViewerModel.fromJson(String source) =>
      ProfileViewerModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ProfileViewerModel(uid: $uid, timestamp: $timestamp)';

  @override
  bool operator ==(covariant ProfileViewerModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid && other.timestamp == timestamp;
  }

  @override
  int get hashCode => uid.hashCode ^ timestamp.hashCode;
}
