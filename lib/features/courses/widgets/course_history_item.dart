// ignore_for_file: always_specify_types

import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CourseHistoryItem extends StatefulWidget {
  final dynamic history;
  const CourseHistoryItem({
    super.key,
    required this.history,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CourseHistoryItemState createState() => _CourseHistoryItemState();
}

class _CourseHistoryItemState extends State<CourseHistoryItem> {
  ProfileController profileController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                formatDate(widget.history['date']),
                style: TextStyle(
                    color: textColor.withValues(alpha: 0.4),
                    fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              height: 1,
              color: backgroundcolorinterface,
            ),
            const SizedBox(
              height: 5,
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 15.0),
            //   child: Container(
            //     padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            //     decoration: BoxDecoration(
            //         color: backgroundcolorinterface,
            //         borderRadius: BorderRadius.circular(30)),
            //     child: const Text('Course Sale'),
            //   ),
            // ),
            // const SizedBox(
            //   height: 5,
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: Text(
                      widget.history['course']['title'],
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 18),
                      maxLines: 2,
                      overflow:
                          TextOverflow.ellipsis, // Optional: Handle overflow
                    ),
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                          widget.history['course']['userId'] ==
                                  profileController.myProfile.uid
                              ? '+'
                              : '-',
                          style: const TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 18)),
                      SvgPicture.asset('assets/svgs/coin.svg'),
                      Text(widget.history['course']['price'],
                          style: const TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 18)),
                      Text(
                          ' (\$${(num.parse(widget.history['course']['price']) / 100).toString()})',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: textColor.withValues(alpha: 0.4)))
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        NetworkImageWithPlaceHolder(
                          imageUrl: profileController.myProfile.photoUrl ?? '',
                          radius: 200,
                          width: 25,
                          height: 25,
                          placeHolder: Icons.person,
                          iconSize: 20.0,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(widget.history['user']['name'] ??
                            widget.history['user']['username'])
                      ]),
                  Text(
                    formatDateTimeToAgo(widget.history['date']),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: textColor.withValues(alpha: 0.4),
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ));
  }

  String formatDateTimeToAgo(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    Duration difference = DateTime.now().difference(dateTime);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} yrs';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} mon';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hrs';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} mins';
    } else {
      return 'just now';
    }
  }

  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  String formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    String day = DateFormat('d').format(dateTime);
    String month = DateFormat('MMM').format(dateTime);
    String year = DateFormat('y').format(dateTime);

    String suffix = _getDaySuffix(int.parse(day));

    return '$day$suffix $month $year';
  }
}
