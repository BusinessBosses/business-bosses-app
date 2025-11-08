import 'package:business_bosses_v2/action/action.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/profile/presentation/update_profile_screen.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../utils/theme/theme.dart';

// ignore: non_constant_identifier_names, public_member_api_docs
Container OutlineButtonHeader(BuildContext context, UserModel myProfile) {
  void shareWithFriends() {
    // ignore: unnecessary_null_comparison
    if (myProfile.inviteId == null) return;
    String message = 'Check out Business Bosses.\n'
        'An app to meet entrepreneurs and grow your business. Join now for FREE promotion\n'
        'https://businessbosses.onelink.me/xLWk/36a2ff16\n'
        'Invite id: $myProfile.inviteId';
    socialShare(message);
  }

  return Container(
    height: 50.0,
    padding: const EdgeInsets.all(4.0),
    alignment: Alignment.center,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: OutlinedButton(
            onPressed: () async {
              Get.to(
                () => UpdateProfileScreen(
                  user: myProfile,
                ),
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SvgPicture.asset(
                  'assets/svgs/edit.svg',
                  height: 17,
                  colorFilter:
                      const ColorFilter.mode(primaryColorLT, BlendMode.srcIn),
                ),
                const SizedBox(
                  width: 5,
                ),
                const Text(
                  'Edit',
                  style: TextStyle(
                      fontSize: 15,
                      color: primaryColorLT,
                      fontWeight: FontWeight.w500),
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
              children: <Widget>[
                SvgPicture.asset(
                  'assets/svgs/coin.svg',
                ),
                const SizedBox(
                  width: 5,
                ),
                const Text(
                  'Earn',
                  style: TextStyle(
                      fontSize: 15,
                      color: primaryColorLT,
                      fontWeight: FontWeight.w500),
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
              shareWithFriends();
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(LucideIcons.share2, color: primaryColorLT, size: 17),
                const SizedBox(
                  width: 5,
                ),
                const Text(
                  'Invite',
                  style: TextStyle(
                      fontSize: 15,
                      color: primaryColorLT,
                      fontWeight: FontWeight.w500),
                ),
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
