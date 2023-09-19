// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:business_bosses_v2/common/models/comment_model.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';

class ForumModel {
  final String forumId;
  final String industryId;
  final String? description;
  final String? industry;
  final String? title;
  final List<String>? images;
  final int? timestamp;
  late final List<String>? likes;
  final List<String>? coins;
  final List<CommentModel>? comments;
  final UserModel? user;
  int? views = 0;
  final bool? isRanked;
  ForumModel({
    required this.forumId,
    required this.industryId,
    this.description,
    this.industry,
    this.title,
    this.images,
    this.timestamp,
    this.likes,
    this.views = 0,
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
    String? industry,
    List<String>? images,
    int? timestamp,
    List<String>? likes,
    List<String>? coins,
    List<CommentModel>? comments,
    UserModel? user,
    bool? isRanked,
    int? views,
  }) {
    return ForumModel(
      forumId: forumId ?? this.forumId,
      industryId: industryId ?? this.industryId,
      description: description ?? this.description,
      title: title ?? this.title,
      industry: industry ?? this.industry,
      images: images ?? this.images,
      timestamp: timestamp ?? this.timestamp,
      likes: likes ?? this.likes,
      coins: coins ?? this.coins,
      comments: comments ?? this.comments,
      user: user ?? this.user,
      views: views ?? this.views,
      isRanked: isRanked ?? this.isRanked,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'forumId': forumId,
      'industryId': industryId,
      'description': description,
      'title': title,
      'industry': industry,
      'images': images,
      'timestamp': timestamp,
      'likes': likes,
      'coins': coins,
      'comments': comments!.map((CommentModel x) => x.toMap()).toList(),
      'user': user!.toMap(),
      'views': views,
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
      industry: map['industry'] != null ? map['industry'] as String : null,
      images: map['images'] != null && map['images'] != ''
          ? List<String>.from((map['images']))
                  .where((String element) => element.isNotEmpty)
                  .toList()
                  .isEmpty
              ? null
              : List<String>.from((map['images']))
                  .where((String element) => element.isNotEmpty)
                  .toList()
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
      views: map['views'] != null ? map['views'] as int : 0,
      isRanked: map['isRanked'] ?? false,
    );
  }

  setViews(int newViews) {
    views = newViews;
  }
}
