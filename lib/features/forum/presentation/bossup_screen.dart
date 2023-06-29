import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import '../../../common/widgets/safety_model.dart';
import '../../../navigation/routes.dart';
import '../../../utils/theme/theme.dart';
import '../../home/controller/home_controller.dart';
import '../../moreinfoscreens/bossuppartner.dart';
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
  final HomeController hmeController = Get.find();

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
                                                    widget.industry.photo!,
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
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8),
                                                    child: SvgPicture.asset(
                                                      'assets/svgs/members.svg',
                                                      height: 15,
                                                      color: primaryColorLT,
                                                    ),
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
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color:
                                                                primaryColorLT,
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
                                                      BorderRadius.circular(
                                                          200),
                                                  color: const Color.fromARGB(
                                                      47, 255, 255, 255),
                                                ),
                                                child: Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      'assets/svgs/topics.svg',
                                                      height: 11.5,
                                                      color: textColor,
                                                    ),
                                                    RichText(
                                                      text: TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text:
                                                                ' Entries: (${controller.totalForums.value}) ',
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 12,
                                                              color: textColor,
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
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    JoinedButton(
                                                      widget.industry
                                                              .joinedUsers
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
                          hmeController.bossUp != null &&
                                  hmeController.bossUp!.isNotEmpty
                              ? GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              const Bossuppartner()),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      right: 20,
                                      left: 20,
                                      bottom: 10,
                                    ),
                                    child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF4F4F4),
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.3),
                                            spreadRadius: 20,
                                            blurRadius: 500,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: const Color(0xFFFFFFFF)
                                                .withAlpha(150),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                color:
                                                    Colors.white.withOpacity(1),
                                                spreadRadius: 20,
                                                blurRadius: 500,
                                                offset: const Offset(0, 3),
                                              ),
                                            ]),
                                        child: Row(
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.only(
                                                left: 10,
                                              ),
                                              child: Center(
                                                child: Padding(
                                                  padding: EdgeInsets.all(2),
                                                  child: Text(
                                                    'Boss Up by',
                                                    style:
                                                        TextStyle(fontSize: 11),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              '|',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: textColor
                                                      .withOpacity(0.5)),
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              hmeController.bossUp != null &&
                                                      hmeController
                                                          .bossUp!.isNotEmpty
                                                  ? hmeController.bossUp!.last[
                                                          'companyName'] ??
                                                      ''
                                                  : '',
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: false,
                                            ),
                                            const Spacer(),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10.0),
                                              child: SvgPicture.asset(
                                                'assets/svgs/nexticon.svg',
                                                color: textColor,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
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
    print('working');

    setState(() {});
  }

  Future<void> refreshData() async {
    await loadData(); // Trigger data reload
  }
}
