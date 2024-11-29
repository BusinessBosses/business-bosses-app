import 'package:business_bosses_v2/bbpro/models/product_model.dart';
import 'package:business_bosses_v2/bbpro/models/service_model.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:flutter/material.dart';

class ProshopdealsWidget extends StatefulWidget {
  final String? title;
  final List<Service>? services;
  final List<Product>? products;

  const ProshopdealsWidget({
    Key? key,
    this.title,
    this.services,
    this.products,
  }) : super(key: key);

  @override
  State<ProshopdealsWidget> createState() => _ProshopdealsWidgetState();
}

class _ProshopdealsWidgetState extends State<ProshopdealsWidget> {
  @override
  Widget build(BuildContext context) {
    // Determine which data to use and limit to the first 4 items
    final List<Object>? items =
        widget.products?.take(4).toList() ?? widget.services?.take(4).toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(13.0),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  const Text(
                    'Pro users deals',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Text(
                      widget.title ?? '',
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
          const SizedBox(height: 16.0),
          SizedBox(
            height: 150, // Adjust height as needed for proper display
            child: items != null && items.isNotEmpty
                ? ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: items.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Object item = items[index];
                      if (item is Product) {
                        return _buildDealItem(
                          item.images!.isNotEmpty
                              ? item.images![0]
                              : 'assets/placeholder.png',
                          item.name ?? 'Unknown Product',
                          '-${item.discount ?? '0%'}',
                          '${item.price ?? '£0.00'}',
                        );
                      } else if (item is Service) {
                        return _buildDealItem(
                          item.images!.isNotEmpty
                              ? item.images![0]
                              : 'assets/placeholder.png',
                          item.name ?? 'Unknown Service',
                          '-${item.discount ?? '0%'}',
                          '${item.price ?? '£0.00'}',
                        );
                      }
                      return const SizedBox();
                    },
                  )
                : const Center(child: Text('No deals available')),
          ),
        ],
      ),
    );
  }

  Widget _buildDealItem(
      String imagePath, String title, String discount, String price) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 16.0),
      child: Column(
        children: <Widget>[
          NetworkImageWithPlaceHolder(imageUrl: imagePath),
          const SizedBox(height: 8.0),
          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4.0),
          Text(
            discount,
            style: const TextStyle(fontSize: 12, color: Colors.red),
          ),
          const SizedBox(height: 4.0),
          Text(
            price,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
