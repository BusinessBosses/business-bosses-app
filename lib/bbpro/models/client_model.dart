import 'dart:convert';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';

// Enum for client types
enum ClientType {
  allclients('All Clients', Colors.black),
  online('Online', Colors.blue),
  inPerson('In-Person', Colors.green),
  bbUser('Bb-User', primaryColorLT);

  const ClientType(this.displayTitle, this.backgroundColor);

  final String displayTitle;
  final Color backgroundColor;

  // Converts a string to a ClientType enum
  static ClientType fromString(String type) {
    switch (type) {
      case 'on-line':
        return ClientType.online;
      case 'in-person':
        return ClientType.inPerson;
      case 'bb-user':
        return ClientType.bbUser;
      default:
        return ClientType.online; // default value if the type doesn't match
    }
  }

  // Converts a ClientType enum to the correct string representation
  String toShortString() {
    return displayTitle;
  }

  // Converts a ClientType enum to the format expected by the API
  String toApiString() {
    switch (this) {
      case ClientType.online:
        return 'on-line';
      case ClientType.inPerson:
        return 'in-person';
      case ClientType.bbUser:
        return 'bb-user';
      default:
        return 'on-line'; // default value, if needed
    }
  }
}

// Client model
class Client {
  final String id;
  final String userId;
  final String name;
  final String email;
  final String phone;
  final ClientType type;
  final DateTime createdAt;
  final List<String> image;

  Client({
    required this.id,
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.type,
    required this.createdAt,
    required this.image,
  });

  factory Client.fromJson(String str) => Client.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Client.fromMap(Map<String, dynamic> json) => Client(
        id: json['id'],
        userId: json['userId'],
        name: json['name'],
        email: json['email'],
        phone: json['phone'],
        type: ClientType.fromString(json['type']),
        createdAt: DateTime.parse(json['createdAt']),
        image: List<String>.from(json['image']),
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'userId': userId,
        'name': name,
        'email': email,
        'phone': phone,
        'type': type.toShortString(),
        'createdAt': createdAt.toIso8601String(),
        'image': image,
      };
}
