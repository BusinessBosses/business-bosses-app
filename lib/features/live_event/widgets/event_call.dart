import 'package:business_bosses_v2/features/live_event/controller/live_event_controller.dart';
import 'package:business_bosses_v2/features/live_event/models/events_model.dart';
import 'package:business_bosses_v2/features/live_event/widgets/event_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventCall extends StatefulWidget {
  const EventCall(
      {super.key, this.ongoing = false, this.full = false, this.ishome});
  final bool ongoing;
  final bool full;
  final bool? ishome;

  @override
  State<EventCall> createState() => _EventCallState();
}

class _EventCallState extends State<EventCall> {
  final LiveController liveEventController = Get.put(LiveController());

  @override
  Widget build(BuildContext context) {
    EventModel event = liveEventController.events[0];
    if (widget.ishome == true) {
      return liveEventController.events.isNotEmpty
          ?
          // SizedBox(
          //     height: 260,
          //     child: ListView.builder(
          //       physics: const NeverScrollableScrollPhysics(),
          //       shrinkWrap: false,
          //       itemCount: 1,
          //       itemBuilder: (BuildContext context, int index) {

          //       },
          //     ),
          //   )

          Column(
              children: <Widget>[
                EventItem(
                  ishomeview: true,
                  event: event,
                  ongoing: liveEventController.ongoing.contains(event)
                      ? true
                      : false,
                ),
              ],
            )
          : const Center(
              child: Text('No Event Available!'),
            );
    }

    if (widget.full) {
      return liveEventController.events.isNotEmpty
          ? Obx(
              () => ListView.builder(
                itemCount: liveEventController.events.length,
                itemBuilder: (BuildContext context, int index) {
                  EventModel event = liveEventController.events[index];
                  return EventItem(
                    event: event,
                    ongoing: liveEventController.ongoing.contains(event)
                        ? true
                        : false,
                  );
                },
              ),
            )
          : const Center(
              child: Text('No Event Available!'),
            );
    } else {
      return !widget.ongoing
          ? liveEventController.upcoming.isNotEmpty
              ? Obx(
                  () => ListView.builder(
                    itemCount: liveEventController.upcoming.length,
                    itemBuilder: (BuildContext context, int index) {
                      EventModel event = liveEventController.upcoming[index];
                      return EventItem(
                        event: event,
                        ongoing: false,
                      );
                    },
                  ),
                )
              : const Center(
                  child: Text('No Live Event is Upcoming'),
                )
          : liveEventController.ongoing.isNotEmpty
              ? Obx(
                  () => ListView.builder(
                    physics: widget.ishome == true
                        ? const NeverScrollableScrollPhysics()
                        : null,
                    itemCount: liveEventController.ongoing.length,
                    itemBuilder: (BuildContext context, int index) {
                      EventModel event = liveEventController.ongoing[index];
                      return EventItem(
                        event: event,
                        ongoing: true,
                      );
                    },
                  ),
                )
              : const Center(
                  child: Text('No Live Event is Ongoing'),
                );
    }
  }
}
