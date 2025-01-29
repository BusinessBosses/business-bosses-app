import 'package:business_bosses_v2/bbpro/controllers/order_controller.dart';
import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/product_model.dart';
import 'package:business_bosses_v2/bbpro/models/service_model.dart';
import 'package:business_bosses_v2/bbpro/widgets/orderwidget.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpandedOrdersView extends StatefulWidget {
  final String order;

  const ExpandedOrdersView({
    super.key,
    required this.order,
  });

  @override
  State<ExpandedOrdersView> createState() => _ExpandedOrdersViewState();
}

class _ExpandedOrdersViewState extends State<ExpandedOrdersView> {
  final ShopController shopController = Get.find();
  final OrderController orderController = Get.put(OrderController());

  @override
  void initState() {
    super.initState();
    saveOrderDetails();
    orderController.loadOrder(widget.order);
  }

  void saveOrderDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('visited', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        ),
        title: const Text(
          'Order Details',
          style: TextStyle(
            color: proprimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Obx(
        () => orderController.orderLoading.value
            ? const SafetyModel()
            : orderController.orderView == null
                ? const SafetyModel(
                    isLoading: false,
                    title: 'No Order With ID found!',
                  )
                : ListView(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    children: <Widget>[
                      OrderWidget(
                        order: orderController.orderView!,
                        bgcolor:
                            orderController.orderView!.status.backgroundColor,
                        isExpanded: true,
                        shop: orderController.orderView!.shop,
                        myShop: false,
                      ),
                      const SizedBox(height: 30),
                      if (orderController.orderView!.notes != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(
                                'Buyer Note',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(
                                orderController.orderView!.notes!,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                          'Listings',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      ...orderController.orderView!.products!.map<Widget>(
                        (Product product) {
                          return ListTile(
                            title: Text(
                              product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            leading: _buildProductImage(product),
                            subtitle: Text(
                              '${orderController.orderView!.shop.currency} ${product.price.toString()}',
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          );
                        },
                      ).toList(),
                      ...orderController.orderView!.services!.map<Widget>(
                        (Service service) {
                          return ListTile(
                            title: Text(
                              service.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            leading: _buildServiceImage(service),
                            subtitle: Text(
                              '${orderController.orderView!.shop.currency} ${service.price.toString()}',
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          );
                        },
                      ).toList(),
                      ...orderController.orderView!.customItems!.map<Widget>(
                        (dynamic custom) {
                          return ListTile(
                            title: Text(
                              custom['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              '${orderController.orderView!.shop.currency} ${custom['amount'].toString()}',
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          );
                        },
                      ).toList(),
                    ],
                  ),
      ),
    );
  }

  Widget? _buildProductImage(Product product) {
    final List<String>? images = product.images;
    if (images == null || images.isEmpty) {
      return null;
    }

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: NetworkImageWithPlaceHolder(
          imageUrl: images.first,
        ),
      ),
    );
  }

  Widget? _buildServiceImage(Service service) {
    final List<String>? images = service.images;
    if (images == null || images.isEmpty) {
      return null;
    }

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: NetworkImageWithPlaceHolder(
          imageUrl: images.first,
        ),
      ),
    );
  }
}
