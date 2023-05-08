// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class IndustryModel {
  String industryId;
  String industry;
  String? photo;
  String description;
  List<String>? joinedUsers;
  int timestamp;
  bool active;
  String categoryId;
  IndustryModel({
    required this.industryId,
    required this.industry,
    this.photo,
    required this.description,
    this.joinedUsers,
    required this.timestamp,
    required this.active,
    required this.categoryId,
  });

  IndustryModel copyWith({
    String? industryId,
    String? industry,
    String? photo,
    String? description,
    List<String>? joinedUsers,
    int? timestamp,
    bool? active,
    String? categoryId,
  }) {
    return IndustryModel(
      industryId: industryId ?? this.industryId,
      industry: industry ?? this.industry,
      photo: photo ?? this.photo,
      description: description ?? this.description,
      joinedUsers: joinedUsers ?? this.joinedUsers,
      timestamp: timestamp ?? this.timestamp,
      active: active ?? this.active,
      categoryId: categoryId ?? this.categoryId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'industryId': industryId,
      'industry': industry,
      'photo': photo,
      'description': description,
      'joinedUsers': joinedUsers,
      'timestamp': timestamp,
      'active': active,
      'categoryId': categoryId,
    };
  }

  factory IndustryModel.fromMap(Map<String, dynamic> map) {
    return IndustryModel(
      industryId: map['industryId'] as String,
      industry: map['industry'] as String,
      photo: map['photo'] != null ? map['photo'] as String : null,
      description: map['description'] as String,
      joinedUsers: map['joinedUsers'] != null
          ? List<String>.from((map['joinedUsers'] as List<String>))
          : null,
      timestamp: map['timestamp'] as int,
      active: map['active'] as bool,
      categoryId: map['categoryId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory IndustryModel.fromJson(String source) =>
      IndustryModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'IndustryModel(industryId: $industryId, industry: $industry, photo: $photo, description: $description, joinedUsers: $joinedUsers, timestamp: $timestamp, active: $active, categoryId: $categoryId)';
  }

  @override
  bool operator ==(covariant IndustryModel other) {
    if (identical(this, other)) return true;

    return other.industryId == industryId &&
        other.industry == industry &&
        other.photo == photo &&
        other.description == description &&
        listEquals(other.joinedUsers, joinedUsers) &&
        other.timestamp == timestamp &&
        other.active == active &&
        other.categoryId == categoryId;
  }

  @override
  int get hashCode {
    return industryId.hashCode ^
        industry.hashCode ^
        photo.hashCode ^
        description.hashCode ^
        joinedUsers.hashCode ^
        timestamp.hashCode ^
        active.hashCode ^
        categoryId.hashCode;
  }
}
