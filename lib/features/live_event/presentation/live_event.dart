// ignore_for_file: public_member_api_docs

import 'dart:math';

import 'package:business_bosses_v2/action/action.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/features/live_event/controller/live_event_controller.dart';
import 'package:business_bosses_v2/features/live_event/models/events_model.dart';
import 'package:business_bosses_v2/features/live_event/widgets/call_room.dart';
import 'package:business_bosses_v2/features/live_event/widgets/event_item.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import 'create_event.dart';

class LiveEvent extends StatefulWidget {
  const LiveEvent({super.key});

  @override
  State<LiveEvent> createState() => _LiveEventState();
}

class _LiveEventState extends State<LiveEvent> {
  final LiveController liveEventController = Get.put(LiveController());
  TextEditingController joinEvent = TextEditingController();
  List<bool> _isSelected = <bool>[true, false];
  int _currentIndex = 0;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    tzdata.initializeTimeZones(); // Initialize time zones
    super.initState();
  }

  DateTime selectedDateTime = DateTime.now();

  void _showDateTimePicker() {
    DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      onChanged: (DateTime date) {
        setState(() {
          selectedDateTime = date;
          tz.TZDateTime selectedDateTimeZ = tz.TZDateTime.now(tz.local);
          final String formattedDateTime =
              DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(selectedDateTimeZ);
          print(formattedDateTime);
        });
      },
      currentTime: selectedDateTime,
    );
  }

  final Map<int, Widget> _segments = {
    0: const Padding(
      padding: EdgeInsets.all(8),
      child: Text(
        'Upcoming',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    1: const Padding(
      padding: EdgeInsets.all(8),
      child: Text('Ongoing', style: TextStyle(fontWeight: FontWeight.bold)),
    )
  };

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LiveController>(
      builder: (LiveController liveController) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
            ),
            centerTitle: true,
            title: const Text(
              'Live Events',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ),
          body: liveController.loading.value
              ? const Center(child: CircularProgressIndicator())
              : NestedScrollView(
                  controller: scrollController,
                  headerSliverBuilder: (
                    BuildContext context,
                    bool innerBoxIsScrolled,
                  ) {
                    return <Widget>[
                      SliverStickyHeader(
                        sticky: false,
                        header: Column(
                          children: <Widget>[
                            Stack(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                    top: 10,
                                    right: 15,
                                    left: 15,
                                  ),
                                  height: 150,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    image: const DecorationImage(
                                      image: AssetImage(
                                          'assets/images/live_event.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const Positioned(
                                  top: 50,
                                  right: 35,
                                  child: Text(
                                    'Share your thoughts with bosses\n We want to listen as it happens',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    softWrap: true,
                                  ),
                                ),
                                Positioned(
                                  bottom: 10,
                                  right: 35,
                                  child: ElevatedButton(
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            CreateEvent(),
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 10,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                      ),
                                    ),
                                    child: const Text(
                                      'Create Live Event',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                top: 10,
                                right: 15,
                                left: 15,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: TextField(
                                      controller: joinEvent,
                                      decoration: const InputDecoration(
                                        hintText: 'Find Event By ID',
                                        filled: true,
                                        fillColor: backgroundColor,
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color.fromRGBO(
                                                224, 224, 224, 1),
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(12),
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 0,
                                          bottom: 0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  ElevatedButton(
                                    onPressed: () => joinLive(context, ''),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color.fromRGBO(242, 28, 41, 1),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 35,
                                        vertical: 15,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                    ),
                                    child: const Text(
                                      'Join',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: CupertinoSlidingSegmentedControl<int>(
                                  padding: const EdgeInsets.all(5),
                                  children: _segments,
                                  onValueChanged: (int? value) {
                                    setState(() {
                                      _currentIndex = value!;
                                    });
                                  },
                                  groupValue: _currentIndex,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 15,
                                top: 20,
                                right: 15,
                                bottom: 10,
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 5,
                                      bottom: 3,
                                    ),
                                    child: Text(
                                      _currentIndex == 0
                                          ? 'Upcoming'
                                          : 'Ongoing',
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Text(
                                      _currentIndex == 0 ? 'Events' : 'Now',
                                      style: const TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ];
                  },
                  body: _currentIndex == 0
                      ? EventCall()
                      : EventCall(
                          ongoing: true,
                        )),
        );
      },
    );
  }

  void jumpToLivePage(
    BuildContext context, {
    required String roomID,
    required bool isHost,
    required String title,
  }) {
    Navigator.push(
      context,
      // ignore: always_specify_types
      MaterialPageRoute(
        builder: (BuildContext context) => CallRoom(
          title: title,
          roomID: roomID,
          isHost: isHost,
        ),
      ),
    );
  }

  void startLive(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        // Calculate the height of the bottom sheet
        final double screenHeight = MediaQuery.of(context).size.height;
        final double halfScreenHeight = screenHeight / 3;
        final String roomID = generateRandomRoomID();
        // Here, you can define the content of your bottom sheet.
        return SizedBox(
          // Add your bottom sheet content here.
          height: halfScreenHeight,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(
                child: Text(
                  '\n\nYour Live Event Will Be Hosted With The following ID \n',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                child: Text(
                  roomID,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () {
                      // Copy the generated room ID to the clipboard
                      final String generatedRoomID = roomID;
                      Clipboard.setData(ClipboardData(text: generatedRoomID));
                      showSnackbar(message: 'Room ID copied to clipboard');
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      String message =
                          'Join My Event On The Business Bosses App With Room ID: $roomID';
                      socialShare(message);
                    },
                    child: SvgPicture.asset(
                      'assets/svgs/share.svg',
                      height: 15.0,
                      width: 15.0,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                child: const Text('Start'),
                onPressed: () {},
              ),
              ElevatedButton(
                child: const Text('Back'),
                onPressed: () {
                  // Handle Option 2 action here.
                  Navigator.pop(context); // Close the bottom sheet.
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void joinLive(BuildContext context, String title) {
    final TextEditingController roomIDController = TextEditingController();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        final double screenHeight = MediaQuery.of(context).size.height;
        final double halfScreenHeight = screenHeight / 3;

        return SizedBox(
          height: halfScreenHeight,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(
                child: Text(
                  '\n\nEnter the Room ID for Your Live Event:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: roomIDController,
                  decoration: const InputDecoration(
                    labelText: 'Room ID',
                  ),
                ),
              ),
              ElevatedButton(
                child: const Text('Join'),
                onPressed: () {
                  final String enteredRoomID = roomIDController.text;
                  jumpToLivePage(
                    context,
                    title: title,
                    roomID: enteredRoomID,
                    isHost: false,
                  );
                },
              ),
              ElevatedButton(
                child: const Text('Back'),
                onPressed: () {
                  // Handle Option 2 action here.
                  Navigator.pop(context); // Close the bottom sheet.
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String generateRandomRoomID() {
    final random = Random();

    // Generate three random letters for the "abc" part.
    final String randomABC = String.fromCharCodes(List.generate(3,
        (_) => random.nextInt(26) + 97)); // ASCII values for lowercase letters.

    // Generate a random integer between 0 and 999 (inclusive).
    final String randomSuffix = random.nextInt(1000).toString().padLeft(3, '0');

    return '$randomABC-$randomSuffix';
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class EventCall extends StatefulWidget {
  EventCall({super.key, this.ongoing = false});
  final bool ongoing;

  @override
  State<EventCall> createState() => _EventCallState();
}

class _EventCallState extends State<EventCall> {
  final LiveController liveEventController = Get.put(LiveController());

  @override
  Widget build(BuildContext context) {
    if (!widget.ongoing) {
      return liveEventController.upcoming.isNotEmpty
          ? Obx(
              () => ListView.builder(
                itemCount: liveEventController.upcoming.length,
                itemBuilder: (BuildContext context, int index) {
                  EventModel event = liveEventController.upcoming[index];
                  return EventItem(
                    event: event,
                  );
                },
              ),
            )
          : const Center(
              child: Text('No Live Event is Upcoming'),
            );
    } else {
      return liveEventController.ongoing.isNotEmpty
          ? Obx(
              () => ListView.builder(
                itemCount: liveEventController.ongoing.length,
                itemBuilder: (BuildContext context, int index) {
                  EventModel event = liveEventController.ongoing[index];
                  return EventItem(
                    event: event,
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

class TabContent extends StatelessWidget {
  final String title;
  final Color color;

  TabContent({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: color,
        alignment: Alignment.center,
        child: Text(
          title,
          style: const TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}
