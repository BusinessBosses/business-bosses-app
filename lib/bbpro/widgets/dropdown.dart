// import 'package:business_bosses_v2/utils/theme/theme.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// class CustomDropdownWidget extends StatefulWidget {
//   final String caption;
//   final String iconName;
//   final List<String> items;
//   final String? initialValue;
//   final ValueChanged<String?>? onChanged;
//   final String? hintText; // Changed: hintText is now optional

//   const CustomDropdownWidget({
//     super.key,
//     required this.caption,
//     required this.items,
//     required this.iconName,
//     this.initialValue,
//     this.onChanged,
//     this.hintText, // Changed: hintText is now optional
//   });

//   @override
//   _CustomDropdownWidgetState createState() => _CustomDropdownWidgetState();
// }

// class _CustomDropdownWidgetState extends State<CustomDropdownWidget> {
//   String? _selectedItem;

//   @override
//   void initState() {
//     super.initState();
//     _selectedItem = widget.initialValue;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 15.0),
//       child: Container(
//         decoration: BoxDecoration(
//             color: Colors.white, borderRadius: BorderRadius.circular(10)),
//         padding: const EdgeInsets.only(left: 15.0, right: 15, top: 15),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Text(
//               widget.caption,
//               style: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             DropdownButtonHideUnderline(
//               child: DropdownButton<String>(
//                 value: _selectedItem,
//                 hint: widget.hintText != null
//                     ? Text(widget.hintText!,
//                         style: const TextStyle(fontSize: 13))
//                     : null, // Changed: Only show hint if hintText is provided
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _selectedItem = newValue;
//                   });
//                   if (widget.onChanged != null) {
//                     widget.onChanged!(newValue);
//                   }
//                 },
//                 items:
//                     widget.items.map<DropdownMenuItem<String>>((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value, style: const TextStyle(fontSize: 13)),
//                   );
//                 }).toList(),
//                 isExpanded: true,
//                 icon: SvgPicture.asset(
//                   widget.iconName,
//                   color: proprimaryColor,
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomDropdownWidget extends StatefulWidget {
  final String caption;
  final String iconName;
  final List<String> items;
  final String? initialValue;
  final ValueChanged<String?>? onChanged;
  final String? hintText;
  final FormFieldValidator<String>? validator; // New: Optional validator field

  const CustomDropdownWidget({
    super.key,
    required this.caption,
    required this.items,
    required this.iconName,
    this.initialValue,
    this.onChanged,
    this.hintText,
    this.validator, // New: Optional validator field
  });

  @override
  _CustomDropdownWidgetState createState() => _CustomDropdownWidgetState();
}

class _CustomDropdownWidgetState extends State<CustomDropdownWidget> {
  String? _selectedItem;

  @override
  void initState() {
    super.initState();
    // Set _selectedItem only if initialValue is within widget.items
    if (widget.items.contains(widget.initialValue)) {
      _selectedItem = widget.initialValue;
    } else {
      _selectedItem = null;
    }
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
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
              ),
              value:
                  widget.items.contains(_selectedItem) ? _selectedItem : null,
              hint: widget.hintText != null
                  ? Text(
                      widget.hintText!,
                      style: const TextStyle(fontSize: 13),
                    )
                  : null,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedItem = newValue;
                });
                if (widget.onChanged != null) {
                  widget.onChanged!(newValue);
                }
              },
              items: widget.items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: const TextStyle(fontSize: 13)),
                );
              }).toList(),
              isExpanded: true,
              icon: SvgPicture.asset(
                widget.iconName,
                color: proprimaryColor,
              ),
              validator: widget.validator,
            )
          ],
        ),
      ),
    );
  }
}
