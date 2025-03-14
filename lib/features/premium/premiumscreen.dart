import 'dart:developer';

import 'package:business_bosses_v2/bbpro/widgets/button.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/subscription_confirmation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../utils/theme/theme.dart';
import '../../common/dialogs/snackbar.dart';
import '../../common/models/api_response_model.dart';
import '../profile/controller/profile_controller.dart';
import '../../services/api_service.dart';

class PremiumScreen extends StatefulWidget {
  static const String routeName = '/premiumScreen';

  const PremiumScreen({Key? key}) : super(key: key);

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  final int _currentIndex = 0;
  String paymentMethodId = 'Promonth';
  final Map<int, Widget> _segments = <int, Widget>{
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

  bool isCoin = false;
  bool loading = false;
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
    ApiService.post(path: 'subscription', body: <String, dynamic>{
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
      setState(() {});
    } catch (e) {
      setState(() {});
      log('Here ->>>>>> $e');

      showSnackbar(
          title: 'OOPS!',
          message: 'An error occurred, please try again!',
          error: true);
    }
  }

  ///intialize the payment
  Future<void> makePayment() async {
    setState(() {});
    final ApiResponseModel res =
        await ApiService.post(path: 'subscription', body: <String, dynamic>{
      'price': plans[_currentIndex]['price'],
      'plan': plans[_currentIndex]['plan'],
    });

    if (res.success) {
      if (await canLaunchUrlString(res.data)) {
        await launchUrlString(res.data, mode: LaunchMode.externalApplication);
      }
    } else {
      showSnackbar(
          title: 'OOPS!',
          message: 'An error occurred, please try again!',
          error: true);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Purchases.logIn(profileController.myProfile.uid.toString());
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              SvgPicture.asset(
                'assets/svgs/premiumback.svg',
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fitWidth,
              ),
              Column(
                children: <Widget>[
                  const Column(
                    children: <Widget>[
                      SizedBox(
                        height: 25,
                      ),
                      Text('Upgrade to a Pro Boss Experience',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text.rich(
                          textAlign: TextAlign.center,
                          TextSpan(
                            children: <InlineSpan>[
                              TextSpan(
                                text:
                                    'Everything You Need to boost and grow your business 10X faster, ',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              TextSpan(
                                text: 'all in one place',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: primaryColorLT),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Padding(
                  //   padding:
                  //       const EdgeInsets.only(left: 50.0, right: 50, top: 50),
                  //   child: RichText(
                  //     textAlign: TextAlign.center,
                  //     text: TextSpan(
                  //       children: <InlineSpan>[
                  //         const TextSpan(
                  //           text: 'Upgrade to a pro boss experience at only, ',
                  //           style: TextStyle(
                  //               color: Colors.black,
                  //               fontSize: 15,
                  //               fontWeight: FontWeight.w500),
                  //         ),
                  //         TextSpan(
                  //           text: _currentIndex == 0
                  //               ? '\$9.99/month'
                  //               : '\$99.99/year',
                  //           style: const TextStyle(
                  //               color: primaryColorLT,
                  //               fontSize: 16,
                  //               fontWeight: FontWeight.bold),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 20.0),
                  //   child: Align(
                  //     alignment: Alignment.topCenter,
                  //     child: CupertinoSlidingSegmentedControl<int>(
                  //       padding: const EdgeInsets.all(5),
                  //       children: _segments,
                  //       onValueChanged: (int? value) {
                  //         setState(() {
                  //           _currentIndex = value!;
                  //           paymentMethodId =
                  //               _currentIndex == 0 ? 'Promonth' : 'Proyear';
                  //         });
                  //       },
                  //       groupValue: _currentIndex,
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20),
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.grey.withOpacity(0.12),
                                    width: 2,
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const Text(
                                      'Whats included:',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 20),
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
                                              fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: <Widget>[
                                        SvgPicture.asset('assets/svgs/coin.svg',
                                            height: 30),
                                        const SizedBox(width: 10),
                                        const Text(
                                          'Earn 100 coins per month',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
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
                                              fontWeight: FontWeight.w600),
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
                                              fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                    Row(
                                      children: <Widget>[
                                        SvgPicture.asset(
                                            'assets/svgs/addtolist.svg',
                                            height: 25),
                                        const SizedBox(width: 15),
                                        const Text(
                                          'Get listing featured on marketplace',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                    Row(
                                      children: <Widget>[
                                        SvgPicture.asset(
                                            'assets/svgs/handshake.svg',
                                            height: 16),
                                        const SizedBox(width: 18),
                                        const Text(
                                          'Access to Exclusive Partner Offers',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                    Row(
                                      children: <Widget>[
                                        SvgPicture.asset(
                                            'assets/svgs/campaign.svg',
                                            height: 20),
                                        const SizedBox(width: 18),
                                        const Text(
                                          'Grow business with marketing campaigns',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 7),
                        SizedBox(
                          width: double.infinity,
                          child: ProCustomButton(
                              color: primaryColorLT,
                              text: 'Start your \$1/Month Trial',
                              onPressed: () async {
                                // setState(() {
                                //   loading = true;
                                // });
                                showModalBottomSheet<void>(
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(25.0),
                                    ),
                                  ),
                                  builder: (BuildContext context) {
                                    return StatefulBuilder(
                                      // Wrap the entire bottom sheet content with StatefulBuilder
                                      builder: (BuildContext context,
                                          StateSetter setState) {
                                        return Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 20),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  const Text(
                                                    'Choose your plan',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(
                                                      Icons.close,
                                                      color: Colors.black54,
                                                    ),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    paymentMethodId =
                                                        'Promonth';
                                                  });
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: paymentMethodId ==
                                                              'Promonth'
                                                          ? primaryColorLT
                                                          : Colors.transparent,
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  child: RadioListTile<String>(
                                                    contentPadding:
                                                        const EdgeInsets.only(
                                                            right: 10),
                                                    title: const Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        Text(
                                                          'Pro Monthly',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 16),
                                                        ),
                                                        Text('\$14.99/month',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w200,
                                                                fontSize: 16)),
                                                      ],
                                                    ),
                                                    value: 'Promonth',
                                                    groupValue: paymentMethodId,
                                                    onChanged: (String? value) {
                                                      setState(() {
                                                        paymentMethodId =
                                                            value!;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: paymentMethodId ==
                                                            'Proyear'
                                                        ? primaryColorLT
                                                        : Colors.transparent,
                                                    width: 2,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: RadioListTile<String>(
                                                  contentPadding:
                                                      const EdgeInsets.only(
                                                          right: 10),
                                                  title: const Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Text(
                                                        'Pro Yearly',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 16),
                                                      ),
                                                      Text(
                                                          '\$9.99/month ( 33% off )',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w200,
                                                              fontSize: 16)),
                                                    ],
                                                  ),
                                                  value: 'Proyear',
                                                  groupValue: paymentMethodId,
                                                  onChanged: (String? value) {
                                                    setState(() {
                                                      paymentMethodId = value!;
                                                    });
                                                  },
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              SizedBox(
                                                  width: double.infinity,
                                                  child: ProCustomButton(
                                                    padding: 0,
                                                    color: primaryColorLT,
                                                    text:
                                                        'Start your \$1/month trial',
                                                    loading: loading,
                                                    onPressed: () async {
                                                      setState(() {
                                                        loading = true;
                                                      });
                                                      if (paymentMethodId ==
                                                          'Proyear') {
                                                        try {
                                                          final List<
                                                                  StoreProduct>
                                                              product =
                                                              await Purchases
                                                                  .getProducts(<String>[
                                                            'xyz.codexia.businessbosses.proyear'
                                                          ]);
                                                          final CustomerInfo
                                                              customerInfo =
                                                              await Purchases
                                                                  .purchaseStoreProduct(
                                                                      product[
                                                                          0]);
                                                          if (customerInfo
                                                                  .entitlements
                                                                  .all[
                                                                      'xyz.codexia.businessbosses.proyear']
                                                                  ?.isActive ??
                                                              false) {
                                                            // Grant access to premium features
                                                            print(
                                                                'User subscribed!');
                                                          }
                                                        } catch (e) {
                                                          // Handle error
                                                          print(
                                                              'Error purchasing product: $e');
                                                        } finally {
                                                          setState(() {
                                                            loading = false;
                                                          });
                                                        }
                                                      } else {
                                                        try {
                                                          final List<
                                                                  StoreProduct>
                                                              product =
                                                              await Purchases
                                                                  .getProducts(<String>[
                                                            'xyz.codexia.businessbosses.promonth'
                                                          ]);
                                                          final CustomerInfo
                                                              customerInfo =
                                                              await Purchases
                                                                  .purchaseStoreProduct(
                                                                      product[
                                                                          0]);
                                                          if (customerInfo
                                                                  .entitlements
                                                                  .all[
                                                                      'xyz.codexia.businessbosses.promonth']
                                                                  ?.isActive ??
                                                              false) {
                                                            // Grant access to premium features
                                                            print(
                                                                'User subscribed!');
                                                          }
                                                        } catch (e) {
                                                          // Handle error
                                                          print(
                                                              'Error purchasing product: $e');
                                                        } finally {
                                                          setState(() {
                                                            loading = false;
                                                          });
                                                        }
                                                      }
                                                    },
                                                  )),
                                              const SizedBox(
                                                height: 50,
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              }
                              // },
                              ),
                        ),
                        const SizedBox(height: 8),
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
    );
  }
}
