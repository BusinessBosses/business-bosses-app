import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class CustomChildButton extends StatelessWidget {
  final int value;
  final String caption;
  final Function onPressed;
  const CustomChildButton({
    super.key,
    required this.value,
    required this.caption,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    String formattedValue = value.toString();
    if (value >= 1000) {
      double kmValue = value / 1000;
      formattedValue = '${kmValue.toStringAsFixed(kmValue % 1 == 0 ? 0 : 1)}k';
    }
    return TextButton(
      onPressed: onPressed as void Function(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(formattedValue,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold)),
          Text(
            caption,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: textColor.withValues(alpha: 0.52),
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
          )
        ],
      ),
    );
  }
}
