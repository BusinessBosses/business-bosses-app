// ignore_for_file: constant_identifier_names

import 'package:intl/intl.dart';

class TimeFormat {
  static const num ONE_MINUTE = 60000;
  static const num ONE_HOUR = 3600000;
  static const num ONE_DAY = 86400000;
  static const num ONE_WEEK = 604800000;
  static const num ONE_MONTH = 1000 * 60 * 60 * 24 * 30;

  static const ONE_SECOND_AGO = "sec before";
  static const ONE_MINUTE_AGO = "min ago";
  static const ONE_HOUR_AGO = "hours ago";
  static const ONE_DAY_AGO = "days ago";
  static const ONE_MONTH_AGO = "months before";
  static const ONE_YEAR_AGO = "years ago";

  //Time conversion
  static String formatString(int timestamp) {
    num delta = DateTime.now().millisecondsSinceEpoch - timestamp;
    if (delta < 1 * ONE_MINUTE) {
      num seconds = toSeconds(delta);
      return (seconds <= 0 ? 1 : seconds).toInt().toString() +
          ' ' +
          ONE_SECOND_AGO;
    }
    if (delta < 45 * ONE_MINUTE) {
      num minutes = toMinutes(delta);
      return (minutes <= 0 ? 1 : minutes).toInt().toString() +
          ' ' +
          ONE_MINUTE_AGO;
    }
    if (delta < 24 * ONE_HOUR) {
      num hours = toHours(delta);
      return (hours <= 0 ? 1 : hours).toInt().toString() + ' ' + ONE_HOUR_AGO;
    }
    if (delta < 48 * ONE_HOUR) {
      return "yesterday";
    }
    if (delta < 30 * ONE_DAY) {
      num days = toDays(delta);
      return (days <= 0 ? 1 : days).toInt().toString() + ' ' + ONE_DAY_AGO;
    }
    if (delta < 12 * 4 * ONE_WEEK) {
      num months = toMonths(delta);
      return (months <= 0 ? 1 : months).toInt().toString() +
          ' ' +
          ONE_MONTH_AGO;
    } else {
      String formatDate(DateTime timestamp) {
        DateFormat formatter = DateFormat('d MMMM, yyyy');
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
