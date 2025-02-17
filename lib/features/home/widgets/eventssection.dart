import 'package:business_bosses_v2/features/live_event/controller/live_event_controller.dart';
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
    return GetBuilder<LiveController>(
        builder: (LiveController controller) => controller.events.isNotEmpty
            ? GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.liveEvents);
                },
                child: Container(
                  color: backgroundColor,
                  child: const Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Events',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 14),
                            ),
                            Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: <Widget>[
                                  // const Text(
                                  //   'View all',
                                  //   style: TextStyle(fontSize: 11),
                                  // ),
                                  // const SizedBox(width: 5.0),
                                  Icon(Icons.chevron_right,
                                      color: textColor, size: 16),
                                ]),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      EventCall(
                        ishome: true,
                        full: true,
                      ),
                    ],
                  ),
                ),
              )
            : Container());
  }
}
