// ignore_for_file: public_member_api_docs

import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/features/live_event/controller/live_event_controller.dart';
import 'package:business_bosses_v2/features/live_event/models/events_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../utils/theme/theme.dart';
import '../../profile/controller/profile_controller.dart';
import '../presentation/create_event.dart';
import 'call_room.dart';
import 'custom_icon_button.dart';

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
    final DateFormat dateFormat = DateFormat('d MMM, y');

    // Format the date
    final String formattedDate = dateFormat.format(event.startAt!);
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconButton(
              onTap: () {},
              height: 42,
              width: 42,
              margin: const EdgeInsets.symmetric(vertical: 44),
              padding: const EdgeInsets.all(10),
              child: SvgPicture.asset(
                'assets/svgs/share.svg',
                height: 15.0,
                width: 15.0,
                color: textColor.withOpacity(1.0),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 17, bottom: 16, right: 30),
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(244, 244, 244, 1),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'ID: ${event.roomId!}',
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        if (event.user?.uid == profileController.myProfile.uid)
                          _buildPopupMenuButton(context),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        event.title!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text('Host:'),
                        const SizedBox(
                          width: 4,
                        ),
                        NetworkImageWithPlaceHolder(
                          imageUrl: event.user?.photoUrl,
                          height: 16,
                          width: 16,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          event.user?.name ?? event.user!.username,
                          style: const TextStyle(
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Expanded(
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: const Color.fromRGBO(224, 224, 224, 1),
                              ),
                              child: Row(
                                children: <Widget>[
                                  const Icon(
                                    Icons.calendar_month,
                                    size: 10,
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    formattedDate.toString(),
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  Text(
                                    '${formatTime(event.startAt!)} - ${formatTime(event.endAt!)}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.red,
                                minimumSize: const Size(55, 32),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      12), // Set the border radius
                                ),
                              ),
                              onPressed: () {
                                if (event.user?.uid ==
                                    profileController.myProfile.uid) {
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
                              },
                              child: const Text(
                                'Join',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatTime(DateTime dateTime) {
    final String formattedTime = DateFormat('h:mm a').format(dateTime);
    return formattedTime;
  }

  Widget _buildPopupMenuButton(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(
        Icons.more_horiz,
        color: Colors.black54,
        size: 14,
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
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
        if (value == 'edit') {
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
