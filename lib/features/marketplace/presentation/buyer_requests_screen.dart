import 'package:business_bosses_v2/action/action.dart';
import 'package:business_bosses_v2/utils/currency_format.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/common/widgets/popup/my_popup_menu_button.dart';
import 'package:business_bosses_v2/common/widgets/typography/text_widget.dart';
import 'package:business_bosses_v2/features/chat/chat_room_screen.dart';
import 'package:business_bosses_v2/features/home/widgets/buyer_request_item.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/market_controller.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/requests_controller.dart';
import 'package:business_bosses_v2/features/marketplace/models/buyer_request_model.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/apply_with_cv_sheet.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/buyer_requests_form.dart';
import 'package:business_bosses_v2/features/premium/premium_paywall_sheet.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/features/profile/presentation/public_profile_screen.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class BuyerRequestsScreen extends StatefulWidget {
  final String? filterByIndustry;
  final String? filterByLocation;
  final bool showOnlyMyRequests;
  final bool showAppBar;

  /// When true, free (non-Pro) users see only the first [_kFreeMatchLimit]
  /// matched requests followed by an upgrade prompt; Pro users see all. Used
  /// for the buyer-match contexts ("Matched Buyer" tile / "I need customers").
  final bool gateForFreeUsers;

  const BuyerRequestsScreen({
    super.key,
    this.filterByIndustry,
    this.filterByLocation,
    this.showOnlyMyRequests = false,
    this.showAppBar = true,
    this.gateForFreeUsers = false,
  });

  @override
  State<BuyerRequestsScreen> createState() => _BuyerRequestsScreenState();
}

class _BuyerRequestsScreenState extends State<BuyerRequestsScreen> {
  final BuyerRequestController _buyerRequestController =
      Get.put(BuyerRequestController());
  final ProfileController profileController = Get.find();

  final String _selectedFilter = 'All';
  List<BuyerRequestModel> _filteredRequests = <BuyerRequestModel>[];

  /// Number of matched requests a free user can see before the upgrade prompt.
  static const int _kFreeMatchLimit = 2;

  @override
  void initState() {
    super.initState();
    // Deferred to after the frame: fetching clears the shared Rx lists, and
    // doing that from initState marks other live Obx widgets dirty mid-build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _fetchRequests();
    });
  }

  Future<void> _fetchRequests() async {
    // If we're showing only my requests or have specific filters, we use them.
    // Otherwise, if we're in the general marketplace context (no specific filter),
    // we fetch ALL requests to satisfy the requirement "SHOW ALL THE REQUEST by all users".
    String? locationFilter;

    if (widget.showOnlyMyRequests) {
      locationFilter = null; // Don't filter by location for "My Requests"
    } else if (widget.filterByLocation != null &&
        widget.filterByLocation!.isNotEmpty) {
      locationFilter = widget.filterByLocation;
    } else if (widget.showAppBar) {
      // If it's a dedicated screen (not embedded in marketplace tabs),
      // or if it was explicitly requested with a location.
      final MarketController marketController = Get.find();
      locationFilter = marketController.selectedLocation;
    } else {
      // embedded in marketplace "I Need" tab, show all
      locationFilter = null;
    }

    await _buyerRequestController.initBuyerRequests(
        priorityLocation: locationFilter);
    _applyFilter();
  }

  void _applyFilter() {
    // The fetch can outlive the screen — switching home tabs disposes this
    // widget while the request is still in flight, and setState() on a
    // disposed State throws.
    if (!mounted) return;

    final RxList<BuyerRequestModel> allRequests =
        _buyerRequestController.buyerRequests;
    setState(() {
      List<BuyerRequestModel> baseRequests =
          List<BuyerRequestModel>.from(allRequests);

      // Buyer-match mode (seller / "Matched Buyer"): keep requests that match
      // my industry OR my location, ranked both-match first, then industry-only,
      // then location-only (most recent first within each tier). Gated on
      // industry being set so location-only browse contexts are unaffected.
      final String industry =
          (widget.filterByIndustry ?? '').toLowerCase().trim();
      final String location =
          (widget.filterByLocation ?? '').toLowerCase().trim();

      if (industry.isNotEmpty) {
        final String myUid = profileController.myProfile.uid;
        bool categoryMatch(BuyerRequestModel r) =>
            r.category.toLowerCase().trim() == industry;
        bool locationMatch(BuyerRequestModel r) =>
            location.isNotEmpty &&
            (r.user.location ?? '').toLowerCase().contains(location);

        // Exclude my own requests so the list (and its count) only shows
        // other people's buyer requests that match me.
        baseRequests = baseRequests
            .where((BuyerRequestModel r) =>
                r.user.uid != myUid &&
                (categoryMatch(r) || locationMatch(r)))
            .toList();

        int rank(BuyerRequestModel r) {
          final bool c = categoryMatch(r);
          final bool l = locationMatch(r);
          if (c && l) return 0; // both → top
          if (c) return 1; // industry only
          return 2; // location only
        }

        DateTime created(BuyerRequestModel r) =>
            DateTime.tryParse(r.createdAt ?? '') ??
            DateTime.fromMillisecondsSinceEpoch(0);

        baseRequests.sort((BuyerRequestModel a, BuyerRequestModel b) {
          final int byRank = rank(a).compareTo(rank(b));
          if (byRank != 0) return byRank;
          return created(b).compareTo(created(a)); // newer first within a tier
        });
      }

      // Filter by my requests if specified
      if (widget.showOnlyMyRequests) {
        baseRequests = baseRequests
            .where((BuyerRequestModel r) =>
                r.user.uid == profileController.myProfile.uid)
            .toList();
      }

      if (_selectedFilter == 'All') {
        _filteredRequests = baseRequests;
      } else if (_selectedFilter == 'Active') {
        _filteredRequests = baseRequests
            .where((BuyerRequestModel r) =>
                DateTime.tryParse(r.deadline)?.isAfter(DateTime.now()) == true)
            .toList();
      } else if (_selectedFilter == 'Has Offers') {
        _filteredRequests = baseRequests
            .where((BuyerRequestModel r) => r.offerCount > 0)
            .toList();
      } else if (_selectedFilter == 'Closing Soon') {
        _filteredRequests = baseRequests
            .where((BuyerRequestModel r) =>
                r.deadline.isNotEmpty &&
                DateTime.tryParse(r.deadline)!
                        .difference(DateTime.now())
                        .inDays <=
                    7)
            .toList();
      }
    });
  }

  /// Applying opens the CV sheet first — attaching one is optional.
  Future<void> _navigateToChatScreen(BuyerRequestModel request) async {
    final JobApplication? application = await showApplyWithCvSheet(request);
    if (application == null) return;

    Get.to(
      () =>
          const ChatRoomScreen(frommarketplace: false, fromBuyerRequest: true),
      arguments: <String, Object?>{
        'user': request.user,
        'buyerRequest': request,
        'cvUrl': application.cvUrl,
        'cvName': application.cvName,
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

  void _shareRequest(BuyerRequestModel request) {
    String message = 'Check out this job on Business Bosses\n'
        'Title: ${request.title}\n'
        'Budget: \$${request.budgetStart.toStringAsFixed(0)} - \$${request.budgetEnd.toStringAsFixed(0)}\n'
        'https://vm.businessbosses.co.uk/share/post';
    logEvent(request.id ?? '', 'buyer_request');
    socialShare(message);
  }

  void _showReportBlockDialog(BuyerRequestModel request) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              onTap: () {
                Navigator.pop(context);
                _showBlockDialog();
              },
              contentPadding: EdgeInsets.zero,
              title: TextWidget(
                text: 'Block @${request.user.name ?? "User"}',
                color: Colors.blue,
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                _showReportDialog(request);
              },
              contentPadding: EdgeInsets.zero,
              title: const TextWidget(
                text: 'Report this job',
                color: Colors.red,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showBlockDialog() {
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
          text:
              'You will no longer see this user\'s jobs on your feed',
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
              // if (widget.onRemoveRequest != null) {
              //   widget.onRemoveRequest!(widget.request.userId);
              // }
              Navigator.pop(context);
              showSnackBar(context, message: 'User has been blocked');
              setState(() {
                // hide = true;
              });
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
                text: 'Block',
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showReportDialog(BuyerRequestModel request) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const TextWidget(
          text: 'Do you want to report post?',
          centralize: true,
          fontWeight: FontWeight.w700,
          size: 20,
        ),
        content: TextWidget(
          text:
              'The post will be reported to admin to evaluate if it violates any community policy',
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
              ApiService.post(path: 'reportedpost', body: <String, dynamic>{
                'postId': request.id,
                'reason': 'This is a bad post',
              });
              showSnackBar(context, message: 'Post has been Reported');
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

  void _showRequestDetails(BuyerRequestModel request) {
    bool hasValidImage = false;
    if (request.attachments.isNotEmpty) {
      hasValidImage = _isValidImageUrl(request.attachments[0]);
    }
    final bool hasValidProfilePic = _isValidImageUrl(request.user.photoUrl);
    final bool isMyRequest =
        request.user.uid == profileController.myProfile.uid;

    final List<PopupMenuEntry<String>> detailsMenuOwner =
        <PopupMenuEntry<String>>[
      const PopupMenuItem<String>(
        value: 'Edit',
        child: Text('Edit', style: bodyText2),
      ),
      const PopupMenuDivider(height: 0.0),
      const PopupMenuItem<String>(
        value: 'Share',
        child: Text('Share', style: bodyText2),
      ),
      const PopupMenuDivider(height: 0.0),
      const PopupMenuItem<String>(
        value: 'Delete',
        child: Text('Delete', style: bodyText2),
      ),
    ];

    final List<PopupMenuEntry<String>> detailsMenuOther =
        <PopupMenuEntry<String>>[
      const PopupMenuItem<String>(
        value: 'Share',
        child: Text('Share', style: bodyText2),
      ),
      const PopupMenuDivider(height: 0.0),
      const PopupMenuItem<String>(
        value: 'Block',
        child: Text('Block', style: bodyText2),
      ),
      const PopupMenuDivider(height: 0.0),
      const PopupMenuItem<String>(
        value: 'Report',
        child: Text('Report', style: bodyText2),
      ),
    ];

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
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
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
                      ),
                      // Three-dot menu
                      MyPopupMenuButton(
                        popupItems:
                            isMyRequest ? detailsMenuOwner : detailsMenuOther,
                        icon: const Icon(
                          Icons.more_horiz,
                          size: 24,
                          color: Colors.black,
                        ),
                        onSelected: (String val) async {
                          if (val == 'Edit') {
                            Get.back();
                            Get.to(() => AddBuyerRequests(request: request));
                          } else if (val == 'Delete') {
                            final bool? confirmed =
                                await _showDeleteConfirmation();
                            if (confirmed == true) {
                              Get.dialog(
                                const Center(
                                    child: CircularProgressIndicator()),
                                barrierDismissible: false,
                              );
                              final bool success = await _buyerRequestController
                                  .deleteBuyerRequest(request.id!);
                              Get.back();
                              if (success) {
                                Get.snackbar(
                                  'Deleted',
                                  'Job deleted successfully!',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.green[100],
                                  colorText: Colors.green[900],
                                );
                                Future<Null>.delayed(
                                    const Duration(milliseconds: 100), () {
                                  Get.back(closeOverlays: true);
                                });
                              } else {
                                Get.snackbar(
                                  'Error',
                                  'Failed to delete job.',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.red[100],
                                  colorText: Colors.red[900],
                                );
                              }
                            }
                          } else if (val == 'Share') {
                            _shareRequest(request);
                          } else if (val == 'Block') {
                            ApiService.post(
                              path: 'blockedpost',
                              body: <String, dynamic>{'postId': request.id},
                            );
                            _buyerRequestController.buyerRequests.removeWhere(
                                (BuyerRequestModel element) =>
                                    element.id == request.id);
                            Get.back();
                            Get.snackbar(
                              'Blocked',
                              'Job has been blocked',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.grey[100],
                              colorText: Colors.grey[900],
                            );
                          } else if (val == 'Report') {
                            Get.back();
                            _showReportBlockDialog(request);
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (hasValidImage) ...<Widget>[
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: NetworkImage(request.attachments[0]),
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
                      '${CurrencyFormatter.formatCurrency(CurrencyFormatter.coinsForPrice(request.budgetStart, currencyCode: 'USD'))} - ${CurrencyFormatter.formatCurrency(CurrencyFormatter.coinsForPrice(request.budgetEnd, currencyCode: 'USD'))}'),
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
                  // Anyone can apply to a job — no shop required.
                  if (!isMyRequest)
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
                          'Apply with your CV',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<bool?> _showDeleteConfirmation() async {
    return await Get.dialog(
      AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this job?'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              title: const Text('Matched Jobs'),
            )
          : null,
      backgroundColor: backgroundColor,
      body: Obx(() {
        if (_buyerRequestController.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_buyerRequestController.error.value) {
          return Center(
            child: Text(
              'Error loading jobs',
              style: TextStyle(color: Colors.grey[700]),
            ),
          );
        }

        // ✅ Fix: safely apply filter AFTER current frame
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _applyFilter();
        });

        // Free users see only the first few matches; Pro users see all.
        final bool gated = widget.gateForFreeUsers &&
            !profileController.myProfile.isSubscribed;
        final List<BuyerRequestModel> visibleRequests = gated
            ? _filteredRequests.take(_kFreeMatchLimit).toList()
            : _filteredRequests;
        final int hiddenCount =
            _filteredRequests.length - visibleRequests.length;

        return _filteredRequests.isEmpty
            ? _buildEmptyState()
            : RefreshIndicator(
                onRefresh: _fetchRequests,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: MasonryGridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, top: 10, bottom: 100),
                        itemCount: visibleRequests.length,
                        itemBuilder: (BuildContext context, int index) {
                          final BuyerRequestModel request =
                              visibleRequests[index];
                          return BuyerRequestItem(
                            request: request,
                            onApply: () => _navigateToChatScreen(request),
                            onTap: () => _showRequestDetails(request),
                          );
                        },
                      ),
                    ),
                    if (gated && hiddenCount > 0)
                      _buildUpgradePrompt(hiddenCount),
                  ],
                ),
              );
      }),
    );
  }

  Widget _buildUpgradePrompt(int hiddenCount) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(15, 0, 15, 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[premiumGold, Color(0xFFD97706)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            '$hiddenCount more ${hiddenCount == 1 ? 'job' : 'jobs'} matched',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          const Text(
            'Upgrade to Pro to see all your job matches',
            style: TextStyle(color: Colors.white70, fontSize: 13),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => showPremiumPaywall(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: premiumGold,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Upgrade to Pro',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 16),
        Text('No Jobs found',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700])),
        SizedBox(
          height: 10,
        ),
        Icon(
          LucideIcons.bellRing,
          size: 30,
          color: Colors.grey[400],
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            "We'll notify you when we find a job match for you",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Check back soon for new opportunities',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }
}
