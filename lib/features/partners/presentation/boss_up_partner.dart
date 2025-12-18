import 'dart:core';
import 'package:business_bosses_v2/features/partners/controllers/partners_controller.dart';
import 'package:business_bosses_v2/features/partners/models/partner_model.dart';
import 'package:business_bosses_v2/features/partners/presentation/become_a_partner_screen.dart';
import 'package:business_bosses_v2/features/partners/widgets/bossup_partner_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../utils/theme/theme.dart';

class BossUpPartner extends StatefulWidget {
  final bool? isMarketplace;
  const BossUpPartner({super.key, this.isMarketplace});

  @override
  State<BossUpPartner> createState() => _BossUpPartnerState();
}

class _BossUpPartnerState extends State<BossUpPartner> {
  final PartnerController partnerController = Get.put(PartnerController());

  @override
  void didChangeDependencies() {
    if (partnerController.partners.isEmpty) {
      partnerController.loadPartners();
    }
    super.didChangeDependencies();
  }

  bool isLastItem(int index) {
    return index == partnerController.partners.length - 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: widget.isMarketplace != null
          ? const PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: SizedBox.shrink(),
            )
          : AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: SvgPicture.asset(
                  'assets/svgs/backbutton.svg',
                ),
              ),
              centerTitle: true,
              title: const Text(
                'Partner Deals',
                textAlign: TextAlign.center,
              ),
            ),
      body: Obx(() {
        if (partnerController.loading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (partnerController.partners.isEmpty) {
          return const Center(
            child: Text(
              'No partners available at the moment.',
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
          );
        }

        return Column(
          children: <Widget>[
            if (widget.isMarketplace == null)
              Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 20, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    const Expanded(
                      child: Text(
                        'Partner with us, list deals, get featured & more customers.',
                        maxLines: 3,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        height: 45,
                        child: ElevatedButton(
                          child: const Text(
                            'Become a Partner',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                          onPressed: () {
                            Get.to(() => const BecomeaPartnerScreen());
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 10, bottom: 100),
                itemCount: partnerController.partners.length,
                itemBuilder: (BuildContext context, int index) {
                  final Partner partner =
                      partnerController.partners.toList()[index];
                  return BossuppartnerItem(
                    companyName: partner.companyName,
                    companyDescription: partner.companyDescription ?? '',
                    companyUrl: partner.companyUrl ?? '',
                    companyPhoto: partner.companyPhoto,
                    clicks: partner.clicks,
                    id: partner.id ?? 0,
                    partner: partner,
                    showPartnerMessage: isLastItem(index),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
