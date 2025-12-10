import 'package:business_bosses_v2/bbpro/widgets/drawercontent.dart';
import 'package:business_bosses_v2/features/donations/controller/donations_controller.dart';
import 'package:business_bosses_v2/features/donations/presentation/filterdonationposts.dart';
import 'package:business_bosses_v2/features/donations/presentation/filterdonationusers.dart';
import 'package:business_bosses_v2/features/forum/presentation/bossup_challenge.dart';
import 'package:business_bosses_v2/features/forum/widgets/forum_item.dart';
import 'package:business_bosses_v2/features/home/controller/commumities_controller.dart';
import 'package:business_bosses_v2/features/home/widgets/industriessearch.dart';
import 'package:business_bosses_v2/features/premium/premiumscreen.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/features/search/presentation/complete_searching_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../common/widgets/safety_model.dart';
import '../../utils/theme/theme.dart';
import '../forum/models/industry.dart';
import '../search/widgets/search_bar.dart';

class AllCommunitiesScreen extends StatefulWidget {
  static const String routeName = '/all-communities-screen';
  final int? initialTabIndex;
  final int? initialBossupTabIndex;

  const AllCommunitiesScreen(
      {super.key, this.initialTabIndex, this.initialBossupTabIndex});

  @override
  // ignore: library_private_types_in_public_api
  _AllCommunitiesScreenState createState() => _AllCommunitiesScreenState();
}

class _AllCommunitiesScreenState extends State<AllCommunitiesScreen>
    with TickerProviderStateMixin {
  final bool _isSearching = false;
  final bool _isSearchingDonations = false;
  Industry industry = Industry();
  bool isScrolled = true;

  final ProfileController profileController = Get.put(ProfileController());

  // ignore: unused_field
  final CommunitiesController _communitiesController =
      Get.put(CommunitiesController());
  final DonationsController donationsController =
      Get.put(DonationsController());
  late final TabController _searchTabController;
  late final TabController _donationsearchTabController;
  late final TabController _pageTabController;
  late final TabController _bossupTabController;
  final AdvancedDrawerController _advancedDrawerController =
      AdvancedDrawerController();

  List<Widget> get mActions {
    return <Widget>[
      Padding(
        padding: const EdgeInsets.only(right: 15.0, bottom: 8, top: 8),
        child: GestureDetector(
          onTap: () => Get.to(CompleteSearchingScreen()),
          child: CircleAvatar(
              radius: 16,
              backgroundColor: backgroundColor,
              child:
                  SvgPicture.asset('assets/svgs/collaborator.svg', height: 15)),
        ),
      ),
      if (!profileController.myProfile.isSubscribed)
        Padding(
          padding: const EdgeInsets.only(right: 15.0, bottom: 8, top: 8),
          child: GestureDetector(
            onTap: () {
              Get.bottomSheet(
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.9,
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                            padding:
                                EdgeInsets.only(left: 0.0, top: 0, bottom: 10),
                            child: PremiumScreen()),
                      ],
                    ),
                  ),
                ),
                backgroundColor: Colors.white,
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: backgroundcolorinterface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: <Widget>[
                  SvgPicture.asset(
                    'assets/svgs/growfilled.svg',
                    height: 15,
                    color: primaryColorLT,
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    'Grow',
                    style: TextStyle(
                      color: primaryColorLT,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
    ];
  }

  @override
  void initState() {
    super.initState();
    _searchTabController = TabController(length: 2, vsync: this);
    _donationsearchTabController = TabController(length: 2, vsync: this);
    _bossupTabController = TabController(
        length: 1,
        vsync: this,
        initialIndex: widget.initialBossupTabIndex ?? 0);

    _bossupTabController.addListener(() {
      setState(() {});
    });
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
        return AdvancedDrawer(
          backdrop: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  Colors.white,
                  Colors.white.withValues(alpha: 0.2)
                ],
              ),
            ),
          ),
          controller: _advancedDrawerController,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 300),
          animateChildDecoration: true,
          rtlOpening: false,
          // openScale: 1.0,
          disabledGestures: false,
          childDecoration: const BoxDecoration(
            // NOTICE: Uncomment if you want to add shadow behind the page.
            // Keep in mind that it may cause animation jerks.
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black12,
                blurRadius: 3,
              ),
            ],
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),

          drawer: DrawerContent(
            oncrowfundclick: () {
              setState(() {
                _bossupTabController.index = 3;
              });
            },
            oncloseclick: () {
              _advancedDrawerController.hideDrawer();
            },
            currentuser: profileController.myProfile,
            hasUnreadNotification:
                profileController.myProfile.unReadCount != null &&
                    profileController.myProfile.unReadCount! > 0,
          ),

          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,
              leading: IconButton(
                onPressed: () {
                  Get.back(closeOverlays: false);
                },
                icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
              ),
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
                  : _isSearchingDonations && _pageTabController.index == 2
                      ? Searchbar(
                          hintText: 'Search Donations Members or Posts',
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
                      : const Text(
                          'Boss Up',
                          style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.w900,
                              fontSize: 20),
                        ),
              actions: mActions,
            ),
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
                      child: Column(
                        children: <Widget>[
                          if (_isSearchingDonations)
                            TabBar(
                              controller: _donationsearchTabController,
                              labelStyle:
                                  const TextStyle(fontWeight: FontWeight.w500),
                              labelColor: Colors.black,
                              indicatorColor: primaryColorLT,
                              tabs: const <Widget>[
                                Tab(text: 'Projects'),
                                Tab(text: 'Members'),
                              ],
                            )
                          else if (_isSearching)
                            TabBar(
                              controller: _searchTabController,
                              labelStyle:
                                  const TextStyle(fontWeight: FontWeight.w500),
                              labelColor: Colors.black,
                              tabs: const <Widget>[
                                Tab(text: 'Posts'),
                                Tab(text: 'Groups'),
                              ],
                            ),
                          Expanded(
                            child: _isSearching || _isSearchingDonations
                                ? TabBarView(
                                    controller: _isSearching
                                        ? _searchTabController
                                        : _donationsearchTabController,
                                    children: <Widget>[
                                      if (_isSearching)
                                        Container(
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          height: double.infinity,
                                          width: double.infinity,
                                          child: controller
                                                  .searchedForums.isEmpty
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
                                                  padding:
                                                      const EdgeInsets.only(
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
                                        )
                                      else
                                        Obx(
                                          () => FilterDonationPosts(
                                            filterItems: donationsController
                                                .searchedPosts,
                                            isLoading: donationsController
                                                    .loading.value ||
                                                donationsController
                                                    .loadingPostsSearch.value,
                                          ),
                                        ),
                                      if (_isSearching)
                                        Container(
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          height: double.infinity,
                                          width: double.infinity,
                                          child: MySearchIndustries(
                                              searchIndustries: controller
                                                  .searchedIndustries),
                                        )
                                      else
                                        Obx(() => FilterDonationsUsers(
                                              members: donationsController
                                                  .usersMembers,
                                              filterItems: donationsController
                                                  .searchedUsers,
                                              isLoading: donationsController
                                                      .loading.value ||
                                                  donationsController
                                                      .loadingSearch.value,
                                              onConnectionChange:
                                                  donationsController
                                                      .connectToUser,
                                              isSearch: donationsController
                                                  .isUserSearch.value,
                                            )),
                                    ],
                                  )
                                : Column(
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          children: <Widget>[
                                            Expanded(
                                              child: TabBarView(
                                                controller:
                                                    _bossupTabController,
                                                children: <Widget>[
                                                  const BossupChallenge(
                                                    ishome: false,
                                                    backgroundColor:
                                                        backgroundColor,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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
