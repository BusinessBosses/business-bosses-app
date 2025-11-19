import 'package:business_bosses_v2/features/courses/controller/course_controller.dart';
import 'package:business_bosses_v2/features/courses/models/course_model.dart';
import 'package:business_bosses_v2/features/courses/presentation/courses.dart';
import 'package:business_bosses_v2/features/courses/widgets/filtercoursesposts.dart';
import 'package:business_bosses_v2/features/search/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../home/controller/home_controller.dart';
import '../models/industry.dart';

import '../../../utils/theme/theme.dart';

class AllForumScreen extends StatefulWidget {
  static const String routeName = 'all-forum-screen';
  final bool? isCourses;
  const AllForumScreen({
    super.key,
    this.isCourses = false,
  });

  @override
  State<AllForumScreen> createState() => _AllForumScreenState();
}

class _AllForumScreenState extends State<AllForumScreen>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late Industry industry;

  final HomeController homeController = Get.find();
  final CourseController courseController = Get.put(CourseController());

  bool _isSearching = false;
  bool _iscouseSearching = false;

  final String? id = Get.parameters['id'];

  String _filtercourses = '';

  @override
  void initState() {
    super.initState();

    final args = Get.arguments;

    if (args != null && args is Industry) {
      industry = args;
    } else {
      industry = Industry(industryId: '', industry: 'Courses');
    }
  }

  void onPreferencesTap(String filterOption) {
    setState(() {
      _filtercourses = filterOption;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    // Removed forum controller clearing
                  }
                  setState(() {});
                },
                onSubmit: (String query) {
                  // Removed forum search
                  setState(() {});
                },
              )
            : _iscouseSearching
                ? Searchbar(
                    hintText: 'Search Courses',
                    onChange: (String query) {
                      if (query.isEmpty) {
                        courseController.clearUserSearch();
                        courseController.clearPostSearch();
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
                  ),
        actions: <Widget>[
          widget.isCourses == true
              ? IconButton(
                  icon: _iscouseSearching
                      ? const Icon(Icons.close)
                      : SvgPicture.asset(
                          'assets/svgs/preferences.svg',
                          color: const Color.fromARGB(255, 62, 55, 55),
                          height: 20,
                        ),
                  onPressed: () {
                    _iscouseSearching
                        ? <void>{
                            _iscouseSearching = !_iscouseSearching,
                            setState(() {}),
                            courseController.searchedPosts.clear(),
                            courseController.searchedUsers.clear(),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 20),
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.back();
                                        _iscouseSearching = !_iscouseSearching;
                                        setState(() {});
                                      },
                                      child: SizedBox(
                                        height: 42,
                                        width: double.infinity,
                                        child: TextFormField(
                                          style: const TextStyle(fontSize: 20),
                                          decoration: inputDecoration.copyWith(
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            fillColor: backgroundcolorinterface,
                                            filled: true,
                                            enabled: false,
                                            prefixIcon: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
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
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return GestureDetector(
                                          onTap: () {
                                            onPreferencesTap(
                                                preferenceslist[index]);
                                            Get.back();
                                          },
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 20,
                                                  vertical: 20,
                                                ),
                                                color: Colors.white,
                                                child: Text(
                                                  preferenceslist[index] +
                                                      preferencesnumber[index],
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
                    // Removed controller clearing
                  })
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: SizedBox(height: 0),
        ),
      ),
      body: _isSearching
          ? const SizedBox() // no forum search
          : _iscouseSearching
              ? Obx(
                  () => FilterCoursesPosts(
                    filterItems: courseController.searchedPosts,
                    isLoading: courseController.loading.value ||
                        courseController.loadingPostsSearch.value,
                  ),
                )
              : CoursesPage(
                  industry: industry.industryId!,
                  filter: _filtercourses,
                ),
    );
  }

  List<String> get preferenceslist => <String>[
        'All Courses',
        'Free Courses',
        'Paid Courses',
      ];

  List<String> get preferencesnumber => <String>[
        ' (${courseController.courses.length})',
        ' (${courseController.courses.where((CourseModel course) => course.courseType == 'free').length})',
        ' (${courseController.courses.where((CourseModel course) => course.courseType == 'paid').length})',
      ];
}
