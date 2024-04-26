import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/common/widgets/buttons/custom_button.dart';
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/features/promotions/widgets/buycoinslist_item.dart';
import 'package:business_bosses_v2/features/withdrawal/controller/coinhistorycontroller.dart';
import 'package:business_bosses_v2/features/withdrawal/widgets/withdrawal_header_item.dart';
import 'package:business_bosses_v2/features/withdrawal/widgets/withdrawal_item.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  String? _paymentmethods;
  late String _referralId;
  List<String> coinAmounts = ['100', '200', '500', '1000', '10000'];
  List<String> coinPrices = ['0.99', '1.99', '4.99', '9.99', '99.99'];
  List<String> coinIDs = [
    '100_bb_coins',
    '200_bb_coins',
    '500_bb_coins',
    '1000_bb_coins',
    '10000_bb_coins'
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _referralId = _profileController.myProfile.inviteId!;
  }

  @override
  Widget build(BuildContext context) {
    ProfileController profileController = Get.find();
    return Scaffold(
        backgroundColor: Colors.white,
        body: NestedScrollView(
            controller: scrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return <Widget>[
                SliverStickyHeader(
                  sticky: false,
                  header: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 1,
                          color: backgroundcolorinterface,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                              Container(
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
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 40.0,
                                                      horizontal: 20),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
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
                                                Container(
                                                  child: Expanded(
                                                    child: Column(
                                                      children: [
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
                                                        Container(
                                                          child: Expanded(
                                                            child: ListView
                                                                .builder(
                                                              itemCount:
                                                                  coinAmounts
                                                                      .length,
                                                              itemBuilder:
                                                                  (BuildContext
                                                                          context,
                                                                      int index) {
                                                                return GestureDetector(
                                                                  onTap:
                                                                      () async {
                                                                    try {
                                                                      await Purchases
                                                                          .purchaseProduct(
                                                                              coinIDs[index]);
                                                                      print(
                                                                          'coin increase');

                                                                      /// update coin here
                                                                    } catch (e) {
                                                                      showSnackbar(
                                                                        title:
                                                                            'OOPS!',
                                                                        message:
                                                                            'An error occurred while making payment, please try again!',
                                                                        error:
                                                                            true,
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
                                                        ),
                                                      ],
                                                    ),
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
                        Visibility(
                          visible: !profileController.myProfile.isSubscribed,
                          child: Container(
                            height: 1,
                            color: backgroundcolorinterface,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Become a premium user',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    'Get 500 coins monthly',
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
                                    children: [
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
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                  padding: EdgeInsets.symmetric(
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
                                    children: [
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
            body: Column(
              children: [
                ExpansionTile(
                  trailing: isExpanded
                      ? SvgPicture.asset(
                          'assets/svgs/dropdownexpansionup.svg',
                        )
                      : SvgPicture.asset(
                          'assets/svgs/dropdownexpansion.svg',
                        ),
                  title: const Text('Top up history',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  children: [
                    Container(
                      child: coinHistoryController.coindepositsHistory.isEmpty
                          ? const SafetyModel(
                              isLoading: false,
                              title: 'No Coin Deposits Found',
                              icon: Icon(Icons.warning),
                            )
                          : Column(
                              children: [
                                WithdrawalHeaderItem(),
                                Container(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: coinHistoryController.coindepositsHistory.length,
                                    itemBuilder: (BuildContext context, int i) {
                                      return WithdrawalItem();
                                    },
                                  ),
                                ),
                              ],
                            ),
                    )
                  ],
                ),
                Container(
                  height: 1,
                  color: backgroundcolorinterface,
                ),
              ],
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
