import 'package:business_bosses_v2/bbpro/models/shop_model.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';

class Product {
  List<String>? images;
  int id;
  UserModel? user;
  Shop? shop;
  String name;
  String price;
  String discount;
  String description;
  String category;
  String location;
  String paymentMethod;
  String deliveryMethod;
  String url;
  String? deliveryDuration;
  String itemType;
  bool isActive;
  String storageLocation;
  int productNumber;
  int quantity;
  DateTime startAt;
  DateTime endAt;
  String color;
  String size;
  DateTime createdAt;

  Product({
    this.images,
    required this.id,
    this.user,
    this.shop,
    required this.name,
    required this.price,
    required this.discount,
    required this.description,
    required this.category,
    required this.location,
    required this.paymentMethod,
    required this.deliveryMethod,
    required this.url,
    this.deliveryDuration,
    required this.itemType,
    required this.isActive,
    required this.storageLocation,
    required this.productNumber,
    required this.quantity,
    required this.startAt,
    required this.endAt,
    required this.color,
    required this.size,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      images: json['images'] != null ? List<String>.from(json['images']) : null,
      id: json['id'],
      user: json['user'] != null ? UserModel.fromMap(json['user']) : null,
      shop: json['shop'] != null ? Shop.fromMap(json['shop']) : null,
      name: json['name'],
      price: json['price'],
      discount: json['discount'],
      description: json['description'],
      category: json['category'],
      location: json['location'] ?? 'Nigeria',
      paymentMethod: json['paymentMethod'],
      deliveryMethod: json['deliveryMethod'],
      url: json['url'],
      deliveryDuration: json['deliveryDuration'],
      itemType: json['itemType'],
      isActive: json['isActive'],
      storageLocation: json['storageLocation'],
      productNumber: json['productNumber'] is int
          ? json['productNumber']
          : int.parse(json['productNumber']),
      quantity: json['quantity'] is int
          ? json['quantity']
          : int.parse(json['quantity']),
      startAt: DateTime.parse(json['startAt']),
      endAt: DateTime.parse(json['endAt']),
      color: json['color'],
      size: json['size'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'images': images,
      'id': id,
      'user': user?.toMap(),
      'shop': shop?.toMap(),
      'name': name,
      'price': price,
      'discount': discount,
      'description': description,
      'category': category,
      'location': location,
      'paymentMethod': paymentMethod,
      'deliveryMethod': deliveryMethod,
      'url': url,
      'deliveryDuration': deliveryDuration,
      'itemType': itemType,
      'isActive': isActive,
      'storageLocation': storageLocation,
      'productNumber': productNumber,
      'quantity': quantity,
      'startAt': startAt.toIso8601String(),
      'endAt': endAt.toIso8601String(),
      'color': color,
      'size': size,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return '''
Product {
  id: $id,
  name: $name,
  price: $price,
  discount: $discount,
  description: $description,
  category: $category,
  location: $location,
  paymentMethod: $paymentMethod,
  deliveryMethod: $deliveryMethod,
  url: $url,
  deliveryDuration: $deliveryDuration,
  itemType: $itemType,
  isActive: $isActive,
  user: $user,
  shop: $shop,
  storageLocation: $storageLocation,
  productNumber: $productNumber,
  quantity: $quantity,
  color: $color,
  size: $size,
  startAt: ${startAt.toIso8601String()},
  endAt: ${endAt.toIso8601String()},
  createdAt: ${createdAt.toIso8601String()},
  images: $images
}
''';
  }
}
