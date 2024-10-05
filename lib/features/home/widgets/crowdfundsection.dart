import 'package:business_bosses_v2/features/donations/controller/donations_controller.dart';
import 'package:business_bosses_v2/features/donations/presentation/donations.dart';
import 'package:business_bosses_v2/features/donations/widgets/donation_item.dart';
import 'package:business_bosses_v2/features/forum/presentation/bossup_challenge.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CrowdfundSection extends StatefulWidget {
  final Color? backgroundColor;
  const CrowdfundSection({super.key, this.backgroundColor});

  @override
  State<CrowdfundSection> createState() => _CrowdfundSectionState();
}

class _CrowdfundSectionState extends State<CrowdfundSection> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DonationsController>(
        builder: (DonationsController controller) {
      return GestureDetector(
        onTap: () {
          Get.to(const DonationsPage(
            ishome: false,
          ));
        },
        child: Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      'Crowdfund',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                    Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: <Widget>[
                          const Text(
                            'View all',
                            style: TextStyle(fontSize: 11),
                          ),
                          const SizedBox(width: 5.0),
                          SvgPicture.asset(
                            'assets/svgs/nexticon.svg',
                            // ignore: deprecated_member_use
                            color: textColor,
                            height: 8,
                          ),
                        ]),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                  height: 230,
                  child: DonationsPage(
                    ishome: true,
                  ))
            ],
          ),
        ),
      );
    });
  }
}
