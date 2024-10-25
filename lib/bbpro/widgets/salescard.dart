import 'package:business_bosses_v2/bbpro/controllers/order_controller.dart';
import 'package:business_bosses_v2/bbpro/presentation/bottomnavscreen.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SalesWidget extends StatefulWidget {
  const SalesWidget({super.key});

  @override
  State<SalesWidget> createState() => _SalesWidgetState();
}

class _SalesWidgetState extends State<SalesWidget> {
  bool isHidden = false;
  final OrderController orderController = Get.put(OrderController());
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 15),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Wrap(
                  children: <Widget>[
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
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const Bottomnavscreen(initialindex: 2),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          decoration: BoxDecoration(
                              color: prosemibackColor,
                              borderRadius: BorderRadius.circular(8)),
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: <Widget>[
                              RichText(
                                text: TextSpan(
                                  text: 'View All Sales ',
                                  style: const TextStyle(
                                    color: proprimaryColor,
                                    fontSize: 12,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text:
                                          '(${orderController.orders.length})',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 5),
                              SvgPicture.asset(
                                'assets/svgs/nexticon.svg',
                                color: proprimaryColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            // const Row(
            //   children: <Widget>[
            //     Text(
            //       '128,7K',
            //       style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            //     ),
            //   ],
            // ),
            Container(
              padding: const EdgeInsets.only(right: 10),
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
                        getTitles: (double value) {
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
                  lineBarsData: <LineChartBarData>[
                    LineChartBarData(
                      isStrokeCapRound: true,
                      spots: <FlSpot>[
                        FlSpot(0, 150),
                        FlSpot(1, 250),
                        FlSpot(2, 100),
                        FlSpot(3, 300),
                        FlSpot(4, 500),
                        FlSpot(5, 400),
                        FlSpot(6, 700),
                      ],
                      isCurved: true,
                      colors: <Color>[proprimaryColor],
                      barWidth: 4,
                      belowBarData: BarAreaData(
                        show: true,
                        colors: <Color>[prosemibackColor.withAlpha(150)],
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
