class ShopGraphData {
  final int totalSales;
  final List<GraphDataPoint> graphData;
  final String xAxis;

  ShopGraphData({
    required this.totalSales,
    required this.graphData,
    required this.xAxis,
  });

  factory ShopGraphData.fromJson(Map<String, dynamic> json) {
    return ShopGraphData(
      totalSales: json['totalSales'],
      graphData: (json['graphData'] as List<dynamic>)
          .map((dynamic dataPoint) => GraphDataPoint.fromJson(dataPoint))
          .toList(),
      xAxis: json['xAxis'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'totalSales': totalSales,
      'graphData': graphData
          .map((GraphDataPoint dataPoint) => dataPoint.toJson())
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
    required this.totalAmount,
  });

  factory GraphDataPoint.fromJson(Map<String, dynamic> json) {
    return GraphDataPoint(
      date: json['date'],
      totalAmount: json['totalAmount'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'date': date,
      'totalAmount': totalAmount,
    };
  }
}
