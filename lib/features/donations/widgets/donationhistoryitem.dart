// ignore_for_file: always_specify_types

import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DonationHistoryItem extends StatefulWidget {
  final dynamic item;
  final String? previousDate;
  const DonationHistoryItem({
    super.key,
    this.item,
     this.previousDate,
  });

  @override
  // ignore: library_private_types_in_public_api
  _DonationHistoryItemState createState() => _DonationHistoryItemState();
}

class _DonationHistoryItemState extends State<DonationHistoryItem> {
  ProfileController profileController = Get.find();
  @override
  Widget build(BuildContext context) {
    String dateTimeString = widget.item['date'];
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 5,
          ),
          Visibility(
            visible: widget.previousDate != formatDate(dateTimeString),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                formatDate(dateTimeString),
                style: TextStyle(
                    color: textColor.withOpacity(0.4),
                    fontWeight: FontWeight.w700),
              ),
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
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: widget.item['user']['uid'] ==
                                  profileController.myProfile.uid
                              ? SvgPicture.asset(
                                  'assets/svgs/upicon.svg',
                                  color: Colors.red,
                                )
                              : SvgPicture.asset(
                                  'assets/svgs/downicon.svg',
                                  color: Colors.green,
                                ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.item['donation']['title'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 18),
                                maxLines: 2,
                                overflow: TextOverflow
                                    .ellipsis, // Optional: Handle overflow
                              ),
                              Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    NetworkImageWithPlaceHolder(
                                      imageUrl:
                                          widget.item['user']['photoUrl'] ?? '',
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
                                    Text(widget.item['user']['name'] ??
                                        widget.item['user']['username'])
                                  ]),
                            ],
                          ),
                        ),
                      ]),
                ),
                const SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(widget.item['type'] == 'donated' ? '-' : '+',
                            style: const TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 18)),
                        SvgPicture.asset('assets/svgs/coin.svg'),
                        Text(widget.item['amount'],
                            style: const TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 18)),
                        Text('(\$${double.parse(widget.item['amount']) / 100})',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: textColor.withOpacity(0.4)))
                      ],
                    ),
                    Text(
                      formatDateTimeToAgo(dateTimeString),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: textColor.withOpacity(0.4),
                          ),
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

String formatDateTimeToAgo(String dateTimeString) {
  DateTime dateTime = DateTime.parse(dateTimeString);
  Duration difference = DateTime.now().difference(dateTime);

  if (difference.inDays > 365) {
    return '${(difference.inDays / 365).floor()} yrs ago';
  } else if (difference.inDays > 30) {
    return '${(difference.inDays / 30).floor()} mon ago';
  } else if (difference.inDays > 0) {
    return '${difference.inDays} d ago';
  } else if (difference.inHours > 0) {
    return '${difference.inHours} hrs ago';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes} mins ago';
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
