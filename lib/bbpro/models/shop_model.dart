import 'package:business_bosses_v2/common/models/user_model.dart';

class Shop {
  final String id;
  final String name;
  final String description;
  final String? image;
  final String email;
  final String phone;
  final String location;
  final int views;
  final DateTime? timestamp;
  final List<dynamic> payments;
  final bool promote;
  final int? promotionDuration;
  final bool? approved;
  final String? plan;
  final String? facebook;
  final String? twitter;
  final String? linkedin;
  final String? instagram;
  final DateTime createdAt;
  final String currency;
  final UserModel? user;

  Shop({
    required this.id,
    required this.name,
    required this.description,
    this.image,
    required this.email,
    required this.phone,
    required this.location,
    this.views = 0,
    this.timestamp,
    required this.payments,
    required this.promote,
    this.promotionDuration,
    this.approved = false,
    this.plan,
    required this.currency,
    required this.createdAt,
    this.user,
    this.facebook,
    this.twitter,
    this.linkedin,
    this.instagram,
  });

  factory Shop.fromMap(Map<String, dynamic> json) {
    return Shop(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      email: json['email'],
      phone: json['phone'],
      location: json['location'],
      views: int.parse(json['views'].toString()),
      timestamp:
          json['timestamp'] != null ? DateTime.parse(json['timestamp']) : null,
      payments: json['payments'] ?? <dynamic>[],
      promote: json['promote'],
      promotionDuration: json['promotionDuration'],
      approved: json['approved'] ?? false,
      plan: json['plan'],
      currency: json['currency'],
      facebook: json['facebook'],
      twitter: json['twitter'],
      linkedin: json['linkedin'],
      instagram: json['instagram'],
      createdAt: DateTime.parse(json['createdAt']),
      user: json['user'] != null ? UserModel.fromMap(json['user']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'email': email,
      'phone': phone,
      'location': location,
      'views': views,
      'timestamp': timestamp?.toIso8601String(),
      'payments': payments,
      'promote': promote,
      'promotionDuration': promotionDuration,
      'approved': approved,
      'plan': plan,
      'currency': currency,
      'facebook': facebook,
      'twitter': twitter,
      'instagram': instagram,
      'linkedin': linkedin,
      'createdAt': createdAt.toIso8601String(),
      'user': user?.toMap(),
    };
  }
}
