// ignore_for_file: public_member_api_docs

import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/features/live_event/controller/live_event_controller.dart';
import 'package:business_bosses_v2/features/live_event/models/events_model.dart';
import 'package:business_bosses_v2/features/live_event/presentation/create_event.dart';
import 'package:business_bosses_v2/features/live_event/widgets/call_room.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EventItem extends StatelessWidget {
  final EventModel event;
  final bool ongoing;
  final ProfileController profileController = Get.find();
  final LiveController liveController = Get.find();

  EventItem({
    Key? key,
    required this.event,
    this.ongoing = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('d MMM, y');
    final DateFormat timeFormat = DateFormat('h:mm a');

// Convert the event start and end times to the local time zone
    final DateTime localStartTime = event.startAt!.toLocal();
    final DateTime localEndTime = event.endAt!.toLocal();

    final String formattedDate = dateFormat.format(localStartTime);
    final String formattedStartTime = timeFormat.format(localStartTime);
    final String formattedEndTime = timeFormat.format(localEndTime);

    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {},
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                color: backgroundcolorinterface,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SvgPicture.asset(
                  'assets/svgs/share.svg',
                  height: 15.0,
                  width: 15.0,
                  // ignore: deprecated_member_use
                  color: textColor.withOpacity(1.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(
                left: 15,
                bottom: 10,
                top: 10,
                right: 15,
              ),
              decoration: const BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                            top: event.user?.uid ==
                                    profileController.myProfile.uid
                                ? 0.0
                                : 15,
                            bottom: event.user?.uid ==
                                    profileController.myProfile.uid
                                ? 0.0
                                : 15,
                          ),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'ID: ${event.roomId!}',
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        if (event.user?.uid == profileController.myProfile.uid)
                          _buildPopupMenuButton(context),
                      ],
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        event.title!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: <Widget>[
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
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
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
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  '$formattedStartTime - $formattedEndTime',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                        if (ongoing)
                          Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: ElevatedButton(
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
                            ),
                          )
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
            ),
          ),
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
      icon: const Icon(
        Icons.more_horiz,
        color: Colors.black54,
        size: 16,
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
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                liveController.deleteEvent(id);
                Navigator.of(context).pop();
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
