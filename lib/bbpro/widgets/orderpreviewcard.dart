import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class OrderPreviewCard extends StatelessWidget {
  final String title;
  final String size;
  final String color;
  final double price;
  final int deliveryDays;
  final String deliveryLocation;
  final String imageUrl;

  const OrderPreviewCard({
    Key? key,
    required this.title,
    required this.size,
    required this.color,
    required this.price,
    required this.deliveryDays,
    required this.deliveryLocation,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.all(15.0),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const NetworkImageWithPlaceHolder(
            width: 100,
            height: 100,
            fit: BoxFit.cover,
            imageUrl: '',
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('Size: $size'),
                Text('Color: $color'),
                const SizedBox(height: 5.0),
                Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: <Widget>[
                    const Icon(
                      Icons.access_time,
                      size: 12,
                    ),
                    const SizedBox(width: 4.0),
                    Text('$deliveryDays Days Delivery'),
                  ],
                ),
                Row(
                  children: <Widget>[
                    const Icon(
                      Icons.location_on,
                      size: 12,
                    ),
                    const SizedBox(width: 4.0),
                    Text(deliveryLocation),
                  ],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(5)),
              child: const Row(
                children: <Widget>[
                  Text('Edit'),
                  Icon(Icons.edit, size: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
