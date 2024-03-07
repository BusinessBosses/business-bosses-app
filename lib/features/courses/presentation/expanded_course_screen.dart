import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/features/courses/models/course_model.dart';
import 'package:business_bosses_v2/features/forum/widgets/downloadable_item.dart';
import 'package:business_bosses_v2/features/posts/widgets/youtube_display.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ExpandedCourseScreen extends StatefulWidget {
  static const String routeName = '/expandedcoursescreen';
  final CourseModel course;

  const ExpandedCourseScreen({Key? key, required this.course})
      : super(key: key);

  @override
  _ExpandedCourseScreenState createState() => _ExpandedCourseScreenState();
}

class _ExpandedCourseScreenState extends State<ExpandedCourseScreen> {
  String? description;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ProfileController profileController = Get.find();
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
          ),
          centerTitle: true,
          title: const Text(
            'Course Title',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
        ),
        body: Stack(children: [
          Column(
            children: [
              YoutubeDisplay(widget.course.youtubeUrls![0]),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(widget.course.title!),
                      ],
                    ),
                    Text(widget.course.description!),
                    Row(
                      children: <Widget>[
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
                          overflow:
                              TextOverflow.ellipsis, // or TextOverflow.ellipsis
                          maxLines: 1,
                          widget.course.user?.name ?? widget.course.user!.name!,
                          style: const TextStyle(fontWeight: FontWeight.w700),
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
                        TextButton.icon(
                          onPressed: () async {},
                          icon: const Icon(Icons.remove_red_eye_outlined,
                              size: 19, color: Colors.black),
                          label: Text(
                            '${widget.course.views.toString()} ${widget.course.views == 1 ? 'View' : 'Views'}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: textColor.withOpacity(0.8),
                                ),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(onPressed: () {}, child: Text('Buy Course')),
                    Text('Downloadable Resources'),
                    Container(
                      height: 200,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (BuildContext context, int index) {
                            return const DownloadableItem(); // Assuming DownloadableItem is a widget class
                          }),
                    )
                  ],
                ),
              )
            ],
          ),
          Positioned(
              bottom: 0,
              child: Column(
                children: [
                  Container(
                    height: 1,
                    width: MediaQuery.of(context).size.width,
                    color: backgroundcolorinterface,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: SvgPicture.asset('assets/svgs/comment.svg'),
                              onPressed: () {},
                            ),
                            Text('Comment')
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: SvgPicture.asset('assets/svgs/comment.svg'),
                              onPressed: () {},
                            ),
                            Text('Rate')
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: SvgPicture.asset('assets/svgs/comment.svg'),
                              onPressed: () {},
                            ),
                            Text('Share')
                          ],
                        ),
                      ]),
                ],
              ))
        ]));
  }
}
