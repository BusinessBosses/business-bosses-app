import 'package:business_bosses_v2/features/donations/controller/donations_controller.dart';
import 'package:business_bosses_v2/features/donations/presentation/donation_members.dart';
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
  const DonationsPage({super.key});

  @override
  State<DonationsPage> createState() => _DonationsPageState();
}

class _DonationsPageState extends State<DonationsPage> {
  final DonationsController donationsController =
      Get.put(DonationsController());
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
    return NestedScrollView(
      controller: scrollController,
      headerSliverBuilder: (
        BuildContext context,
        bool innerBoxIsScrolled,
      ) {
        return <Widget>[
          SliverStickyHeader(
            sticky: false,
            header: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  color: Colors.transparent,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 10,
                      ),
                      if (_myProfile.myProfile.toPost)
                        Row(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () => <Future>{},
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Row(
                                  children: <Widget>[
                                    const Text(
                                      'Info',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
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
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(150, 45)),
                                    onPressed: () {
                                      if (!donationsController.userIds
                                          .contains(_myProfile.myProfile.uid)) {
                                        Get.snackbar(
                                          'Error!',
                                          'You have to join to create a donation!',
                                          backgroundColor: Colors.red,
                                          colorText: Colors.white,
                                        );
                                        return;
                                      }
                                      if (donationsController
                                          .doesUserDonationExist()) {
                                        Get.snackbar(
                                          'Error!',
                                          'You cannot create multiple donations!',
                                          backgroundColor: Colors.red,
                                          colorText: Colors.white,
                                        );
                                        return;
                                      }
                                      Get.toNamed(Routes.createdonationsscreen);
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        const Text(
                                          'Create a Donation',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500),
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
                        decoration: BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.black.withOpacity(0.09),
                              blurRadius: 100.0, // soften the shadow
                              spreadRadius: 5, //extend the shadow
                            )
                          ],
                        ),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(
                                  top: 10, right: 15, left: 15),
                              height: 150,
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: const ColoredBox(color: Colors.white),
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 25, right: 15, left: 30),
                                      height: 86,
                                      width: 142,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: FittedBox(
                                          fit: BoxFit.fill,
                                          child: Image.asset(
                                              'assets/images/donationpic.png'),
                                        ),
                                      ),
                                    ),
                                    const Expanded(
                                        child: Padding(
                                      padding:
                                          EdgeInsets.only(top: 25, right: 30),
                                      child: Text(
                                        // industry.description ??
                                        'Donate to Support a Project',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700),
                                        softWrap: true,
                                        maxLines: 5,
                                      ),
                                    )),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 27, right: 15),
                                  child: Row(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 2, top: 5),
                                            child: SvgPicture.asset(
                                              'assets/svgs/members.svg',
                                              height: 15,
                                              color: primaryColorLT,
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5.0),
                                            child: Obx(
                                              () => RichText(
                                                text: TextSpan(
                                                  children: <InlineSpan>[
                                                    TextSpan(
                                                      text:
                                                          'Members (${formatCount(donationsController.userIds.length)})',
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: primaryColorLT,
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                      ),
                                                      recognizer:
                                                          TapGestureRecognizer()
                                                            ..onTap = () {
                                                              Get.to(() =>
                                                                  DonationMembers(
                                                                      users: donationsController
                                                                          .usersMembers));
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
                                            padding: const EdgeInsets.only(
                                                left: 8.0, top: 5, right: 2),
                                            child: SvgPicture.asset(
                                              'assets/svgs/topics.svg',
                                              color: textColor,
                                              height: 11.5,
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5.0),
                                            child: Obx(
                                              () => RichText(
                                                text: TextSpan(
                                                  children: <InlineSpan>[
                                                    TextSpan(
                                                      text:
                                                          'Posts (${formatCount(donationsController.donations.length)})',
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        color: textColor,
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
                                        alignment: Alignment.centerRight,
                                        child: Obx(
                                          () => JoinedButton(
                                            donationsController.userIds
                                                .contains(
                                                    _myProfile.myProfile.uid),
                                            () {
                                              donationsController.joinGroup();
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
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 15, left: 15, bottom: 10),
                        child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFFFFF),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 20,
                                  blurRadius: 500,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed(Routes.promotionscreen);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: <Widget>[
                                        const Text('Coin Balance: '),
                                        SvgPicture.asset(
                                            'assets/svgs/coin.svg'),
                                        const SizedBox(
                                          width: 2,
                                        ),
                                        Text(
                                          '${_myProfile.myProfile.coinscount!}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: subtextColor),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.to(() => const DonationsHistory());
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      right: 10.0,
                                    ),
                                    child: Wrap(
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: <Widget>[
                                          const Text('Donation History '),
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
                    ],
                  ),
                )
              ],
            ),
          )
        ];
      },
      body: GetBuilder<DonationsController>(
        builder: (DonationsController controller) {
          return controller.loading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: controller.donations.length,
                  itemBuilder: (BuildContext context, int i) {
                    bool isLastItem = i == controller.donations.length - 1;
                    return DonationItem(
                      donation: controller.donations[i],
                      isLastItem: isLastItem,
                    );
                  },
                );
        },
      ),
    );
  }
}
