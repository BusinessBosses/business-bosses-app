import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/order_model.dart';
import 'package:business_bosses_v2/bbpro/models/product_model.dart';
import 'package:business_bosses_v2/bbpro/models/service_model.dart';
import 'package:business_bosses_v2/bbpro/models/shop_model.dart';
import 'package:business_bosses_v2/bbpro/presentation/book_service.dart';
import 'package:business_bosses_v2/bbpro/presentation/order_product.dart';
import 'package:business_bosses_v2/bbpro/widgets/myorderwidget.dart';
import 'package:business_bosses_v2/bbpro/widgets/orderwidget.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ExpandedOrders extends StatefulWidget {
  final bool? ismyorder;
  final Order order;
  final Shop? shop;

  const ExpandedOrders({
    super.key,
    required this.order,
    this.shop,
    this.ismyorder,
  });

  @override
  State<ExpandedOrders> createState() => _ExpandedOrdersState();
}

class _ExpandedOrdersState extends State<ExpandedOrders> {
  final ShopController shopController = Get.find();
  @override
  Widget build(BuildContext context) {
    String? productNotes = widget.order.products!
        .map((Product product) =>
            product.notes) // Assuming `notes` is a field in `Product`
        .where((String? note) => note != null && note.isNotEmpty)
        .join(', '); // Combine notes into a single string

    String? serviceNotes = widget.order.services!
        .map((Service service) =>
            service.notes) // Assuming `notes` is a field in `Service`
        .where((String? note) => note != null && note.isNotEmpty)
        .join(', '); // Combine notes into a single string

    // Combine product and service notes
    String? sellernotes;
    if (productNotes.isNotEmpty) {
      sellernotes = productNotes;
    }
    if (serviceNotes.isNotEmpty) {
      sellernotes =
          sellernotes != null ? '$sellernotes, $serviceNotes' : serviceNotes;
    }
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
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        children: <Widget>[
          if (widget.ismyorder != null)
            MyOrderWidget(
              order: widget.order,
              bgcolor: widget.order.status.backgroundColor,
              isExpanded: true,
              shop: widget.shop,
              ismyorderspage: true,
              sellernotes: sellernotes,
            ),
          if (widget.ismyorder == null)
            OrderWidget(
              order: widget.order,
              bgcolor: widget.order.status.backgroundColor,
              isExpanded: true,
              shop: widget.shop,
            ),
          const SizedBox(height: 30),
          if (widget.order.notes != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    'My note to Seller',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    widget.order.notes!.isNotEmpty
                        ? widget.order.notes!
                        : 'N/A',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 30),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Listings',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                // Text(
                //   'Quantity: ${widget.order.}',
                //   style: const TextStyle(fontSize: 16),
                // )
              ],
            ),
          ),
          ...widget.order.products!.map<Widget>((Product product) {
            return GestureDetector(
              onTap: () {
                print(product.notes);
                // Get.to(
                //     OrderProductScreen(product: product, shop: product.shop!));
              },
              child: ListTile(
                title: Text(
                  product.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 14),
                ),
                leading: _buildProductImage(product),
                subtitle: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${widget.shop != null ? widget.shop!.currency : widget.order.shop.currency} ${product.price.toString()}',
                      style: const TextStyle(
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      widget.order.orderDetails != null
                          ? widget.order.orderDetails!
                          : '',
                      style: const TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
            );
          }).toList(),
          ...widget.order.services!.map<Widget>((Service service) {
            return GestureDetector(
              onTap: () {
                // Get.to(
                //     BookServiceScreen(service: service, shop: service.shop!));
              },
              child: ListTile(
                title: Text(
                  service.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                leading: _buildServiceImage(service),
                subtitle: Text(
                  '${widget.shop != null ? widget.shop!.currency : widget.order.shop.currency} ${service.price.toString()}',
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
            );
          }).toList(),
          ...widget.order.customItems!.map<Widget>((dynamic custom) {
            return GestureDetector(
              child: ListTile(
                title: Text(
                  custom['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  '${widget.shop != null ? widget.shop!.currency : widget.order.shop.currency} ${custom['amount'].toString()}',
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
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
      return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[200],
        ),
        child: Icon(
          Icons.image,
          color: Colors.grey[400],
        ),
      );
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
          placeHolder: Icons.image,
        ),
      ),
    );
  }

  Widget? _buildServiceImage(Service service) {
    final List<String>? images = service.images;
    if (images == null || images.isEmpty) {
      return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[200],
        ),
        child: Icon(
          Icons.image,
          color: Colors.grey[400],
        ),
      );
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
          placeHolder: Icons.image,
        ),
      ),
    );
  }
}
