// ignore_for_file: constant_identifier_names

import 'package:intl/intl.dart';

class TimeFormat {
  static const num ONE_SECOND = 1000;
  static const num ONE_MINUTE = 60000;
  static const num ONE_HOUR = 3600000;
  static const num ONE_DAY = 86400000;
  static const num ONE_WEEK = 604800000;
  static const num ONE_MONTH = 1000 * 60 * 60 * 24 * 30;

  static const String MANY_SECONDS_AGO = 'secs ago';
  static const String MANY_MINUTES_AGO = 'mins ago';
  static const String MANY_HOURS_AGO = 'hr ago';
  static const String MANY_DAYS_AGO = 'd ago';
  static const String MANY_MONTHS_AGO = 'mon ago';
  static const String MANY_YEARS_AGO = 'yr ago';

  static const String ONE_SECOND_AGO = 'sec ago';
  static const String ONE_MINUTE_AGO = 'min ago';
  static const String ONE_HOUR_AGO = 'hr ago';
  static const String ONE_DAY_AGO = 'd ago';
  static const String ONE_MONTH_AGO = 'mon ago';
  static const String ONE_YEAR_AGO = 'yr ago';

  //Time conversion
  static String formatString(int? timestamp) {
    num delta = DateTime.now().millisecondsSinceEpoch - timestamp!;
    if (delta < 1 * ONE_SECOND) {
      num seconds = toSeconds(delta);
      return '${(seconds < 1 ? 1 : seconds).toInt()}$MANY_SECONDS_AGO';
    }
    if (delta < 1 * ONE_MINUTE) {
      num seconds = toSeconds(delta);
      String secondsLabel =
          seconds.toInt() == 1 ? ONE_SECOND_AGO : MANY_SECONDS_AGO;
      return '${(seconds <= 0 ? 1 : seconds).toInt()}$secondsLabel';
    }
    if (delta < 45 * ONE_MINUTE) {
      num minutes = toMinutes(delta);
      String minutesLabel =
          minutes.toInt() == 1 ? ONE_MINUTE_AGO : MANY_MINUTES_AGO;
      return '${(minutes <= 0 ? 1 : minutes).toInt()}$minutesLabel';
    }
    if (delta < 24 * ONE_HOUR) {
      num hours = toHours(delta);
      String hoursLabel = hours.toInt() == 1 ? ONE_HOUR_AGO : MANY_HOURS_AGO;
      return '${(hours <= 0 ? 1 : hours).toInt()}$hoursLabel';
    }
    if (delta < 48 * ONE_HOUR) {
      return 'yesterday';
    }
    if (delta < 30 * ONE_DAY) {
      num days = toDays(delta);
      String daysLabel = days.toInt() == 1 ? ONE_DAY_AGO : MANY_DAYS_AGO;
      return '${(days <= 0 ? 1 : days).toInt()}$daysLabel';
    }
    if (delta < 12 * 4 * ONE_WEEK) {
      num months = toMonths(delta);
      String monthLabel = months.toInt() == 1 ? ONE_MONTH_AGO : MANY_MONTHS_AGO;
      return '${(months <= 0 ? 1 : months).toInt()}$monthLabel';
    } else {
      String formatDate(DateTime timestamp) {
        DateFormat formatter = DateFormat('d MMM, yyyy');
        String formattedDate = formatter.format(timestamp);
        return formattedDate;
      }

// Example usage:
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      String formattedDate = formatDate(dateTime);
      return (formattedDate);
    }
  }

  static String toDayFormat(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('dd MMM yy').format(dateTime);
  }

  static num toSeconds(num date) {
    return date / 1000;
  }

  static num toMinutes(num date) {
    return toSeconds(date) / 60;
  }

  static num toHours(num date) {
    return toMinutes(date) / 60;
  }

  static num toDays(num date) {
    return toHours(date) / 24;
  }

  static num toMonths(num date) {
    return toDays(date) / 30;
  }

  static num toYears(num date) {
    return toMonths(date) / 365;
  }

  // String messageTime(int timestamp) {
  //   int now = DateTime.now().millisecondsSinceEpoch;
  //
  //   Duration day = Duration(days: now - timestamp);
  // }
}
