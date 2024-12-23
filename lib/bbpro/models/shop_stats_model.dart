import 'dart:convert';

class ShopStats {
  final num views;
  final num clientCount;
  final num projectCount;
  final num totalAmount;
  final num totalExpenses;
  ShopStats({
    required this.views,
    this.clientCount = 0,
    this.projectCount = 0,
    this.totalAmount = 0,
    this.totalExpenses = 0,
  });

  ShopStats copyWith({
    num? views,
    num? clientCount,
    num? projectCount,
    num? totalAmount,
    num? totalExpenses,
  }) {
    return ShopStats(
      views: views ?? this.views,
      clientCount: clientCount ?? this.clientCount,
      projectCount: projectCount ?? this.projectCount,
      totalAmount: totalAmount ?? this.totalAmount,
      totalExpenses: totalExpenses ?? this.totalExpenses,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'views': views,
      'clientCount': clientCount,
      'projectCount': projectCount,
      'totalAmount': totalAmount,
      'totalExpenses': totalExpenses,
    };
  }

  factory ShopStats.fromMap(Map<String, dynamic> map) {
    return ShopStats(
      views: map['views'] == null ? 0 : num.parse(map['views'].toString()),
      clientCount: map['clientCount'] == null
          ? 0
          : num.parse(map['clientCount'].toString()),
      projectCount: map['projectCount'] == null
          ? 0
          : num.parse(map['projectCount'].toString()),
      totalAmount: map['totalAmount'] == null
          ? 0
          : num.parse(map['totalAmount'].toString()),
      totalExpenses: map['totalExpenses'] == null
          ? 0
          : num.parse(map['totalExpenses'].toString()),
    );
  }

  String toJson() => json.encode(toMap());

  factory ShopStats.fromJson(String source) =>
      ShopStats.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ShopStats(views: $views, clientCount: $clientCount, projectCount: $projectCount, totalAmount: $totalAmount, totalExpenses: $totalExpenses)';
  }
}
