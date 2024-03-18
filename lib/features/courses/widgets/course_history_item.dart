// ignore_for_file: always_specify_types

import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/features/courses/models/course_model.dart';
import 'package:business_bosses_v2/features/courses/presentation/expanded_course_screen.dart';
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

class CourseHistoryItem extends StatefulWidget {
  const CourseHistoryItem({
    super.key,
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
          children: [
            Text('date'),
            Container(
              height: 1,
              color: backgroundcolorinterface,
            ),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: backgroundcolorinterface,
                  borderRadius: BorderRadius.circular(30)),
              child: Text('Course Sale'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Title'),
                Wrap(
                  children: [
                    Text('+'),
                    SvgPicture.asset('assets/svgs/coin.svg'),
                    Text('200'),
                    Text('(\$200)')
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Wrap(children: [
                  NetworkImageWithPlaceHolder(
                    imageUrl: profileController.myProfile.photoUrl ?? '',
                    radius: radius,
                    placeHolder: Icons.person,
                    iconSize: 22.0,
                    fit: BoxFit.cover,
                  ),
                  Text('data')
                ]),
                Text('2hr ago'),

              ],
            )
          ],
        ));
  }
}
