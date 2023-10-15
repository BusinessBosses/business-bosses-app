import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../utils/theme/theme.dart';

Widget subscribetopremiumbutton() {
  return Container(
    decoration: BoxDecoration(
      color: primaryColorLT,
      borderRadius: BorderRadius.circular(100.0),
    ),
    child: IntrinsicWidth(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Subscribe to Premium',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            SvgPicture.asset(
              'assets/svgs/nextbutton.svg',
              color: Colors.white,
            ),
          ],
        ),
      ),
    ),
  );
}
