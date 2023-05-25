// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

import '../../utils/theme/theme.dart';

class FieldContainer extends StatelessWidget {
  final Color color;
  final double height;
  final double radius;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Alignment alignment;
  final String message;
  final TextStyle messageStyle;
  final double bottomSpace;
  final double topSpace;
  final bool isError;

  const FieldContainer({
    Key? key,
    required this.child,
    this.color = Colors.white,
    this.height = fieldHeight,
    this.radius = radiusValue,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
    this.alignment = Alignment.center,
    this.bottomSpace = 0.0,
    this.topSpace = 0.0,
    required this.message,
    this.messageStyle = const TextStyle(),
    this.isError = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: topSpace),
        Container(
          padding: padding,
          width: double.infinity,
          height: height,
          alignment: alignment,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(radius),
          ),
          child: child,
        ),
        const SizedBox(height: 8.0),
        Text(
          message,
          style: messageStyle.copyWith(
            color: isError ? Colors.red : textColor,
            fontSize: 12.0,
          ),
        ),
        SizedBox(height: bottomSpace),
      ],
    );
  }
}
