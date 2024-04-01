import 'package:business_bosses_v2/features/forum/presentation/bossup_challenge.dart';
import 'package:business_bosses_v2/features/forum/widgets/forum_item.dart';
import 'package:business_bosses_v2/features/home/controller/commumities_controller.dart';
import 'package:business_bosses_v2/features/home/widgets/bottom_bar.dart';
import 'package:business_bosses_v2/features/home/widgets/industriessearch.dart';
import 'package:business_bosses_v2/utils/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../common/widgets/safety_model.dart';
import '../../common/widgets/tiles/custom_tile.dart';
import '../../navigation/routes.dart';
import '../../utils/theme/theme.dart';

import '../forum/models/industry.dart';
import '../search/widgets/search_bar.dart';

// ignore: public_member_api_docs
class AllCommunitiesScreen extends StatefulWidget {
  // ignore: public_member_api_docs
  static const String routeName = '/all-communities-screen';

  // ignore: public_member_api_docs
  const AllCommunitiesScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AllCommunitiesScreenState createState() => _AllCommunitiesScreenState();
}

class _AllCommunitiesScreenState extends State<AllCommunitiesScreen>
    with TickerProviderStateMixin {
  bool _isSearching = false;
  Industry industry = Industry();
  bool isScrolled = true;

  final CommunitiesController _communitiesController =
      Get.put(CommunitiesController());
  late final TabController _searchTabController;

  List<Widget> get mActions {
    return <Widget>[
      IconButton(
        icon: _isSearching
            ? const Icon(Icons.close)
            : SvgPicture.asset(
                'assets/svgs/search.svg',
              ),
        onPressed: () {
          // if (_isSearching) {
          _isSearching = !_isSearching;
          // }
          setState(() {});
          _communitiesController.clearSearch();
        },
      ),
    ];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchTabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommunitiesController>(
      builder: (CommunitiesController controller) {
        return Scaffold(
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: DefaultTabController(
                      length: _isSearching ? 2 : 3, // number of tabs
                      child: Scaffold(
                          backgroundColor: backgroundcolorinterface,
                          appBar: AppBar(
                            automaticallyImplyLeading: false,
                            title: _isSearching
                                ? Searchbar(
                                    hintText: 'Search',
                                    onChange: (String query) {
                                      if (_searchTabController.index == 0) {
                                        controller.onSearch(
                                            _searchTabController.index, query);
                                      }
                                    },
                                    onSubmit: (String query) {
                                      if (_searchTabController.index == 1) {
                                        controller.onSearch(
                                            _searchTabController.index, query);
                                      }
                                    },
                                  )
                                : const Text('Boss Up'),
                            actions: mActions,
                            bottom: !_isSearching
                                ? const TabBar(
                                    labelStyle:
                                        TextStyle(fontWeight: FontWeight.w500),
                                    labelColor: Colors.black,
                                    tabs: <Widget>[
                                        Tab(
                                          text: 'Challenge',
                                        ),
                                        Tab(
                                          text: 'Learning',
                                        ),
                                        Tab(
                                          text: 'Opportunities',
                                        ),
                                      ])
                                : TabBar(
                                    controller: _searchTabController,
                                    labelStyle: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                    labelColor: Colors.black,
                                    tabs: const <Widget>[
                                      Tab(
                                        text: 'Groups',
                                      ),
                                      Tab(
                                        text: 'Topics',
                                      ),
                                    ],
                                  ),
                          ),
                          body: !_isSearching
                              ? TabBarView(
                                  children: <Widget>[
                                    // content of Tab 1
                                    controller.loading.value
                                        ? const Center(
                                            child: CircularProgressIndicator(),
                                          )
                                        : BossupChallenge(),
                                    // content of Tab 2
                                    Padding(
                                      padding: const EdgeInsets.only(
                                           left: 15, right: 15),
                                      child: controller.loading.value
                                          ? SafetyModel(
                                              isLoading:
                                                  controller.loading.value,
                                              title: '',
                                            )
                                          : controller.error.value
                                              ? SafetyModel(
                                                  isLoading: false,
                                                  title: 'Something went wrong',
                                                  clickableText: 'Reload',
                                                  onTap: () async {
                                                    await controller
                                                        .fetchIndustries();
                                                  },
                                                )
                                              : GridView.builder(
                                                  itemCount: controller
                                                      .getCategoryIndustries(
                                                          Constants.LEARNINGID)
                                                      .length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return CustomTile(
                                                      label: controller
                                                          .getCategoryIndustries(
                                                              Constants
                                                                  .LEARNINGID)[
                                                              index]
                                                          .industry!,
                                                      photo: controller
                                                          .getCategoryIndustries(
                                                              Constants
                                                                  .LEARNINGID)[
                                                              index]
                                                          .photo!,
                                                      onTap: () {
                                                        Get.toNamed(
                                                          Routes.allforumscreen,
                                                          arguments: controller
                                                              .getCategoryIndustries(
                                                                  Constants
                                                                      .LEARNINGID)[index],
                                                        );
                                                      },
                                                    );
                                                  },
                                                  gridDelegate:
                                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                                    mainAxisSpacing: 15.0,
                                                    crossAxisSpacing: 15.0,
                                                    crossAxisCount: 2,
                                                  ),
                                                ),
                                    ),
                                    // content of Tab 3
                                    Padding(
                                      padding: const EdgeInsets.only(
                                       left: 15, right: 15),
                                      child: controller.loading.value
                                          ? SafetyModel(
                                              isLoading:
                                                  controller.loading.value,
                                              title: '',
                                            )
                                          : controller.error.value
                                              ? SafetyModel(
                                                  isLoading: false,
                                                  title: 'Something went wrong',
                                                  clickableText: 'Reload',
                                                  onTap: () async {
                                                    await controller
                                                        .fetchIndustries();
                                                  },
                                                )
                                              : GridView.builder(
                                                  itemCount: controller
                                                      .getCategoryIndustries(
                                                          Constants
                                                              .OPPORTUNITIESID)
                                                      .length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return CustomTile(
                                                      label: controller
                                                          .getCategoryIndustries(
                                                              Constants
                                                                  .OPPORTUNITIESID)[
                                                              index]
                                                          .industry!,
                                                      photo: controller
                                                          .getCategoryIndustries(
                                                              Constants
                                                                  .OPPORTUNITIESID)[
                                                              index]
                                                          .photo!,
                                                      onTap: () {
                                                        Get.toNamed(
                                                            Routes
                                                                .allforumscreen,
                                                            arguments: controller
                                                                .getCategoryIndustries(
                                                                    Constants
                                                                        .OPPORTUNITIESID)[index]);
                                                      },
                                                    );
                                                  },
                                                  gridDelegate:
                                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                                    mainAxisSpacing: 15.0,
                                                    crossAxisSpacing: 15.0,
                                                    crossAxisCount: 2,
                                                  ),
                                                ),
                                    ),
                                  ],
                                )
                              : TabBarView(
                                  controller: _searchTabController,
                                  children: <Widget>[
                                    Container(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      height: double.infinity,
                                      width: double.infinity,
                                      child: MySearchIndustries(
                                          searchIndustries:
                                              controller.searchedIndustries),
                                    ),
                                    Container(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      height: double.infinity,
                                      width: double.infinity,
                                      child: controller.searchedForums.isEmpty
                                          ? SafetyModel(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              isLoading: controller
                                                  .loadingSearch.value,
                                              icon: SvgPicture.asset(
                                                  'assets/svgs/search.svg',
                                                  color: hintColor,
                                                  height: 80.0,
                                                  width: 80.0),
                                              title:
                                                  'Search for Category name', //'Search for ${cat.category.toLowerCase()}',
                                              subTitle:
                                                  'Search for specific topic of Category name',
                                              //'Search for specific topic of ${cat.category.toLowerCase()}',
                                            )
                                          : ListView.builder(
                                              key: const ValueKey(
                                                  'cat.categoryId'),
                                              padding: const EdgeInsets.only(
                                                top: 8.0,
                                                right: 8.0,
                                                left: 8.0,
                                                bottom: 120.0,
                                              ),
                                              itemCount: controller
                                                  .searchedForums.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int i) {
                                                return ForumItem(
                                                  forum: controller
                                                      .searchedForums[i],
                                                  controller: controller,
                                                );
                                                // return ForumItem(
                                                //   _searchTopics[i],
                                                //   key: ValueKey(_searchTopics[i].forumId),
                                                //   onLikeTap: (ForumModel latestForum) {
                                                //     _searchTopics[i].likes = latestForum.likes;
                                                //     setState(() {});
                                                //   },
                                                //   onCommentSent: (ForumModel latestForum) {
                                                //     _searchTopics[i].comments = latestForum.comments;
                                                //     setState(() {});
                                                //   },
                                                // );
                                              },
                                            ),
                                    ),
                                  ],
                                ))),
                ),
                const BottomBar(
                  activeIndex: 1,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _searchTabController.dispose();
    super.dispose();
  }

  void _onChanged(String value) {}
}
