import 'package:business_bosses_v2/bbpro/controllers/order_controller.dart';
import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
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

  // String _formatNumber(int number) {
  //   if (number >= 1000) {
  //     double numberInK = number / 1000;
  //     if (numberInK >= 1000) {
  //       return '${(numberInK / 1000).toStringAsFixed(1)}K';
  //     } else {
  //       return '${numberInK.toStringAsFixed(1)}K';
  //     }
  //   } else {
  //     return number.toString();
  //   }
  // }

  @override
  void initState() {
    super.initState();
  }

  // void _navigateToOrders() {
  //   Bottomnavscreen.of(context)?.onTabTapped(2);
  // }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ShopController>(
      builder: (_) {
        // Still fetching statistics and nothing loaded yet → show a loader
        // rather than a £0 total that looks like real (empty) data.
        if (shopController.loadingData.value &&
            shopController.shopStats == null) {
          return const Padding(
            padding: EdgeInsets.all(30),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

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
                          'Financial Projection',
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
                  defaultVerticalAlignment:
                      TableCellVerticalAlignment.middle,
                  columnWidths: const <int, TableColumnWidth>{
                    0: FlexColumnWidth(),
                    1: FlexColumnWidth(),
                  },
                  border: TableBorder.all(
                    borderRadius: BorderRadius.circular(10.0),
                    color: textColor,
                  ),
                  children: <TableRow>[
                    TableRow(
                      decoration: const BoxDecoration(
                        color: probackgroundColor,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Center(
                            child: Text(
                              textAlign: TextAlign.center,
                              'Leads from\nAll Orders',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
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
