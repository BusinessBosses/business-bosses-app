import 'package:business_bosses_v2/features/premium/premiumscreen.dart';
import 'package:business_bosses_v2/features/premium/proscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
          Get.bottomSheet(
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            SizedBox(
              height: Get.height * 0.9,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        'Upgrade now to get your listing featured',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // Lottie.asset(
                    //   'assets/anim/listing.json',
                    //   fit: BoxFit.cover,
                    //   height: 90,
                    //   width: 90,
                    // ),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 0.0, top: 10, bottom: 10),
                        child: ProSubscribeSection(
                          isGrow: true,
                        )),
                  ],
                ),
              ),
            ),
            backgroundColor: Colors.white,
          );
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
              // SizedBox(
              //   width: 5,
              // ),
              // Icon(
              //   Icons.add,
              //   color: Colors.white,
              //   size: 15,
              // )
            ],
          ),
        ),
      ),
    ),
  );
}
