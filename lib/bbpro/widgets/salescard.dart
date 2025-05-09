import 'package:business_bosses_v2/bbpro/controllers/order_controller.dart';
import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/shop_graph_model.dart';
import 'package:business_bosses_v2/bbpro/presentation/bottom_nav_screen.dart';
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

  String _formatNumber(int number) {
    if (number >= 1000) {
      double numberInK = number / 1000;
      if (numberInK >= 1000) {
        return '${(numberInK / 1000).toStringAsFixed(1)}K';
      } else {
        return '${numberInK.toStringAsFixed(1)}K';
      }
    } else {
      return number.toString();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  void _navigateToOrders() {
    Bottomnavscreen.of(context)?.onTabTapped(2);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ShopController>(
      builder: (_) {
        if (shopController.shopGraph == null) {
          return const Padding(
            padding: EdgeInsets.all(15),
            child: Center(
              child: Text('No Data To Show On Graph!'),
            ),
          );
        }

        return GestureDetector(
          onTap: () {
            _navigateToOrders();
          },
          child: Padding(
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
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            ' - Breakdown',
                            style: TextStyle(
                              fontSize: 15,
                              color: proprimaryColor,
                              fontWeight: FontWeight.w700,
                            ),
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
                                _navigateToOrders();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: prosemibackColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
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
                                                '${shopController.shop!.currency}${_formatNumber(shopController.shopGraph!.totalSales)}',
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
                  const SizedBox(height: 10),
                  if (shopController.shopGraph!.graphData != null &&
                      shopController.shopGraph!.graphData!.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(15),
                      child: Center(
                        child: Text(
                          'No Data To Show',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.only(right: 10),
                      height: 100,
                      width: double.infinity,
                      child: LineChart(
                        LineChartData(
                          minX: 0,
                          maxX: (shopController.shopGraph!.graphData!.length -
                                  1)
                              .toDouble(), // Dynamically set maxX based on data length
                          minY: 0,
                          maxY: shopController.shopGraph!.totalSales
                              .toDouble(), // Dynamically set maxY based on totalSales
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: shopController.shopGraph!.totalSales >
                                        0
                                    ? shopController.shopGraph!.totalSales / 5
                                    : 100,
                                getTitlesWidget:
                                    defaultGetTitle, // Use the default or provide your own function
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles:
                                    shopController.shopGraph!.totalSales > 0,
                                getTitlesWidget:
                                    (double value, TitleMeta meta) {
                                  // Ensure value index is within bounds and map date label to the X-axis
                                  int index = value.toInt();
                                  if (index >= 0 &&
                                      index <
                                          shopController
                                              .shopGraph!.graphData!.length) {
                                    DateTime date = DateTime.parse(
                                        shopController
                                            .shopGraph!.graphData![index].date);
                                    return Text(date.day.toString());
                                  }
                                  return const Text('');
                                },
                              ),
                            ),
                            rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                          ),
                          gridData: FlGridData(show: false),
                          borderData: FlBorderData(show: false),
                          lineBarsData: <LineChartBarData>[
                            LineChartBarData(
                              isStrokeCapRound: true,
                              spots: shopController.shopGraph!.graphData!
                                  .asMap()
                                  .entries
                                  .map((MapEntry<int, GraphDataPoint> entry) =>
                                      FlSpot(entry.key.toDouble(),
                                          entry.value.totalAmount.toDouble()))
                                  .toList(),
                              isCurved: true,
                              color: proprimaryColor,
                              barWidth: 4,
                              belowBarData: BarAreaData(
                                show: true,
                                color: proprimaryColor.withAlpha(100),
                              ),
                              dotData: const FlDotData(show: false),
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
      },
    );
  }
}
