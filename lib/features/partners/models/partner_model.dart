import 'dart:convert';

import 'package:business_bosses_v2/common/models/user_model.dart';

class Partner {
  final int? id;
  final String companyName;
  final String? companyDescription;
  final String? companyUrl;
  final String? companyPhoto;
  final String? companyEmail;
  final String? companyPhone;
  final String? location;
  final String? partnershipType;
  final String? category;
  final bool approved;
  final int clicks;
  final bool isRanked;
  final String? userId;
  final UserModel? user; // 👈 association (belongsTo)
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Partner({
    this.id,
    required this.companyName,
    this.companyDescription,
    this.companyUrl,
    this.companyPhoto,
    this.companyEmail,
    this.companyPhone,
    this.location,
    this.partnershipType,
    this.category,
    this.approved = false,
    this.clicks = 0,
    this.isRanked = false,
    this.userId,
    this.user,
    this.createdAt,
    this.updatedAt,
  });

  factory Partner.fromJson(Map<String, dynamic> json) {
    return Partner(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? ''),
      companyName: json['companyName'] ?? '',
      companyDescription: json['companyDescription'],
      companyUrl: json['companyUrl'],
      companyPhoto: json['companyPhoto'],
      companyEmail: json['companyEmail'],
      companyPhone: json['companyPhone'],
      location: json['location'],
      partnershipType: json['partnershipType'],
      category: json['category'],
      approved: json['approved'] == true || json['approved'] == 1,
      clicks: json['clicks'] is int
          ? json['clicks']
          : int.tryParse(json['clicks']?.toString() ?? '0') ?? 0,
      isRanked: json['isRanked'] == true || json['isRanked'] == 1,
      userId: json['userId']?.toString(),
      user: json['user'] != null
          ? UserModel.fromMap(json['user'] as Map<String, dynamic>)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{
      'companyName': companyName,
      'companyDescription': companyDescription,
      'companyUrl': companyUrl,
      'companyPhoto': companyPhoto,
      'companyEmail': companyEmail,
      'companyPhone': companyPhone,
      'location': location,
      'partnershipType': partnershipType,
      'category': category,
      'approved': approved,
      'clicks': clicks,
      'isRanked': isRanked,
      'userId': userId,
      if (user != null) 'user': user!.toMap(),
    };

    if (id != null) data['id'] = id;
    if (createdAt != null) data['createdAt'] = createdAt!.toIso8601String();
    if (updatedAt != null) data['updatedAt'] = updatedAt!.toIso8601String();

    return data;
  }

  static Partner fromJsonString(String jsonStr) =>
      Partner.fromJson(json.decode(jsonStr));

  String toJsonString() => json.encode(toJson());

  Partner copyWith({
    int? id,
    String? companyName,
    String? companyDescription,
    String? companyUrl,
    String? companyPhoto,
    String? companyEmail,
    String? companyPhone,
    String? location,
    String? partnershipType,
    String? category,
    bool? approved,
    int? clicks,
    bool? isRanked,
    String? userId,
    UserModel? user,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Partner(
      id: id ?? this.id,
      companyName: companyName ?? this.companyName,
      companyDescription: companyDescription ?? this.companyDescription,
      companyUrl: companyUrl ?? this.companyUrl,
      companyPhoto: companyPhoto ?? this.companyPhoto,
      companyEmail: companyEmail ?? this.companyEmail,
      companyPhone: companyPhone ?? this.companyPhone,
      location: location ?? this.location,
      partnershipType: partnershipType ?? this.partnershipType,
      category: category ?? this.category,
      approved: approved ?? this.approved,
      clicks: clicks ?? this.clicks,
      isRanked: isRanked ?? this.isRanked,
      userId: userId ?? this.userId,
      user: user ?? this.user,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
