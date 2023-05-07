import 'package:flutter/material.dart';

import '../../../utils/theme/theme.dart';

class MyPopupMenuButton extends StatelessWidget {
  final List<PopupMenuEntry<String>> popupItems;
  final void Function(String newValue) onSelected;
  final double elevation;
  final Icon icon;
  final double iconSize;
  final EdgeInsets padding;
  const MyPopupMenuButton(
      {Key? key,
      required this.popupItems,
      required this.onSelected,
      this.elevation = 8.0,
      this.icon = const Icon(Icons.keyboard_arrow_down, color: hintColor),
      this.iconSize = 24.0,
      this.padding = const EdgeInsets.all(0.0)})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      elevation: elevation,
      onSelected: onSelected,
      icon: icon,
      iconSize: iconSize,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      padding: padding,
      itemBuilder: (context) => popupItems,
    );
  }
}
