// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:business_bosses_v2/common/models/comment_model.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/forum/models/industry.dart';

class ForumModel {
  final String forumId;
  final String industryId;
  final String? description;
  final Industry? industry;
  final String? title;
  final String? ytUrl;
  final List<String>? images;
  bool promote;
  bool approved;
  final int? timestamp;
  late final List<String>? likes;
  final List<String>? coins;
  final List<CommentModel>? comments;
  final UserModel? user;
  int? views = 0;
  final bool? isRanked;
  ForumModel(
      {required this.forumId,
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
      this.promote = false,
      this.approved = false,
      this.user,
      this.isRanked,
      this.ytUrl});

  ForumModel copyWith({
    String? forumId,
    String? industryId,
    String? description,
    String? title,
    Industry? industry,
    List<String>? images,
    int? timestamp,
    List<String>? likes,
    List<String>? coins,
    List<CommentModel>? comments,
    UserModel? user,
    bool? promote,
    bool? approved,
    bool? isRanked,
    int? views,
    String? ytUrl,
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
      promote: promote ?? this.promote,
      approved: approved ?? this.approved,
      views: views ?? this.views,
      isRanked: isRanked ?? this.isRanked,
      ytUrl: ytUrl ?? this.ytUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'forumId': forumId,
      'industryId': industryId,
      'description': description,
      'title': title,
      'industry': industry?.toMap(),
      'images': images,
      'promote': promote,
      'approved': approved,
      'timestamp': timestamp,
      'likes': likes,
      'coins': coins,
      'comments': comments!.map((CommentModel x) => x.toMap()).toList(),
      'user': user!.toMap(),
      'views': views,
      'isRanked': isRanked,
      'ytUrl': ytUrl,
    };
  }

  factory ForumModel.fromMap(Map<String, dynamic> map) {
    return ForumModel(
      forumId: map['forumId']?.toString() ?? '',
      industryId: map['industryId']?.toString() ?? '',
      description: map['description']?.toString(),
      title: map['title']?.toString(),
      ytUrl: map['ytUrl']?.toString(),
      industry: map['industry'] != null && map['industry'] is Map
          ? Industry.fromMap(Map<String, dynamic>.from(map['industry']))
          : null,
      images: map['images'] != null && map['images'] != ''
          ? (map['images'] as List<dynamic>)
              .map((dynamic e) => e?.toString() ?? '')
              .where((String e) => e.isNotEmpty)
              .toList()
          : null,
      timestamp: map['timestamp'] != null
          ? int.tryParse(map['timestamp'].toString())
          : null,
      likes: map['likes'] != null
          ? (map['likes'] as List<dynamic>).map((dynamic like) {
              if (like is Map<String, dynamic>) {
                return like['userId']?.toString() ?? '';
              }
              return like?.toString() ?? '';
            }).where((String e) => e.isNotEmpty).toList()
          : null,
      coins: map['coins'] != null
          ? (map['coins'] as List<dynamic>).map((dynamic coin) {
              if (coin is Map<String, dynamic>) {
                return coin['userId']?.toString() ?? '';
              }
              return coin?.toString() ?? '';
            }).where((String e) => e.isNotEmpty).toList()
          : null,
      promote: map['promote'] == true,
      approved: map['approved'] == true,
      comments: map['comments'] != null
          ? (map['comments'] as List<dynamic>)
              .map((dynamic e) => CommentModel.fromMap(Map<String, dynamic>.from(e)))
              .toList()
          : <CommentModel>[],
      user: map['user'] != null
          ? UserModel.fromMap(Map<String, dynamic>.from(map['user']))
          : null,
      views: map['views'] != null ? int.tryParse(map['views'].toString()) ?? 0 : 0,
      isRanked: map['isRanked'] == true,
    );
  }

  void setViews(int newViews) {
    views = newViews;
  }
}
