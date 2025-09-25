import 'package:business_bosses_v2/analytics/presentation/analysescreen.dart';
import 'package:business_bosses_v2/common/models/my_response.dart';
import 'package:business_bosses_v2/common/models/my_title.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/common/widgets/data_selection_screen.dart';
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/common/widgets/text_widget.dart';
import 'package:business_bosses_v2/features/forum/models/forum_model.dart';
import 'package:business_bosses_v2/features/forum/widgets/forum_item.dart';

import 'package:business_bosses_v2/features/home/widgets/howtousetile.dart';
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

  const CompleteSearchingScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CompleteSearchingScreenState createState() =>
      _CompleteSearchingScreenState();
}

class _CompleteSearchingScreenState extends State<CompleteSearchingScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _filtertitle = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CompleteSearchController>(
      builder: (CompleteSearchController controller) {
        // Sort users with profile pictures first
        final List<UserModel> sortedUsers = controller.isUserSearch.value
            ? List.from(controller.searchedUsers)
            : List.from(controller.recommendedConnections);
        sortedUsers.sort((UserModel a, UserModel b) {
          if (a.photoUrl != null && a.photoUrl!.isNotEmpty) {
            return (b.photoUrl != null && b.photoUrl!.isNotEmpty) ? 0 : -1;
          } else {
            return (b.photoUrl != null && b.photoUrl!.isNotEmpty) ? 1 : 0;
          }
        });

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
                onChange: (String value) {
                  controller.query.value = value;
                  if (value.isEmpty) {
                    controller.clearUserSearch();
                  } else {
                    controller.search(currentIndex: _tabController.index);
                  }
                },
                onSubmit: (String value) {
                  controller.query.value = value;
                  controller.search(currentIndex: _tabController.index);
                },
              ),
              bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight + 50),
                  child: Column(
                    children: <Widget>[
                      const HowtouseTile(),
                      TabBar(
                        controller: _tabController,
                        tabs: const <Widget>[
                          Tab(
                            child: TextWidget(
                              text: 'People',
                              size: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Tab(
                            child: TextWidget(
                              text: 'Posts',
                              size: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
              actions: <Widget>[
                if (_tabController.index == 0)
                  IconButton(
                    onPressed: () {
                      _showFilterModal(controller);
                    },
                    icon: SvgPicture.asset('assets/svgs/filternoback.svg'),
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
                children: <Widget>[
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: <Widget>[
                        FilterUsers(
                          filterItems: sortedUsers,
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

  void _showFilterModal(CompleteSearchController controller) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
                height: 300,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        SvgPicture.asset('assets/svgs/filternoback.svg'),
                        const SizedBox(
                          width: 8,
                        ),
                        const Text(
                          'Filter',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    const Text(
                        'Select a category or profession to filter results',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 15),
                    GestureDetector(
                      onTap: () => _selectCategory(controller, setState),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              _filtertitle.isNotEmpty
                                  ? _filtertitle
                                  : 'Select Category',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const Icon(Icons.chevron_right)
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _filtertitle = '';
                            });
                            controller.resetData('');
                            Get.back();
                          },
                          child: const Text('Clear'),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            Get.back();
                            controller.resetData(_filtertitle);
                          },
                          child: const Text('Apply'),
                        ),
                      ],
                    ),
                  ],
                ));
          });
        });
  }

  void _selectCategory(
      CompleteSearchController controller, StateSetter setState) async {
    final MyResponse? res = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) =>
            const DataSelectionScreen(analyser: Analyser.category),
      ),
    );

    if (res != null && res.success) {
      MyTitle category = res.data;
      controller.selectedFilter.value = category.title ?? '';
      setState(() {
        _filtertitle = category.title ?? '';
      });
      controller.update();
    }
  }
}

/// FILTER FORUMS
class FilterForum extends StatelessWidget {
  final List<ForumModel> filterItems;
  final bool isLoading;

  /// CONSTRUCTOR
  const FilterForum({
    super.key,
    this.filterItems = const <ForumModel>[],
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return filterItems.isEmpty
        ? SafetyModel(
            icon: SvgPicture.asset(
              'assets/svgs/group.svg',
              height: 80.0,
              colorFilter: const ColorFilter.mode(
                hintColor,
                BlendMode.srcIn,
              ),
            ),
            title: 'No forum to show you',
            subTitle: 'Your search forums will be displayed here!',
            isLoading: isLoading,
          )
        : ListView.separated(
            key: ValueKey<List<ForumModel>>(filterItems),
            separatorBuilder: (_, __) => const SizedBox(height: 8.0),
            itemCount: filterItems.length,
            itemBuilder: (BuildContext context, int i) {
              return ForumItem(forum: filterItems[i]);
            },
          );
  }
}
