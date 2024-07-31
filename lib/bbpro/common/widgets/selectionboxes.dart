import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class SelectionSection extends StatefulWidget {
  final Function(Map<String, bool>) onSelectionChanged;

  SelectionSection({required this.onSelectionChanged});

  @override
  _SelectionSectionState createState() => _SelectionSectionState();
}

class _SelectionSectionState extends State<SelectionSection> {
  Map<String, bool> selections = {
    'Bank': false,
    'Paypal': false,
    'Wallet': false,
    'Cash': false,
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        child: Column(
          children: [
            ...selections.keys.map((String key) {
              return Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      Checkbox(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        activeColor:
                            proprimaryColor, // Sets the color of the checkbox when checked
                        value: selections[key],
                        onChanged: (bool? value) {
                          setState(() {
                            selections[key] = value!;
                            widget.onSelectionChanged(selections);
                          });
                        },
                      ),
                      Text(key),
                    ],
                  ));
            }).toList(),
          ],
        ),
      ),
    );
  }
}
