import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/order_model.dart';
import 'package:business_bosses_v2/bbpro/models/product_model.dart';
import 'package:business_bosses_v2/bbpro/models/service_model.dart';
import 'package:business_bosses_v2/bbpro/models/shop_model.dart';
import 'package:business_bosses_v2/bbpro/widgets/orderwidget.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ExpandedOrders extends StatefulWidget {
  final Order order;
  final Shop? shop;

  const ExpandedOrders({
    super.key,
    required this.order,
    this.shop,
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
            shop: widget.shop,
          ),
          const SizedBox(height: 30),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              'Listings',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          ...widget.order.products!.map<Widget>((Product product) {
            return ListTile(
              title: Text(
                product.name,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              leading: _buildProductImage(product),
              subtitle: Text(
                '${widget.shop != null ? widget.shop!.currency : shopController.shop?.currency ?? ''} ${product.price.toString()}',
                style: const TextStyle(
                  fontSize: 13,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
            );
          }).toList(),
          ...widget.order.services!.map<Widget>((Service service) {
            return ListTile(
              title: Text(
                service.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              leading: _buildServiceImage(service),
              subtitle: Text(
                '${widget.shop != null ? widget.shop!.currency : shopController.shop?.currency ?? ''} ${service.price.toString()}',
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
          ...widget.order.customItems!.map<Widget>((dynamic custom) {
            return ListTile(
              title: Text(
                custom['name'],
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                '${widget.shop != null ? widget.shop!.currency : shopController.shop?.currency ?? ''} ${custom['amount'].toString()}',
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
