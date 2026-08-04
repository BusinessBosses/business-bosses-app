import 'package:business_bosses_v2/common/widgets/popup/learningpopup.dart';
import 'package:business_bosses_v2/common/widgets/popup/opportunitiespopup.dart';
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/forum/controller/forum_controller.dart';
import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:business_bosses_v2/features/forum/widgets/joinedbutton.dart';
import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/forum/widgets/forum_item.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/constants/constants.dart';
import 'package:business_bosses_v2/features/courses/controller/course_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

class TopicsPage extends StatefulWidget {
  const TopicsPage({super.key});

  @override
  State<TopicsPage> createState() => _TopicsPageState();
}

class _TopicsPageState extends State<TopicsPage> {
  final ProfileController _myProfile = Get.find();
  final HomeController hmeController = Get.find();
  final CourseController courseController = Get.find();
  final ScrollController scrollController = ScrollController();
  late Industry industry;

  @override
  void initState() {
    super.initState();
    if (Get.arguments == null) {
      Get.back();
    } else {
      industry = Get.arguments;
    }
  }

  String formatCount(int count) {
    if (count >= 1000) {
      double countInK = count / 1000;
      if (countInK >= 1000) {
        return '${(countInK / 1000).toStringAsFixed(1)}m';
      } else {
        return '${countInK.toStringAsFixed(1)}k';
      }
    } else {
      return count.toString();
    }
  }

  void toggleJoinAndLeaveIndustry(ForumController controller) {
    final String myUid = _myProfile.myProfile.uid;
    // print(myUid);
    if (industry.joinedUsers?.contains(myUid) ?? false) {
      industry.joinedUsers!.removeWhere((String element) => element == myUid);
    } else {
      if (industry.joinedUsers == null) {
        industry.joinedUsers = <String>[myUid];
      } else {
        industry.joinedUsers!.add(myUid);
      }
    }
    setState(() {});
    controller.joinAndLeaveIndustry(myUid, industry.industryId!);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ForumController>(builder: (ForumController controller) {
      int userCount = industry.joinedUsersCount ?? 0;
      String formattedUserCount = formatCount(userCount);
      int postCount = controller.totalForums.value;
      String formattedpostCount = formatCount(postCount);
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
                        if (_myProfile.myProfile.toPost)
                          Row(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () async {
                                  industry.categoryId!.toString() ==
                                          Constants.LEARNINGID
                                      ? showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              const LearningPopUp(),
                                        )
                                      : showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              const OpportunitiesPopup(),
                                        );
                                },
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
                                          backgroundColor: Colors.red,
                                          minimumSize: const Size(150, 45)),
                                      onPressed: () {
                                        Get.toNamed(Routes.createForum,
                                            arguments: <String, Object?>{
                                              'isBossUp': false,
                                              'industryId': industry.industryId,
                                              'categoryId': industry.categoryId
                                            });
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            industry.categoryId!.toString() ==
                                                    Constants.LEARNINGID
                                                ? 'Share Resources'
                                                : 'Share Opportunities',
                                            style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600),
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
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.09),
                                blurRadius: 100.0, // soften the shadow
                                spreadRadius: 5, //extend the shadow
                              )
                            ],
                          ),
                          child: Stack(
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.only(
                                    top: 10, right: 15, left: 15),
                                height: 150,
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: const ColoredBox(color: Colors.white),
                                ),
                              ),
                              Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 25, right: 15, left: 30),
                                        height: 86,
                                        width: 142,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: FittedBox(
                                            fit: BoxFit.fill,
                                            child: CachedNetworkImage(
                                              imageUrl: industry.photo ??
                                                  'https://businessbosses.com.ng/learningImages/events.jpg',
                                              memCacheHeight: 256,
                                              memCacheWidth: 256,
                                              placeholder: (BuildContext
                                                          context,
                                                      String photo) =>
                                                  const CircularProgressIndicator(),
                                              errorWidget:
                                                  // ignore: always_specify_types
                                                  (BuildContext context,
                                                          // ignore: always_specify_types
                                                          String photo,
                                                          Object error) =>
                                                      const Icon(Icons.error),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 30),
                                        child: Text(
                                          industry.description ??
                                              'Industry Description',
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700),
                                          softWrap: true,
                                          maxLines: 5,
                                        ),
                                      )),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 27, right: 15),
                                    child: Row(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 2, top: 5),
                                              child: SvgPicture.asset(
                                                'assets/svgs/members.svg',
                                                height: 15,
                                                colorFilter: ColorFilter.mode(
                                                    primaryColorLT,
                                                    BlendMode.srcIn),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5.0),
                                              child: RichText(
                                                text: TextSpan(
                                                  children: <InlineSpan>[
                                                    TextSpan(
                                                      text: industry
                                                                  .joinedUsers ==
                                                              null
                                                          ? 'Members (0)'
                                                          : 'Members ($formattedUserCount)',
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: primaryColorLT,
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                      ),
                                                      recognizer:
                                                          TapGestureRecognizer()
                                                            ..onTap = () {
                                                              Get.toNamed(
                                                                Routes
                                                                    .specificuserlistscreen,
                                                                arguments: industry
                                                                    .industryId,
                                                              );
                                                            },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0, top: 5, right: 2),
                                              child: SvgPicture.asset(
                                                'assets/svgs/topics.svg',
                                                colorFilter: ColorFilter.mode(
                                                    textColor, BlendMode.srcIn),
                                                height: 11.5,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5.0),
                                              child: RichText(
                                                text: TextSpan(
                                                  children: <InlineSpan>[
                                                    TextSpan(
                                                      text: industry.categoryId!
                                                                  .toString() ==
                                                              'd479f179-3f41-4d84-915d-33110cf5b4fb'
                                                          ? 'Topics ($formattedpostCount) '
                                                          : 'Topics ($formattedpostCount)',
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        color: textColor,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: joinedButton(
                                            industry.joinedUsers?.contains(
                                                    _myProfile.myProfile.uid) ??
                                                false,
                                            () {
                                              toggleJoinAndLeaveIndustry(
                                                  controller);
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ];
        },
        body: controller.loading.value
            ? SafetyModel(
                isLoading: controller.loading.value,
                title: '',
              )
            : controller.error.value
                ? SafetyModel(
                    isLoading: false,
                    title: 'Something went wrong',
                    clickableText: 'Reload',
                    onTap: () async {
                      await controller.fetchForums();
                      courseController.initCourses();
                    },
                  )
                : !controller.loading.value &&
                        !controller.error.value &&
                        controller.forums.isEmpty
                    ? const SafetyModel(
                        isLoading: false,
                        title: 'No post',
                        subTitle: 'This industry has no post',
                        // clickableText: "Reload",
                        // onTap: () async {
                        //   await controller.fetchForums();
                        // },
                      )
                    : ListView.builder(
                        itemCount: controller.forums.length,

                        // <-- this will disable scroll

                        //controller: differentController,

                        itemBuilder: (BuildContext context, int i) {
                          return VisibilityDetector(
                            key: Key(i.toString()),
                            onVisibilityChanged: (VisibilityInfo info) {
                              final bool hasIncrementedView = hmeController
                                  .itemsWithIncrementedViews
                                  .contains(controller.forums[i].forumId);
                              if (info.visibleFraction == 1.0 &&
                                  !hasIncrementedView) {
                                controller
                                    .updateForumViews(controller.forums[i]);
                                setState(() {
                                  hmeController.itemsWithIncrementedViews.add(
                                      controller.forums[i]
                                          .forumId); // Set the flag to prevent further increments
                                });
                              }
                            },
                            child: ForumItem(
                              isLearningpost: true,
                              forum: controller.forums[i],
                              key: ValueKey<String>(
                                  controller.forums[i].forumId),
                              controller: controller,
                              isBossUp: true,
                            ),
                          );
                        }),
      );
    });
  }
}
