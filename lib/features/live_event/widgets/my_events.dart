import 'package:business_bosses_v2/features/live_event/controller/live_event_controller.dart';
import 'package:business_bosses_v2/features/live_event/models/events_model.dart';
import 'package:business_bosses_v2/features/live_event/presentation/live_event.dart';
import 'package:business_bosses_v2/features/live_event/widgets/event_item.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class MyEvents extends StatefulWidget {
  const MyEvents({super.key});

  @override
  State<MyEvents> createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  final LiveController liveController = Get.put(LiveController());
  @override
  Widget build(BuildContext context) {
    String? previousScreen = Get.previousRoute;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
          ),
          centerTitle: true,
          title: const Text(
            'My Events',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
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
                  : previousScreen == '/myProfileScreen'
                      ? Center(
                          child: Column(
                             mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'You Have Not Chosen To Attend Any Event!',
                              ),
                              const SizedBox(height: 10,),
                              Stack(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                      color: backgroundcolorinterface,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Wrap(
                                        crossAxisAlignment: WrapCrossAlignment.center,
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () {
                                              Get.to(() => const LiveEvent());
                                            },
                                            child: const Text(
                                              'Go to Events',
                                              style: TextStyle(
                                                color: primaryColorLT,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          SvgPicture.asset(
                                              'assets/svgs/nexticon.svg'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      : const Center(
                          child: Text(
                            'You Have Not Chosen To Attend Any Event!',
                          ),
                        ),
        ));
  }
}
