// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Vendor {
  final List<String> images;
  final String id;
  final String userId;
  final String name;
  final String phone;
  final String email;
  final String description;
  final String url;
  final String category;
  final String location;

  Vendor({
    required this.images,
    required this.id,
    required this.userId,
    required this.name,
    required this.phone,
    required this.email,
    required this.description,
    required this.url,
    required this.category,
    required this.location,
  });

  Vendor copyWith({
    List<String>? images,
    String? id,
    String? userId,
    String? name,
    String? phone,
    String? email,
    String? description,
    String? url,
    String? category,
    String? location,
  }) {
    return Vendor(
      images: images ?? this.images,
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      description: description ?? this.description,
      url: url ?? this.url,
      category: category ?? this.category,
      location: location ?? this.location,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'images': images,
      'id': id,
      'userId': userId,
      'name': name,
      'phone': phone,
      'email': email,
      'description': description,
      'url': url,
      'category': category,
      'location': location,
    };
  }

  factory Vendor.fromMap(Map<String, dynamic> map) {
    return Vendor(
      images: List<String>.from((map['images'] as List<String>)),
      id: map['id'] as String,
      userId: map['userId'] as String,
      name: map['name'] as String,
      phone: map['phone'] as String,
      email: map['email'] as String,
      description: map['description'] as String,
      url: map['url'] as String,
      category: map['category'] as String,
      location: map['location'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Vendor.fromJson(String source) =>
      Vendor.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Vendor(images: $images, id: $id, userId: $userId, name: $name, phone: $phone, email: $email, description: $description, url: $url, category: $category, location: $location)';
  }
}
