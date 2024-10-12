import 'package:business_bosses_v2/bbpro/controllers/order_controller.dart';
import 'package:business_bosses_v2/bbpro/presentation/bottomnavscreen.dart';
import 'package:business_bosses_v2/bbpro/presentation/ordersandinvoices.dart';
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
  final OrderController orderController = Get.put(OrderController());
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) =>
                const Bottomnavscreen(initialindex: 2),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
        child: Container(
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
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isHidden = !isHidden;
                      });
                    },
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: prosemibackColor,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Icon(
                            isHidden ? Icons.visibility_off : Icons.visibility,
                            color: proprimaryColor,
                            size: 15,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          isHidden
                              ? '***'
                              : orderController.orders.length.toString(),
                          style: const TextStyle(
                            color: proprimaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 165,
                    height: 165,
                    child: PieChart(
                      PieChartData(
                        sections: <PieChartSectionData>[
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
                  const SizedBox(
                    width: 10,
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                        color: prosemibackColor,
                        borderRadius: BorderRadius.circular(8)),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        const Text('View All Orders'),
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
