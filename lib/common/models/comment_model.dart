// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:business_bosses_v2/common/models/user_model.dart';

class CommentModel {
  final String? commentId;
  final String? userId;
  final String? postId;
  final String? comment;
  final int? timestamp;
  final UserModel? user;
  CommentModel({
    this.commentId,
    this.userId,
    this.postId,
    this.comment,
    this.timestamp,
    this.user,
  });

  CommentModel copyWith({
    String? commentId,
    String? userId,
    String? postId,
    String? comment,
    int? timestamp,
    UserModel? user,
  }) {
    return CommentModel(
      commentId: commentId ?? this.commentId,
      userId: userId ?? this.userId,
      postId: postId ?? this.postId,
      comment: comment ?? this.comment,
      timestamp: timestamp ?? this.timestamp,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'commentId': commentId,
      'userId': userId,
      'postId': postId,
      'comment': comment,
      'timestamp': timestamp,
      'user': user?.toMap(),
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      commentId: map['commentId']?.toString(),
      userId: map['userId']?.toString(),
      postId: map['postId']?.toString(),
      comment: map['comment']?.toString(),
      timestamp: map['timestamp'] != null
          ? int.tryParse(map['timestamp'].toString())
          : null,
      user: map['user'] != null
          ? UserModel.fromMap(Map<String, dynamic>.from(map['user']))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) =>
      CommentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CommentModel(commentId: $commentId, userId: $userId, postId: $postId, comment: $comment, timestamp: $timestamp, user: $user)';
  }

  @override
  bool operator ==(covariant CommentModel other) {
    if (identical(this, other)) return true;

    return other.commentId == commentId &&
        other.userId == userId &&
        other.postId == postId &&
        other.comment == comment &&
        other.timestamp == timestamp &&
        other.user == user;
  }

  @override
  int get hashCode {
    return commentId.hashCode ^
        userId.hashCode ^
        postId.hashCode ^
        comment.hashCode ^
        timestamp.hashCode ^
        user.hashCode;
  }
}
