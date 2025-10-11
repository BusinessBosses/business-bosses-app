import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:flutter/material.dart';

class MatchModel {
  final String id;
  final String name;
  final String type;
  final String description;
  final double rating;
  final String location;
  final String responseTime;
  final String? budget;
  final int quality;
  final bool verified;
  final String? photoUrl;
  final List<String> services;
  final List<String>? achievements; // ADDED: To hold achievements
  final String? matchType;
  final UserModel user;

  const MatchModel({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.rating,
    required this.location,
    required this.responseTime,
    this.budget,
    required this.quality,
    required this.verified,
    this.photoUrl,
    required this.services,
    this.achievements, // ADDED: In constructor
    this.matchType,
    required this.user,
  });

  /// Factory constructor to create a Match instance from a JSON map.
  factory MatchModel.fromJson(Map<String, dynamic> json) {
    final dynamic userData = json['user'];

    List<String> parseStringList(dynamic value) {
      if (value == null) return <String>[];
      if (value is List) {
        return value.map((e) {
          if (e is Map && e.containsKey('name')) return e['name'].toString();
          return e.toString();
        }).toList();
      }
      return <String>[];
    }

    return MatchModel(
      id: json['uid']?.toString() ?? UniqueKey().toString(),
      name: json['name']?.toString() ?? 'No Name Provided',
      type: json['type']?.toString() ?? 'General',
      description: json['description']?.toString() ?? '',
      // 👇 FIX HERE: if no 'user', create a minimal UserModel
      user: ((userData is Map) || userData != null)
          ? UserModel.fromMap(userData)
          : UserModel(
              uid: json['uid']?.toString() ?? '',
              name: json['name']?.toString(),
              photoUrl: json['profile_image']?.toString(),
            ),
      rating: (json['rating'] is num)
          ? (json['rating'] as num).toDouble()
          : double.tryParse(json['rating']?.toString() ?? '0') ?? 0.0,
      location: json['location']?.toString() ?? 'Not Specified',
      responseTime: json['responseTime']?.toString() ?? 'Not available',
      budget: json['budget']?.toString(),
      quality: (json['quality'] is num)
          ? (json['quality'] as num).toInt()
          : int.tryParse(json['quality']?.toString() ?? '0') ?? 0,
      verified: json['verified'] == true,
      photoUrl: json['profile_image']?.toString(), // 👈 use API field
      matchType: json['matchType']?.toString(),
      services: parseStringList(json['services']),
      achievements: parseStringList(json['achievements']),
    );
  }

  /// Convert this Match instance into a Map (for saving in SharedPreferences).
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': id,
      'name': name,
      'type': type,
      'description': description,
      'rating': rating,
      'location': location,
      'responseTime': responseTime,
      'budget': budget,
      'quality': quality,
      'verified': verified,
      'photoUrl': photoUrl,
      'services': services,
      'achievements': achievements,
      'matchType': matchType,
      'user': user.toMap(),
    };
  }
}
