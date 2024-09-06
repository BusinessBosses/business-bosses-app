import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomDropdownWidget extends StatefulWidget {
  final String caption;
  final String iconName;
  final List<String> items;

  const CustomDropdownWidget({super.key, required this.caption, required this.items, required this.iconName});

  @override
  _CustomDropdownWidgetState createState() => _CustomDropdownWidgetState();
}

class _CustomDropdownWidgetState extends State<CustomDropdownWidget> {
  String? _selectedItem;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.items.isNotEmpty ? widget.items[0] : null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.only(left: 15.0, right: 15, top: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.caption,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedItem,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedItem = newValue;
                  });
                },
                items:
                    widget.items.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(fontSize: 13)),
                  );
                }).toList(),
                isExpanded: true,
                icon: SvgPicture.asset(widget.iconName, color: proprimaryColor,),
                
              ),
            )
          ],
        ),
      ),
    );
  }
}
