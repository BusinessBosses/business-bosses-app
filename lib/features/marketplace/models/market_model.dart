// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:business_bosses_v2/common/models/user_model.dart';

import '../../../common/models/comment_model.dart';

class MarketModel {
  String marketId;
  String category;
  String location;
  String description;
  String userId;
  List<String>? images;
  String price;
  UserModel user;
  bool promote;
  int? timestamp;
  final List<String>? likes;
  final List<String>? coins;
  final List<CommentModel>? comments;
  MarketModel({
    required this.marketId,
    required this.category,
    required this.userId,
    required this.price,
    required this.description,
    required this.location,
    this.images,
    this.timestamp,
    required this.user,
    this.promote = false,
    this.likes,
    this.coins,
    this.comments,
  });

  MarketModel copyWith({
    String? marketId,
    String? category,
    String? location,
    String? description,
    String? userId,
    List<String>? images,
    String? price,
    UserModel? user,
    bool? promote,
    int? timestamp,
    List<String>? likes,
    List<String>? coins,
    List<CommentModel>? comments,
  }) {
    return MarketModel(
      description: description ?? this.description,
      location: location ?? this.location,
      images: images ?? this.images,
      user: user ?? this.user,
      category: category ?? this.category,
      marketId: marketId ?? this.marketId,
      price: price ?? this.price,
      userId: userId ?? this.userId,
      promote: promote ?? this.promote,
      timestamp: timestamp ?? this.timestamp,
      likes: likes ?? this.likes,
      coins: coins ?? this.coins,
      comments: comments ?? this.comments,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'description': description,
      'location': location,
      'images': images,
      'user': user.toMap(),
      'category': category,
      'marketId': marketId,
      'price': price,
      'userId': userId,
      'promote': promote,
      'timestamp': timestamp,
      'likes': likes,
      'coins': coins,
      'comments': comments?.map((CommentModel x) => x.toMap()).toList(),
    };
  }

  factory MarketModel.fromMap(Map<String, dynamic> map) {
    return MarketModel(
      description: map['description'] as String,
      images: map['images'] != null
          ? List<String>.from((map['images'] as List<String>))
          : null,
      user: UserModel.fromMap(map['user'] as Map<String, dynamic>),
      category: map['category'] as String,
      location: map['location'] as String,
      marketId: map['marketId'] as String,
      price: map['price'] as String,
      userId: map['userId'] as String,
      promote: map['promote'] as bool,
      likes: map['likes'] != null ? List<String>.from((map['likes'])) : null,
      coins: map['coins'] != null ? List<String>.from((map['coins'])) : null,
      comments: List.from(map['comments'])
          .map((e) => CommentModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  String toJson() => json.encode(toMap());

  factory MarketModel.fromJson(String source) =>
      MarketModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MarketModel(description: $description, location: $location, images: $images, user: $user, category: $category, marketId: $marketId, price: $price, userId: $userId, promote: $promote, timestamp: $timestamp)';
  }
}
