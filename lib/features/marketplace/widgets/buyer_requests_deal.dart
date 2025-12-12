import 'package:business_bosses_v2/action/action.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/common/widgets/popup/my_popup_menu_button.dart';
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/chat/chat_room_screen.dart';
import 'package:business_bosses_v2/features/home/marketplace_screen.dart';
import 'package:business_bosses_v2/features/marketplace/models/buyer_request_model.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/requests_controller.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/buyer_requests_form.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/features/profile/presentation/public_profile_screen.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BuyerRequestDealsWidget extends StatefulWidget {
  final String title;
  final bool isHome;

  const BuyerRequestDealsWidget({
    super.key,
    this.title = 'Buyer Requests',
    this.isHome = false,
  });

  @override
  State<BuyerRequestDealsWidget> createState() =>
      _BuyerRequestDealsWidgetState();
}

class _BuyerRequestDealsWidgetState extends State<BuyerRequestDealsWidget> {
  final BuyerRequestController requestController =
      Get.put(BuyerRequestController());
  final ProfileController profileController = Get.find();

  @override
  void initState() {
    if (requestController.buyerRequests.isEmpty) {
      requestController.initBuyerRequests();
    }
    super.initState();
  }

  bool _isValidImageUrl(String? url) =>
      url != null &&
      url.isNotEmpty &&
      Uri.parse(url).hasAbsolutePath &&
      (url.startsWith('http'));

  void _navigateToChatScreen(BuyerRequestModel req) {
    Get.to(
      () =>
          const ChatRoomScreen(frommarketplace: false, fromBuyerRequest: true),
      arguments: <String, Object>{'user': req.user, 'buyerRequest': req},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final List<BuyerRequestModel> requests = requestController.buyerRequests
          .where((BuyerRequestModel e) => _isValidImageUrl(e.imageUrl))
          .take(10)
          .toList();

      return GestureDetector(
        onTap: () => Get.off(() => const MarketplaceScreen()),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(widget.isHome ? 0 : 15),
          ),
          margin: EdgeInsets.symmetric(
            horizontal: widget.isHome ? 0 : 10,
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(widget.title,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Row(children: const <Widget>[
                      Text('Explore',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600)),
                      Icon(Icons.chevron_right, color: textColor, size: 20),
                    ]),
                  ],
                ),
              ),
              SizedBox(
                height: 160,
                child: requestController.loading.value
                    ? SafetyModel()
                    : requests.isEmpty
                        ? Center(
                            child: Text('No requests available',
                                style: TextStyle(color: Colors.grey[600])),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: requests.length,
                            padding: const EdgeInsets.only(left: 10),
                            itemBuilder: (BuildContext context, int index) {
                              final BuyerRequestModel request = requests[index];
                              final String deadline =
                                  DateFormat('MMM d').format(
                                DateTime.tryParse(request.deadline) ??
                                    DateTime.now(),
                              );

                              return GestureDetector(
                                onTap: () => _showRequestDetails(request),
                                child: Container(
                                  width: 130,
                                  margin: const EdgeInsets.only(right: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: NetworkImageWithPlaceHolder(
                                          imageUrl: request.imageUrl!,
                                          height: 90,
                                          width: 130,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        request.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        '\$${request.budgetStart} - \$${request.budgetEnd}',
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.black),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Due: $deadline',
                                        style: const TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
              )
            ],
          ),
        ),
      );
    });
  }

  /* ----------------------------------------------------------
   * COPIED FULL showRequestDetails FUNCTION FROM THE SCREEN
   * ---------------------------------------------------------- */
  void _showRequestDetails(BuyerRequestModel request) {
    final bool hasValidImg = _isValidImageUrl(request.imageUrl);
    final bool hasValidPfp = _isValidImageUrl(request.user.photoUrl);
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

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (BuildContext ctx) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 0.95,
        expand: false,
        builder: (BuildContext ctx, ScrollController scroll) =>
            SingleChildScrollView(
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
                            request.user.name ?? request.user.username,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          )
                        ],
                      ),
                    ),
                  ),
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
                        ApiService.delete(path: 'buyerrequest/${request.id}');
                        Get.back();
                      }
                    },
                  )
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
              _detail(Icons.attach_money, 'Budget',
                  '\$${request.budgetStart} - \$${request.budgetEnd}'),
              const SizedBox(height: 8),
              _detail(
                  Icons.calendar_today,
                  'Deadline',
                  DateFormat('MMMM dd, yyyy').format(
                      DateTime.tryParse(request.deadline) ?? DateTime.now())),
              const SizedBox(height: 8),
              _detail(Icons.category, 'Category', request.category),
              const SizedBox(height: 16),
              if (!isMine)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _navigateToChatScreen(request),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColorLT,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Send Proposal',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  void _shareRequest(BuyerRequestModel request) {
    String message = 'Check out this buyer request on Business Bosses\n'
        'Title: ${request.title}\n'
        'Budget: \$${request.budgetStart.toStringAsFixed(0)} - \$${request.budgetEnd.toStringAsFixed(0)}\n'
        'https://vm.businessbosses.co.uk/share/post';
    logEvent(request.id ?? '', 'buyer_request');
    socialShare(message);
  }

  Widget _detail(IconData icon, String title, String val) => Row(
        children: <Widget>[
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Text('$title: ', style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(child: Text(val)),
        ],
      );
}
