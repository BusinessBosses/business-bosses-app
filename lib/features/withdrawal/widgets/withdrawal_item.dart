// ignore_for_file: always_specify_types

import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/features/courses/models/course_model.dart';
import 'package:business_bosses_v2/features/courses/presentation/expanded_course_screen.dart';
import 'package:business_bosses_v2/features/donations/widgets/donationhistoryitem.dart';
import 'package:business_bosses_v2/features/posts/widgets/youtube_display.dart';
import 'package:business_bosses_v2/features/posts/widgets/yt_player.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:business_bosses_v2/utils/time_format.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class WithdrawalItem extends StatefulWidget {
  final dynamic item;
  const WithdrawalItem({super.key, this.item});

  @override
  // ignore: library_private_types_in_public_api
  _WithdrawalItemState createState() => _WithdrawalItemState();
}

class _WithdrawalItemState extends State<WithdrawalItem> {
  @override
  Widget build(BuildContext context) {
    String dateTimeString = widget.item['date'];
    return Container(
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                        Text(
                          widget.item['amount'],
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          '(\$${(num.parse(widget.item['amount']) / 100).toStringAsFixed(0)})',
                          style: const TextStyle(color: Colors.black26),
                        ),
                      ]),
                      Text(formatDateTimeToAgo(dateTimeString)),
                    ],
                  ),
                  Text(
                    widget.item['status'],
                    style: widget.item['status'] == 'Pending'
                        ? const TextStyle(color: Colors.grey)
                        : const TextStyle(color: Colors.greenAccent),
                  ),
                ]),
          ),
          Container(
            color: backgroundcolorinterface,
            height: 1,
          )
        ],
      ),
    );
  }
}
