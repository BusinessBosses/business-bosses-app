// ignore_for_file: deprecated_member_use, always_specify_types

import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/features/home/all_communities_screen.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/features/promotions/widgets/buycoinslist_item.dart';
import 'package:business_bosses_v2/features/withdrawal/controller/coinhistorycontroller.dart';
import 'package:business_bosses_v2/features/withdrawal/widgets/withdrawal_header_item.dart';
import 'package:business_bosses_v2/features/withdrawal/widgets/withdrawal_item.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../action/action.dart';
import '../../../navigation/routes.dart';

bool isExpanded = false;

class DepositsScreen extends StatefulWidget {
  static const String routeName = '/deposits-screen';

  const DepositsScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DepositsScreenState createState() => _DepositsScreenState();
}

class _DepositsScreenState extends State<DepositsScreen> {
  final ScrollController scrollController = ScrollController();
  final ProfileController _profileController = Get.find();
  final CoinHistoryController coinHistoryController =
      Get.put(CoinHistoryController());
  // ignore: unused_field
  String? _paymentmethods;
  late String _referralId;
  List<String> coinAmounts = <String>['100', '200', '500', '1000', '10000'];
  List<String> coinPrices = <String>['0.99', '1.99', '4.99', '9.99', '99.99'];
  List<String> coinIDs = <String>[
    '100_bb_coins',
    '200_bb_coins',
    '500_bb_coins',
    '1000_bb_coins',
    '10000_bb_coins'
  ];

  @override
  void initState() {
    super.initState();
    _referralId = _profileController.myProfile.inviteId!;
  }

  @override
  Widget build(BuildContext context) {
    ProfileController profileController = Get.find();
    final ThemeData theme =
        Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return Scaffold(
        backgroundColor: Colors.white,
        body: NestedScrollView(
            controller: scrollController,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverStickyHeader(
                  sticky: false,
                  header: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 1,
                          color: backgroundcolorinterface,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Top up balance',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    'Get more coins using cash',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w700),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 120,
                                height: 43,
                                child: ElevatedButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          backgroundColor: Colors.white,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 40.0,
                                                      horizontal: 20),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        'Buy more BB Coins',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18),
                                                      ),
                                                      Text('Promotional Text')
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    10.0),
                                                        child: Container(
                                                          color:
                                                              backgroundcolorinterface,
                                                          height: 1,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: ListView.builder(
                                                          itemCount: coinAmounts
                                                              .length,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index) {
                                                            return GestureDetector(
                                                              onTap: () async {
                                                                try {
                                                                  await Purchases
                                                                      .purchaseProduct(
                                                                          coinIDs[
                                                                              index]);

                                                                  /// update coin here
                                                                } catch (e) {
                                                                  showSnackbar(
                                                                    title:
                                                                        'OOPS!',
                                                                    message:
                                                                        'An error occurred while making payment, please try again!',
                                                                    error: true,
                                                                  );
                                                                }
                                                              },
                                                              child:
                                                                  BuyCoinsListItem(
                                                                coinamount:
                                                                    coinAmounts[
                                                                        index],
                                                                coinprice:
                                                                    coinPrices[
                                                                        index],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    child: const Text(
                                      'Buy Coins',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16),
                                    )),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 1,
                          color: backgroundcolorinterface,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Become a premium user',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    'Get 100 coins monthly',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w700),
                                  )
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  !profileController.myProfile.isSubscribed
                                      ? Get.toNamed(Routes.premiumscreen)
                                      : null;
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  width: 120,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2,
                                        color: !profileController
                                                .myProfile.isSubscribed
                                            ? primaryColorLT
                                            : Colors.grey),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        !profileController
                                                .myProfile.isSubscribed
                                            ? 'Subscribe'
                                            : 'Subscribed',
                                        style: TextStyle(
                                            color: !profileController
                                                    .myProfile.isSubscribed
                                                ? primaryColorLT
                                                : Colors.grey,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16),
                                      ),
                                      !profileController.myProfile.isSubscribed
                                          ? SvgPicture.asset(
                                              'assets/svgs/nexticon.svg')
                                          : Container()
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 1,
                          color: backgroundcolorinterface,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Sell on Marketplace',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    'Sell your Products or Services',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w700),
                                  )
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed(
                                    Routes.marketPlace,
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  width: 120,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2, color: primaryColorLT),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      const Text(
                                        'Sell',
                                        style: TextStyle(
                                            color: primaryColorLT,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16),
                                      ),
                                      SvgPicture.asset(
                                          'assets/svgs/nexticon.svg')
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 1,
                          color: backgroundcolorinterface,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Create Premium Courses',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    'Monetise your expetise',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w700),
                                  )
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.to(() => const AllCommunitiesScreen(
                                        initialTabIndex: 1,
                                      ));
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  width: 120,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2, color: primaryColorLT),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      const Text(
                                        'Create',
                                        style: TextStyle(
                                            color: primaryColorLT,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16),
                                      ),
                                      SvgPicture.asset(
                                          'assets/svgs/nexticon.svg')
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 1,
                          color: backgroundcolorinterface,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const Text(
                                    'Invite friends to get 10 coins',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    'Invite ID : ${_profileController.myProfile.inviteId!}',
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w700),
                                  )
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  _shareWithFriends();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  width: 120,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2, color: primaryColorLT),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      const Text(
                                        'Invite',
                                        style: TextStyle(
                                            color: primaryColorLT,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16),
                                      ),
                                      SvgPicture.asset(
                                        'assets/svgs/invite.svg',
                                        color: primaryColorLT,
                                        height: 13,
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 1,
                          color: backgroundcolorinterface,
                        ),
                      ],
                    ),
                  ),
                )
              ];
            },
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Theme(
                    data: theme,
                    child: ExpansionTile(
                      trailing: isExpanded
                          ? SvgPicture.asset(
                              'assets/svgs/dropdownexpansionup.svg',
                            )
                          : SvgPicture.asset(
                              'assets/svgs/dropdownexpansion.svg',
                            ),
                      title: const Text('Top up history',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 16)),
                      children: <Widget>[
                        FutureBuilder<void>(
                          future: coinHistoryController.initHistory(),
                          builder: (BuildContext context,
                              AsyncSnapshot<void> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              // While data is being fetched, show a loading indicator
                              return const Padding(
                                padding: EdgeInsets.all(80.0),
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              // If an error occurs during data fetching, handle it accordingly
                              return Text('Error: ${snapshot.error}');
                            } else {
                              // If data fetching is successful, build your UI with the fetched data
                              return Container(
                                child: coinHistoryController
                                        .coindepositsHistory.isEmpty
                                    ? Padding(
                                        padding: const EdgeInsets.all(80.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            SvgPicture.asset(
                                              'assets/svgs/coinnn.svg',
                                              height: 40,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            const Text(
                                              'No Coin Deposits Found',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 15),
                                            )
                                          ],
                                        ),
                                      )
                                    : Column(
                                        children: <Widget>[
                                          const WithdrawalHeaderItem(),
                                          ListView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: coinHistoryController
                                                .coindepositsHistory.length,
                                            itemBuilder:
                                                (BuildContext context, int i) {
                                              coinHistoryController
                                                  .coindepositsHistory
                                                  .sort((a, b) =>
                                                      DateTime.parse(b['date'])
                                                          .compareTo(
                                                              DateTime.parse(
                                                                  a['date'])));

                                              return WithdrawalItem(
                                                item: coinHistoryController
                                                    .coindepositsHistory[i],
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                              );
                            }
                          },
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 1,
                    color: backgroundcolorinterface,
                  ),
                ],
              ),
            )));
  }

  void _shareWithFriends() {
    // ignore: unnecessary_null_comparison
    if (_referralId == null) return;
    String message = 'Check out Business Bosses.\n'
        'An app to meet entrepreneurs and grow your business. Join now for FREE promotion\n'
        'https://businessbosses.onelink.me/xLWk/36a2ff16\n'
        'Invite id: $_referralId';
    logEvent(_profileController.myProfile.inviteId, 'invite');
    socialShare(message);
  }
}
