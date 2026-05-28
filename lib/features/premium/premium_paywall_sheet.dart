import 'package:business_bosses_v2/features/premium/premiumscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showPremiumPaywall() {
  Get.bottomSheet(
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
    ),
    Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      height: Get.height * 0.9,
      child: const ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        child: SingleChildScrollView(
          child: PremiumScreen(),
        ),
      ),
    ),
    backgroundColor: Colors.white,
  );
}
