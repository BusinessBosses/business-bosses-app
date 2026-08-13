class OrderStats {
  final num totalOrders;
  final num online;
  final num inPerson;
  final num pickup;
  final num failed;
  final num pending;
  final num processed;
  final num completed;
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
    this.completed = 0,
    this.cancelled = 0,
    this.paid = 0,
  });

  static num _count(dynamic value) =>
      value == null ? 0 : num.tryParse(value.toString()) ?? 0;

  factory OrderStats.fromJson(Map<String, dynamic> json) {
    return OrderStats(
      totalOrders: _count(json['totalOrders']),
      online: _count(json['online']),
      // The null check was inverted, so this was 0 whenever the server
      // actually sent a value — which it always does.
      inPerson: _count(json['in_person']),
      pickup: _count(json['pickup']),
      failed: _count(json['failed']),
      pending: _count(json['pending']),
      processed: _count(json['processed']),
      // 'completed' and 'cancelled' are distinct counts now; older cached
      // payloads only carry 'cancelled', which is why this falls back to 0
      // rather than reusing it.
      completed: _count(json['completed']),
      cancelled: _count(json['cancelled']),
      paid: _count(json['paid']),
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
      'completed': completed,
      'cancelled': cancelled,
      'paid': paid,
    };
  }
}
