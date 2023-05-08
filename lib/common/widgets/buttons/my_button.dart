import 'package:flutter/material.dart';

import '../../../utils/theme/theme.dart';

class MyButton extends StatelessWidget {
  final String label;
  final TextStyle labelStyle;
  final double height;
  final double width;
  final Function onPressed;
  final bool isProcessing;

  const MyButton({
    Key? key,
    required this.label,
    this.labelStyle = const TextStyle(),
    this.height = buttonHeight,
    this.width = double.infinity,
    required this.onPressed,
    this.isProcessing = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: buttonHeight,
      child: isProcessing
          ? Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: primaryColorLT,
                borderRadius: BorderRadius.circular(10.0),
              ),
              alignment: Alignment.center,
              child: const SizedBox(
                height: 24.0,
                width: 24.0,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
              ),
            )
          : ElevatedButton(
              onPressed: () {},
              child: Text(
                label ?? 'Continue',
                style: labelStyle,
              ),
            ),
    );
  }
}
