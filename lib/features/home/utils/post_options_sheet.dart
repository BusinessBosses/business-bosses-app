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

              // Start a Conversation
              _buildOptionItem(
                iconPath: 'assets/svgs/chat_bubble.svg',
                iconData: Icons.auto_awesome,
                iconColor: const Color(0xFFEEF2FF),
                iconTintColor: const Color(0xFF6366F1),
                title: 'Start a Conversation',
                subtitle: 'Share content and updates. Get featured.',
                onTap: () {
                  Navigator.pop(context);
                  Get.toNamed(Routes.createPost);
                },
              ),
              const SizedBox(height: 15),

              // Sell Product or Services
              _buildOptionItem(
                iconPath: 'assets/svgs/sell_bag.svg',
                iconData: Icons.shopping_bag_outlined,
                iconColor: const Color(0xFFFFEBEE),
                iconTintColor: const Color(0xFFEF4444),
                title: 'Sell Product or Services',
                subtitle: 'Reach customers who are searching right now.',
                onTap: () {
                  Navigator.pop(context);
                  sellProduct(context);
                },
              ),
              const SizedBox(height: 15),

              // Post a Job
              _buildOptionItem(
                iconPath: 'assets/svgs/need_doc.svg',
                iconData: Icons.description_outlined,
                iconColor: const Color(0xFFE8F5E9),
                iconTintColor: const Color(0xFF22C55E),
                title: 'Post a Job',
                subtitle: 'Get your work done faster, with the best talent.',
                onTap: () {
                  Navigator.pop(context);
                  Get.to(() => const AddBuyerRequests());
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
