import 'dart:convert';

class ShopStats {
  final num views;
  final num clientCount;
  final num projectCount;
  final num totalAmount;
  ShopStats({
    required this.views,
    this.clientCount = 0,
    this.projectCount = 0,
    this.totalAmount = 0,
  });

  ShopStats copyWith({
    int? views,
    int? clientCount,
    int? projectCount,
    int? totalAmount,
  }) {
    return ShopStats(
      views: views ?? this.views,
      clientCount: clientCount ?? this.clientCount,
      projectCount: projectCount ?? this.projectCount,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'views': views,
      'clientCount': clientCount,
      'projectCount': projectCount,
      'totalAmount': totalAmount,
    };
  }

  factory ShopStats.fromMap(Map<String, dynamic> map) {
    return ShopStats(
      views: num.parse(map['views'].toString()),
      clientCount: num.parse(map['clientCount'].toString()),
      projectCount: num.parse(map['projectCount'].toString()),
      totalAmount: map['totalAmount'] == null
          ? 0
          : num.parse(map['totalAmount'].toString()),
    );
  }

  String toJson() => json.encode(toMap());

  factory ShopStats.fromJson(String source) =>
      ShopStats.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ShopStats(views: $views, clientCount: $clientCount, projectCount: $projectCount, totalAmount: $totalAmount)';
  }
}
