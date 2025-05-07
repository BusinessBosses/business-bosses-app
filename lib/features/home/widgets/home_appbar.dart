import 'package:business_bosses_v2/bbpro/widgets/menubutton.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/products.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    super.key,
    this.hasBadge = false,
    required this.coinsCount,
    this.hasUnreadNotification = false,
    this.isTabVisible = false,
    required this.controller,
    this.hasevent,
    this.onMenuClick,
  });

  final VoidCallback? onMenuClick;
  final bool hasBadge;
  final bool isTabVisible;
  final String coinsCount;
  final bool hasUnreadNotification;
  final TabController controller;
  final bool? hasevent;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.only(
                top: 10.0, bottom: 10.0, left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // Search button
                GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.completesearchingscreen);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(80),
                      color: backgroundColor,
                    ),
                    child: CircleAvatar(
                      backgroundColor: backgroundColor,
                      child: SvgPicture.asset(
                        'assets/svgs/homesearch.svg',
                        colorFilter: const ColorFilter.mode(
                          textColor,
                          BlendMode.srcIn,
                        ),
                        height: 20,
                      ),
                    ),
                  ),
                ),

                // Boss Up button
                GestureDetector(
                  onTap: () => Get.toNamed(Routes.allCommunitiesScreen),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: backgroundcolorinterface,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: SvgPicture.asset('assets/svgs/bossupu.svg',
                              height: 16),
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          'Boss Up',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Events button
                GestureDetector(
                  onTap: () => Get.toNamed(Routes.liveEvents),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: backgroundcolorinterface,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: SvgPicture.asset('assets/svgs/eventu.svg',
                              height: 16),
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          'Events',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Coins button
                GestureDetector(
                  onTap: () => Get.toNamed(Routes.promotionscreen),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      color: backgroundcolorinterface,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: <Widget>[
                        SvgPicture.asset('assets/svgs/coin.svg', height: 22),
                        const SizedBox(width: 5),
                        Text(
                          formatCount(int.parse(coinsCount)),
                          style: const TextStyle(
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Menu button
                Stack(
                  children: <Widget>[
                    GestureDetector(
                        onTap: onMenuClick, child: const CustomMenuButton()),
                    if (hasUnreadNotification)
                      Positioned(
                        right: 0,
                        top: 2,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                )
              ],
            ),
          ),
        ),
        Container(
          height: 1,
          color: backgroundColor,
        ),
      ],
    );
  }
}
