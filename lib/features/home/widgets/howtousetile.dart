import 'package:business_bosses_v2/analytics/presentation/howtouseapp.dart';
import 'package:business_bosses_v2/features/matching_feature/presentation/expanded_matches_screen.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class HowtouseTile extends StatelessWidget {
  final bool? isSearch;
  const HowtouseTile({super.key, this.isSearch});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => const ExpandedMatchesScreen());
      },
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: <Widget>[
              if (isSearch == true)
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'How To Use Business Bosses App',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                  ],
                ),
              const SizedBox(height: 5),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Find Your Business Match',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Spacer(),
                    Image.asset(
                      'assets/images/howitworkspic.png',
                      height: 20,
                    ),
                    if (isSearch == true) const SizedBox(height: 10),
                    // Subscription message
                    if (isSearch == true)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          'Get to know the Business Bosses app and all of its features.',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    if (isSearch == true)
                      const SizedBox(
                        height: 10,
                      ),
                    const Icon(
                      LucideIcons.chevronRight,
                      color: Colors.green,
                      size: 30,
                    ),
                    if (isSearch == true)
                      GestureDetector(
                        onTap: () {
                          Get.to(() => const HowToUseAppScreen());
                        },
                        child: Container(
                          constraints: const BoxConstraints(minHeight: 40),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 8),
                          child: const Row(
                            mainAxisSize: MainAxisSize
                                .min, // Row will only take up the space it needs
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Explore',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.chevron_right_rounded,
                                color: Colors.green,
                                size: 20,
                              )
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
