import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/donations/controller/donations_controller.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/market_controller.dart';
import 'package:business_bosses_v2/features/donations/presentation/donationpopup.dart';
import 'package:business_bosses_v2/features/donations/presentation/donations_history.dart';
import 'package:business_bosses_v2/features/donations/widgets/donation_item.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class DonationsPage extends StatefulWidget {
  final bool? ishome;
  const DonationsPage({super.key, this.ishome});

  @override
  State<DonationsPage> createState() => _DonationsPageState();
}

class _DonationsPageState extends State<DonationsPage> {
  final DonationsController donationsController =
      Get.put(DonationsController());
  final MarketController marketController = Get.find();
  final ProfileController _myProfile = Get.find();
  final ScrollController scrollController = ScrollController();

  String formatCount(int count) {
    if (count >= 1000) {
      double countInK = count / 1000;
      if (countInK >= 1000) {
        return '${(countInK / 1000).toStringAsFixed(1)}m';
      } else {
        return '${countInK.toStringAsFixed(1)}k';
      }
    } else {
      return count.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: Colors.white,
      body: Obx(
        () => donationsController.loading.value
            ? Center(child: SafetyModel())
            : NestedScrollView(
                controller: scrollController,
                headerSliverBuilder: (_, __) => <Widget>[
                  if (widget.ishome == false)
                    DonationsHeader(
                      controller: marketController,
                      donationsController: donationsController,
                      formatCount: formatCount,
                    ),
                ],
                body: DonationsList(
                  isHome: widget.ishome ?? false,
                  donationsController: donationsController,
                  myProfile: _myProfile,
                ),
              ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
      ),
      centerTitle: true,
      title: const Text('CrowdFund'),
    );
  }
}

class DonationsHeader extends StatelessWidget {
  final MarketController controller;
  final DonationsController donationsController;
  final String Function(int) formatCount;

  const DonationsHeader({
    super.key,
    required this.controller,
    required this.donationsController,
    required this.formatCount,
  });

  @override
  Widget build(BuildContext context) {
    return SliverStickyHeader(
      sticky: false,
      header: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            color: backgroundcolorinterface,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => const DonationPopup(),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(30)),
                          child: Row(
                            children: <Widget>[
                              SvgPicture.asset(
                                'assets/svgs/info.svg',
                                height: 15,
                              ),
                              const SizedBox(width: 5),
                              const Text(
                                'How it works ',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.09),
                          blurRadius: 100.0,
                          spreadRadius: 5,
                        )
                      ],
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.all(5),
                                height: 86,
                                width: 142,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: FittedBox(
                                    fit: BoxFit.fill,
                                    child: Image.asset(
                                        'assets/images/donationpic.png'),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  controller.donationDescription,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700),
                                  softWrap: true,
                                  maxLines: 5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  SvgPicture.asset(
                                    'assets/svgs/entries.svg',
                                    color: textColor,
                                    height: 11.5,
                                  ),
                                  const SizedBox(width: 5),
                                  Obx(
                                    () => Text(
                                      'Entries (${formatCount(donationsController.donations.length)})',
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                onPressed: () =>
                                    Get.toNamed(Routes.createdonationsscreen),
                                style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(90, 40)),
                                child: Row(
                                  children: <Widget>[
                                    const Text(
                                      'Enter ',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    SvgPicture.asset(
                                      'assets/svgs/startatopic.svg',
                                      height: 10,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DonationsList extends StatelessWidget {
  final bool isHome;
  final DonationsController donationsController;
  final ProfileController myProfile;

  const DonationsList({
    super.key,
    required this.isHome,
    required this.donationsController,
    required this.myProfile,
  });

  @override
  Widget build(BuildContext context) {
    return donationsController.donations.isEmpty
        ? const SafetyModel(isLoading: false, title: 'No Post Found!')
        : GetBuilder<DonationsController>(
            builder: (DonationsController controller) {
              return Container(
                color: isHome ? Colors.white : backgroundColor,
                child: Column(
                  children: <Widget>[
                    if (!isHome) _buildBalanceAndHistoryRow(),
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.only(bottom: isHome ? 0 : 100),
                        scrollDirection:
                            isHome ? Axis.horizontal : Axis.vertical,
                        itemCount: isHome ? 5 : controller.donations.length,
                        itemBuilder: (BuildContext context, int i) {
                          final bool isLast =
                              i == controller.donations.length - 1;
                          return Padding(
                            padding: EdgeInsets.only(left: isHome ? 10.0 : 0),
                            child: DonationItem(
                              donation: controller.donations[i],
                              isLastItem: isLast,
                              isHome: isHome,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
  }

  Widget _buildBalanceAndHistoryRow() {
    return Padding(
      padding: const EdgeInsets.only(right: 15, left: 15, bottom: 10, top: 10),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              onTap: () => Get.toNamed(Routes.promotionscreen),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Container(
                  width: 142,
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text('Balance: '),
                      SvgPicture.asset('assets/svgs/coin.svg'),
                      const SizedBox(width: 2),
                      Text(
                        '${myProfile.myProfile.coinscount!}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: subtextColor,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => Get.to(() => const DonationsHistory()),
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Row(
                  children: <Widget>[
                    const Text(
                      'Crowdfund History ',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    SvgPicture.asset(
                      'assets/svgs/nexticon.svg',
                      colorFilter:
                          const ColorFilter.mode(textColor, BlendMode.srcIn),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
