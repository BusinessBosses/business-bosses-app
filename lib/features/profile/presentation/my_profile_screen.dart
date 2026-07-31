import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/presentation/bottom_nav_screen.dart';
import 'package:business_bosses_v2/bbpro/presentation/setup_shop.dart';
import 'package:business_bosses_v2/bbpro/widgets/drawercontent.dart';
import 'package:business_bosses_v2/bbpro/widgets/menubutton.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/chat/chat_room_screen.dart';
import 'package:business_bosses_v2/features/courses/models/course_model.dart';
import 'package:business_bosses_v2/features/donations/models/donations_model.dart';
import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/donations/widgets/donation_item.dart';
import 'package:business_bosses_v2/features/home/widgets/bottom_bar.dart';
import 'package:business_bosses_v2/features/home/widgets/buyer_request_item.dart';
import 'package:business_bosses_v2/features/home/widgets/course_item.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/requests_controller.dart';
import 'package:business_bosses_v2/features/marketplace/models/buyer_request_model.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/buyer_requests_form.dart';
import 'package:business_bosses_v2/features/partners/controllers/partners_controller.dart';
import 'package:business_bosses_v2/features/partners/models/partner_model.dart';
import 'package:business_bosses_v2/features/partners/widgets/bossup_partner_item.dart';
import 'package:business_bosses_v2/features/posts/models/post_model.dart';
import 'package:business_bosses_v2/features/posts/widgets/userpost_tile.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/features/profile/presentation/public_profile_screen.dart';
import 'package:business_bosses_v2/features/profile/widgets/profileinfodisplay.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../action/action.dart';
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
  final PartnerController partnerController = Get.put(PartnerController());
  final BuyerRequestController buyerRequestController =
      Get.put(BuyerRequestController());

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
        if (mounted) setState(() => loading = false);
      });
      // If initShop() synchronously set the shop from cache
      if (shopController.shop != null) {
        loading = false;
      }
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
                          setState(() {
                            _selectedIndex = index;
                          });
                        },
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget? _buildAppBar() {
    final bool showHeader = _selectedIndex == 0 || _selectedIndex == 4;

    // Return null (not a zero-height bar) when hidden so the outer Scaffold
    // doesn't strip the top MediaQuery padding from the body — otherwise the
    // nested My Biz screens (e.g. Orders) lose their SafeArea inset.
    if (!showHeader) return null;

    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight + 20),
      child: SafeArea(
              bottom: false,
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
                        1: _segmentLabel('My Biz', _currentIndex == 1),
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
            ),
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
              child: Text('Jobs',
                  style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          if (partnerController.myPartners.isNotEmpty)
            const Tab(
              child:
                  Text('Deals', style: TextStyle(fontWeight: FontWeight.w700)),
            )
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
        if (partnerController.myPartners.isNotEmpty) _buildPartnersTab(),
        // if (homeController.userdonations.isNotEmpty) _buildDonationsTab(),
        // if (homeController.usercourses.isNotEmpty) _buildCoursesTab(),
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

      return MasonryGridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        padding:
            const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 100),
        itemCount: homeController.myRequests.length,
        itemBuilder: (BuildContext context, int index) {
          final BuyerRequestModel request = homeController.myRequests[index];
          return BuyerRequestItem(
            request: request,
            onApply: () => _navigateToChatScreen(request),
            onTap: () => _showRequestDetails(request),
            onMoreOptions: () => _showRequestMenu(request),
          );
        },
      );
    });
  }

  Widget _buildPartnersTab() {
    return Obx(() {
      if (partnerController.myPartners.isEmpty) {
        return _emptyState('No Partners Found', 'assets/svgs/supporter.svg');
      }

      return ListView.builder(
        padding: const EdgeInsets.only(top: 10, bottom: 100),
        itemCount: partnerController.myPartners.length,
        itemBuilder: (BuildContext context, int index) {
          final Partner partner = partnerController.myPartners[index];
          return BossuppartnerItem(
            companyName: partner.companyName,
            companyDescription: partner.companyDescription ?? '',
            companyUrl: partner.companyUrl ?? '',
            companyPhoto: partner.companyPhoto,
            clicks: partner.clicks,
            id: partner.id ?? 0,
            partner: partner,
            showPartnerMessage: false,
          );
        },
      );
    });
  }

  void _showRequestMenu(BuyerRequestModel request) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.blue),
              title: const Text('Edit'),
              onTap: () {
                Navigator.pop(context);
                Get.to(() => AddBuyerRequests(request: request));
              },
            ),
            const Divider(height: 0),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete'),
              onTap: () async {
                Navigator.pop(context);
                final bool? confirmed = await _showDeleteConfirmation();
                if (confirmed == true) {
                  Get.dialog(
                    const Center(child: CircularProgressIndicator()),
                    barrierDismissible: false,
                  );
                  final bool success = await buyerRequestController
                      .deleteBuyerRequest(request.id!);
                  Get.back();
                  if (success) {
                    Get.snackbar(
                      'Deleted',
                      'Request deleted successfully!',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green[100],
                      colorText: Colors.green[900],
                    );
                  } else {
                    Get.snackbar(
                      'Error',
                      'Failed to delete request.',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red[100],
                      colorText: Colors.red[900],
                    );
                  }
                }
              },
            ),
            const Divider(height: 0),
            ListTile(
              leading: const Icon(Icons.share, color: Colors.green),
              title: const Text('Share'),
              onTap: () {
                Navigator.pop(context);
                _shareRequest(request);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _shareRequest(BuyerRequestModel request) {
    String message = 'Check out this buyer request on Business Bosses\\n'
        'Title: ${request.title}\\n'
        'Budget: \$${request.budgetStart.toStringAsFixed(0)} - \$${request.budgetEnd.toStringAsFixed(0)}\\n'
        'https://vm.businessbosses.co.uk/share/post';
    logEvent(request.id ?? '', 'buyer_request');
    socialShare(message);
  }

  void _navigateToChatScreen(BuyerRequestModel request) {
    Get.to(
      () =>
          const ChatRoomScreen(frommarketplace: false, fromBuyerRequest: true),
      arguments: <String, Object>{
        'user': request.user,
        'buyerRequest': request,
      },
    );
  }

  bool _isValidImageUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    final Uri? uri = Uri.tryParse(url);
    return uri != null &&
        uri.hasAbsolutePath &&
        (uri.scheme == 'http' || uri.scheme == 'https');
  }

  void _showRequestDetails(BuyerRequestModel request) {
    final bool hasValidImage = _isValidImageUrl(request.imageUrl);
    final bool hasValidProfilePic = _isValidImageUrl(request.user.photoUrl);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (BuildContext context, ScrollController scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => PublicProfileScreen(),
                          arguments: request.user);
                    },
                    child: Row(
                      spacing: 10,
                      children: <Widget>[
                        if (hasValidProfilePic)
                          NetworkImageWithPlaceHolder(
                            imageUrl: request.user.photoUrl!,
                            height: 40,
                            width: 40,
                            radius: 50,
                            cacheHeight: 256,
                            cacheWidth: 256,
                            placeHolder: Icons.person,
                            iconSize: 24,
                          )
                        else
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Icon(
                              Icons.person,
                              size: 24,
                              color: Colors.grey[600],
                            ),
                          ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              request.user.name ?? request.user.username,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: textDark,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (hasValidImage) ...<Widget>[
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: NetworkImage(request.imageUrl!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  Text(
                    request.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    request.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: textColor,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow(Icons.attach_money, 'Budget',
                      '\$${request.budgetStart} - \$${request.budgetEnd}'),
                  const SizedBox(height: 8),
                  if (request.deadline.isNotEmpty) ...<Widget>[
                    _buildDetailRow(
                      Icons.calendar_today,
                      'Deadline',
                      DateFormat('MMMM dd, yyyy').format(
                        DateTime.tryParse(request.deadline) ?? DateTime.now(),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  _buildDetailRow(Icons.category, 'Category', request.category),
                  const SizedBox(height: 16),
                  if (request.user.uid !=
                      profileController.myProfile.uid) ...<Widget>[
                    if (profileController.myProfile.hasShop) ...<Widget>[
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _navigateToChatScreen(request),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColorLT,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Send Proposal',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ] else ...<Widget>[
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Get.to(() => Setupshop()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColorLT,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Setup Shop to Send Proposal',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ] else ...<Widget>[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () =>
                            Get.to(() => AddBuyerRequests(request: request)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColorLT,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Edit Job',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          // 🟡 Confirm before deleting
                          final bool? confirmed =
                              await _showDeleteConfirmation();

                          if (confirmed == true) {
                            // 🟢 Show loading dialog
                            Get.dialog(
                              const Center(child: CircularProgressIndicator()),
                              barrierDismissible: false,
                            );

                            // 🚀 Perform delete action
                            final bool success =
                                await buyerRequestController.deleteBuyerRequest(
                                    request.id!); // Assuming request has id

                            // ❌ Hide loader
                            Get.back();

                            if (success) {
                              Get.snackbar(
                                'Deleted',
                                'Request deleted successfully!',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.green[100],
                                colorText: Colors.green[900],
                              );

                              // Safely close both loader and bottom sheet
                              Future<Null>.delayed(
                                  const Duration(milliseconds: 100), () {
                                Get.back(closeOverlays: true);
                              });
                            } else {
                              Get.snackbar(
                                'Error',
                                'Failed to delete request.',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red[100],
                                colorText: Colors.red[900],
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Delete Job',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    )
                  ]
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: <Widget>[
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }

  Future<bool?> _showDeleteConfirmation() async {
    return await Get.dialog(
      AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this request?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostsTab() {
    return GetBuilder<ProfileController>(builder: (ProfileController controller) {
      final List<UnifiedFeedItem> combinedItems = <UnifiedFeedItem>[];

      // Add normal posts
      for (final PostModel post in controller.posts) {
        combinedItems.add(UnifiedFeedItem(
          data: post,
          type: FeedType.post,
          createdAt: DateTime.fromMillisecondsSinceEpoch(post.timestamp),
        ));
      }

      // Add donations
      for (final DonationModel donation in homeController.userdonations) {
        if (donation.timestamp != null) {
          combinedItems.add(UnifiedFeedItem(
            data: donation,
            type: FeedType.donation,
            createdAt:
                DateTime.fromMillisecondsSinceEpoch(donation.timestamp ?? 0),
          ));
        }
      }

      // Add courses
      for (final CourseModel course in homeController.usercourses) {
        if (course.timestamp != null) {
          combinedItems.add(UnifiedFeedItem(
            data: course,
            type: FeedType.course,
            createdAt:
                DateTime.fromMillisecondsSinceEpoch(course.timestamp ?? 0),
          ));
        }
      }

      // Sort DESC by createdAt
      combinedItems.sort(
        (UnifiedFeedItem a, UnifiedFeedItem b) =>
            b.createdAt.compareTo(a.createdAt),
      );

      if (combinedItems.isEmpty) {
        return _emptyState('No Posts Found', 'assets/svgs/text.svg');
      }

      return ListView.builder(
        padding: const EdgeInsets.only(top: 15, bottom: 120),
        itemCount: combinedItems.length,
        itemBuilder: (_, int i) {
        final UnifiedFeedItem item = combinedItems[i];

        switch (item.type) {
          case FeedType.post:
            return Container(
              // enforce height constraints for grid-style tile
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: PostTile(
                post: item.data,
                controller: homeController,
              ),
            );

          case FeedType.request:
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: BuyerRequestItem(
                request: item.data,
                onTap: () => _showRequestDetails(item.data),
                onApply: () => _navigateToChatScreen(item.data),
                onMoreOptions: () => _showRequestMenu(item.data),
              ),
            );

          case FeedType.donation:
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: DonationItem(
                donation: item.data,
                isLastItem: false,
              ),
            );

          case FeedType.course:
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: CourseItem(course: item.data),
            );

          default:
            return const SizedBox.shrink();
          }
        },
      );
    });
  }

  // Widget _buildDonationsTab() {
  //   return Obx(() {
  //     if (homeController.userdonations.isEmpty) {
  //       return _emptyState('No Crowdfunds Found', 'assets/svgs/supporter.svg');
  //     }

  //     return ListView.builder(
  //       itemCount: homeController.userdonations.length,
  //       itemBuilder: (_, int i) {
  //         return DonationItem(
  //           donation: homeController.userdonations[i],
  //           isLastItem: i == homeController.userdonations.length - 1,
  //         );
  //       },
  //     );
  //   });
  // }

  // Widget _buildCoursesTab() {
  //   return Obx(() {
  //     if (homeController.loading.value) {
  //       return const Center(child: CircularProgressIndicator());
  //     }

  //     if (homeController.cError.value) {
  //       return _emptyState('Error Loading Courses!', 'assets/svgs/courses.svg');
  //     }

  //     if (homeController.usercourses.isEmpty) {
  //       return _emptyState('No Courses Found', 'assets/svgs/courses.svg');
  //     }

  //     return ListView.builder(
  //       itemCount: homeController.usercourses.length,
  //       itemBuilder: (_, int i) =>
  //           CourseItem(course: homeController.usercourses[i]),
  //     );
  //   });
  // }

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
    if (homeController.myRequests.isNotEmpty) count++;
    if (partnerController.myPartners.isNotEmpty) count++;
    return count;
  }
}

class UnifiedFeedItem {
  final dynamic data;
  final FeedType type;
  final DateTime createdAt;

  UnifiedFeedItem({
    required this.data,
    required this.type,
    required this.createdAt,
  });
}

enum FeedType { post, request, donation, course }
