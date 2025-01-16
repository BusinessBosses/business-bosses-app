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
  final FormFieldValidator<String>? validator;
  final Widget? secondarysection;
  final double? padding;
  final bool? isorder;
  final Color? iconcolor;

  const CustomDropdownWidget({
    super.key,
    required this.caption,
    required this.items,
    required this.iconName,
    this.initialValue,
    this.onChanged,
    this.hintText,
    this.validator,
    this.secondarysection,
    this.isorder,
    this.padding,
    this.iconcolor,
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
    if (widget.initialValue != null &&
        widget.items.contains(widget.initialValue)) {
      _selectedItem = widget.initialValue;
    } else {
      _selectedItem = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.padding ?? 15.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.only(
          left: 15.0,
          right: 15,
          top: widget.isorder != null ? 0 : 15,
        ),
        child: widget.isorder != null
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      widget.caption,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                      ),
                      value: _selectedItem, // Directly use _selectedItem
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
                      items: widget.items
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child:
                              Text(value, style: const TextStyle(fontSize: 13)),
                        );
                      }).toList(),
                      isExpanded: true,
                      icon: SvgPicture.asset(
                        widget.iconName,
                        color: widget.iconcolor ?? proprimaryColor,
                      ),
                      validator: widget.validator,
                    ),
                  ),
                ],
              )
            : Column(
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
                    value: _selectedItem, // Directly use _selectedItem
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
                    items: widget.items
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child:
                            Text(value, style: const TextStyle(fontSize: 13)),
                      );
                    }).toList(),
                    isExpanded: true,
                    icon: SvgPicture.asset(
                      widget.iconName,
                      color: widget.iconcolor ?? proprimaryColor,
                    ),
                    validator: widget.validator,
                  ),
                  if (widget.secondarysection != null) widget.secondarysection!,
                ],
              ),
      ),
    );
  }
}
