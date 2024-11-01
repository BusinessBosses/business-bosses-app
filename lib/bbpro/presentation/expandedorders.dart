import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/order_model.dart';
import 'package:business_bosses_v2/bbpro/models/product_model.dart';
import 'package:business_bosses_v2/bbpro/widgets/orderwidget.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ExpandedOrders extends StatefulWidget {
  final Order order;

  const ExpandedOrders({
    super.key,
    required this.order,
  });

  @override
  State<ExpandedOrders> createState() => _ExpandedOrdersState();
}

class _ExpandedOrdersState extends State<ExpandedOrders> {
  final ShopController shopController = Get.find();
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
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        children: <Widget>[
          OrderWidget(
            order: widget.order,
            bgcolor: widget.order.status.backgroundColor,
            isExpanded: true,
          ),
          const SizedBox(height: 30),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              'Items',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          ...widget.order.products!.map<Widget>((Product product) {
            return ListTile(
              title: Text(
                product.name ?? 'Unknown Product',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              leading: _buildProductImage(product),
              subtitle: Text(
                '${shopController.shop?.currency ?? ''} ${product.price.toString() ?? '0'}',
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
            );
          }).toList(),
        ],
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
}
