// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:business_bosses_v2/common/models/user_model.dart';

class CommentModel {
  final String? commentId;
  final String uid;
  final String? comment;
  final int? timestamp;
  final UserModel? user;
  CommentModel({
    this.commentId,
    required this.uid,
    this.comment,
    this.timestamp,
    this.user,
  });

  CommentModel copyWith({
    String? commentId,
    String? uid,
    String? comment,
    int? timestamp,
    UserModel? user,
  }) {
    return CommentModel(
      commentId: commentId ?? this.commentId,
      uid: uid ?? this.uid,
      comment: comment ?? this.comment,
      timestamp: timestamp ?? this.timestamp,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'commentId': commentId,
      'uid': uid,
      'comment': comment,
      'timestamp': timestamp,
      'user': user?.toMap(),
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      commentId: map['commentId'] != null ? map['commentId'] as String : null,
      uid: map['uid'] as String,
      comment: map['comment'] != null ? map['comment'] as String : null,
      timestamp: map['timestamp'] != null ? map['timestamp'] as int : null,
      user: map['user'] != null
          ? UserModel.fromMap(map['user'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) =>
      CommentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CommentModel(commentId: $commentId, uid: $uid, comment: $comment, timestamp: $timestamp, user: $user)';
  }

  @override
  bool operator ==(covariant CommentModel other) {
    if (identical(this, other)) return true;

    return other.commentId == commentId &&
        other.uid == uid &&
        other.comment == comment &&
        other.timestamp == timestamp &&
        other.user == user;
  }

  @override
  int get hashCode {
    return commentId.hashCode ^
        uid.hashCode ^
        comment.hashCode ^
        timestamp.hashCode ^
        user.hashCode;
  }
}
