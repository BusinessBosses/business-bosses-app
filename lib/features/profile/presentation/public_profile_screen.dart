import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/presentation/user_shop_screen.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/features/chat/chat_room_screen.dart';
import 'package:business_bosses_v2/features/home/widgets/buyer_request_item.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/requests_controller.dart';
import 'package:business_bosses_v2/features/marketplace/models/buyer_request_model.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/buyer_requests_form.dart';
import 'package:business_bosses_v2/features/posts/models/post_model.dart';
import 'package:business_bosses_v2/features/profile/widgets/profileinfodisplay.dart';
import 'package:business_bosses_v2/features/profile/widgets/profilepostsdisplay.dart';

import 'package:business_bosses_v2/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../action/action.dart';
import '../../../common/widgets/text_widget.dart';
import '../../../utils/theme/theme.dart';
import '../controller/profile_controller.dart';
import '../widgets/friendoutlinebuttonheader.dart';
import '../widgets/friend_profile_header.dart';

// ignore: public_member_api_docs, must_be_immutable
class PublicProfileScreen extends StatefulWidget {
  static const String routeName = '/public-profile-screen';
  bool? store;
  final int? selectedIndex;
  final int? currentIndex;
  // ignore: public_member_api_docs
  PublicProfileScreen(
      {super.key, this.store, this.selectedIndex, this.currentIndex});

  @override
  State<PublicProfileScreen> createState() => _PublicProfileScreenState();
}

class _PublicProfileScreenState extends State<PublicProfileScreen> {
  final ProfileController _profileController = Get.find();
  final ShopController shopController = Get.find();
  final BuyerRequestController buyerRequestController =
      Get.put(BuyerRequestController());
  List<PostModel> _posts = <PostModel>[];
  late UserModel publicUser;
  bool isLoading = true;
  bool blocked = false;
  bool hasShop = false;
  List<BuyerRequestModel> buyerRequests = <BuyerRequestModel>[];

  bool hasUser = true;

  late PageController _pageController;

  int? _selectedIndex;
  int _currentIndex = 0;

  Future<void> loadData() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
    });

    try {
      final Map<String, dynamic> res =
          await _profileController.loadData(publicUser.uid);

      // Process user model outside of setState
      final UserModel modelizedUser = UserModel.fromMap(
        <dynamic, dynamic>{...res['user'], 'interests': res['industries']},
      );

      // Assign values locally first
      UserModel updatedUser = modelizedUser;

      // Initialize shop asynchronously and await result
      if (updatedUser.hasShop) {
        await shopController.initUserShop(modelizedUser);
      }

      final ApiResponseModel requestResponse =
          await ApiService.get(path: 'buyer-request/user/${publicUser.uid}');
      if (requestResponse.success) {
        for (dynamic request in requestResponse.data) {
          buyerRequests.add(BuyerRequestModel.fromJson(request));
        }
      }
      // All state updates at once
      if (mounted) {
        setState(() {
          publicUser = updatedUser;
          _posts = res['posts'];
          hasShop = updatedUser.hasShop;
          isLoading = false; // Done loading
        });
      }
    } catch (e) {
      // Handle errors
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> report(
      BuildContext context, String type, String publicUserUid) async {}

  Future<void> connect(String userId) async {
    // ignore: unused_local_variable
    final ApiResponseModel res = await ApiService.post(
        path: 'connection/connect',
        body: <String, dynamic>{
          'userId': _profileController.myProfile.uid,
          'connectedId': userId,
          'timestamp': DateTime.now().millisecondsSinceEpoch
        });
  }

  Future<void> disconnect(String userId) async {
    // ignore: unused_local_variable
    final ApiResponseModel res = await ApiService.post(
        path: 'connection/disconnect',
        body: <String, dynamic>{
          'userId': _profileController.myProfile.uid,
          'connectedId': userId,
          'timestamp': DateTime.now().millisecondsSinceEpoch
        });
  }

  void connectToUser() async {
    final int checkConnected = _profileController.myProfile.connecteds == null
        ? -1
        : _profileController.myProfile.connecteds!
            .indexWhere((String element) => element == publicUser.uid);
    if (checkConnected == -1) {
      // connecteds.add(user);
      _profileController.updateConnections(publicUser.uid);
      setState(() {
        publicUser = UserModel.fromMap(<dynamic, dynamic>{
          ...publicUser.toMap(),
          'connectionCount': publicUser.connectionCount == null
              ? 1
              : publicUser.connectionCount! + 1
        });
      });
      await connect(publicUser.uid);
    } else {
      _profileController.updateConnections(publicUser.uid);

      setState(() {
        publicUser = UserModel.fromMap(<dynamic, dynamic>{
          ...publicUser.toMap(),
          'connectionCount': publicUser.connectionCount == null
              ? null
              : publicUser.connectionCount! - 1
        });
      });
      // connecteds.removeAt(checkConnected);
      await disconnect(publicUser.uid);
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController =
        PageController(initialPage: widget.currentIndex ?? _currentIndex);
    _selectedIndex = widget.selectedIndex ?? 0;
    _currentIndex = widget.currentIndex ?? 0;

    if (Get.arguments == null) {
      // print("back");
      Get.back();
    } else {
      // print("yo");

      publicUser = Get.arguments;
      // print(publicUser.productsandservices);
      loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: !hasShop
            ? AppBar(
                actions: <Widget>[
                  threeDots(),
                ],
                leading: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
                ),
                title: Text(publicUser.name ?? publicUser.username),
              )
            : PreferredSize(
                preferredSize: Size.fromHeight(
                    (_selectedIndex == 0 || _selectedIndex == 4)
                        ? kToolbarHeight
                        : 0),
                child: Stack(children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      if (_selectedIndex == 0 || _selectedIndex == 4)
                        if (hasShop) ...<Widget>{
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: CupertinoSlidingSegmentedControl<int>(
                              backgroundColor: backgroundColor,
                              padding: const EdgeInsets.all(5),
                              children: <int, Widget>{
                                0: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Text('Profile',
                                      style: _currentIndex == 0
                                          ? const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            )
                                          : const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: textColor)),
                                ),
                                1: Text(
                                  'Biz-Center',
                                  style: _currentIndex == 1
                                      ? const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14)
                                      : const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: textColor,
                                        ),
                                ),
                              },
                              onValueChanged: (int? value) {
                                if (value != null) {
                                  setState(() {
                                    _selectedIndex == 0;
                                    _currentIndex = value;
                                    _pageController.animateToPage(
                                      _currentIndex,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.ease,
                                    );
                                  });
                                }
                              },
                              groupValue: _currentIndex,
                            ),
                          )
                        },
                      if (_selectedIndex == 0 || _selectedIndex == 4)
                        const SizedBox(height: 10.0),
                    ],
                  ),
                  Positioned(
                      bottom: 10,
                      right: 0,
                      child: publicUser.uid != _profileController.myProfile.uid
                          ? threeDots()
                          : Container()),
                  Positioned(
                    bottom: 5,
                    left: 0,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
                    ),
                  ),
                ]),
              ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator.adaptive())
            : PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                onPageChanged: (int index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                children: <Widget>[
                    NestedScrollView(
                      headerSliverBuilder:
                          (BuildContext context, bool innerBoxIsScrolled) {
                        return <Widget>[
                          SliverStickyHeader(
                            sticky: false,
                            header: friendProfileHeader(publicUser),
                          )
                        ];
                      },
                      body: DefaultTabController(
                        length: buyerRequests.isEmpty ? 2 : 3,
                        initialIndex: widget.store != null ? 2 : 0,
                        child: Column(
                          children: <Widget>[
                            outlineButtonHeader(
                              publicUser,
                              _profileController.myProfile,
                              connectToUser,
                              context,
                            ),
                            const SizedBox(height: 15.0),
                            // },
                            const SizedBox(
                              width: double.infinity,
                              height: 1.5,
                              child:
                                  ColoredBox(color: backgroundcolorinterface),
                            ),

                            Material(
                              color: const Color(0xFFF9F9F9),
                              child: TabBar(
                                indicatorColor: primaryColorLT,
                                labelStyle: const TextStyle(
                                    fontWeight: FontWeight.w500),
                                labelColor: Colors.black,
                                tabs: <Widget>[
                                  const Tab(
                                    text: 'About',
                                  ),
                                  const Tab(
                                    text: 'Posts',
                                  ),
                                  if (buyerRequests.isNotEmpty)
                                    const Tab(
                                      text: 'Requests',
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: double.infinity,
                              height: 1.5,
                              child:
                                  ColoredBox(color: backgroundcolorinterface),
                            ), // Container(

                            Expanded(
                              child: TabBarView(children: <Widget>[
                                SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      profileinfodisplay(context, publicUser),
                                    ],
                                  ),
                                ),
                                // Container()
                                profilepostsdisplay(
                                  ispublicposts: true,
                                  context,
                                  publicUser,
                                  _posts,
                                  loading: isLoading,
                                ),
                                if (buyerRequests.isNotEmpty)
                                  MasonryGridView.count(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    padding: const EdgeInsets.only(
                                        left: 15,
                                        right: 15,
                                        top: 15,
                                        bottom: 100),
                                    itemCount: buyerRequests.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final BuyerRequestModel request =
                                          buyerRequests[index];
                                      return BuyerRequestItem(
                                        request: request,
                                        onApply: () =>
                                            _navigateToChatScreen(request),
                                        onTap: () =>
                                            _showRequestDetails(request),
                                        onMoreOptions: () =>
                                            _showRequestMenu(request),
                                      );
                                    },
                                  ),
                              ]),
                            ),
                          ],
                        ),
                      ),
                    ),
                    UserShopScreen(
                      user: publicUser,
                      ismyshop: false,
                    ),
                  ]));
  }

  bool _isValidImageUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    final Uri? uri = Uri.tryParse(url);
    return uri != null &&
        uri.hasAbsolutePath &&
        (uri.scheme == 'http' || uri.scheme == 'https');
  }

  void _showRequestMenu(BuyerRequestModel request) {
    final bool isMyRequest =
        request.user.uid == _profileController.myProfile.uid;

    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (isMyRequest) ...<Widget>[
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
                      // Refresh the list
                      setState(() {
                        buyerRequests.removeWhere(
                            (BuyerRequestModel r) => r.id == request.id);
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
              ),
              const Divider(height: 0),
            ] else ...<Widget>[
              ListTile(
                leading: const Icon(Icons.report, color: Colors.red),
                title: const Text('Report'),
                onTap: () {
                  Navigator.pop(context);
                  _showReportDialog(request);
                },
              ),
              const Divider(height: 0),
            ],
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
        'https://vm.businessbosses.co.uk/share/request';
    logEvent(request.id ?? '', 'buyer_request');
    socialShare(message);
  }

  void _showReportDialog(BuyerRequestModel request) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const TextWidget(
          text: 'Do you want to report this request?',
          centralize: true,
          fontWeight: FontWeight.w700,
          size: 20,
        ),
        content: TextWidget(
          text:
              'The request will be reported to admin to evaluate if it violates any community policy',
          centralize: true,
          color: Colors.black.withValues(alpha: .6),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const TextWidget(
              text: 'Cancel',
              fontWeight: FontWeight.w700,
              size: 18,
              color: Colors.grey,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              ApiService.post(path: 'reportedrequest', body: <String, dynamic>{
                'requestId': request.id,
                'reason': 'This request violates community guidelines',
              });
              showSnackBar(context, message: 'Request has been reported');
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 7,
                horizontal: 14,
              ),
              decoration: BoxDecoration(
                color: primaryColorLT,
                borderRadius: BorderRadius.circular(5),
              ),
              child: const TextWidget(
                text: 'Report',
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
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
                      _profileController.myProfile.uid) ...<Widget>[
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
                          'Edit Request',
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
                              Future.delayed(const Duration(milliseconds: 100),
                                  () {
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
                          'Delete Request',
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

  Widget threeDots() {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          onTap: () {
                            navigateTo(context);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const TextWidget(
                                  text: 'Do you want to block user?',
                                  centralize: true,
                                  fontWeight: FontWeight.w700,
                                  size: 20,
                                ),
                                content: TextWidget(
                                  text: blocked == true
                                      ? 'You will see posts and comments related to user on your feed'
                                      : 'You will no longer see undefined posts and comments on your feed',
                                  centralize: true,
                                  color: Colors.black.withValues(alpha: .6),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => navigateTo(context),
                                    child: const TextWidget(
                                      text: 'Cancel',
                                      fontWeight: FontWeight.w700,
                                      size: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      navigateTo(context);
                                      // print(_post.user.uid);

                                      // widget
                                      //     .onBlock(_post.user.uid);
                                      showSnackBar(context,
                                          message: blocked == true
                                              ? 'User has been blocked'
                                              : 'User has been unblocked');
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 7,
                                        horizontal: 14,
                                      ),
                                      decoration: BoxDecoration(
                                        color: primaryColorLT,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: TextWidget(
                                        text: blocked == true
                                            ? 'Unblock'
                                            : 'Block',
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                          contentPadding: EdgeInsets.zero,
                          title: publicUser.isSubscribed == true
                              ? Row(
                                  children: <Widget>[
                                    TextWidget(
                                      text: blocked == true
                                          ? 'Unblock @${publicUser.name}'
                                          : 'Block @${publicUser.name}',
                                      color: Colors.blue,
                                    ),
                                    const SizedBox(width: 5),
                                    SvgPicture.asset(
                                      'assets/svgs/premiumbadge.svg',
                                      height: 9,
                                      colorFilter: ColorFilter.mode(
                                          primaryColorLT, BlendMode.src),
                                    )
                                  ],
                                )
                              : TextWidget(
                                  text: blocked == true
                                      ? 'Unblock @${publicUser.name}'
                                      : 'Block @${publicUser.name}',
                                  color: Colors.blue,
                                ),
                        ),
                        ListTile(
                          onTap: () {
                            navigateTo(context);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const TextWidget(
                                  text: 'Do you want to report user?',
                                  centralize: true,
                                  fontWeight: FontWeight.w700,
                                  size: 20,
                                ),
                                content: TextWidget(
                                  text:
                                      'The user will be reported to admin to evaluate if it violates any community policy',
                                  centralize: true,
                                  color: Colors.black.withValues(alpha: .6),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => navigateTo(context),
                                    child: const TextWidget(
                                      text: 'Cancel',
                                      fontWeight: FontWeight.w700,
                                      size: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      navigateTo(context);
                                      await report(
                                        context,
                                        'accountReport',
                                        publicUser.uid,
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 7,
                                        horizontal: 14,
                                      ),
                                      decoration: BoxDecoration(
                                        color: primaryColorLT,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: const TextWidget(
                                        text: 'Report',
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                          contentPadding: EdgeInsets.zero,
                          title: const TextWidget(
                            text: 'Report this user',
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
              child: CircleAvatar(
                  backgroundColor: backgroundColor,
                  child: SvgPicture.asset('assets/svgs/more.svg'))),
        ),
      ],
    );
  }

  Widget optionsButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      onTap: () {
                        navigateTo(context);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const TextWidget(
                              text: 'Do you want to block user?',
                              centralize: true,
                              fontWeight: FontWeight.w700,
                              size: 20,
                            ),
                            content: TextWidget(
                              text: blocked == true
                                  ? 'You will see posts and comments related to user on your feed'
                                  : 'You will no longer see undefined posts and comments on your feed',
                              centralize: true,
                              color: Colors.black.withValues(alpha: .6),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => navigateTo(context),
                                child: const TextWidget(
                                  text: 'Cancel',
                                  fontWeight: FontWeight.w700,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  navigateTo(context);
                                  // print(_post.user.uid);

                                  // widget
                                  //     .onBlock(_post.user.uid);
                                  showSnackBar(context,
                                      message: blocked == true
                                          ? 'User has been blocked'
                                          : 'User has been unblocked');
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 7,
                                    horizontal: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: primaryColorLT,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: TextWidget(
                                    text: blocked == true ? 'Unblock' : 'Block',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                      contentPadding: EdgeInsets.zero,
                      title: publicUser.isSubscribed == true
                          ? Row(
                              children: <Widget>[
                                TextWidget(
                                  text: blocked == true
                                      ? 'Unblock @${publicUser.name}'
                                      : 'Block @${publicUser.name}',
                                  color: Colors.blue,
                                ),
                                const SizedBox(width: 5),
                                SvgPicture.asset(
                                  'assets/svgs/premiumbadge.svg',
                                  height: 9,
                                  colorFilter: ColorFilter.mode(
                                      primaryColorLT, BlendMode.srcIn),
                                )
                              ],
                            )
                          : TextWidget(
                              text: blocked == true
                                  ? 'Unblock @${publicUser.name}'
                                  : 'Block @${publicUser.name}',
                              color: Colors.blue,
                            ),
                    ),
                    ListTile(
                      onTap: () {
                        navigateTo(context);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const TextWidget(
                              text: 'Do you want to report user?',
                              centralize: true,
                              fontWeight: FontWeight.w700,
                              size: 20,
                            ),
                            content: TextWidget(
                              text:
                                  'The user will be reported to admin to evaluate if it violates any community policy',
                              centralize: true,
                              color: Colors.black.withValues(alpha: .6),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => navigateTo(context),
                                child: const TextWidget(
                                  text: 'Cancel',
                                  fontWeight: FontWeight.w700,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  navigateTo(context);
                                  await report(
                                    context,
                                    'accountReport',
                                    publicUser.uid,
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 7,
                                    horizontal: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: primaryColorLT,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: const TextWidget(
                                    text: 'Report',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                      contentPadding: EdgeInsets.zero,
                      title: const TextWidget(
                        text: 'Report this user',
                        color: Colors.red,
                      ),
                    )
                  ],
                ),
              ),
            );
          },
          child: CircleAvatar(
              backgroundColor: backgroundColor,
              child: SvgPicture.asset('assets/svgs/more.svg'))),
    );
  }
}
