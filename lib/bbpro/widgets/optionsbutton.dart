import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class OptionsButton extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final Color? borderColor;

  const OptionsButton({
    Key? key,
    this.padding ,
    this.borderColor, // Default border color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: borderColor ?? backgroundColor,
          width: 1,
        ),
      ),
      child: const Center(child: Icon(Icons.more_vert)),
    );
  }
}
