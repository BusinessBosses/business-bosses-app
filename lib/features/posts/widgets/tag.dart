import 'package:flutter/material.dart';

class PostTag extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color? textColor;

  const PostTag(
      {super.key,
      required this.label,
      required this.backgroundColor,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(500), color: backgroundColor),
      margin: EdgeInsets.only(left: 15, top: 15),
      child: Text(label, style: TextStyle(color: textColor ?? textColor)),
    );
  }
}
