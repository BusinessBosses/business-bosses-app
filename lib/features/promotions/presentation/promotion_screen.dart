import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/features/promotions/widgets/coinpopup.dart';
import 'package:business_bosses_v2/features/withdrawal/presentation/deposit_screen.dart';
import 'package:business_bosses_v2/features/withdrawal/presentation/withdrawal_screen.dart';
import 'package:business_bosses_v2/utils/currency_format.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class PromotionScreen extends StatefulWidget {
  static const String routeName = '/promotion-screen';

  const PromotionScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PromotionScreenState createState() => _PromotionScreenState();
}

class _PromotionScreenState extends State<PromotionScreen> {
  // ignore: unused_field
  late String _referralId;
  final ProfileController _profileController = Get.find();
  List<String> coinAmounts = <String>['100', '200', '500', '1000', '10000'];
  List<String> coinPrices = <String>['0.99', '1.99', '4.99', '9.99', '99.99'];
  List<String> coinIDs = <String>[
    '100_bb_coins',
    '200_bb_coins',
    '500_bb_coins',
    '1000_bb_coins',
    '10000_bb_coins'
  ];
  final ScrollController scrollController = ScrollController();
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _referralId = _profileController.myProfile.inviteId!;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    ProfileController profileController = Get.find();
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
            ),
            actions: <Widget>[
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => const CoinPopup(),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: SvgPicture.asset(
                    'assets/svgs/info.svg',
                    height: 22,
                  ),
                ),
              )
            ],
            centerTitle: true,
            title: Container(
                decoration: BoxDecoration(
                    color: backgroundcolorinterface,
                    borderRadius: BorderRadius.circular(50)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: <Widget>[
                      const Text(
                        'My Coin Balance',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      SvgPicture.asset('assets/svgs/coin.svg'),
                      const SizedBox(
                        width: 3,
                      ),
                      Text(
                        '${_profileController.myProfile.coinscount ?? 0}',
                        style: const TextStyle(
                          color: textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        CurrencyFormatter.coinEquivalent(_profileController.myProfile.coinscount ?? 0),
                        style: const TextStyle(
                          color: textColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ]))),
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              color: Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: CupertinoSlidingSegmentedControl<int>(
                    backgroundColor: Colors.grey[200]!,
                    padding: const EdgeInsets.all(5),
                    children: <int, Widget>{
                      0: Text('Earn',
                          style: _currentIndex == 0
                              ? const TextStyle(fontWeight: FontWeight.bold)
                              : const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey)),
                      1: Text('Withdraw',
                          style: _currentIndex == 1
                              ? const TextStyle(fontWeight: FontWeight.bold)
                              : const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey)),
                    },
                    onValueChanged: (int? value) {
                      if (value != null) {
                        setState(() {
                          _currentIndex = value;
                          _pageController.animateToPage(
                            _currentIndex,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        });
                      }
                    },
                    groupValue: _currentIndex,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                _currentIndex == 0 ? 'Earn More' : 'Withdraw Coins',
                style:
                    const TextStyle(fontWeight: FontWeight.w700, fontSize: 25),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (int index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                children: const <Widget>[
                  DepositsScreen(),
                  WithdrawalScreen(),
                ],
              ),
            ),
          ],
        ));
  }
}
