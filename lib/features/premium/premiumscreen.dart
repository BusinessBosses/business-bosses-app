import 'dart:developer';
import 'dart:io';

import 'package:business_bosses_v2/bbpro/widgets/button.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/subscription_confirmation.dart';
import 'package:business_bosses_v2/utils/constants/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../utils/theme/theme.dart';
import '../../common/dialogs/snackbar.dart';
import '../../common/models/api_response_model.dart';
import '../profile/controller/profile_controller.dart';
import '../../services/api_service.dart';

class PremiumScreen extends StatefulWidget {
  static const String routeName = '/premiumScreen';

  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  final int _currentIndex = 0;
  String paymentMethodId = 'Promonth';

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

  Future<void> restorePurchases() async {
    try {
      final CustomerInfo customerInfo = await Purchases.restorePurchases();

      if (customerInfo.entitlements.active.isNotEmpty) {
        // Update local state
        profileController.updateProfile(<String, dynamic>{
          ...profileController.myProfile.toMap(),
          'isSubscribed': true,
        });

        showSnackbar(
          title: 'Purchases Restored',
          message: 'Your subscription has been restored.',
          error: false,
        );
      } else {
        showSnackbar(
          title: 'No Active Subscription',
          message: 'No active subscription found.',
          error: true,
        );
      }
    } catch (e) {
      log('Restore purchases failed: $e');
      showSnackbar(
        title: 'Restore Failed',
        message: 'Failed to restore purchases. Please try again.',
        error: true,
      );
    }
  }

  /// Debug full RevenueCat configuration
  // Update your debugFullConfiguration method
  Future<void> debugFullConfiguration() async {
    try {
      log('=== DEBUGGING REVENUECAT CONFIGURATION ===');

      final CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      log('RevenueCat User ID: ${customerInfo.originalAppUserId}');
      log('Active entitlements: ${customerInfo.entitlements.active.keys.toList()}');

      // Check offerings
      final Offerings offerings = await Purchases.getOfferings();
      log('Available offerings: ${offerings.all.keys.toList()}');

      if (offerings.current != null) {
        log('Current offering: ${offerings.current!.identifier}');

        // Log all available packages
        for (Package package in offerings.current!.availablePackages) {
          log('Package: ${package.identifier} - Product: ${package.storeProduct.identifier}');
          log('  - Price: ${package.storeProduct.priceString}');
          log('  - Title: ${package.storeProduct.title}');

          // Check if this is a subscription package
          if (package.identifier == '\$rc_monthly' ||
              package.identifier == '\$rc_annual') {
            log('  - Type: Subscription');
          }
        }

        // Check standard package identifiers
        log('Monthly package available: ${offerings.current!.monthly != null}');
        log('Annual package available: ${offerings.current!.annual != null}');
      }

      log('=== END DEBUG ===');
    } catch (e, stackTrace) {
      log('Debug failed: $e');
      log('Stack trace: $stackTrace');
    }
  }

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
      // ignore: use_build_context_synchronously, always_specify_types
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
        error: true,
      );
    }
  }

  /// Initialize the payment
  Future<bool> makePayment() async {
    final ApiResponseModel res =
        await ApiService.post(path: 'apple-sub', body: <String, dynamic>{
      'price': plans[_currentIndex]['price'],
      'plan': plans[_currentIndex]['plan'],
    });

    if (res.success) {
      return true;
    } else {
      showSnackbar(
        title: 'OOPS!',
        message: 'An error occurred, please try again!',
        error: true,
      );
      return false;
    }
  }

  /// Main validation and purchase method
  Future<void> validateAndPurchase() async {
    setState(() {
      loading = true;
    });

    try {
      // First validate backend
      final bool backendResponse = await makePayment();
      if (!backendResponse) {
        showSnackbar(
          title: 'Backend Error',
          message: 'Failed to initialize subscription on server.',
          error: true,
        );
        return;
      }

      // Try to get offerings first
      final Offerings offerings = await Purchases.getOfferings();

      if (offerings.current != null) {
        // Use offerings approach
        await purchaseUsingOfferings(offerings);
      } else {
        // Fallback to direct product purchase
        await purchaseUsingProducts();
      }
    } catch (e, stackTrace) {
      log('Purchase validation error: $e');
      log('Stack trace: $stackTrace');

      showSnackbar(
        title: 'Purchase Error',
        message: 'An error occurred during purchase. Please try again.',
        error: true,
      );
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  // Replace your purchaseUsingOfferings method with this:
  Future<void> purchaseUsingOfferings(Offerings offerings) async {
    try {
      Package? package;

      // Use RevenueCat's standard package identifiers
      if (offerings.current != null) {
        if (paymentMethodId == 'Proyear') {
          // Use RevenueCat's annual package identifier
          package = offerings.current!.annual ??
              offerings.current!.getPackage('\$rc_annual');
        } else {
          // Use RevenueCat's monthly package identifier
          package = offerings.current!.monthly ??
              offerings.current!.getPackage('\$rc_monthly');
        }
      }

      if (package == null) {
        log('Subscription package not found in offerings');
        // Fall back to direct product purchase
        await purchaseUsingProducts();
        return;
      }

      log('Purchasing subscription package: ${package.identifier} - ${package.storeProduct.identifier}');
      final PurchaseResult purchaseResult =
          await Purchases.purchasePackage(package);
      await handleSuccessfulPurchase(purchaseResult.customerInfo);
    } catch (e) {
      log('Offerings purchase failed: $e');
      // Fall back to direct product purchase
      await purchaseUsingProducts();
    }
  }

  // Replace your purchaseUsingProducts method with this:
  Future<void> purchaseUsingProducts() async {
    try {
      // Use the correct product IDs from your debug log
      final String productId = paymentMethodId == 'Proyear'
          ? 'xyz.codexia.businessbosses.proyear'
          : 'xyz.codexia.businessbosses.promonth';

      log('Attempting direct purchase of: $productId');

      final List<StoreProduct> products =
          await Purchases.getProducts(<String>[productId]);

      if (products.isEmpty) {
        showSnackbar(
          title: 'Product Not Available',
          message: 'Subscription product is not available at the moment.',
          error: true,
        );
        return;
      }

      log('Found product: ${products[0].identifier} - ${products[0].title}');
      final PurchaseResult purchaseResult =
          await Purchases.purchaseStoreProduct(products[0]);
      await handleSuccessfulPurchase(purchaseResult.customerInfo);
    } catch (e) {
      log('Direct purchase failed: $e');
      showSnackbar(
        title: 'Purchase Failed',
        message: 'Failed to complete purchase. Please try again.',
        error: true,
      );
    }
  }

  Future<void> checkExistingSubscriptions() async {
    try {
      final CustomerInfo customerInfo = await Purchases.getCustomerInfo();

      if (customerInfo.entitlements.active.isNotEmpty) {
        // User already has an active subscription
        showSnackbar(
          title: 'Active Subscription',
          message: 'You already have an active subscription.',
          error: false,
        );

        // Update local state
        profileController.updateProfile(<String, dynamic>{
          ...profileController.myProfile.toMap(),
          'isSubscribed': true,
        });

        return;
      }
    } catch (e) {
      log('Error checking existing subscriptions: $e');
    }
  }

  Future<void> tryAlternativeProductIds() async {
    // Sometimes the product ID format might be different
    final List<String> alternativeIds = <String>[
      // Try without the full bundle path
      'promonth',
      'proyear',
      // Try with different bundle format
      'com.businessbosses.promonth',
      'com.businessbosses.proyear',
      'businessbosses.promonth',
      'businessbosses.proyear',
      // Try with underscores
      'pro_monthly',
      'pro_yearly',
      // Add any other possible formats you might have used
    ];

    final String selectedType =
        paymentMethodId == 'Proyear' ? 'yearly' : 'monthly';

    for (String altId in alternativeIds) {
      // Only try IDs that match the selected subscription type
      if ((selectedType == 'yearly' &&
              (altId.contains('year') || altId.contains('annual'))) ||
          (selectedType == 'monthly' && (altId.contains('month')))) {
        try {
          log('Trying alternative product ID: $altId');
          final List<StoreProduct> products =
              await Purchases.getProducts(<String>[altId]);

          if (products.isNotEmpty) {
            log('Found product with alternative ID: $altId');
            final PurchaseResult purchaseResult =
                await Purchases.purchaseStoreProduct(products[0]);
            await handleSuccessfulPurchase(purchaseResult.customerInfo);
            return;
          }
        } catch (e) {
          log('Alternative ID $altId failed: $e');
          continue;
        }
      }
    }

    // If we get here, no products were found
    showSnackbar(
      title: 'Products Not Available',
      message:
          'Subscription products are not configured. Please check App Store Connect and RevenueCat configuration.',
      error: true,
    );
  }

  Future<void> handleSuccessfulPurchase(CustomerInfo customerInfo) async {
    // Check if any subscription is active
    if (customerInfo.entitlements.active.isNotEmpty) {
      log('Subscription activated successfully');
      log('Active entitlements: ${customerInfo.entitlements.active.keys.toList()}');

      profileController.updateProfile(<String, dynamic>{
        ...profileController.myProfile.toMap(),
        'isSubscribed': true,
      });

      Navigator.pop(context);
      Get.off(() => const SubscriptionConfirmation());
    } else {
      // ✅ Treat as pending success instead of error
      showSnackbar(
        title: 'Purchase Completed',
        message:
            'Your subscription is being activated. This may take a few minutes.',
        error: false,
      );

      // Optionally set local state to "subscribed" immediately
      profileController.updateProfile(<String, dynamic>{
        ...profileController.myProfile.toMap(),
        'isSubscribed': true,
      });

      Navigator.pop(context);
      Get.off(() => const SubscriptionConfirmation());
    }
  }

  @override
  void initState() {
    super.initState();

    // Log in to RevenueCat with current user ID
    _loginToRevenueCat();
    checkExistingSubscriptions();
  }

  // Function to log in to RevenueCat with current user
  // Update your _loginToRevenueCat method:
  // Update your _loginToRevenueCat method:
  Future<void> _loginToRevenueCat() async {
    try {
      final String userId = profileController.myProfile.uid.toString();
      final CustomerInfo currentInfo = await Purchases.getCustomerInfo();

      // Check if we're already logged in with the right user
      if (currentInfo.originalAppUserId == userId) {
        log('Already logged in with correct user ID: $userId');
        await debugFullConfiguration();
        return;
      }

      // Check if we have an anonymous ID that needs to be converted
      if (currentInfo.originalAppUserId.contains('RCAnonymousID')) {
        log('Converting anonymous user to logged-in user: $userId');
        await Purchases.logIn(userId);

        // Wait a moment for the login to complete
        await Future.delayed(const Duration(milliseconds: 500));

        // Verify the login was successful
        final CustomerInfo newInfo = await Purchases.getCustomerInfo();
        log('Login successful. New User ID: ${newInfo.originalAppUserId}');

        if (newInfo.originalAppUserId == userId) {
          log('✓ User ID matches successfully');
        } else {
          log('⚠ User ID mismatch. Expected: $userId, Got: ${newInfo.originalAppUserId}');
        }
      } else {
        log('Already logged in with different user ID: ${currentInfo.originalAppUserId}');
      }

      await debugFullConfiguration();
    } catch (e) {
      log('Error in RevenueCat login: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20),
                    child: Column(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.grey.withValues(alpha: 0.12),
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
                                      SvgPicture.asset('assets/svgs/rocket.svg',
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
                                        'Access to exclusive partner offers',
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
                                  const SizedBox(height: 15),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        width: 22,
                                        height: 22,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              child: Center(
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: <Widget>[
                                                    Icon(LucideIcons.network)
                                                  ],
                                                ),
                                              )),
                                        ),
                                      ),
                                      const SizedBox(width: 18),
                                      const Text(
                                        'Find more leads & business matches',
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
                        const SizedBox(height: 7),
                        SizedBox(
                          width: double.infinity,
                          child: ProCustomButton(
                              color: primaryColorLT,
                              text: 'Start your \$1/month trial',
                              onPressed: () async {
                                showModalBottomSheet<void>(
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(25.0),
                                    ),
                                  ),
                                  builder: (BuildContext context) {
                                    bool modalLoading = false;
                                    return StatefulBuilder(
                                      // Wrap the entire bottom sheet content with StatefulBuilder
                                      builder: (BuildContext context,
                                          StateSetter setModalState) {
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
                                                  setModalState(() {
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
                                                      setModalState(() {
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
                                                    setModalState(() {
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
                                                    loading: modalLoading,
                                                    onPressed: () async {
                                                      setModalState(() {
                                                        modalLoading = true;
                                                      });

                                                      try {
                                                        await validateAndPurchase();
                                                      } finally {
                                                        if (mounted) {
                                                          setModalState(() {
                                                            modalLoading =
                                                                false;
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
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: <InlineSpan>[
                                TextSpan(
                                  text:
                                      'By upgrading to Pro, you hereby agree to our ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                          color: const Color(0xff999797),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600),
                                ),
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      launchPolicy();
                                    },
                                  text: 'Privacy Policy',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                      color: primaryColorLT),
                                ),
                                if (Platform.isIOS)
                                  TextSpan(
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {},
                                      text: ' and ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              color: const Color(0xff999797),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600)),
                                if (Platform.isIOS)
                                  TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        launchTermsofService();
                                      },
                                    text: 'Terms of Service',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.underline,
                                        color: primaryColorLT),
                                  ),
                                TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {},
                                    text: '  of Business Bosses ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                            color: const Color(0xff999797),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
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
    );
  }
}

Future<void> launchPolicy() async {
  String url = Constants.PRIVACY_POLICY_LINK;
  bool canLunchLink = await canLaunchUrlString(url);
  if (canLunchLink) {
    await launchUrlString(url);
  } else {
    showSnackbar(
        title: 'OOPS!',
        message: 'An error occurred, please try again!',
        error: true);
  }
}

Future<void> launchTermsofService() async {
  String url = Constants.TERMS_OF_SERVICE_LINK;
  bool canLunchLink = await canLaunchUrlString(url);
  if (canLunchLink) {
    await launchUrlString(url);
  } else {
    showSnackbar(
        title: 'OOPS!',
        message: 'An error occurred, please try again!',
        error: true);
  }
}
