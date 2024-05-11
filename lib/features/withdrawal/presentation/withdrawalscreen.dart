import 'package:business_bosses_v2/features/withdrawal/widgets/withdrawal_header_item.dart';
import 'package:business_bosses_v2/features/withdrawal/widgets/withdrawal_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../common/dialogs/snackbar.dart';
import '../../../common/widgets/buttons/custom_button.dart';
import '../../../features/profile/controller/profile_controller.dart';
import '../../../features/withdrawal/controller/coinhistorycontroller.dart';
import '../../../utils/theme/theme.dart';

class WithdrawalScreen extends StatefulWidget {
  static const String routeName = '/withdrawal-screen';

  const WithdrawalScreen({Key? key}) : super(key: key);

  @override
  _WithdrawalScreenState createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  final ScrollController scrollController = ScrollController();
  late ProfileController _profileController;
  final TextEditingController _withdrawlAmountController = TextEditingController();
  final TextEditingController _walletAddressController = TextEditingController();
  String? _paymentMethods;
  bool paymentSelected = false;
  bool isProcessing = false;
  late CoinHistoryController coinHistoryController;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    _profileController = Get.find();
    coinHistoryController = Get.find();
    coinHistoryController.initHistory();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);

    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        controller: scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(
                      height: 10,
                    ),
                    const Row(
                      children: <Widget>[
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
                    Stack(
                      children: <Widget>[
                        TextFormField(
                          controller: _withdrawlAmountController,
                          maxLength: 6,
                          onChanged: (String val) {
                            setState(() {});
                          },
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              SvgPicture.asset('assets/svgs/coin.svg'),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 0,
                          bottom: 0,
                          right: 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                _withdrawlAmountController.text.isNotEmpty
                                    ? ' \$${num.parse(_withdrawlAmountController.text) / 100}'
                                    : '\$0',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text('Payment Method'),
                    Container(
                      height: 55,
                      padding: const EdgeInsets.symmetric(horizontal: 9),
                      decoration: BoxDecoration(
                        color: backgroundcolorinterface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: DropdownButton<String>(
                              value: _paymentMethods,
                              borderRadius: BorderRadius.circular(radius),
                              isExpanded: true,
                              icon: const Icon(Icons.keyboard_arrow_down_sharp),
                              iconSize: 24,
                              elevation: 16,
                              underline: Container(
                                height: 0,
                                color: Colors.white,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _paymentMethods = newValue;
                                  paymentSelected = true;
                                });
                              },
                              items: <String>['Paypal', 'Bank', 'Mobile Money']
                                  .map<DropdownMenuItem<String>>(
                                (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Row(
                                      children: <Widget>[
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
                                },
                              ).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Visibility(
                      visible: paymentSelected,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Enter your $_paymentMethods details below'),
                          Text(_paymentMethods == 'Bank'
                              ? 'FULL NAME: COUNTRY: BANK NAME: ACCOUNT NUMBER:'
                              : _paymentMethods == 'Paypal'
                                  ? 'FULL NAME: PAYPAL EMAIL ADDRESS: '
                                  : 'FULL NAME: MOBILE MONEY NUMBER: '),
                          TextFormField(
                            controller: _walletAddressController,
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
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: CustomButton(
                        isProcessing: isProcessing,
                        buttonType: ButtonType.elevated,
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          SystemChannels.textInput
                              .invokeMethod('TextInput.hide');
                          if (_withdrawlAmountController.text.isEmpty) {
                            showSnackbar(
                              title: 'OOPS!',
                              message: 'Please enter an amount to withdraw!',
                              error: true,
                            );
                          } else if (num.parse(
                                  _withdrawlAmountController.text) <
                              5000) {
                            showSnackbar(
                              title: 'OOPS!',
                              message:
                                  'Withdrawal amount cannot be less than 5000 coins, please try again!',
                              error: true,
                            );
                          } else if (num.parse(
                                  _withdrawlAmountController.text) >
                              _profileController.myProfile.coinsCount) {
                            showSnackbar(
                              title: 'OOPS!',
                              message:
                                  'Withdrawal amount cannot exceed your balance, please try again!',
                              error: true,
                            );
                          } else if (_paymentMethods == null) {
                            showSnackbar(
                              title: 'OOPS!',
                              message:
                                  'Please select a payment method to continue',
                              error: true,
                            );
                          } else if (_walletAddressController.text.isEmpty) {
                            showSnackbar(
                              title: 'OOPS!',
                              message:
                                  'Please enter a wallet address to continue',
                              error: true,
                            );
                          } else {
                            print('object');
                            setState(() {
                              isProcessing = true;
                            });
                            await coinHistoryController
                                .makeWithdrawal(<String, dynamic>{
                              'status': 'Pending',
                              'approved': false,
                              'duration': null,
                              'description': _walletAddressController.text,
                              'deleted': false,
                              'deletedAt': null,
                              'userId': _profileController.myProfile.uid,
                              'transactionType': 'debit',
                              'amount': _withdrawlAmountController.text,
                              'paymentMethod': _paymentMethods,
                              'date': DateTime.now().toString(),
                            });
                            setState(() {
                              isProcessing = false;
                            });
                          }
                        },
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
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
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
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  children: <Widget>[
                    FutureBuilder<void>(
                      future: coinHistoryController.initHistory(),
                      builder:
                          (BuildContext context, AsyncSnapshot<void> snapshot) {
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
                                    .coinwithdrawalHistory.isEmpty
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
                                          'No Coin Withdrawals Found',
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
                                      Container(
                                        child: ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
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
                    ),
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
      ),
    );
  }
}
