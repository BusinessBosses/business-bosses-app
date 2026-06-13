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
      builder: (BuildContext context) {
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

              // Post with AI
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (BuildContext context) => const AIPromoteSheet(),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F7FF),
                    border:
                        Border.all(color: const Color(0xFF0D47A1), width: 1.5),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: const Icon(Icons.auto_awesome,
                            color: Color(0xFF0D47A1), size: 30),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                const Text(
                                  'Post with AI ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color(0xFF1F2937),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFD54F),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: const Text(
                                    'Get Matched',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Color(0xFF1F2937),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Get featured, get matched, and discover new opportunities faster.',
                              style: TextStyle(
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
              ),
              const SizedBox(height: 15),

              // Sell my product or service
              _buildOptionItem(
                iconPath: 'assets/svgs/sell_bag.svg',
                iconData: Icons.shopping_bag_outlined,
                iconColor: const Color(0xFFFFEBEE),
                iconTintColor: const Color(0xFFEF4444),
                title: 'Sell my product or service',
                subtitle:
                    'Showcase what you offer to buyers searching right now',
                onTap: () {
                  Navigator.pop(context);
                  sellProduct(context);
                },
              ),
              const SizedBox(height: 15),

              // Need a Product or Service
              _buildOptionItem(
                iconPath: 'assets/svgs/need_doc.svg',
                iconData: Icons.description_outlined,
                iconColor: const Color(0xFFE8F5E9),
                iconTintColor: const Color(0xFF22C55E),
                title: 'Need a Product or Service',
                subtitle:
                    'Post what you need and get matched with the right supplier',
                onTap: () {
                  Navigator.pop(context);
                  Get.to(() => const AddBuyerRequests());
                },
              ),
              const SizedBox(height: 15),

              // Start a conversation
              _buildOptionItem(
                iconPath: 'assets/svgs/chat_bubble.svg',
                iconData: Icons.chat_bubble_outline,
                iconColor: const Color(0xFFFFF8E1),
                iconTintColor: const Color(0xFFF59E0B),
                title: 'Start a conversation',
                subtitle:
                    'Share content, updates, announcements, or discussion.',
                onTap: () {
                  Navigator.pop(context);
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
    required String iconPath,
    required IconData iconData,
    required Color iconColor,
    required Color iconTintColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade200, width: 1),
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
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF1F2937),
                    ),
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
