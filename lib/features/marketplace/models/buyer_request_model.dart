import 'dart:convert';

import 'package:business_bosses_v2/common/models/user_model.dart';

class BuyerRequestModel {
  final int? id;
  final String userId;
  final String title;
  final String description;
  final String category;
  final double budgetStart;
  final double budgetEnd;
  final String deadline;
  final List<String> attachments;
  final String? imageUrl; // optional if any request image shown in UI
  final int offerCount;
  final String? createdAt;
  final String? updatedAt;
  final UserModel user;

  BuyerRequestModel({
    this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.category,
    required this.budgetStart,
    required this.budgetEnd,
    required this.deadline,
    this.attachments = const <String>[],
    this.imageUrl,
    this.offerCount = 0,
    this.createdAt,
    this.updatedAt,
    required this.user,
  });

  /// ✅ Safe number parser (handles string, int, double)
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  /// ✅ Parse from JSON (coming from Node backend)
  factory BuyerRequestModel.fromJson(Map<String, dynamic> json) {
    final List<String> attachmentsList = json['attachments'] != null
        ? (json['attachments'] is String
            ? List<String>.from(jsonDecode(json['attachments']))
            : List<String>.from(json['attachments']))
        : <String>[];

    return BuyerRequestModel(
      id: json['id'],
      userId: json['user_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      budgetStart: _parseDouble(json['budget_start']),
      budgetEnd: _parseDouble(json['budget_end']),
      deadline: json['deadline'] ?? '',
      attachments: attachmentsList,
      imageUrl: attachmentsList.isNotEmpty ? attachmentsList.first : null,
      offerCount: json['offer_count'] ?? 0,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      user: UserModel.fromMap(json['user']),
    );
  }

  /// ✅ Convert to JSON (for POST/PUT requests)
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'category': category,
      'budget_start': budgetStart,
      'budget_end': budgetEnd,
      'deadline': deadline,
      'attachments': attachments,
      'offer_count': offerCount,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'user': user.toMap(),
    };
  }
}
