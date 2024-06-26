import 'dart:convert';

import 'package:business_bosses_v2/common/models/user_model.dart';

class SuppliersModel {
  String id;
  String? category;
  String? location;
  String description;
  String name;
  String phone;
  String? email;
  UserModel? user;
  bool isVerified;
  bool isApproved;
  String? url;
  SuppliersModel({
    required this.id,
    this.category,
    required this.name,
    required this.phone,
    required this.description,
    this.location,
    this.email,
    this.user,
    this.isVerified = false,
    this.isApproved = false,
    required this.url,
  });

  SuppliersModel copyWith({
    String? id,
    String? category,
    String? location,
    String? description,
    String? name,
    String? phone,
    UserModel? user,
    bool? isVerified,
    bool? isApproved,
    String? email,
    String? url,
  }) {
    return SuppliersModel(
      description: description ?? this.description,
      location: location ?? this.location,
      user: user ?? this.user,
      category: category ?? this.category,
      id: id ?? this.id,
      phone: phone ?? this.phone,
      name: name ?? this.name,
      isVerified: isVerified ?? this.isVerified,
      isApproved: isApproved ?? this.isApproved,
      email: email ?? this.email,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'description': description,
      'location': location,
      'user': user?.toMap(),
      'category': category,
      'id': id,
      'phone': phone,
      'name': name,
      'isVerified': isVerified,
      'isApproved': isApproved,
      'email': email,
      'url': url,
    };
  }

  factory SuppliersModel.fromMap(Map<String, dynamic> map) {
    return SuppliersModel(
      description: map['description'] as String,
      user: map['user'] != null
          ? UserModel.fromMap(map['user'] as Map<String, dynamic>)
          : null,
      category: map['category'] != null ? map['category'] as String : null,
      location: map['location'] != null ? map['location'] as String : null,
      id: map['id'] as String,
      phone: map['phone'] as String,
      name: map['name'] as String,
      isVerified: map['isVerified'] as bool,
      isApproved: map['isApproved'] as bool,
      email: map['email'] != null ? map['email'] as String : null,
      url: map['url'] != null ? map['url'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SuppliersModel.fromJson(String source) =>
      SuppliersModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SuppliersModel(description: $description, location: $location, name: $name, user: $user, category: $category, id: $id, phone: $phone, isVerified: $isVerified, isApproved: $isApproved, email: $email, url: $url)';
  }
}
