import 'package:business_bosses_v2/bbpro/controllers/order_controller.dart';
import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/shop_graph_model.dart';
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
  final ShopController shopController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => shopController.shopGraph == null
          ? const Padding(
              padding: EdgeInsets.all(15),
              child: Center(
                child: Text('No Data To Show On Graph!'),
              ),
            )
          : Padding(
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
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
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
                                          const Bottomnavscreen(
                                              initialindex: 2),
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
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
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
                                        colorFilter: const ColorFilter.mode(
                                          proprimaryColor,
                                          BlendMode.srcIn,
                                        ),
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
                    shopController.shopGraph!.graphData == null
                        ? const Padding(
                            padding: EdgeInsets.all(15),
                            child: Center(
                              child: Text('No Data To Show On Graph!'),
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.only(right: 10),
                            height: 100,
                            width: double.infinity,
                            child: LineChart(
                              LineChartData(
                                minX: 0,
                                maxX: (shopController
                                            .shopGraph!.graphData!.length -
                                        1)
                                    .toDouble(), // Dynamically set maxX based on data length
                                minY: 0,
                                maxY: shopController.shopGraph!.totalSales
                                    .toDouble(), // Dynamically set maxY based on totalSales
                                titlesData: FlTitlesData(
                                  leftTitles: SideTitles(
                                    showTitles: true,
                                    interval:
                                        shopController.shopGraph!.totalSales > 0
                                            ? shopController
                                                    .shopGraph!.totalSales /
                                                5
                                            : 100,
                                  ),
                                  bottomTitles: SideTitles(
                                    showTitles:
                                        shopController.shopGraph!.totalSales >
                                            0, // Only show if totalSales > 0
                                    getTitles: (double value) {
                                      // Ensure value index is within bounds and map date label to the X-axis
                                      int index = value.toInt();
                                      if (index >= 0 &&
                                          index <
                                              shopController.shopGraph!
                                                  .graphData!.length) {
                                        return shopController
                                            .shopGraph!.graphData![index].date
                                            .substring(
                                                5); // Display date part "MM-DD"
                                      }
                                      return '';
                                    },
                                  ),
                                ),
                                gridData: FlGridData(show: false),
                                borderData: FlBorderData(show: false),
                                lineBarsData: <LineChartBarData>[
                                  LineChartBarData(
                                    isStrokeCapRound: true,
                                    spots: shopController.shopGraph!.graphData!
                                        .asMap()
                                        .entries
                                        .map((MapEntry<int, GraphDataPoint>
                                                entry) =>
                                            FlSpot(
                                                entry.key.toDouble(),
                                                entry.value.totalAmount
                                                    .toDouble()))
                                        .toList(),
                                    isCurved: true,
                                    colors: <Color>[
                                      Colors.blue
                                    ], // Use your custom colors
                                    barWidth: 4,
                                    belowBarData: BarAreaData(
                                      show: true,
                                      colors: <Color>[
                                        Colors.blue.withAlpha(100)
                                      ], // Use your custom colors
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
            ),
    );
  }
}
