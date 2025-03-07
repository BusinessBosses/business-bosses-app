import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/common/widgets/text_widget.dart';
import 'package:business_bosses_v2/features/courses/controller/course_controller.dart';
import 'package:business_bosses_v2/features/courses/models/course_model.dart';
import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:business_bosses_v2/features/home/controller/commumities_controller.dart';
import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/home/widgets/course_item.dart';
import 'package:business_bosses_v2/features/home/widgets/course_list.dart';
import 'package:business_bosses_v2/features/home/widgets/relevantpeopletile.dart';
import 'package:business_bosses_v2/features/live_event/controller/live_event_controller.dart';
import 'package:business_bosses_v2/features/live_event/presentation/live_event.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/market_controller.dart';
import 'package:business_bosses_v2/features/marketplace/models/market_model.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/marketplace_item.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/service_item.dart';
import 'package:business_bosses_v2/features/moreinfoscreens/bossuppartner.dart';
import 'package:business_bosses_v2/features/posts/models/post_model.dart';
import 'package:business_bosses_v2/features/posts/widgets/userpost_tile.dart';
import 'package:business_bosses_v2/features/profile/widgets/boss_of_the_week_tile.dart';
import 'package:business_bosses_v2/utils/constants/constants.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';

class PostsWidget extends StatefulWidget {
  final Function(int)? onPageChange;
  const PostsWidget({super.key, this.onPageChange});

  @override
  State<PostsWidget> createState() => _PostsWidgetState();
}

class _PostsWidgetState extends State<PostsWidget> {
  final HomeController controller = Get.find();
  final MarketController marketController = Get.find();
  final LiveController liveEventController = Get.find();
  final CommunitiesController communitiesController = Get.find();
  final ScrollController _scrollController = ScrollController();
  final CourseController courseController = Get.put(CourseController());
  late Industry industry;
  final GlobalKey<State<CourseList>> courseListKey =
      GlobalKey<State<CourseList>>();
  final HomeController homeController = Get.find();
  final List<Color> startColors = <Color>[backgroundColor];

  @override
  void initState() {
    super.initState();
    industry =
        communitiesController.getCategoryIndustries(Constants.LEARNINGID)[2];

    // Add scroll listener
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 300 &&
          !controller.loadingMore.value) {
        // Call fetchPosts when near the end of the list
        controller.fetchPosts();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    if (courseListKey.currentState is CourseList) {
      (courseListKey.currentState as dynamic).pauseAllVideos();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      controller: _scrollController,
      itemCount: controller.mixedPosts.length + 2,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return Column(
            children: <Widget>[
              if (liveEventController.ongoing.isNotEmpty)
                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 26, 26, 26),
                  ),
                  margin: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.center, // Adjust alignment as needed
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Lottie.asset(
                          'assets/anim/liveevent.json',
                          height: 25,
                        ),
                      ),
                      const Expanded(
                        child: TextScroll(
                          '     Events - Create or Start listening to live events from bosses.           ',
                          mode: TextScrollMode.bouncing,
                          style: TextStyle(color: Colors.white, fontSize: 15),
                          velocity: Velocity(
                            pixelsPerSecond: Offset(30, 0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.grey.shade300),
                          ),
                          onPressed: () => Get.to(() => const LiveEvent()),
                          child: const Text(
                            'Live Events',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
            ],
          );
        }

        if (index == 1) {
          return const BossOfWeekProfileTile(
            isForyou: true,
          );
        }

        return _buildPostWidget(index - 2);
      },
    );
  }

  Widget _buildPostWidget(int postIndex) {
    // List to hold multiple widgets (ChallengeSection + Post)
    List<Widget> widgets = <Widget>[];

    if (postIndex == 3) {
      widgets.add(Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Get.to(() => const Bossuppartner());
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Deals',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: textColor,
                              fontSize: 16),
                        ),
                        Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: <Widget>[
                              Icon(Icons.chevron_right,
                                  color: textColor, size: 20),
                            ]),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  dealsSection(),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(height: 7, color: backgroundColor),
                ],
              ),
            ),
          ),
          // ProshopdealsWidget(
          //   isHome: true,
          //   caption: 'Featured Listing',
          //   combinedList: <Object>[
          //     ...marketController.proItems
          //       ..where((Object item) {
          //         if (item is Product) {
          //           return item.images != null &&
          //               item.images!.isNotEmpty &&
          //               item.images!.first.isNotEmpty &&
          //               (item).user!.isSubscribed;
          //         } else {
          //           return (item as Service).images != null &&
          //               (item).images!.isNotEmpty &&
          //               (item).images![0].isNotEmpty &&
          //               (item).user!.isSubscribed;
          //         }
          //       }).take(10).toList(),
          //   ],
          // ),
        ],
      ));
    }

    if (postIndex == 5) {
      widgets.add(const Column(
        children: <Widget>[
          RelevantPeopleTile(),
        ],
      ));
    }

    // if (postIndex != 0 && postIndex % 6 == 0) {
    //   widgets.add(Column(
    //     children: <Widget>[
    //       const ChallengesSection(backgroundColor: backgroundColor),
    //       Container(
    //         height: 10,
    //         color: backgroundColor,
    //       )
    //     ],
    //   ));
    // }

    final dynamic currentPost = controller.mixedPosts[postIndex];

    Widget postWidget;

    if (currentPost['type'] == 'post') {
      final PostModel post = controller.posts[currentPost['index']];

      // Handle regular non-promoted PostModel
      final PostModel nonPromotedPostModel = post;
      final bool hasIncrementedView = controller.itemsWithIncrementedViews
          .contains(nonPromotedPostModel.postId);
      postWidget = VisibilityDetector(
        key: Key(postIndex.toString()),
        onVisibilityChanged: (VisibilityInfo info) {
          if (info.visibleFraction == 1.0 && !hasIncrementedView) {
            controller.updateViews(nonPromotedPostModel);
            setState(() {
              controller.itemsWithIncrementedViews
                  .add(nonPromotedPostModel.postId);
            });
          }
        },
        child: PostTile(
          controller: controller,
          post: nonPromotedPostModel,
          onPageChange: (int page) {
            if (widget.onPageChange != null) {
              widget.onPageChange!(page);
            }
          },
        ),
      );
    } else if (currentPost['type'] == 'promotedPost') {
      final PostModel post = controller.promotedPosts[currentPost['index']];

      // Handle promoted PostModel
      final PostModel promotedPostModel = post;
      final bool hasIncrementedView = controller.itemsWithIncrementedViews
          .contains(promotedPostModel.postId);
      postWidget = VisibilityDetector(
        key: Key(postIndex.toString()),
        onVisibilityChanged: (VisibilityInfo info) {
          if (info.visibleFraction == 1.0 && !hasIncrementedView) {
            controller.updateViews(promotedPostModel);
            setState(() {
              controller.itemsWithIncrementedViews
                  .add(promotedPostModel.postId);
            });
          }
        },
        child: PostTile(
          controller: controller,
          post: promotedPostModel,
          onPageChange: (int page) {
            if (widget.onPageChange != null) {
              widget.onPageChange!(page);
            }
          },
        ),
      );
    } else if (currentPost['type'] == 'market') {
      final MarketModel post = controller.promotedMarkets[currentPost['index']];

      // Handle MarketModel
      final MarketModel marketModel = post;
      final bool hasIncrementedView =
          controller.itemsWithIncrementedViews.contains(marketModel.marketId);
      postWidget = VisibilityDetector(
        key: Key(postIndex.toString()),
        onVisibilityChanged: (VisibilityInfo info) {
          if (info.visibleFraction == 1.0 && !hasIncrementedView) {
            marketController.updatemarketViews(marketModel);
            setState(() {
              controller.itemsWithIncrementedViews.add(marketModel.marketId);
            });
          }
        },
        child: marketModel.isProduct
            ? MarketTile(
                controller: controller,
                post: marketModel,
              )
            : ServiceTile(
                controller: controller,
                post: marketModel,
              ),
      );
    } else if (currentPost['type'] == 'course') {
      final CourseModel post = controller.promotedCourses[currentPost['index']];

      // Handle CourseModel
      postWidget = Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: TextWidget(
              text: 'Sponsored',
              fontWeight: FontWeight.w700,
              size: 10,
            ),
          ),
          CourseItem(course: post),
        ],
      );
    } else {
      postWidget = const SizedBox();
    }

    widgets.add(postWidget);

    return Column(
      children: widgets,
    );
  }

  Widget dealsSection() {
    return Column(
      children: <Widget>[
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: homeController.bossUp!.reversed
                .toList()
                .map((Map<String, dynamic> item) {
              final Color startColor = startColors[
                  homeController.bossUp!.indexOf(item) % startColors.length];
              return LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return GestureDetector(
                    onTap: () async {
                      final Uri companyUrl = Uri.parse(item['companyUrl']);
                      if (!await launchUrl(companyUrl)) {
                        throw Exception('Could not launch $companyUrl');
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 4,
                      margin: const EdgeInsets.only(left: 10.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: startColor,
                          width: 1.0,
                        ),
                        gradient: LinearGradient(
                          colors: <Color>[startColor, backgroundColor],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8, top: 8, bottom: 5),
                                child: SizedBox(
                                  height: 35.0,
                                  width: 35.0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 0.5, color: Colors.black12),
                                      color: backgroundColor,
                                      borderRadius:
                                          BorderRadius.circular(100.0),
                                    ),
                                    child: NetworkImageWithPlaceHolder(
                                      imageUrl: item['companyPhoto'] ?? '',
                                      radius: 200,
                                      placeHolder: Icons.person,
                                      iconSize: 15.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 8.0, top: 8),
                                child: Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.white70,
                                      shape: BoxShape.circle),
                                  padding: const EdgeInsets.all(4),
                                  child: SvgPicture.asset(
                                    'assets/svgs/upicon.svg',
                                    color: const Color(0xFF0F132D),
                                    height: 8,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    item['companyName'],
                                    textAlign: TextAlign.left,
                                    maxLines: 2,
                                    style: const TextStyle(
                                      color: textColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                ],
                              )),
                          // Padding(
                          //   padding: const EdgeInsets.all(8),
                          //   child: SizedBox(
                          //     width: double.infinity,
                          //     child: Wrap(
                          //         crossAxisAlignment:
                          //             WrapCrossAlignment.center,
                          //         children: <Widget>[
                          //           Container(
                          //             decoration: const BoxDecoration(
                          //                 color: Colors.white,
                          //                 shape: BoxShape.circle),
                          //             padding: const EdgeInsets.all(4),
                          //             child: SvgPicture.asset(
                          //               'assets/svgs/upicon.svg',
                          //               color: const Color(0xFF0F132D),
                          //               height: 8,
                          //             ),
                          //           ),
                          //           const SizedBox(
                          //             width: 5,
                          //           ),
                          //           const Text(
                          //             'Learn more',
                          //             style: TextStyle(
                          //                 fontSize: 11, color: textColor),
                          //           ),
                          //         ]),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  );
                },
              );
              // : LayoutBuilder(
              //     builder: (BuildContext context, BoxConstraints constraints) {
              //       return GestureDetector(
              //         onTap: () async {
              //           final Uri companyUrl = Uri.parse(item['companyUrl']);
              //           if (!await launchUrl(companyUrl)) {
              //             throw Exception('Could not launch $companyUrl');
              //           }
              //         },
              //         child: Container(
              //           width: MediaQuery.of(context).size.width / 1.5,
              //           height: 120,
              //           margin: const EdgeInsets.only(left: 15.0),
              //           decoration: BoxDecoration(
              //             border: Border.all(
              //               color: Colors.black12,
              //               width: 0.5,
              //             ),
              //             gradient: LinearGradient(
              //               colors: <Color>[startColor, Colors.white],
              //               begin: Alignment.topRight,
              //               end: Alignment.bottomLeft,
              //             ),
              //             borderRadius: BorderRadius.circular(12),
              //           ),
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: <Widget>[
              //               Row(
              //                   crossAxisAlignment: CrossAxisAlignment.center,
              //                   children: <Widget>[
              //                     Padding(
              //                       padding: const EdgeInsets.only(
              //                           left: 10,
              //                           right: 10,
              //                           top: 10,
              //                           bottom: 5),
              //                       child: SizedBox(
              //                         height: 68.0,
              //                         width: 68.0,
              //                         child: Container(
              //                           decoration: BoxDecoration(
              //                             border: Border.all(
              //                                 width: 0.5,
              //                                 color: Colors.black12),
              //                             color: backgroundColor,
              //                             borderRadius:
              //                                 BorderRadius.circular(10.0),
              //                           ),
              //                           child: NetworkImageWithPlaceHolder(
              //                             imageUrl: item['companyPhoto'] ?? '',
              //                             radius: 10,
              //                             placeHolder: Icons.person,
              //                             iconSize: 15.0,
              //                             fit: BoxFit.cover,
              //                           ),
              //                         ),
              //                       ),
              //                     ),
              //                     Expanded(
              //                       child: Padding(
              //                         padding:
              //                             const EdgeInsets.only(right: 10.0),
              //                         child: Column(
              //                           crossAxisAlignment:
              //                               CrossAxisAlignment.start,
              //                           children: <Widget>[
              //                             Text(
              //                               item['companyName'],
              //                               softWrap: true,
              //                               textAlign: TextAlign.left,
              //                               maxLines: 1,
              //                               style: const TextStyle(
              //                                 color: textColor,
              //                                 fontSize: 13,
              //                                 fontWeight: FontWeight.w700,
              //                               ),
              //                               overflow: TextOverflow.ellipsis,
              //                             ),
              //                             Text(
              //                               item['companyDescription'],
              //                               softWrap: true,
              //                               textAlign: TextAlign.left,
              //                               maxLines: 3,
              //                               style: const TextStyle(
              //                                 color: textColor,
              //                                 fontSize: 12,
              //                               ),
              //                               overflow: TextOverflow.ellipsis,
              //                             ),
              //                           ],
              //                         ),
              //                       ),
              //                     ),
              //                   ]),
              //               Padding(
              //                 padding: const EdgeInsets.all(10),
              //                 child: SizedBox(
              //                   width: double.infinity,
              //                   child: Wrap(
              //                       crossAxisAlignment:
              //                           WrapCrossAlignment.center,
              //                       children: <Widget>[
              //                         Container(
              //                           decoration: const BoxDecoration(
              //                               color: Colors.white,
              //                               shape: BoxShape.circle),
              //                           padding: const EdgeInsets.all(4),
              //                           child: SvgPicture.asset(
              //                             'assets/svgs/upicon.svg',
              //                             // ignore: deprecated_member_use
              //                             color: const Color(0xFF0F132D),
              //                             height: 8,
              //                           ),
              //                         ),
              //                         const SizedBox(
              //                           width: 5,
              //                         ),
              //                         const Text(
              //                           'Learn more',
              //                           style: TextStyle(
              //                               fontSize: 11, color: textColor),
              //                         ),
              //                       ]),
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       );
              //     },
              //   );
            }).toList(),
          ),
        ),
        // Container(
        //   height: 7,
        //   color: backgroundColor,
        // ),
      ],
    );
  }
}
