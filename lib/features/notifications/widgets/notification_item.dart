import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utils/theme/theme.dart';
import '../models/my_notification.dart';

// ignore: public_member_api_docs
class NotificationItem extends StatelessWidget {
  // ignore: public_member_api_docs
  final MyNotification myNotification;
  // ignore: public_member_api_docs
  final VoidCallback? onTap;

  // ignore: public_member_api_docs
  const NotificationItem(
    this.myNotification, {
    Key? key,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
                radius: 48 / 2,
                backgroundColor: primaryColorLT.withOpacity(0.1),
                child: myNotification.title!.contains('New Message')
                    ? SvgPicture.asset(
                        'assets/svgs/message.svg',
                        color: primaryColorLT,
                      )
                    : SvgPicture.asset(
                        'assets/svgs/notification.svg',
                        color: primaryColorLT,
                      )),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          myNotification.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: bodyText1,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    myNotification.message,
                    style: bodyText2,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
