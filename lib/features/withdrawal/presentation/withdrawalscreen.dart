import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/common/widgets/buttons/custom_button.dart';
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/features/withdrawal/controller/coinhistorycontroller.dart';
import 'package:business_bosses_v2/features/withdrawal/model/cointransactionmodel.dart';
import 'package:business_bosses_v2/features/withdrawal/widgets/withdrawal_header_item.dart';
import 'package:business_bosses_v2/features/withdrawal/widgets/withdrawal_item.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../action/action.dart';
import '../../../navigation/routes.dart';

bool isExpanded = false;

class WithdrawalScreen extends StatefulWidget {
  static const String routeName = '/withdrawal-screen';

  const WithdrawalScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _WithdrawalScreenState createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  final ScrollController scrollController = ScrollController();
  final ProfileController _profileController = Get.find();
  TextEditingController _withdrawlamountcontroller = TextEditingController();
  TextEditingController _walletaddresscontroller = TextEditingController();
  String? _paymentmethods;
  bool paymentSelected = false;
  bool isProcessing = false;
  final CoinHistoryController coinHistoryController = Get.find();

  @override
  void initState() {
    super.initState();
    coinHistoryController.initHistory();
  }

  @override
  Widget build(BuildContext context) {
    ProfileController profileController = Get.find();
    print(coinHistoryController.coinwithdrawalHistory);
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);

    return Scaffold(
        backgroundColor: Colors.white,
        body: NestedScrollView(
            controller: scrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return <Widget>[
                SliverStickyHeader(
                  sticky: false,
                  header: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        const Row(
                          children: [
                            Text('Amount to withdraw'),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '(Minimum 5,000 Coins)',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        Stack(children: [
                          TextFormField(
                            controller: _withdrawlamountcontroller,
                            maxLength: 6,
                            onChanged: (String val) {
                              setState(() {});
                            },
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')), // Allow only numbers
                            ],
                            buildCounter: (BuildContext context,
                                    {required int? currentLength,
                                    required bool isFocused,
                                    required int? maxLength}) =>
                                null,
                            decoration: inputDecoration.copyWith(
                              contentPadding: const EdgeInsets.only(
                                  left: 50, top: 18, bottom: 18),
                              hintText: '0',
                              hintStyle: const TextStyle(
                                color: iconColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              filled: true,
                              fillColor: const Color(0xffF4F4F4),
                            ),
                          ),
                          Positioned(
                              top: 0,
                              bottom: 0,
                              left: 10,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SvgPicture.asset('assets/svgs/coin.svg'),
                                ],
                              )),
                          Positioned(
                              top: 0,
                              bottom: 0,
                              right: 10,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(_withdrawlamountcontroller.text != ''
                                      ? ' \$${num.parse(_withdrawlamountcontroller.text) / 100}'
                                      : '\$0'),
                                ],
                              )),
                        ]),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text('Payment Method'),
                        Container(
                          height: 55,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                          ),
                          decoration: BoxDecoration(
                            color: backgroundcolorinterface,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: DropdownButton<String>(
                                  value: _paymentmethods,
                                  borderRadius: BorderRadius.circular(radius),
                                  isExpanded: true,
                                  icon: const Icon(
                                      Icons.keyboard_arrow_down_sharp),
                                  iconSize: 24,
                                  elevation: 16,
                                  underline: Container(
                                    height: 0,
                                    color: Colors.white,
                                  ),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _paymentmethods = newValue ?? 'Paypal';
                                      paymentSelected = true;
                                    });
                                  },
                                  items: <String>[
                                    'Paypal',
                                    'Bank',
                                    'Mobile Money'
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Row(
                                        children: [
                                          value == 'Paypal'
                                              ? SvgPicture.asset(
                                                  'assets/svgs/paypallogo.svg',
                                                  height: 20,
                                                )
                                              : value == 'Bank'
                                                  ? SvgPicture.asset(
                                                      'assets/svgs/bank.svg',
                                                      height: 20,
                                                    )
                                                  : SvgPicture.asset(
                                                      'assets/svgs/mobilemoney.svg',
                                                      height: 15,
                                                    ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(value),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Visibility(
                          visible: paymentSelected,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Enter your $_paymentmethods details below'),
                              Text(_paymentmethods == 'Bank'
                                  ? 'FULL NAME: COUNTRY: BANK NAME: ACCOUNT NUMBER:'
                                  : _paymentmethods == 'Paypal'
                                      ? 'FULL NAME: PAYPAL EMAIL ADDRESS: '
                                      : 'FULL NAME: MOBILE MONEY NUMBER: '),
                              TextFormField(
                                controller: _walletaddresscontroller,
                                maxLines: 5,
                                onChanged: (String val) {
                                  setState(() {});
                                },
                                decoration: inputDecoration.copyWith(
                                  hintText: '',
                                  hintStyle: const TextStyle(
                                    color: iconColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xffF4F4F4),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: double.infinity,
                          height: 50,
                          child: CustomButton(
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              if (_withdrawlamountcontroller.text != '') {
                                if (num.parse(_withdrawlamountcontroller.text) <
                                    5000) {
                                  showSnackbar(
                                      title: 'OOPS!',
                                      message:
                                          'Withdrawal amount cannot be less than 5000 coins, please try again!',
                                      error: true);
                                } else if (num.parse(
                                        _withdrawlamountcontroller.text) >
                                    profileController.myProfile.coinsCount) {
                                  showSnackbar(
                                      title: 'OOPS!',
                                      message:
                                          'Withdrawal amount cannot exceed your balance, please try again!',
                                      error: true);
                                } else if (_paymentmethods == null) {
                                  showSnackbar(
                                      title: 'OOPS!',
                                      message:
                                          'Please select a payment method to continue',
                                      error: true);
                                } else if (_walletaddresscontroller
                                    .text.isEmpty) {
                                  showSnackbar(
                                      title: 'OOPS!',
                                      message:
                                          'Please enter a wallet address to continue',
                                      error: true);
                                } else {
                                  setState(() {
                                    isProcessing = true;
                                  });
                                  await coinHistoryController
                                      .makeWithdrawal(<String, dynamic>{
                                    'status': 'Pending',
                                    'approved': false,
                                    'duration': null,
                                    'description':
                                        _walletaddresscontroller.text,
                                    'deleted': false,
                                    'deletedAt': null,
                                    'userId': profileController.myProfile.uid,
                                    'transactionType': 'credit',
                                    'amount': _withdrawlamountcontroller.text,
                                    'paymentMethod': 'revenuecat',
                                    'date': DateTime.now().toString(),
                                  });
                                  setState(() {
                                    isProcessing = false;
                                  });
                                }
                              } else {
                                showSnackbar(
                                    title: 'OOPS!',
                                    message:
                                        'Please enter an amount to withdraw!',
                                    error: true);
                              }
                            },
                            isProcessing: isProcessing,
                            buttonType: ButtonType.elevated,
                            child: const Text(
                              'Make Withdrawal',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 17),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ];
            },
            body: Column(
              children: [
                Container(
                  height: 1,
                  color: backgroundcolorinterface,
                ),
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
                    title: const Text('Withdrawal history',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16)),
                    children: [
                      FutureBuilder<void>(
                        future: coinHistoryController.initHistory(),
                        builder: (BuildContext context,
                            AsyncSnapshot<void> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            // While data is being fetched, show a loading indicator
                            return Padding(
                              padding: const EdgeInsets.all(80.0),
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            // If an error occurs during data fetching, handle it accordingly
                            return Text('Error: ${snapshot.error}');
                          } else {
                            // If data fetching is successful, build your UI with the fetched data
                            return Container(
                              child: coinHistoryController
                                      .coinwithdrawalHistory.isEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.all(80.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/svgs/coinnn.svg',
                                            height: 40,
                                            color: Colors.grey,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'No Coin Withdrawals Found',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 15),
                                          )
                                        ],
                                      ),
                                    )
                                  : Column(
                                      children: [
                                        WithdrawalHeaderItem(),
                                        Container(
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: coinHistoryController
                                                .coinwithdrawalHistory.length,
                                            itemBuilder:
                                                (BuildContext context, int i) {
                                              // Sort the list based on the 'date' key in each map in descending order
                                              coinHistoryController
                                                  .coinwithdrawalHistory
                                                  .sort((a, b) =>
                                                      DateTime.parse(b['date'])
                                                          .compareTo(
                                                              DateTime.parse(
                                                                  a['date'])));

                                              return WithdrawalItem(
                                                item: coinHistoryController
                                                    .coinwithdrawalHistory[i],
                                              );
                                            },
                                          ),
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
            )));
  }
}
