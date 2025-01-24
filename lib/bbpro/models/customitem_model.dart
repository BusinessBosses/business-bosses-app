import 'package:business_bosses_v2/bbpro/models/shop_model.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';

class Customitem {
  List<String>? images;
  int id;
  UserModel? user;
  Shop? shop;
  String title;
  String description;
  String? url;
  DateTime createdAt;

  Customitem({
    this.images,
    required this.id,
    this.user,
    this.shop,
    required this.title,
    required this.description,
    this.url,
    required this.createdAt,
  });

  factory Customitem.fromJson(Map<String, dynamic> json) {
    return Customitem(
      images: json['images'] != null && json['images'] is List
          ? List<String>.from(json['images'])
          : <String>[],
      id: json['id'],
      user: json['user'] != null ? UserModel.fromMap(json['user']) : null,
      shop: json['shop'] != null ? Shop.fromMap(json['shop']) : null,
      title: json['title'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'images': images,
      'id': id,
      'user': user?.toMap(),
      'shop': shop?.toMap(),
      'title': title,
      'description': description,
      'url': url,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return '''
Service {
  id: $id,
  name: $title,
  description: $description,
  url: $url,
  createdAt: ${createdAt.toIso8601String()},
}
''';
  }
}
