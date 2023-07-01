import 'package:business_bosses_v2/common/widgets/buttons/my_outlined_button.dart';
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
              child: SizedBox(
                  height: 38,
                  width: 80,
                  child: !joined
                      ? const MCustomButton(
                          child: Text(
                            'Join',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: primaryColorLT,
                            ),
                          ),
                        )
                      : const MCustomButton(
                          buttonType: ButtonType.outlinegrey,
                          child: Text(
                            'Leave',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF777777),
                            ),
                          ),
                        )))));
}
