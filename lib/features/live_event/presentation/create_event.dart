import 'dart:math';

import 'package:business_bosses_v2/action/action.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/features/live_event/models/events_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

import '../controller/live_event_controller.dart';
import '../widgets/call_room.dart';

class CreateEvent extends StatefulWidget {
  final EventModel? event;
  CreateEvent({super.key, this.event});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  TextEditingController titleController = TextEditingController();
  DateTime startAt = DateTime.now();
  DateTime endAt = DateTime.now();
  DateTime selectedDateTime = DateTime.now();
  final LiveController liveEventController = Get.find();
  String? eventID;

  @override
  Widget build(BuildContext context) {
    final String roomID = generateRandomRoomID();
    setState(() {
      eventID = roomID;
    });
    // Here, you can define the content of your bottom sheet.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Event'),
      ),
      body: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Event Title'),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: Text(
                      // ignore: unnecessary_null_comparison
                      startAt == null
                          ? 'Select Start Date'
                          : 'Start Date: ${startAt.toLocal()}',
                    ),
                    onTap: () => _selectDate(context, true),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text(
                      // ignore: unnecessary_null_comparison
                      endAt == null
                          ? 'Select End Date'
                          : 'End Date: ${endAt.toLocal()}',
                    ),
                    onTap: () => _selectDate(context, false),
                  ),
                ),
              ],
            ),
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
              child: const Text('Create'),
              onPressed: () {
                Map<String, dynamic> data = {
                  'title': titleController.text,
                  'roomId': eventID,
                  'startAt': startAt.toString(),
                  'endAt': endAt.toString(),
                  'startTime': '00:00:00'
                };
                liveEventController.createEvent(data);
                Navigator.pop(context);
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
      ),
    );
  }

  void jumpToLivePage(BuildContext context,
      {required String roomID, required bool isHost, required String title}) {
    Navigator.push(
      context,
      // ignore: always_specify_types
      MaterialPageRoute(
        builder: (BuildContext context) => CallRoom(
          roomID: roomID,
          isHost: isHost,
          title: title,
        ),
      ),
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
    titleController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartTime) async {
    DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      onConfirm: (DateTime date) {
        setState(() {
          selectedDateTime = date;
          tz.TZDateTime selectedDateTimeZ = tz.TZDateTime.now(tz.local);
          final String formattedDateTime =
              DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(selectedDateTimeZ);
          print(formattedDateTime);
          if (isStartTime) {
            setState(() {
              startAt = selectedDateTime;
            });
          } else {
            setState(() {
              endAt = selectedDateTime;
            });
          }
        });
      },
      currentTime: DateTime.now(),
    );
  }
}
