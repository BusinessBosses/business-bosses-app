// ignore_for_file: public_member_api_docs

import 'package:business_bosses_v2/features/live_event/controller/live_event_controller.dart';
import 'package:business_bosses_v2/features/live_event/models/events_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../profile/controller/profile_controller.dart';
import '../presentation/create_event.dart';
import 'call_room.dart';

class EventItem extends StatelessWidget {
  final EventModel event;
  final ProfileController profileController = Get.find();
  final LiveController liveController = Get.find();

  EventItem({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    // Define a custom date format
    final DateFormat dateFormat = DateFormat('d MMMM, y');

    // Format the date
    final String formattedDate = dateFormat.format(event.startAt!);
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(19),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                event.title!,
                style:
                    const TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
              ),
              _buildPopupMenuButton(context), // Three dots menu
            ],
          ),
          Text(
            'Event ID: ${event.roomId!}',
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          ),
          Text(formattedDate),
          Row(
            children: <Widget>[
              Text(
                  '${formatTime(event.startAt!)} - ${formatTime(event.endAt!)}')
            ],
          ),
          Text('Host: ${event.user?.name ?? event.user?.username}'),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  String formatTime(DateTime dateTime) {
    final String formattedTime = DateFormat('h:mm a').format(dateTime);
    return formattedTime;
  }

  Widget _buildPopupMenuButton(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'join',
          child: Text('Join'),
        ),
        if (event.user?.uid == profileController.myProfile.uid)
          const PopupMenuItem<String>(
            value: 'edit',
            child: Text('Edit'),
          ),
        if (event.user?.uid == profileController.myProfile.uid)
          const PopupMenuItem<String>(
            value: 'delete',
            child: Text('Delete'),
          ),
      ],
      onSelected: (String value) {
        if (value == 'join') {
          // Handle edit action here
          // You can navigate to an edit screen or perform any other action
          if (event.user?.uid == profileController.myProfile.uid) {
            jumpToLivePage(
              context,
              title: event.title!,
              roomID: event.roomId!,
              isHost: true,
            );
          } else {
            jumpToLivePage(
              context,
              title: event.title!,
              roomID: event.roomId!,
              isHost: false,
            );
          }
        } else if (value == 'edit') {
          // Handle edit action here
          // You can navigate to an edit screen or perform any other action
          Navigator.push(
            context,
            // ignore: always_specify_types
            MaterialPageRoute(
              builder: (BuildContext context) => CreateEvent(
                event: event,
              ),
            ),
          );
        } else if (value == 'delete') {
          // Handle delete action here
          // You can show a confirmation dialog and delete the event if confirmed
          _showDeleteConfirmationDialog(context, event.id!);
        }
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Event'),
          content: const Text('Are you sure you want to delete this event?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Perform the delete action here
                // You can delete the event and update your data
                liveController.deleteEvent(id);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
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
}
