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
    this.hasevent,
    this.onMenuClick,
  });

  final VoidCallback? onMenuClick;
  final bool hasBadge;
  final String coinsCount;
  final bool hasUnreadNotification;
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
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
            child: SafeArea(
              bottom: false,
              child: Row(
                spacing: 15,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  // Search button - expands to fill available space
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                            Get.to(() => AllCommunitiesScreen());
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            decoration: BoxDecoration(
                                color: backgroundcolorinterface,
                                borderRadius: BorderRadius.circular(50)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                SvgPicture.asset('assets/svgs/bossupu.svg',
                                    colorFilter: const ColorFilter.mode(
                                        textColor, BlendMode.srcIn),
                                    height: 19),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    'Boss Up & Grow',
                                    style: const TextStyle(
                                      color: textColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.completesearchingscreen);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(80),
                        color: Colors.transparent,
                      ),
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.transparent,
                        child: const Icon(LucideIcons.search,
                            size: 25, color: textColor),
                      ),
                    ),
                  ),

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

                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            GestureDetector(
                                onTap: onMenuClick,
                                child: const CustomMenuButton()),
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
                ],
              ),
            ),
          ),
        ),
        // Container(
        //   height: 1,
        //   color: backgroundColor,
        // ),
      ],
    );
  }
}
