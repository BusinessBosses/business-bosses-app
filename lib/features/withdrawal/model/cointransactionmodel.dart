// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:business_bosses_v2/common/models/user_model.dart';

class CoinTransaction {
  final String id;
  final String userId;
  final String transactionType;
  final DateTime date;
  final int amount;
  final String? status;
  final bool? approved;
  final String? paymentMethod;
  final String? description;
  final int? duration;
  final bool? deleted;
  final DateTime? deletedAt;
  final UserModel? user;

  CoinTransaction({
    required this.id,
    required this.userId,
    required this.transactionType,
    required this.date,
    required this.amount,
    required this.status,
    this.approved,
    this.paymentMethod,
    this.description,
    this.duration,
    this.deleted,
    this.deletedAt,
    this.user,
  });

  factory CoinTransaction.fromMap(Map<String, dynamic> map) {
    return CoinTransaction(
      id: map['id'] as String,
      date: DateTime.parse(map['date']),
      amount: int.parse(map['amount']),
      description: map['description'] as String?,
      userId: '',
      transactionType: map['transactionType'] as String,
      status: '',
    );
  }

  void toMap() {}
}
