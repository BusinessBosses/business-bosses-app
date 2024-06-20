import 'package:business_bosses_v2/features/donations/presentation/filterdonationusers.dart';
import 'package:business_bosses_v2/features/forum/controller/create_bossup_controller.dart';
import 'package:business_bosses_v2/features/forum/presentation/create_bossup_screen.dart';
import 'package:business_bosses_v2/features/forum/presentation/filterchallengeposts.dart';
import 'package:business_bosses_v2/features/home/widgets/floatingbutton.dart';
import 'package:business_bosses_v2/features/search/widgets/search_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:intl/intl.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../common/widgets/popup/bossup_challenge_popup.dart';
import '../../../common/widgets/safety_model.dart';
import '../../../navigation/routes.dart';
import '../../../utils/theme/theme.dart';
import '../../home/controller/home_controller.dart';
import '../../profile/controller/profile_controller.dart';
import '../controller/bossup_controller.dart';
import '../models/industry.dart';
import '../widgets/forum_item.dart';

class BossUpSection extends StatefulWidget {
  final Industry industry;
  final Industry bossUp;
  const BossUpSection(
      {super.key, required this.industry, required this.bossUp});

  @override
  State<BossUpSection> createState() => _BossUpSectionState();
}

class _BossUpSectionState extends State<BossUpSection>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController scrollController = ScrollController();
  final ProfileController _myProfile = Get.find();
  final HomeController hmeController = Get.find();
  final BossUpController bossUpController = Get.put(BossUpController());
  late final TabController _searchTabController;
  bool _isSearching = false;
  late final TabController _pageTabController;

  bool showFloatingButton = false;

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

  void toggleJoinAndLeaveIndustry(BossUpController controller) {
    final String myUid = _myProfile.myProfile.uid;
    // print(myUid);
    if (widget.industry.joinedUsers?.contains(myUid) ?? false) {
      widget.industry.joinedUsers!
          .removeWhere((String element) => element == myUid);
    } else {
      if (widget.industry.joinedUsers == null) {
        widget.industry.joinedUsers = <String>[myUid];
      } else {
        widget.industry.joinedUsers!.add(myUid);
      }
    }
    setState(() {});

    controller.joinAndLeaveIndustry(myUid, widget.industry);
  }

  @override
  void initState() {
    super.initState();
    bossUpController.fetchForums(widget.industry.industryId!);
    _searchTabController = TabController(length: 2, vsync: this);
    _pageTabController = TabController(
      length: 2,
      vsync: this,
    );
    scrollController.addListener(() {
      double percentageScrolled =
          scrollController.offset / scrollController.position.maxScrollExtent;

      if (percentageScrolled >= 0.3) {
        setState(() {
          showFloatingButton = true;
        });
      } else {
        setState(() {
          showFloatingButton = false;
        });
      }
    });
    _pageTabController.addListener(() {
      setState(() {});
    });
  }

  Future<void> refreshData() async {
    await bossUpController.fetchForums(widget.industry.industryId!);
  }

  @override
  Widget build(BuildContext context) {
    int userCount = widget.bossUp.joinedUsers
            ?.where((String element) => element.isNotEmpty)
            .toList()
            .length ??
        0;
    String formattedUserCount = formatCount(userCount);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
            Get.delete<BossUpController>();
          },
          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        ),
        centerTitle: _isSearching ? false : true,
        title: _isSearching
            ? Searchbar(
                hintText: 'Search Posts or Members',
                onChange: (String query) {
                  if (query.isEmpty) {
                    _searchTabController.index == 1
                        ? bossUpController.clearUserSearch()
                        : bossUpController.clearPostSearch();
                  }
                  setState(() {});
                },
                onSubmit: (String query) {
                  _searchTabController.index == 1
                      ? bossUpController.searchUsers(
                          query, widget.industry.industryId)
                      : bossUpController.searchPosts(query);
                  setState(() {});
                },
              )
            : Text(
                widget.industry.industry!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20),
              ),
        actions: [
          IconButton(
            icon: _isSearching
                ? const Icon(Icons.close)
                : SvgPicture.asset(
                    'assets/svgs/search.svg',
                  ),
            onPressed: () {
              // // if (_isSearching) {
              _isSearching = !_isSearching;
              // }
              setState(() {});
              bossUpController.searchedPosts.clear();
              bossUpController.searchedUsers.clear();
              // _communitiesController.clearSearch();
            },
          ),
        ],
        bottom: !_isSearching
            ? const PreferredSize(
                preferredSize: Size.fromHeight(0.0),
                child: SizedBox(height: 0),
              )
            : TabBar(
                controller: _searchTabController,
                labelStyle: const TextStyle(fontWeight: FontWeight.w500),
                labelColor: Colors.black,
                indicatorColor: primaryColorLT,
                tabs: const <Widget>[
                  Tab(text: 'Posts'),
                  Tab(text: 'Members'),
                ],
              ),
      ),
      body: _isSearching
          ? TabBarView(
              controller: _searchTabController,
              children: [
                Obx(
                  () => FilterChallengePosts(
                    filterItems: bossUpController.searchedPosts,
                    isLoading: bossUpController.loading.value ||
                        bossUpController.loadingPostSearch.value,
                  ),
                ),
                Obx(() => FilterDonationsUsers(
                      members: bossUpController.members,
                      filterItems: bossUpController.searchedUsers,
                      isLoading: bossUpController.loading.value ||
                          bossUpController.loadingMembers.value,
                      onConnectionChange: bossUpController.connectToUser,
                      isSearch: bossUpController.isUserSearch.value,
                    )),
              ],
            )
          : GetBuilder<BossUpController>(
              builder: (BossUpController controller) {
              int postCount = controller.totalForums.value;
              String formattedpostCount = formatCount(postCount);
              if (controller.loading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Stack(children: <Widget>[
                  NestedScrollView(
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
                                color: backgroundcolorinterface,
                                child: Stack(children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text(
                                                        widget.industry
                                                                    .industryId ==
                                                                '-MsUOGcOT9oRXGakCcJv'
                                                            ? 'Free Promotion'
                                                            : widget.industry
                                                                    .award ??
                                                                'Win',
                                                        style: const TextStyle(
                                                          color: primaryColorLT,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 17,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      const Icon(
                                                        Icons
                                                            .watch_later_outlined,
                                                        size: 15,
                                                      ),
                                                      const SizedBox(
                                                        width: 2,
                                                      ),
                                                      Text(
                                                        widget.industry
                                                                    .industryId ==
                                                                '-MsUOGcOT9oRXGakCcJv'
                                                            ? 'Every Monday'
                                                            : _calculateEndsDate(
                                                                widget.industry
                                                                    .endedAt!),
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                      const SizedBox(width: 3),
                                                      widget.industry.endedAt !=
                                                              null
                                                          ? Text(
                                                              '(${_calculateTimeLeft(widget.industry.endedAt!)})')
                                                          : const Text(
                                                              '(Ongoing)'),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: (() {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          BossUpChallangePopUp(
                                                              industry: widget
                                                                  .industry),
                                                );
                                              }),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 8),
                                                decoration: BoxDecoration(
                                                    color: Colors.black12,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30)),
                                                child: Row(
                                                  children: <Widget>[
                                                    SvgPicture.asset(
                                                      'assets/svgs/info.svg',
                                                      height: 15,
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    const Text(
                                                      'How it works ',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.09),
                                              blurRadius:
                                                  100.0, // soften the shadow
                                              spreadRadius:
                                                  5, //extend the shadow
                                            )
                                          ],
                                        ),
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.all(5),
                                                    height: 86,
                                                    width: 142,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      child: FittedBox(
                                                        fit: BoxFit.fill,
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: widget
                                                              .industry.photo!,
                                                          memCacheHeight: 256,
                                                          memCacheWidth: 256,
                                                          placeholder: (BuildContext
                                                                      context,
                                                                  String
                                                                      photo) =>
                                                              const CircularProgressIndicator(),
                                                          errorWidget:
                                                              // ignore: always_specify_types
                                                              (BuildContext
                                                                          context,
                                                                      // ignore: always_specify_types
                                                                      String
                                                                          photo,
                                                                      dynamic
                                                                          error) =>
                                                                  const Icon(Icons
                                                                      .error),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 30),
                                                      child: Text(
                                                        widget.industry
                                                                .description
                                                                ?.trim() ??
                                                            'Industry Description',
                                                        style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                        softWrap: true,
                                                        maxLines: 5,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Row(
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    right: 2,
                                                                    top: 5),
                                                            child: SvgPicture
                                                                .asset(
                                                              'assets/svgs/members.svg',
                                                              height: 15,
                                                              color:
                                                                  primaryColorLT,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 5.0),
                                                            child: RichText(
                                                              text: TextSpan(
                                                                children: <InlineSpan>[
                                                                  TextSpan(
                                                                    text: widget.industry.joinedUsers ==
                                                                            null
                                                                        ? 'Members (0)'
                                                                        : 'Members ($formattedUserCount)',
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          12,
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
                                                                              Routes.specificuserlistscreen,
                                                                              arguments: '-MsUOGcOT9oRXGakCcJv',
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
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 8.0,
                                                                    top: 5,
                                                                    right: 2),
                                                            child: SvgPicture
                                                                .asset(
                                                              'assets/svgs/entries.svg',
                                                              color: textColor,
                                                              height: 11.5,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 5.0),
                                                            child: RichText(
                                                              text: TextSpan(
                                                                children: <InlineSpan>[
                                                                  TextSpan(
                                                                    text:
                                                                        'Entries ($formattedpostCount) ',
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          12,
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
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            minimumSize:
                                                                const Size(
                                                                    90, 40)),
                                                    onPressed: () {
                                                      int now = DateTime.now()
                                                          .millisecondsSinceEpoch;
                                                      int previousStamp = _myProfile
                                                              .myProfile
                                                              .bossOfTheWeekTimeStamp ??
                                                          0;
                                                      if ((previousStamp +
                                                                  1209600000) >
                                                              now &&
                                                          widget.industry
                                                                  .industryId ==
                                                              '-MsUOGcOT9oRXGakCcJv') {
                                                        const SnackBar
                                                            snackBar = SnackBar(
                                                          duration: Duration(
                                                              seconds: 4),
                                                          content: Text(
                                                              'You may have posted in Boss Up Challenge'
                                                              ' in the past 12 weeks. You Can only post once in 12 weeks.'),
                                                        );
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                snackBar);
                                                      } else {
                                                        if (widget.industry
                                                                .industryId ==
                                                            '-MsUOGcOT9oRXGakCcJv') {
                                                          Get.to(
                                                            CreateBossUpScreen(
                                                                industryModel:
                                                                    widget
                                                                        .industry),
                                                            arguments: <String,
                                                                Object?>{
                                                              'isBossUp': true,
                                                              'industryId':
                                                                  widget
                                                                      .industry
                                                                      .industryId
                                                            },
                                                            binding: BindingsBuilder
                                                                .put(() =>
                                                                    CreateBossUpController()),
                                                          );
                                                        } else {
                                                          if (_myProfile
                                                              .myProfile
                                                              .postChallenges!
                                                              .contains(widget
                                                                  .industry
                                                                  .industryId)) {
                                                            const SnackBar
                                                                snackBar =
                                                                SnackBar(
                                                              duration:
                                                                  Duration(
                                                                      seconds:
                                                                          4),
                                                              content: Text(
                                                                  'You can only post once in a challenge'),
                                                            );
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    snackBar);
                                                            return;
                                                          }
                                                          Get.to(
                                                            () => CreateBossUpScreen(
                                                                industryModel:
                                                                    widget
                                                                        .industry),
                                                            arguments: <String,
                                                                Object?>{
                                                              'isBossUp': true,
                                                              'industryId':
                                                                  widget
                                                                      .industry
                                                                      .industryId
                                                            },
                                                            binding: BindingsBuilder<
                                                                    CreateBossUpController>.put(
                                                                () =>
                                                                    CreateBossUpController()),
                                                          );
                                                        }
                                                      }
                                                    },
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        const Text(
                                                          'Enter ',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        SvgPicture.asset(
                                                          'assets/svgs/startatopic.svg',
                                                          height: 10,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ]),
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
                                  await controller
                                      .fetchForums(widget.industry.industryId!);
                                },
                              )
                            : controller.forums.isEmpty
                                ? const SafetyModel(
                                    isLoading: false,
                                    title: 'No post',
                                    subTitle: 'This industry has no post',
                                  )
                                : RefreshIndicator(
                                    onRefresh: refreshData,
                                    child: ListView.builder(
                                        itemCount: controller.forums.length,
                                        itemBuilder:
                                            (BuildContext context, int i) {
                                          return VisibilityDetector(
                                            key: Key(i.toString()),
                                            onVisibilityChanged:
                                                (VisibilityInfo info) {
                                              final bool hasIncrementedView =
                                                  hmeController
                                                      .itemsWithIncrementedViews
                                                      .contains(controller
                                                          .forums[i].forumId);
                                              if (info.visibleFraction == 1.0 &&
                                                  !hasIncrementedView) {
                                                controller.updateForumViews(
                                                    controller.forums[i]);
                                                setState(() {
                                                  hmeController
                                                      .itemsWithIncrementedViews
                                                      .add(controller.forums[i]
                                                          .forumId); // Set the flag to prevent further increments
                                                });
                                              }
                                            },
                                            child: ForumItem(
                                              forum: controller.forums[i],
                                              key: ValueKey(
                                                  controller.forums[i].forumId),
                                              controller: controller,
                                              isBossUp: true,
                                            ),
                                          );
                                        }),
                                  ),
                  ),
                  Positioned(
                      right: 0,
                      bottom: -70,
                      child: showFloatingButton
                          ? const Floatingbutton()
                          : Container())
                ]);
              }
            }),
    );
  }

  String _calculateTimeLeft(DateTime endTime) {
    DateTime now = DateTime.now();
    Duration difference = endTime.difference(now);

    if (difference.isNegative) {
      return "Time's up"; // Or handle accordingly if time is already passed
    } else if (difference.inDays > 0) {
      return "${difference.inDays} day${difference.inDays > 1 ? 's' : ''} left";
    } else {
      return '1 day left';
    }
  }

  String _calculateEndsDate(DateTime endedAt) {
    // Format the endedAt date using DateFormat
    String formattedDate = DateFormat('d MMM').format(endedAt);
    return 'Ends $formattedDate';
  }
}
