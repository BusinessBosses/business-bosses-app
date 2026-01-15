import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/forum/presentation/bossup_challenge.dart';
import 'package:business_bosses_v2/features/home/all_communities_screen.dart';
import 'package:business_bosses_v2/features/posts/presentation/create_post_screen.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/features/profile/presentation/update_profile_screen.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:business_bosses_v2/features/impact/presentation/verify_business_screen.dart';

class ReachHeaderCard extends StatefulWidget {
  final dynamic data;
  const ReachHeaderCard({super.key, this.data});

  @override
  State<ReachHeaderCard> createState() => _ReachHeaderCardState();
}

class _ReachHeaderCardState extends State<ReachHeaderCard> {
  ProfileController profileController = Get.find();
  UserModel get profile => UserModel.fromMap(widget.data['user']);

  @override
  Widget build(BuildContext context) {
    // Calculate Breakdown scores
    final Map<String, dynamic> dataMap =
        widget.data is Map ? widget.data : <String, dynamic>{};
    final double profileScore = (dataMap['profileScore'] ?? 45).toDouble();
    final double engagementScore =
        (dataMap['engagementScore'] ?? 30).toDouble();
    final double discoveryScore = (dataMap['discoveryScore'] ?? 20).toDouble();
    final double trustScore = (dataMap['trustScore'] ?? 20).toDouble();

    final int totalLikes = widget.data['totalLikes'] ?? 0;
    final int totalViews = widget.data['totalViews'] ?? 0;

    final int totalReachScore = (totalLikes +
            totalViews +
            profileScore +
            engagementScore +
            discoveryScore +
            trustScore)
        .toInt();

    return Column(
      children: <Widget>[
        // Reach Breakdown Card
        SizedBox(
          height: 10,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              initiallyExpanded: false,
              tilePadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              childrenPadding: const EdgeInsets.only(bottom: 20),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Reach Breakdown',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[900],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Detailed view of reach and influence',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  Text(
                    totalReachScore.toString(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryColorLT,
                    ),
                  ),
                ],
              ),
              children: <Widget>[
                const Divider(height: 1),
                const SizedBox(height: 10),

                // Reach Items (Likes & Views & Scores)
                _buildReachItem(
                  icon: LucideIcons.heart,
                  iconColor: Colors.red[400]!,
                  iconBgColor: backgroundColor,
                  title: 'Likes',
                  subtitle: 'Post engagement',
                  value: totalLikes.toString(),
                ),

                _buildReachItem(
                  icon: LucideIcons.eye,
                  iconColor: Colors.blue[400]!,
                  iconBgColor: backgroundColor,
                  title: 'Views',
                  subtitle: 'Content reach',
                  value: totalViews.toString(),
                ),

                _buildReachItem(
                  icon: LucideIcons.userCircle,
                  iconColor: Colors.green[400]!,
                  iconBgColor: backgroundColor,
                  title: 'Profile Reach',
                  subtitle: 'Profile effectiveness',
                  value: profileScore.toInt().toString(),
                ),

                _buildReachItem(
                  icon: LucideIcons.messageCircle,
                  iconColor: Colors.purple[400]!,
                  iconBgColor: backgroundColor,
                  title: 'Engagement Reach',
                  subtitle: 'Interaction quality',
                  value: engagementScore.toInt().toString(),
                ),
                _buildReachItem(
                  icon: LucideIcons.globe,
                  iconColor: Colors.orange[400]!,
                  iconBgColor: backgroundColor,
                  title: 'Discovery Reach',
                  subtitle: 'Visibility score',
                  value: discoveryScore.toInt().toString(),
                ),
                _buildReachItem(
                  icon: LucideIcons.shieldCheck,
                  iconColor: Colors.teal[400]!,
                  iconBgColor: backgroundColor,
                  title: 'Trust Reach',
                  subtitle: 'Verification status',
                  value: trustScore.toInt().toString(),
                ),

                // Total Reach Score Section
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: primaryColorLT.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: primaryColorLT.withValues(alpha: 0.1)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Total Reach Score',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[900],
                          ),
                        ),
                        Text(
                          totalReachScore.toString(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: primaryColorLT,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 15),

        // Recommended Actions Card
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Recommended Actions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 15),
              _buildImprovementActions(
                profileScore,
                engagementScore,
                discoveryScore,
                trustScore,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReachItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: <Widget>[
          // Icon
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),

          // Title and subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[900],
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // Value
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[900],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImprovementActions(double profileScore, double engagementScore,
      double discoveryScore, double trustScore) {
    final List<Map<String, dynamic>> allActions = <Map<String, dynamic>>[
      <String, dynamic>{
        'score': profileScore,
        'title': 'Complete Profile',
        'subtitle': 'Maximize Profile Reach',
        'expectedIncrease': 10,
        'ctaLabel': 'Edit Profile',
        'color': Colors.white,
        'iconColor': primaryColorLT,
        'icon': LucideIcons.userCheck,
        'onTap': () {
          Get.to(() => UpdateProfileScreen(
                user: profileController.myProfile,
              ));
        },
      },
      <String, dynamic>{
        'score': engagementScore,
        'title': 'Join a Challenge',
        'subtitle': 'Boost Engagement Reach',
        'expectedIncrease': 15,
        'ctaLabel': 'Get Featured',
        'color': Colors.white,
        'iconColor': primaryColorLT,
        'icon': LucideIcons.trophy,
        'onTap': () {
          Get.to(() => AllCommunitiesScreen());
        },
      },
      <String, dynamic>{
        'score': discoveryScore,
        'title': 'Boost a Post',
        'subtitle': 'Expand Discovery Reach',
        'expectedIncrease': 20,
        'ctaLabel': 'Boost',
        'color': Colors.white,
        'iconColor': primaryColorLT,
        'icon': LucideIcons.rocket,
        'onTap': () {
          Get.to(CreatePostScreen());
        },
      },
      <String, dynamic>{
        'score': trustScore,
        'title': 'Verify your Business',
        'subtitle': 'Increase Trust Reach',
        'expectedIncrease': 25,
        'ctaLabel': 'Get Verified',
        'color': Colors.white,
        'iconColor': primaryColorLT,
        'icon': LucideIcons.badgeCheck,
        'onTap': () {
          Get.to(() => const VerifyBusinessScreen());
        },
      },
    ];

    allActions.sort((Map<String, dynamic> a, Map<String, dynamic> b) =>
        (a['score'] as double).compareTo(b['score'] as double));

    final List<Map<String, dynamic>> topActions = allActions.take(3).toList();

    return Column(
      children: topActions.map((Map<String, dynamic> action) {
        return _buildActionCard(
          title: action['title'] as String,
          subtitle: action['subtitle'] as String,
          expectedIncrease: action['expectedIncrease'] as int,
          ctaLabel: action['ctaLabel'] as String,
          color: action['color'] as Color,
          iconColor: action['iconColor'] as Color,
          icon: action['icon'] as IconData,
          onTap: action['onTap'] as VoidCallback,
        );
      }).toList(),
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required int expectedIncrease,
    required String ctaLabel,
    required Color color,
    required Color iconColor,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: textColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '+$expectedIncrease Reach Score',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: iconColor,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              minimumSize: const Size(0, 32),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: iconColor),
              ),
            ),
            child: Text(
              ctaLabel,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
