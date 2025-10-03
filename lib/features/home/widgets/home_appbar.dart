import 'package:business_bosses_v2/bbpro/widgets/menubutton.dart';
import 'package:business_bosses_v2/features/home/all_communities_screen.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/products.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

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
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                          height: 50,
                        ),
                      ),
                    ],
                  ),
                ),
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
                      radius: 16,
                      backgroundColor: backgroundColor,
                      child:
                          Icon(LucideIcons.search, size: 18, color: textColor),
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    Get.to(AllCommunitiesScreen());
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                        color: backgroundcolorinterface,
                        borderRadius: BorderRadius.circular(50)),
                    child: Row(
                      spacing: 8,
                      children: <Widget>[
                        SvgPicture.asset('assets/svgs/bossupu.svg', height: 15),
                        Text(
                          'Boss Up & Grow',
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
