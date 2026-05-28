import 'package:business_bosses_v2/features/premium/premium_paywall_sheet.dart';
import 'package:flutter/material.dart';

import '../../../utils/theme/theme.dart';

Widget subscribetopremiumbutton() {
  return Container(
    decoration: BoxDecoration(
      color: primaryColorLT,
      borderRadius: BorderRadius.circular(100.0),
    ),
    child: IntrinsicWidth(
      child: GestureDetector(
        onTap: () {
          showPremiumPaywall();
        },
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Upgrade to Pro',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
