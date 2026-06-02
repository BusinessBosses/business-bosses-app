// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:business_bosses_v2/common/models/user_model.dart';

import '../../../common/models/comment_model.dart';

class MarketModel {
  String marketId;
  String? category;
  String? location;
  String description;
  String? title;
  String userId;
  List<dynamic>? images;
  String price;
  String? discount;
  UserModel? user;
  bool promote;
  bool approved;
  int? timestamp;
  int? views;
  bool isProduct;
  final List<String>? likes;
  final List<String>? coins;
  final List<CommentModel>? comments;
  MarketModel({
    required this.marketId,
    this.category,
    required this.userId,
    required this.price,
    required this.description,
    this.title,
    this.location,
    this.images,
    this.timestamp,
    this.user,
    this.promote = false,
    this.approved = false,
    this.likes,
    this.views = 0,
    this.coins,
    this.comments,
    this.discount = '0',
    this.isProduct = true,
  });

  MarketModel copyWith({
    String? marketId,
    String? category,
    String? location,
    String? description,
    String? title,
    String? userId,
    List<String>? images,
    String? price,
    UserModel? user,
    bool? promote,
    bool? approved,
    int? timestamp,
    int? views,
    List<String>? likes,
    List<String>? coins,
    List<CommentModel>? comments,
    String? discount,
    bool? isProduct,
  }) {
    return MarketModel(
      description: description ?? this.description,
      title: title ?? this.title,
      location: location ?? this.location,
      images: images ?? this.images,
      user: user ?? this.user,
      category: category ?? this.category,
      marketId: marketId ?? this.marketId,
      price: price ?? this.price,
      userId: userId ?? this.userId,
      promote: promote ?? this.promote,
      approved: approved ?? this.approved,
      timestamp: timestamp ?? this.timestamp,
      likes: likes ?? this.likes,
      coins: coins ?? this.coins,
      comments: comments ?? this.comments,
      views: views ?? this.views,
      discount: discount ?? this.discount,
      isProduct: isProduct ?? this.isProduct,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'description': description,
      'title': title,
      'location': location,
      'images': images,
      'user': user?.toMap(),
      'category': category,
      'marketId': marketId,
      'price': price,
      'userId': userId,
      'promote': promote,
      'approved': approved,
      'timestamp': timestamp,
      'likes': likes,
      'coins': coins,
      'views': views,
      'comments': comments?.map((CommentModel x) => x.toMap()).toList(),
      'discount': discount,
      'isProduct': isProduct,
    };
  }

  factory MarketModel.fromMap(Map<String, dynamic> map) {
    return MarketModel(
      description: map['description']?.toString() ?? '',
      title: map['title']?.toString(),
      images: map['images'] is List ? map['images'] as List : null,
      user: map['user'] != null
          ? UserModel.fromMap(Map<String, dynamic>.from(map['user']))
          : null,
      category: map['category']?.toString(),
      location: map['location']?.toString(),
      marketId: map['marketId']?.toString() ?? '',
      price: map['price']?.toString() ?? '0',
      userId: map['userId']?.toString() ?? '',
      promote: map['promote'] == true,
      approved: map['approved'] == true,
      views: map['views'] != null ? int.tryParse(map['views'].toString()) ?? 0 : 0,
      discount: map['discount']?.toString() ?? '0',
      likes: map['likes'] != null
          ? (map['likes'] as List).map((dynamic e) => e?.toString() ?? '').toList()
          : null,
      coins: map['coins'] != null
          ? (map['coins'] as List).map((dynamic e) => e?.toString() ?? '').toList()
          : null,
      comments: map['comments'] != null
          ? (map['comments'] as List)
              .map((dynamic e) => CommentModel.fromMap(Map<String, dynamic>.from(e)))
              .toList()
          : null,
      isProduct: map['isProduct'] == true,
    );
  }

  String toJson() => json.encode(toMap());

  void setViews(int newViews) {
    views = newViews;
  }

  factory MarketModel.fromJson(String source) =>
      MarketModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MarketModel(description: $description, title: $title, location: $location, images: $images, user: $user, category: $category, marketId: $marketId, price: $price, userId: $userId, promote: $promote, approved: $approved, timestamp: $timestamp)';
  }
}
