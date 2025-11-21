import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/features/chat/chat_room_screen.dart';
import 'package:business_bosses_v2/features/home/widgets/buyer_request_item.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/requests_controller.dart';
import 'package:business_bosses_v2/features/marketplace/models/buyer_request_model.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/buyer_requests_form.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/features/profile/presentation/public_profile_screen.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BuyerRequestsScreen extends StatefulWidget {
  const BuyerRequestsScreen({super.key});

  @override
  State<BuyerRequestsScreen> createState() => _BuyerRequestsScreenState();
}

class _BuyerRequestsScreenState extends State<BuyerRequestsScreen> {
  final BuyerRequestController _buyerRequestController =
      Get.put(BuyerRequestController());
  final ProfileController profileController = Get.find();

  final String _selectedFilter = 'All';
  List<BuyerRequestModel> _filteredRequests = <BuyerRequestModel>[];

  @override
  void initState() {
    super.initState();
  }

  Future<void> _fetchRequests() async {
    await _buyerRequestController.initBuyerRequests();
    _applyFilter();
  }

  void _applyFilter() {
    final RxList<BuyerRequestModel> allRequests =
        _buyerRequestController.buyerRequests;
    setState(() {
      if (_selectedFilter == 'All') {
        _filteredRequests = List<BuyerRequestModel>.from(allRequests);
      } else if (_selectedFilter == 'Active') {
        _filteredRequests = allRequests
            .where((BuyerRequestModel r) =>
                DateTime.tryParse(r.deadline)?.isAfter(DateTime.now()) == true)
            .toList();
      } else if (_selectedFilter == 'Has Offers') {
        _filteredRequests = allRequests
            .where((BuyerRequestModel r) => r.offerCount > 0)
            .toList();
      } else if (_selectedFilter == 'Closing Soon') {
        _filteredRequests = allRequests
            .where((BuyerRequestModel r) =>
                DateTime.tryParse(r.deadline)!
                    .difference(DateTime.now())
                    .inDays <=
                7)
            .toList();
      }
    });
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
                            print('logged');
                            // 🟢 Show loading dialog
                            Get.dialog(
                              const Center(child: CircularProgressIndicator()),
                              barrierDismissible: false,
                            );

                            // 🚀 Perform delete action
                            final bool success = await _buyerRequestController
                                .deleteBuyerRequest(
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
      backgroundColor: backgroundColor,
      body: Obx(() {
        if (_buyerRequestController.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_buyerRequestController.error.value) {
          return Center(
            child: Text(
              'Error loading requests',
              style: TextStyle(color: Colors.grey[700]),
            ),
          );
        }

        // ✅ Fix: safely apply filter AFTER current frame
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _applyFilter();
        });

        return _filteredRequests.isEmpty
            ? _buildEmptyState()
            : RefreshIndicator(
                onRefresh: _fetchRequests,
                child: MasonryGridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, top: 15, bottom: 100),
                  itemCount: _filteredRequests.length,
                  itemBuilder: (BuildContext context, int index) {
                    final BuyerRequestModel request = _filteredRequests[index];
                    return BuyerRequestItem(
                      request: request,
                      onApply: () => _navigateToChatScreen(request),
                      onTap: () => _showRequestDetails(request),
                    );
                  },
                ),
              );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.inbox_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No requests found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
