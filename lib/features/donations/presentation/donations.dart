import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/donations/controller/donations_controller.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/market_controller.dart';
import 'package:business_bosses_v2/features/donations/presentation/donation_members.dart';
import 'package:business_bosses_v2/features/donations/presentation/donationpopup.dart';
import 'package:business_bosses_v2/features/donations/presentation/donations_history.dart';
import 'package:business_bosses_v2/features/donations/widgets/donation_item.dart';
import 'package:business_bosses_v2/features/forum/widgets/joinedbutton.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/gestures.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
        backgroundColor: Colors.white,
        // appBar: widget.ishome == false
        //     ? AppBar(
        //         leading: IconButton(
        //           onPressed: () {
        //             Navigator.pop(context);
        //           },
        //           icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        //         ),
        //         centerTitle: true,
        //         title: const Text(
        //           'CrowdFund',
        //           textAlign: TextAlign.center,
        //         ),
        //       )
        //     : null,
        body: donationsController.loading.value
            ? const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : NestedScrollView(
                controller: scrollController,
                headerSliverBuilder: (
                  BuildContext context,
                  bool innerBoxIsScrolled,
                ) {
                  return <Widget>[
                    SliverStickyHeader(
                      sticky: false,
                      header: widget.ishome == false
                          ? Column(
                              children: <Widget>[
                                Container(
                                  width: double.infinity,
                                  color: backgroundColor,
                                  child: Column(
                                    children: <Widget>[
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      if (_myProfile.myProfile.toPost)
                                        Row(
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          const DonationPopup(),
                                                );
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15.0),
                                                child: Row(
                                                  children: <Widget>[
                                                    const Text(
                                                      'Info',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    SvgPicture.asset(
                                                      'assets/svgs/info.svg',
                                                      height: 20,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const Spacer(),
                                            Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 15),
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            minimumSize:
                                                                const Size(
                                                                    150, 45)),
                                                    onPressed: () {
                                                      if (!donationsController
                                                          .userIds
                                                          .contains(_myProfile
                                                              .myProfile.uid)) {
                                                        Get.snackbar(
                                                          'Error!',
                                                          'You have to join to create a donation!',
                                                          backgroundColor:
                                                              Colors.red,
                                                          colorText:
                                                              Colors.white,
                                                        );
                                                        return;
                                                      }
                                                      if (donationsController
                                                          .doesUserDonationExist()) {
                                                        Get.snackbar(
                                                          'Error!',
                                                          'You cannot create multiple donations!',
                                                          backgroundColor:
                                                              Colors.red,
                                                          colorText:
                                                              Colors.white,
                                                        );
                                                        return;
                                                      }
                                                      Get.toNamed(Routes
                                                          .createdonationsscreen);
                                                    },
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        const Text(
                                                          'Post a Project',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        SvgPicture.asset(
                                                            'assets/svgs/startatopic.svg')
                                                      ],
                                                    ),
                                                  ),
                                                )),
                                          ],
                                        ),
                                      Container(
                                        decoration: const BoxDecoration(
                                            color: backgroundColor),
                                        child: Stack(
                                          children: <Widget>[
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 10, right: 15, left: 15),
                                              height: 150,
                                              width: double.infinity,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                                child: const ColoredBox(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            Column(
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 25,
                                                              right: 15,
                                                              left: 30),
                                                      height: 86,
                                                      width: 142,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        child: FittedBox(
                                                          fit: BoxFit.fill,
                                                          child: Image.asset(
                                                              'assets/images/donationpic.png'),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                        child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 25,
                                                              right: 30),
                                                      child: Text(
                                                        marketController
                                                            .donationDescription,
                                                        style: const TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                        softWrap: true,
                                                        maxLines: 5,
                                                      ),
                                                    )),
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 27, right: 15),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Row(
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    right: 2,
                                                                    top: 5),
                                                            child: SvgPicture
                                                                .asset(
                                                              'assets/svgs/members.svg',
                                                              height: 15,
                                                              color:
                                                                  primaryColorLT,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 5.0),
                                                            child: Obx(
                                                              () => RichText(
                                                                text: TextSpan(
                                                                  children: <InlineSpan>[
                                                                    TextSpan(
                                                                      text:
                                                                          'Members (${formatCount(donationsController.userIds.length)})',
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        color:
                                                                            primaryColorLT,
                                                                        decoration:
                                                                            TextDecoration.underline,
                                                                      ),
                                                                      recognizer:
                                                                          TapGestureRecognizer()
                                                                            ..onTap =
                                                                                () {
                                                                              Get.to(() => DonationMembers(users: donationsController.usersMembers));
                                                                            },
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 8.0,
                                                                    top: 5,
                                                                    right: 2),
                                                            child: SvgPicture
                                                                .asset(
                                                              'assets/svgs/topics.svg',
                                                              color: textColor,
                                                              height: 11.5,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 5.0),
                                                            child: Obx(
                                                              () => RichText(
                                                                text: TextSpan(
                                                                  children: <InlineSpan>[
                                                                    TextSpan(
                                                                      text:
                                                                          'Posts (${formatCount(donationsController.donations.length)})',
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        color:
                                                                            textColor,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const Spacer(),
                                                      Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Obx(
                                                          () => JoinedButton(
                                                            donationsController
                                                                .userIds
                                                                .contains(
                                                                    _myProfile
                                                                        .myProfile
                                                                        .uid),
                                                            () {
                                                              donationsController
                                                                  .joinGroup();
                                                            },
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )
                          : null,
                    )
                  ];
                },
                body: donationsController.donations.isEmpty
                    ? const SafetyModel(
                        isLoading: false,
                        title: 'No Post Found!',
                      )
                    : GetBuilder<DonationsController>(
                        builder: (DonationsController controller) {
                          return Container(
                            color: widget.ishome == false
                                ? backgroundColor
                                : Colors.white,
                            child: Column(
                              children: <Widget>[
                                widget.ishome == false
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            right: 15,
                                            left: 15,
                                            bottom: 10,
                                            top: 10),
                                        child: Container(
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              // boxShadow: <BoxShadow>[
                                              //   BoxShadow(
                                              //     color: Colors.grey
                                              //         .withOpacity(0.3),
                                              //     spreadRadius: 20,
                                              //     blurRadius: 500,
                                              //     offset: const Offset(0, 3),
                                              //   ),
                                              // ],
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                GestureDetector(
                                                  onTap: () {
                                                    Get.toNamed(
                                                        Routes.promotionscreen);
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10.0),
                                                    child: Container(
                                                      width: 142,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 1),
                                                      decoration: BoxDecoration(
                                                          color:
                                                              backgroundColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                      child: Wrap(
                                                        alignment: WrapAlignment
                                                            .center,
                                                        crossAxisAlignment:
                                                            WrapCrossAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          const Text(
                                                              'Balance: '),
                                                          SvgPicture.asset(
                                                              'assets/svgs/coin.svg'),
                                                          const SizedBox(
                                                            width: 2,
                                                          ),
                                                          Text(
                                                            '${_myProfile.myProfile.coinscount!}',
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color:
                                                                    subtextColor),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Get.to(() =>
                                                        const DonationsHistory());
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      right: 10.0,
                                                    ),
                                                    child: Wrap(
                                                        crossAxisAlignment:
                                                            WrapCrossAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          const Text(
                                                            'Crowdfund History ',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                          SvgPicture.asset(
                                                            'assets/svgs/nexticon.svg',
                                                            color: textColor,
                                                          ),
                                                        ]),
                                                  ),
                                                )
                                              ],
                                            )),
                                      )
                                    : Container(),
                                controller.loading.value
                                    ? const Expanded(
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      )
                                    : Container(
                                        child: Expanded(
                                          child: Container(
                                            color: backgroundColor,
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection:
                                                  widget.ishome == false
                                                      ? Axis.vertical
                                                      : Axis.horizontal,
                                              itemCount: widget.ishome == false
                                                  ? controller.donations.length
                                                  : 5,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int i) {
                                                bool isLastItem = controller
                                                            .donations.length !=
                                                        1
                                                    ? i ==
                                                        controller.donations
                                                                .length -
                                                            1
                                                    : i ==
                                                        controller
                                                            .donations.length;
                                                return Padding(
                                                  padding: EdgeInsets.only(
                                                      left:
                                                          widget.ishome == false
                                                              ? 0
                                                              : 10.0),
                                                  child: DonationItem(
                                                    donation:
                                                        controller.donations[i],
                                                    isLastItem: isLastItem,
                                                    isHome:
                                                        widget.ishome == false
                                                            ? false
                                                            : true,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      )
                              ],
                            ),
                          );
                        },
                      ),
              ));
  }
}
