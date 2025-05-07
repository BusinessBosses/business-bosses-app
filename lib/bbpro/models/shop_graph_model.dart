class ShopGraphData {
  final int totalSales;
  final List<GraphDataPoint>? graphData;
  final String xAxis;

  ShopGraphData({
    required this.totalSales,
    required this.graphData,
    required this.xAxis,
  });

  factory ShopGraphData.fromJson(Map<String, dynamic> json) {
    return ShopGraphData(
      totalSales: json['totalSales'] ?? 0,
      graphData: json['graphData'] == null
          ? null
          : (json['graphData'] as List<dynamic>)
              .map((dynamic dataPoint) => GraphDataPoint.fromJson(dataPoint))
              .toList(),
      xAxis: json['xAxis'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'totalSales': totalSales,
      'graphData': graphData?.map((GraphDataPoint dataPoint) => dataPoint.toJson())
              .toList(),
      'xAxis': xAxis,
    };
  }
}

class GraphDataPoint {
  final String date;
  final int totalAmount;

  GraphDataPoint({
    required this.date,
    this.totalAmount = 0,
  });

  factory GraphDataPoint.fromJson(Map<String, dynamic> json) {
    return GraphDataPoint(
      date: json['date'],
      totalAmount: json['totalAmount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'date': date,
      'totalAmount': totalAmount,
    };
  }
}
