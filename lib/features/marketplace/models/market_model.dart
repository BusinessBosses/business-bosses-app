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
      description: map['description'] as String,
      title: map['title'] != null ? map['title'] as String : null,
      images: map['images'] != null
          ? List<dynamic>.from((map['images'] as List<dynamic>))
          : null,
      user: map['user'] != null
          ? UserModel.fromMap(map['user'] as Map<String, dynamic>)
          : null,
      category: map['category'] != null ? map['category'] as String : null,
      location: map['location'] != null ? map['location'] as String : null,
      marketId: map['marketId'] as String,
      price: map['price'] as String,
      userId: map['userId'] as String,
      promote: map['promote'] as bool,
      approved: map['approved'] as bool,
      views: map['views'] != null ? map['views'] as int : 0,
      discount: map['discount'] != null ? map['discount'] as String : '0',
      likes: map['likes'] != null ? List<String>.from((map['likes'])) : null,
      coins: map['coins'] != null ? List<String>.from((map['coins'])) : null,
      comments: map['comments'] != null
          ? List<dynamic>.from(map['comments'])
              .map((dynamic e) =>
                  CommentModel.fromMap(e as Map<String, dynamic>))
              .toList()
          : null,
      isProduct: map['isProduct'] as bool,
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
