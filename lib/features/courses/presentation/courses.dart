import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/features/courses/controller/course_controller.dart';
import 'package:business_bosses_v2/features/courses/models/course_model.dart';
import 'package:business_bosses_v2/features/courses/presentation/create_course.dart';
import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:business_bosses_v2/features/courses/presentation/course_item.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CoursesPage extends StatefulWidget {
  final String industryId;
  const CoursesPage({super.key, required this.industryId});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  final ScrollController scrollController = ScrollController();
  final ProfileController profileController = Get.find();
  late Industry industry;
  final CourseController courseController = Get.put(CourseController());
  String _filtercourses = "";
  List<String> preferenceslist = [
    'All Courses',
    'Free Courses',
    'Paid Courses',
    'Free Course Bundles',
    'Paid Course Bundles',
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Get.arguments == null) {
      Get.back();
    } else {
      industry = Get.arguments;
    }
  }

  @override
  Widget build(BuildContext context) {
    void _refreshScreen() {
      setState(() {
        _filtercourses = "";
      });
    }

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
                            onTap: () {
                              Get.toNamed(Routes.coursehistoryscreen);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.black.withAlpha(20),
                                    borderRadius: BorderRadius.circular(50)),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0, top: 6, bottom: 6),
                                  child: Row(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 35.0,
                                        width: 35.0,
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(1000),
                                            child: NetworkImageWithPlaceHolder(
                                              imageUrl: profileController
                                                      .myProfile.photoUrl ??
                                                  '',
                                              radius: radius,
                                              placeHolder: Icons.person,
                                              iconSize: 22.0,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            'Course History',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          SvgPicture.asset(
                                            'assets/svgs/nexticon.svg',
                                            color: Colors.black,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
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
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          )
        ];
      },
      body: Obx(
        () {
          final filteredCourses = courseController.courses.where((course) {
            if (_filtercourses.isEmpty ||
                (_filtercourses == 'All Courses' &&
                    (course.courseType == 'free' ||
                        course.courseType == 'paid' ||
                        course.youtubeUrls!.length > 1)) ||
                (_filtercourses == 'Free Courses' &&
                    course.courseType == 'free') ||
                (_filtercourses == 'Paid Courses' &&
                    course.courseType == 'paid') ||
                (_filtercourses == 'Free Course Bundles' &&
                    course.courseType == 'free' &&
                    course.youtubeUrls!.length > 1) ||
                (_filtercourses == 'Paid Course Bundles' &&
                    course.courseType == 'paid' &&
                    course.youtubeUrls!.length > 1)) {
              return true;
            } else {
              return false;
            }
          }).toList();

          return Container(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Showing ${filteredCourses.length} Courses'),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Get.toNamed(Routes.promotionscreen);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.black.withAlpha(20),
                                  borderRadius: BorderRadius.circular(50)),
                              child: GestureDetector(
                                child: Wrap(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 6,
                                        right: 6,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {},
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            SvgPicture.asset(
                                              'assets/svgs/coin.svg',
                                              height: 22,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              profileController
                                                  .myProfile.coinscount
                                                  .toString(),
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  backgroundColor: Colors.white,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 40.0, horizontal: 20),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Filter Courses',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Expanded(
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10.0),
                                                  child: Container(
                                                    color:
                                                        backgroundcolorinterface,
                                                    height: 1,
                                                  ),
                                                ),
                                                Container(
                                                  child: Expanded(
                                                    child: ListView.builder(
                                                      itemCount: preferenceslist
                                                          .length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              _filtercourses =
                                                                  preferenceslist[
                                                                          index]
                                                                      .toString();
                                                            });
                                                            Get.back();
                                                          },
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                width: MediaQuery
                                                                        .sizeOf(
                                                                            context)
                                                                    .width,
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        20,
                                                                    vertical:
                                                                        20),
                                                                color: Colors
                                                                    .white,
                                                                child: Text(
                                                                  preferenceslist[
                                                                      index],
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        15),
                                                                child:
                                                                    Container(
                                                                  height: 1,
                                                                  color:
                                                                      backgroundColor,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: Container(
                              height: 38,
                              width: 38,
                              decoration: BoxDecoration(
                                  color: Colors.black.withAlpha(20),
                                  borderRadius: BorderRadius.circular(50)),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: SvgPicture.asset(
                                  'assets/svgs/preferences.svg',
                                  color: Colors.black,
                                  height: 10,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
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
                            final course = filteredCourses[i];
                            return CourseItem(course: course);
                          },
                        ),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
