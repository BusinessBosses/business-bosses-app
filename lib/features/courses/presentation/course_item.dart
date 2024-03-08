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

class CourseItem extends StatefulWidget {
  final CourseModel course;
  const CourseItem({super.key, required this.course});

  @override
  // ignore: library_private_types_in_public_api
  _CourseItemState createState() => _CourseItemState();
}

class _CourseItemState extends State<CourseItem> {
  ProfileController profileController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(children: [
                  SizedBox(
                    height: 90,
                    width: 160,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: Stack(
                          children: <Widget>[
                            GestureDetector(
                                onTap: () {},
                                child: YoutubeDisplay(
                                    widget.course.youtubeUrls![0])),
                            Positioned(
                              top: 0,
                              bottom: 0,
                              right: 0,
                              left: 0,
                              child: GestureDetector(
                                onTap: () {},
                                child: Icon(
                                  Icons.play_circle_outlined,
                                  color: Colors.black.withOpacity(0.5),
                                  size: 70,
                                ),
                              ),
                            ),
                            Positioned(
                                bottom: 12,
                                right: 12,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.black.withAlpha(150),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/svgs/coursebundle.svg',
                                          height: 20,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          '${widget.course.youtubeUrls!.length.toString()} ${widget.course.youtubeUrls!.length > 1 ? 'Videos' : 'Video'}',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => ExpandedCourseScreen(course: widget.course));
                    },
                    child: Container(
                      height: 90,
                      width: 160,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(12.0)),
                    ),
                  )
                ]),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        overflow:
                            TextOverflow.ellipsis, // or TextOverflow.ellipsis
                        maxLines: 2,
                        widget.course.title!,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        overflow:
                            TextOverflow.ellipsis, // or TextOverflow.ellipsis
                        maxLines: 2,
                        widget.course.description!,
                        style: const TextStyle(color: Colors.black45),
                      ),
                      Row(
                        children: [
                          const Text('by'),
                          const SizedBox(
                            width: 5,
                          ),
                          SizedBox(
                            height: 20.0,
                            width: 20.0,
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(1000),
                                child: NetworkImageWithPlaceHolder(
                                  imageUrl: widget.course.user?.photoUrl ?? '',
                                  radius: radius,
                                  placeHolder: Icons.person,
                                  iconSize: 15.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            overflow: TextOverflow
                                .ellipsis, // or TextOverflow.ellipsis
                            maxLines: 1,
                            widget.course.user?.name ??
                                widget.course.user!.name!,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.more_horiz,
                  size: 20,
                  color: Colors.black,
                  weight: 100,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: backgroundcolorinterface,
                      borderRadius: BorderRadius.circular(50)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8, top: 5, right: 8, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SvgPicture.asset(
                          'assets/svgs/coin.svg',
                          height: 22,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          widget.course.courseType == 'free'
                              ? 'free'
                              : widget.course.price!,
                          style: const TextStyle(
                            color: Color.fromRGBO(133, 133, 133, 1),
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Icon(
                  Icons.star,
                  color: Color.fromRGBO(255, 202, 40, 1),
                  size: 16,
                ),
                Text(
                  widget.course.averageRating.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.course.transcript != null)
                      SvgPicture.asset(
                        'assets/svgs/transcript.svg',
                        height: 16,
                      ),
                    const SizedBox(
                      width: 10,
                    ),
                    if (widget.course.documents != null)
                      Stack(children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 15.0, top: 5, bottom: 5),
                          child: SvgPicture.asset(
                            'assets/svgs/downloadables.svg',
                            height: 16,
                          ),
                        ),
                        Positioned(
                          right: 5,
                          top: 0,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(50)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6.0),
                              child: Text(
                                widget.course.documents!.length.toString(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        )
                      ]),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: TextButton.icon(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    'assets/svgs/comment.svg',
                    height: 15,
                  ),
                  label: Text(
                    '${widget.course.comments?.length} ${widget.course.comments!.length == 1 ? 'Comment' : 'Comments'}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: textColor.withOpacity(0.8),
                        ),
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () async {},
                icon: const Icon(Icons.remove_red_eye_outlined,
                    size: 19, color: Colors.black),
                label: Text(
                  '${widget.course.views.toString()} ${widget.course.views == 1 ? 'View' : 'Views'}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: textColor.withOpacity(0.8),
                      ),
                ),
              ),
              const SizedBox(width: 8.0),
              GestureDetector(
                onTap: () => {},
                child: SvgPicture.asset(
                  'assets/svgs/share.svg',
                  height: 15.0,
                  width: 15.0,
                  color: textColor.withOpacity(1.0),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Text(
                  TimeFormat.formatString(widget.course.timestamp),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: textColor.withOpacity(0.4)),
                ),
              )
            ],
          ),
          Container(
            color: backgroundcolorinterface,
            height: 7,
          )
        ],
      ),
    );
  }
}
