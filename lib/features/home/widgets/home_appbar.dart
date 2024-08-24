import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/features/home/widgets/searchsection.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/products.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    Key? key,
    this.hasBadge = false,
    required this.coinsCount,
    this.hasUnreadNotification = false,
    this.isTabVisible = false,
    required this.controller,
  }) : super(key: key);

  final bool hasBadge;
  final bool isTabVisible;
  final String coinsCount;
  final bool hasUnreadNotification;
  final TabController controller;

  String getGreeting() {
    final int hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find<ProfileController>();
    final String profileName = profileController.myProfile.name!;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Container(
            color: Colors.white,
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                controller.index == 0
                    ? Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Get.toNamed(Routes.myProfile);
                            },
                            child: SizedBox(
                              height: 40.0,
                              width: 40.0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: NetworkImageWithPlaceHolder(
                                  imageUrl:
                                      profileController.myProfile.photoUrl ??
                                          '',
                                  radius: 10,
                                  placeHolder: Icons.person,
                                  iconSize: 22.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profileName.length > 12
                                    ? '${profileName.substring(0, 12)}...'
                                    : profileName,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '👋' + getGreeting(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Expanded(
                        child: Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: const SearchSection(),
                      )),
                Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => Get.toNamed(Routes.promotionscreen),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 5),
                        decoration: BoxDecoration(
                          color: backgroundcolorinterface,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: <Widget>[
                            SvgPicture.asset('assets/svgs/coin.svg',
                                height: 22),
                            const SizedBox(width: 5),
                            Text(
                              formatCount(int.parse(coinsCount)),
                              style: const TextStyle(
                                color: Color.fromRGBO(133, 133, 133, 1),
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 2),
                    Stack(
                      children: <Widget>[
                        IconButton(
                          icon: SvgPicture.asset(
                              'assets/svgs/messagefilled.svg',
                              height: 18,
                              color: primaryColorLT),
                          onPressed: () => Get.toNamed(Routes.chat),
                        ),
                        if (hasBadge)
                          Positioned(
                            top: 5,
                            right: 5,
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
                    Stack(
                      children: <Widget>[
                        IconButton(
                          icon: SvgPicture.asset(
                              'assets/svgs/notificationfilled.svg',
                              height: 20,
                              color: primaryColorLT),
                          onPressed: () => Get.toNamed(Routes.notifications),
                        ),
                        if (hasUnreadNotification)
                          Positioned(
                            top: 5,
                            right: 8,
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
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 1,
          color: backgroundColor,
        ),
        TabBar(
          controller: controller,
          indicatorColor: Colors.transparent,
          tabs: <Widget>[
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (controller.index == 0)
                    Container(
                      margin: const EdgeInsets.only(right: 8.0),
                      width: 8.0,
                      height: 8.0,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  Text(
                    'Discover',
                    style: TextStyle(
                      color:
                          controller.index == 0 ? primaryColorLT : Colors.grey,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (controller.index == 1)
                    Container(
                      margin: const EdgeInsets.only(right: 8.0),
                      width: 8.0,
                      height: 8.0,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  Text(
                    'For you',
                    style: TextStyle(
                      color:
                          controller.index == 1 ? primaryColorLT : Colors.grey,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (controller.index == 2)
                    Container(
                      margin: const EdgeInsets.only(right: 8.0),
                      width: 8.0,
                      height: 8.0,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  Text(
                    'Following',
                    style: TextStyle(
                      color:
                          controller.index == 2 ? primaryColorLT : Colors.grey,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Container(
          height: 1,
          color: backgroundColor,
        ),
      ],
    );
  }
}
