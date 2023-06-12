import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/theme/theme.dart';
import '../common/widgets/buttons/custom_button.dart';
import '../features/posts/widgets/my_container.dart';

class PremiumScreen extends StatefulWidget {
  static const routeName = '/premiumScreen';

  PremiumScreen({Key? key}) : super(key: key);

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  int _currentIndex = 0;

  final Map<int, Widget> _segments = {
    0: const Padding(
      padding: EdgeInsets.all(8),
      child: Text(
        'Monthly',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    1: const Padding(
      padding: EdgeInsets.all(8),
      child: Text('Annually', style: TextStyle(fontWeight: FontWeight.bold)),
    )
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
          ),
          centerTitle: true,
          title: const Text(
            'Become a premium member',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 20,
              color:
                  backgroundcolorinterface, // Replace with your desired color
            ),
            Expanded(
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  SvgPicture.asset(
                    'assets/svgs/premiumback.svg',
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fitWidth,
                  ),
                  Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 50.0, right: 50),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text:
                                    'Upgrade to a premium boss experience at only, ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                              TextSpan(
                                text: _currentIndex == 0
                                    ? '\$4.99/month'
                                    : '\$49.99/year',
                                style: const TextStyle(
                                    color: primaryColorLT,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: CupertinoSlidingSegmentedControl<int>(
                            padding: const EdgeInsets.all(5),
                            children: _segments,
                            onValueChanged: (value) {
                              setState(() {
                                _currentIndex = value!;
                              });
                            },
                            groupValue: _currentIndex,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20),
                        child: Column(
                          children: [
                            Container(
                              child: Column(children: [
                                Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.09),
                                            blurRadius: 50.0,
                                            spreadRadius: 0.0,
                                          ),
                                        ],
                                      ),
                                      child: SvgPicture.asset(
                                        'assets/svgs/premiumdescback.svg',
                                        width:
                                            MediaQuery.of(context).size.width,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 60.0, left: 30),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Whats included:',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                'assets/svgs/goldcheckmark.svg',
                                                height: 25,
                                              ),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              const Text(
                                                'Premium Badge',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                  'assets/svgs/coin.svg',
                                                  height: 30),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              const Text(
                                                'Get 500 coins per month',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                  'assets/svgs/rocket.svg',
                                                  height: 25),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              const Text(
                                                'Boost post FREE with coins',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                'assets/svgs/moreconnections.svg',
                                                height: 20,
                                              ),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              const Text(
                                                'More connections & referrals',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                'assets/svgs/rankingicon.svg',
                                                height: 23,
                                              ),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              const Text(
                                                'Rank higher on posts & listing',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ]),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomButton(
                              margin: const EdgeInsets.all(2.0),
                              label: _currentIndex == 0
                                  ? 'Subscribe at \$4.99'
                                  : 'Subscribe at \$49.99',
                              onPressed: () async {
                                setState(() {
                                  // _autoValidateMode = AutovalidateMode.always;
                                });
                                setState(() {
                                  // _isProcessing = true;
                                });
                              },
                              buttonType: ButtonType.elevated,
                              child: Container(),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            const Text(
                              'By Subscribing you accept the Terms of Service',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
