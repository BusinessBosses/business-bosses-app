import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class SelectionSection extends StatefulWidget {
  final Function(Map<String, bool>) onSelectionChanged;

  const SelectionSection({super.key, required this.onSelectionChanged});

  @override
  // ignore: library_private_types_in_public_api
  _SelectionSectionState createState() => _SelectionSectionState();
}

class _SelectionSectionState extends State<SelectionSection> {
  Map<String, bool> selections = <String, bool>{
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
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        child: Column(
          children: <Widget>[
            ...selections.keys.map((String key) {
              return Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: <Widget>[
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
