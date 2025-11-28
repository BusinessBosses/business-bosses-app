import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/features/premium/premiumscreen.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';

import 'package:lucide_icons/lucide_icons.dart';

class BlurredMatchCard extends StatelessWidget {
  final UserModel match;

  const BlurredMatchCard({
    super.key,
    required this.match,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.bottomSheet(
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            height: Get.height * 0.9,
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  PremiumScreen(),
                ],
              ),
            ),
          ),
          backgroundColor: Colors.white,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Stack(
          children: <Widget>[
            // Base card with actual content
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 15, top: 8, bottom: 8, right: 8),
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              spacing: 10,
                              children: <Widget>[
                                NetworkImageWithPlaceHolder(
                                  imageUrl: match.photoUrl,
                                  height: 40,
                                  width: 40,
                                  radius: 50,
                                  cacheHeight: 256,
                                  cacheWidth: 256,
                                  placeHolder: Icons.person,
                                  iconSize: 24,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Flexible(
                                            child: Text(
                                              match.name ?? match.username,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: textDark,
                                              ),
                                            ),
                                          ),
                                          if (match.isSubscribed) ...<Widget>[
                                            const SizedBox(width: 4),
                                            const Icon(
                                              Icons.verified,
                                              size: 15,
                                              color: primaryColorLT,
                                            ),
                                          ],
                                        ],
                                      ),
                                      // Text(
                                      //   match.type,
                                      //   maxLines: 1,
                                      //   overflow: TextOverflow.ellipsis,
                                      //   style: const TextStyle(
                                      //     fontSize: 14,
                                      //     fontWeight: FontWeight.w600,
                                      //     color: primaryBlue,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: <Widget>[
                                const Icon(Icons.star,
                                    size: 16, color: premiumGold),
                                const SizedBox(width: 4),
                                Text(
                                  match.averageRating.toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: textDark,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Icon(LucideIcons.mapPin,
                                    size: 14, color: textMedium),
                                const SizedBox(width: 4),
                                Text(
                                  match.location ?? '',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: textMedium,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Column(
                                //   crossAxisAlignment: CrossAxisAlignment.end,
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceBetween,
                                //   children: <Widget>[
                                //     Text(
                                //       '${match.quality}% Match',
                                //       style: const TextStyle(
                                //         color: Colors.green,
                                //         fontWeight: FontWeight.bold,
                                //         fontSize: 12,
                                //       ),
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),
                            Text(
                              match.bio ?? '',
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                                color: textMedium,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(LucideIcons.chevronRight,
                          color: textMedium, size: 18),
                    ],
                  ),
                ),
              ),
            ),
            // Blur overlay
            Positioned.fill(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              LucideIcons.crown,
                              size: 30,
                              color: premiumGold,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Premium Match',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: textDark,
                              ),
                            ),
                            Text(
                              'Upgrade to view details',
                              style: TextStyle(
                                fontSize: 14,
                                color: textMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
