// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:business_bosses_v2/common/models/user_model.dart';

class CourseCommentModel {
  final String? receiverUid;
  final String? userId;
  final String? courseId;
  final String? comment;
  final int? timestamp;
  final UserModel? user;

  CourseCommentModel({
    this.receiverUid,
    this.userId,
    this.courseId,
    this.comment,
    this.timestamp,
    this.user,
  });

  CourseCommentModel copyWith({
    String? receiverUid,
    String? userId,
    String? courseId,
    String? comment,
    int? timestamp,
    UserModel? user,
  }) {
    return CourseCommentModel(
      receiverUid: receiverUid ?? this.receiverUid,
      userId: userId ?? this.userId,
      courseId: courseId ?? this.courseId,
      comment: comment ?? this.comment,
      timestamp: timestamp ?? this.timestamp,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'receiverUid': receiverUid,
      'userId': userId,
      'courseId': courseId,
      'comment': comment,
      'timestamp': timestamp,
      'user': user?.toMap(),
    };
  }

  factory CourseCommentModel.fromMap(Map<String, dynamic> map) {
    return CourseCommentModel(
      receiverUid:
          map['receiverUid'] != null ? map['receiverUid'] as String : null,
      userId: map['userId'] as String,
      courseId: map['courseId'] as String,
      comment: map['comment'] != null ? map['comment'] as String : null,
      timestamp: int.parse(map['timestamp'].toString()),
      user: map['user'] != null
          ? UserModel.fromMap(map['user'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CourseCommentModel.fromJson(String source) =>
      CourseCommentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CourseCommentModel(receiverUid: $receiverUid, userId: $userId, courseId: $courseId, comment: $comment, timestamp: $timestamp, user: $user)';
  }

  @override
  bool operator ==(covariant CourseCommentModel other) {
    if (identical(this, other)) return true;

    return other.receiverUid == receiverUid &&
        other.userId == userId &&
        other.courseId == courseId &&
        other.comment == comment &&
        other.timestamp == timestamp &&
        other.user == user;
  }

  @override
  int get hashCode {
    return receiverUid.hashCode ^
        userId.hashCode ^
        courseId.hashCode ^
        comment.hashCode ^
        timestamp.hashCode ^
        user.hashCode;
  }
}
