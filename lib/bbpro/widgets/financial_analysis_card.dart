import 'package:business_bosses_v2/bbpro/controllers/order_controller.dart';
import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/presentation/bottom_nav_screen.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FinancialanalysisWidget extends StatefulWidget {
  const FinancialanalysisWidget({super.key});

  @override
  State<FinancialanalysisWidget> createState() =>
      _FinancialanalysisWidgetState();
}

class _FinancialanalysisWidgetState extends State<FinancialanalysisWidget> {
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

        return Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 15),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Wrap(
                      children: <Widget>[
                        Text(
                          'Financial Analysis',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Table(
                  border: TableBorder.all(
                    borderRadius: BorderRadius.circular(10.0),
                    color: textColor,
                  ),
                  children: <TableRow>[
                    const TableRow(
                      decoration: BoxDecoration(
                        color: probackgroundColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                      ),
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              'Sales fromAll Orders',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              'Expenses from Tasks',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              shopController.shopStats != null
                                  ? shopController.shop!.currency +
                                      (shopController.shopStats!.totalAmount >=
                                              1000000
                                          ? '${(shopController.shopStats!.totalAmount / 1000000).toStringAsFixed(1)}M'
                                          : shopController
                                                      .shopStats!.totalAmount >=
                                                  1000
                                              ? '${(shopController.shopStats!.totalAmount / 1000).toStringAsFixed(1)}K'
                                              : shopController
                                                  .shopStats!.totalAmount
                                                  .toStringAsFixed(1))
                                  : '0',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: textColor,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              shopController.shopStats != null
                                  ? shopController.shop!.currency +
                                      (shopController
                                                  .shopStats!.totalExpenses >=
                                              1000000
                                          ? '${(shopController.shopStats!.totalExpenses / 1000000).toStringAsFixed(1)}M'
                                          : shopController.shopStats!
                                                      .totalExpenses >=
                                                  1000
                                              ? '${(shopController.shopStats!.totalExpenses / 1000).toStringAsFixed(1)}K'
                                              : shopController
                                                  .shopStats!.totalExpenses
                                                  .toStringAsFixed(1))
                                  : '0',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: textColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
