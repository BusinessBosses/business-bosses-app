import 'package:business_bosses_v2/features/marketplace/controllers/requests_controller.dart';
import 'package:business_bosses_v2/features/marketplace/models/buyer_request_model.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/request_details_sheet.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuccessScreen extends StatelessWidget {
  final VoidCallback onCreateAnother;

  const SuccessScreen({super.key, required this.onCreateAnother});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 20),
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFE8F5E9),
          ),
          child: const Icon(
            Icons.check_circle_outline,
            color: Color(0xFF4CAF50),
            size: 40,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Success!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Your post is now live. Here are matched opportunities for you',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF4B5563),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 24),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(
                      '1,000+',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF6366F1),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Potential Viewers',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: Color(0xFFE5E7EB),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(
                      'Global',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF6366F1),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Reach',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Showing real matches from the BuyerRequestController
        GetBuilder<BuyerRequestController>(
          init: BuyerRequestController(),
          builder: (BuyerRequestController controller) {
            if (controller.loading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.buyerRequests.isEmpty) {
              return Center(
                child: Text(
                  'No matching requests found yet.',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              );
            }

            // Show top 3 matches
            final List<BuyerRequestModel> matches =
                controller.buyerRequests.take(3).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${matches.length} Match${matches.length > 1 ? "es" : ""} found',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 12),
                ...matches.map((BuyerRequestModel request) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: Colors.orange.withValues(alpha: 0.1),
                        child: const Icon(Icons.person_outline,
                            color: Colors.orange),
                      ),
                      title: Text(
                        request.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        request.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12),
                      ),
                      trailing: const Icon(Icons.chevron_right, size: 16),
                      onTap: () {
                        RequestDetailsSheet.show(context, request);
                      },
                    ),
                  );
                }),
              ],
            );
          },
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Get.offAllNamed(Routes.marketPlace);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColorLT,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Go Home',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
