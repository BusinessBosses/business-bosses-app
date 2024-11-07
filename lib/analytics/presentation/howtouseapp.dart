// ignore_for_file: always_specify_types

import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class HowToUseAppScreen extends StatefulWidget {
  const HowToUseAppScreen({Key? key}) : super(key: key);

  @override
  State<HowToUseAppScreen> createState() => _HowToUseAppScreenState();
}

class _HowToUseAppScreenState extends State<HowToUseAppScreen> {
  final ProfileController profileController = Get.find();
  // Data for each tile

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> tilesData = <Map<String, dynamic>>[
      {
        'icon': SvgPicture.asset(
          'assets/svgs/cartu.svg',
          height: 35,
          colorFilter: const ColorFilter.mode(
            Colors.grey,
            BlendMode.srcIn,
          ),
        ),
        'title': 'Marketplace',
        'description':
            'Browse and purchase items from other users. You can find a wide variety of items here.',
        'screenRoute': '/marketplace',
      },
      {
        'icon': SvgPicture.asset(
          'assets/svgs/grow.svg',
          height: 35,
          colorFilter: const ColorFilter.mode(
            Colors.grey,
            BlendMode.srcIn,
          ),
        ),
        'title': 'Grow',
        'description':
            'Upgrade to Premium for exclusive features and benefits. Enjoy ad-free browsing and more.',
        'screenRoute': '/premium',
      },
      {
        'icon': SizedBox(
          height: 35.0,
          width: 35.0,
          child: Align(
            alignment: Alignment.topLeft,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(1000),
              child: NetworkImageWithPlaceHolder(
                imageUrl: profileController.myProfile.photoUrl ?? '',
                radius: radius,
                placeHolder: Icons.person,
                iconSize: 22.0,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        'title': 'Profile',
        'description':
            'View and edit your profile information. Manage your account settings and preferences.',
        'screenRoute': '/profile',
      },
      {
        'icon': SvgPicture.asset(
          'assets/svgs/bossupu.svg',
          height: 35,
          colorFilter: const ColorFilter.mode(
            Colors.grey,
            BlendMode.srcIn,
          ),
        ),
        'title': 'Boss Up',
        'description':
            'Connect with other users and build your network. Find friends who share your interests.',
        'screenRoute': '/friends',
      },
      {
        'icon': SvgPicture.asset(
          'assets/svgs/messages.svg',
          height: 35,
          colorFilter: const ColorFilter.mode(
            Colors.grey,
            BlendMode.srcIn,
          ),
        ),
        'title': 'Messages',
        'description':
            'Join or create groups to discuss topics with like-minded individuals. Share your thoughts and ideas.',
        'screenRoute': '/groups',
      },
      {
        'icon': SvgPicture.asset(
          'assets/svgs/calendar.svg',
          height: 35,
          colorFilter: const ColorFilter.mode(
            Colors.grey,
            BlendMode.srcIn,
          ),
        ),
        'title': 'Events',
        'description':
            'Manage your inventory of items. Track your purchases and sales.',
        'screenRoute': '/inventory',
      },
      {
        'icon': SvgPicture.asset(
          'assets/svgs/supporter.svg',
          height: 35,
          colorFilter: const ColorFilter.mode(
            Colors.grey,
            BlendMode.srcIn,
          ),
        ),
        'title': 'Crowdfund',
        'description':
            'Communicate with other users through private messages. Stay connected with your friends and colleagues.',
        'screenRoute': '/messages',
        // 'notificationCount': 1, // Example notification count
      },
      {
        'icon': const Icon(
          Icons.add,
          size: 35,
          color: Colors.grey,
        ),
        'title': 'Create',
        'description':
            'Create your own content and share it with the community. Build your brand and reach a wider audience.',
        'screenRoute': '/create',
      },
    ];
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        ),
        centerTitle: true,
        title: const Text(
          'How to Use Business Bosses App',
          textAlign: TextAlign.center,
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        itemCount: tilesData.length,
        itemBuilder: (BuildContext context, int index) {
          final Map<String, dynamic> tileData = tilesData[index];
          return TileWidget(
            icon: tileData['icon'],
            title: tileData['title'],
            description: tileData['description'],
            screenRoute: tileData['screenRoute'],
            notificationCount: tileData['notificationCount'] ?? 0,
          );
        },
      ),
    );
  }
}

class TileWidget extends StatelessWidget {
  final Widget icon;
  final String title;
  final String description;
  final String screenRoute;
  final int notificationCount;

  const TileWidget({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
    required this.screenRoute,
    this.notificationCount = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          isScrollControlled: true,
          builder: (BuildContext context) {
            return FractionallySizedBox(
              heightFactor: 0.8,
              child: BottomSheetContent(
                title: title,
                description: description,
                screenRoute: screenRoute,
              ),
            );
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radiusValue),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Stack(
                alignment: Alignment.topRight,
                children: <Widget>[
                  icon,
                  if (notificationCount > 0)
                    CircleAvatar(
                      radius: 8.0,
                      backgroundColor: Colors.red,
                      child: Text(
                        notificationCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10.0,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8.0),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomSheetContent extends StatelessWidget {
  final String title;
  final String description;
  final String screenRoute;

  const BottomSheetContent({
    Key? key,
    required this.title,
    required this.description,
    required this.screenRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(description),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              // Navigate to the specified screen
              Navigator.pushNamed(context, screenRoute);
            },
            child: const Text('Go to Screen'),
          ),
        ],
      ),
    );
  }
}
