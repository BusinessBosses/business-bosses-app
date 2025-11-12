import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/features/withdrawal/presentation/deposit_screen.dart';
import 'package:business_bosses_v2/features/withdrawal/presentation/withdrawal_screen.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CoinHistoryScreen extends StatefulWidget {
  static const String routeName = '/withdrawal-screen';

  const CoinHistoryScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CoinHistoryScreenState createState() => _CoinHistoryScreenState();
}

class _CoinHistoryScreenState extends State<CoinHistoryScreen> {
  final ScrollController scrollController = ScrollController();
  final ProfileController _profileController = Get.find();
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: SvgPicture.asset('assets/svgs/help.svg'),
              )
            ],
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
                                fontWeight: FontWeight.w600, fontSize: 16),
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
        body: Column(
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
                    children: const <int, Widget>{
                      0: Text('Withdrawals'),
                      1: Text('Coin Purchases'),
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
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (int index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                children: const <Widget>[
                  WithdrawalScreen(),
                  DepositsScreen(),
                ],
              ),
            ),
          ],
        ));
  }
}
