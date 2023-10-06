// ignore_for_file: public_member_api_docs

import 'dart:math';

import 'package:business_bosses_v2/action/action.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/features/live_event/controller/live_event_controller.dart';
import 'package:business_bosses_v2/features/live_event/models/events_model.dart';
import 'package:business_bosses_v2/features/live_event/widgets/call_room.dart';
import 'package:business_bosses_v2/features/live_event/widgets/event_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class LiveEvent extends StatefulWidget {
  const LiveEvent({super.key});

  @override
  State<LiveEvent> createState() => _LiveEventState();
}

class _LiveEventState extends State<LiveEvent> {
  final LiveController liveEventController = Get.put(LiveController());

  @override
  void initState() {
    super.initState();
  }

  DateTime selectedDateTime = DateTime.now();

  // void _showDateTimePicker() {
  //   DatePicker.showDateTimePicker(
  //     context,
  //     showTitleActions: true,
  //     onChanged: (DateTime date) {
  //       setState(() {
  //         selectedDateTime = date;
  //       });
  //     },
  //     currentTime: selectedDateTime,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(title: const Text('Live Event')),
          body: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () => startLive(context),
                    child: const Text('Create Event'),
                  ),
                  ElevatedButton(
                    onPressed: () => joinLive(context),
                    child: const Text('Join'),
                  ),
                  // ElevatedButton(
                  //   onPressed: () => _showDateTimePicker(),
                  //   child: const Text('Date'),
                  // ),
                ],
              ),
              const Text(
                'Upcoming Events',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 21),
                textAlign: TextAlign.left,
              ),
              const SizedBox(
                height: 10,
              ),
              Obx(
                () => Expanded(
                  child: ListView.builder(
                    itemCount: liveEventController.events.length,
                    itemBuilder: (BuildContext context, int index) {
                      EventModel event = liveEventController.events[index];
                      return EventItem(
                        event: event,
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void jumpToLivePage(BuildContext context,
      {required String roomID, required bool isHost}) {
    Navigator.push(
      context,
      // ignore: always_specify_types
      MaterialPageRoute(
        builder: (BuildContext context) => CallRoom(
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
                onPressed: () {
                  jumpToLivePage(
                    context,
                    roomID: roomID,
                    isHost: true,
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

  void joinLive(BuildContext context) {
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
