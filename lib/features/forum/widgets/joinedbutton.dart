import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';

Widget JoinedButton(bool joined, VoidCallback onTap) {
  return GestureDetector(
    onTap: () {
      onTap();
    },
    child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        alignment: Alignment.center,
        child: Material(
          elevation: 4.0,
          shadowColor: Colors.black.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 500.0, // soften the shadow
                  spreadRadius: 15, //extend the shadow
                )
              ],
            ),
            child: Text(
              joined ? 'Leave' : 'Join',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: primaryColorLT,
              ),
            ),
          ),
        )),
  );
}
