import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/common/widgets/text_widget.dart';
import 'package:business_bosses_v2/features/forum/models/forum_model.dart';
import 'package:business_bosses_v2/features/forum/widgets/forum_item.dart';
import 'package:business_bosses_v2/features/search/controller/search_controller.dart';
import 'package:business_bosses_v2/features/search/widgets/search_bar.dart';
import 'package:business_bosses_v2/features/search/widgets/filterusers.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../action/action.dart';
import '../widgets/filterposts.dart';

class CompleteSearchingScreen extends StatefulWidget {
  static const String routeName = '/completesearchingScreen';

  const CompleteSearchingScreen({Key? key}) : super(key: key);

  @override
  _CompleteSearchingScreenState createState() =>
      _CompleteSearchingScreenState();
}

class _CompleteSearchingScreenState extends State<CompleteSearchingScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  final bool _hasFilter = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CompleteSearchController>(
      builder: (CompleteSearchController controller) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: backgroundcolorinterface,
            appBar: AppBar(
              titleSpacing: 0.0,
              automaticallyImplyLeading: false,
              leadingWidth: 48.0,
              leading: IconButton(
                alignment: Alignment.centerRight,
                onPressed: () => navigateTo(context),
                icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
              ),
              title: Searchbar(
                hintText: 'Search',
                onChange: (String query) {
                  if (query.isEmpty) {
                    controller.clearUserSearch();
                  }
                },
                onSubmit: (String query) {
                  controller.search(query, currentIndex: _tabController.index);
                },
              ),
              bottom: TabBar(
                controller: _tabController,
                tabs: const <Widget>[
                  Tab(
                    child: TextWidget(
                      text: 'People',
                      size: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Tab(
                    child: TextWidget(
                      text: 'Posts',
                      size: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  // Tab(
                  //   child: TextWidget(
                  //     text: 'Forums',
                  //     size: 20,
                  //     fontWeight: FontWeight.w700,
                  //   ),
                  // ),
                ],
              ),
              actions: [
                if (_hasFilter)
                  IconButton(
                    icon: SvgPicture.asset('assets/svgs/filter.svg'),
                    onPressed: () {},
                  ),
              ],
            ),
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              onVerticalDragDown: (_) {
                FocusScope.of(context).unfocus();
              },
              child: Column(
                children: [
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        FilterUsers(
                          filterItems: controller.isUserSearch.value
                              ? controller.searchedUsers
                              : controller.recommendedConnections,
                          isLoading: controller.loading.value ||
                              controller.loadingSearch.value,
                          onConnectionChange: controller.connectToUser,
                          isSearch: controller.isUserSearch.value,
                        ),
                        FilterPosts(
                          filterItems: controller.isPostSearch.value
                              ? controller.searchedPosts
                              : controller.recommendedPosts,
                          isLoading: controller.loading.value ||
                              controller.loadingSearch.value,
                        ),
                        // FilterForum(
                        //   filterItems: controller.searchedForums,
                        //   isLoading: controller.loading.value ||
                        //       controller.loadingSearch.value,
                        // ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// FILTER POSTS
// class FilterPosts extends StatelessWidget {
//   final List<PostModel> filterItems;
//   final bool isLoading;

//   /// CONSTRUCTOR
//   const FilterPosts({
//     Key? key,
//     this.filterItems = const <PostModel>[],
//     this.isLoading = false,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final HomeController homeController = Get.find();
//     return filterItems.isEmpty
//         ? SafetyModel(
//             icon: const Icon(
//               Icons.edit,
//               size: 80.0,
//               color: hintColor,
//             ),
//             title: 'No post found',
//             subTitle: 'Your search posts will be displayed here!',
//             isLoading: isLoading,
//           )
//         : ListView.separated(
//             key: key,
//             separatorBuilder: (_, __) => const SizedBox(height: 8.0),
//             padding: const EdgeInsets.all(16.0),
//             itemCount: filterItems.length ?? 0,
//             itemBuilder: (BuildContext context, int i) {
//               return PostTile(
//                 post: filterItems[i],
//                 controller: homeController,
//               );
//             },
//           );
//   }
// }

/// FILTER FORUMS
class FilterForum extends StatelessWidget {
  final List<ForumModel> filterItems;
  final bool isLoading;

  /// CONSTRUCTOR
  const FilterForum({
    Key? key,
    this.filterItems = const <ForumModel>[],
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return filterItems.isEmpty
        ? SafetyModel(
            icon: SvgPicture.asset(
              'assets/svgs/group.svg',
              height: 80.0,
              color: hintColor,
            ),
            title: 'No forum to show you',
            subTitle: 'Your search forums will be displayed here!',
            isLoading: isLoading,
          )
        : ListView.separated(
            key: ValueKey(filterItems),
            separatorBuilder: (_, __) => const SizedBox(height: 8.0),
            itemCount: filterItems.length,
            itemBuilder: (BuildContext context, int i) {
              return ForumItem(forum: filterItems[i]);
            },
          );
  }
}
