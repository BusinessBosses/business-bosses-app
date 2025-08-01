import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class OrderPaymentMethodsWidget extends StatefulWidget {
  final List<dynamic>? paymentMethods;
  const OrderPaymentMethodsWidget({super.key, this.paymentMethods});

  @override
  State<OrderPaymentMethodsWidget> createState() =>
      _OrderPaymentMethodsWidgetState();
}

class _OrderPaymentMethodsWidgetState extends State<OrderPaymentMethodsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              "Seller's Accepted Payment Methods",
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w700, color: textColor),
            ),
            const SizedBox(height: 16.0),
            if (widget.paymentMethods != null)
              ...widget.paymentMethods!
                  .map((dynamic payment) => _buildPaymentMethod(
                        title: payment['paymentMethod'],
                        details: 'Details:   ${payment['details']}',
                      )),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethod({required String title, String? details}) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          if (details != null)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                details,
                style: const TextStyle(fontSize: 13),
              ),
            ),
        ],
      ),
    );
  }
}
