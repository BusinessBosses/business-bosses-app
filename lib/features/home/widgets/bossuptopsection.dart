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
            children: <Widget>[
              Wrap(
                spacing: 8.0, // Space between items horizontally
                runSpacing: 10.0, // Space between rows vertically
                children: <Widget>[
                  _buildButton(context, 'Challenge',
                      Colors.grey.shade800.withOpacity(0.1), () {
                    Get.to(const BossupChallenge(
                      ishome: false,
                    ));
                  }),
                  _buildButton(context, 'Learning',
                      Colors.green.shade700.withOpacity(0.1), () {
                    Get.to(const LearningPage());
                  }),
                  _buildButton(context, 'Community',
                      Colors.red.shade700.withOpacity(0.1), () {
                    Get.to(() =>
                        const AllLearningPostsScreen(isCoursesTile: true));
                  }),
                  _buildButton(context, 'Events',
                      Colors.orange.shade900.withOpacity(0.1), () {
                    Get.toNamed(Routes.liveEvents);
                  }),
                  _buildButton(context, 'Crowdfund',
                      Colors.purple.shade700.withOpacity(0.1), () {
                    Get.to(const DonationsPage());
                  }),
                  _buildButton(
                      context, 'Upgrade +', proprimaryColor.withOpacity(0.1),
                      () {
                    // Action for Upgrade + button
                    print('Upgrade + button tapped');
                  }),
                ],
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
      child: Container(
        width: (MediaQuery.of(context).size.width - 46) /
            3, // Same width for each button
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: color, // Transparent color for the container
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: color.withOpacity(1.0), // Fully opaque color for the text
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
