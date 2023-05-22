import 'package:flutter/material.dart';

import '../../../utils/theme/theme.dart';

/// MyButton Widget
class MyButton extends StatelessWidget {
  // ignore: public_member_api_docs
  final String label;
  // ignore: public_member_api_docs
  final TextStyle labelStyle;
  // ignore: public_member_api_docs
  final double height;
  // ignore: public_member_api_docs
  final double width;
  // ignore: public_member_api_docs
  final Function onPressed;
  // ignore: public_member_api_docs
  final bool isProcessing;

  /// MyButton Widget
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
              onPressed: () {
                onPressed();
              },
              child: Text(
                label,
                style: labelStyle,
              ),
            ),
    );
  }
}
