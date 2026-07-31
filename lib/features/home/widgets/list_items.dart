import 'package:business_bosses_v2/bbpro/widgets/proshopdeals.dart';
import 'package:business_bosses_v2/common/widgets/text_widget.dart';
import 'package:business_bosses_v2/features/courses/controller/course_controller.dart';
import 'package:business_bosses_v2/features/courses/models/course_model.dart';
import 'package:business_bosses_v2/features/donations/models/donations_model.dart';
import 'package:business_bosses_v2/features/donations/widgets/donation_item.dart';
import 'package:business_bosses_v2/features/forum/models/forum_model.dart';
import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:business_bosses_v2/features/home/controller/commumities_controller.dart';
import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/home/widgets/course_item.dart';
import 'package:business_bosses_v2/features/home/widgets/course_list.dart';
import 'package:business_bosses_v2/features/home/widgets/forum_item.dart';
import 'package:business_bosses_v2/features/home/widgets/hero_section.dart';
import 'package:business_bosses_v2/features/home/widgets/relevant_people_tile.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/market_controller.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/buyer_requests_deal.dart';
import 'package:business_bosses_v2/features/partners/widgets/deals_section.dart';
import 'package:business_bosses_v2/features/posts/models/post_model.dart';
import 'package:business_bosses_v2/features/posts/widgets/userpost_tile.dart';
import 'package:business_bosses_v2/utils/constants/constants.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

class PostsWidget extends StatefulWidget {
  final Function(int)? onPageChange;
  final ScrollController scrollController;

  /// Widget pinned above the feed (scrolls with it). Used by the "For you"
  /// home tab to show the performance / boss of the week cards.
  final Widget? header;

  /// The rotating hero card is hidden when the caller renders its own header
  /// (the header already carries the Boss of The Week card).
  final bool showHero;
  const PostsWidget({
    super.key,
    this.onPageChange,
    required this.scrollController,
    this.header,
    this.showHero = true,
  });

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
    final List<Industry> industries =
        communitiesController.getCategoryIndustries(Constants.LEARNINGID);
    if (industries.length > 2) {
      industry = industries[2];
    } else if (industries.isNotEmpty) {
      industry = industries[0];
    } else {
      // Create a dummy industry if none available yet to avoid late initialization error
      industry = Industry(
        industryId: '',
        industry: '',
        categoryId: Constants.LEARNINGID,
        description: '',
      );
    }

    // Add scroll listener. Kept in a field so it can be removed again — the
    // controller outlives this widget when it sits inside a TabBarView, and
    // stacked listeners would fire fetchPosts() once per rebuild.
    widget.scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!widget.scrollController.hasClients) return;
    if (widget.scrollController.position.pixels >=
            widget.scrollController.position.maxScrollExtent - 300 &&
        !controller.loadingMore.value) {
      controller.fetchPosts();
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    if (courseListKey.currentState is CourseList) {
      (courseListKey.currentState as dynamic).pauseAllVideos();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        builder: (HomeController controller) => ListView.builder(
              shrinkWrap: true,
              // Without this the list inherits the MediaQuery top inset and
              // leaves a blank band under the tab bar.
              padding: EdgeInsets.zero,
              controller: widget.scrollController,
              itemCount: controller.mixedPosts.length +
                  2 +
                  (controller.loadingMore.value ? 1 : 0),
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return widget.header ?? const SizedBox.shrink();
                }

                if (index == 1) {
                  return widget.showHero
                      ? HeroSection()
                      : const SizedBox.shrink();
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
          Padding(
            padding: const EdgeInsets.only(bottom: 7.0),
            child: DealsSection(),
          ),
          Container(
            height: 7,
            color: backgroundColor,
          ),
        ],
      ));
    }

    if (postIndex == 5) {
      widgets.add(Column(
        children: <Widget>[
          Obx(
            () => ProshopdealsWidget(
              isHome: true,
              caption: 'Featured Listing',
              combinedList: marketController.featuredItems.take(10).toList(),
            ),
          ),
          Container(
            height: 7,
            color: backgroundColor,
          ),
        ],
      ));
    }

    if (postIndex == 4) {
      widgets.add(BuyerRequestDealsWidget(
        isHome: true,
      ));
    }

    if (postIndex == 7) {
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
      final bool promoted = (currentPost['source'] == 'promoted');
      final CourseModel course = promoted
          ? controller.promotedCourses[currentPost['index']]
          : controller.courses[currentPost['index']];

      postWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (promoted)
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
    } else if (currentPost['type'] == 'donation') {
      final DonationModel donationModel =
          controller.donations[currentPost['index']];

      postWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DonationItem(
            donation: donationModel,
            isLastItem: false,
            isHome: true,
          )
        ],
      );
    } else if (currentPost['type'] == 'forum') {
      final ForumModel forumModel = controller.forums[currentPost['index']];
      final bool hasIncrementedView =
          controller.itemsWithIncrementedViews.contains(forumModel.forumId);

      postWidget = VisibilityDetector(
        key: Key(postIndex.toString()),
        onVisibilityChanged: (VisibilityInfo info) {
          if (info.visibleFraction == 1.0 && !hasIncrementedView) {
            controller.updateForumViews(forumModel);
            controller.itemsWithIncrementedViews.add(forumModel.forumId);
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ForumItem(
              forum: forumModel,
              controller: controller,
            )
          ],
        ),
      );
    } else {
      postWidget = const SizedBox();
    }

    widgets.add(postWidget);
    return Column(children: widgets);
  }
}
