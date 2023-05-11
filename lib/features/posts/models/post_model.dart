// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:business_bosses_v2/common/models/comment_model.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';

class PostModel {
  final String postId;
  final String title;
  final List<String>? images;
  final int timestamp;
  final List<String>? likes;
  final List<String>? coins;
  final List<CommentModel>? comments;
  final UserModel? user;
  final String? videoUrl;
  final bool isRanked;
  final bool? promote;
  final dynamic promotionDuration;
  final String? plan;
  final bool? approved;
  PostModel({
    required this.postId,
    required this.title,
    this.images,
    required this.timestamp,
    this.likes,
    this.coins,
    this.comments,
    this.user,
    this.videoUrl,
    required this.isRanked,
    this.promote,
    required this.promotionDuration,
    this.plan,
    this.approved,
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
    bool? promote,
    dynamic? promotionDuration,
    String? plan,
    bool? approved,
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
      promote: promote ?? this.promote,
      promotionDuration: promotionDuration ?? this.promotionDuration,
      plan: plan ?? this.plan,
      approved: approved ?? this.approved,
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
      'comments': comments?.map((CommentModel x) => x.toMap()).toList(),
      'user': user?.toMap(),
      'videoUrl': videoUrl,
      'isRanked': isRanked,
      'promote': promote,
      'promotionDuration': promotionDuration,
      'plan': plan,
      'approved': approved,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      postId: map['postId'] as String,
      title: map['title'] as String,
      images: map['images'] != null ? List<String>.from((map['images'])) : null,
      timestamp: map['timestamp'] as int,
      likes: map['likes'] != null ? List<String>.from((map['likes'])) : null,
      coins: map['coins'] != null ? List<String>.from((map['coins'])) : null,
      comments: List.from(map['comments'])
          .map((e) => CommentModel.fromMap(e as Map<String, dynamic>))
          .toList(),
      user: map['user'] != null
          ? UserModel.fromMap(map['user'] as Map<String, dynamic>)
          : null,
      videoUrl: map['videoUrl'] != null ? map['videoUrl'] as String : null,
      isRanked: map['isRanked'] as bool,
      promote: map['promote'] != null ? map['promote'] as bool : null,
      promotionDuration: map['promotionDuration'] as dynamic,
      plan: map['plan'] != null ? map['plan'] as String : null,
      approved: map['approved'] != null ? map['approved'] as bool : null,
    );
  }
}
