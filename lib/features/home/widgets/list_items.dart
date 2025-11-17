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
import 'package:business_bosses_v2/features/home/widgets/hero_section.dart';
import 'package:business_bosses_v2/features/home/widgets/relevantpeopletile.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/market_controller.dart';
import 'package:business_bosses_v2/features/posts/models/post_model.dart';
import 'package:business_bosses_v2/features/posts/widgets/userpost_tile.dart';
import 'package:business_bosses_v2/utils/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  final CommunitiesController communitiesController = Get.find();
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
    return Obx(() => ListView.builder(
          shrinkWrap: true,
          controller: widget.scrollController,
          itemCount: controller.mixedPosts.length +
              2 +
              (controller.loadingMore.value ? 1 : 0),
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Column(children: <Widget>[]);
            }

            if (index == 1) {
              return Column(children: <Widget>[HeroSection()]);
            }

            // Loader at the bottom when loadingMore is true
            if (index == controller.mixedPosts.length + 2 &&
                controller.loadingMore.value) {
              return const Padding(
                padding: EdgeInsets.only(bottom: 100),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            return _buildPostWidget(index - 2);
          },
        ));
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
                        item.user!.isSubscribed;
                  } else {
                    return (item as Service).images != null &&
                        item.images!.isNotEmpty &&
                        item.images![0].isNotEmpty &&
                        item.user!.isSubscribed;
                  }
                }).take(10).toList(),
            ],
          ),
          const SizedBox(height: 7),
        ],
      ));
    }

    if (postIndex == 5) {
      widgets.add(const Column(children: <Widget>[RelevantPeopleTile()]));
    }

    final dynamic currentPost = controller.mixedPosts[postIndex];
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
            controller.itemsWithIncrementedViews.add(post.postId);
          }
        },
        child: PostTile(
          controller: controller,
          post: post,
          onPageChange: widget.onPageChange,
        ),
      );
    } else if (currentPost['type'] == 'promotedPost') {
      final PostModel post = controller.promotedPosts[currentPost['index']];
      final bool hasIncrementedView =
          controller.itemsWithIncrementedViews.contains(post.postId);

      postWidget = VisibilityDetector(
        key: Key(postIndex.toString()),
        onVisibilityChanged: (VisibilityInfo info) {
          if (info.visibleFraction == 1.0 && !hasIncrementedView) {
            controller.updateViews(post);
            controller.itemsWithIncrementedViews.add(post.postId);
          }
        },
        child: PostTile(
          controller: controller,
          post: post,
          onPageChange: widget.onPageChange,
        ),
      );
    } else if (currentPost['type'] == 'course') {
      final CourseModel course =
          controller.promotedCourses[currentPost['index']];

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
          CourseItem(course: course),
        ],
      );
    } else {
      postWidget = const SizedBox();
    }

    widgets.add(postWidget);
    return Column(children: widgets);
  }
}
