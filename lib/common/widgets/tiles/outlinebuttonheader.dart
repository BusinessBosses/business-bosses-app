import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../utils/theme/theme.dart';

// ignore: non_constant_identifier_names, public_member_api_docs
Container OutlineButtonHeader(BuildContext context, UserModel myProfile) {
  return Container(
    height: 50.0,
    margin: const EdgeInsets.only(top: 10),
    padding: const EdgeInsets.all(4.0),
    alignment: Alignment.center,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: OutlinedButton(
            onPressed: () async {
              Get.toNamed(Routes.updateProfile, arguments: myProfile);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Edit',
                  style: TextStyle(
                      fontSize: 15,
                      color: primaryColorLT,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  width: 5,
                ),
                SvgPicture.asset(
                  'assets/svgs/edit.svg',
                  height: 17,
                  color: primaryColorLT,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              Get.toNamed(Routes.promotionscreen);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Earn',
                  style: TextStyle(
                      fontSize: 15,
                      color: primaryColorLT,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  width: 5,
                ),
                SvgPicture.asset(
                  'assets/svgs/coin.svg',
                )
              ],
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              Get.toNamed(Routes.analysescreen);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Analyse',
                  style: TextStyle(
                      fontSize: 15,
                      color: primaryColorLT,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  width: 5,
                ),
                SvgPicture.asset(
                  'assets/svgs/analyse.svg',
                  height: 17,
                  color: primaryColorLT,
                )
              ],
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
      ],
    ),
  );
}
