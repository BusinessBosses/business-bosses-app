import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/features/live_event/models/events_model.dart';
import 'package:business_bosses_v2/features/live_event/widgets/attendeesitem.dart';
import 'package:business_bosses_v2/features/posts/widgets/images_viewer_screen.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../utils/size_config.dart';
import '../../../utils/theme/theme.dart';

/// Boss Up Challenge Pop Up
class EventPopUp extends StatelessWidget {
  final EventModel event;
  final bool isfirstattend;

  /// Boss Up Challenge Pop Up
  const EventPopUp({Key? key, required this.event, required this.isfirstattend})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? attendMessage = 'Be the first to attend!';
    int? attendCount = event.totalAttendees ?? 0;
    if (attendCount == 1) {
      attendMessage = '1 person is attending';
    } else if (attendCount > 1) {
      attendMessage = '$attendCount people are attending';
    }
    final ProfileController profileController = Get.find();
    final DateFormat dateFormat = DateFormat('d MMM, y');
    final DateFormat timeFormat = DateFormat('h:mm a');
    final DateTime localStartTime = event.startAt!.toLocal();
    final DateTime localEndTime = event.endAt!.toLocal();
    final String formattedDate = dateFormat.format(localStartTime);

    final String formattedStartTime = timeFormat.format(localStartTime);
    final String formattedEndTime = timeFormat.format(localEndTime);
    return Dialog(
      backgroundColor: backgroundColor,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      insetPadding: const EdgeInsets.all(10),
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    top: event.user?.uid == profileController.myProfile.uid
                        ? 0.0
                        : 15,
                    bottom: event.user?.uid == profileController.myProfile.uid
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
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) => AttendeesItem(
                              event: event,
                            ));
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(6)),
                    child: Text(
                      attendMessage,
                      style: const TextStyle(fontSize: 13, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            if (event.image != null)
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => ImagesViewerScreen(
                        urls: [event.image],
                        text: event.title,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 0, right: 0),
                  child: NetworkImageWithPlaceHolder(
                    borderColor: Colors.black12,
                    imageUrl: event.image,
                    width: double.infinity,
                    height: 240.0,
                    fit: BoxFit.cover,
                    placeHolder: Icons.photo,
                    iconSize: 50.0,
                  ),
                ),
              ),
            const SizedBox(
              height: 20,
            ),
            Text(
              event.title!,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontSize: 16,
                  ),
            ),
            if (event.description != null)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: Text(
                        event.description ?? '',
                        style: bodyText2,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Host:'),
                const SizedBox(
                  width: 4,
                ),
                NetworkImageWithPlaceHolder(
                  imageUrl: event.user?.photoUrl,
                  height: 20,
                  width: 20,
                ),
                const SizedBox(
                  width: 4,
                ),
                if (event.user != null)
                  Text(
                    event.user?.name ?? event.user!.username,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color.fromRGBO(224, 224, 224, 1),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
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
                  Row(
                    children: <Widget>[
                      Icon(
                        event.link != null ? Icons.language : Icons.location_on,
                        size: 10,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Wrap(
                        children: [
                          Text(
                            event.link != null
                                ? 'Online Event'
                                : 'In-Person Event',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          event.address != null
                              ? Text(
                                  '-  ${event.address ?? ''}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isfirstattend == true)
              const SizedBox(
                height: 20,
              ),
            if (isfirstattend == true)
              Column(
                children: [
                  const Text(
                      'Do you also want to add the event to your calender?'),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text('No')),
                      const SizedBox(width: 8),
                      ElevatedButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text('Yes'))
                    ],
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
