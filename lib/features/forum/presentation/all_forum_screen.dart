import 'package:business_bosses_v2/features/courses/controller/course_controller.dart';
import 'package:business_bosses_v2/features/courses/models/course_model.dart';
import 'package:business_bosses_v2/features/courses/presentation/courses.dart';
import 'package:business_bosses_v2/features/forum/controller/forum_controller.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../home/controller/home_controller.dart';
import '../models/industry.dart';
import '../presentation/topics.dart';

import '../../../utils/theme/theme.dart';

class AllForumScreen extends StatefulWidget {
  static const String routeName = 'all-forum-screen';
  const AllForumScreen({super.key });



  @override
  State<AllForumScreen> createState() => _AllForumScreenState();
}

class _AllForumScreenState extends State<AllForumScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late Industry industry;
  final ProfileController _myProfile = Get.find();
  final HomeController homeController = Get.find();
  late ForumController forumController;
  final CourseController courseController = Get.put(CourseController());

  int currentTabIndex = 0; // Track the current tab index
  String _filtercourses = "";

  @override
  void initState() {
    super.initState();
    if (Get.arguments == null) {
      Get.back();
    } else {
      industry = Get.arguments as Industry;
    }
    forumController = Get.put(ForumController());
  }

  void onPreferencesTap(String filterOption) {
    setState(() {
      _filtercourses = filterOption;
      print("Selected Filter Option: $_filtercourses");
    });

  //  CoursesPage.callUpdateFilter(filterOption);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ForumController>(
      builder: (ForumController controller) {
        return Scaffold(
          backgroundColor: backgroundcolorinterface,
          key: scaffoldKey,
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
            ),
            centerTitle: true,
            title: Text(
              industry.industry ?? 'Topic',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
            actions: <Widget>[
              if (currentTabIndex ==
                  1) // Show preferences button only for Courses tab
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Colors.white,
                      context: context,
                      builder: (BuildContext context) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 40.0,
                                horizontal: 20,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Filter Courses',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: preferenceslist.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      onPreferencesTap(preferenceslist[index]);
                                      Get.back();
                                    },
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 20,
                                          ),
                                          color: Colors.white,
                                          child: Text(
                                            preferenceslist[index] + preferencesnumber[index],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const Divider(
                                          height: 1,
                                          color: backgroundColor,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SvgPicture.asset(
                        'assets/svgs/preferences.svg',
                        color: Colors.black,
                        height: 20,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          body: DefaultTabController(
            length: 2,
            child: Column(
              children: <Widget>[
                Container(
                  color: Colors.white,
                  constraints: const BoxConstraints.expand(height: 50),
                  child: TabBar(
                    tabs: <Widget>[
                      Tab(text: 'Topics'),
                      Tab(text: 'Courses'),
                    ],
                    onTap: (int index) {
                      setState(() {
                        currentTabIndex = index; // Update the current tab index
                      });
                    },
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      Container(child: const TopicsPage()),
                      Container(
                        child: CoursesPage(
                          industryId: industry.industryId!, filter: _filtercourses,
                          
                          
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    Get.delete<ForumController>();
    super.dispose();
  }

  List<String> get preferenceslist => <String>[
        'All Courses',
        'Free Courses',
        'Paid Courses',
        'Free Course Bundles',
        'Paid Course Bundles',
      ];

  List<String> get preferencesnumber => <String>[
        ' (${courseController.courses.length})',
        ' (${courseController.courses.where((CourseModel course) => course.courseType == 'free').length})',
        ' (${courseController.courses.where((CourseModel course) => course.courseType == 'paid').length})',
        ' (${courseController.courses.where((CourseModel course) => course.courseType == 'free' && course.youtubeUrls!.length > 1).length})',
        ' (${courseController.courses.where((CourseModel course) => course.courseType == 'paid' && course.youtubeUrls!.length > 1).length})',
      ];
}
