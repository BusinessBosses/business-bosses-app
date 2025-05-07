// ignore_for_file: always_specify_types

import 'package:business_bosses_v2/bbpro/presentation/my_orders_screen.dart';
import 'package:business_bosses_v2/bbpro/widgets/button.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/features/chat/chat_screen.dart';
import 'package:business_bosses_v2/features/forum/controller/challenge_controller.dart';
import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:business_bosses_v2/features/forum/presentation/bossup_screen.dart';
import 'package:business_bosses_v2/features/home/all_communities_screen.dart';
import 'package:business_bosses_v2/features/home/home_screen.dart';
import 'package:business_bosses_v2/features/home/marketplace_screen.dart';
import 'package:business_bosses_v2/features/home/sellProduct.dart';
import 'package:business_bosses_v2/features/moreinfoscreens/bossuppartner.dart';
import 'package:business_bosses_v2/features/posts/presentation/create_poll_screen.dart';
import 'package:business_bosses_v2/features/premium/premiumscreen.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/features/profile/presentation/my_profile_screen.dart';
import 'package:business_bosses_v2/features/settings/settingsscreen.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class DrawerContent extends StatelessWidget {
  final UserModel? currentuser;
  final VoidCallback? oncloseclick;
  final VoidCallback? oncrowfundclick;
  final bool hasUnreadNotification;
  const DrawerContent(
      {super.key,
      this.currentuser,
      this.oncloseclick,
      this.oncrowfundclick,
      required this.hasUnreadNotification});

  @override
  Widget build(BuildContext context) {
    ProfileController profileController = Get.find();
    ChallengeController controller = Get.put(ChallengeController());
    final Industry category = controller.categories[0];
    List<Map<String, dynamic>> tilesData = <Map<String, dynamic>>[
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
          oncloseclick?.call();
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
        'title': 'My-Biz',
        'description':
            'Everything you need to manage and grow your business 10X faster, all in one place.',
        'onTileClicked': () {
          oncloseclick?.call();
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
          oncloseclick?.call();
          Get.toNamed(Routes.promotionscreen);
        },
      },
      {
        'icon': SvgPicture.asset(
          'assets/svgs/bossupu.svg',
          height: 25,
          colorFilter: const ColorFilter.mode(
            textColor,
            BlendMode.srcIn,
          ),
        ),
        'title': 'Boss Up',
        'description':
            'Connect with other users and build your network. Find connections who share your interests.',
        'onTileClicked': () {
          oncloseclick?.call();
          Get.to(() => const AllCommunitiesScreen());
        },
      },
      !profileController.myProfile.isSubscribed
          ? {
              'icon': SvgPicture.asset(
                'assets/svgs/growfilled.svg',
                height: 22,
                colorFilter: const ColorFilter.mode(
                  textColor,
                  BlendMode.srcIn,
                ),
              ),
              'title': 'Grow',
              'description':
                  'Access tools and resources to grow your business and reach new heights.',
              'onTileClicked': () {
                Get.bottomSheet(
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                  SizedBox(
                    height: Get.height * 0.9,
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 0.0, top: 0, bottom: 10),
                              child: PremiumScreen()),
                        ],
                      ),
                    ),
                  ),
                  backgroundColor: Colors.white,
                );
              }
            }
          : {
              'icon': SvgPicture.asset(
                'assets/svgs/messages.svg',
                height: 25,
                colorFilter: const ColorFilter.mode(
                  textColor,
                  BlendMode.srcIn,
                ),
              ),
              'title': 'Messages',
              'description':
                  'Communicate with other users through private messages. Stay connected with your connections and customers',
              'onTileClicked': () {
                oncloseclick?.call();
                Get.to(() => const ChatScreen());
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
          oncloseclick?.call();
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
          oncloseclick?.call();
          Get.to(() => const MyOrdersScreen());
        },
      },
      // {
      //   'icon': SvgPicture.asset(
      //     'assets/svgs/supporter.svg',
      //     height: 25,
      //     colorFilter: const ColorFilter.mode(
      //       textColor,
      //       BlendMode.srcIn,
      //     ),
      //   ),
      //   'title': 'Crowdfund',
      //   'description':
      //       'Support and invest in projects you believe in. Discover opportunities to back innovative ideas and businesses.',
      //   'onTileClicked': () {
      //     oncloseclick?.call();
      //     Get.to(() => const AllCommunitiesScreen(
      //           initialBossupTabIndex: 3,
      //         ));
      //     oncrowfundclick?.call();
      //   },
      // },
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
          oncloseclick?.call();
          Get.to(() => const Bossuppartner());
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
          oncloseclick?.call();
          Get.to(() => const SettingsScreen());
        },
      },
    ];

    return SafeArea(
      child: Container(
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
                        Stack(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () => Get.toNamed(Routes.notifications),
                              child: CircleAvatar(
                                backgroundColor: backgroundColor,
                                child: SvgPicture.asset(
                                  'assets/svgs/notificationicon.svg',
                                  height: 20,
                                  colorFilter: const ColorFilter.mode(
                                    Colors.black,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                            if (hasUnreadNotification)
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white, // Border color
                                      width: 2.0, // Border width
                                    ),
                                  ),
                                  child: const CircleAvatar(
                                    backgroundColor: primaryColorLT,
                                    radius: 5,
                                  ),
                                ),
                              )
                          ],
                        ),
                        GestureDetector(
                          onTap: oncloseclick,
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
                    padding: const EdgeInsets.only(top: 30.0),
                    child: SizedBox(
                        width: double.infinity,
                        child: ProCustomButton(
                            color: primaryColorLT,
                            icon: const Icon(Icons.add),
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
                                  return SizedBox(
                                    height:
                                        380, // Increased height to accommodate the new item
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Expanded(
                                            child: ListView.separated(
                                              itemCount:
                                                  5, // Changed to 5 items
                                              separatorBuilder:
                                                  (BuildContext context,
                                                          int index) =>
                                                      const Divider(),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return ListTile(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    if (index == 0) {
                                                      Get.to(() =>
                                                          BossUpSection(
                                                            industry: category,
                                                            bossUp: controller
                                                                .categories[0],
                                                          ));
                                                    } else if (index == 1) {
                                                      Get.toNamed(
                                                          Routes.createPost);
                                                    } else if (index == 2) {
                                                      sellProduct(context);
                                                    } else if (index == 3) {
                                                      Get.toNamed(
                                                          Routes.createevent);
                                                    } else if (index == 4) {
                                                      Get.to(() =>
                                                          const CreatePollScreen());
                                                    }
                                                  },
                                                  minVerticalPadding: 0,
                                                  contentPadding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  leading: index == 4
                                                      ? const Icon(
                                                          Icons.poll,
                                                          color: textColor,
                                                        )
                                                      : index == 0
                                                          ? const Icon(
                                                              Icons.star,
                                                              color: textColor,
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
                                                              color: textColor
                                                                  .withOpacity(
                                                                      1),
                                                            ),
                                                  title: Text(
                                                    index == 0
                                                        ? 'Enter free business promotion'
                                                        : index == 1
                                                            ? 'Post content, discussion, etc'
                                                            : index == 2
                                                                ? 'Sell your product & service'
                                                                : index == 3
                                                                    ? 'Create an event'
                                                                    : 'Create polls & surveys',
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w700,
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
                              imageUrl: currentuser?.photoUrl ?? '',
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
                          Text('@${currentuser?.username.toLowerCase() ?? ''}',
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w700)),
                          Row(
                            children: [
                              Text(
                                currentuser != null
                                    ? currentuser!.connectionCount.toString()
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
                                currentuser != null &&
                                        currentuser?.connecteds != null
                                    ? currentuser!.connecteds!.length.toString()
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
      ),
    );
  }
}
