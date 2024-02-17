// ignore_for_file: public_member_api_docs

import 'dart:convert';

import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/features/live_event/controller/live_event_controller.dart';
import 'package:business_bosses_v2/features/live_event/models/events_model.dart';
import 'package:business_bosses_v2/features/live_event/presentation/attendance_list.dart';
import 'package:business_bosses_v2/features/live_event/presentation/create_event.dart';
import 'package:business_bosses_v2/features/live_event/widgets/call_room.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../action/action.dart';
// import 'package:add_2_calendar/add_2_calendar.dart';

class EventItem extends StatefulWidget {
  final EventModel event;
  final bool ongoing;

  const EventItem({
    Key? key,
    required this.event,
    this.ongoing = false,
  }) : super(key: key);

  @override
  State<EventItem> createState() => _EventItemState();
}

class _EventItemState extends State<EventItem> {
  final ProfileController profileController = Get.find();

  final LiveController liveController = Get.find();

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('d MMM, y');
    final DateFormat timeFormat = DateFormat('h:mm a');

// Convert the event start and end times to the local time zone
    final DateTime localStartTime = widget.event.startAt!.toLocal();
    final DateTime localEndTime = widget.event.endAt!.toLocal();

    final String formattedDate = dateFormat.format(localStartTime);

    final String formattedStartTime = timeFormat.format(localStartTime);
    final String formattedEndTime = timeFormat.format(localEndTime);

    Map<String, dynamic> dataa = <String, dynamic>{
      'id': widget.event.id,
      'title': widget.event.title,
      'roomId': widget.event.roomId,
      'date': formattedDate,
      'starttime': formattedStartTime,
      'host': widget.event.user?.name,
      'photourl': widget.event.user?.photoUrl,
      'startat': widget.event.startAt.toString(),
      'endat': widget.event.endAt.toString(),
      'image': widget.event.image,
    };

    String? jsonData = jsonEncode(dataa);
    int? attendCount = widget.event.totalAttendees ?? 0;
    String? attendMessage = 'Be the first to attend!';
    if (attendCount == 1) {
      attendMessage = '1 person is attending';
    } else if (attendCount > 1) {
      attendMessage = '$attendCount people are attending';
    }
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SpeedDial(
            backgroundColor: backgroundcolorinterface,
            icon: Icons.share,
            buttonSize: const Size(40, 40),
            iconTheme: const IconThemeData(color: Colors.black),
            activeIcon: Icons.close,
            spacing: 3,
            childPadding: const EdgeInsets.all(5),
            spaceBetweenChildren: 4,
            switchLabelPosition: true,
            visible: true,
            direction: SpeedDialDirection.down,
            closeManually: false,
            renderOverlay: true,
            overlayColor: Colors.black,
            overlayOpacity: 0.8,
            useRotationAnimation: true,
            tooltip: 'Open Speed Dial',
            heroTag: 'speed-dial-hero-tag-${widget.event.id}-2',
            elevation: 0.0,
            animationCurve: Curves.elasticInOut,
            isOpenOnStart: false,
            shape: const CircleBorder(),
            children: [
              SpeedDialChild(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SvgPicture.asset(
                    'assets/svgs/text.svg',
                    color: Colors.white,
                  ),
                ),
                backgroundColor: Colors.red,
                label: 'Post on Business Bosses',
                labelStyle: const TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.w700),
                onTap: () => Get.toNamed(
                  Routes.createPost,
                  arguments: <String, String?>{
                    'sharemessage':
                        'Hey there! Join this event on $formattedDate  $formattedStartTime with Room ID: ${widget.event.roomId}',
                    'title': widget.event.title,
                    'livedata': jsonData,
                  },
                ),
              ),
              SpeedDialChild(
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: SvgPicture.asset(
                    'assets/svgs/share.svg',
                    height: 15.0,
                    width: 15.0,
                    // ignore: deprecated_member_use
                    color: textColor.withOpacity(1.0),
                  ),
                ),
                backgroundColor: Colors.white,
                label: 'Share',
                labelStyle: const TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.w700),
                onTap: () {
                  String message =
                      'Hey there! Join this event on $formattedDate  $formattedStartTime with Room ID: ${widget.event.roomId}  https://businessbosses.onelink.me/xLWk/36a2ff16';
                  socialShare(message);
                },
              ),
              SpeedDialChild(
                  child: Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: SvgPicture.asset(
                      'assets/svgs/calendar.svg',
                      color: Colors.black,
                    ),
                  ),
                  backgroundColor: Colors.white,
                  label: 'Save to Calendar',
                  labelStyle: const TextStyle(
                      fontSize: 18.0, fontWeight: FontWeight.w700),
                  onTap: () {
                    // Add2Calendar.addEvent2Cal(Event(
                    //     title: widget.event.title ?? '',
                    //     startDate: localStartTime,
                    //     endDate: localEndTime));
                  }),
            ],
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
                padding: const EdgeInsets.only(left: 15.0, bottom: 7),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                            top: widget.event.user?.uid ==
                                    profileController.myProfile.uid
                                ? 0.0
                                : 15,
                            bottom: widget.event.user?.uid ==
                                    profileController.myProfile.uid
                                ? 0.0
                                : 15,
                          ),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'ID: ${widget.event.roomId!}',
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: Text(
                            attendMessage,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                        if (widget.event.user?.uid ==
                            profileController.myProfile.uid)
                          _buildPopupMenuButton(context),
                      ],
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        widget.event.title!,
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
                          imageUrl: widget.event.user?.photoUrl,
                          height: 20,
                          width: 20,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        if (widget.event.user != null)
                          Text(
                            widget.event.user?.name ??
                                widget.event.user!.username,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: const Color.fromRGBO(224, 224, 224, 1),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
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
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    const Icon(
                                      Icons.access_time,
                                      size: 10,
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Text(
                                      '$formattedStartTime - $formattedEndTime',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        if (widget.ongoing)
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
                                if (widget.event.user?.uid ==
                                    profileController.myProfile.uid) {
                                  jumpToLivePage(
                                    context,
                                    title: widget.event.title!,
                                    roomID: widget.event.roomId!,
                                    isHost: true,
                                    image: widget.event.image,
                                  );
                                } else {
                                  jumpToLivePage(
                                    context,
                                    title: widget.event.title!,
                                    roomID: widget.event.roomId!,
                                    isHost: false,
                                    image: widget.event.image,
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
                        else if (!liveController.joined.any(
                            (EventModel event) => event.id == widget.event.id))
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
                              onPressed: () async {
                                Get.dialog(
                                  AlertDialog(
                                    title: const Text(''),
                                    content: const Text(
                                        'Do you also want to add the event to your calender?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          // Close the dialog
                                          Get.back();
                                        },
                                        child: const Text('No'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          // Add2Calendar.addEvent2Cal(
                                          //   Event(
                                          //       title: widget.event.title ?? '',
                                          //       startDate: localStartTime,
                                          //       endDate: localEndTime),
                                          // );
                                          Get.back();
                                        },
                                        child: const Text('Yes'),
                                      ),
                                    ],
                                  ),
                                );
                                await liveController.attendEvent(widget.event);
                                setState(() {});
                              },
                              child: const Text(
                                'Attend',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )
                        else
                          Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(55, 32),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      12), // Set the border radius
                                ),
                              ),
                              onPressed: () async {
                                Get.to(() => AttendanceList(
                                      eventId: widget.event.id!,
                                    ));
                              },
                              child: const Text(
                                'Attending',
                                style: TextStyle(
                                  fontSize: 10,
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
        if (widget.event.user?.uid == profileController.myProfile.uid)
          const PopupMenuItem<String>(
            value: 'edit',
            child: Text('Edit'),
          ),
        if (widget.event.user?.uid == profileController.myProfile.uid)
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
                event: widget.event,
              ),
            ),
          );
        } else if (value == 'delete') {
          _showDeleteConfirmationDialog(context, widget.event.id!);
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
      {required String roomID,
      required bool isHost,
      required String title,
      String? image}) {
    Navigator.push(
      context,
      // ignore: always_specify_types
      MaterialPageRoute(
        builder: (BuildContext context) => CallRoom(
          roomID: roomID,
          isHost: isHost,
          title: title,
          image: image,
        ),
      ),
    );
  }
}
