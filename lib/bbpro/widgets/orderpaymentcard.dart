import 'package:flutter/material.dart';

class OrderPaymentMethodsWidget extends StatelessWidget {
  const OrderPaymentMethodsWidget({Key? key}) : super(key: key);

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
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            _buildPaymentMethod(
              title: 'Bank Payment',
              details:
                  '123456789012, ABC Bank, 4567 Market St, Apt 12, San Francisco, CA 94103',
            ),
            const SizedBox(height: 16.0),
            _buildPaymentMethod(
              title: 'Cash',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethod({required String title, String? details}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        if (details != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(details),
          ),
      ],
    );
  }
}
