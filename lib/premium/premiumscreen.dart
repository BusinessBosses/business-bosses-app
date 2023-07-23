import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../utils/theme/theme.dart';
import '../action/action.dart';
import '../common/models/api_response_model.dart';
import '../common/widgets/buttons/custom_button.dart';
import '../features/marketplace/presentation/subscription_confirmation.dart';
import '../features/profile/controller/profile_controller.dart';
import '../services/api_service.dart';

class PremiumScreen extends StatefulWidget {
  static const String routeName = '/premiumScreen';

  const PremiumScreen({Key? key}) : super(key: key);

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  int _currentIndex = 0;
  String paymentMethodId = '';
  final ProfileController _profileController = Get.find();
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

  bool _isProcessing = false;
  bool isCoin = false;
  bool isSubscribed = false;
  late Map<String, dynamic>? paymantIntent;
  final ProfileController profileController = Get.find();

  late String duration;
  List<Map<String, dynamic>> plans = <Map<String, dynamic>>[
    <String, dynamic>{
      'price': dotenv.env['TEST_MONTHLY_PRICE'],
      'plan': 'monthly',
    },
    <String, dynamic>{
      'price': dotenv.env['TEST_YEARLY_PRICE'],
      'plan': 'annually',
    },
  ];

  /// send the data to the backend
  Future<void> addSubscription() async {
    ApiService.post(path: 'subscription', body: {
      'price': plans[_currentIndex]['price'],
      'plan': plans[_currentIndex]['plan'],
    });
  }

  void displaySheet() async {
    try {
      await addSubscription();
      // Navigate to SubscriptionConfirmation page
      Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => const SubscriptionConfirmation(),
      ));
      setState(() {
        _isProcessing = false;
      });
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      log('Here ->>>>>> $e');

      showSnackBar(context, message: 'Opps!! Something went wrong. Try again');
    }
  }

  ///intialize the payment
  Future<void> makePayment() async {
    setState(() {
      _isProcessing = true;
    });
    final ApiResponseModel res =
        await ApiService.post(path: 'subscription', body: {
      'price': plans[_currentIndex]['price'],
      'plan': plans[_currentIndex]['plan'],
    });

    if (res.success) {
      if (await canLaunchUrlString(res.data)) {
        await launchUrlString(res.data, mode: LaunchMode.externalApplication);
      }
    } else {
      showSnackBar(context, message: res.message);
    }
    setState(() {
      _isProcessing = false;
    });
  }

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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 20,
              color: backgroundcolorinterface,
            ),
            SizedBox(
              // height: MediaQuery.of(context).size.height -
              //     AppBar().preferredSize.height -
              //     20, // Adjust the height as needed
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
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 50.0, right: 50, top: 50),
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
                            onValueChanged: (int? value) {
                              setState(() {
                                _currentIndex = value!;
                              });
                            },
                            groupValue: _currentIndex,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20),
                        child: Column(
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.09),
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
                                            const SizedBox(height: 30),
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/svgs/goldcheckmark.svg',
                                                  height: 25,
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
                                              children: [
                                                SvgPicture.asset(
                                                    'assets/svgs/coin.svg',
                                                    height: 30),
                                                const SizedBox(width: 15),
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
                                              children: [
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
                                              children: [
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
                                              children: [
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
                            ),
                            const SizedBox(height: 7),
                            CustomButton(
                              isProcessing: _isProcessing,
                              margin: const EdgeInsets.all(2.0),
                              label: _currentIndex == 0
                                  ? 'Subscribe at \$4.99'
                                  : 'Subscribe at \$49.99',
                              onPressed: () async {
                                plans[_currentIndex];
                                await makePayment();
                              },
                              buttonType: ButtonType.elevated,
                              child: Container(),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'By Subscribing you accept the Terms of Service',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                            const SizedBox(
                              height: 50,
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
        ),
      ),
    );
  }
}
