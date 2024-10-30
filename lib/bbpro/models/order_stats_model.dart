class OrderStats {
  final num totalOrders;
  final num online;
  final num inPerson;
  final num pickup;
  final num failed;
  final num pending;
  final num processed;
  final num cancelled;
  final num paid;

  OrderStats({
    required this.totalOrders,
    required this.online,
    required this.inPerson,
    required this.pickup,
    required this.failed,
    required this.pending,
    required this.processed,
    required this.cancelled,
    required this.paid,
  });

  factory OrderStats.fromJson(Map<String, dynamic> json) {
    return OrderStats(
      totalOrders: num.parse(json['totalOrders'].toString()),
      online: num.parse(json['online'].toString()),
      inPerson: num.parse(json['in_person'].toString()),
      pickup: num.parse(json['pickup'].toString()),
      failed: num.parse(json['failed'].toString()),
      pending: num.parse(json['pending'].toString()),
      processed: num.parse(json['processed'].toString()),
      cancelled: num.parse(json['cancelled'].toString()),
      paid: num.parse(json['paid'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'totalOrders': totalOrders,
      'online': online,
      'in_person': inPerson,
      'pickup': pickup,
      'failed': failed,
      'pending': pending,
      'processed': processed,
      'cancelled': cancelled,
      'paid': paid,
    };
  }
}
