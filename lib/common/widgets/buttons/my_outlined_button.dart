import 'package:flutter/material.dart';
import '../../../utils/theme/theme.dart';

class MCustomButton extends StatelessWidget {
  final double? width;
  final double? height;
  final double? radius;
  final Function? onPressed;
  final Widget? child;
  final EdgeInsets? margin;
  final String? label;
  final bool isProcessing;
  final ButtonType buttonType;

  const MCustomButton({
    Key? key,
    this.width = double.infinity,
    this.height = buttonHeight,
    this.radius = radiusValue,
    this.onPressed,
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
              onPressed: isProcessing ? null : onPressed as void Function()?,
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
                        children: [
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
              onPressed: isProcessing ? null : onPressed as void Function()?,
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
                        children: [
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
