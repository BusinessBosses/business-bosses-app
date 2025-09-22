import 'package:flutter/foundation.dart';

class Match {
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

  const Match({
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
  });

  /// Factory constructor to create a Match instance from a JSON map.
  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json['uid'] ?? UniqueKey().toString(),
      name: json['name'] ?? 'No Name Provided',
      type: json['type'] ?? 'General',
      description: json['description'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      location: json['location'] ?? 'Not Specified',
      responseTime: json['responseTime'] ?? 'Not available',
      budget: json['budget'],
      quality: (json['quality'] ?? 0).toInt(),
      verified: json['verified'] ?? false,
      photoUrl: json['photoUrl'],

      // CHANGED: Now looks for the 'services' key from the JSON
      services: List<String>.from(json['services'] ?? <dynamic>[]),

      // ADDED: Parses the 'achievements' key from the JSON
      achievements: List<String>.from(json['achievements'] ?? <dynamic>[]),
    );
  }
}
