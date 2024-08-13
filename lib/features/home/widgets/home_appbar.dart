import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/products.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    Key? key,
    this.hasBadge = false,
    required this.coinsCount,
    this.hasUnreadNotification = false,
    this.isTabVisible = false,
  }) : super(key: key);

  final bool hasBadge;
  final bool isTabVisible;
  final String coinsCount;
  final bool hasUnreadNotification;

  String getGreeting() {
    final hour = DateTime.now().hour;
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
    final profileController = Get.find<ProfileController>();
    final profileName = profileController.myProfile.name!;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: Container(
            color: Colors.white,
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: 40.0,
                      width: 40.0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: NetworkImageWithPlaceHolder(
                          imageUrl: profileController.myProfile.photoUrl ?? '',
                          radius: 10,
                          placeHolder: Icons.person,
                          iconSize: 22.0,
                          fit: BoxFit.cover,
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
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          getGreeting(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
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
                          children: [
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
                      children: [
                        IconButton(
                          icon: SvgPicture.asset(
                              'assets/svgs/messagefilled.svg',
                              height: 18,
                              color: primaryColorLT),
                          onPressed: () => Get.toNamed(Routes.chat),
                        ),
                        if (hasBadge)
                          const Positioned(
                            top: 12,
                            right: 10,
                            child: CircleAvatar(
                              backgroundColor: primaryotherColorLT,
                              radius: 5,
                            ),
                          ),
                      ],
                    ),
                    Stack(
                      children: [
                        IconButton(
                          icon: SvgPicture.asset(
                              'assets/svgs/notificationfilled.svg',
                              height: 20,
                              color: primaryColorLT),
                          onPressed: () => Get.toNamed(Routes.notifications),
                        ),
                        if (hasUnreadNotification)
                          const Positioned(
                            top: 12,
                            right: 14,
                            child: CircleAvatar(
                              backgroundColor: primaryotherColorLT,
                              radius: 5,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
