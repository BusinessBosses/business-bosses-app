import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ProCustomButton extends StatefulWidget {
  final String text;
  final Widget? icon;
  final VoidCallback onPressed;
  bool back;
  bool loading;
  final Color? color;
  final double? padding;

  ProCustomButton({
    super.key,
    required this.text,
    this.icon,
    required this.onPressed,
    this.back = false,
    this.loading = false,
    this.color,
    this.padding,
  });

  @override
  State<ProCustomButton> createState() => _ProCustomButtonState();
}

class _ProCustomButtonState extends State<ProCustomButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.padding ?? 15.0),
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
          onPressed: !widget.loading ? widget.onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                widget.color ?? proprimaryColor, // Background color
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: widget.loading
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (!widget.back)
                      if (widget.icon != null) widget.icon!,
                    if (!widget.back)
                      const SizedBox(
                        width: 5,
                      ), // Display icon if it's not null
                    Text(
                      widget.text,
                      style: const TextStyle(
                          color: Colors.white, // Text color
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
