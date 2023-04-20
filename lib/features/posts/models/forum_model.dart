// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:business_bosses_v2/common/models/comment_model.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';

class ForumModel {
  final String forumId;
  final String categoryId;
  final String industryId;
  final String description;
  final bool? isArchived;
  final String marketCategory; // new field
  final String? location;
  final String title;
  final List<String> images;
  final int timestamp;
  final List<String> likes;
  final List<String> coins;
  final List<CommentModel> comments;
  final UserModel user;
  final bool isRanked;
  ForumModel({
    required this.forumId,
    required this.categoryId,
    required this.industryId,
    required this.description,
    this.isArchived,
    required this.marketCategory,
    this.location,
    required this.title,
    required this.images,
    required this.timestamp,
    required this.likes,
    required this.coins,
    required this.comments,
    required this.user,
    required this.isRanked,
  });

  ForumModel copyWith({
    String? forumId,
    String? categoryId,
    String? industryId,
    String? description,
    bool? isArchived,
    String? marketCategory,
    String? location,
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
      categoryId: categoryId ?? this.categoryId,
      industryId: industryId ?? this.industryId,
      description: description ?? this.description,
      isArchived: isArchived ?? this.isArchived,
      marketCategory: marketCategory ?? this.marketCategory,
      location: location ?? this.location,
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
      'categoryId': categoryId,
      'industryId': industryId,
      'description': description,
      'isArchived': isArchived,
      'marketCategory': marketCategory,
      'location': location,
      'title': title,
      'images': images,
      'timestamp': timestamp,
      'likes': likes,
      'coins': coins,
      'comments': comments.map((CommentModel x) => x.toMap()).toList(),
      'user': user.toMap(),
      'isRanked': isRanked,
    };
  }

  factory ForumModel.fromMap(Map<String, dynamic> map) {
    return ForumModel(
      forumId: map['forumId'] as String,
      categoryId: map['categoryId'] as String,
      industryId: map['industryId'] as String,
      description: map['description'] as String,
      isArchived: map['isArchived'] != null ? map['isArchived'] as bool : null,
      marketCategory: map['marketCategory'] as String,
      location: map['location'] != null ? map['location'] as String : null,
      title: map['title'] as String,
      images: List<String>.from((map['images'] as List<String>)),
      timestamp: map['timestamp'] as int,
      likes: List<String>.from((map['likes'] as List<String>)),
      coins: List<String>.from((map['coins'] as List<String>)),
      comments: List<CommentModel>.from(
        (map['comments'] as List<int>).map<CommentModel>(
          (int x) => CommentModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      user: UserModel.fromMap(map['user'] as Map<String, dynamic>),
      isRanked: map['isRanked'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory ForumModel.fromJson(String source) =>
      ForumModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ForumModel(forumId: $forumId, categoryId: $categoryId, industryId: $industryId, description: $description, isArchived: $isArchived, marketCategory: $marketCategory, location: $location, title: $title, images: $images, timestamp: $timestamp, likes: $likes, coins: $coins, comments: $comments, user: $user, isRanked: $isRanked)';
  }
}
