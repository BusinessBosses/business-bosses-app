// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:business_bosses_v2/common/models/comment_model.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';

class MarketModel {
  String marketId;
  String category;
  String location;
  String description;
  String userId;
  List<String>? images;
  int price;
  List<String>? likes;
  List<String>? coins;
  List<CommentModel>? comments;
  UserModel user;
  bool promote;
  MarketModel({
    required this.marketId,
    required this.category,
    required this.userId,
    required this.price,
    required this.description,
    required this.location,
    this.images,
    this.likes,
    this.coins,
    this.comments,
    required this.user,
    this.promote = false,
  });

  MarketModel copyWith({
    String? marketId,
    String? category,
    String? location,
    String? description,
    String? userId,
    List<String>? images,
    int? price,
    List<String>? likes,
    List<String>? coins,
    List<CommentModel>? comments,
    UserModel? user,
    bool? promote,
  }) {
    return MarketModel(
      description: description ?? this.description,
      location: location ?? this.location,
      images: images ?? this.images,
      likes: likes ?? this.likes,
      coins: coins ?? this.coins,
      comments: comments ?? this.comments,
      user: user ?? this.user,
      category: category ?? this.category,
      marketId: marketId ?? this.marketId,
      price: price ?? this.price,
      userId: userId ?? this.userId,
      promote: promote ?? this.promote,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'description': description,
      'location': location,
      'images': images,
      'likes': likes,
      'coins': coins,
      'comments': comments?.map((CommentModel x) => x.toMap()).toList(),
      'user': user.toMap(),
      'category': category,
      'marketId': marketId,
      'price': price,
      'userId': userId,
      'promote': promote,
    };
  }

  factory MarketModel.fromMap(Map<String, dynamic> map) {
    return MarketModel(
      description: map['description'] as String,
      images: map['images'] != null
          ? List<String>.from((map['images'] as List<String>))
          : null,
      likes: List<String>.from((map['likes'] as List<String>)),
      coins: List<String>.from((map['coins'] as List<String>)),
      comments: List<CommentModel>.from(
        (map['comments'] as List<int>).map<CommentModel>(
          (int x) => CommentModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      user: UserModel.fromMap(map['user'] as Map<String, dynamic>),
      category: map['category'] as String,
      location: map['location'] as String,
      marketId: map['marketId'] as String,
      price: map['price'] as int,
      userId: map['userId'] as String,
      promote: map['promote'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory MarketModel.fromJson(String source) =>
      MarketModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MarketModel(description: $description, location: $location, images: $images, likes: $likes, coins: $coins, comments: $comments, user: $user, category: $category, marketId: $marketId, price: $price, userId: $userId, promote: $promote)';
  }
}
