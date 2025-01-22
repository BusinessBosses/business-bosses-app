import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';

String formatServiceDuration(int? duration) {
  if (duration == null || duration == 2000000) return '';
  if (duration < 60) return '$duration mins @';
  if (duration < 1440) {
    int hours = duration ~/ 60;
    int minutes = duration % 60;
    String formattedDuration = '${hours}hr(s)';
    if (minutes > 0) {
      formattedDuration += ' ${minutes}mins';
    }
    return '$formattedDuration @ ';
  } else {
    int days = duration ~/ 1440;
    int remainingMinutes = duration % 1440;
    int hours = remainingMinutes ~/ 60;
    int minutes = remainingMinutes % 60;
    String formattedDuration = '${days}days';
    if (hours > 0) {
      formattedDuration += ' ${hours}hr(s)';
    }
    if (minutes > 0) {
      formattedDuration += ' ${minutes}mins';
    }
    return '$formattedDuration @ ';
  }
}

class OrderSummaryWidget extends StatefulWidget {
  final int quantity;
  final double price;
  final double discount;
  final double total;
  final String currency;
  final bool? isservice;
  final double? packagesprice;
  final int? serviceDuration;
  final String? timeofservice;
  const OrderSummaryWidget(
      {Key? key,
      required this.quantity,
      required this.price,
      required this.discount,
      required this.total,
      required this.currency,
      this.serviceDuration,
      this.isservice,
      this.packagesprice,
      this.timeofservice})
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
              'Order Summary',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: textColor,
              ),
            ),
            if (widget.serviceDuration != null) const SizedBox(height: 16),
            const SizedBox(height: 16),
            if (widget.serviceDuration != null)
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      if (widget.discount > 0)
                        Row(
                          children: <Widget>[
                            Text(
                              '${formatServiceDuration(widget.serviceDuration)}${widget.currency}${((widget.price * (1 - widget.discount / 100)) * 100).round() / 100}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '${widget.currency}${widget.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        )
                      else
                        Text(
                          '${formatServiceDuration(widget.serviceDuration)}${widget.currency}${widget.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                    ],
                  ),
                  Text(
                    widget.timeofservice ?? '',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
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
                  '${widget.discount.toString()}%',
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
            if (widget.isservice != null) const SizedBox(height: 8),
            if (widget.isservice != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'Additional packages:',
                    style: TextStyle(fontSize: 13),
                  ),
                  Text(
                    '${widget.currency}${widget.packagesprice.toString() ?? 0}',
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
                  '${widget.currency} ${widget.total}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
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
