import 'package:flutter/material.dart';

import '../../utils/theme/theme.dart';

/// Text Widget
class TextWidget extends StatelessWidget {
  /// Text Widget
  const TextWidget({
    Key? key,
    this.color = textColor,
    this.fontWeight = FontWeight.w600,
    this.size = 15,
    this.centralize = false,
    required this.text,
  }) : super(key: key);
  final String text;
  final FontWeight fontWeight;
  final Color color;
  final double size;
  final bool centralize;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: fontWeight,
        fontSize: size,
        color: color,
      ),
      textAlign: centralize ? TextAlign.center : TextAlign.left,
    );
  }
}
