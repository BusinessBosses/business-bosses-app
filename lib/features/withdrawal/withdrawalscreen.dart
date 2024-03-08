import 'package:business_bosses_v2/common/widgets/buttons/custom_button.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
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

class WithdrawalScreen extends StatefulWidget {
  static const String routeName = '/withdrawal-screen';

  const WithdrawalScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _WithdrawalScreenState createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  final ScrollController scrollController = ScrollController();
  late String _referralId;
  final ProfileController _profileController = Get.find();
  String? _paymentmethods;

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
        appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
            ),
            centerTitle: true,
            title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 5, bottom: 5),
                      decoration: BoxDecoration(
                        color: backgroundcolorinterface,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            'My Coin Balance',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          SvgPicture.asset(
                            'assets/svgs/coin.svg',
                            height: 30,
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Text(
                            '${_profileController.myProfile.coinscount ?? 0}',
                            style: const TextStyle(
                              color: textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )),
                  const SizedBox(
                    width: 30,
                  ),
                ])),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Withdraw',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SvgPicture.asset('assets/svgs/help.svg')
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Text('Withdrawable Balance'),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 55,
                        decoration: BoxDecoration(
                          color: backgroundcolorinterface,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            children: [
                              Text('5720 Coins'),
                              Text(
                                '(\$20.39)',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Payment Method'),
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
                            Row(
                              children: <Widget>[
                                SvgPicture.asset('assets/svgs/coin.svg'),
                                const SizedBox(width: 20),
                              ],
                            ),
                            Expanded(
                              child: DropdownButton<String>(
                                value: _paymentmethods,
                                borderRadius: BorderRadius.circular(radius),
                                isExpanded: true,
                                icon:
                                    const Icon(Icons.keyboard_arrow_down_sharp),
                                iconSize: 24,
                                elevation: 16,
                                underline: Container(
                                  height: 0,
                                  color: Colors.white,
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _paymentmethods = newValue ?? 'Paypal';
                                  });
                                },
                                items: <String>[
                                  'Paypal',
                                  'Bank',
                                  'Mobile Money'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Destination Address'),
                      TextFormField(
                        onChanged: (String val) {
                          setState(() {});
                        },
                        decoration: inputDecoration.copyWith(
                          hintText: 'Enter your wallet address',
                          hintStyle: const TextStyle(
                            color: iconColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          filled: true,
                          fillColor: const Color(0xffF4F4F4),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomButton(
                        margin: const EdgeInsets.all(2.0),
                        label: 'Withdraw',
                        onPressed: () async {},
                        buttonType: ButtonType.elevated,
                        child: Container(),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Withdrawal History',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      
                    ],
                  ),
                ),
              )
            ];
          },
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal:15.0),
            child: Container(
              child: Expanded(
                child: Column(
                  children: [
                    WithdrawalHeaderItem() ,
                    Container(
                      child: Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: 10,
                          itemBuilder: (BuildContext context, int i) {
                            return  WithdrawalItem();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
