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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                '22nd Jan 2024',
                style: TextStyle(
                    color: textColor.withOpacity(0.4),
                    fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              height: 1,
              color: backgroundcolorinterface,
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                    color: backgroundcolorinterface,
                    borderRadius: BorderRadius.circular(30)),
                child: Text('Course Sale'),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: Text(
                      'What does investment ',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                      maxLines: 2,
                      overflow:
                          TextOverflow.ellipsis, // Optional: Handle overflow
                    ),
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text('+',
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 18)),
                      SvgPicture.asset('assets/svgs/coin.svg'),
                      Text('200',
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 18)),
                      Text('(\$200)',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: textColor.withOpacity(0.4)))
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
                        SizedBox(
                          width: 5,
                        ),
                        Text('data')
                      ]),
                  Text(
                    '2hr ago',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: textColor.withOpacity(0.4),
                        ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ));
  }
}
