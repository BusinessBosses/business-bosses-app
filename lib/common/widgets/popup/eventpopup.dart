import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/utils/safe_url_launcher.dart';
import 'package:business_bosses_v2/features/live_event/models/events_model.dart';
// import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/theme/theme.dart';

/// Boss Up Challenge Pop Up
class EventPopUp extends StatelessWidget {
  final EventModel event;

  /// Boss Up Challenge Pop Up
  const EventPopUp({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    // String? attendMessage = 'Be the first to attend!';
    // int? attendCount = event.totalAttendees ?? 0;
    // if (attendCount == 1) {
    //   attendMessage = '1 person is attending';
    // } else if (attendCount > 1) {
    //   attendMessage = '$attendCount people are attending';
    // }
    // final ProfileController profileController = Get.find();
    // final DateFormat dateFormat = DateFormat('d MMM, y');
    // final DateFormat timeFormat = DateFormat('h:mm a');
    // final DateTime localStartTime = event.startAt!.toLocal();
    // final DateTime localEndTime = event.endAt!.toLocal();
    // final String formattedDate = dateFormat.format(localStartTime);

    // final String formattedStartTime = timeFormat.format(localStartTime);
    // final String formattedEndTime = timeFormat.format(localEndTime);
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
            Text(
              event.title!,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontSize: 16,
                  ),
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
            Column(
              children: <Widget>[
                const Text('Location Details'),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  event.address != null ? event.address! : 'Online',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        fontSize: 16,
                      ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    OutlinedButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text('Cancel')),
                    const SizedBox(width: 8),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          _launchMapsUrl(event.address!);
                        },
                        child: const Text('Go to Meeting'))
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _launchMapsUrl(String address) async {
    final String query = Uri.encodeComponent(address);
    final Uri? url =
        Uri.tryParse('https://www.google.com/maps/search/?api=1&query=$query');

    if (await canLaunchUrl(url!)) {
      await openUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
