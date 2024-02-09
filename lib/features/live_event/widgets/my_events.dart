import 'package:business_bosses_v2/features/live_event/controller/live_event_controller.dart';
import 'package:business_bosses_v2/features/live_event/models/events_model.dart';
import 'package:business_bosses_v2/features/live_event/presentation/live_event.dart';
import 'package:business_bosses_v2/features/live_event/widgets/event_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class MyEvents extends StatefulWidget {
  final bool? toHome;
  const MyEvents({super.key, this.toHome = false});

  @override
  State<MyEvents> createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  final LiveController liveController = Get.put(LiveController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset('assets/svgs/backbutton.svg'),),
          centerTitle: true,
          title: const Text(
            'My Events',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
          actions: <Widget>[
            widget.toHome != null && widget.toHome == true
                ? IconButton(
                    onPressed: () {
                      Get.to(() => const LiveEvent());
                    },
                    icon: SvgPicture.asset(
                      'assets/svgs/liveevent.svg',
                      height: 23,
                      color: Colors.black,
                    ),
                  )
                : const SizedBox(),
          ],
        ),
        body: Obx(
          () => liveController.loading.value
              ? const Center(child: CircularProgressIndicator())
              : liveController.joined.isNotEmpty
                  ? Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: liveController.joined.length,
                            itemBuilder: (BuildContext context, int index) {
                              EventModel event = liveController.joined[index];
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
        ));
  }
}
