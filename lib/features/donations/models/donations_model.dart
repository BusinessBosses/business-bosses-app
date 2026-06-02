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
  bool? isCashoutApproved;
  final List<DonationTransaction>? transactions;
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
    this.transactions,
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
    List<DonationTransaction>? transactions,
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
      transactions: transactions ?? this.transactions,
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
      'comments': comments?.map((CommentModel x) => x.toMap()).toList() ??
          <Map<String, dynamic>>[],
      'user': user?.toMap() ?? <String, dynamic>{},
      'views': views,
      'isApproved': isApproved,
      'isSuspended': isSuspended,
      'isCashoutApproved': isCashoutApproved,
      'youtubeUrls': youtubeUrls,
      'images': images,
      'transactions':
          transactions?.map((DonationTransaction t) => t.toMap()).toList() ??
              <dynamic>[],
    };
  }

  factory DonationModel.fromMap(Map<String, dynamic> map) {
    return DonationModel(
      id: map['id']?.toString() ?? '',
      categoryId: map['categoryId']?.toString() ?? '',
      description: map['description']?.toString(),
      title: map['title']?.toString(),
      youtubeUrls: map['youtubeUrls']?.toString(),
      targetAmount: map['targetAmount'] != null
          ? int.tryParse(map['targetAmount'].toString())
          : null,
      amountRecieved: map['amountRecieved'] != null
          ? int.tryParse(map['amountRecieved'].toString()) ?? 0
          : 0,
      photo: map['photo']?.toString(),
      timestamp: map['timestamp'] != null
          ? int.tryParse(map['timestamp'].toString())
          : null,
      likes: map['likes'] != null
          ? (map['likes'] as List).map((dynamic like) {
              if (like is Map<String, dynamic>) {
                return like['userId']?.toString() ?? '';
              }
              return like?.toString() ?? '';
            }).where((String e) => e.isNotEmpty).toList()
          : null,
      coins: map['coins'] != null
          ? (map['coins'] as List).map((dynamic coin) {
              if (coin is Map<String, dynamic>) {
                return coin['userId']?.toString() ?? '';
              }
              return coin?.toString() ?? '';
            }).where((String e) => e.isNotEmpty).toList()
          : null,
      comments: map['comments'] != null
          ? (map['comments'] as List)
              .map((dynamic e) => CommentModel.fromMap(Map<String, dynamic>.from(e)))
              .toList()
          : null,
      user: map['user'] != null
          ? UserModel.fromMap(Map<String, dynamic>.from(map['user']))
          : null,
      views: map['views'] != null ? int.tryParse(map['views'].toString()) ?? 0 : 0,
      isApproved: map['isApproved'] == true,
      isSuspended: map['isSuspended'] == true,
      isCashoutApproved: map['isCashoutApproved'] == true,
      images: map['images'] != null
          ? (map['images'] as List).map((dynamic e) => e?.toString() ?? '').toList()
          : <String>[],
      transactions: map['transactions'] != null
          ? (map['transactions'] as List)
              .where((dynamic t) => t != null)
              .map((dynamic t) => DonationTransaction.fromMap(Map<String, dynamic>.from(t)))
              .toList()
          : <DonationTransaction>[],
    );
  }

  void setViews(int newViews) {
    views = newViews;
  }

  void setRecievedAmount(int incrementBy) {
    amountRecieved += incrementBy;
  }
}

class DonationTransaction {
  final String id;
  final DateTime date;
  final int amount;
  final String? description;
  final String type;

  DonationTransaction({
    required this.id,
    required this.date,
    required this.amount,
    this.description,
    required this.type,
  });

  factory DonationTransaction.fromMap(Map<String, dynamic> map) {
    return DonationTransaction(
      id: map['id']?.toString() ?? '',
      date: map['date'] != null
          ? DateTime.tryParse(map['date'].toString()) ?? DateTime.now()
          : DateTime.now(),
      amount: map['amount'] != null
          ? int.tryParse(map['amount'].toString()) ?? 0
          : 0,
      description: map['description']?.toString(),
      type: map['type']?.toString() ?? '',
    );
  }

  void toMap() {}
}
