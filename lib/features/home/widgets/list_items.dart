import 'package:business_bosses_v2/bbpro/widgets/proshopdeals.dart';
import 'package:business_bosses_v2/common/widgets/text_widget.dart';
import 'package:business_bosses_v2/features/courses/controller/course_controller.dart';
import 'package:business_bosses_v2/features/courses/models/course_model.dart';
import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:business_bosses_v2/features/home/controller/commumities_controller.dart';
import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/home/widgets/challengessection.dart';
import 'package:business_bosses_v2/features/home/widgets/course_item.dart';
import 'package:business_bosses_v2/features/home/widgets/course_list.dart';
import 'package:business_bosses_v2/features/home/widgets/relevantpeopletile.dart';
import 'package:business_bosses_v2/features/live_event/controller/live_event_controller.dart';
import 'package:business_bosses_v2/features/live_event/presentation/live_event.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/market_controller.dart';
import 'package:business_bosses_v2/features/marketplace/models/market_model.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/marketplace_item.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/service_item.dart';
import 'package:business_bosses_v2/features/posts/models/post_model.dart';
import 'package:business_bosses_v2/features/posts/widgets/userpost_tile.dart';
import 'package:business_bosses_v2/features/profile/widgets/boss_of_the_week_tile.dart';
import 'package:business_bosses_v2/utils/constants/constants.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:text_scroll/text_scroll.dart';
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
          ProshopdealsWidget(
            isHome: true,
            caption: 'Featured Listing',
            combinedList: <Object>[
              ...marketController.proProducts.take(5).toList(),
              ...marketController.proServices.take(5).toList(),
            ],
          ),
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
}
