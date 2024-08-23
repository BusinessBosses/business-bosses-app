import 'package:business_bosses_v2/common/models/user_model.dart';

class Order {
  final String id;
  final String userId;
  final String shopId;
  final String clientId;
  final List<OrderItem> items;
  final String deliveryMethod;
  final DateTime deliveryDate;
  final String paymentMethod;
  final String notes;
  final String invoiceOption;
  final UserModel? user;
  final String status;

  Order({
    required this.id,
    required this.userId,
    required this.shopId,
    required this.clientId,
    required this.items,
    required this.deliveryMethod,
    required this.deliveryDate,
    required this.paymentMethod,
    required this.notes,
    required this.invoiceOption,
    this.user,
    required this.status,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['userId'],
      shopId: json['shopId'],
      clientId: json['clientId'],
      items: (json['items'] as List<dynamic>)
          .map((dynamic item) => OrderItem.fromJson(item))
          .toList(),
      deliveryMethod: json['deliveryMethod'],
      deliveryDate: DateTime.parse(json['deliveryDate']),
      paymentMethod: json['paymentMethod'],
      notes: json['notes'],
      invoiceOption: json['invoiceOption'],
      user: json['user'] == null ? null : UserModel.fromMap(json['user']),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'shopId': shopId,
      'clientId': clientId,
      'items': items.map((OrderItem item) => item.toJson()).toList(),
      'deliveryMethod': deliveryMethod,
      'deliveryDate': deliveryDate.toIso8601String(),
      'paymentMethod': paymentMethod,
      'notes': notes,
      'invoiceOption': invoiceOption,
      'user': user,
      'status': status,
    };
  }
}

class OrderItem {
  final String type;
  final int? id;
  final String? name;
  final double? amount;

  OrderItem({
    required this.type,
    this.id,
    this.name,
    this.amount,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      type: json['type'],
      id: json['id'],
      name: json['name'],
      amount: json['amount']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': type,
      'id': id,
      'name': name,
      'amount': amount,
    };
  }
}
