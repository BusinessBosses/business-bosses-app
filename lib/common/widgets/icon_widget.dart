import 'package:flutter/material.dart';

import '../../utils/theme/theme.dart';

/// Icon widget
class IconWidget extends StatelessWidget {
  /// Icon widget
  const IconWidget({
    super.key,
    this.color = iconColor,
    required this.icon,
    this.size = 23,
  });
  final IconData icon;
  final Color color;
  final double size;
  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: size,
      color: color,
    );
  }
}
