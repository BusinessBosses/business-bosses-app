import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class InvoiceOptionsWidget extends StatefulWidget {
  final Function(int) onOptionSelected; // Callback function

  const InvoiceOptionsWidget({super.key, required this.onOptionSelected});

  @override
  State<InvoiceOptionsWidget> createState() => _InvoiceOptionsWidgetState();
}

class _InvoiceOptionsWidgetState extends State<InvoiceOptionsWidget> {
  int selectedOption = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text(
              'Do you want to send invoice for this order',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16.0),
            RadioListTile(
              contentPadding: EdgeInsets.zero,
              activeColor: proprimaryColor, // Set selected thumb color
              value: 0,
              groupValue: selectedOption,
              onChanged: (int? value) {
                setState(() {
                  selectedOption = value!;
                  widget.onOptionSelected(selectedOption); // Call callback
                });
              },
              title: const Text('Don\'t send invoice',
                  style: TextStyle(fontSize: 13)),
            ),
            RadioListTile(
              contentPadding: EdgeInsets.zero,
              activeColor: proprimaryColor, // Set selected thumb color
              value: 1,
              groupValue: selectedOption,
              onChanged: (int? value) {
                setState(() {
                  selectedOption = value!;
                  widget.onOptionSelected(selectedOption); // Call callback
                });
              },
              title: const Text(
                'Send invoice with Payment link',
                style: TextStyle(fontSize: 13),
              ),
            ),
            RadioListTile(
              contentPadding: EdgeInsets.zero,
              activeColor: proprimaryColor, // Set selected thumb color
              value: 2,
              groupValue: selectedOption,
              onChanged: (int? value) {
                setState(() {
                  selectedOption = value!;
                  widget.onOptionSelected(selectedOption); // Call callback
                });
              },
              title: const Text('Send invoice without Payment link',
                  style: TextStyle(fontSize: 13)),
            ),
          ],
        ),
      ),
    );
  }
}
