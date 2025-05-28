import 'package:flutter/material.dart';

Widget but(BuildContext context, String text, bool white, Function() ontap) {
  TextStyle style = TextStyle(
      color: white ? Colors.black.withValues(alpha: 0.8) : Colors.white,
      fontSize: 13);
  return GestureDetector(
    onTap: ontap,
    child: Container(
      height: 35,
      width: 80,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: white ? Colors.grey.shade100 : Colors.red),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: style,
        ),
      ),
    ),
  );
}
