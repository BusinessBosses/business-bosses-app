// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:business_bosses_v2/common/models/comment_model.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';

class DonationModel {
  final String id;
  final String categoryId;
  final String? description;
  final int? targetAmount;
  int amountRecieved;
  final String? title;
  final String? youtubeUrls;
  final String? photo;
  final int? timestamp;
  late final List<String>? likes;
  final List<String>? coins;
  final List<CommentModel>? comments;
  final UserModel? user;
  int? views = 0;
  final List<String> images;
  final bool? isApproved;
  final bool? isSuspended;
  final bool? isCashoutApproved;
  DonationModel({
    required this.id,
    required this.categoryId,
    this.description,
    this.targetAmount,
    required this.amountRecieved,
    this.title,
    this.photo,
    this.timestamp,
    this.likes,
    this.views = 0,
    this.coins,
    this.comments,
    this.user,
    this.isApproved,
    this.isSuspended,
    this.isCashoutApproved,
    this.youtubeUrls,
    required this.images,
  });

  DonationModel copyWith({
    String? id,
    String? categoryId,
    String? description,
    String? title,
    int? targetAmount,
    int? amountRecieved,
    String? photo,
    int? timestamp,
    List<String>? likes,
    List<String>? coins,
    List<CommentModel>? comments,
    UserModel? user,
    bool? isApproved,
    bool? isSuspended,
    bool? isCashoutApproved,
    int? views,
    String? youtubeUrls,
    List<String>? images,
  }) {
    return DonationModel(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      description: description ?? this.description,
      title: title ?? this.title,
      targetAmount: targetAmount ?? this.targetAmount,
      amountRecieved: amountRecieved ?? this.amountRecieved,
      photo: photo ?? this.photo,
      timestamp: timestamp ?? this.timestamp,
      likes: likes ?? this.likes,
      coins: coins ?? this.coins,
      comments: comments ?? this.comments,
      user: user ?? this.user,
      views: views ?? this.views,
      isApproved: isApproved ?? this.isApproved,
      isSuspended: isSuspended ?? this.isSuspended,
      isCashoutApproved: isCashoutApproved ?? this.isCashoutApproved,
      youtubeUrls: youtubeUrls ?? this.youtubeUrls,
      images: images ?? this.images,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'categoryId': categoryId,
      'description': description,
      'title': title,
      'targetAmount': targetAmount,
      'amountRecieved': amountRecieved,
      'photo': photo,
      'timestamp': timestamp,
      'likes': likes,
      'coins': coins,
      'comments': comments!.map((CommentModel x) => x.toMap()).toList(),
      'user': user!.toMap(),
      'views': views,
      'isApproved': isApproved,
      'isSuspended': isSuspended,
      'isCashoutApproved': isCashoutApproved,
      'youtubeUrls': youtubeUrls,
      'images': images,
    };
  }

  factory DonationModel.fromMap(Map<String, dynamic> map) {
    return DonationModel(
      id: map['id'] as String,
      categoryId: map['categoryId'] as String,
      description:
          map['description'] != null ? map['description'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      youtubeUrls:
          map['youtubeUrls'] != null ? map['youtubeUrls'] as String : null,
      targetAmount:
          map['targetAmount'] != null ? map['targetAmount'] as int : null,
      amountRecieved:
          map['amountRecieved'] != null ? map['amountRecieved'] as int : 0,
      photo: map['photo'] != null ? map['photo'] as String : null,
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
      isApproved: map['isApproved'] ?? false,
      isSuspended: map['isSuspended'] ?? false,
      isCashoutApproved: map['isCashoutApproved'] ?? false,
      images: List<String>.from((map['images'])),
    );
  }

  void setViews(int newViews) {
    views = newViews;
  }

  void setRecievedAmount(int incrementBy) {
    amountRecieved += incrementBy;
  }
}
