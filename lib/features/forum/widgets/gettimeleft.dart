import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:flutter/material.dart';

Widget getChallengeTimeLeft(Industry category) {
  DateTime now = DateTime.now();
  bool hasNotStarted =
      category.startAt != null && now.isBefore(category.startAt!);

  return SizedBox(
    width: 142,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
          decoration: BoxDecoration(
            color: hasNotStarted
                ? Colors.grey.withAlpha(40)
                : Colors.green.withAlpha(40),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            hasNotStarted
                ? _calculateTimeLeftToStart(category.startAt!)
                : category.endedAt != null
                    ? _calculateTimeLeft(category.endedAt!)
                    : 'Ongoing',
            style: TextStyle(
              color: hasNotStarted ? Colors.black54 : Colors.green,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    ),
  );
}

String _calculateTimeLeftToStart(DateTime startTime) {
  DateTime now = DateTime.now();
  Duration difference = startTime.difference(now);

  if (difference.inDays > 0) {
    return "Starts ${difference.inDays} day${difference.inDays > 1 ? 's' : ''}";
  } else {
    return 'Starts 1 day';
  }
}

// String _calculateEndsDate(DateTime endedAt) {
//   // Format the endedAt date using DateFormat
//   String formattedDate = DateFormat('d MMM').format(endedAt);
//   return 'Ends $formattedDate';
// }

// String _calculateStartDate(DateTime startAt) {
//   // Format the endedAt date using DateFormat
//   String formattedDate = DateFormat('d MMM').format(startAt);
//   return 'Starts $formattedDate';
// }

String _calculateTimeLeft(DateTime endTime) {
  DateTime now = DateTime.now();
  Duration difference = endTime.difference(now);

  if (difference.isNegative) {
    return "Time's up"; // Or handle accordingly if time is already passed
  } else if (difference.inDays > 0) {
    return "Ends ${difference.inDays} day${difference.inDays > 1 ? 's' : ''}";
  } else {
    return '1 day left';
  }
}
