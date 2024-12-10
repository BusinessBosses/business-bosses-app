import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/order_model.dart';
import 'package:business_bosses_v2/bbpro/models/product_model.dart';
import 'package:business_bosses_v2/bbpro/models/service_model.dart';
import 'package:business_bosses_v2/bbpro/widgets/orderwidget.dart';
import 'package:business_bosses_v2/bbpro/widgets/proseardwidget.dart';
import 'package:business_bosses_v2/bbpro/widgets/proshopdeals.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/market_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  final ShopController shopController = Get.find();
  String? _selectedItem;
  String searchQuery = '';
  List<Order> filteredOrders = <Order>[];
  final MarketController _marketController = Get.find();

  @override
  void initState() {
    super.initState();
    filteredOrders = _marketController.orders;
  }

  void _showFilterMenu(BuildContext context, Offset position) {
    showMenu(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      context: context,
      shadowColor: Colors.black,
      position: RelativeRect.fromLTRB(position.dx, position.dy,
          MediaQuery.of(context).size.width - position.dx, 0),
      items: <String>[
        'All Products',
        'Low Stock',
        'Out of Stock',
        'Most Popular',
        'Newest First',
      ].map((String option) {
        return PopupMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
    ).then((String? selected) {
      if (selected != null) {
        setState(() {
          _selectedItem = selected;
        });
        // Implement filter logic here
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: probackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        ),
        title: Text(
          'My Orders (${filteredOrders.length})',
          style: const TextStyle(
            color: proprimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
                // Search Bar
                SizedBox(
                  height: 55,
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, right: 10, bottom: 10),
                        child: SizedBox(
                          width: double.infinity,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: <Widget>[
                                  SvgPicture.asset(
                                    'assets/svgs/search.svg',
                                    height: 20,
                                    color: hintColor,
                                  ),
                                  Expanded(
                                    child: ProSearchbar(
                                      contentPadding: 10,
                                      hasSearchIcon: false,
                                      hintText: 'Search Orders',
                                      autofocus: false,
                                      onChange: (String query) {
                                        setState(() {
                                          searchQuery = query;
                                          filteredOrders = _marketController
                                              .orders
                                              .where((Order order) => order
                                                  .user!.username
                                                  .toLowerCase()
                                                  .contains(searchQuery
                                                      .toLowerCase()))
                                              .toList();
                                        });
                                      },
                                      onSubmit: (String query) {},
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 10,
                        top: 0,
                        bottom: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: GestureDetector(
                            onTap: () {
                              _showFilterMenu(
                                context,
                                Offset(
                                  MediaQuery.of(context).size.width,
                                  120,
                                ),
                              );
                            },
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: backgroundColor,
                                borderRadius: BorderRadius.circular(7),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: backgroundColor.withOpacity(0.6),
                                    offset: const Offset(-5, 0),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: SvgPicture.asset(
                                    'assets/svgs/filterprosections.svg'),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Product List
            Expanded(
              child: filteredOrders.isNotEmpty
                  ? ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: filteredOrders.length,
                      itemBuilder: (BuildContext context, int index) {
                        final Order order = filteredOrders[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: OrderWidget(
                            order: order,
                            bgcolor: order.status.backgroundColor,
                            shop: order.shop,
                            showChange: false,
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SvgPicture.asset(
                          'assets/svgs/ordersinvoices.svg',
                          height: 50,
                          color: Colors.black12,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                            'Looks like you haven\'t placed an order yet'),
                        const SizedBox(
                          height: 50,
                        ),
                        Column(
                          children: <Widget>[
                            ProshopdealsWidget(
                              caption: 'Recommended',
                              combinedList:
                                  _marketController.proItems.take(10).toList(),
                            ),
                          ],
                        )
                      ],
                    )),
            ),
          ],
        ),
      ),
    );
  }
}
