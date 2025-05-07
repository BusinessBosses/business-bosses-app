// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// Icon Text Button
class IconTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double width, height;
  final Color backgroundColor;
  final BorderRadius borderRadius;
  final String label;
  final Color labelColor;
  final IconData? icon;
  final EdgeInsetsGeometry padding;

  /// Icon text button
  const IconTextButton({
    super.key,
    required this.onPressed,
    this.width = double.infinity,
    this.height = 57.0,
    this.backgroundColor = Colors.white,
    required this.borderRadius,
    this.label = 'Button',
    this.labelColor = Colors.black,
    this.icon,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: borderRadius,
      onTap: onPressed,
      child: Ink(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            icon == null
                ? SvgPicture.asset(
                    'assets/svgs/g.svg',
                    width: 17,
                  )
                : Icon(icon),
            const SizedBox(width: 5.0),
            Text(
              label,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: labelColor,
                  ),
            )
          ],
        ),
      ),
    );
  }
}
