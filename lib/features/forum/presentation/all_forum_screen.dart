import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/forum/controller/forum_controller.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/constants/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../navigation/routes.dart';
import '../models/industry.dart';
import '../../../utils/theme/theme.dart';
import '../widgets/forum_item.dart';
import '../widgets/joinedbutton.dart';

// ignore: public_member_api_docs
class AllForumScreen extends StatefulWidget {
  // ignore: public_member_api_docs
  static const String routeName = 'all-forum-screen';

  // ignore: public_member_api_docs
  const AllForumScreen({super.key});

  @override
  State<AllForumScreen> createState() => _AllForumScreenState();
}

class _AllForumScreenState extends State<AllForumScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController scrollController = ScrollController();
  late Industry industry;
  final ProfileController _myProfile = Get.find();
  // final List<ForumModel> forums = [];

  void toggleJoinAndLeaveIndustry(ForumController controller) {
    final String myUid = _myProfile.myProfile.uid;
    // print(myUid);
    if (industry.joinedUsers?.contains(myUid) ?? false) {
      industry.joinedUsers!.removeWhere((String element) => element == myUid);
    } else {
      if (industry.joinedUsers == null) {
        industry.joinedUsers = [myUid];
      } else {
        industry.joinedUsers!.add(myUid);
      }
    }
    setState(() {});
    controller.joinAndLeaveIndustry(myUid, industry.industryId!);
  }

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
    return GetBuilder<ForumController>(
      builder: (ForumController controller) {
        return Scaffold(
            backgroundColor: backgroundcolorinterface,
            key: scaffoldKey,
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
              ),
              centerTitle: true,
              title: Text(
                industry.industry ?? 'Topic',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            body: NestedScrollView(
              controller: scrollController,
              headerSliverBuilder: (
                BuildContext context,
                bool innerBoxIsScrolled,
              ) {
                return <Widget>[
                  SliverStickyHeader(
                    sticky: false,
                    header: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          color: Colors.transparent,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Row(
                                      children: [
                                        Text('Info'),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        SvgPicture.asset(
                                          'assets/svgs/info.svg',
                                          height: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 20),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              minimumSize: const Size(150, 45)),
                                          onPressed: () {
                                            Get.toNamed(Routes.createForum,
                                                arguments: {
                                                  'isBossUp': false,
                                                  'industryId':
                                                      industry.industryId,
                                                  'categoryId':
                                                      industry.categoryId
                                                });
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                industry.categoryId!
                                                            .toString() ==
                                                        Constants.LEARNINGID
                                                    ? 'Start a Topic'
                                                    : 'Create Opportunities',
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w500),
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
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.09),
                                      blurRadius: 100.0, // soften the shadow
                                      spreadRadius: 5, //extend the shadow
                                    )
                                  ],
                                ),
                                child: Stack(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 10, right: 20, left: 20),
                                      height: 150,
                                      width: double.infinity,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        child: const ColoredBox(
                                            color: Colors.white),
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 25, right: 20, left: 35),
                                              height: 86,
                                              width: 142,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                child: FittedBox(
                                                  fit: BoxFit.fill,
                                                  child: CachedNetworkImage(
                                                    imageUrl: industry.photo ??
                                                        'http://44.210.87.234/learningImages/events.jpg',
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
                                                                error) =>
                                                            const Icon(
                                                                Icons.error),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                                child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 35),
                                              child: Text(
                                                industry.description ??
                                                    'Industry Description',
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w700),
                                                softWrap: true,
                                                maxLines: 5,
                                              ),
                                            )),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Stack(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 35, top: 5),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 8,
                                                            top: 8,
                                                            left: 0,
                                                            right: 10),
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 8),
                                                          child:
                                                              SvgPicture.asset(
                                                            'assets/svgs/members.svg',
                                                            height: 15,
                                                            color:
                                                                primaryColorLT,
                                                          ),
                                                        ),
                                                        RichText(
                                                          text: TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text: industry
                                                                            .joinedUsers ==
                                                                        null
                                                                    ? 'Members: 0'
                                                                    : 'Members: (${industry.joinedUsers?.where((String element) => element.isNotEmpty).toList().length ?? 0})',
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color:
                                                                      primaryColorLT,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                ),
                                                                recognizer:
                                                                    TapGestureRecognizer()
                                                                      ..onTap =
                                                                          () {
                                                                        Get.toNamed(
                                                                          Routes
                                                                              .specificuserlistscreen,
                                                                          arguments:
                                                                              industry.industryId,
                                                                        );
                                                                      },
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Stack(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5, top: 5),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 8,
                                                            top: 8,
                                                            left: 10,
                                                            right: 10),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              200),
                                                      color:
                                                          const Color.fromARGB(
                                                              47,
                                                              255,
                                                              255,
                                                              255),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        SvgPicture.asset(
                                                          'assets/svgs/topics.svg',
                                                          color: textColor,
                                                          height: 11.5,
                                                        ),
                                                        RichText(
                                                          text: TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text: industry
                                                                            .categoryId!
                                                                            .toString() ==
                                                                        'd479f179-3f41-4d84-915d-33110cf5b4fb'
                                                                    ? ' Topics: (${controller.totalForums.value}) '
                                                                    : ' Opport.: (${controller.totalForums.value})',
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 12,
                                                                  color:
                                                                      textColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Flexible(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 20),
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        JoinedButton(
                                                          industry.joinedUsers
                                                                  ?.contains(
                                                                      _myProfile
                                                                          .myProfile
                                                                          .uid) ??
                                                              false,
                                                          () {
                                                            toggleJoinAndLeaveIndustry(
                                                                controller);
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
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

                              itemBuilder: (BuildContext context, int i) =>
                                  ForumItem(
                                    forum: controller.forums[i],
                                    key: ValueKey(controller.forums[i].forumId),
                                    controller: controller,
                                  )),
            ));
      },
    );
  }
}
