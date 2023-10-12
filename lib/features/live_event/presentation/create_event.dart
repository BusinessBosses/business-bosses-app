import 'dart:math';

import 'package:business_bosses_v2/action/action.dart';
import 'package:business_bosses_v2/features/live_event/models/events_model.dart';
import 'package:business_bosses_v2/features/live_event/presentation/confirm_create_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../common/widgets/buttons/custom_button.dart';
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
    final DateFormat dateFormat = DateFormat('d MMM, y');

    // Format the date
    final String formattedDate = dateFormat.format(startAt);
    // Here, you can define the content of your bottom sheet.
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
          'Create Event',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(
                      244, 244, 244, 1), // Background color
                  borderRadius: BorderRadius.circular(10.0), // Border radius
                  border: Border.all(
                    color:
                        const Color.fromRGBO(224, 224, 224, 1), // Border color
                    width: 1.0, // Border width
                  ),
                ),
                child: TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Add Title',
                    labelStyle: TextStyle(fontWeight: FontWeight.w600),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromRGBO(235, 235, 235, 1),
                    ),
                    borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, right: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              title: Text(
                                // ignore: unnecessary_null_comparison
                                startAt == null
                                    ? 'Select Start and Time'
                                    : 'Starts at:',
                              ),
                              onTap: () => _selectDate(context, true),
                            ),
                          ),
                          TextButton(
                            onPressed: () => _selectDate(context, true),
                            child: Container(
                              padding: const EdgeInsets.all(9),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color:
                                      const Color.fromRGBO(224, 224, 224, 1)),
                              child: Text(
                                formattedDate,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => _selectDate(context, true),
                            child: Container(
                              padding: const EdgeInsets.all(9),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color:
                                      const Color.fromRGBO(224, 224, 224, 1)),
                              child: Text(
                                formatTime(startAt),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              title: Text(
                                // ignore: unnecessary_null_comparison
                                startAt == null
                                    ? 'Select Start and Time'
                                    : 'End at:',
                              ),
                              onTap: () => _selectDate(context, true),
                            ),
                          ),
                          TextButton(
                            onPressed: () => _selectDate(context, false),
                            child: Container(
                              padding: const EdgeInsets.all(9),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color:
                                      const Color.fromRGBO(224, 224, 224, 1)),
                              child: Text(
                                formattedDate,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => _selectDate(context, false),
                            child: Container(
                              padding: const EdgeInsets.all(9),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color:
                                      const Color.fromRGBO(224, 224, 224, 1)),
                              child: Text(
                                formatTime(endAt),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomButton(
                buttonType: ButtonType.elevated,
                onPressed: () async {
                  if (titleController.text.isEmpty) {
                    showSnackBar(
                      context,
                      message: 'Please enter a title',
                    );
                    return;
                  }
                  if (endAt.isBefore(startAt)) {
                    // Show an error message or handle it in a way that's appropriate for your app.
                    showSnackBar(context,
                        message: 'End time cannot be before start time');
                    return;
                  }
                  if (startAt.isBefore(DateTime.now()) ||
                      endAt.isBefore(DateTime.now())) {
                    // Show an error message or handle it as per your app's requirements.
                    showSnackBar(context,
                        message: 'Start time cannot be in the past');
                  }
                  if (endAt.isAfter(startAt.add(const Duration(hours: 2)))) {
                    showSnackBar(context,
                        message: 'Event duration cannot be more than 2 hours');
                    return;
                  }
                  Map<String, dynamic> data = {
                    'title': titleController.text,
                    'roomId': eventID,
                    'startAt': startAt.toString(),
                    'endAt': endAt.toString(),
                    'startTime': '00:00:00'
                  };
                  liveEventController.createEvent(data);
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (BuildContext context) => ConfirmCreateEvent(
                        roomID: roomID,
                      ),
                    ),
                    (route) =>
                        false, // Removes all previous routes from the stack
                  );
                },
                child: const Text('Create Event'),
              ),
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

  String formatTime(DateTime dateTime) {
    final String formattedTime = DateFormat('h:mm a').format(dateTime);
    return formattedTime;
  }

  String generateRandomRoomID() {
    final Random random = Random();

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
