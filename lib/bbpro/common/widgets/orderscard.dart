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
                Text(
                  'Orders',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Icon(
                      Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      '9',
                      style: TextStyle(color: proprimaryColor),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Breakdown',
              style: TextStyle(
                fontSize: 16,
                color: proprimaryColor,
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Container(
                  width: 180,
                  height: 180,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          color: Colors.blue,
                          value: 430,
                          title: '',
                          radius: 50,
                        ),
                        PieChartSectionData(
                          color: Colors.purple,
                          value: 430,
                          title: '',
                          radius: 50,
                        ),
                        PieChartSectionData(
                          color: Colors.yellow,
                          value: 430,
                          title: '',
                          radius: 50,
                        ),
                        PieChartSectionData(
                          color: Colors.green,
                          value: 430,
                          title: '',
                          radius: 50,
                        ),
                        PieChartSectionData(
                          color: Colors.red,
                          value: 430,
                          title: '',
                          radius: 50,
                        ),
                      ],
                      sectionsSpace: 0,
                      centerSpaceRadius: 30,
                    ),
                  ),
                ),
                SizedBox(width: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Indicator(
                      color: Colors.blue,
                      text: 'Online',
                      value: 430,
                    ),
                    SizedBox(height: 3,),
                    Indicator(
                      color: Colors.purple,
                      text: 'In Person',
                      value: 430,
                    ),
                    SizedBox(height: 3,),
                    Indicator(
                      color: Colors.yellow,
                      text: 'Pending',
                      value: 430,
                    ),
                    SizedBox(height: 3,),
                    Indicator(
                      color: Colors.green,
                      text: 'Paid',
                      value: 430,
                    ),
                    SizedBox(height: 3,),
                    Indicator(
                      color: Colors.red,
                      text: 'Cancelled',
                      value: 430,
                    ),
                  ],
                ),
              ],
            )
            // Row(
            //   children: [
            //     Container(
            //       width: 100,
            //       height: 100,
            //       child: PieChart(
            //         PieChartData(
            //           sections: [
            //             PieChartSectionData(
            //               color: Colors.blue,
            //               value: 430,
            //               title: '',
            //               radius: 50,
            //             ),
            //             PieChartSectionData(
            //               color: Colors.purple,
            //               value: 430,
            //               title: '',
            //               radius: 50,
            //             ),
            //             PieChartSectionData(
            //               color: Colors.yellow,
            //               value: 430,
            //               title: '',
            //               radius: 50,
            //             ),
            //             PieChartSectionData(
            //               color: Colors.green,
            //               value: 430,
            //               title: '',
            //               radius: 50,
            //             ),
            //             PieChartSectionData(
            //               color: Colors.red,
            //               value: 430,
            //               title: '',
            //               radius: 50,
            //             ),
            //           ],
            //           sectionsSpace: 0,
            //           centerSpaceRadius: 30,
            //         ),
            //       ),
            //     ),
            //     SizedBox(width: 16),
            //     Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Indicator(
            //           color: Colors.blue,
            //           text: 'Online',
            //           value: 430,
            //         ),
            //         Indicator(
            //           color: Colors.purple,
            //           text: 'In Person',
            //           value: 430,
            //         ),
            //         Indicator(
            //           color: Colors.yellow,
            //           text: 'Pending',
            //           value: 430,
            //         ),
            //         Indicator(
            //           color: Colors.green,
            //           text: 'Paid',
            //           value: 430,
            //         ),
            //         Indicator(
            //           color: Colors.red,
            //           text: 'Cancelled',
            //           value: 430,
            //         ),
            //       ],
            //     ),
            //   ],
            // ),
            ,
            SizedBox(height: 16),
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
