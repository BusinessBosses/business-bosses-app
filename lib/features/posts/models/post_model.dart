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
      postId: map['postId']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      images: map['images'] != null
          ? (map['images'] as List)
              .map((dynamic e) => e?.toString() ?? '')
              .where((String e) => e.isNotEmpty)
              .toList()
          : null,
      timestamp: map['timestamp'] != null
          ? int.tryParse(map['timestamp'].toString()) ?? 0
          : 0,
      oldtimestamp: map['oldtimestamp'] != null
          ? int.tryParse(map['oldtimestamp'].toString())
          : null,
      likes: map['likes'] != null
          ? (map['likes'] as List).map((dynamic e) => e?.toString() ?? '').toList()
          : null,
      coins: map['coins'] != null
          ? (map['coins'] as List).map((dynamic e) => e?.toString() ?? '').toList()
          : null,
      reposts: map['reposts'] != null
          ? (map['reposts'] as List).map((dynamic item) {
              if (item is Map<String, dynamic>) {
                return item['userId']?.toString() ?? '';
              } else {
                return item?.toString() ?? '';
              }
            }).where((String id) => id.isNotEmpty).toList()
          : null,
      comments: map['comments'] != null
          ? (map['comments'] as List)
              .map((dynamic e) => CommentModel.fromMap(Map<String, dynamic>.from(e)))
              .toList()
          : null,
      user: map['user'] != null
          ? UserModel.fromMap(Map<String, dynamic>.from(map['user']))
          : null,
      videoUrl: map['videoUrl']?.toString(),
      donation: map['donation'] != null
          ? DonationModel.fromMap(Map<String, dynamic>.from(map['donation']))
          : null,
      forum: map['forum'] != null
          ? ForumModel.fromMap(Map<String, dynamic>.from(map['forum']))
          : null,
      ytUrl: map['ytUrl']?.toString(),
      livedata: map['livedata']?.toString(),
      isRanked: map['isRanked'] == true,
      views: map['views'] != null ? int.tryParse(map['views'].toString()) : 0,
      promote: map['promote'] == true,
      promotionDuration: map['promotionDuration'],
      plan: map['plan']?.toString(),
      approved: map['approved'] == true,
      isPolled: map['isPolled'] == true,
      options: map['options'] is List ? map['options'] as List : null,
      pollvotes: map['pollvotes'] != null
          ? (map['pollvotes'] as List).map((dynamic e) => Map<String, dynamic>.from(e)).toList()
          : null,
      market: map['market'] != null
          ? MarketModel.fromMap(Map<String, dynamic>.from(map['market']))
          : null,
    );
  }

  void setViews(int newViews) {
    views = newViews;
  }
}
