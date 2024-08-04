import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomTextWidget extends StatefulWidget {
  final String caption;
  final String iconName;
  final String text;

  const CustomTextWidget(
      {super.key,
      required this.caption,
      required this.iconName,
      required this.text});

  @override
  // ignore: library_private_types_in_public_api
  _CustomTextWidgetState createState() => _CustomTextWidgetState();
}

class _CustomTextWidgetState extends State<CustomTextWidget> {
  String? _selectedItem;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.caption,
              style: const TextStyle(
                fontSize: 16,
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
                Text(
                  widget.text,
                  style: TextStyle(
                      fontSize: 16,
                      color: widget.text == 'Choose Shop Location'
                          ? hintColor
                          : textColor),
                ),
                SvgPicture.asset(
                  widget.iconName,
                  color: proprimaryColor,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
