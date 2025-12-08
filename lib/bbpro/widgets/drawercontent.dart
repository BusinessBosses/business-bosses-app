// ignore_for_file: always_specify_types

import 'package:business_bosses_v2/bbpro/presentation/my_orders_screen.dart';
import 'package:business_bosses_v2/bbpro/widgets/button.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/features/forum/controller/challenge_controller.dart';
import 'package:business_bosses_v2/features/forum/controller/create_bossup_controller.dart';
import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:business_bosses_v2/features/forum/presentation/create_bossup_screen.dart';
import 'package:business_bosses_v2/features/home/all_communities_screen.dart';
import 'package:business_bosses_v2/features/home/home_screen.dart';
import 'package:business_bosses_v2/features/home/marketplace_screen.dart';
import 'package:business_bosses_v2/features/home/sellProduct.dart';
import 'package:business_bosses_v2/features/notifications/notificationsscreen.dart';
import 'package:business_bosses_v2/features/partners/presentation/boss_up_partner.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/features/profile/presentation/my_profile_screen.dart';
import 'package:business_bosses_v2/features/settings/settingsscreen.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

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
        : Industry.fromMap({
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
        : Industry.fromMap({
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
      {
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
      {
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
      {
        'icon': SvgPicture.asset(
          'assets/svgs/cartu.svg',
          height: 25,
          colorFilter: const ColorFilter.mode(
            textColor,
            BlendMode.srcIn,
          ),
        ),
        'title': 'Marketplace',
        'description':
            'Browse and purchase items from other users. You can find a wide variety of items here.',
        'onTileClicked': () {
          widget.oncloseclick?.call();
          Get.to(() => const MarketplaceScreen());
        },
      },
      {
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
      {
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
      {
        'icon': SvgPicture.asset(
          'assets/svgs/calendar.svg',
          height: 25,
          colorFilter: const ColorFilter.mode(
            textColor,
            BlendMode.srcIn,
          ),
        ),
        'title': 'Events',
        'description':
            'Discover and attend events hosted by other users. Find events that match your interests and goals.',
        'onTileClicked': () {
          widget.oncloseclick?.call();
          Get.toNamed(Routes.liveEvents);
        },
      },
      {
        'icon': SvgPicture.asset(
          'assets/svgs/shoppingcart.svg',
          height: 25,
          colorFilter: const ColorFilter.mode(
            textColor,
            BlendMode.srcIn,
          ),
        ),
        'title': 'My Orders',
        'description':
            'Discover and attend events hosted by other users. Find events that match your interests and goals.',
        'onTileClicked': () {
          widget.oncloseclick?.call();
          Get.to(() => const MyOrdersScreen());
        },
      },
      {
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
      {
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

    void enterChallenge() {
      int now = DateTime.now().millisecondsSinceEpoch;
      int previousStamp =
          profileController.myProfile.bossOfTheWeekTimeStamp ?? 0;

      if ((previousStamp + 1209600000) > now &&
          industry.industryId == '-MsUOGcOT9oRXGakCcJv') {
        const SnackBar snackBar = SnackBar(
          duration: Duration(seconds: 4),
          content: Text(
            'You may have posted in Boss Up Challenge'
            ' in the past 12 weeks. You can only post once in 12 weeks.',
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        if (industry.industryId == '-MsUOGcOT9oRXGakCcJv') {
          Get.to(
            () => CreateBossUpScreen(industryModel: industry),
            arguments: <String, Object?>{
              'isBossUp': true,
              'industryId': industry.industryId,
            },
            binding: BindingsBuilder<CreateBossUpController>.put(
                () => CreateBossUpController()),
          );
        } else {
          if (profileController.myProfile.postChallenges!
              .contains(industry.industryId)) {
            const SnackBar snackBar = SnackBar(
              duration: Duration(seconds: 4),
              content: Text('You can only post once in a challenge'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            return;
          }
          Get.to(
            () => CreateBossUpScreen(industryModel: industry),
            arguments: <String, Object?>{
              'isBossUp': true,
              'industryId': industry.industryId,
            },
            binding: BindingsBuilder<CreateBossUpController>.put(
              () => CreateBossUpController(),
            ),
          );
        }
      }
    }

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
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const HomeScreen());
                    },
                    child: Row(
                      children: [
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
                    children: [
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
            Column(
              children: [
                const SizedBox(height: 20),
                ...List.generate(
                    tilesData.length,
                    (index) => Padding(
                          padding: const EdgeInsets.only(left: 15.0, right: 15),
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
                  padding: const EdgeInsets.only(top: 30.0),
                  child: SizedBox(
                      width: double.infinity,
                      child: ProCustomButton(
                          color: primaryColorLT,
                          icon: const Icon(Icons.add, color: Colors.white),
                          text: 'Create',
                          onPressed: () {
                            showModalBottomSheet(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      ListView.separated(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: 4,
                                        separatorBuilder:
                                            (BuildContext context, int index) =>
                                                const Divider(),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return ListTile(
                                            onTap: () {
                                              Navigator.pop(context);
                                              if (index == 0) {
                                                enterChallenge();
                                              } else if (index == 1) {
                                                sellProduct(context);
                                              } else if (index == 2) {
                                                Get.toNamed(Routes.createPost);
                                              } else if (index == 3) {
                                                final url = Uri.parse(
                                                    'https://businessbosses.news/instant-pr/');
                                                launchUrl(url,
                                                    mode: LaunchMode
                                                        .platformDefault);
                                              }
                                            },
                                            minVerticalPadding: 0,
                                            contentPadding:
                                                const EdgeInsets.only(left: 10),
                                            leading: index == 0
                                                ? Icon(
                                                    LucideIcons.trophy,
                                                    color: textColor.withValues(
                                                        alpha: 1),
                                                    size: 26,
                                                  )
                                                : index == 1
                                                    ? SvgPicture.asset(
                                                        'assets/svgs/sellicon.svg',
                                                        height: 25,
                                                        color: textColor
                                                            .withValues(
                                                                alpha: 1),
                                                      )
                                                    : index == 2
                                                        ? SvgPicture.asset(
                                                            'assets/svgs/text.svg',
                                                            height: 25,
                                                            color: textColor
                                                                .withValues(
                                                                    alpha: 1),
                                                          )
                                                        : Icon(
                                                            LucideIcons.globe,
                                                            color: textColor
                                                                .withValues(
                                                                    alpha: 1),
                                                            size: 26,
                                                          ),
                                            title: Text(
                                              index == 0
                                                  ? 'Share business, get featured'
                                                  : index == 1
                                                      ? 'Sell your product & service'
                                                      : index == 2
                                                          ? 'Post content, requests, etc'
                                                          : 'Create press release',
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
                            );
                          })),
                )
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: GestureDetector(
                onTap: () => Get.to(() => const MyProfileScreen()),
                child: Row(
                  children: [
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
                      children: [
                        Text(
                            '@${widget.currentuser?.username.toLowerCase() ?? ''}',
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w700)),
                        Row(
                          children: [
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
