import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class OrderSummaryWidget extends StatefulWidget {
  final int quantity;
  final double price;
  final double discount;
  final double total;
  final String currency;
  const OrderSummaryWidget(
      {Key? key,
      required this.quantity,
      required this.price,
      required this.discount,
      required this.total,
      required this.currency})
      : super(key: key);

  @override
  State<OrderSummaryWidget> createState() => _OrderSummaryWidgetState();
}

class _OrderSummaryWidgetState extends State<OrderSummaryWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Order Total',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: proprimaryColor),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  'Quantity:',
                  style: TextStyle(fontSize: 13),
                ),
                Text(
                  widget.quantity.toString(),
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  'Unit Price:',
                  style: TextStyle(fontSize: 13),
                ),
                Text(
                  widget.currency + widget.price.toString(),
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  'Discount:',
                  style: TextStyle(fontSize: 13),
                ),
                Text(
                  widget.discount.toString(),
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  'Total:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.currency + widget.total.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: proprimaryColor,
                      fontSize: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
