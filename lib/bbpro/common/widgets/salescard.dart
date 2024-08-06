import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SalesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 15),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Wrap(
                  children: [
                    Text(
                      'Sales',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      ' - Breakdown',
                      style: TextStyle(
                          fontSize: 15,
                          color: proprimaryColor,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: prosemibackColor,
                          borderRadius: BorderRadius.circular(30)),
                      child: Icon(
                        Icons.visibility_off,
                        color: proprimaryColor,
                        size: 15,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '\$19.4k',
                      style: TextStyle(
                          color: proprimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  '128,7K',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.only(right: 5),
              height: 100,
              width: double.infinity,
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: 6,
                  minY: 0,
                  maxY: 1000,
                  titlesData: FlTitlesData(
                    leftTitles: SideTitles(showTitles: true, interval: 200),
                    bottomTitles: SideTitles(
                        showTitles: true,
                        getTitles: (value) {
                          switch (value.toInt()) {
                            case 0:
                              return 'Mon';
                            case 1:
                              return 'Tue';
                            case 2:
                              return 'Wed';
                            case 3:
                              return 'Thu';
                            case 4:
                              return 'Fri';
                            case 5:
                              return 'Sat';
                            case 6:
                              return 'Sun';
                            default:
                              return '';
                          }
                        }),
                  ),
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      isStrokeCapRound: true,
                      spots: [
                        FlSpot(0, 150),
                        FlSpot(1, 250),
                        FlSpot(2, 100),
                        FlSpot(3, 300),
                        FlSpot(4, 500),
                        FlSpot(5, 400),
                        FlSpot(6, 700),
                      ],
                      isCurved: true,
                      colors: [proprimaryColor],
                      barWidth: 4,
                      belowBarData: BarAreaData(
                        show: true,
                        colors: [prosemibackColor.withAlpha(150)],
                      ),
                      dotData: FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
