import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../utils/theme/theme.dart';

Widget subscribetopremiumbutton() {
  return Container(
    decoration: BoxDecoration(
      color: primaryColorLT,
      borderRadius: BorderRadius.circular(100.0),
    ),
    child: const IntrinsicWidth(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Upgrade',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Icon(
              Icons.add,
              color: Colors.white,
              size: 15,
            )
          ],
        ),
      ),
    ),
  );
}
