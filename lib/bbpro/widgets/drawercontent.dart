import 'package:business_bosses_v2/features/home/utils/post_options_sheet.dart';
import 'package:business_bosses_v2/features/impact/presentation/impact_screen.dart';
import 'package:business_bosses_v2/bbpro/widgets/button.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/features/forum/controller/challenge_controller.dart';
import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:business_bosses_v2/features/home/all_communities_screen.dart';
import 'package:business_bosses_v2/features/home/marketplace_screen.dart';
import 'package:business_bosses_v2/features/notifications/notificationsscreen.dart';
import 'package:business_bosses_v2/features/partners/presentation/boss_up_partner.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/features/profile/presentation/my_profile_screen.dart';
import 'package:business_bosses_v2/features/settings/settingsscreen.dart';
import 'package:business_bosses_v2/features/referrals/referral_screen.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class DrawerContent extends StatefulWidget {
  final UserModel? currentuser;
  final VoidCallback? oncloseclick;
  final VoidCallback? oncrowfundclick;
  final bool hasUnreadNotification;
  const DrawerContent(
      {super.key,
      this.currentuser,
      this.oncloseclick,
      this.oncrowfundclick,
      this.hasUnreadNotification = false});

  @override
  State<DrawerContent> createState() => _DrawerContentState();
}

class _DrawerContentState extends State<DrawerContent> {
  ProfileController profileController = Get.find();
  ChallengeController controller = Get.put(ChallengeController());
  late Industry industry;

  @override
  void initState() {
    super.initState();
    industry = controller.categories.isNotEmpty
        ? controller.categories[0]
        : Industry.fromMap(<String, dynamic>{
            'industryId': '-MsUOGcOT9oRXGakCcJv',
            'industry': 'Boss Up Challenge ',
            'categoryId': '-Mos1VMlx3oxZFRaw_BH',
            'timestamp': 1677956626516,
            'active': true,
            'photo': 'https://i.ibb.co/qN7LknF/bossup.jpg',
            'description':
                '👆Post Business \n👍Get highest likes\n🌟Win 7days FREE Promotion',
            'startAt': '1970-01-01T04:00:00.000Z',
            'endedAt': null,
            'criteria': null,
            'award': null,
            'createTitle': null,
            'createDescription': null,
            'createInfo': null,
            'joinedUsersCount': 41789
          });
  }

  @override
  Widget build(BuildContext context) {
    // void showPromoteSheet() {
    //   showModalBottomSheet(
    //     context: context,
    //     isScrollControlled: true,
    //     backgroundColor: Colors.transparent,
    //     builder: (BuildContext context) => AIPromoteSheet(),
    //   );
    // }

    // ignore: unused_local_variable
    final Industry category = controller.categories.isNotEmpty
        ? controller.categories[0]
        : Industry.fromMap(<String, dynamic>{
            'industryId': '-MsUOGcOT9oRXGakCcJv',
            'industry': 'Boss Up Challenge ',
            'categoryId': '-Mos1VMlx3oxZFRaw_BH',
            'timestamp': 1677956626516,
            'active': true,
            'photo': 'https://i.ibb.co/qN7LknF/bossup.jpg',
            'description':
                '👆Post Business \n👍Get highest likes\n🌟Win 7days FREE Promotion',
            'startAt': '1970-01-01T04:00:00.000Z',
            'endedAt': null,
            'criteria': null,
            'award': null,
            'createTitle': null,
            'createDescription': null,
            'createInfo': null,
            'joinedUsersCount': 41789
          });
    List<Map<String, dynamic>> tilesData = <Map<String, dynamic>>[
      <String, dynamic>{
        'icon': Icon(LucideIcons.bell,
            size: 25,
            color: widget.hasUnreadNotification
                ? primaryColorLT
                : textColor), // Changed to Icon widget

        'title': 'Notifications',
        'description':
            'View your notifications, including updates, messages, and alerts.',
        'onTileClicked': () {
          widget.oncloseclick?.call();
          Get.to(() => NotificationsScreen());
        },
      },
      <String, dynamic>{
        'icon': SvgPicture.asset(
          'assets/svgs/bossupu.svg',
          height: 24,
          colorFilter: const ColorFilter.mode(
            textColor,
            BlendMode.srcIn,
          ),
        ),
        'title': 'Boss Up & Grow',
        'description':
            'Connect with other users and build your network. Find connections who share your interests.',
        'onTileClicked': () {
          widget.oncloseclick?.call();
          Get.to(() => const AllCommunitiesScreen());
        },
      },
      <String, dynamic>{
        'icon': SvgPicture.asset(
          'assets/svgs/marketplaceoutlined.svg',
          height: 25,
          colorFilter: const ColorFilter.mode(
            textColor,
            BlendMode.srcIn,
          ),
        ),
        'title': 'My Biz',
        'description':
            'Everything you need to manage and grow your business 10X faster, all in one place.',
        'onTileClicked': () {
          widget.oncloseclick?.call();
          Get.to(() => const MyProfileScreen(
                currentIndex: 1,
              ));
        },
      },
      <String, dynamic>{
        'icon': SvgPicture.asset(
          'assets/svgs/coin.svg',
          height: 30,
        ),
        'title': 'Monetization',
        'description':
            'Monetize your business. Explore various revenue streams and opportunities on business bosses.',
        'onTileClicked': () {
          widget.oncloseclick?.call();
          Get.toNamed(Routes.promotionscreen);
        },
      },
      <String, dynamic>{
        'icon': const Icon(LucideIcons.trophy, size: 25, color: textColor),
        'title': 'Performance',
        'description':
            'See the top ranking business owners and their impact in the community.',
        'onTileClicked': () {
          widget.oncloseclick?.call();
          Get.to(() => ReachScreen(
                user: Get.find<ProfileController>().myProfile,
              ));
        },
      },
      <String, dynamic>{
        'icon': SvgPicture.asset(
          'assets/svgs/shoppingcart.svg',
          height: 25,
          colorFilter: const ColorFilter.mode(
            textColor,
            BlendMode.srcIn,
          ),
        ),
        'title': 'Marketplace',
        'description':
            'Browse products and services from businesses across the community.',
        'onTileClicked': () {
          widget.oncloseclick?.call();
          Get.to(() => const MarketplaceScreen(
                initialIndex: MarketplaceScreen.marketplaceTab,
              ));
        },
      },
      <String, dynamic>{
        'icon': SvgPicture.asset(
          'assets/svgs/partner.svg',
          height: 25,
          colorFilter: const ColorFilter.mode(
            textColor,
            BlendMode.srcIn,
          ),
        ),
        'title': 'Partnership',
        'description':
            'Support and invest in projects you believe in. Discover opportunities to back innovative ideas and businesses.',
        'onTileClicked': () {
          widget.oncloseclick?.call();
          Get.to(() => const BossUpPartner());
        }
      },
      <String, dynamic>{
        'icon': const Icon(LucideIcons.gift, size: 25, color: textColor),
        'title': 'Referrals',
        'description': 'See your referral earnings and manage shop referral rewards.',
        'onTileClicked': () {
          widget.oncloseclick?.call();
          Get.to(() => const ReferralScreen());
        },
      },
      <String, dynamic>{
        'icon': SvgPicture.asset(
          'assets/svgs/settings.svg',
          height: 25,
          colorFilter: const ColorFilter.mode(
            textColor,
            BlendMode.srcIn,
          ),
        ),
        'title': 'Settings',
        'description':
            'Customize your app preferences and manage your account settings. ',
        'onTileClicked': () {
          widget.oncloseclick?.call();
          Get.to(() => const SettingsScreen());
        },
      },
    ];

    return SafeArea(
      child: ListTileTheme(
        textColor: Colors.white,
        iconColor: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const MarketplaceScreen());
                    },
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 35.0,
                          height: 35.0,
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            'assets/images/app_logo_2.png',
                          ),
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        const Text(
                          'Business Bosses',
                          style: TextStyle(
                              fontSize: 16,
                              color: primaryColorLT,
                              fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: widget.oncloseclick,
                        child: const CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Icon(
                            Icons.close,
                            color: textColor,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 20),
                    ...List<Widget>.generate(
                        tilesData.length,
                        (int index) => Padding(
                              padding:
                                  const EdgeInsets.only(left: 15.0, right: 15),
                              child: ListTile(
                                minVerticalPadding: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                onTap: tilesData[index]['onTileClicked'] as void
                                    Function(),
                                leading: tilesData[index]['icon'] as Widget,
                                title: Text(
                                  tilesData[index]['title'] as String,
                                  style: const TextStyle(
                                      color: textColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15),
                                ),
                              ),
                            )),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0, bottom: 20.0),
                      child: SizedBox(
                          width: double.infinity,
                          child: ProCustomButton(
                              color: primaryColorLT,
                              icon: const Icon(Icons.add, color: Colors.white),
                              text: 'Create',
                              onPressed: () {
                                widget.oncloseclick?.call();
                                PostOptionsBottomSheet.show(context);
                              })),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: GestureDetector(
                onTap: () => Get.to(() => const MyProfileScreen()),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      height: 40.0,
                      width: 40.0,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(1000),
                          child: NetworkImageWithPlaceHolder(
                            imageUrl: widget.currentuser?.photoUrl ?? '',
                            radius: radius,
                            placeHolder: Icons.person,
                            iconSize: 22.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                            '@${widget.currentuser?.username.toLowerCase() ?? ''}',
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w700)),
                        Row(
                          children: <Widget>[
                            Text(
                              widget.currentuser != null
                                  ? widget.currentuser!.connectionCount
                                      .toString()
                                  : '0',
                              style: const TextStyle(
                                color: primaryColorLT,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              ' followers • ',
                              style: TextStyle(
                                color: textColor,
                              ),
                            ),
                            Text(
                              widget.currentuser != null &&
                                      widget.currentuser?.connecteds != null
                                  ? widget.currentuser!.connecteds!.length
                                      .toString()
                                  : '0',
                              style: const TextStyle(
                                color: primaryColorLT,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              ' following',
                              style: TextStyle(
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
