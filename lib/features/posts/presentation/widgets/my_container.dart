import 'package:flutter/material.dart';

class MyContainer extends StatelessWidget {
  final double height, width, radius;
  final Color color;
  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets margin;

  const MyContainer({
    Key? key,
    this.height = 0,
    this.width = double.infinity,
    this.radius = 10.0,
    this.color = Colors.white,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
    this.margin = const EdgeInsets.all(0.0),
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      height: height,
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: child,
    );
  }
}
