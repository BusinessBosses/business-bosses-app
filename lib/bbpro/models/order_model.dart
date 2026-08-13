import 'package:business_bosses_v2/bbpro/models/client_model.dart';
import 'package:business_bosses_v2/bbpro/models/product_model.dart';
import 'package:business_bosses_v2/bbpro/models/service_model.dart';
import 'package:business_bosses_v2/bbpro/models/shop_model.dart';
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
  final Shop shop;
  final DateTime? startTime;
  final DateTime? endTime;
  final int? quantity;

  /// Coin escrow for this order, when it was paid in coins. Null otherwise.
  final OrderEscrow? escrow;

  Order({
    this.quantity,
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
    required this.shop,
    this.startTime,
    this.endTime,
    this.escrow,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      quantity: json['quantity'],
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
      escrow: json['escrow'] == null
          ? null
          : OrderEscrow.fromJson(json['escrow'] as Map<String, dynamic>),
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
      shop: Shop.fromMap(json['shop']),
      startTime:
          json['startTime'] == null ? null : DateTime.parse(json['startTime']),
      endTime: json['endTime'] == null ? null : DateTime.parse(json['endTime']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'quantity': quantity,
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
      'startTime': startTime,
      'endTime': endTime,
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
  /// Not a real order status — a pseudo-value used as the "show everything"
  /// filter tab. It must never be written back to the server; use
  /// [isPersistable] before sending a status in a request body.
  allorders,
  pending,
  paid,
  completed,
  cancelled;

  static OrderStatus fromString(String? status) {
    switch (status) {
      case 'all orders':
        return OrderStatus.allorders;
      case 'pending':
        return OrderStatus.pending;
      case 'paid':
        return OrderStatus.paid;
      case 'completed':
        return OrderStatus.completed;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        // Legacy/unknown values ('processed', 'failed', null) must not blow
        // up the whole order list — one bad row used to throw here and take
        // the entire parse down with it.
        debugPrint('Unknown order status "$status", treating as pending');
        return OrderStatus.pending;
    }
  }

  /// False for [allorders], which is a filter, not a status.
  bool get isPersistable => this != OrderStatus.allorders;

  String get displayTitle {
    switch (this) {
      case OrderStatus.allorders:
        return 'All Orders';
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.paid:
        return 'Paid';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color get backgroundColor {
    switch (this) {
      case OrderStatus.allorders:
        return Colors.white;
      case OrderStatus.pending:
        return Colors.amber.withValues(alpha: 0.1);
      case OrderStatus.paid:
        return Colors.blue.withValues(alpha: 0.1);
      case OrderStatus.completed:
        return Colors.green.withValues(alpha: 0.1);
      case OrderStatus.cancelled:
        return Colors.red.withValues(alpha: 0.1);
    }
  }

  /// The exact string the API stores in `orders.status`.
  @override
  String toString() {
    switch (this) {
      case OrderStatus.allorders:
        return 'all orders';
      case OrderStatus.pending:
        return 'pending';
      case OrderStatus.paid:
        return 'paid';
      case OrderStatus.completed:
        return 'completed';
      case OrderStatus.cancelled:
        return 'cancelled';
    }
  }
}

/// The coin hold attached to an order: the buyer's coins are held until the
/// seller delivers, then released after the hold period.
///
/// "escrow" is internal naming only — never surface the word in UI copy. Tell
/// the seller their coins are held for [holdDays] days.
class OrderEscrow {
  const OrderEscrow({
    required this.status,
    required this.coinAmount,
    this.releaseAt,
    this.buyerId,
    this.sellerId,
    this.holdDays = 7,
  });

  /// held | delivered | released | refunded
  final String status;
  final int coinAmount;
  final DateTime? releaseAt;
  final String? buyerId;
  final String? sellerId;

  /// Days the coins stay held after delivery. Server-driven so the copy
  /// matches the actual release schedule.
  final int holdDays;

  factory OrderEscrow.fromJson(Map<String, dynamic> json) {
    return OrderEscrow(
      status: (json['status'] ?? '').toString(),
      coinAmount: (json['coinAmount'] as num?)?.toInt() ?? 0,
      releaseAt: json['releaseAt'] == null
          ? null
          : DateTime.tryParse(json['releaseAt'].toString()),
      buyerId: json['buyerId']?.toString(),
      sellerId: json['sellerId']?.toString(),
      holdDays: (json['holdDays'] as num?)?.toInt() ?? 7,
    );
  }

  /// "7 days" / "1 day".
  String get holdDurationLabel =>
      '$holdDays ${holdDays == 1 ? 'day' : 'days'}';

  /// Coins are paid but not yet the seller's.
  bool get isOnHold => status == 'held' || status == 'delivered';
  bool get isReleased => status == 'released';
  bool get isRefunded => status == 'refunded';

  /// Any escrow record at all means the buyer has paid in coins.
  bool get isPaid => status.isNotEmpty && !isRefunded;
}
