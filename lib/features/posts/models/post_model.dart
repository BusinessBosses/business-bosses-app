// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:business_bosses_v2/common/models/comment_model.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/donations/models/donations_model.dart';
import 'package:business_bosses_v2/features/forum/models/forum_model.dart';
import 'package:business_bosses_v2/features/marketplace/models/market_model.dart';

class PostModel {
  final String postId;
  final String title;
  final List<String>? images;
  final int timestamp;
  int? oldtimestamp;
  final List<String>? likes;
  final List<String>? coins;
  final List<String>? reposts;
  final List<CommentModel>? comments;
  final UserModel? user;
  final String? videoUrl;
  final String? ytUrl;
  final String? livedata;
  final bool isRanked;
  int? views;
  final bool? promote;
  final dynamic promotionDuration;
  final String? plan;
  final bool? approved;
  final bool? isPolled;
  final List<dynamic>? options;
  final DonationModel? donation;
  final MarketModel? market;
  final ForumModel? forum;
  final List<Map<String, dynamic>>? pollvotes;
  PostModel({
    this.market,
    this.donation,
    this.forum,
    required this.postId,
    required this.title,
    this.images,
    required this.timestamp,
    this.oldtimestamp = 0,
    this.likes,
    this.coins,
    this.reposts,
    this.comments,
    this.user,
    this.videoUrl,
    this.ytUrl,
    this.livedata,
    required this.isRanked,
    this.views = 0,
    this.promote,
    required this.promotionDuration,
    this.plan,
    this.approved,
    this.isPolled = false,
    this.options,
    this.pollvotes,
  });

  PostModel copyWith({
    String? postId,
    String? title,
    List<String>? images,
    int? timestamp,
    int? oldtimestamp,
    List<String>? likes,
    List<String>? coins,
    List<String>? reposts,
    List<CommentModel>? comments,
    UserModel? user,
    String? videoUrl,
    String? ytUrl,
    String? livedata,
    bool? isRanked,
    int? views,
    bool? promote,
    dynamic promotionDuration,
    String? plan,
    bool? approved,
    bool? isPolled,
    List<dynamic>? options,
    List<Map<String, dynamic>>? pollvotes,
    DonationModel? donation,
    MarketModel? market,
    ForumModel? forum,
  }) {
    return PostModel(
      postId: postId ?? this.postId,
      title: title ?? this.title,
      images: images ?? this.images,
      timestamp: timestamp ?? this.timestamp,
      oldtimestamp: oldtimestamp ?? this.oldtimestamp,
      likes: likes ?? this.likes,
      coins: coins ?? this.coins,
      reposts: reposts ?? this.reposts,
      comments: comments ?? this.comments,
      user: user ?? this.user,
      videoUrl: videoUrl ?? this.videoUrl,
      ytUrl: ytUrl ?? this.ytUrl,
      livedata: livedata ?? this.livedata,
      isRanked: isRanked ?? this.isRanked,
      views: views ?? this.views,
      promote: promote ?? this.promote,
      promotionDuration: promotionDuration ?? this.promotionDuration,
      plan: plan ?? this.plan,
      approved: approved ?? this.approved,
      isPolled: isPolled ?? this.isPolled,
      options: options ?? this.options,
      pollvotes: pollvotes ?? this.pollvotes,
      donation: donation ?? this.donation,
      forum: forum ?? this.forum,
      market: market ?? this.market,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'postId': postId,
      'title': title,
      'images': images,
      'timestamp': timestamp,
      'oldtimestamp': oldtimestamp,
      'likes': likes,
      'coins': coins,
      'reposts': reposts,
      'comments': comments?.map((CommentModel x) => x.toMap()).toList(),
      'user': user?.toMap(),
      'videoUrl': videoUrl,
      'ytUrl': ytUrl,
      'livedata': livedata,
      'isRanked': isRanked,
      'views': views,
      'promote': promote,
      'promotionDuration': promotionDuration,
      'plan': plan,
      'approved': approved,
      'isPolled': isPolled,
      'options': options,
      'pollvotes': pollvotes,
      'donation': donation,
      'forum': forum,
      'market': market,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      postId: map['postId'] as String,
      title: map['title'] as String,
      images: map['images'] != null
          ? List<String>.from((map['images']))
                  .where((String element) => element.isNotEmpty)
                  .isEmpty
              ? null
              : List<String>.from((map['images']))
                  .where((String element) => element.isNotEmpty)
                  .toList()
          : null,
      timestamp: int.parse(map['timestamp'].toString()),
      oldtimestamp:
          map['oldtimestamp'] != null ? map['oldtimestamp'] as int : null,
      likes: map['likes'] != null ? List<String>.from((map['likes'])) : null,
      coins: map['coins'] != null ? List<String>.from((map['coins'])) : null,
      reposts: map['reposts'] != null
          ? List<String>.from(
              (map['reposts'] as List<dynamic>).map((dynamic item) {
                if (item is Map<String, dynamic>) {
                  return item['userId']?.toString() ?? '';
                } else if (item is String) {
                  return item;
                }
                return '';
              }).where((String id) => id.isNotEmpty),
            )
          : null,
      comments: List<dynamic>.from(map['comments'])
          .map((dynamic e) => CommentModel.fromMap(e as Map<String, dynamic>))
          .toList(),
      user: map['user'] != null
          ? UserModel.fromMap(map['user'] as Map<String, dynamic>)
          : null,
      videoUrl: map['videoUrl'] != null ? map['videoUrl'] as String : null,
      donation: map['donation'] != null
          ? DonationModel.fromMap(map['donation'])
          : null,
      forum: map['forum'] != null ? ForumModel.fromMap(map['forum']) : null,
      ytUrl: map['ytUrl'] != null ? map['ytUrl'] as String : null,
      livedata: map['livedata'] != null ? map['livedata'] as String : null,
      isRanked: map['isRanked'] as bool,
      views: map['views'] != null ? map['views'] as int : null,
      promote: map['promote'] != null ? map['promote'] as bool : null,
      promotionDuration: map['promotionDuration'] as dynamic,
      plan: map['plan'] != null ? map['plan'] as String : null,
      approved: map['approved'] != null ? map['approved'] as bool : null,
      isPolled: map['isPolled'] != null ? map['isPolled'] as bool : null,
      options: map['options'] != null ? map['options'] as List<dynamic> : null,
      pollvotes: map['pollvotes'] != null
          ? List<Map<String, dynamic>>.from(map['pollvotes'])
          : null,
      market: map['market'] != null ? MarketModel.fromMap(map['market']) : null,
    );
  }

  void setViews(int newViews) {
    views = newViews;
  }
}
