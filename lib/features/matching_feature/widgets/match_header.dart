import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class MatchHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final int weeklyMatches;
  final int totalMatches;
  final int matchQuality;

  const MatchHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.weeklyMatches,
    required this.totalMatches,
    required this.matchQuality,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[primaryBlue, accentPurple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
          // SizedBox(
          //   height: 15,
          // ),
          // Container(
          //   decoration: BoxDecoration(
          //     color: Colors.white.withOpacity(0.15),
          //     borderRadius: BorderRadius.circular(16),
          //   ),
          //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceAround,
          //     children: <Widget>[
          //       _buildStat(LucideIcons.calendar, weeklyMatches.toString(),
          //           'This Week'),
          //       _buildDivider(),
          //       _buildStat(LucideIcons.users, totalMatches.toString(),
          //           'Total Available'),
          //       _buildDivider(),
          //       _buildStat(LucideIcons.searchCheck,
          //           '${matchQuality.toString()}%', 'Match Quality'),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  // Widget _buildStat(IconData icon, String number, String label) {
  //   return Column(
  //     children: <Widget>[
  //       Icon(icon, color: Colors.white, size: 20),
  //       const SizedBox(height: 4),
  //       Text(
  //         number,
  //         style: const TextStyle(
  //           fontSize: 18,
  //           fontWeight: FontWeight.bold,
  //           color: Colors.white,
  //         ),
  //       ),
  //       Text(
  //         label,
  //         style: const TextStyle(
  //           fontSize: 12,
  //           color: Colors.white70,
  //         ),
  //         textAlign: TextAlign.center,
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildDivider() {
  //   return Container(
  //     width: 1,
  //     height: 40,
  //     color: Colors.white.withOpacity(0.3),
  //   );
  // }
}
