import 'package:flutter/material.dart';
import 'package:business_bosses_v2/features/live_event/models/events_model.dart';

class AttendeesCountWidget extends StatefulWidget {
  final List<EventModel> events;
  final int currentEventId;

  const AttendeesCountWidget({
    super.key,
    required this.events,
    required this.currentEventId,
  });

  @override
  State<AttendeesCountWidget> createState() => _AttendeesCountWidgetState();
}

class _AttendeesCountWidgetState extends State<AttendeesCountWidget> {
  EventModel? currentEvent;

  @override
  void initState() {
    super.initState();
    _findCurrentEvent();
  }

  void _findCurrentEvent() {
    // Find the current event in events list
    for (EventModel event in widget.events) {
      if (event.id == widget.currentEventId) {
        setState(() {
          currentEvent = event;
        });
        return; // Exit the loop once the event is found
      }
    }
    // If the event is not found, set currentEvent to null
    setState(() {
      currentEvent = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentEvent != null) {
      // Return a Text widget displaying the number of attendees for the current event
      return Text(
        '${currentEvent?.totalAttendees} people are attending',
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      );
    } else {
      // Return a Text widget indicating that the event was not found
      return const Text(
        'Event not found',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: Colors.red, // You can choose a color for the message
        ),
      );
    }
  }
}
