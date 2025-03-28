import 'dart:developer';
import 'dart:io';

import 'package:business_bosses_v2/bbpro/widgets/button.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/subscription_confirmation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../utils/theme/theme.dart';
import '../../common/dialogs/snackbar.dart';
import '../profile/controller/profile_controller.dart';

class PremiumScreen extends StatefulWidget {
  static const String routeName = '/premiumScreen';

  const PremiumScreen({Key? key}) : super(key: key);

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  final ProfileController profileController = Get.find();

  // Default plan selection
  String paymentMethodId = 'Promonth';
  bool loading = false;

  // You might need to ensure these match your actual pricing/trial setup
  final String monthlyPrice = '\$14.99/month';
  final String yearlyPrice = '\$9.99/month (billed annually)';

  @override
  Widget build(BuildContext context) {
    // Make sure you’ve set up RevenueCat user ID if needed
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
                      SizedBox(height: 25),
                      Text(
                        'Upgrade to a Pro Boss Experience',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: 'all in one place',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: primaryColorLT,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20),
                    child: Column(
                      children: <Widget>[
                        // Premium Feature List
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                'What’s included:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: <Widget>[
                                  SvgPicture.asset(
                                    'assets/svgs/goldcheckmark.svg',
                                    height: 25,
                                    colorFilter: const ColorFilter.mode(
                                      primaryColorLT,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  const Text(
                                    'Premium Badge',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: <Widget>[
                                  SvgPicture.asset(
                                    'assets/svgs/coin.svg',
                                    height: 30,
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    'Earn 100 coins per month',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: <Widget>[
                                  SvgPicture.asset(
                                    'assets/svgs/rocket.svg',
                                    height: 25,
                                  ),
                                  const SizedBox(width: 15),
                                  const Text(
                                    'Boost post FREE with coins',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 15),
                              Row(
                                children: <Widget>[
                                  SvgPicture.asset(
                                    'assets/svgs/moreconnections.svg',
                                    height: 20,
                                  ),
                                  const SizedBox(width: 15),
                                  const Text(
                                    'More connections & referrals',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 15),
                              Row(
                                children: <Widget>[
                                  SvgPicture.asset(
                                    'assets/svgs/addtolist.svg',
                                    height: 25,
                                  ),
                                  const SizedBox(width: 15),
                                  const Text(
                                    'Get listing featured on marketplace',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 15),
                              Row(
                                children: <Widget>[
                                  SvgPicture.asset(
                                    'assets/svgs/handshake.svg',
                                    height: 16,
                                  ),
                                  const SizedBox(width: 18),
                                  const Text(
                                    'Access to Exclusive Partner Offers',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 15),
                              Row(
                                children: <Widget>[
                                  SvgPicture.asset(
                                    'assets/svgs/campaign.svg',
                                    height: 20,
                                  ),
                                  const SizedBox(width: 18),
                                  const Text(
                                    'Grow business with marketing campaigns',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        // Primary button to open subscription options
                        SizedBox(
                          width: double.infinity,
                          child: ProCustomButton(
                            color: primaryColorLT,
                            text: 'Start your free/intro trial',
                            onPressed: () {
                              showModalBottomSheet<void>(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(25.0),
                                  ),
                                ),
                                builder: (BuildContext context) {
                                  return StatefulBuilder(
                                    builder: (BuildContext context,
                                        StateSetter setState) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 20,
                                        ),
                                        child: SingleChildScrollView(
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
                                              const SizedBox(height: 20),
                                              // MONTHLY
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
                                                    title: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        const Text(
                                                          'Pro Monthly',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                        Text(
                                                          monthlyPrice,
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w200,
                                                            fontSize: 16,
                                                          ),
                                                        ),
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
                                              const SizedBox(height: 10),
                                              // YEARLY
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    paymentMethodId = 'Proyear';
                                                  });
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: paymentMethodId ==
                                                              'Proyear'
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
                                                    title: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        const Text(
                                                          'Pro Yearly',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                        Text(
                                                          yearlyPrice,
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w200,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    value: 'Proyear',
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
                                              const SizedBox(height: 20),
                                              // Additional compliance text
                                              Text(
                                                Platform.isIOS
                                                    ? 'Your subscription automatically renews unless auto-renew is turned off at least 24 hours before the end of the current period. Your Apple ID account will be charged at confirmation of purchase. You can manage or cancel your subscription in your App Store account settings. The subscription is optional and you can continue using the free version of the app without subscribing.'
                                                    : 'Your subscription automatically renews unless canceled at least 24 hours before the end of the current period. Payment will be charged to your Google Play account at confirmation of purchase. You can manage or cancel your subscription anytime in your Play Store account settings. The subscription is optional and you can continue using the free version of the app without subscribing.',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              // Confirm Purchase Button
                                              SizedBox(
                                                width: double.infinity,
                                                child: ProCustomButton(
                                                  padding: 0,
                                                  color: primaryColorLT,
                                                  text:
                                                      'Continue with Selected Plan',
                                                  loading: loading,
                                                  onPressed: () async {
                                                    setState(() {
                                                      loading = true;
                                                    });

                                                    // Example: purchase logic
                                                    // Make sure these product IDs match
                                                    // what you set in RevenueCat & Play Console
                                                    final String productId =
                                                        paymentMethodId ==
                                                                'Proyear'
                                                            ? 'xyz.codexia.businessbosses.proyear'
                                                            : 'xyz.codexia.businessbosses.promonth';

                                                    try {
                                                      final List<StoreProduct>
                                                          products =
                                                          await Purchases
                                                              .getProducts(
                                                        <String>[productId],
                                                      );
                                                      final CustomerInfo
                                                          customerInfo =
                                                          await Purchases
                                                              .purchaseStoreProduct(
                                                        products[0],
                                                      );

                                                      final bool isActive =
                                                          customerInfo
                                                                  .entitlements
                                                                  .all[
                                                                      productId]
                                                                  ?.isActive ??
                                                              false;

                                                      if (isActive) {
                                                        // Grant access to premium features
                                                        log('User subscribed to $productId!');
                                                        // Example: Navigate to a confirmation screen
                                                        if (mounted) {
                                                          Navigator.of(context)
                                                              .pushReplacement(
                                                            MaterialPageRoute(
                                                              builder: (_) =>
                                                                  const SubscriptionConfirmation(),
                                                            ),
                                                          );
                                                        }
                                                      }
                                                    } catch (e) {
                                                      // Handle purchase errors
                                                      log('Error purchasing product: $e');
                                                      showSnackbar(
                                                        title: 'OOPS!',
                                                        message:
                                                            'An error occurred, please try again!',
                                                        error: true,
                                                      );
                                                    } finally {
                                                      if (mounted) {
                                                        setState(() {
                                                          loading = false;
                                                        });
                                                      }
                                                    }
                                                  },
                                                ),
                                              ),
                                              const SizedBox(height: 40),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Extra spacing
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
