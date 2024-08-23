import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class ProIconButton extends StatelessWidget {
  final String text;
  final Widget? icon;
  final VoidCallback onPressed;
  final double? radius;
  final Color? backgroundColor;
    final Color? textColor;

  const ProIconButton({
    Key? key,
    required this.text,
    this.icon,
    required this.onPressed,
    this.radius,
    this.backgroundColor, this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.white,
        backgroundColor: backgroundColor ?? proprimaryColor, // Background color
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius ?? 30.0),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (icon != null) icon!, // Display icon if it's not null
          if (icon != null) const SizedBox(width: 8.0), // Space between icon and text
          Text(
            text,
            style: TextStyle(
              color: textColor ?? Colors.white, // Text color
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }
}
