import 'package:business_bosses_v2/bbpro/models/product_model.dart';
import 'package:business_bosses_v2/bbpro/models/service_model.dart';
import 'package:business_bosses_v2/bbpro/widgets/proshopdeals.dart';
import 'package:business_bosses_v2/common/widgets/text_widget.dart';
import 'package:business_bosses_v2/features/courses/controller/course_controller.dart';
import 'package:business_bosses_v2/features/courses/models/course_model.dart';
import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:business_bosses_v2/features/home/controller/commumities_controller.dart';
import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/home/widgets/course_item.dart';
import 'package:business_bosses_v2/features/home/widgets/course_list.dart';
import 'package:business_bosses_v2/features/home/widgets/herosection.dart';
import 'package:business_bosses_v2/features/home/widgets/relevantpeopletile.dart';
import 'package:business_bosses_v2/features/live_event/controller/live_event_controller.dart';
import 'package:business_bosses_v2/features/live_event/presentation/live_event.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/market_controller.dart';
import 'package:business_bosses_v2/features/marketplace/models/market_model.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/marketplace_item.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/service_item.dart';
import 'package:business_bosses_v2/features/posts/models/post_model.dart';
import 'package:business_bosses_v2/features/posts/widgets/userpost_tile.dart';
import 'package:business_bosses_v2/utils/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:visibility_detector/visibility_detector.dart';

class PostsWidget extends StatefulWidget {
  final Function(int)? onPageChange;
  final ScrollController scrollController;
  const PostsWidget(
      {super.key, this.onPageChange, required this.scrollController});

  @override
  State<PostsWidget> createState() => _PostsWidgetState();
}

class _PostsWidgetState extends State<PostsWidget> {
  final HomeController controller = Get.find();
  final MarketController marketController = Get.find();
  final LiveController liveEventController = Get.find();
  final CommunitiesController communitiesController = Get.find();
  final CourseController courseController = Get.put(CourseController());
  late Industry industry;
  final GlobalKey<State<CourseList>> courseListKey =
      GlobalKey<State<CourseList>>();

  // ************  ADD THIS  ************
  final Set<String> shownPromoted = <String>{};
  // ************************************

  @override
  void initState() {
    super.initState();
    industry =
        communitiesController.getCategoryIndustries(Constants.LEARNINGID)[2];

    widget.scrollController.addListener(() {
      if (widget.scrollController.position.pixels >=
              widget.scrollController.position.maxScrollExtent - 300 &&
          !controller.loadingMore.value) {
        controller.fetchPosts();
      }
    });
  }

  @override
  void dispose() {
    if (courseListKey.currentState is CourseList) {
      (courseListKey.currentState as dynamic).pauseAllVideos();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      controller: widget.scrollController,
      itemCount: controller.mixedPosts.length + 2,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return Column(
            children: <Widget>[
              if (liveEventController.ongoing.isNotEmpty)
                Container(
                  decoration: const BoxDecoration(color: Colors.black),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                            backgroundColor:
                                WidgetStateProperty.all<Color>(Colors.white),
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
          return Column(
            children: <Widget>[
              HeroSection(),
            ],
          );
        }

        return _buildPostWidget(index - 2);
      },
    );
  }

  Widget _buildPostWidget(int postIndex) {
    List<Widget> widgets = <Widget>[];

    if (postIndex == 3) {
      widgets.add(Column(
        children: <Widget>[
          ProshopdealsWidget(
            isHome: true,
            caption: 'Featured Listing',
            combinedList: <Object>[
              ...marketController.proItems
                ..where((Object item) {
                  if (item is Product) {
                    return item.images != null &&
                        item.images!.isNotEmpty &&
                        item.images!.first.isNotEmpty &&
                        (item).user!.isSubscribed;
                  } else {
                    return (item as Service).images != null &&
                        (item).images!.isNotEmpty &&
                        (item).images![0].isNotEmpty &&
                        (item).user!.isSubscribed;
                  }
                }).take(10).toList(),
            ],
          ),
          const SizedBox(
            height: 7,
          )
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

    final List<int> injectedPoints = <int>[3, 5];
    int subtract = injectedPoints.where((int e) => postIndex > e).length;

    final int mixedIndex = postIndex - subtract;

    if (mixedIndex < 0 || mixedIndex >= controller.mixedPosts.length) {
      return const SizedBox.shrink();
    }

    final dynamic currentPost = controller.mixedPosts[mixedIndex];

    Widget postWidget;

    if (currentPost['type'] == 'post') {
      final PostModel post = controller.posts[currentPost['index']];

      final bool hasIncrementedView =
          controller.itemsWithIncrementedViews.contains(post.postId);
      postWidget = VisibilityDetector(
        key: Key(postIndex.toString()),
        onVisibilityChanged: (VisibilityInfo info) {
          if (info.visibleFraction == 1.0 && !hasIncrementedView) {
            controller.updateViews(post);
            setState(() {
              controller.itemsWithIncrementedViews.add(post.postId);
            });
          }
        },
        child: PostTile(
          controller: controller,
          post: post,
          onPageChange: (int page) {
            widget.onPageChange?.call(page);
          },
        ),
      );
    } else if (currentPost['type'] == 'promotedPost') {
      final PostModel post = controller.promotedPosts[currentPost['index']];

      // ********* DUP PROTECTION *********
      if (shownPromoted.contains(post.postId)) {
        return const SizedBox.shrink();
      }
      shownPromoted.add(post.postId);
      // **********************************

      final bool hasIncrementedView =
          controller.itemsWithIncrementedViews.contains(post.postId);
      postWidget = VisibilityDetector(
        key: Key(postIndex.toString()),
        onVisibilityChanged: (VisibilityInfo info) {
          if (info.visibleFraction == 1.0 && !hasIncrementedView) {
            controller.updateViews(post);
            setState(() {
              controller.itemsWithIncrementedViews.add(post.postId);
            });
          }
        },
        child: PostTile(
          controller: controller,
          post: post,
          onPageChange: (int page) {
            widget.onPageChange?.call(page);
          },
        ),
      );
    } else if (currentPost['type'] == 'market') {
      final MarketModel post = controller.promotedMarkets[currentPost['index']];

      final bool hasIncrementedView =
          controller.itemsWithIncrementedViews.contains(post.marketId);
      postWidget = VisibilityDetector(
        key: Key(postIndex.toString()),
        onVisibilityChanged: (VisibilityInfo info) {
          if (info.visibleFraction == 1.0 && !hasIncrementedView) {
            marketController.updatemarketViews(post);
            setState(() {
              controller.itemsWithIncrementedViews.add(post.marketId);
            });
          }
        },
        child: post.isProduct
            ? MarketTile(
                controller: controller,
                post: post,
              )
            : ServiceTile(
                controller: controller,
                post: post,
              ),
      );
    } else if (currentPost['type'] == 'course') {
      final CourseModel post = controller.promotedCourses[currentPost['index']];

      postWidget = Column(
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
