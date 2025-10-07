import 'package:business_bosses_v2/features/posts/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:business_bosses_v2/features/search/controller/search_controller.dart';
import 'package:business_bosses_v2/features/search/widgets/filterposts.dart';
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';

class PostsTab extends StatelessWidget {
  final CompleteSearchController controller;

  const PostsTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final List<PostModel> posts = controller.isPostSearch.value
        ? controller.searchedPosts
        : controller.recommendedPosts;

    final bool isLoading =
        controller.loading.value || controller.loadingSearch.value;

    if (!isLoading && posts.isEmpty) {
      return SafetyModel(
        icon: SvgPicture.asset(
          'assets/svgs/post.svg',
          height: 80.0,
          colorFilter: const ColorFilter.mode(hintColor, BlendMode.srcIn),
        ),
        title: 'No posts found',
        subTitle: 'Try searching with a different keyword!',
        isLoading: false,
      );
    }

    return FilterPosts(
      filterItems: posts,
      isLoading: isLoading,
    );
  }
}
