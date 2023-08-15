import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import '../../../utils/theme/theme.dart';

Widget subscribetopremiumbutton() {
  return Container(
    decoration: BoxDecoration(
      color: Color(0xFFF4F4F4),
      borderRadius: BorderRadius.circular(100.0),
    ),
    child: IntrinsicWidth(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Subscribe to Premium',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            SvgPicture.asset(
              'assets/svgs/nextbutton.svg',
              color: primaryColorLT,
            ),
          ],
        ),
      ),
    ),
  );
}
