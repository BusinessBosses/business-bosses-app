// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum BadgeSize { small, medium, large }

class RankingBadge extends StatelessWidget {
  final double size;

  const RankingBadge({Key? key, this.size = 30.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      padding: EdgeInsets.all(size * .2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Colors.black,
            blurRadius: 500.0, // soften the shadow
            spreadRadius: 0.02, //extend the shadow
          )
        ],
      ),
      child: SvgPicture.asset(
        'assets/svgs/bosseek.svg',
      ),
    );
  }
}
