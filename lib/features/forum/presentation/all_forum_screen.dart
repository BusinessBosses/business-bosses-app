// ignore_for_file: deprecated_member_use

import 'package:business_bosses_v2/features/courses/controller/course_controller.dart';
import 'package:business_bosses_v2/features/courses/models/course_model.dart';
import 'package:business_bosses_v2/features/courses/presentation/courses.dart';
import 'package:business_bosses_v2/features/courses/widgets/filtercoursesposts.dart';
import 'package:business_bosses_v2/features/courses/widgets/filtercoursesusers.dart';
import 'package:business_bosses_v2/features/forum/controller/bossup_controller.dart';
import 'package:business_bosses_v2/features/forum/controller/forum_controller.dart';
import 'package:business_bosses_v2/features/forum/presentation/filterchallengeposts.dart';
import 'package:business_bosses_v2/features/forum/presentation/filterchallengeusers.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/features/search/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../home/controller/home_controller.dart';
import '../models/industry.dart';
import '../presentation/topics.dart';

import '../../../utils/theme/theme.dart';

class AllForumScreen extends StatefulWidget {
  static const String routeName = 'all-forum-screen';
  const AllForumScreen({super.key});

  @override
  State<AllForumScreen> createState() => _AllForumScreenState();
}

class _AllForumScreenState extends State<AllForumScreen>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late Industry industry;
  // ignore: unused_field
  final ProfileController _myProfile = Get.find();
  final HomeController homeController = Get.find();
  late ForumController forumController;
  final CourseController courseController = Get.put(CourseController());
  bool _isSearching = false;
  bool _iscouseSearching = false;
  late final TabController _searchTabController;
  late final TabController _coursesearchTabController;
  late final TabController _pageTabController;
  late final TabController _coursespageTabController;
  late BossUpController bossUpController;

  int currentTabIndex = 0; // Track the current tab index
  String _filtercourses = '';

  @override
  void initState() {
    super.initState();
    _searchTabController = TabController(length: 2, vsync: this);
    _coursesearchTabController = TabController(length: 2, vsync: this);
    _pageTabController = TabController(length: 2, vsync: this);
    _coursespageTabController = TabController(length: 2, vsync: this);
    if (Get.arguments == null) {
      Get.back();
    } else {
      industry = Get.arguments as Industry;
    }
    forumController = Get.put(ForumController());
    bossUpController = Get.put(BossUpController());
  }

  void onPreferencesTap(String filterOption) {
    setState(() {
      _filtercourses = filterOption;
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
            centerTitle: _isSearching ? false : true,
            title: _isSearching
                ? Searchbar(
                    hintText: 'Search ${industry.industry!}',
                    onChange: (String query) {
                      if (query.isEmpty) {
                        _searchTabController.index == 1
                            ? controller.clearUserSearch()
                            : controller.clearPostSearch();
                      }
                      setState(() {});
                    },
                    onSubmit: (String query) {
                      controller.searchUsers(query, industry.industryId!);
                      controller.searchPosts(query);
                      setState(() {});
                    },
                  )
                : _iscouseSearching
                    ? Searchbar(
                        hintText: 'Search Courses',
                        onChange: (String query) {
                          if (query.isEmpty) {
                            _searchTabController.index == 1
                                ? courseController.clearUserSearch()
                                : courseController.clearPostSearch();
                          }
                          setState(() {});
                        },
                        onSubmit: (String query) {
                          courseController.searchUsers(query);
                          courseController.searchPosts(query);
                          setState(() {});
                        },
                      )
                    : Text(
                        industry.industry ?? 'Topic',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 20),
                      ),
            actions: <Widget>[
              currentTabIndex == 0
                  ? IconButton(
                      icon: _iscouseSearching
                          ? const Icon(Icons.close)
                          : SvgPicture.asset(
                              'assets/svgs/preferences.svg',
                              color: Colors.black,
                              height: 20,
                            ),
                      onPressed: () {
                        _iscouseSearching
                            ? {
                                _iscouseSearching = !_iscouseSearching,
                                setState(() {})
                              }
                            : showModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                backgroundColor: Colors.white,
                                context: context,
                                builder: (BuildContext context) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0, vertical: 20),
                                        child: GestureDetector(
                                          onTap: () {
                                            Get.back();
                                            _iscouseSearching =
                                                !_iscouseSearching;
                                            setState(() {});
                                          },
                                          child: SizedBox(
                                            height: 42,
                                            width: double.infinity,
                                            child: TextFormField(
                                              // key: searchkey,
                                              style:
                                                  const TextStyle(fontSize: 20),
                                              decoration:
                                                  inputDecoration.copyWith(
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                fillColor:
                                                    backgroundcolorinterface,
                                                filled: true,
                                                enabled: false,
                                                prefixIcon: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 10.0),
                                                  child: SvgPicture.asset(
                                                    'assets/svgs/search.svg',
                                                    color: hintColor,
                                                  ),
                                                ),
                                                hintText: 'Search Courses',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            left: 20, top: 15, bottom: 15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                      const Divider(
                                        height: 1,
                                        color: backgroundColor,
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: preferenceslist.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return GestureDetector(
                                              onTap: () {
                                                onPreferencesTap(
                                                    preferenceslist[index]);
                                                Get.back();
                                              },
                                              child: Column(
                                                children: <Widget>[
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 20,
                                                      vertical: 20,
                                                    ),
                                                    color: Colors.white,
                                                    child: Text(
                                                      preferenceslist[index] +
                                                          preferencesnumber[
                                                              index],
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
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
                    )
                  : IconButton(
                      icon: _isSearching
                          ? const Icon(Icons.close)
                          : SvgPicture.asset(
                              'assets/svgs/search.svg',
                              color: Colors.black,
                            ),
                      onPressed: () {
                        _isSearching = !_isSearching;

                        setState(() {});
                      })
            ],
            bottom: !_isSearching && !_iscouseSearching
                ? const PreferredSize(
                    preferredSize: Size.fromHeight(0.0),
                    child: SizedBox(height: 0),
                  )
                : _iscouseSearching
                    ? TabBar(
                        controller: _coursesearchTabController,
                        labelStyle:
                            const TextStyle(fontWeight: FontWeight.w500),
                        labelColor: Colors.black,
                        indicatorColor: primaryColorLT,
                        tabs: const <Widget>[
                          Tab(text: 'Posts'),
                          Tab(text: 'People'),
                        ],
                      )
                    : TabBar(
                        controller: _searchTabController,
                        labelStyle:
                            const TextStyle(fontWeight: FontWeight.w500),
                        labelColor: Colors.black,
                        indicatorColor: primaryColorLT,
                        tabs: const <Widget>[
                          Tab(text: 'Posts'),
                          Tab(text: 'People'),
                        ],
                      ),
          ),
          body: _isSearching
              ? TabBarView(
                  controller: _searchTabController,
                  children: [
                    Obx(
                      () => FilterChallengePosts(
                        filterItems: controller.searchedPosts,
                        isLoading: controller.loading.value ||
                            controller.loadingPosts.value,
                      ),
                    ),
                    Obx(() => FilterChallengeUsers(
                          members: controller.members,
                          filterItems: controller.searchedUsers,
                          isLoading: controller.loading.value ||
                              controller.loadingMembers.value,
                          onConnectionChange: controller.connectToUser,
                          isSearch: controller.isUserSearch.value,
                        )),
                  ],
                )
              : _iscouseSearching
                  ? TabBarView(
                      controller: _coursesearchTabController,
                      children: [
                        Obx(
                          () => FilterCoursesPosts(
                            filterItems: courseController.searchedPosts,
                            isLoading: courseController.loading.value ||
                                courseController.loadingPostsSearch.value,
                          ),
                        ),
                        Obx(() => FilterCoursesUsers(
                              members: courseController.usersMembers,
                              filterItems: courseController.searchedUsers,
                              isLoading: courseController.loading.value ||
                                  courseController.loadingSearch.value,
                              onConnectionChange:
                                  courseController.connectToUser,
                              isSearch: courseController.isUserSearch.value,
                            )),
                      ],
                    )
                  : DefaultTabController(
                      length: 2,
                      child: Column(
                        children: <Widget>[
                          Container(
                            color: Colors.white,
                            constraints:
                                const BoxConstraints.expand(height: 50),
                            child: TabBar(
                              tabs: const <Widget>[
                                Tab(text: 'Courses'),
                                Tab(text: 'Resources'),
                              ],
                              onTap: (int index) {
                                setState(() {
                                  currentTabIndex =
                                      index; // Update the current tab index
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: TabBarView(
                              physics: const NeverScrollableScrollPhysics(),
                              children: <Widget>[
                                CoursesPage(
                                  industryId: industry.industryId!,
                                  filter: _filtercourses,
                                ),
                                const TopicsPage(),
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
