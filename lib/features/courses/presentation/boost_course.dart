// ignore_for_file: deprecated_member_use

import 'package:business_bosses_v2/action/action.dart';
import 'package:business_bosses_v2/features/premium/reviewpayment.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

// ❌ OLD PAYMENT IMPORTS (KEPT BUT COMMENTED)
// import 'dart:convert';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:http/http.dart' as http;

import '../../../common/widgets/buttons/my_button.dart';
import '../../../common/widgets/text_widget.dart';
import '../../../utils/theme/theme.dart';
import '../../profile/controller/profile_controller.dart';
import 'confirmation.dart';

/// BOOST COURSE SCREEN
class BoostCourse extends StatefulWidget {
  const BoostCourse({
    super.key,
    required this.postId,
    this.postTitle = '',
  });

  final String postTitle;
  final String postId;

  @override
  State<BoostCourse> createState() => _BoostCourseState();
}

class _BoostCourseState extends State<BoostCourse> {
  bool _isProcessing = false;
  bool isCoin = false;

  final ProfileController profileController = Get.find();

  late String initPlan;
  late String myPlan;

  /// -----------------------------
  /// PLANS (UNCHANGED)
  /// -----------------------------
  final List<Map<String, dynamic>> plans = <Map<String, dynamic>>[
    <String, dynamic>{
      'amount': '3',
      'duration': 'Duration 3 days',
      'reach': 'Reach 500 to 850 people'
    },
    <String, dynamic>{
      'amount': '5',
      'duration': 'Duration 5 Days',
      'reach': 'Reach 900 to 1.2k people'
    },
  ];

  final List<Map<String, dynamic>> options = <Map<String, dynamic>>[
    <String, dynamic>{
      'optionname': 'Coins (100 Coins = \$1)',
      'optionsvg': 'assets/svgs/coin.svg'
    },
    <String, dynamic>{
      'optionname': 'Card Payment',
      'optionsvg': 'assets/svgs/cardlogo.svg'
    },
  ];

  /// -----------------------------
  /// REVENUECAT CONFIG (SAME AS BOOST POST)
  /// -----------------------------
  final List<String> boostProductIds = <String>[
    'boost_3_days',
    'boost_5_days',
  ];

  List<Package> _boostPackages = <Package>[];

  @override
  void initState() {
    super.initState();
    initPlan = plans[0]['amount'];
    myPlan = options[0]['optionname'];
    _loadBoostProducts();
  }

  Future<void> _loadBoostProducts() async {
    try {
      final Offerings offerings = await Purchases.getOfferings();

      if (offerings.current != null) {
        final List<Package> filtered =
            offerings.current!.availablePackages.where((Package pkg) {
          return pkg.storeProduct.productCategory ==
                  ProductCategory.nonSubscription &&
              boostProductIds.contains(pkg.storeProduct.identifier);
        }).toList();

        setState(() {
          _boostPackages = filtered;
        });
      }
    } catch (e) {
      debugPrint('Error loading boost products: $e');
    }
  }

  Package? _selectedPackage() {
    final String productId = initPlan == '3' ? 'boost_3_days' : 'boost_5_days';

    try {
      return _boostPackages.firstWhere(
        (Package p) => p.storeProduct.identifier == productId,
      );
    } catch (_) {
      return null;
    }
  }

  /// -----------------------------
  /// BACKEND UPDATE (UNCHANGED)
  /// -----------------------------
  Future<void> updatePost(String method) async {
    await ApiService.put(
      path: 'courses/update-course/${widget.postId}',
      body: <String, dynamic>{
        'isPromoted': true,
        'plan': '$initPlan dollars',
        'paymentMethod': method,
      },
    );
  }

  /// -----------------------------
  /// COIN PAYMENT (UNCHANGED)
  /// -----------------------------
  Future<void> makeCoinPayment() async {
    if (profileController.myProfile.coinscount! < (int.parse(initPlan) * 100)) {
      showSnackBar(context, message: 'Not enough coins');
      return;
    }

    try {
      setState(() => _isProcessing = true);

      await ApiService.put(
        path: 'users/${profileController.myProfile.uid}',
        body: <String, dynamic>{
          'coinscount': profileController.myProfile.coinscount! -
              (int.parse(initPlan) * 100),
        },
      );

      await updatePost('coin');
      profileController.updateCoinCount(
        -(int.parse(initPlan) * 100),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const Confirmation()),
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  /// -----------------------------
  /// REVENUECAT PURCHASE (FIXED API)
  /// -----------------------------
  Future<void> purchaseBoostWithRevenueCat() async {
    final Package? pkg = _selectedPackage();

    if (pkg == null) {
      showSnackBar(context, message: 'Product not available');
      return;
    }

    try {
      setState(() => _isProcessing = true);

      final PurchaseResult result = await Purchases.purchasePackage(pkg);

      final CustomerInfo info = result.customerInfo;

      final bool purchased = info.nonSubscriptionTransactions.any(
        (StoreTransaction t) =>
            t.productIdentifier == pkg.storeProduct.identifier,
      );

      if (purchased) {
        await updatePost('card');

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const Confirmation(),
          ),
        );
      } else {
        showSnackBar(context, message: 'Payment not completed');
      }
    } on PlatformException catch (e) {
      showSnackBar(
        context,
        message: e.message ?? 'Payment cancelled',
      );
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  /// -----------------------------
  /// OLD STRIPE / PAYSTACK (COMMENTED)
  /// -----------------------------
  /*
  Future<void> makeStripePayment() async {}
  void displaySheet() async {}
  void _makePayment() async {}
  */

  /// -----------------------------
  /// UI (UNCHANGED)
  /// -----------------------------
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          GestureDetector(
            onTap: () => Get.back(),
            child: const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Row(
                children: <Widget>[
                  Icon(Icons.clear_outlined, color: primaryColorLT, size: 14),
                  SizedBox(width: 2),
                  Text(
                    'Cancel Boost',
                    style: TextStyle(
                        color: primaryColorLT,
                        fontSize: 15,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
        ],
        title: const Text('Boost Post'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.asset(
              'assets/images/boost_banner.png',
              width: size.width,
              height: size.width / 2,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: plans
                    .map(
                      (Map<String, dynamic> plan) => BoostPlanCard(
                        plan: plan,
                        activePlan: initPlan,
                        onTap: (String v) => setState(() => initPlan = v),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: options
                    .map(
                      (Map<String, dynamic> o) => PaymentOptionCard(
                        option: o,
                        activeoption: myPlan,
                        onTap: (String v) => setState(() => myPlan = v),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: MyButton(
                labelStyle:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                isProcessing: _isProcessing,
                label: 'Continue',
                onPressed: () async {
                  if (myPlan.contains('Coins')) {
                    await makeCoinPayment();
                  } else {
                    await purchaseBoostWithRevenueCat();
                  }
                },
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

/// BOOST PLAN CARD (UNCHANGED)
class BoostPlanCard extends StatelessWidget {
  const BoostPlanCard({
    super.key,
    required this.plan,
    required this.activePlan,
    required this.onTap,
  });

  final Map<String, dynamic> plan;
  final String activePlan;
  final Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(plan['amount']),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border.all(
            color:
                plan['amount'] == activePlan ? primaryColorLT : Colors.black12,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextWidget(
              text: '\$${plan['amount']}.00',
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(height: 10),
            TextWidget(text: plan['duration']),
            const SizedBox(height: 10),
            TextWidget(text: plan['reach']),
          ],
        ),
      ),
    );
  }
}
