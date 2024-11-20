import 'package:business_bosses_v2/bbpro/models/client_model.dart';
import 'package:business_bosses_v2/bbpro/models/product_model.dart';
import 'package:business_bosses_v2/bbpro/models/service_model.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:flutter/material.dart';

class Order {
  final String id;
  final String userId;
  final String shopId;
  final String? clientId;
  final List<OrderItem>? items;
  final String deliveryMethod;
  final DateTime? deliveryDate;
  final String paymentMethod;
  final String? notes;
  final String invoiceOption;
  final UserModel? user;
  final Client? client;
  final OrderStatus status;
  final List<Product>? products;
  final List<dynamic>? customItems;
  final List<Service>? services;
  final DateTime createdAt;
  final String? orderDetails;

  Order({
    required this.id,
    required this.userId,
    required this.shopId,
    this.clientId,
    this.items,
    required this.deliveryMethod,
    this.deliveryDate,
    required this.paymentMethod,
    this.notes,
    required this.invoiceOption,
    this.user,
    required this.status,
    this.products,
    this.services,
    this.customItems,
    this.client,
    required this.createdAt,
    this.orderDetails,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['userId'],
      shopId: json['shopId'],
      clientId: json['clientId'],
      deliveryMethod: json['deliveryMethod'],
      deliveryDate: json['deliveryDate'] == null
          ? null
          : DateTime.parse(json['deliveryDate']),
      paymentMethod: json['paymentMethod'],
      notes: json['notes'],
      orderDetails: json['orderDetails'],
      invoiceOption: json['invoiceOption'],
      user: json['user'] == null ? null : UserModel.fromMap(json['user']),
      status: OrderStatus.fromString(json['status']),
      products: json['products'] != null
          ? (json['products'] as List<dynamic>)
              .map((dynamic item) => Product.fromJson(item))
              .toList()
          : <Product>[],
      customItems: json['customItems'] != null
          ? (json['customItems'] as List<dynamic>)
              .map((dynamic item) => item)
              .toList()
          : <dynamic>[],
      services: json['services'] != null
          ? (json['services'] as List<dynamic>)
              .map((dynamic item) => Service.fromJson(item))
              .toList()
          : <Service>[],
      client: json['client'] == null ? null : Client.fromMap(json['client']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'shopId': shopId,
      'clientId': clientId,
      'deliveryMethod': deliveryMethod,
      'deliveryDate': deliveryDate != null
          ? DateTime.now()
          : deliveryDate!.toIso8601String(),
      'paymentMethod': paymentMethod,
      'notes': notes,
      'invoiceOption': invoiceOption,
      'user': user,
      'client': client,
      'status': status,
      'products': products?.map((Product product) => product.toJson()).toList(),
      'services': services?.map((Service service) => service.toJson()).toList(),
      'createdAt': createdAt,
      'orderDetails': orderDetails,
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

enum OrderStatus {
  allorders,
  pending,
  paid,
  cancelled;

  static OrderStatus fromString(String status) {
    switch (status) {
      case 'all orders':
        return OrderStatus.allorders;
      case 'pending':
        return OrderStatus.pending;
      case 'paid':
        return OrderStatus.paid;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        throw ArgumentError('Unknown status: $status');
    }
  }

  String get displayTitle {
    switch (this) {
      case OrderStatus.allorders:
        return 'All Orders';
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.paid:
        return 'Paid';
      case OrderStatus.cancelled:
        return 'Completed';
    }
  }

  Color get backgroundColor {
    switch (this) {
      case OrderStatus.allorders:
        return Colors.white;
      case OrderStatus.pending:
        return Colors.amber.withOpacity(0.1);
      case OrderStatus.paid:
        return Colors.blue.withOpacity(0.1);
      case OrderStatus.cancelled:
        return Colors.green.withOpacity(0.1);
    }
  }

  @override
  String toString() {
    switch (this) {
      case OrderStatus.allorders:
        return 'all orders';
      case OrderStatus.pending:
        return 'pending';
      case OrderStatus.paid:
        return 'paid';
      case OrderStatus.cancelled:
        return 'cancelled';
    }
  }
}
