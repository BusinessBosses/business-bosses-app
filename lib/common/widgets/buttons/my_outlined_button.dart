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
                          if (label != null)
                            Text(
                              label!,
                              style: headline6.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                    ),
            ),
          )
        : buttonType == ButtonType.grey
            ? Container(
                margin: margin,
                width: width,
                height: height,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    elevation: 0.0,
                  ),
                  onPressed:
                      isProcessing ? null : onPressed as void Function()?,
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
                              if (label != null)
                                Text(
                                  label!,
                                  style: headline6.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                            ],
                          ),
                        ),
                ),
              )
            : buttonType == ButtonType.outlinegrey
                ? Container(
                    margin: margin,
                    width: width,
                    height: height,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Colors.grey, // Adjust the color as needed
                        ),
                      ),
                      onPressed:
                          isProcessing ? null : onPressed as void Function()?,
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
                                  if (label != null)
                                    Text(
                                      label!,
                                      style: headline6.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF4B4B4B),
                                      ),
                                    ),
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
                      onPressed:
                          isProcessing ? null : onPressed as void Function()?,
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
                                  if (label != null)
                                    Text(
                                      label!,
                                      style: headline6.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                    ),
                  );
  }
}

/// BUTTON TYPE
enum ButtonType { outline, elevated, outlinegrey, grey }
