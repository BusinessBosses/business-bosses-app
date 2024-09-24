import 'package:flutter/material.dart';

class AddToOrderWidget extends StatefulWidget {
  const AddToOrderWidget({Key? key}) : super(key: key);

  @override
  State<AddToOrderWidget> createState() => _AddToOrderWidgetState();
}

class _AddToOrderWidgetState extends State<AddToOrderWidget> {
  bool _package1Selected = false;
  bool _package2Selected = true; // Initially selected
  bool _package3Selected = true; // Initially selected

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Add to your Order',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildPackageCheckbox(
              'Package 1',
              _package1Selected,
              (bool? value) => setState(() => _package1Selected = value!),
            ),
            _buildPackageCheckbox(
              'Package 2',
              _package2Selected,
              (bool? value) => setState(() => _package2Selected = value!),
            ),
            _buildPackageCheckbox(
              'Package 3',
              _package3Selected,
              (bool? value) => setState(() => _package3Selected = value!),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPackageCheckbox(
      String title, bool isSelected, ValueChanged<bool?> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            Checkbox(
              value: isSelected,
              onChanged: onChanged,
              activeColor: Colors.blue, // Customize checkbox color
            ),
            Text(title),
          ],
        ),
        const Text('\$10'), // Price
      ],
    );
  }
}
