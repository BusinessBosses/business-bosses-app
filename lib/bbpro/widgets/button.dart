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

  ProCustomButton({
    Key? key,
    required this.text,
    this.icon,
    required this.onPressed,
    this.back = false,
    this.loading = false,
    this.color,
  }) : super(key: key);

  @override
  State<ProCustomButton> createState() => _ProCustomButtonState();
}

class _ProCustomButtonState extends State<ProCustomButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
          onPressed: !widget.loading ? widget.onPressed : () {},
          style: ElevatedButton.styleFrom(
            backgroundColor:
                widget.color ?? proprimaryColor, // Background color
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (widget.back)
                if (widget.icon != null) widget.icon!,
              if (widget.loading)
                const CircularProgressIndicator(
                  color: Colors.white,
                ),
              if (!widget.loading)
                Text(
                  widget.text,
                  style: const TextStyle(
                      color: Colors.white, // Text color
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700),
                ),
              if (widget.back == false)
                if (widget.icon != null)
                  widget.icon!, // Display icon if it's not null
            ],
          ),
        ),
      ),
    );
  }
}
