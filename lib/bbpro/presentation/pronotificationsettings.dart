import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ProNotificationSettings extends StatefulWidget {
  const ProNotificationSettings({super.key});

  @override
  State<ProNotificationSettings> createState() =>
      _ProNotificationSettingsState();
}

class _ProNotificationSettingsState extends State<ProNotificationSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
          ),
          title: const Text(
            'Notification Settings',
            style: TextStyle(
              color: proprimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: const Placeholder());
  }
}
