import 'package:business_bosses_v2/features/live_event/widgets/event_call.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class EventsSection extends StatelessWidget {
  const EventsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.liveEvents);
      },
      child: Container(
        color: backgroundColor,
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'Events',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        const Text(
                          'View all',
                          style: TextStyle(fontSize: 11),
                        ),
                        const SizedBox(width: 5.0),
                        SvgPicture.asset(
                          'assets/svgs/nexticon.svg',
                          // ignore: deprecated_member_use
                          color: textColor,
                          height: 8,
                        ),
                      ]),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const EventCall(
              ishome: true,
              full: true,
            ),
          ],
        ),
      ),
    );
  }
}
