import 'package:flutter/material.dart';

class AddToOrderWidget extends StatefulWidget {
  final List<dynamic> packages;

  const AddToOrderWidget({Key? key, required this.packages}) : super(key: key);

  @override
  State<AddToOrderWidget> createState() => _AddToOrderWidgetState();
}

class _AddToOrderWidgetState extends State<AddToOrderWidget> {
  bool _packageSelected = false;

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
            ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                final dynamic package = widget.packages[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildPackageCheckbox(
                    package,
                    _packageSelected,
                    (bool? value) => setState(() => _packageSelected = value!),
                  ),
                );
              },
              itemCount: widget.packages.length,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPackageCheckbox(
      dynamic package, bool isSelected, ValueChanged<bool?> onChanged) {
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
            Text(package['name']),
          ],
        ),
        Text(package['price']), // Price
      ],
    );
  }
}
