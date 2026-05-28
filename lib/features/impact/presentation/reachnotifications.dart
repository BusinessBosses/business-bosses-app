import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ReachNotificationsScreen extends StatefulWidget {
  const ReachNotificationsScreen({super.key});

  @override
  State<ReachNotificationsScreen> createState() =>
      _ReachNotificationsScreenState();
}

class _ReachNotificationsScreenState extends State<ReachNotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    // Example list of notifications
    final List<String> notifications = <String>[
      'Your post reached 1,000 people!',
      'You have a new follower.',
      'Your campaign was approved.',
      'Reminder: Update your business profile.',
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        ),
        centerTitle: true,
        title: const Text(
          'Reach Notifications',
          textAlign: TextAlign.center,
        ),
      ),
      body: ListView.separated(
        itemCount: notifications.length,
        separatorBuilder: (BuildContext context, int index) =>
            const Divider(height: 1),
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: const Icon(
              LucideIcons.bell,
              size: 18,
            ),
            title: Text(notifications[index]),
          );
        },
      ),
    );
  }
}
