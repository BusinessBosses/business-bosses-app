import 'dart:convert';

import 'package:business_bosses_v2/bbpro/models/shop_model.dart';
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
  List<dynamic>? images;
  bool? isBiz;
  Shop? shop; // Added shop model field

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
    this.images,
    this.isBiz = false,
    this.shop, // Added parameter in constructor
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
    List<dynamic>? images,
    bool? isBiz,
    Shop? shop,
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
      images: images ?? this.images,
      isBiz: isBiz ?? this.isBiz,
      shop: shop ?? this.shop, // Added in copyWith
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
      'images': images,
      'isBiz': isBiz,
      'shop': shop?.toMap(), // Added shop to map
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
      isBiz: map['isBiz'] ?? false,
      images: map['images'] != null
          ? List<dynamic>.from((map['images'] as List<dynamic>))
          : null,
      shop: map['shop'] != null
          ? Shop.fromMap(map['shop'] as Map<String, dynamic>)
          : null, // Deserialize shop if available
    );
  }

  String toJson() => json.encode(toMap());

  factory SuppliersModel.fromJson(String source) =>
      SuppliersModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SuppliersModel(description: $description, location: $location, name: $name, user: $user, category: $category, id: $id, phone: $phone, isVerified: $isVerified, isApproved: $isApproved, email: $email, url: $url, isBiz: $isBiz, shop: $shop)';
  }
}
