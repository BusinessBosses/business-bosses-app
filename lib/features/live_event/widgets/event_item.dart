// ignore_for_file: public_member_api_docs

import 'package:business_bosses_v2/features/live_event/models/events_model.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart';

class EventItem extends StatelessWidget {
  final EventModel event;

  const EventItem({
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
          Text(
            event.title!,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
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
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  String formatTime(DateTime dateTime) {
    final String formattedTime = DateFormat('h:mm a').format(dateTime);
    return formattedTime;
  }
}
