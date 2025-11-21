import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/partners/controllers/partners_controller.dart';
import 'package:business_bosses_v2/features/partners/models/partner_model.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class DealsSection extends StatefulWidget {
  const DealsSection({super.key});

  @override
  State<DealsSection> createState() => _DealsSectionState();
}

class _DealsSectionState extends State<DealsSection> {
  final PartnerController partnerController = Get.put(PartnerController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (partnerController.loading.value) {
        return SafetyModel();
      }

      return Container(
        padding: EdgeInsets.only(bottom: 16, right: 8, left: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Partners\' Deals',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 8,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 10,
                children: partnerController.partners.map((Partner item) {
                  return LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return GestureDetector(
                        onTap: () async {
                          final Uri companyUrl = Uri.parse(item.companyUrl!);
                          if (!await launchUrl(companyUrl)) {
                            throw Exception('Could not launch $companyUrl');
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 4,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: backgroundColor,
                              width: 1.0,
                            ),
                            gradient: const LinearGradient(
                              colors: <Color>[Colors.white, Colors.white],
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8, top: 8, bottom: 5),
                                    child: SizedBox(
                                      height: 35.0,
                                      width: 35.0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 0.5,
                                              color: Colors.black12),
                                          color: backgroundColor,
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                        ),
                                        child: NetworkImageWithPlaceHolder(
                                          imageUrl: item.companyPhoto ?? '',
                                          radius: 200,
                                          placeHolder: Icons.person,
                                          iconSize: 15.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 8.0, top: 8),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.white70,
                                        shape: BoxShape.circle,
                                      ),
                                      padding: const EdgeInsets.all(4),
                                      child: Icon(
                                        LucideIcons.arrowUpRight,
                                        size: 10,
                                        color: textColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      item.companyName,
                                      textAlign: TextAlign.left,
                                      maxLines: 1,
                                      style: const TextStyle(
                                        color: textColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );
    });
  }
}
