import 'package:business_bosses_v2/features/search/controller/search_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/safety_model.dart';
import '../../../navigation/routes.dart';
import '../../../utils/theme/theme.dart';
import '../../home/controller/home_controller.dart';
import '../../posts/models/post_model.dart';
import '../../posts/widgets/post_grid_item.dart';
import '../../posts/widgets/userpost_tile.dart';

class FilterPosts extends StatelessWidget {
  final List<PostModel> filterItems;
  final bool isLoading;
  final bool isSearch;

  /// CONSTRUCTOR
  const FilterPosts({
    super.key,
    this.filterItems = const <PostModel>[],
    this.isLoading = false,
    this.isSearch = false,
  });

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find();
    final CompleteSearchController controller = Get.find();
    return controller.isClosed
        ? SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: const Padding(
                    padding: EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 0),
                    child: Text(
                      'Recommended Posts',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                  ),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                  ),
                  padding: const EdgeInsets.only(
                      top: 2.0, bottom: 120, left: 10, right: 10),
                  itemCount: 6,
                  itemBuilder: (BuildContext context, int index) {
                    return PostGridItem(
                      hasMore: false,
                      post: PostModel(
                          postId: 'postId',
                          title: 'title',
                          timestamp: 78,
                          isRanked: false,
                          promotionDuration: 56),
                      onTap: () {
                        Get.toNamed(Routes.postDetails, arguments: 'posts[i]');
                      },
                    );
                  },
                ),
              ],
            ),
          )
        : filterItems.isEmpty
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
                separatorBuilder: (_, __) => const SizedBox(height: 7.0),
                itemCount: filterItems.length,
                itemBuilder: (BuildContext context, int i) {
                  return PostTile(
                    post: filterItems[i],
                    controller: homeController,
                  );
                },
              );
  }
}
