import 'package:flutter/material.dart';

class ProIconButton extends StatelessWidget {
  final String text;
  final Widget? icon;
  final VoidCallback onPressed;
  final double? radius;

  const ProIconButton({
    Key? key,
    required this.text,
    this.icon,
    required this.onPressed,
    this.radius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: Color(0xFF4A6FA5), // Background color
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius ?? 30.0),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) icon!, // Display icon if it's not null
          if (icon != null) SizedBox(width: 8.0), // Space between icon and text
          Text(
            text,
            style: TextStyle(
              color: Colors.white, // Text color
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}
