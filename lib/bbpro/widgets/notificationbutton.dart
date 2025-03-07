import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class NotificationButton extends StatelessWidget {
  final double? padding;
  final double? toppadding;
  final bool hasUnreadNotification;
  const NotificationButton(
      {Key? key,
      this.padding,
      this.toppadding,
      this.hasUnreadNotification = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.notifications);
      },
      child: Stack(
        children: <Widget>[
          Padding(
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
          if (hasUnreadNotification)
            Positioned(
              right: 19,
              top: 7,
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: primaryColorLT,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
