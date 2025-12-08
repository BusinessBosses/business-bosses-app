import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucide_icons/lucide_icons.dart';

class PostTag extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color? textColor;

  const PostTag(
      {super.key,
      required this.label,
      required this.backgroundColor,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(500), color: backgroundColor),
      margin: EdgeInsets.only(left: 15, top: 15),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          Icon(
            label == 'Learning'
                ? LucideIcons.bookOpen
                : label == 'Partners Deals'
                    ? LucideIcons.heartHandshake
                    : label == 'Crowdfund'
                        ? LucideIcons.dollarSign
                        : label == 'Growth'
                            ? LucideIcons.arrowUpRight
                            : LucideIcons.trophy,
            size: 10,
            color: textColor ?? Colors.black,
          ),
          const SizedBox(width: 5),
          Text(label,
              style: TextStyle(color: textColor ?? Colors.black, fontSize: 12)),
        ],
      ),
    );
  }
}
