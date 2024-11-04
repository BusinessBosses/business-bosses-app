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
    this.totalOrders = 0,
    this.online = 0,
    this.inPerson = 0,
    this.pickup = 0,
    this.failed = 0,
    this.pending = 0,
    this.processed = 0,
    this.cancelled = 0,
    this.paid = 0,
  });

  factory OrderStats.fromJson(Map<String, dynamic> json) {
    return OrderStats(
      totalOrders: json['totalOrders'] != null
          ? 0
          : num.parse(json['totalOrders'].toString()),
      online: json['online'] != null ? 0 : num.parse(json['online'].toString()),
      inPerson: json['inPerson'] != null
          ? 0
          : num.parse(json['in_person'].toString()),
      pickup: json['pickup'] != null ? 0 : num.parse(json['pickup'].toString()),
      failed: json['failed'] != null ? 0 : num.parse(json['failed'].toString()),
      pending:
          json['pending'] != null ? 0 : num.parse(json['pending'].toString()),
      processed: json['processed'] != null
          ? 0
          : num.parse(json['processed'].toString()),
      cancelled: json['cancelled'] != null
          ? 0
          : num.parse(json['cancelled'].toString()),
      paid: json['paid'] != null ? 0 : num.parse(json['paid'].toString()),
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
