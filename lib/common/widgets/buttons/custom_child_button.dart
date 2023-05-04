import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class CustomChildButton extends StatelessWidget {
  final int value;
  final String caption;
  final Function onPressed;
  const CustomChildButton({
    Key? key,
    required this.value,
    required this.caption,
    required this.onPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed as void Function(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('$value',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold)),
          Text(
            caption,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: textColor.withOpacity(0.52),
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
          )
        ],
      ),
    );
  }
}
