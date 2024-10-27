import 'package:business_bosses_v2/bbpro/models/shop_model.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';

class Product {
  List<String>? images;
  int id;
  UserModel? user;
  Shop? shop;
  String name;
  double price;
  double discount;
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
  String? productNumber;
  int? quantity;
  DateTime? startAt;
  DateTime? endAt;
  List<String>? color;
  List<String>? size;
  DateTime? createdAt;

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
    this.startAt,
    this.endAt,
    this.color,
    this.size,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      images: json['images'] != null ? List<String>.from(json['images']) : null,
      id: json['id'],
      user: json['user'] != null ? UserModel.fromMap(json['user']) : null,
      shop: json['shop'] != null ? Shop.fromMap(json['shop']) : null,
      name: json['name'],
      price: double.parse(json['price'].toString()),
      discount: double.parse(json['discount'].toString()),
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
      productNumber: json['productNumber'].toString(),
      quantity:
          json['quantity'] != null ? int.parse(json['quantity'].toString()) : 0,
      startAt: json['startAt'] == null ? null : DateTime.parse(json['startAt']),
      endAt: json['endAt'] == null ? null : DateTime.parse(json['endAt']),
      color: json['color'] != null ? List<String>.from(json['color']) : null,
      size: json['size'] != null ? List<String>.from(json['size']) : null,
      createdAt: null,
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
      'quantity': quantity ?? 0, // Ensure quantity is not null
      'startAt': startAt == null ? null : startAt!.toIso8601String(),
      'endAt': endAt == null ? null : endAt!.toIso8601String(),
      'color': color,
      'size': size,
      // 'createdAt': createdAt.toIso8601String(),
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
  startAt: ${startAt == null ? null : startAt!.toIso8601String()},
  endAt: ${endAt == null ? null : endAt!.toIso8601String()},
  
  images: $images
}
''';
  }
}
