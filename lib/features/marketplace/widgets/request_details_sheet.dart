import 'package:business_bosses_v2/action/action.dart';
import 'package:business_bosses_v2/utils/currency_format.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/common/widgets/popup/my_popup_menu_button.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/requests_controller.dart';
import 'package:business_bosses_v2/features/marketplace/models/buyer_request_model.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/apply_to_job_button.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/buyer_requests_form.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/features/profile/presentation/public_profile_screen.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RequestDetailsSheet {
  static void show(BuildContext context, BuyerRequestModel request) {
    final bool hasValidImg = _isValidImageUrl(request.imageUrl);
    final bool hasValidPfp = _isValidImageUrl(request.user.photoUrl);
    final ProfileController profileController = Get.find();
    final bool isMine = request.user.uid == profileController.myProfile.uid;

    final List<PopupMenuEntry<String>> menuOwner = <PopupMenuEntry<String>>[
      const PopupMenuItem<String>(value: 'Edit', child: Text('Edit')),
      const PopupMenuDivider(),
      const PopupMenuItem<String>(value: 'Share', child: Text('Share')),
      const PopupMenuDivider(),
      const PopupMenuItem<String>(value: 'Delete', child: Text('Delete')),
    ];
    final List<PopupMenuEntry<String>> menuOther = <PopupMenuEntry<String>>[
      const PopupMenuItem<String>(value: 'Share', child: Text('Share')),
      const PopupMenuDivider(),
      const PopupMenuItem<String>(value: 'Block', child: Text('Block')),
      const PopupMenuDivider(),
      const PopupMenuItem<String>(value: 'Report', child: Text('Report')),
    ];

    Get.bottomSheet(
      DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 0.95,
        expand: false,
        builder: (BuildContext ctx, ScrollController scroll) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            controller: scroll,
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
                      )),
                ),
                const SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Get.to(() => PublicProfileScreen(),
                            arguments: request.user),
                        child: Row(
                          children: <Widget>[
                            if (hasValidPfp)
                              NetworkImageWithPlaceHolder(
                                imageUrl: request.user.photoUrl!,
                                height: 40,
                                width: 40,
                                radius: 50,
                                placeHolder: Icons.person,
                              )
                            else
                              const CircleAvatar(
                                  radius: 20, child: Icon(Icons.person)),
                            const SizedBox(width: 10),
                            Text(
                              (request.user.name ?? request.user.username),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    const Spacer(),
                    MyPopupMenuButton(
                      popupItems: isMine ? menuOwner : menuOther,
                      icon: const Icon(Icons.more_horiz),
                      onSelected: (String val) async {
                        if (val == 'Edit') {
                          Get.back();
                          Get.to(() => AddBuyerRequests(request: request));
                        } else if (val == 'Share') {
                          _shareRequest(request);
                        } else if (val == 'Delete') {
                          final bool? confirmed =
                              await _showDeleteConfirmation();
                          if (confirmed == true) {
                            final BuyerRequestController
                                buyerRequestController = Get.find();
                            final bool success = await buyerRequestController
                                .deleteBuyerRequest(request.id!);
                            if (success) {
                              showSnackbar(
                                  message: 'Job deleted successfully!');
                              Get.back(); // Close bottom sheet
                            } else {
                              showSnackbar(
                                  message: 'Error deleting job!',
                                  error: true);
                            }
                          }
                        } else if (val == 'Block') {
                          ApiService.post(
                            path: 'blockedpost',
                            body: <String, dynamic>{'postId': request.id},
                          );
                          Get.back();
                        } else if (val == 'Report') {
                          ApiService.post(
                            path: 'reportedpost',
                            body: <String, dynamic>{
                              'postId': request.id,
                              'reason': 'Reported from Marketplace',
                            },
                          );
                          Get.back();
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (hasValidImg)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: NetworkImageWithPlaceHolder(
                      imageUrl: request.imageUrl!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(height: 16),
                Text(request.title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(request.description),
                const SizedBox(height: 12),
                if (CurrencyFormatter.budgetRange(
                        request.budgetStart, request.budgetEnd) !=
                    null) ...<Widget>[
                  _detail(
                      Icons.attach_money,
                      'Budget',
                      CurrencyFormatter.budgetRange(
                          request.budgetStart, request.budgetEnd)!),
                  const SizedBox(height: 8),
                ],
                _detail(
                    Icons.calendar_today,
                    'Deadline',
                    DateFormat('MMMM dd, yyyy').format(
                        DateTime.tryParse(request.deadline) ?? DateTime.now())),
                const SizedBox(height: 8),
                _detail(Icons.category, 'Category', request.category),
                const SizedBox(height: 16),
                // Anyone can apply to a job — no shop required.
                if (!isMine) ApplyToJobButton(request: request),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static bool _isValidImageUrl(String? url) =>
      url != null &&
      url.isNotEmpty &&
      Uri.parse(url).hasAbsolutePath &&
      (url.startsWith('http'));



  static Future<bool?> _showDeleteConfirmation() async {
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

  static void _shareRequest(BuyerRequestModel request) {
    String message = 'Check out this job on Business Bosses\n'
        'Title: ${request.title}\n'
        'Budget: \$${(request.budgetStart > 0 ? request.budgetStart : request.budgetEnd).toStringAsFixed(0)}\n'
        'https://vm.businessbosses.co.uk/share/post';
    logEvent(request.id ?? '', 'buyer_request');
    socialShare(message);
  }

  static Widget _detail(IconData icon, String title, String val) => Row(
        children: <Widget>[
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Text('$title: ', style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(child: Text(val)),
        ],
      );
}
