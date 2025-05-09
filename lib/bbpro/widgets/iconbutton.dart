import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class ProIconButton extends StatelessWidget {
  final String text;
  final Widget? icon;
  final VoidCallback onPressed;
  final double? radius;
  final Color? backgroundColor;
  final Color? textColor;
  final double? padding;
  final double? vpadding;
  final Color? shadow;
  final double? textsize;

  const ProIconButton({
    super.key,
    required this.text,
    this.icon,
    required this.onPressed,
    this.radius,
    this.backgroundColor,
    this.textColor,
    this.padding,
    this.shadow,
    this.textsize,
    this.vpadding,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shadowColor: shadow ?? Colors.white,
        backgroundColor: backgroundColor ?? proprimaryColor, // Background color
        padding: EdgeInsets.symmetric(
            horizontal: padding ?? 20.0, vertical: vpadding ?? 10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius ?? 30.0),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (icon != null) icon!, // Display icon if it's not null
          if (icon != null)
            const SizedBox(width: 8.0), // Space between icon and text
          Text(
            text,
            style: TextStyle(
              color: textColor ?? Colors.white, // Text color
              fontSize: textsize ?? 14.0,
            ),
          ),
        ],
      ),
    );
  }
}
