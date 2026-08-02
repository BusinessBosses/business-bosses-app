import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/home/marketplace_screen.dart';
import 'package:business_bosses_v2/features/marketplace/models/buyer_request_model.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/requests_controller.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/request_details_sheet.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:business_bosses_v2/utils/currency_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BuyerRequestDealsWidget extends StatefulWidget {
  final String title;
  final bool isHome;

  const BuyerRequestDealsWidget({
    super.key,
    this.title = 'Jobs',
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

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final List<BuyerRequestModel> requests = requestController.buyerRequests
          .where((BuyerRequestModel e) => _isValidImageUrl(e.imageUrl))
          .take(10)
          .toList();

      return GestureDetector(
        onTap: () => Get.to(() => const MarketplaceScreen(initialIndex: MarketplaceScreen.jobsTab)),
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
                            child: Text('No jobs available',
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
                                      if (CurrencyFormatter.budgetRange(
                                              request.budgetStart,
                                              request.budgetEnd) !=
                                          null) ...<Widget>[
                                        const SizedBox(height: 3),
                                        Text(
                                          CurrencyFormatter.budgetRange(
                                              request.budgetStart,
                                              request.budgetEnd)!,
                                          style: const TextStyle(
                                              fontSize: 12, color: Colors.black),
                                        ),
                                      ],
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
              ),
              Container(height: 7, color: backgroundColor),
            ],
          ),
        ),
      );
    });
  }

  void _showRequestDetails(BuyerRequestModel request) {
    RequestDetailsSheet.show(context, request);
  }
}
