import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/order_model.dart';
import 'package:business_bosses_v2/bbpro/widgets/order_payment_status.dart';
import 'package:business_bosses_v2/bbpro/models/product_model.dart';
import 'package:business_bosses_v2/bbpro/models/service_model.dart';
import 'package:business_bosses_v2/bbpro/models/shop_model.dart';
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
    List<String> parseOrderDetails(String orderDetails) {
      // Remove the square brackets and split the string by commas
      final String cleanedString =
          orderDetails.replaceAll('[', '').replaceAll(']', '');
      final List<String> details = cleanedString.split('},');

      // Add the missing closing brace for each item except the last one, then remove { and }
      return details.map((String detail) {
        if (!detail.endsWith('}')) {
          detail = '$detail}';
        }
        return detail.replaceAll('{', '').replaceAll('}', '');
      }).toList();
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
              quantity: widget.order.quantity ?? 1,
            ),
          if (widget.ismyorder == null)
            OrderWidget(
              quantity: widget.order.quantity ?? 1,
              order: widget.order,
              bgcolor: widget.order.status.backgroundColor,
              isExpanded: true,
              shop: widget.shop,
              buyernotes: widget.order.notes,
            ),
          const SizedBox(height: 16),
          OrderPaymentStatus(order: widget.order),
          const SizedBox(height: 14),
          if (widget.ismyorder == null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    'My note to Buyer',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    sellernotes ?? 'N/A',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          if (widget.ismyorder != null)
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
                    widget.order.notes ?? 'N/A',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  'Listings',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                if (widget.order.products!.isNotEmpty)
                  Text(
                    'Quantity: ${widget.order.quantity}',
                    style: const TextStyle(fontSize: 16),
                  )
              ],
            ),
          ),
          ...widget.order.products!.expand<Widget>((Product product) {
            // Parse the orderDetails string into a list of strings
            final List<String> orderDetailsList =
                widget.order.orderDetails != null
                    ? parseOrderDetails(widget.order.orderDetails!)
                    : <String>[];

            // Generate a list of ListTiles based on the ORDER quantity
            return List<Widget>.generate(widget.order.quantity!, (int index) {
              // Get the order detail for the current index
              final String orderDetail = orderDetailsList.length > index
                  ? orderDetailsList[index]
                  : '';

              return GestureDetector(
                onTap: () {
                  // Handle product tap
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
                        orderDetail,
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
            });
          }),
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
                    fontWeight: FontWeight.w600,
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
          }),
          ...widget.order.customItems!.map<Widget>((dynamic custom) {
            return GestureDetector(
              child: ListTile(
                title: Text(
                  custom['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
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
          }),
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
          color: Color(0xFF757575),
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
          color: Color(0xFF757575),
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
