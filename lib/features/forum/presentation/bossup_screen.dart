import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import '../../../common/widgets/safety_model.dart';
import '../../../navigation/routes.dart';
import '../../../utils/theme/theme.dart';
import '../../profile/controller/profile_controller.dart';
import '../controller/bossup_controller.dart';
import '../models/industry.dart';
import '../widgets/forum_item.dart';
import '../widgets/joinedbutton.dart';

class BossUpSection extends StatefulWidget {
  final Industry industry;
  const BossUpSection({super.key, required this.industry});

  @override
  State<BossUpSection> createState() => _BossUpSectionState();
}

class _BossUpSectionState extends State<BossUpSection> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController scrollController = ScrollController();
  final ProfileController _myProfile = Get.find();

  void toggleJoinAndLeaveIndustry(BossUpController controller) {
    final String myUid = _myProfile.myProfile.uid;
    // print(myUid);
    if (widget.industry.joinedUsers?.contains(myUid) ?? false) {
      widget.industry.joinedUsers!
          .removeWhere((String element) => element == myUid);
    } else {
      if (widget.industry.joinedUsers == null) {
        widget.industry.joinedUsers = [myUid];
      } else {
        widget.industry.joinedUsers!.add(myUid);
      }
    }
    setState(() {});

    controller.joinAndLeaveIndustry(myUid, widget.industry.industryId!);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BossUpController>(builder: (BossUpController controller) {
      if (controller.loading.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else {
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
                  children: [
                    Container(
                      width: double.infinity,
                      color: Colors.transparent,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(150, 45)),
                                  onPressed: () {
                                    int now =
                                        DateTime.now().millisecondsSinceEpoch;
                                    int previousStamp = _myProfile
                                            .myProfile.bossOfTheWeekTimeStamp ??
                                        0;
                                    if ((previousStamp + 2419200000) > now) {
                                      const SnackBar snackBar = SnackBar(
                                        duration: Duration(seconds: 4),
                                        content: Text(
                                            'You may have posted in Boss Up Challenge'
                                            ' in the past 4 weeks. You Can only post once in 4 weeks.'),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    } else {
                                      Get.toNamed(Routes.createBossUp,
                                          arguments: {
                                            'isBossUp': true,
                                            'industryId':
                                                widget.industry.industryId
                                          });
                                    }
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        'Enter Challenge',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      SvgPicture.asset(
                                          'assets/svgs/enterchallenge.svg')
                                    ],
                                  ),
                                ),
                              )),
                          Stack(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                    top: 10, right: 20, left: 20),
                                height: 150,
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: FittedBox(
                                    fit: BoxFit.fill,
                                    child: Image.asset(
                                        'assets/images/postbackground.png'),
                                  ),
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
                                              imageUrl:
                                                  'https://files.ng/bossup.jpg',
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
                                                          dynamic error) =>
                                                      const Icon(Icons.error),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 35),
                                        child: Text(
                                          widget.industry.description ??
                                              'Industry Description',
                                          style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700),
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
                                            padding: const EdgeInsets.only(
                                                left: 35, top: 5),
                                            child: Container(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8,
                                                  top: 8,
                                                  left: 10,
                                                  right: 10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(200),
                                                color: primaryColorLT,
                                              ),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8),
                                                    child: SvgPicture.asset(
                                                        'assets/svgs/members.svg'),
                                                  ),
                                                  RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: widget.industry
                                                                      .joinedUsers ==
                                                                  null
                                                              ? 'Members: 0'
                                                              : 'Members: (${widget.industry.joinedUsers?.where((String element) => element.isNotEmpty).toList().length ?? 0})',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 11,
                                                                  color: Colors
                                                                      .white),
                                                          recognizer:
                                                              TapGestureRecognizer()
                                                                ..onTap = () {
                                                                  Get.toNamed(
                                                                    Routes
                                                                        .specificuserlistscreen,
                                                                    arguments: widget
                                                                        .industry
                                                                        .industryId,
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
                                            padding: const EdgeInsets.only(
                                                left: 5, top: 5),
                                            child: Container(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8,
                                                  top: 8,
                                                  left: 10,
                                                  right: 10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(200),
                                                color: const Color.fromARGB(
                                                    47, 255, 255, 255),
                                              ),
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/svgs/topics.svg',
                                                  ),
                                                  RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                              'Topics: (${controller.totalForums.value}) ',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 11,
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
                                          padding:
                                              const EdgeInsets.only(right: 20),
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  JoinedButton(
                                                    widget.industry.joinedUsers
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
                        )
                      : RefreshIndicator(
                          onRefresh: refreshData,
                          child: ListView.builder(
                            itemCount: controller.forums.length,

                            // <-- this will disable scroll

                            //controller: differentController,

                            itemBuilder: (BuildContext context, int i) =>
                                ForumItem(
                              forum: controller.forums[i],
                              key: ValueKey(controller.forums[i].forumId),
                              controller: controller,
                            ),
                          ),
                        ),
        );
      }
    });
  }

  Future<void> loadData() async {
    setState(() {});

    // Call the loadPosts() function from the PostsController
    // await Get.find<PostsController>().loadPosts();
    await Get.find<BossUpController>().fetchForums();
    print("working");

    setState(() {});
  }

  Future<void> refreshData() async {
    await loadData(); // Trigger data reload
  }
}
