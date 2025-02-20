import 'package:business_bosses_v2/features/donations/controller/donations_controller.dart';
import 'package:business_bosses_v2/features/donations/presentation/donations.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CrowdfundSection extends StatefulWidget {
  final Color? backgroundColor;
  final Function? onTap;
  const CrowdfundSection({super.key, this.backgroundColor, this.onTap});

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
          Get.to(() => const DonationsPage(
                ishome: false,
              ));
        },
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: GestureDetector(
                onTap: () {
                  if (widget.onTap != null) {
                    widget.onTap!();
                  }
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Crowdfund',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                    Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: <Widget>[
                          // const Text(
                          //   'View all',
                          //   style: TextStyle(fontSize: 11),
                          // ),
                          // const SizedBox(width: 5.0),
                          Icon(Icons.chevron_right, color: textColor, size: 20),
                        ]),
                  ],
                ),
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
      );
    });
  }
}
