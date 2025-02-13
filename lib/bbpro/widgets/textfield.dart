import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomTextWidget extends StatefulWidget {
  final String caption;
  final String iconName;
  final String? text;
  final bool? hashint;
  final Color? backgroundColor;
  final double? padding;
  final double? textpadding;
  final bool? isSupplier;
  final String? buttontext;
  final Widget? selectedarea;
  final Color? iconcolor;

  const CustomTextWidget(
      {super.key,
      required this.caption,
      required this.iconName,
      required this.text,
      this.backgroundColor,
      this.padding,
      this.textpadding,
      this.isSupplier,
      this.buttontext,
      this.selectedarea,
      this.hashint,
      this.iconcolor});

  @override
  // ignore: library_private_types_in_public_api
  _CustomTextWidgetState createState() => _CustomTextWidgetState();
}

class _CustomTextWidgetState extends State<CustomTextWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.padding ?? 10.0),
      child: Container(
        decoration: BoxDecoration(
            color: widget.backgroundColor ?? Colors.white,
            borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.symmetric(
            horizontal: widget.textpadding ?? 5, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.caption,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    widget.text == null ? '' : widget.text!,
                    style: const TextStyle(fontSize: 13, color: textColor),
                  ),
                ),
                widget.isSupplier == true
                    ? SizedBox(
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                proprimaryColor, // Background color
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                widget.buttontext!,
                                style: const TextStyle(
                                  color: Colors.white, // Text color
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : SvgPicture.asset(
                        widget.iconName,
                        color: widget.iconcolor ?? proprimaryColor,
                      ),
              ],
            ),
            if (widget.selectedarea != null)
              const SizedBox(
                height: 10,
              ),
            widget.selectedarea ?? const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
