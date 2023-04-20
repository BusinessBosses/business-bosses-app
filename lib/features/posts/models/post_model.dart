// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:business_bosses_v2/common/models/comment_model.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';

class PostModel {
  final String postId;
  final String title;
  final List<String>? images;
  final int timestamp;
  final List<String> likes;
  final List<String> coins;
  final List<CommentModel> comments;
  final UserModel user;
  final String? videoUrl;
  final bool isRanked;
  PostModel({
    required this.postId,
    required this.title,
    this.images,
    required this.timestamp,
    required this.likes,
    required this.coins,
    required this.comments,
    required this.user,
    this.videoUrl,
    required this.isRanked,
  });

  PostModel copyWith({
    String? postId,
    String? title,
    List<String>? images,
    int? timestamp,
    List<String>? likes,
    List<String>? coins,
    List<CommentModel>? comments,
    UserModel? user,
    String? videoUrl,
    bool? isRanked,
  }) {
    return PostModel(
      postId: postId ?? this.postId,
      title: title ?? this.title,
      images: images ?? this.images,
      timestamp: timestamp ?? this.timestamp,
      likes: likes ?? this.likes,
      coins: coins ?? this.coins,
      comments: comments ?? this.comments,
      user: user ?? this.user,
      videoUrl: videoUrl ?? this.videoUrl,
      isRanked: isRanked ?? this.isRanked,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'postId': postId,
      'title': title,
      'images': images,
      'timestamp': timestamp,
      'likes': likes,
      'coins': coins,
      'comments': comments.map((CommentModel x) => x.toMap()).toList(),
      'user': user.toMap(),
      'videoUrl': videoUrl,
      'isRanked': isRanked,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      postId: map['postId'] as String,
      title: map['title'] as String,
      images: map['images'] != null
          ? List<String>.from((map['images'] as List<String>))
          : null,
      timestamp: map['timestamp'] as int,
      likes: List<String>.from((map['likes'] as List<String>)),
      coins: List<String>.from((map['coins'] as List<String>)),
      comments: List<CommentModel>.from(
        (map['comments'] as List<int>).map<CommentModel>(
          (int x) => CommentModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      user: UserModel.fromMap(map['user'] as Map<String, dynamic>),
      videoUrl: map['videoUrl'] != null ? map['videoUrl'] as String : null,
      isRanked: map['isRanked'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory PostModel.fromJson(String source) =>
      PostModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PostModel(postId: $postId, title: $title, images: $images, timestamp: $timestamp, likes: $likes, coins: $coins, comments: $comments, user: $user, videoUrl: $videoUrl, isRanked: $isRanked)';
  }
}
