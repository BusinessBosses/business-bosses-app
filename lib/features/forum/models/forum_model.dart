// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:business_bosses_v2/common/models/comment_model.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';

class ForumModel {
  final String forumId;
  final String industryId;
  final String? description;
  final String? title;
  final List<String>? images;
  final int? timestamp;
  final List<String>? likes;
  final List<String>? coins;
  final List<CommentModel>? comments;
  final UserModel? user;
  final bool? isRanked;
  ForumModel({
    required this.forumId,
    required this.industryId,
    this.description,
    this.title,
    this.images,
    this.timestamp,
    this.likes,
    this.coins,
    this.comments,
    this.user,
    this.isRanked,
  });

  ForumModel copyWith({
    String? forumId,
    String? industryId,
    String? description,
    String? title,
    List<String>? images,
    int? timestamp,
    List<String>? likes,
    List<String>? coins,
    List<CommentModel>? comments,
    UserModel? user,
    bool? isRanked,
  }) {
    return ForumModel(
      forumId: forumId ?? this.forumId,
      industryId: industryId ?? this.industryId,
      description: description ?? this.description,
      title: title ?? this.title,
      images: images ?? this.images,
      timestamp: timestamp ?? this.timestamp,
      likes: likes ?? this.likes,
      coins: coins ?? this.coins,
      comments: comments ?? this.comments,
      user: user ?? this.user,
      isRanked: isRanked ?? this.isRanked,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'forumId': forumId,
      'industryId': industryId,
      'description': description,
      'title': title,
      'images': images,
      'timestamp': timestamp,
      'likes': likes,
      'coins': coins,
      'comments': comments!.map((CommentModel x) => x.toMap()).toList(),
      'user': user!.toMap(),
      'isRanked': isRanked,
    };
  }

  factory ForumModel.fromMap(Map<String, dynamic> map) {
    return ForumModel(
      forumId: map['forumId'] as String,
      industryId: map['industryId'] as String,
      description:
          map['description'] != null ? map['description'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      images: map['images'] != null
          ? List<String>.from((map['images'] as List<String>))
          : null,
      timestamp: map['timestamp'] != null
          ? int.parse(map['timestamp'].toString())
          : null,
      likes: map['likes'] != null ? List<String>.from((map['likes'])) : null,
      coins: map['coins'] != null ? List<String>.from((map['coins'])) : null,
      comments: List.from(map['comments'])
          .map((e) => CommentModel.fromMap(e as Map<String, dynamic>))
          .toList(),
      user: map['user'] != null
          ? UserModel.fromMap(map['user'] as Map<String, dynamic>)
          : null,
      isRanked: map['isRanked'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory ForumModel.fromJson(String source) =>
      ForumModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ForumModel(forumId: $forumId, industryId: $industryId, description: $description, title: $title, images: $images, timestamp: $timestamp, likes: $likes, coins: $coins, comments: $comments, user: $user, isRanked: $isRanked)';
  }

  @override
  bool operator ==(covariant ForumModel other) {
    if (identical(this, other)) return true;

    return other.forumId == forumId &&
        other.industryId == industryId &&
        other.description == description &&
        other.title == title &&
        listEquals(other.images, images) &&
        other.timestamp == timestamp &&
        listEquals(other.likes, likes) &&
        listEquals(other.coins, coins) &&
        listEquals(other.comments, comments) &&
        other.user == user &&
        other.isRanked == isRanked;
  }

  @override
  int get hashCode {
    return forumId.hashCode ^
        industryId.hashCode ^
        description.hashCode ^
        title.hashCode ^
        images.hashCode ^
        timestamp.hashCode ^
        likes.hashCode ^
        coins.hashCode ^
        comments.hashCode ^
        user.hashCode ^
        isRanked.hashCode;
  }
}
