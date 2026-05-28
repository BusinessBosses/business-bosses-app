import 'package:business_bosses_v2/common/models/user_model.dart';

class Shop {
  final String id;
  final String userId;
  final String name;
  final String description;
  final String? image;
  final String? email;
  final String? phone;
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
  final String? linkedIn;
  final String? instagram;
  final String? url;
  final DateTime createdAt;
  final String currency;
  final String appId;
  final UserModel? user;
  final String? imageType;
  final String category; // Added category field
  final List<dynamic> keyIndividualDocs;
  final List<dynamic> businessRegDocs;
  final List<dynamic> proofOfAddressDocs;
  final String verificationStatus;

  Shop({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    this.image,
    this.email = '',
    this.phone = '',
    required this.location,
    this.views = 0,
    this.timestamp,
    required this.payments,
    required this.promote,
    this.promotionDuration,
    this.approved = false,
    this.plan,
    required this.currency,
    required this.appId,
    required this.createdAt,
    this.user,
    this.facebook,
    this.twitter,
    this.linkedIn,
    this.instagram,
    this.url,
    this.imageType = 'circle',
    required this.category, // Added parameter in constructor
    required this.keyIndividualDocs,
    required this.businessRegDocs,
    required this.proofOfAddressDocs,
    required this.verificationStatus,
  });

  factory Shop.fromMap(Map<String, dynamic> json) {
    return Shop(
      id: json['id'],
      userId: json['userId'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      location: json['location'],
      views: double.parse(json['views'].toString()).toInt(),
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
      linkedIn: json['linkedIn'],
      instagram: json['instagram'],
      url: json['url'],
      appId: json['appId'],
      createdAt: DateTime.parse(json['createdAt']),
      user: json['user'] != null ? UserModel.fromMap(json['user']) : null,
      imageType: json['imageType'] ?? 'circle',
      category: json['category'] ?? '', // Added fromMap mapping
      keyIndividualDocs: json['keyIndividualDocs'] ?? <dynamic>[],
      businessRegDocs: json['businessRegDocs'] ?? <dynamic>[],
      proofOfAddressDocs: json['proofOfAddressDocs'] ?? <dynamic>[],
      verificationStatus: json['verificationStatus'] ?? 'pending',
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
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
      'linkedIn': linkedIn,
      'url': url,
      'appId': appId,
      'createdAt': createdAt.toIso8601String(),
      'user': user?.toMap(),
      'imageType': imageType,
      'category': category, // Added toMap mapping
      'keyIndividualDocs': keyIndividualDocs,
      'businessRegDocs': businessRegDocs,
      'proofOfAddressDocs': proofOfAddressDocs,
      'verificationStatus': verificationStatus,
    };
  }
}
