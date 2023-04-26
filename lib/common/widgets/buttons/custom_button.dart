// ignore_for_file: public_member_api_docs

import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final double width, height, radius;
  final VoidCallback onPressed;
  final Widget? child;
  final EdgeInsets? margin;
  final String? label;
  final bool isProcessing;
  final ButtonType buttonType;

  const CustomButton({
    Key? key,
    this.width = double.infinity,
    this.height = buttonHeight,
    this.radius = radiusValue,
    required this.onPressed,
    this.margin,
    this.child,
    this.label,
    this.isProcessing = false,
    this.buttonType = ButtonType.outline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buttonType == ButtonType.outline
        ? Container(
            margin: margin,
            width: width,
            height: height,
            child: OutlinedButton(
              onPressed: isProcessing ? null : onPressed,
              child: isProcessing
                  ? const SizedBox(
                      width: 24.0,
                      height: 24.0,
                      child: CircularProgressIndicator(),
                    )
                  : FittedBox(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          child ?? Container(),
                          label != null
                              ? Text(
                                  label!,
                                  style: headline6.copyWith(
                                      fontWeight: FontWeight.bold),
                                )
                              : Container(),
                        ],
                      ),
                    ),
            ),
          )
        : Container(
            margin: margin,
            width: width,
            height: height,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0.0,
              ),
              onPressed: isProcessing ? null : onPressed,
              child: isProcessing
                  ? const SizedBox(
                      width: 24.0,
                      height: 24.0,
                      child: CircularProgressIndicator(),
                    )
                  : FittedBox(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          child ?? Container(),
                          label != null
                              ? Text(
                                  label!,
                                  style: headline6.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
            ),
          );
  }
}

enum ButtonType { outline, elevated }
