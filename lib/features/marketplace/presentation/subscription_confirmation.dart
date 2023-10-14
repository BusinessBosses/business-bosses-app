import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../common/widgets/buttons/my_button.dart';
import '../../../common/widgets/text_widget.dart';
import '../../../navigation/routes.dart';
import '../../../utils/theme/theme.dart';

// ignore: public_member_api_docs
class SubscriptionConfirmation extends StatelessWidget {
  // ignore: public_member_api_docs
  const SubscriptionConfirmation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFFFFFF),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
          ),
          centerTitle: true,
          title: const TextWidget(
              text: 'Payment Confirmation', color: Color(0xFF333333), size: 20),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  left: 32.5,
                  top: 40,
                ),
                child: SvgPicture.asset(
                  'assets/svgs/dottedline.svg',
                  height: 370,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 21),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const CircleAvatar(
                          radius: 14,
                          backgroundColor: Color(0xFFF01C29),
                          child: CircleAvatar(
                            radius: 6,
                            backgroundColor: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            alignment: Alignment.center,
                            width: 223,
                            height: 131,
                            decoration: BoxDecoration(
                                color: backgroundcolorinterface,
                                borderRadius: BorderRadius.circular(9.3)),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                TextWidget(
                                  text:
                                      'Congratulations on becoming a valued subscriber! Welcome to our premium membership program. 🎉',
                                  size: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  centralize: true,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const CircleAvatar(
                          radius: 14,
                          backgroundColor: Color(0xFFF01C29),
                          child: CircleAvatar(
                            radius: 6,
                            backgroundColor: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              const Row(
                                children: <Widget>[
                                  TextWidget(
                                    text: 'Payment Confirmed',
                                    size: 18,
                                    fontWeight: FontWeight.w700,
                                  )
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Stack(
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.03),
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
                                          children: <Widget>[
                                            const Text(
                                              'Whats included:',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 30),
                                            Row(
                                              children: <Widget>[
                                                SvgPicture.asset(
                                                  'assets/svgs/goldcheckmark.svg',
                                                  height: 25,
                                                  color: primaryColorLT,
                                                ),
                                                const SizedBox(width: 15),
                                                const Text(
                                                  'Premium Badge',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                )
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: <Widget>[
                                                SvgPicture.asset(
                                                    'assets/svgs/coin.svg',
                                                    height: 30),
                                                const SizedBox(width: 10),
                                                const Text(
                                                  'Get 500 coins per month',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                )
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: <Widget>[
                                                SvgPicture.asset(
                                                    'assets/svgs/rocket.svg',
                                                    height: 25),
                                                const SizedBox(width: 15),
                                                const Text(
                                                  'Boost post FREE with coins',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                )
                                              ],
                                            ),
                                            const SizedBox(height: 15),
                                            Row(
                                              children: <Widget>[
                                                SvgPicture.asset(
                                                    'assets/svgs/moreconnections.svg',
                                                    height: 20),
                                                const SizedBox(width: 15),
                                                const Text(
                                                  'More connections & referrals',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                )
                                              ],
                                            ),
                                            const SizedBox(height: 15),
                                            Row(
                                              children: <Widget>[
                                                SvgPicture.asset(
                                                    'assets/svgs/rankingicon.svg',
                                                    height: 23),
                                                const SizedBox(width: 15),
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
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MyButton(
                      labelStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                      label: 'Ok',
                      onPressed: () {
                        Get.offAndToNamed(Routes.home);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
