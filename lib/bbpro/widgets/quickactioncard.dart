import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class QuickActionCard extends StatefulWidget {
  final String cardName;
  final String value;
  final String? assetlocation;
  final Color? color;

  const QuickActionCard({
    required this.cardName,
    required this.value,
    super.key,
    this.assetlocation,
    this.color,
  });

  @override
  // ignore: library_private_types_in_public_api
  _QuickActionCardState createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<QuickActionCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
            radius: 30,
            backgroundColor: widget.color != null
                ? widget.color!.withValues(alpha: 0.1)
                : prosemibackColor,
            child: SvgPicture.asset(
              widget.assetlocation!,
              colorFilter: ColorFilter.mode(
                  widget.color ?? Colors.black, BlendMode.srcIn),
              height: 25,
            )),
        const SizedBox(
          height: 5,
        ),
        Text(
          widget.cardName,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
