import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/utils/constants/constants.dart';
import 'package:business_bosses_v2/features/home/all_communities_screen.dart';
import 'package:business_bosses_v2/features/impact/presentation/verify_business_screen.dart';
import 'package:business_bosses_v2/features/posts/presentation/create_post_screen.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/features/profile/presentation/my_profile_screen.dart';
import 'package:business_bosses_v2/features/profile/presentation/update_profile_screen.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ReachHeaderCard extends StatefulWidget {
  final dynamic data;
  final bool isMe;
  const ReachHeaderCard({super.key, this.data, this.isMe = false});

  @override
  State<ReachHeaderCard> createState() => _ReachHeaderCardState();
}

class _ReachHeaderCardState extends State<ReachHeaderCard> {
  ProfileController profileController = Get.find();
  UserModel get profile => UserModel.fromMap(widget.data['user']);

  String _formatValue(num value) {
    if (value >= 1000) {
      double formatted = value / 1000;
      return '${formatted.toStringAsFixed(formatted % 1 == 0 ? 0 : 1)}k';
    }
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate Breakdown scores
    final Map<String, dynamic> dataMap =
        widget.data is Map ? widget.data : <String, dynamic>{};
    final double profileScore = (dataMap['profileReach'] ?? 10).toDouble();
    final double engagementScore =
        (dataMap['engagementReach'] ?? 30).toDouble();
    final double discoveryScore = ((dataMap['shopPoints'] as num? ?? 0) +
            (dataMap['shopImpactScore'] as num? ?? 0))
        .toDouble();
    final double trustScore = (dataMap['trustReach'] ?? 20).toDouble();
    final double aiVisibilityScore =
        (dataMap['aiVisibilityScore'] as num? ?? 0).toDouble();

    final int totalLikes = widget.data['totalLikes'] ?? 0;
    final int totalViews = widget.data['totalViews'] ?? 0;
    final int totalComments = widget.data['totalComments'] ?? 0;

    final int totalReachScore =
        (dataMap['totalReachPoints'] as num? ?? 0).toInt();

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
                        'Reach Score Breakdown',
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
                      const SizedBox(height: 2),
                      const Text(
                        'The higher your score, the more opportunities you get',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: primaryColorLT,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    _formatValue(totalReachScore),
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
                  title: 'Interest',
                  subtitle: 'Active Interactions',
                  value: _formatValue(totalLikes + totalComments),
                ),

                _buildReachItem(
                  icon: LucideIcons.eye,
                  iconColor: Colors.blue[400]!,
                  iconBgColor: backgroundColor,
                  title: 'Views',
                  subtitle: 'Listing/Post Views',
                  value: _formatValue(totalViews),
                ),

                _buildReachItem(
                  icon: LucideIcons.userCircle,
                  iconColor: Colors.green[400]!,
                  iconBgColor: backgroundColor,
                  title: 'Profile Strength',
                  subtitle: 'Profile Completion Score',
                  value: _formatValue(profileScore.toInt()),
                ),

                _buildReachItem(
                  icon: LucideIcons.messageCircle,
                  iconColor: Colors.purple[400]!,
                  iconBgColor: backgroundColor,
                  title: 'Achievements',
                  subtitle: 'Featured, Challenge Wins',
                  value: _formatValue(engagementScore.toInt()),
                ),
                _buildReachItem(
                  icon: LucideIcons.globe,
                  iconColor: Colors.orange[400]!,
                  iconBgColor: backgroundColor,
                  title: 'Bizcenter Buyer Activity',
                  subtitle: 'Lead Intent & Buyer Demand',
                  value: _formatValue(discoveryScore.toInt()),
                  onTap: () {
                    Get.to(() => const MyProfileScreen(currentIndex: 1));
                  },
                ),
                _buildReachItem(
                  icon: LucideIcons.shieldCheck,
                  iconColor: Colors.teal[400]!,
                  iconBgColor: backgroundColor,
                  title: 'Trust',
                  subtitle: 'Verification status',
                  value: _formatValue(trustScore.toInt()),
                ),
                _buildReachItem(
                  icon: LucideIcons.bot,
                  iconColor: Colors.indigo[400]!,
                  iconBgColor: backgroundColor,
                  title: 'Business Health Data',
                  subtitle: 'Complete readiness score',
                  value: '${aiVisibilityScore.toInt()}%',
                  onTap: () async {
                    const String url = '$bizCenterBaseUrl';
                    if (await canLaunchUrlString(url)) {
                      await launchUrlString(url,
                          mode: LaunchMode.externalApplication);
                    }
                  },
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
                          _formatValue(totalReachScore),
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
        if (widget.isMe)
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
                  aiVisibilityScore,
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
    VoidCallback? onTap,
  }) {
    final Widget item = Container(
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
          if (onTap != null) ...<Widget>[
            const SizedBox(width: 4),
            Icon(
              LucideIcons.chevronRight,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ],
      ),
    );

    if (onTap == null) {
      return item;
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: item,
    );
  }

  Widget _buildImprovementActions(
    double profileScore,
    double engagementScore,
    double discoveryScore,
    double trustScore,
    double aiVisibilityScore,
  ) {
    final List<Map<String, dynamic>> allActions = <Map<String, dynamic>>[
      <String, dynamic>{
        'score': profileScore,
        'title': 'Complete Profile',
        'subtitle': 'Maximize Profile Strength',
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
        'subtitle': 'Boost Authority',
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
        'subtitle': 'Increase Interactions',
        'expectedIncrease': 20,
        'ctaLabel': 'Boost',
        'color': Colors.white,
        'iconColor': primaryColorLT,
        'icon': LucideIcons.rocket,
        'onTap': () {
          Get.to(() => const CreatePostScreen(fromBoost: true));
        },
      },
      <String, dynamic>{
        'score': trustScore,
        'title': 'Verify your Business',
        'subtitle': 'Increase Trust',
        'expectedIncrease': 100,
        'ctaLabel': 'Get Verified',
        'color': Colors.white,
        'iconColor': primaryColorLT,
        'icon': LucideIcons.badgeCheck,
        'onTap': () {
          Get.to(() => const VerifyBusinessScreen());
        },
      },
      <String, dynamic>{
        'score': aiVisibilityScore,
        'title': 'Boost Visibility',
        'subtitle': 'Reach a wider audience',
        'expectedIncrease': 50,
        'ctaLabel': 'Boost',
        'color': Colors.white,
        'iconColor': primaryColorLT,
        'icon': LucideIcons.bot,
        'onTap': () async {
          Get.to(() => const CreatePostScreen(fromBoost: true));
        },
      },
    ];

    // Filter out sections with a score of 100
    final List<Map<String, dynamic>> pendingActions = allActions
        .where(
            (Map<String, dynamic> action) => (action['score'] as double) < 100)
        .toList();

    // Sort by lowest score
    pendingActions.sort((Map<String, dynamic> a, Map<String, dynamic> b) =>
        (a['score'] as double).compareTo(b['score'] as double));

    // Take top 3
    final List<Map<String, dynamic>> topActions =
        pendingActions.take(3).toList();

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
