import 'package:business_bosses_v2/bbpro/presentation/pronotification.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class NotificationButton extends StatelessWidget {
  final double? padding;
  final double? toppadding;
  const NotificationButton({super.key, this.padding, this.toppadding});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => const ProNotifications());
      },
      child: Padding(
        padding: EdgeInsets.only(
            right: 10.0, bottom: padding ?? 0, top: toppadding ?? 0),
        child: CircleAvatar(
            radius: 20,
            backgroundColor: prosemibackColor,
            child: SvgPicture.asset(
              'assets/svgs/notificationicon.svg',
              height: 20,
            )),
      ),
    );
  }
}
