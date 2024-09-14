import 'package:flutter/material.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart'; // Importing theme

class SelectionSection extends StatefulWidget {
  final Function(Map<String, bool>) onSelectionChanged;
  final Map<String, bool>? selectedOptions; // Nullable to allow defaults
  final List<String>
      options; // List of options to dynamically create selections

  const SelectionSection({
    super.key,
    required this.onSelectionChanged,
    this.selectedOptions,
    required this.options,
  });

  @override
  _SelectionSectionState createState() => _SelectionSectionState();
}

class _SelectionSectionState extends State<SelectionSection> {
  late Map<String, bool> selections;

  @override
  void initState() {
    super.initState();
    // Initialize selections with passed options or default to all false
    selections = widget.selectedOptions ??
        <String, bool>{for (String option in widget.options) option: false};
  }

  @override
  void didUpdateWidget(covariant SelectionSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update selections if new options are passed
    if (widget.selectedOptions != oldWidget.selectedOptions) {
      setState(() {
        selections = widget.selectedOptions ?? selections;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        child: Column(
          children: <Widget>[
            // Dynamically generate checkboxes for each option
            ...selections.keys.map((String key) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  children: <Widget>[
                    Checkbox(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      activeColor: proprimaryColor,
                      value: selections[key],
                      onChanged: (bool? value) {
                        setState(() {
                          selections[key] = value!;
                          widget.onSelectionChanged(selections);
                        });
                      },
                    ),
                    Text(
                      key,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
