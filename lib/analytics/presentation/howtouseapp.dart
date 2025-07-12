// ignore_for_file: always_specify_types

import 'package:business_bosses_v2/features/aipromote/ai_promote_sheet.dart';
import 'package:business_bosses_v2/features/chat/chat_screen.dart';
import 'package:business_bosses_v2/features/forum/controller/challenge_controller.dart';
import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:business_bosses_v2/features/home/all_communities_screen.dart';
import 'package:business_bosses_v2/features/home/marketplace_screen.dart';
import 'package:business_bosses_v2/features/home/sellProduct.dart';
import 'package:business_bosses_v2/features/moreinfoscreens/bossuppartner.dart';
import 'package:business_bosses_v2/features/posts/presentation/create_poll_screen.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/features/profile/presentation/my_profile_screen.dart';
import 'package:business_bosses_v2/features/settings/settingsscreen.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class HowToUseAppScreen extends StatefulWidget {
  const HowToUseAppScreen({super.key});

  @override
  State<HowToUseAppScreen> createState() => _HowToUseAppScreenState();
}

class _HowToUseAppScreenState extends State<HowToUseAppScreen> {
  final ProfileController profileController = Get.find();
  // Data for each tile

  @override
  Widget build(BuildContext context) {
    void showPromoteSheet() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) => AIPromoteSheet(),
      );
    }

    final ChallengeController controller = Get.put(ChallengeController());
    // ignore: unused_local_variable
    final Industry category = controller.categories[0];
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
        'onTileClicked': () => Get.to(() => const MarketplaceScreen()),
      },
      {
        'icon': SvgPicture.asset(
          'assets/svgs/marketplaceoutlined.svg',
          height: 35,
          colorFilter: const ColorFilter.mode(
            Colors.grey,
            BlendMode.srcIn,
          ),
        ),
        'title': 'My-Biz',
        'description':
            'Everything you need to manage and grow your business 10X faster, all in one place.',
        'onTileClicked': () => Get.to(() => const MyProfileScreen(
              currentIndex: 1,
            )),
      },
      {
        'icon': SvgPicture.asset(
          'assets/svgs/coin.svg',
          height: 35,
          // colorFilter: const ColorFilter.mode(
          //   Colors.grey,
          //   BlendMode.srcIn,
          // ),
        ),
        'title': 'Monetization',
        'description':
            'Monetize your business. Explore various revenue streams and opportunities on business bosses.',
        'onTileClicked': () {
          Get.toNamed(Routes.promotionscreen);
        },
      },
      {
        'icon': SvgPicture.asset(
          'assets/svgs/bossupu.svg',
          height: 40,
          colorFilter: const ColorFilter.mode(
            Colors.grey,
            BlendMode.srcIn,
          ),
        ),
        'title': 'Boss Up',
        'description':
            'Connect with other users and build your network. Find connections who share your interests.',
        'onTileClicked': () => Get.to(() => const AllCommunitiesScreen()),
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
            'Communicate with other users through private messages. Stay connected with your connections and customers',
        'onTileClicked': () => Get.to(() => const ChatScreen()),
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
            'Discover and attend events hosted by other users. Find events that match your interests and goals.',
        'onTileClicked': () => Get.toNamed(Routes.liveEvents),
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
            'Support and invest in projects you believe in. Discover opportunities to back innovative ideas and businesses.',
        'onTileClicked': () => Get.to(() => const AllCommunitiesScreen(
              initialBossupTabIndex: 3,
            )),
      },
      {
        'icon': SvgPicture.asset(
          'assets/svgs/partner.svg',
          height: 35,
          colorFilter: const ColorFilter.mode(
            Colors.grey,
            BlendMode.srcIn,
          ),
        ),
        'title': 'Partnership',
        'description':
            'Support and invest in projects you believe in. Discover opportunities to back innovative ideas and businesses.',
        'onTileClicked': () => Get.to(() => const Bossuppartner())
      },
      {
        'icon': SvgPicture.asset(
          'assets/svgs/settings.svg',
          height: 35,
          colorFilter: const ColorFilter.mode(
            Colors.grey,
            BlendMode.srcIn,
          ),
        ),
        'title': 'Settings',
        'description':
            'Customize your app preferences and manage your account settings. ',
        'onTileClicked': () => Get.to(() => const SettingsScreen()),
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
        'onTileClicked': () => showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(25.0),
                ),
              ),
              builder: (BuildContext context) {
                return SizedBox(
                  height: 380, // Increased height to accommodate the new item
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Expanded(
                          child: ListView.separated(
                            itemCount: 5, // Changed to 5 items
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const Divider(),
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                onTap: () {
                                  Navigator.pop(context);
                                  if (index == 0) {
                                    showPromoteSheet();
                                  } else if (index == 1) {
                                    Get.toNamed(Routes.createPost);
                                  } else if (index == 2) {
                                    sellProduct(context);
                                  } else if (index == 3) {
                                    Get.toNamed(Routes.createevent);
                                  } else if (index == 4) {
                                    Get.to(() => const CreatePollScreen());
                                  }
                                },
                                minVerticalPadding: 0,
                                contentPadding: const EdgeInsets.only(left: 10),
                                leading: index == 4
                                    ? const Icon(
                                        Icons.poll,
                                        color: textColor,
                                      )
                                    : index == 0
                                        ? Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              gradient: LinearGradient(
                                                colors: <Color>[
                                                  Color(0xFF6366F1),
                                                  Color(0xFF818CF8)
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                            ),
                                            child: Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                child: Center(
                                                  child: Icon(
                                                    Icons.star,
                                                    color: Colors.white,
                                                    size: 24,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : SvgPicture.asset(
                                            index == 1
                                                ? 'assets/svgs/text.svg'
                                                : index == 2
                                                    ? 'assets/svgs/sellicon.svg'
                                                    : 'assets/svgs/eventu.svg',
                                            height: index == 1
                                                ? 25
                                                : index == 2
                                                    ? 30
                                                    : 22,
                                            colorFilter: ColorFilter.mode(
                                              textColor.withValues(alpha: 1),
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                title: Text(
                                  index == 0
                                      ? 'Generate free promotion'
                                      : index == 1
                                          ? 'Post content, discussion, etc'
                                          : index == 2
                                              ? 'Sell your product & service'
                                              : index == 3
                                                  ? 'Create an event'
                                                  : 'Create polls & surveys',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            )
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
            onTileClicked: tileData['onTileClicked'],
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
  final void Function() onTileClicked;
  final int notificationCount;

  const TileWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTileClicked,
    this.notificationCount = 0,
  });

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
                onTileClick: () {
                  Navigator.pop(context);
                  onTileClicked();
                },
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
                          fontSize: 14.0,
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
                  fontSize: 15,
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
  final void Function() onTileClick;

  const BottomSheetContent({
    super.key,
    required this.title,
    required this.description,
    required this.onTileClick,
  });

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
          Text(description, style: const TextStyle(fontSize: 15)),
          const SizedBox(height: 16.0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColorLT,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onPressed: onTileClick,
            child: const Text(
              'Go to Screen',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
