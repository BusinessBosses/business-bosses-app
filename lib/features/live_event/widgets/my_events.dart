import 'package:business_bosses_v2/features/live_event/controller/live_event_controller.dart';
import 'package:business_bosses_v2/features/live_event/models/events_model.dart';
import 'package:business_bosses_v2/features/live_event/widgets/event_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyEvents extends StatefulWidget {
  final List<EventModel>? joined;
  const MyEvents({super.key, this.joined});

  @override
  State<MyEvents> createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  final LiveController liveController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('My Events'),
      ),
      body: widget.joined!.isNotEmpty
          ? Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: liveController.upcoming.length,
                    itemBuilder: (BuildContext context, int index) {
                      EventModel event = liveController.upcoming[index];
                      return EventItem(
                        event: event,
                        ongoing: false,
                      );
                    },
                  ),
                ),
              ],
            )
          : const Center(
              child: Text(
                'You Have Not Chose To Attend Any Event!',
              ),
            ),
    );
  }
}