import 'package:flutter/material.dart';

import '../../../common/widgets/safety_model.dart';
import '../../../utils/theme/theme.dart';
import '../../posts/models/post_model.dart';

class FilterPosts extends StatelessWidget {
  final List<PostModel> filterItems;
  final bool isLoading;

  // ignore: public_member_api_docs
  const FilterPosts({
    Key? key,
    this.filterItems = const [],
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('FilterPosts.build: $filterItems');
    return filterItems.isEmpty
        ? SafetyModel(
            icon: const Icon(
              Icons.edit,
              size: 80.0,
              color: hintColor,
            ),
            title: 'No post found',
            subTitle: 'Your search posts will be displayed here!',
            isLoading: isLoading,
          )
        : ListView.separated(
            key: key,
            separatorBuilder: (_, __) => const SizedBox(height: 8.0),
            padding: const EdgeInsets.all(16.0),
            itemCount: filterItems.length ?? 0,
            itemBuilder: (BuildContext context, int i) {
              return Container();
              // UpdatedPostItem(
              //     post: filterItems[i],
              //     onLikeTap: (PostModel latestPost) {
              //       filterItems[i] = latestPost;
              //     },
              //     onComment: (PostModel latestPost) {
              //       filterItems[i] = latestPost;
              //     });
            },
          );
  }
}
