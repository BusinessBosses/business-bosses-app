import 'package:business_bosses_v2/bbpro/presentation/pronotification.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class NotificationButton extends StatelessWidget {
  const NotificationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(ProNotifications());
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 10.0, bottom: 15),
        child: CircleAvatar(
          backgroundColor: prosemibackColor,
          radius: 30, // This sets the circle's radius
          child: Padding(
            padding: const EdgeInsets.all(
                10), // Adjust padding to fit the icon nicely
            child: SvgPicture.asset(
              'assets/svgs/notificationicon.svg',
              height: 20,
            ),
          ),
        ),
      ),
    );
  }
}
