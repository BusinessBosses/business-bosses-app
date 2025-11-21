import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/presentation/bottom_nav_screen.dart';
import 'package:business_bosses_v2/bbpro/widgets/drawercontent.dart';
import 'package:business_bosses_v2/bbpro/widgets/menubutton.dart';
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/donations/widgets/donation_item.dart';
import 'package:business_bosses_v2/features/home/widgets/bottom_bar.dart';
import 'package:business_bosses_v2/features/home/widgets/course_item.dart';
import 'package:business_bosses_v2/features/marketplace/models/buyer_request_model.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/features/profile/widgets/profileinfodisplay.dart';
import 'package:business_bosses_v2/features/profile/widgets/profilepostsdisplay.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../common/widgets/tiles/outlinebuttonheader.dart';
import '../../marketplace/controllers/market_controller.dart';
import '../widgets/my_profile_header.dart';

bool isExpanded = false;

// ignore: public_member_api_docs
class MyProfileScreen extends StatefulWidget {
  final int? selectedIndex;
  final int? currentIndex;

  static const String routeName = '/my-profile-screen';

  const MyProfileScreen({super.key, this.selectedIndex, this.currentIndex});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final ProfileController profileController = Get.find();
  final MarketController marketController = Get.find();
  final ShopController shopController = Get.find();
  final HomeController homeController = Get.find();

  final AdvancedDrawerController _advancedDrawerController =
      AdvancedDrawerController();

  bool loading = true;
  int _currentIndex = 0;
  int? _selectedIndex;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();

    _currentIndex = widget.currentIndex ?? 0;
    _selectedIndex = widget.selectedIndex ?? 0;

    _pageController = PageController(initialPage: _currentIndex);

    if (shopController.shop == null) {
      shopController.initShop().then((_) {
        setState(() => loading = false);
      });
    } else {
      loading = false;
    }
    if (homeController.myRequests.isEmpty) {
      homeController.loadMyRequests();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (_) {
        return AdvancedDrawer(
          controller: _advancedDrawerController,
          backdrop: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  Colors.white,
                  Colors.white.withValues(alpha: 0.2)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          childDecoration: const BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(color: Colors.black12, blurRadius: 3)
            ],
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          drawer: DrawerContent(
            oncloseclick: () => _advancedDrawerController.hideDrawer(),
            currentuser: homeController.profileController.myProfile,
            hasUnreadNotification:
                profileController.myProfile.unReadCount != null &&
                    profileController.myProfile.unReadCount! > 0,
          ),
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: _buildAppBar(),
            body: loading
                ? const SafetyModel()
                : PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (int i) => setState(() {
                      _currentIndex = i;
                    }),
                    children: <Widget>[
                      _buildProfileView(context),
                      Bottomnavscreen(
                        initialindex: 0,
                        onTabChanged: (int index) {
                          setState(() => _selectedIndex = index);
                        },
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final bool showHeader = _selectedIndex == 0 || _selectedIndex == 4;

    return PreferredSize(
      preferredSize: Size.fromHeight(showHeader ? kToolbarHeight : 0),
      child: showHeader
          ? Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Center(
                    child: CupertinoSlidingSegmentedControl<int>(
                      padding: const EdgeInsets.all(5),
                      backgroundColor: backgroundColor,
                      groupValue: _currentIndex,
                      children: <int, Widget>{
                        0: _segmentLabel('Profile', _currentIndex == 0),
                        1: _segmentLabel('My-Biz', _currentIndex == 1),
                      },
                      onValueChanged: (int? v) {
                        if (v != null) {
                          setState(() {
                            _selectedIndex = 0;
                            _currentIndex = v;
                            _pageController.animateToPage(
                              v,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.ease,
                            );
                          });
                        }
                      },
                    ),
                  ),

                  // LEFT ICON
                  Positioned(
                    left: 15,
                    child: GestureDetector(
                      onTap: () => Get.toNamed(Routes.analysescreen),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: backgroundColor,
                        child: const Icon(
                          LucideIcons.helpCircle,
                          color: textColor,
                          size: 20,
                        ),
                      ),
                    ),
                  ),

                  // RIGHT ICON
                  Positioned(
                    right: 15,
                    child: GestureDetector(
                      onTap: () => _advancedDrawerController.showDrawer(),
                      child: const CustomMenuButton(),
                    ),
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _segmentLabel(String text, bool active) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: active ? Colors.black : textColor,
        ),
      ),
    );
  }

  Widget _buildProfileView(BuildContext context) {
    return Stack(
      children: <Widget>[
        _buildProfileTabs(context),
        BottomBar(activeIndex: 4),
      ],
    );
  }

  Widget _buildProfileTabs(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (_, __) => <Widget>[
        SliverStickyHeader(
          header: MyProfileHeader(
            myProfile: profileController.myProfile,
          ),
        )
      ],
      body: DefaultTabController(
        length: calculateTabLength(),
        child: Column(
          children: <Widget>[
            OutlineButtonHeader(context, profileController.myProfile),
            const SizedBox(height: 15),
            _buildTopDivider(),
            _buildTabBar(),
            _buildTopDivider(),
            Expanded(child: _buildTabBarView()),
          ],
        ),
      ),
    );
  }

  Widget _buildTopDivider() => const SizedBox(
        width: double.infinity,
        height: 1.3,
        child: ColoredBox(color: backgroundcolorinterface),
      );

  Widget _buildTabBar() {
    return Material(
      color: const Color(0xFFF9F9F9),
      child: TabBar(
        isScrollable: calculateTabLength() > 4,
        indicatorColor: primaryColorLT,
        tabs: <Widget>[
          const Tab(
              child:
                  Text('About', style: TextStyle(fontWeight: FontWeight.w700))),
          const Tab(
              child:
                  Text('Posts', style: TextStyle(fontWeight: FontWeight.w700))),
          if (homeController.myRequests.isNotEmpty)
            const Tab(
              child: Text(
                'Requests',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          if (homeController.userdonations.isNotEmpty)
            const Tab(
                child: Text('Donations',
                    style: TextStyle(fontWeight: FontWeight.w700))),
          if (homeController.usercourses.isNotEmpty)
            const Tab(
                child: Text('Courses',
                    style: TextStyle(fontWeight: FontWeight.w700))),
        ],
      ),
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      children: <Widget>[
        _buildAboutTab(),
        _buildPostsTab(),
        if (homeController.myRequests.isNotEmpty) _buildRequestsTab(),
        if (homeController.userdonations.isNotEmpty) _buildDonationsTab(),
        if (homeController.usercourses.isNotEmpty) _buildCoursesTab(),
      ],
    );
  }

  Widget _buildAboutTab() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          const SizedBox(height: 30),
          profileinfodisplay(context, profileController.myProfile),
        ],
      ),
    );
  }

  Widget _buildRequestsTab() {
    return Obx(() {
      if (homeController.myRequests.isEmpty) {
        return _emptyState('No Requests Found', 'assets/svgs/supporter.svg');
      }

      return ListView.builder(
        itemCount: homeController.myRequests.length,
        itemBuilder: (_, int i) {
          final BuyerRequestModel req = homeController.myRequests[i];

          return ListTile(
            title: Text(req.title),
            subtitle: Text(req.description),
          );
        },
      );
    });
  }

  Widget _buildPostsTab() {
    return profilepostsdisplay(
      ispublicposts: false,
      context,
      profileController.myProfile,
      profileController.posts,
      loading: profileController.isLoading.value,
    );
  }

  Widget _buildDonationsTab() {
    return Obx(() {
      if (homeController.userdonations.isEmpty) {
        return _emptyState('No Crowdfunds Found', 'assets/svgs/supporter.svg');
      }

      return ListView.builder(
        itemCount: homeController.userdonations.length,
        itemBuilder: (_, int i) {
          return DonationItem(
            donation: homeController.userdonations[i],
            isLastItem: i == homeController.userdonations.length - 1,
          );
        },
      );
    });
  }

  Widget _buildCoursesTab() {
    return Obx(() {
      if (homeController.loading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (homeController.cError.value) {
        return _emptyState('Error Loading Courses!', 'assets/svgs/courses.svg');
      }

      if (homeController.usercourses.isEmpty) {
        return _emptyState('No Courses Found', 'assets/svgs/courses.svg');
      }

      return ListView.builder(
        itemCount: homeController.usercourses.length,
        itemBuilder: (_, int i) =>
            CourseItem(course: homeController.usercourses[i]),
      );
    });
  }

  Widget _emptyState(String msg, String icon) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SvgPicture.asset(icon,
            height: 40,
            colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn)),
        const SizedBox(height: 10),
        Text(msg,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
      ],
    );
  }

  int calculateTabLength() {
    int count = 2; // About + Posts
    if (homeController.userdonations.isNotEmpty) count++;
    if (homeController.usercourses.isNotEmpty) count++;
    if (homeController.myRequests.isNotEmpty) count++;
    return count;
  }
}
