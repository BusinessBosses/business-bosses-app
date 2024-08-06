import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OrdersWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
      child: Container(
        padding: const EdgeInsets.all(10.0),
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
                Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
                  Text(
                    'Orders',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    ' - Breakdown',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: proprimaryColor,
                    ),
                  ),
                ]),
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
                      '9',
                      style: TextStyle(
                          color: proprimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: 165, // Adjust the width as needed
                  height: 165, // Adjust the height as needed
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          color: Colors.blue,
                          value: 430,
                          title: '',
                          radius: 40, // Reduced radius
                        ),
                        PieChartSectionData(
                          color: Colors.purple,
                          value: 430,
                          title: '',
                          radius: 40, // Reduced radius
                        ),
                        PieChartSectionData(
                          color: Colors.yellow,
                          value: 430,
                          title: '',
                          radius: 40, // Reduced radius
                        ),
                        PieChartSectionData(
                          color: Colors.green,
                          value: 430,
                          title: '',
                          radius: 40, // Reduced radius
                        ),
                        PieChartSectionData(
                          color: Colors.red,
                          value: 430,
                          title: '',
                          radius: 40, // Reduced radius
                        ),
                      ],
                      sectionsSpace: 0,
                      centerSpaceRadius: 35, // Reduced center space radius
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Indicator(
                      color: Colors.blue,
                      text: 'Online',
                      value: 430,
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Indicator(
                      color: Colors.purple,
                      text: 'In Person',
                      value: 430,
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Indicator(
                      color: Colors.yellow,
                      text: 'Pending',
                      value: 430,
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Indicator(
                      color: Colors.green,
                      text: 'Paid',
                      value: 430,
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Indicator(
                      color: Colors.red,
                      text: 'Cancelled',
                      value: 430,
                    ),
                  ],
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                    color: prosemibackColor,
                    borderRadius: BorderRadius.circular(8)),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text('View All Orders'),
                    SizedBox(width: 5),
                    SvgPicture.asset(
                      'assets/svgs/nexticon.svg',
                      color: proprimaryColor,
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

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final int value;

  const Indicator({
    required this.color,
    required this.text,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(5),
            color: color,
          ),
        ),
        SizedBox(width: 8),
        Text('$text  $value'),
      ],
    );
  }
}
