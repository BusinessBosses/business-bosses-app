import 'package:business_bosses_v2/features/donations/presentation/donations.dart';
import 'package:business_bosses_v2/features/forum/presentation/all_forum_screen.dart';
import 'package:business_bosses_v2/features/forum/presentation/bossup_challenge.dart';
import 'package:business_bosses_v2/features/home/controller/commumities_controller.dart';
import 'package:business_bosses_v2/features/home/widgets/all_learning_posts.dart';
import 'package:business_bosses_v2/features/home/widgets/learningpage.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/constants/constants.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BossUpTopSection extends StatelessWidget {
  const BossUpTopSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommunitiesController>(
      builder: (CommunitiesController controller) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildButton(context, 'Challenge', Colors.grey, () {
                      Get.to(const BossupChallenge(
                        ishome: false,
                      ));
                    }),
                    _buildButton(context, 'Learning', Colors.orange.shade200,
                        () {
                      Get.to(LearningPage());
                    }),
                    _buildButton(context, 'Community', Colors.purple.shade200,
                        () {
                      Get.to(() =>
                          const AllLearningPostsScreen(isCoursesTile: true));
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 10), // Space between the two rows
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildButton(context, 'Events', Colors.orange.shade700, () {
                      Get.toNamed(Routes.liveEvents);
                    }),
                    _buildButton(context, 'Crowdfund', Colors.purple.shade300,
                        () {
                      Get.to(DonationsPage());
                    }),
                    _buildButton(context, 'Upgrade +', proprimaryColor, () {
                      // Action for Upgrade + button
                      print('Upgrade + button tapped');
                    }),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildButton(
      BuildContext context, String text, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
