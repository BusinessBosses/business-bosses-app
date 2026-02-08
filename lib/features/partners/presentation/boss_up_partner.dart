import 'dart:core';
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/partners/controllers/partners_controller.dart';
import 'package:business_bosses_v2/features/partners/models/partner_model.dart';
import 'package:business_bosses_v2/features/partners/presentation/become_a_partner_screen.dart';
import 'package:business_bosses_v2/features/partners/widgets/bossup_partner_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../utils/theme/theme.dart';

class BossUpPartner extends StatefulWidget {
  final bool? isMarketplace;
  const BossUpPartner({super.key, this.isMarketplace});

  @override
  State<BossUpPartner> createState() => _BossUpPartnerState();
}

class _BossUpPartnerState extends State<BossUpPartner> {
  final PartnerController partnerController = Get.put(PartnerController());
  final List<String> categories = const <String>[
    'All',
    'Agriculture, Food & Beverage',
    'Business Services & Consulting',
    'Learning & Education',
    'Construction & Real Estate',
    'Fashion & Beauty',
    'Finance & Legal',
    'Healthcare & Wellness',
    'Home, Gardens & Outdoors',
    'Jewellery & Timepieces',
    'Media & Entertainment',
    'Security, Safety & Equipment',
    'Technology, Games & Electronic',
    'Vehicle & Transportation',
  ];
  bool _showRightChevron = true;

  String selectedCategory = 'All';
  final ScrollController _categoryScrollController = ScrollController();

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
  void initState() {
    super.initState();

    _categoryScrollController.addListener(() {
      if (!_categoryScrollController.hasClients) return;

      final double maxScroll =
          _categoryScrollController.position.maxScrollExtent;
      final double current = _categoryScrollController.offset;

      setState(() {
        _showRightChevron = current < maxScroll - 10;
      });
    });
  }

  @override
  void dispose() {
    _categoryScrollController.dispose();
    super.dispose();
  }

  Widget _buildCategoryChips() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              // Scrollable chips
              Expanded(
                child: SingleChildScrollView(
                  controller: _categoryScrollController,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: categories.map((String category) {
                      final bool isSelected = selectedCategory == category;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategory = category;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFEEEEEE)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            category.length > 20
                                ? '${category.substring(0, 18)}...'
                                : category,
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              // 👉 Chevron Right (LIKE MARKETPLACE)
              if (_showRightChevron)
                GestureDetector(
                  onTap: () {
                    _categoryScrollController.animateTo(
                      _categoryScrollController.offset + 150,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Icon(
                      LucideIcons.chevronRight,
                      color: Colors.black54,
                      size: 15,
                    ),
                  ),
                ),
            ],
          ),
          const Divider(height: 1),
        ],
      ),
    );
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

        final List<Partner> filteredPartners = selectedCategory == 'All'
            ? partnerController.partners
            : partnerController.partners
                .where((Partner p) => p.category == selectedCategory)
                .toList();

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
            _buildCategoryChips(),
            if (filteredPartners.isEmpty)
              const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: SafetyModel(
                        isLoading: false,
                        icon: Icon(Icons.warning),
                        title: 'No Partner Found in This Category!',
                      ),
                    )
                  ]),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 10, bottom: 100),
                itemCount: filteredPartners.length,
                itemBuilder: (BuildContext context, int index) {
                  final Partner partner = filteredPartners[index];
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
