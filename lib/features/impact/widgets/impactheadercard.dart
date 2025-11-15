import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Reach Breakdown',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[900],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Detailed view of reach and influence',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Reach Items
          _buildReachItem(
            icon: Icons.favorite,
            iconColor: Colors.red[400]!,
            iconBgColor: Colors.red[50]!,
            title: 'Likes',
            subtitle: 'Post engagement',
            value: widget.data['totalLikes'].toString(),
          ),

          _buildReachItem(
            icon: Icons.visibility,
            iconColor: Colors.blue[400]!,
            iconBgColor: Colors.blue[50]!,
            title: 'Views',
            subtitle: 'Content reach',
            value: widget.data['totalViews'].toString(),
          ),

          // GestureDetector(
          //   onTap: () {
          //     Get.toNamed(
          //       Routes.referalsscreen,
          //       arguments: profile.uid,
          //     );
          //   },
          //   child: _buildReachItem(
          //     icon: Icons.people,
          //     iconColor: Colors.green[400]!,
          //     iconBgColor: Colors.green[50]!,
          //     title: 'Referrals',
          //     subtitle: 'Click to see who',
          //     value: 0.toString(),
          //     isLast: false,
          //   ),
          // ),

          Padding(
            padding: const EdgeInsets.all(20),
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
                  (widget.data['totalLikes'] + widget.data['totalViews'])
                      .toString(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[900],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReachItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required String value,
    bool isLast = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: <Widget>[
          // Icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
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
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[900],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
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
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[900],
            ),
          ),
        ],
      ),
    );
  }
}
