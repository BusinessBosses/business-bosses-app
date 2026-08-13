import 'package:business_bosses_v2/features/marketplace/presentation/buyer_requests_form.dart';
import 'package:business_bosses_v2/utils/safe_url_launcher.dart';
import 'package:business_bosses_v2/features/chat/chat_screen.dart';
import 'package:business_bosses_v2/features/donations/presentation/donations.dart';
import 'package:business_bosses_v2/features/forum/controller/challenge_controller.dart';
import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:business_bosses_v2/features/home/all_communities_screen.dart';
import 'package:business_bosses_v2/features/home/marketplace_screen.dart';
import 'package:business_bosses_v2/features/home/sell_product.dart';
import 'package:business_bosses_v2/features/matching_feature/presentation/expanded_matches_screen.dart';
import 'package:business_bosses_v2/features/partners/presentation/boss_up_partner.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/features/profile/presentation/my_profile_screen.dart';
import 'package:business_bosses_v2/features/settings/settingsscreen.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

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
    final ChallengeController controller = Get.put(ChallengeController());
    // ignore: unused_local_variable
    final Industry category = controller.categories[0];
    List<Map<String, dynamic>> tilesData = <Map<String, dynamic>>[
      <String, dynamic>{
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
      <String, dynamic>{
        'icon': SvgPicture.asset(
          'assets/svgs/marketplaceoutlined.svg',
          height: 35,
          colorFilter: const ColorFilter.mode(
            Colors.grey,
            BlendMode.srcIn,
          ),
        ),
        'title': 'My Biz',
        'description':
            'Everything you need to manage and grow your business 10X faster, all in one place.',
        'onTileClicked': () => Get.to(() => const MyProfileScreen(
              currentIndex: 1,
            )),
      },
      <String, dynamic>{
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
      <String, dynamic>{
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
      <String, dynamic>{
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
      <String, dynamic>{
        'icon': Icon(
          LucideIcons.users,
          size: 35,
          color: Color(0xFF616161),
        ),
        'title': 'Matches',
        'description':
            'Find business matches and opportunities tailored to your profile. Get connected with potential partners, clients, and collaborators.',
        'onTileClicked': () => Get.to(() => ExpandedMatchesScreen()),
      },
      <String, dynamic>{
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
        'onTileClicked': () => <Future<dynamic>?>{
              Get.to(() => const DonationsPage(
                    ishome: false,
                  ))
            }
      },
      <String, dynamic>{
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
            'Partner with us to expand your reach, list exclusive deals, and attract new customers. Collaborate on business opportunities, gain visibility, and grow your network through strategic partnerships on Business Bosses.',
        'onTileClicked': () => Get.to(() => const BossUpPartner())
      },
      <String, dynamic>{
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
      <String, dynamic>{
        'icon': const Icon(
          Icons.add,
          size: 35,
          color: Color(0xFF616161),
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
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 4,
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(),
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            onTap: () {
                              Navigator.pop(context);
                              if (index == 0) {
                                // Share business, get featured
                                Get.to(() => AllCommunitiesScreen());
                              } else if (index == 1) {
                                // Sell your product & service
                                sellProduct(context);
                              } else if (index == 2) {
                                Get.to(() => AddBuyerRequests());
                              } else if (index == 3) {
                                // Post content, discussion, etc
                                Get.toNamed(Routes.createPost);
                              } else if (index == 4) {
                                // Submit news for instant PR
                                final Uri url = Uri.parse(
                                    'https://businessbosses.news/submit-your-news/');
                                openUrl(url,
                                    mode: LaunchMode.platformDefault);
                              }
                            },
                            minVerticalPadding: 0,
                            contentPadding: const EdgeInsets.only(left: 10),
                            leading: index == 0
                                ? Icon(
                                    LucideIcons.trophy,
                                    color: textColor.withValues(alpha: 1),
                                    size: 26,
                                  )
                                : index == 1
                                    ? SvgPicture.asset(
                                        'assets/svgs/sellicon.svg',
                                        height: 25,
                                        colorFilter: ColorFilter.mode(
                                            textColor.withValues(alpha: 1),
                                            BlendMode.srcIn),
                                      )
                                    : index == 2
                                        ? Icon(
                                            LucideIcons.shoppingBag,
                                            color:
                                                textColor.withValues(alpha: 1),
                                            size: 26,
                                          )
                                        : index == 3
                                            ? SvgPicture.asset(
                                                'assets/svgs/text.svg',
                                                height: 25,
                                                colorFilter: ColorFilter.mode(
                                                    textColor.withValues(
                                                        alpha: 1),
                                                    BlendMode.srcIn),
                                              )
                                            : Icon(
                                                LucideIcons.globe,
                                                color: textColor.withValues(
                                                    alpha: 1),
                                                size: 26,
                                              ),
                            title: Text(
                              index == 0
                                  ? 'Share business, get featured'
                                  : index == 1
                                      ? 'Sell your product & service'
                                      : index == 2
                                          ? 'Create buyer requests'
                                          :
                                          // index == 3
                                          //     ?
                                          'Post content, discussion, etc',
                              // : 'Submit news for instant PR',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
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
