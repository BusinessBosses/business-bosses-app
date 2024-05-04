import 'package:business_bosses_v2/features/courses/controller/course_controller.dart';
import 'package:business_bosses_v2/features/courses/models/course_model.dart';
import 'package:business_bosses_v2/features/courses/presentation/create_course.dart';
import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:business_bosses_v2/features/courses/presentation/course_item.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CoursesPage extends StatefulWidget {
  final String industryId;
  final String filter;

  const CoursesPage({
    super.key,
    required this.industryId,
    required this.filter,
  });

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  final ScrollController scrollController = ScrollController();
  final ProfileController profileController = Get.find();
  late Industry industry;
  final CourseController courseController = Get.put(CourseController());

  List<String> preferenceslist = <String>[
    'All Courses',
    'Free Courses',
    'Paid Courses',
    'Free Course Bundles',
    'Paid Course Bundles',
  ];

  @override
  void initState() {
    super.initState();
    if (Get.arguments == null) {
      Get.back();
    } else {
      industry = Get.arguments;
    }
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      controller: scrollController,
      headerSliverBuilder: (
        BuildContext context,
        bool innerBoxIsScrolled,
      ) {
        return <Widget>[
          SliverStickyHeader(
            sticky: false,
            header: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  color: Colors.transparent,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Row(
                                children: <Widget>[
                                  const Text(
                                    'Info',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  SvgPicture.asset(
                                    'assets/svgs/info.svg',
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(150, 45)),
                                  onPressed: () {
                                    Get.to(() => CreateCourseScreen(
                                        industryId: widget.industryId));
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      const Text(
                                        'Start a Course',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      SvgPicture.asset(
                                          'assets/svgs/startatopic.svg')
                                    ],
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ];
      },
      body: Obx(
        () {
          final List<CourseModel> filteredCourses =
              courseController.courses.where((CourseModel course) {
            if (widget.filter.isEmpty ||
                (widget.filter == 'All Courses' &&
                    (course.courseType == 'free' ||
                        course.courseType == 'paid' ||
                        course.youtubeUrls!.length > 1)) ||
                (widget.filter == 'Free Courses' &&
                    course.courseType == 'free') ||
                (widget.filter == 'Paid Courses' &&
                    course.courseType == 'paid') ||
                (widget.filter == 'Free Course Bundles' &&
                    course.courseType == 'free' &&
                    course.youtubeUrls!.length > 1) ||
                (widget.filter == 'Paid Course Bundles' &&
                    course.courseType == 'paid' &&
                    course.youtubeUrls!.length > 1)) {
              return true;
            } else {
              return false;
            }
          }).toList();

          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    right: 15, left: 15, bottom: 10, top: 10),
                child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 20,
                          blurRadius: 500,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.promotionscreen);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Container(
                              width: 142,
                              padding: const EdgeInsets.symmetric(vertical: 1),
                              decoration: BoxDecoration(
                                  color: backgroundColor,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: <Widget>[
                                  const Text('Balance: '),
                                  SvgPicture.asset('assets/svgs/coin.svg'),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  Text(
                                    '${profileController.myProfile.coinscount!}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: subtextColor),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.coursehistoryscreen);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 10.0,
                            ),
                            child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: <Widget>[
                                  const Text(
                                    'Course History ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  SvgPicture.asset(
                                    'assets/svgs/nexticon.svg',
                                    // ignore: deprecated_member_use
                                    color: textColor,
                                  ),
                                ]),
                          ),
                        )
                      ],
                    )),
              ),
              Container(
                color: backgroundColor,
                height: 1,
              ),
              filteredCourses.isEmpty
                  ? Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white,
                        child: courseController.loading.value
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : const Center(child: Text('No Courses found')),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: filteredCourses.length,
                        itemBuilder: (BuildContext context, int i) {
                          final CourseModel course = filteredCourses[i];
                          return CourseItem(course: course);
                        },
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }
}
