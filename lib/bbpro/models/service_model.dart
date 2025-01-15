import 'package:business_bosses_v2/bbpro/models/shop_model.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';

class Service {
  List<String>? images;
  int id;
  UserModel? user;
  Shop? shop;
  String name;
  double price;
  double discount;
  String description;
  String? notes;
  String? category;
  String location;
  String? paymentMethod;
  String? deliveryMethod;
  String? url;
  String itemType;
  bool isActive;
  String? deliveryTime;
  DateTime? availableTime;
  String? serviceType;
  String? participants;
  String? repeat;
  DateTime createdAt;
  Map<String, dynamic>? availability;
  List<dynamic> packages;
  List<dynamic> selectedDates;
  int? serviceDuration;

  Service({
    this.images,
    required this.id,
    this.user,
    this.shop,
    required this.name,
    required this.price,
    required this.discount,
    required this.description,
    this.category,
    required this.location,
    this.paymentMethod,
    this.deliveryMethod,
    this.participants,
    this.repeat,
    this.url,
    this.notes,
    required this.itemType,
    required this.isActive,
    this.deliveryTime,
    this.availableTime,
    this.serviceType,
    required this.createdAt,
    this.availability,
    this.packages = const <Map<String, dynamic>>[],
    this.selectedDates = const <dynamic>[],
    this.serviceDuration,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      images: json['images'] != null && json['images'] is List
          ? List<String>.from(json['images'])
          : <String>[],
      id: json['id'],
      user: json['user'] != null ? UserModel.fromMap(json['user']) : null,
      shop: json['shop'] != null ? Shop.fromMap(json['shop']) : null,
      name: json['name'],
      price: double.parse(json['price'].toString()),
      discount: json['discount'] == null
          ? 0
          : double.parse(json['discount'].toString()),
      description: json['description'],
      category: json['category'],
      location: json['location'],
      paymentMethod: json['paymentMethod'],
      deliveryMethod: json['deliveryMethod'],
      url: json['url'],
      participants: json['participants'],
      repeat: json['repeat'],
      itemType: json['itemType'],
      isActive: json['isActive'],
      deliveryTime: json['deliveryTime'],
      serviceType: json['serviceType'],
      createdAt: DateTime.parse(json['createdAt']),
      availability: json['availability'] ?? json['serviceAvailability'],
      packages: json['packages'] ?? <dynamic>[],
      selectedDates: json['selectedDates'] ?? <dynamic>[],
      notes: json['notes'],
      serviceDuration: json['serviceDuration'],
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
      'itemType': itemType,
      'isActive': isActive,
      'deliveryTime': deliveryTime,
      'serviceType': serviceType,
      'createdAt': createdAt.toIso8601String(),
      'availability': availability.toString(),
      'packages': packages,
      'notes': notes,
      'participants': participants,
      'repeat': repeat,
      'selectedDates': selectedDates,
      'serviceDuration': serviceDuration,
    };
  }

  @override
  String toString() {
    return '''
Service {
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
  itemType: $itemType,
  isActive: $isActive,
  user: $user,
  shop: $shop,
  deliveryTime: $deliveryTime,
  serviceType: $serviceType,
  createdAt: ${createdAt.toIso8601String()},
  images: $images, 
  availability: $availability,
  packages: $packages,
  notes: $notes,
  participants: $participants,
  repeat: $repeat,
  selectedDates: $selectedDates,
  serviceDuration: $serviceDuration, 
}
''';
  }
}
