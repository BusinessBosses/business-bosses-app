import 'package:business_bosses_v2/features/donations/controller/donations_controller.dart';
import 'package:business_bosses_v2/features/donations/presentation/donations.dart';
import 'package:business_bosses_v2/features/donations/presentation/filterdonationposts.dart';
import 'package:business_bosses_v2/features/donations/presentation/filterdonationusers.dart';
import 'package:business_bosses_v2/features/forum/presentation/bossup_challenge.dart';
import 'package:business_bosses_v2/features/forum/widgets/forum_item.dart';
import 'package:business_bosses_v2/features/home/controller/commumities_controller.dart';
import 'package:business_bosses_v2/features/home/widgets/bottom_bar.dart';
import 'package:business_bosses_v2/features/home/widgets/challengessection.dart';
import 'package:business_bosses_v2/features/home/widgets/crowdfundsection.dart';
import 'package:business_bosses_v2/features/home/widgets/eventssection.dart';
import 'package:business_bosses_v2/features/home/widgets/industriessearch.dart';
import 'package:business_bosses_v2/features/home/widgets/learningpage.dart';
import 'package:business_bosses_v2/features/home/widgets/learningsection.dart';
import 'package:business_bosses_v2/features/live_event/presentation/live_event.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../common/widgets/safety_model.dart';
import '../../utils/theme/theme.dart';

import '../forum/models/industry.dart';
import '../search/widgets/search_bar.dart';

class AllCommunitiesScreen extends StatefulWidget {
  static const String routeName = '/all-communities-screen';
  final int? initialTabIndex;

  const AllCommunitiesScreen({Key? key, this.initialTabIndex})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AllCommunitiesScreenState createState() => _AllCommunitiesScreenState();
}

class _AllCommunitiesScreenState extends State<AllCommunitiesScreen>
    with TickerProviderStateMixin {
  bool _isSearching = false;
  bool _isSearchingDonations = false;
  Industry industry = Industry();
  bool isScrolled = true;

  final CommunitiesController _communitiesController =
      Get.put(CommunitiesController());
  final DonationsController donationsController =
      Get.put(DonationsController());
  late final TabController _searchTabController;
  late final TabController _donationsearchTabController;
  late final TabController _pageTabController;
  late final TabController _bossupTabController;

  List<Widget> get mActions {
    return <Widget>[
      if (!_isSearching)
        Padding(
          padding: const EdgeInsets.only(right: 8.0, bottom: 8, top: 8),
          child: GestureDetector(
            onTap: () => Get.toNamed(Routes.relevantusersscreen),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: backgroundcolorinterface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: <Widget>[
                  SvgPicture.asset('assets/svgs/collaborator.svg', height: 15),
                  const SizedBox(width: 5),
                  const Text(
                    'Find Collaborators',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      _pageTabController.index != 2
          ? GestureDetector(
              onTap: () {
                _isSearching = !_isSearching;
                setState(() {});
                _communitiesController.clearSearch();
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: _isSearching
                    ? const Icon(Icons.close)
                    : CircleAvatar(
                        radius: 20,
                        backgroundColor: backgroundColor,
                        child: SvgPicture.asset(
                          'assets/svgs/homesearch.svg',
                          height: 20,
                          color: textColor,
                        )),
              ),
            )
          : GestureDetector(
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: _isSearchingDonations
                    ? const Icon(Icons.close)
                    : CircleAvatar(
                        radius: 20,
                        backgroundColor: backgroundColor,
                        child: SvgPicture.asset(
                          'assets/svgs/homesearch.svg',
                          height: 20,
                          color: textColor,
                        )),
              ),
              onTap: () {
                _isSearchingDonations = !_isSearchingDonations;
                setState(() {});
                donationsController.searchedPosts.clear();
                donationsController.searchedUsers.clear();
              },
            ),
    ];
  }

  @override
  void initState() {
    super.initState();
    _searchTabController = TabController(length: 2, vsync: this);
    _donationsearchTabController = TabController(length: 2, vsync: this);
    _bossupTabController = TabController(length: 4, vsync: this);
    _pageTabController = TabController(
        length: 3, vsync: this, initialIndex: widget.initialTabIndex ?? 0);

    _pageTabController.addListener(() {
      setState(() {});
    });
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
                    length: _isSearching ? 2 : 3,
                    child: Scaffold(
                      backgroundColor: Colors.white,
                      appBar: AppBar(
                        automaticallyImplyLeading: false,
                        // shadowColor: Colors.black54,
                        // elevation: 0.1,
                        title: _isSearching
                            ? Searchbar(
                                hintText: 'Search',
                                onChange: (String query) {
                                  if (query.isEmpty) {
                                    controller.clearIIndustriesSearch();
                                    controller.clearIndustriesPostSearch();
                                  }
                                  setState(() {});
                                },
                                onSubmit: (String query) {
                                  controller.onsearchIndustries(query);
                                  controller.onsearchPosts(query);
                                },
                              )
                            : _isSearchingDonations &&
                                    _pageTabController.index == 2
                                ? Searchbar(
                                    hintText:
                                        'Search Donations Members or Posts',
                                    onChange: (String query) {
                                      if (query.isEmpty) {
                                        donationsController.clearUserSearch();
                                        donationsController.clearPostSearch();
                                      }
                                      setState(() {});
                                    },
                                    onSubmit: (String query) {
                                      donationsController.searchUsers(query);
                                      donationsController.searchPosts(query);
                                      setState(() {});
                                    },
                                  )
                                : const Text('Boss Up'),
                        actions: mActions,
                        // bottom: !_isSearching && !_isSearchingDonations
                        //     ? TabBar(
                        //         controller: _pageTabController,
                        //         labelStyle: const TextStyle(
                        //             fontWeight: FontWeight.w500),
                        //         labelColor: Colors.black,
                        //         tabs: const <Widget>[
                        //           Tab(text: 'Challenge'),
                        //           Tab(text: 'Learning'),
                        //           Tab(text: 'Crowdfund'),
                        //         ],
                        //       )
                        //     : _isSearchingDonations
                        //         ? TabBar(
                        //             controller: _donationsearchTabController,
                        //             labelStyle: const TextStyle(
                        //                 fontWeight: FontWeight.w500),
                        //             labelColor: Colors.black,
                        //             indicatorColor: primaryColorLT,
                        //             tabs: const <Widget>[
                        //               Tab(text: 'Projects'),
                        //               Tab(text: 'Members'),
                        //             ],
                        //           )
                        //         : TabBar(
                        //             controller: _searchTabController,
                        //             labelStyle: const TextStyle(
                        //                 fontWeight: FontWeight.w500),
                        //             labelColor: Colors.black,
                        //             tabs: const <Widget>[
                        //               Tab(text: 'Posts'),
                        //               Tab(text: 'Groups'),
                        //             ],
                        //           ),
                      ),
                      body: !_isSearching && !_isSearchingDonations
                          ? DefaultTabController(
                              length: 4,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.only(
                                        top: 0, bottom: 0, left: 0),
                                    constraints:
                                        const BoxConstraints.expand(height: 40),
                                    child: TabBar(
                                      labelStyle: const TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13),
                                      controller: _bossupTabController,
                                      isScrollable: false,

                                      // indicator: BoxDecoration(
                                      //   borderRadius: BorderRadius.circular(
                                      //       50), // Creates border
                                      //   color: Colors.black87.withAlpha(180),
                                      // ),
                                      // unselectedLabelColor: Colors.grey,
                                      // labelColor: Colors.white,
                                      labelPadding: const EdgeInsets.symmetric(
                                          horizontal: 0.0),
                                      tabs: const <Widget>[
                                        Tab(
                                          text: 'All',
                                        ),
                                        Tab(text: 'Challenges'),
                                        Tab(text: 'Learning'),
                                        Tab(text: 'Crowdfund'),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Expanded(
                                          child: TabBarView(
                                            controller: _bossupTabController,
                                            children: <Widget>[
                                              Container(
                                                color: backgroundColor,
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      ChallengesSection(
                                                        onTap: () {
                                                          setState(() {
                                                            _bossupTabController
                                                                .index = 1;
                                                          });
                                                        },
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      const LearningSection(),
                                                      const EventsSection(),
                                                      const SizedBox(
                                                        height: 25,
                                                      ),
                                                      CrowdfundSection(
                                                        onTap: () {
                                                          setState(() {
                                                            _bossupTabController
                                                                .index = 3;
                                                          });
                                                        },
                                                      ),
                                                      const SizedBox(
                                                        height: 100,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const BossupChallenge(
                                                ishome: false,
                                                backgroundColor:
                                                    backgroundColor,
                                              ),
                                              const LearningPage(),
                                              const DonationsPage(
                                                ishome: false,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          // TabBarView(
                          //     controller: _pageTabController,
                          //     children: <Widget>[
                          // controller.loading.value
                          //     ? const Center(
                          //         child: CircularProgressIndicator())
                          //     : const BossupChallenge(ishome: false,),

                          // const DonationsPage(),
                          //   ],
                          // )
                          : _isSearchingDonations
                              ? TabBarView(
                                  controller: _donationsearchTabController,
                                  children: <Widget>[
                                    Obx(
                                      () => FilterDonationPosts(
                                        filterItems:
                                            donationsController.searchedPosts,
                                        isLoading:
                                            donationsController.loading.value ||
                                                donationsController
                                                    .loadingPostsSearch.value,
                                      ),
                                    ),
                                    Obx(() => FilterDonationsUsers(
                                          members:
                                              donationsController.usersMembers,
                                          filterItems:
                                              donationsController.searchedUsers,
                                          isLoading: donationsController
                                                  .loading.value ||
                                              donationsController
                                                  .loadingSearch.value,
                                          onConnectionChange:
                                              donationsController.connectToUser,
                                          isSearch: donationsController
                                              .isUserSearch.value,
                                        )),
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
                                      child: controller.searchedForums.isEmpty
                                          ? SafetyModel(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              isLoading: controller
                                                  .loadingSearch.value,
                                              icon: SvgPicture.asset(
                                                  'assets/svgs/search.svg',
                                                  // ignore: deprecated_member_use
                                                  color: hintColor,
                                                  height: 80.0,
                                                  width: 80.0),
                                              title: 'Search for Posts',
                                              subTitle:
                                                  'Search for specific topics ',
                                            )
                                          : ListView.builder(
                                              key: const ValueKey<String>(
                                                  'cat.categoryId'),
                                              padding: const EdgeInsets.only(
                                                  top: 8.0,
                                                  right: 8.0,
                                                  left: 8.0,
                                                  bottom: 120.0),
                                              itemCount: controller
                                                  .searchedForums.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int i) {
                                                return ForumItem(
                                                    forum: controller
                                                        .searchedForums[i],
                                                    controller: controller);
                                              },
                                            ),
                                    ),
                                    Container(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      height: double.infinity,
                                      width: double.infinity,
                                      child: MySearchIndustries(
                                          searchIndustries:
                                              controller.searchedIndustries),
                                    ),
                                  ],
                                ),
                    ),
                  ),
                ),
                const BottomBar(activeIndex: 1),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchTabController.dispose();
    _pageTabController.dispose();
    super.dispose();
  }
}
