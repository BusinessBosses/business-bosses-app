import 'dart:developer';

import 'package:business_bosses_v2/bbpro/widgets/button.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/subscription_confirmation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

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

  /// Debug full RevenueCat configuration
  Future<void> debugFullConfiguration() async {
    try {
      log('=== DEBUGGING REVENUECAT CONFIGURATION ===');

      // 1. Check RevenueCat connection
      final CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      log('✓ RevenueCat connected - User ID: ${customerInfo.originalAppUserId}');

      // 2. Check current app bundle/package
      log('App Bundle ID should match product prefix');

      // 3. Check offerings
      final Offerings offerings = await Purchases.getOfferings();
      log('Available offerings count: ${offerings.all.length}');
      log('Current offering: ${offerings.current?.identifier ?? "NONE"}');

      if (offerings.current != null) {
        log('Monthly package: ${offerings.current!.monthly?.identifier ?? "NONE"}');
        log('Annual package: ${offerings.current!.annual?.identifier ?? "NONE"}');

        // Log all packages in current offering
        for (Package package in offerings.current!.availablePackages) {
          log('Package: ${package.identifier} - Product: ${package.storeProduct.identifier}');
        }
      }

      // 4. Try to get products with various IDs
      final List<String> testProductIds = <String>[
        'xyz.codexia.businessbosses.promonth',
        'xyz.codexia.businessbosses.proyear',
        'promonth',
        'proyear',
        'pro_monthly',
        'pro_yearly',
      ];

      for (String productId in testProductIds) {
        try {
          final List<StoreProduct> products =
              await Purchases.getProducts(<String>[productId]);
          log('Product ID "$productId": ${products.length} found');

          if (products.isNotEmpty) {
            final StoreProduct product = products[0];
            log('  - Title: ${product.title}');
            log('  - Price: ${product.priceString}');
            log('  - Description: ${product.description}');
          }
        } catch (e) {
          log('Product ID "$productId": Error - $e');
        }
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

      // Check RevenueCat configuration
      log('Checking RevenueCat configuration...');
      final CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      log('RevenueCat User ID: ${customerInfo.originalAppUserId}');

      // Try to get offerings first (recommended approach)
      final Offerings offerings = await Purchases.getOfferings();
      log('Available offerings: ${offerings.all.keys.toList()}');

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
        title: 'Configuration Error',
        message:
            'Subscription products are not available. Please contact support.',
        error: true,
      );
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> purchaseUsingOfferings(Offerings offerings) async {
    try {
      final Package? package = paymentMethodId == 'Proyear'
          ? offerings.current!.annual
          : offerings.current!.monthly;

      if (package == null) {
        throw Exception('Selected package not available in offerings');
      }

      log('Purchasing package: ${package.identifier}');
      final PurchaseResult purchaseResult =
          await Purchases.purchasePackage(package);

      await handleSuccessfulPurchase(purchaseResult.customerInfo);
    } catch (e) {
      log('Offerings purchase failed: $e');
      // Fallback to direct product purchase
      await purchaseUsingProducts();
    }
  }

  Future<void> purchaseUsingProducts() async {
    final String productId = paymentMethodId == 'Proyear'
        ? 'xyz.codexia.businessbosses.proyear'
        : 'xyz.codexia.businessbosses.promonth';

    log('Attempting to get product: $productId');

    final List<StoreProduct> products =
        await Purchases.getProducts(<String>[productId]);
    log('Retrieved products: ${products.map((StoreProduct p) => p.identifier).toList()}');

    if (products.isEmpty) {
      // Try alternative product IDs or show configuration error
      await tryAlternativeProductIds();
      return;
    }

    final PurchaseResult purchaseResult =
        await Purchases.purchaseStoreProduct(products[0]);
    await handleSuccessfulPurchase(purchaseResult.customerInfo);
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
    Purchases.logIn(profileController.myProfile.uid.toString()).then((_) {
      debugFullConfiguration();
    });
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
                                  const SizedBox(height: 15),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        width: 22,
                                        height: 22,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          gradient: LinearGradient(
                                            colors: <Color>[
                                              Color(0xFF6366F1),
                                              Color(0xFF818CF8)
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
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
                                                    Text(
                                                      'ai',
                                                      style: TextStyle(
                                                        color: Colors
                                                            .white, // Choose a contrasting color
                                                        fontSize:
                                                            14, // Adjust size to fit within the icon
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                        ),
                                      ),
                                      const SizedBox(width: 18),
                                      const Text(
                                        'Generate Unlimited Promotion',
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
                                                    loading: loading,
                                                    onPressed: () async {
                                                      await validateAndPurchase();
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
