import 'package:business_bosses_v2/features/forum/widgets/forum_item.dart';
import 'package:business_bosses_v2/features/home/controller/commumities_controller.dart';
import 'package:business_bosses_v2/features/home/widgets/industriessearch.dart';
import 'package:business_bosses_v2/utils/constants/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../common/widgets/safety_model.dart';
import '../../common/widgets/tiles/custom_tile.dart';
import '../../navigation/routes.dart';
import '../../utils/theme/theme.dart';
import '../../common/widgets/popup/bossup_challenge_popup.dart';
import '../forum/widgets/joinedbutton.dart';
import '../search/search_bar.dart';

// ignore: public_member_api_docs
class AllCommunitiesScreen extends StatefulWidget {
  // ignore: public_member_api_docs
  static const String routeName = '/all-communities-screen';

  // ignore: public_member_api_docs
  const AllCommunitiesScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AllCommunitiesScreenState createState() => _AllCommunitiesScreenState();
}

class _AllCommunitiesScreenState extends State<AllCommunitiesScreen>
    with TickerProviderStateMixin {
  bool _isSearching = false;

  final CommunitiesController _communitiesController =
      Get.put(CommunitiesController());
  late final TabController _searchTabController;

  List<Widget> get mActions {
    return [
      IconButton(
        icon: _isSearching
            ? const Icon(Icons.close)
            : SvgPicture.asset(
                'assets/svgs/search.svg',
              ),
        onPressed: () {
          // if (_isSearching) {
          _isSearching = !_isSearching;
          // }
          setState(() {});
          _communitiesController.clearSearch();
        },
      ),
    ];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchTabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommunitiesController>(
      builder: (CommunitiesController controller) {
        return DefaultTabController(
          length: _isSearching ? 2 : 3, // number of tabs
          child: Scaffold(
              backgroundColor: backgroundcolorinterface,
              appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: _isSearching
                      ? Searchbar(
                          hintText: 'Search',
                          onChange: (String query) {
                            if (_searchTabController.index == 0) {
                              controller.onSearch(
                                  _searchTabController.index, query);
                            }
                          },
                          onSubmit: (String query) {
                            if (_searchTabController.index == 1) {
                              controller.onSearch(
                                  _searchTabController.index, query);
                            }
                          },
                        )
                      : const Text('Boss Up'),
                  actions: mActions,
                  bottom: !_isSearching
                      ? const TabBar(
                          labelStyle: TextStyle(fontWeight: FontWeight.w500),
                          labelColor: Colors.black,
                          tabs: [
                              Tab(
                                text: 'Challenge',
                              ),
                              Tab(
                                text: 'Learning',
                              ),
                              Tab(
                                text: 'Opportunities',
                              ),
                            ])
                      : TabBar(
                          controller: _searchTabController,
                          labelStyle:
                              const TextStyle(fontWeight: FontWeight.w500),
                          labelColor: Colors.black,
                          tabs: const [
                              Tab(
                                text: 'Groups',
                              ),
                              Tab(
                                text: 'Topics',
                              ),
                            ])),
              body: !_isSearching
                  ? TabBarView(children: [
                      // content of Tab 1
                      NestedScrollView(
                        headerSliverBuilder:
                            (BuildContext context, bool innerBoxIsScrolled) {
                          return <Widget>[
                            SliverStickyHeader(
                              sticky: false,
                              header: Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    color: Colors.transparent,
                                    child: Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, top: 25),
                                          child: GestureDetector(
                                            onTap: (() {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext
                                                        context) =>
                                                    const BossUpChallangePopUpcopy(),
                                              );
                                            }),
                                            child: Row(
                                              children: [
                                                const Text(
                                                  'About ',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                SvgPicture.asset(
                                                  'assets/svgs/info.svg',
                                                  height: 20,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Column(children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 20),
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    minimumSize: const Size(150,
                                                        45) // put the width and height you want
                                                    ),
                                                onPressed: () {
                                                  // int now = DateTime.now()
                                                  //     .millisecondsSinceEpoch;
                                                  // int previousStamp = user.user
                                                  //         .bossOfTheWeekTimeStamp ??
                                                  //     0;
                                                  // if ((previousStamp + 2419200000) >
                                                  //         now &&
                                                  //     _industry.industry.contains(
                                                  //         "Boss Up Challenge")) {
                                                  //   const snackBar = SnackBar(
                                                  //     duration: Duration(seconds: 4),
                                                  //     content: Text(
                                                  //         'You may have posted in Boss Up Challenge'
                                                  //         ' in the past 4 weeks. You Can only post once in 4 weeks.'),
                                                  //   );
                                                  //   ScaffoldMessenger.of(context)
                                                  //       .showSnackBar(snackBar);
                                                  // } else {
                                                  //   navigateWithReplaceTo(context,
                                                  //       routeName:
                                                  //           CreateForumScreen.routeName,
                                                  //       arguments:
                                                  //           Params(arg1: _industry));
                                                  // }
                                                },
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    const Text(
                                                      'Enter Challenge',
                                                      style: TextStyle(
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
                                            ),
                                          ),
                                          Stack(
                                            children: <Widget>[
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    top: 10,
                                                    right: 20,
                                                    left: 20),
                                                height: 150,
                                                width: double.infinity,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
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
                                                    children: <Widget>[
                                                      Container(
                                                        margin: const EdgeInsets
                                                                .only(
                                                            top: 25,
                                                            right: 20,
                                                            left: 35),
                                                        height: 86,
                                                        width: 142,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          child: FittedBox(
                                                            child:
                                                                CachedNetworkImage(
                                                              memCacheWidth:
                                                                  256,
                                                              imageUrl:
                                                                  'https://files.ng/bossup.jpg',
                                                              placeholder: (BuildContext
                                                                          context,
                                                                      String
                                                                          photo) =>
                                                                  const CircularProgressIndicator(),
                                                              errorWidget: (BuildContext
                                                                          context,
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
                                                      const Expanded(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 35),
                                                          child: Text(
                                                            'Description will be here',
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                            softWrap: true,
                                                            maxLines: 5,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Stack(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                              left: 35,
                                                              top: 5,
                                                            ),
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                bottom: 8,
                                                                top: 8,
                                                                left: 10,
                                                                right: 10,
                                                              ),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            200),
                                                                color:
                                                                    primaryColorLT,
                                                              ),
                                                              child: Row(
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            8),
                                                                    child: SvgPicture
                                                                        .asset(
                                                                            'assets/svgs/members.svg'),
                                                                  ),
                                                                  RichText(
                                                                    text:
                                                                        TextSpan(
                                                                      children: [
                                                                        TextSpan(
                                                                            text:
                                                                                'Members: 0',
                                                                            style:
                                                                                const TextStyle(fontSize: 11, color: Colors.white),
                                                                            recognizer: TapGestureRecognizer()..onTap = () {}),
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
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 5,
                                                                    top: 5),
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      bottom: 8,
                                                                      top: 8,
                                                                      left: 10,
                                                                      right:
                                                                          10),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            200),
                                                                color: const Color
                                                                        .fromARGB(
                                                                    47,
                                                                    255,
                                                                    255,
                                                                    255),
                                                              ),
                                                              child: Row(
                                                                children: [
                                                                  SvgPicture.asset(
                                                                      'assets/svgs/entries.svg'),
                                                                  RichText(
                                                                    text:
                                                                        const TextSpan(
                                                                      children: <InlineSpan>[
                                                                        TextSpan(
                                                                          text:
                                                                              'Entries: (0)',
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                11,
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
                                                                const EdgeInsets
                                                                    .only(
                                                              right: 20,
                                                            ),
                                                            child: SizedBox(
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerRight,
                                                                  child: Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      JoinedButton(
                                                                          true,
                                                                          () {}),
                                                                    ],
                                                                  )),
                                                            )),
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  // Padding(
                                                  //   padding: const EdgeInsets.only(
                                                  //     left: 20.0,
                                                  //     right: 5,
                                                  //   ),
                                                  //   child: StreamBuilder<Event>(
                                                  //     stream: FirebaseDatabase.instance
                                                  //         .reference()
                                                  //         .child(
                                                  //             "/settings/BossUp/companyName")
                                                  //         .onValue,
                                                  //     builder: (BuildContext context,
                                                  //         AsyncSnapshot snapshot) {
                                                  //       if (snapshot.hasData &&
                                                  //           snapshot.data.snapshot
                                                  //                   .value !=
                                                  //               null) {
                                                  //         var data = snapshot
                                                  //             .data.snapshot.value;
                                                  //         return GestureDetector(
                                                  //           onTap: () {
                                                  //             Navigator.push(
                                                  //               context,
                                                  //               MaterialPageRoute(
                                                  //                   builder: (BuildContext
                                                  //                           context) =>
                                                  //                       const Bossuppartner()),
                                                  //             );
                                                  //           },
                                                  //           child: Padding(
                                                  //             padding:
                                                  //                 const EdgeInsets.only(
                                                  //                     right: 15, top: 5),
                                                  //             child: Container(
                                                  //               height: 40,
                                                  //               decoration: BoxDecoration(
                                                  //                 color: const Color(
                                                  //                     0xFFF4F4F4),
                                                  //                 borderRadius:
                                                  //                     BorderRadius
                                                  //                         .circular(10),
                                                  //                 boxShadow: [
                                                  //                   BoxShadow(
                                                  //                     color: Colors.grey
                                                  //                         .withOpacity(
                                                  //                             0.3),
                                                  //                     spreadRadius: 20,
                                                  //                     blurRadius: 500,
                                                  //                     offset:
                                                  //                         const Offset(
                                                  //                             0, 3),
                                                  //                   ),
                                                  //                 ],
                                                  //               ),
                                                  //               child: Row(
                                                  //                 children: [
                                                  //                   Padding(
                                                  //                     padding:
                                                  //                         const EdgeInsets
                                                  //                             .only(
                                                  //                       left: 10,
                                                  //                     ),
                                                  //                     child: Container(
                                                  //                       height: 25,
                                                  //                       width: 100,
                                                  //                       decoration:
                                                  //                           BoxDecoration(
                                                  //                         color: const Color(
                                                  //                             0xFFEAEAEA),
                                                  //                         borderRadius:
                                                  //                             BorderRadius
                                                  //                                 .circular(
                                                  //                                     20),
                                                  //                       ),
                                                  //                       child:
                                                  //                           const Center(
                                                  //                         child: Padding(
                                                  //                           padding:
                                                  //                               EdgeInsets
                                                  //                                   .all(
                                                  //                                       2),
                                                  //                           child: Text(
                                                  //                               "Boss Up by"),
                                                  //                         ),
                                                  //                       ),
                                                  //                     ),
                                                  //                   ),
                                                  //                   const SizedBox(
                                                  //                       width: 10),
                                                  //                   Text(
                                                  //                     data.toString(),
                                                  //                     style:
                                                  //                         const TextStyle(
                                                  //                       fontSize: 15,
                                                  //                       fontWeight:
                                                  //                           FontWeight
                                                  //                               .bold,
                                                  //                       decoration:
                                                  //                           TextDecoration
                                                  //                               .underline,
                                                  //                     ),
                                                  //                   ),
                                                  //                 ],
                                                  //               ),
                                                  //             ),
                                                  //           ),
                                                  //         );
                                                  //       } else {
                                                  //         return Container();
                                                  //       }
                                                  //     },
                                                  //   ),
                                                  // ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ]),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ];
                        },
                        body: Container(),
                        // body: Container(
                        //         color: backgroundcolorinterface,
                        //         child: ListView.builder(
                        //             key: ValueKey(cat.categoryId),
                        //             padding: const EdgeInsets.only(
                        //               top: 8.0,
                        //               right: 0.0,
                        //               left: 0.0,
                        //               bottom: 120.0,
                        //             ),
                        //             itemCount: _forums.length,

                        //             // <-- this will disable scroll

                        //             //controller: differentController,

                        //             itemBuilder: (BuildContext context, int i) {
                        //               _forums.sort(
                        //                 (a, b) => b.isRanked
                        //                     .toString()
                        //                     .compareTo(a.isRanked.toString()),
                        //               );
                        //               return UpdatedForumItem(
                        //                 _forums[i],
                        //                 key: ValueKey(_forums[i].forumId),
                        //                 onLikeTap: (MyForum latestForum) {
                        //                   _forums[i].likes = latestForum.likes;
                        //                   setState(() {});
                        //                 },
                        //                 onCommentSent: (MyForum latestForum) {
                        //                   _forums[i].comments = latestForum.comments;
                        //                   setState(() {});
                        //                 },
                        //               );
                        //             }),
                        //       ),
                      ),
                      // content of Tab 2
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: controller.loading.value
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
                                      await controller.fetchIndustries();
                                    },
                                  )
                                : GridView.builder(
                                    itemCount: controller
                                        .getCategoryIndustries(
                                            Constants.LEARNINGID)
                                        .length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return CustomTile(
                                        label: controller
                                            .getCategoryIndustries(
                                                Constants.LEARNINGID)[index]
                                            .industry!,
                                        photo:
                                            'http://44.210.87.234/learningImages/events.jpg',
                                        onTap: () {
                                          Get.toNamed(
                                            Routes.allforumscreen,
                                            arguments: controller
                                                .getCategoryIndustries(Constants
                                                    .LEARNINGID)[index],
                                          );
                                        },
                                      );
                                    },
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      mainAxisSpacing: 10.0,
                                      crossAxisSpacing: 15.0,
                                      crossAxisCount: 2,
                                    ),
                                  ),
                      ),
                      // content of Tab 3
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: controller.loading.value
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
                                      await controller.fetchIndustries();
                                    },
                                  )
                                : GridView.builder(
                                    itemCount: controller
                                        .getCategoryIndustries(
                                            Constants.OPPORTUNITIESID)
                                        .length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return CustomTile(
                                        label: controller
                                            .getCategoryIndustries(Constants
                                                .OPPORTUNITIESID)[index]
                                            .industry!,
                                        photo:
                                            'http://44.210.87.234/learningImages/events.jpg',
                                        onTap: () {
                                          Get.toNamed(Routes.allforumscreen,
                                              arguments: controller
                                                      .getCategoryIndustries(
                                                          Constants
                                                              .OPPORTUNITIESID)[
                                                  index]);
                                        },
                                      );
                                    },
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      mainAxisSpacing: 10.0,
                                      crossAxisSpacing: 15.0,
                                      crossAxisCount: 2,
                                    ),
                                  ),
                      ),
                    ])
                  : TabBarView(
                      controller: _searchTabController,
                      children: [
                        Container(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          height: double.infinity,
                          width: double.infinity,
                          child: MySearchIndustries(
                              searchIndustries: controller.searchedIndustries),
                        ),
                        Container(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          height: double.infinity,
                          width: double.infinity,
                          child: controller.searchedForums.isEmpty
                              ? SafetyModel(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  isLoading: controller.loadingSearch.value,
                                  icon: SvgPicture.asset(
                                      'assets/svgs/search.svg',
                                      color: hintColor,
                                      height: 80.0,
                                      width: 80.0),
                                  title:
                                      'Search for Category name', //'Search for ${cat.category.toLowerCase()}',
                                  subTitle:
                                      'Search for specific topic of Category name',
                                  //'Search for specific topic of ${cat.category.toLowerCase()}',
                                )
                              : ListView.builder(
                                  key: const ValueKey('cat.categoryId'),
                                  padding: const EdgeInsets.only(
                                    top: 8.0,
                                    right: 8.0,
                                    left: 8.0,
                                    bottom: 120.0,
                                  ),
                                  itemCount: controller.searchedForums.length,
                                  itemBuilder: (BuildContext context, int i) {
                                    return ForumItem(
                                      forum: controller.searchedForums[i],
                                      controller: controller,
                                    );
                                    // return ForumItem(
                                    //   _searchTopics[i],
                                    //   key: ValueKey(_searchTopics[i].forumId),
                                    //   onLikeTap: (ForumModel latestForum) {
                                    //     _searchTopics[i].likes = latestForum.likes;
                                    //     setState(() {});
                                    //   },
                                    //   onCommentSent: (ForumModel latestForum) {
                                    //     _searchTopics[i].comments = latestForum.comments;
                                    //     setState(() {});
                                    //   },
                                    // );
                                  },
                                ),
                        ),
                      ],
                    )),
        );
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _searchTabController.dispose();
    super.dispose();
  }

  void _onChanged(String value) {}
}
