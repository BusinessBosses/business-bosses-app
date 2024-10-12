import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/presentation/add_client.dart';
import 'package:business_bosses_v2/bbpro/presentation/add_project.dart';
import 'package:business_bosses_v2/bbpro/presentation/add_supplier.dart';
import 'package:business_bosses_v2/bbpro/presentation/bottomnavscreen.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_product.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_service.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_order.dart';
import 'package:business_bosses_v2/bbpro/widgets/gotoshopwidget.dart';
import 'package:business_bosses_v2/bbpro/widgets/infocard.dart';
import 'package:business_bosses_v2/bbpro/widgets/notificationbutton.dart';
import 'package:business_bosses_v2/bbpro/widgets/orderscard.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import '../widgets/salescard.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({
    super.key,
  });

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final List<String> titles = <String>[
    'Clients',
    'Expenses',
    'To-do tasks',
    'Shop Visits'
  ];
  final ShopController shopController = Get.put(ShopController());

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: 500,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: ListView.separated(
                    itemCount: 6,
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        onTap: () {
                          Navigator.pop(context);
                          if (index == 0) {
                            Get.to(() => const CreateProductListing());
                          } else if (index == 1) {
                            Get.to(() => const CreateServiceListing());
                          } else if (index == 2) {
                            Get.to(() => const AddSupplier());
                          } else if (index == 3) {
                            Get.to(() => const CreateOrder());
                          } else if (index == 4) {
                            Get.to(() => const Addclient());
                          } else if (index == 5) {
                            Get.to(() => const Addproject());
                          }
                        },
                        minVerticalPadding: 0,
                        contentPadding: const EdgeInsets.only(left: 10),
                        leading: Icon(
                          Icons.add,
                          size: 22,
                          color: textColor.withOpacity(1),
                        ),
                        title: Text(
                          index == 0
                              ? 'Add Products'
                              : index == 1
                                  ? 'Add Services'
                                  : index == 2
                                      ? 'Add Suppliers'
                                      : index == 3
                                          ? 'Add Orders'
                                          : index == 4
                                              ? 'Add Clients'
                                              : 'Add Projects',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: probackgroundColor,
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            IconButton(
              onPressed: () {
                Get.back();
              },
              icon: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.transparent,
                child: Image.asset(
                  'assets/images/app_logo_2.png',
                  height: 30,
                ),
              ),
            ),
            const Positioned(
              left: -5,
              child: Icon(
                Icons.chevron_left,
                color: primaryColorLT,
                size: 24,
              ),
            ),
          ],
        ),
        title: const Text(
          'Dashboard',
          style: TextStyle(
            color: proprimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const <Widget>[NotificationButton()],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const GotoshopWidget(),
            const OrdersWidget(),
            const SalesWidget(),
            StaggeredGridView.countBuilder(
              physics: const NeverScrollableScrollPhysics(),
              staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
              padding: const EdgeInsets.symmetric(
                horizontal: 15.0,
              ),
              crossAxisCount: 2,
              crossAxisSpacing: 15.0,
              mainAxisSpacing: 15.0,
              // controller: _controller,
              shrinkWrap: true,
              itemCount: 4,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    if (index == 0) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const Bottomnavscreen(initialindex: 3),
                        ),
                      );
                    } else if (index == 1) {
                      // Add navigation for Expenses
                    } else if (index == 2) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const Bottomnavscreen(initialindex: 1),
                        ),
                      );
                    } else if (index == 3) {
                      Get.to(() => const CreateOrder());
                    }
                  },
                  child: InfoCard(
                    cardName: titles[index],
                    value: '\$20k',
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showBottomSheet,
        backgroundColor: proprimaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
