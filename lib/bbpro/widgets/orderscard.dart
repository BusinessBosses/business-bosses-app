import 'package:business_bosses_v2/bbpro/controllers/order_controller.dart';
import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/presentation/bottom_nav_screen.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class OrdersWidget extends StatefulWidget {
  const OrdersWidget({super.key});

  @override
  State<OrdersWidget> createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends State<OrdersWidget> {
  bool isHidden = false;
  final ShopController shopController = Get.find();
  final OrderController orderController = Get.put(OrderController());

  @override
  void initState() {
    super.initState();
  }

  void _navigateToOrders() {
    Bottomnavscreen.of(context)?.onTabTapped(2);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _navigateToOrders();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
        child: Container(
          padding: const EdgeInsets.all(15.0),
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
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: <Widget>[
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
                                horizontal: 8, vertical: 8),
                            decoration: BoxDecoration(
                                color: probackgroundColor,
                                borderRadius: BorderRadius.circular(8)),
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: <Widget>[
                                RichText(
                                  text: TextSpan(
                                    text: 'View All Orders ',
                                    style: const TextStyle(
                                        color: proprimaryColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                            '${shopController.orderStats!.totalOrders}',
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
              // orderController.orders.isEmpty
              //     ? const Padding(
              //         padding: EdgeInsets.all(15),
              //         child: Center(
              //           child: Text(
              //             'No Data To Show',
              //             style: TextStyle(
              //               fontSize: 14,
              //               fontWeight: FontWeight.w700,
              //               color: Colors.grey,
              //             ),
              //           ),
              //         ),
              //       )
              //     :
              shopController.orderStats != null &&
                      shopController.orderStats!.totalOrders == 0
                  ? const Padding(
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
                  : Row(
                      children: <Widget>[
                        SizedBox(
                          width: 165,
                          height: 165,
                          child: PieChart(
                            PieChartData(
                              sections: <PieChartSectionData>[
                                // PieChartSectionData(
                                //   color: Colors.lightGreenAccent,
                                //   value: double.parse(
                                //       shopController.orderStats?.online != null
                                //           ? shopController.orderStats!.online
                                //               .toString()
                                //           : '0'),
                                //   title: '',
                                //   radius: 40, // Reduced radius
                                // ),
                                // PieChartSectionData(
                                //   color: Colors.purple,
                                //   value: double.parse(
                                //       shopController.orderStats?.inPerson !=
                                //               null
                                //           ? shopController.orderStats!.inPerson
                                //               .toString()
                                //           : '0'),
                                //   title: '',
                                //   radius: 40, // Reduced radius
                                // ),
                                PieChartSectionData(
                                  color: Colors.yellow,
                                  value: double.parse(
                                      shopController.orderStats?.pending != null
                                          ? shopController.orderStats!.pending
                                              .toString()
                                          : '0'),
                                  title: '',
                                  radius: 40, // Reduced radius
                                ),
                                PieChartSectionData(
                                  color: Colors.blue,
                                  value: double.parse(
                                      shopController.orderStats?.paid != null
                                          ? shopController.orderStats!.paid
                                              .toString()
                                          : '0'),
                                  title: '',
                                  radius: 40, // Reduced radius
                                ),
                                PieChartSectionData(
                                  color: Colors.green,
                                  value: double.parse(
                                      shopController.orderStats?.cancelled !=
                                              null
                                          ? shopController.orderStats!.cancelled
                                              .toString()
                                          : '0'),
                                  title: '',
                                  radius: 40, // Reduced radius
                                ),
                              ],
                              sectionsSpace: 0,
                              centerSpaceRadius:
                                  35, // Reduced center space radius
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // Indicator(
                            //   color: Colors.lightGreenAccent,
                            //   text: 'Online',
                            //   value: int.parse(
                            //       shopController.orderStats?.online != null
                            //           ? shopController.orderStats!.online
                            //               .toString()
                            //           : '0'),
                            // ),
                            // const SizedBox(
                            //   height: 3,
                            // ),
                            // Indicator(
                            //   color: Colors.purple,
                            //   text: 'In Person',
                            //   value: int.parse(
                            //       shopController.orderStats?.online != null
                            //           ? shopController.orderStats!.inPerson
                            //               .toString()
                            //           : '0'),
                            // ),
                            // const SizedBox(
                            //   height: 3,
                            // ),
                            Indicator(
                              color: Colors.yellow,
                              text: 'Pending',
                              value: int.parse(
                                  shopController.orderStats?.online != null
                                      ? shopController.orderStats!.pending
                                          .toString()
                                      : '0'),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Indicator(
                              color: Colors.blue,
                              text: 'Paid',
                              value: int.parse(
                                  shopController.orderStats?.online != null
                                      ? shopController.orderStats!.paid
                                          .toString()
                                      : '0'),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Indicator(
                              color: Colors.green,
                              text: 'Completed',
                              value: int.parse(
                                  shopController.orderStats?.online != null
                                      ? shopController.orderStats!.cancelled
                                          .toString()
                                      : '0'),
                            ),
                          ],
                        ),
                      ],
                    ),
            ],
          ),
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
    super.key,
    required this.color,
    required this.text,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(5),
            color: color,
          ),
        ),
        const SizedBox(width: 8),
        Text('$text  $value'),
      ],
    );
  }
}
