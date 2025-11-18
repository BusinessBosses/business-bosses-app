import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/forum/models/forum_model.dart';
import 'package:business_bosses_v2/features/forum/presentation/create_forum_screen.dart';
import 'package:business_bosses_v2/features/forum/widgets/forum_item.dart';
import 'package:business_bosses_v2/features/invitepage/leaderboardpage.dart';
import 'package:business_bosses_v2/features/learningposts/controller/learningpostcontroller.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/products.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../home/controller/home_controller.dart';

class LearningPosts extends StatefulWidget {
  const LearningPosts({super.key});

  @override
  State<LearningPosts> createState() => _LearningPostsState();
}

class _LearningPostsState extends State<LearningPosts> {
  final ScrollController _scrollController = ScrollController();
  final LearningPostsController controller = Get.put(LearningPostsController());
  final HomeController hmeController = Get.find();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.8 &&
        !controller.loadingMore.value &&
        controller.hasMore.value) {
      controller.fetchLearningPosts(isLoadMore: true);
    }
  }

  Future<void> _refreshPosts() async {
    await controller.fetchLearningPosts();
  }

  Widget _buildFundingBanner() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(0.09),
              blurRadius: 100.0,
              spreadRadius: 5,
            )
          ],
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                      margin: const EdgeInsets.all(5),
                      height: 86,
                      width: 142,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl:
                              'https://images.pexels.com/photos/247819/pexels-photo-247819.jpeg',
                          fit: BoxFit.cover,
                          placeholder: (BuildContext context, _) =>
                              const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          errorWidget: (BuildContext context, _, __) =>
                              const Icon(Icons.broken_image,
                                  color: Colors.grey),
                        ),
                      )),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Text(
                        'Share learnings and resources for upskilling and mentorship',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                        softWrap: true,
                        maxLines: 5,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Get.to(LeaderboardScreen());
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(
                          LucideIcons.award,
                          size: 15,
                        ),
                        Text('Previous Winners',
                            style: const TextStyle(
                              fontSize: 13,
                              color: textColor,
                              fontWeight: FontWeight.w600,
                            ))
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      SvgPicture.asset(
                        'assets/svgs/entries.svg',
                        color: textColor,
                        height: 11.5,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Entries (${formatCount(controller.learningPosts.length)})',
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.to(CreateForumScreen());
                    },
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(90, 40)),
                    child: Row(
                      children: <Widget>[
                        const Text(
                          'Enter ',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 5),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
            Get.delete<LearningPostsController>();
          },
          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        ),
        centerTitle: true,
        title: const Text(
          'Learning',
          textAlign: TextAlign.center,
        ),
      ),
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.learningPosts.isEmpty) {
          return Column(
            children: <Widget>[
              _buildFundingBanner(),
              const Expanded(
                child: SafetyModel(
                  isLoading: false,
                  title: 'No posts',
                  subTitle: 'No learning posts available',
                ),
              ),
            ],
          );
        }

        return RefreshIndicator(
          onRefresh: _refreshPosts,
          child: ListView.builder(
            controller: _scrollController,
            itemCount: controller.learningPosts.length +
                2, // +1 for banner, +1 for loading
            itemBuilder: (BuildContext context, int i) {
              // First item is the funding banner
              if (i == 0) {
                return _buildFundingBanner();
              }

              // Adjust index for loading indicator
              final int adjustedIndex = i - 1;

              if (adjustedIndex == controller.learningPosts.length) {
                return controller.loadingMore.value
                    ? const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : const SizedBox.shrink();
              }

              final ForumModel post = controller.learningPosts[adjustedIndex];

              return VisibilityDetector(
                key: Key(post.forumId),
                onVisibilityChanged: (VisibilityInfo info) {
                  final bool hasIncrementedView = hmeController
                      .itemsWithIncrementedViews
                      .contains(post.forumId);
                  if (info.visibleFraction == 1.0 && !hasIncrementedView) {
                    controller.updatePostViews(post);
                    hmeController.itemsWithIncrementedViews.add(post.forumId);
                  }
                },
                child: ForumItem(
                  forum: post,
                  key: ValueKey(post.forumId),
                  controller: controller,
                  isBossUp: false,
                  isLearningpost: true,
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
