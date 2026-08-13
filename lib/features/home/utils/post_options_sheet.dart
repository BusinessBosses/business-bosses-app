import 'package:business_bosses_v2/features/aipromote/ai_promote_sheet.dart';
import 'package:business_bosses_v2/features/home/sell_product.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/buyer_requests_form.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostOptionsBottomSheet {
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext sheetContext) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 30),

              // Post with AI — the promoted option, so it leads and carries
              // the highlighted treatment.
              _buildOptionItem(
                iconData: Icons.auto_awesome,
                iconColor: Colors.transparent,
                iconTintColor: const Color(0xFF2563EB),
                title: 'Post with AI',
                badge: 'Get Matched',
                subtitle:
                    'Get featured, get matched, and discover new opportunities faster.',
                highlighted: true,
                onTap: () {
                  Navigator.pop(sheetContext);
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (BuildContext _) => AIPromoteSheet(),
                  );
                },
              ),
              const SizedBox(height: 15),

              // Sell my product or service
              _buildOptionItem(
                iconData: Icons.shopping_bag_outlined,
                iconColor: const Color(0xFFFFEBEE),
                iconTintColor: const Color(0xFFEF4444),
                title: 'Sell my product or service',
                subtitle: 'Showcase what you offer to buyers searching right now',
                onTap: () {
                  Navigator.pop(sheetContext);
                  sellProduct(context);
                },
              ),
              const SizedBox(height: 15),

              // Need work done
              _buildOptionItem(
                iconData: Icons.description_outlined,
                iconColor: const Color(0xFFE8F5E9),
                iconTintColor: const Color(0xFF22C55E),
                title: 'Need work done',
                subtitle:
                    'Post what you need and get matched with the right talent',
                onTap: () {
                  Navigator.pop(sheetContext);
                  Get.to(() => const AddBuyerRequests());
                },
              ),
              const SizedBox(height: 15),

              // Start a conversation
              _buildOptionItem(
                iconData: Icons.chat_bubble_outline,
                iconColor: const Color(0xFFFEF3C7),
                iconTintColor: const Color(0xFFF59E0B),
                title: 'Start a conversation',
                subtitle: 'Share content, updates, announcements, or discussion.',
                onTap: () {
                  Navigator.pop(sheetContext);
                  Get.toNamed(Routes.createPost);
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }

  static Widget _buildOptionItem({
    required IconData iconData,
    required Color iconColor,
    required Color iconTintColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    String? badge,
    bool highlighted = false,
  }) {
    const Color highlightBorder = Color(0xFF1E3A5F);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: highlighted ? const Color(0xFFF5F8FF) : Colors.white,
          border: Border.all(
            color: highlighted ? highlightBorder : Colors.grey.shade200,
            width: highlighted ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(iconData, color: iconTintColor, size: 24),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: highlighted
                                ? highlightBorder
                                : const Color(0xFF1F2937),
                          ),
                        ),
                      ),
                      if (badge != null) ...<Widget>[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFCD34D),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            badge,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF4B5563),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
