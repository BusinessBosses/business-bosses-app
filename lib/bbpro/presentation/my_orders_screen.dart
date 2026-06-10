import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/order_model.dart';
import 'package:business_bosses_v2/bbpro/models/product_model.dart';
import 'package:business_bosses_v2/bbpro/models/service_model.dart';
import 'package:business_bosses_v2/bbpro/widgets/myorderwidget.dart';
import 'package:business_bosses_v2/bbpro/widgets/proseardwidget.dart';
import 'package:business_bosses_v2/bbpro/widgets/proshopdeals.dart';
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/home/marketplace_screen.dart';
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

  String searchQuery = '';
  List<Order> filteredOrders = <Order>[];
  bool loadingData = true;
  final MarketController _marketController = Get.find();

  @override
  void initState() {
    super.initState();
    _marketController
        .initOrder()
        .then((void value) => setState((() => loadingData = false)));
    filteredOrders = _marketController.orders;
  }

  Future<void> _loadMoreOrders() async {
    if (_marketController.loadingMoreOrders.value ||
        !_marketController.hasMoreOrders) {
      return;
    }
    await _marketController.loadMoreMyOrders();
    if (!mounted) return;
    setState(() {
      // Re-sync the displayed list with the controller's now-longer list.
      // (While searching, filteredOrders holds a filtered snapshot, so it's
      // only re-pointed at the live list when no search is active.)
      if (searchQuery.isEmpty) {
        filteredOrders = _marketController.orders;
      }
    });
  }

  // void _showFilterMenu(BuildContext context, Offset position) {
  //   showMenu(
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //     context: context,
  //     shadowColor: Colors.black,
  //     position: RelativeRect.fromLTRB(position.dx, position.dy,
  //         MediaQuery.of(context).size.width - position.dx, 0),
  //     items: <String>[
  //       'All Products',
  //       'Low Stock',
  //       'Out of Stock',
  //       'Most Popular',
  //       'Newest First',
  //     ].map((String option) {
  //       return PopupMenuItem<String>(
  //         value: option,
  //         child: Text(option),
  //       );
  //     }).toList(),
  //   ).then((String? selected) {
  //     if (selected != null) {
  //       // Implement filter logic here
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: probackgroundColor,
      appBar: AppBar(
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              onTap: () {
                Get.to(() => const MarketplaceScreen());
              },
              child: CircleAvatar(
                backgroundColor: backgroundColor,
                child: SvgPicture.asset(
                  'assets/svgs/cartu.svg',
                  height: 20,
                  colorFilter:
                      const ColorFilter.mode(textColor, BlendMode.srcIn),
                ),
              ),
            ),
          ),
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        ),
        title: Text(
          // When not searching, show the server-reported total so the count is
          // correct before pagination loads every page. While searching, show
          // the number of matches in what's currently loaded.
          'My Orders (${searchQuery.isEmpty ? _marketController.totalOrderCount.value : filteredOrders.length})',
          style: const TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: loadingData
          ? const SafetyModel()
          : Column(
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    children: <Widget>[
                                      SvgPicture.asset(
                                        'assets/svgs/search.svg',
                                        height: 20,
                                        colorFilter: const ColorFilter.mode(
                                            hintColor, BlendMode.srcIn),
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
                        ],
                      ),
                    ),
                  ],
                ),

                // Product List
                Expanded(
                  child: filteredOrders.isNotEmpty
                      ? NotificationListener<ScrollNotification>(
                          onNotification: (ScrollNotification scrollInfo) {
                            // Only auto-paginate the full list (search filters
                            // the already-loaded orders, so it manages its own
                            // result set).
                            if (searchQuery.isEmpty &&
                                scrollInfo.metrics.pixels >=
                                    scrollInfo.metrics.maxScrollExtent - 200) {
                              _loadMoreOrders();
                            }
                            return false;
                          },
                          child: ListView.builder(
                            padding: const EdgeInsets.only(bottom: 100.0),
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: filteredOrders.length + 1,
                            itemBuilder: (BuildContext context, int index) {
                              if (index == filteredOrders.length) {
                                // Footer: show a spinner while the next page
                                // loads, otherwise nothing.
                                return Obx(
                                  () => _marketController
                                          .loadingMoreOrders.value
                                      ? const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 16.0),
                                          child: Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                );
                              }
                              final Order order = filteredOrders[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: MyOrderWidget(
                                  quantity: order.quantity,
                                  order: order,
                                  bgcolor: order.status.backgroundColor,
                                  shop: order.shop,
                                  showChange: false,
                                  myShop: false,
                                ),
                              );
                            },
                          ),
                        )
                      : Center(
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SvgPicture.asset(
                              'assets/svgs/ordersinvoices.svg',
                              height: 50,
                              colorFilter: const ColorFilter.mode(
                                  Colors.black12, BlendMode.srcIn),
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
                                  combinedList: _marketController.proItems
                                    ..where((Object item) {
                                      if (item is Product) {
                                        return item.images != null &&
                                            item.images!.isNotEmpty &&
                                            item.images!.first.isNotEmpty &&
                                            (item).user!.isSubscribed;
                                      } else {
                                        return (item as Service).images !=
                                                null &&
                                            (item).images!.isNotEmpty &&
                                            (item).images![0].isNotEmpty &&
                                            (item).user!.isSubscribed;
                                      }
                                    }).take(10).toList(),
                                ),
                              ],
                            )
                          ],
                        )),
                ),
              ],
            ),
    );
  }
}
