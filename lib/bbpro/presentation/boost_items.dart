import 'dart:convert';
import 'dart:math';
import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/product_model.dart';
import 'package:business_bosses_v2/bbpro/models/service_model.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/features/premium/reviewpayment.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:flutter_paystack/flutter_paystack.dart';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../common/widgets/buttons/my_button.dart';
import '../../../common/widgets/text_widget.dart';
import '../../../utils/theme/theme.dart';
import 'confirmation.dart';

/// BOOST POST SCREEN
class BoostItem extends StatefulWidget {
  const BoostItem({
    super.key,
    this.product,
    this.service,
  });
  final Product? product;
  final Service? service;
  @override
  State<BoostItem> createState() => _BoostItemState();
}

class _BoostItemState extends State<BoostItem> {
  final ShopController shopController = Get.find();
  bool _isProcessing = false;
  bool isCoin = false;
  late Map<String, dynamic>? paymantIntent;
  final ProfileController profileController = Get.find();
  // final PaystackPlugin payStackClient = PaystackPlugin();

  late String duration;
  List<Map<String, dynamic>> plans = <Map<String, dynamic>>[
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

  List<Map<String, dynamic>> options = <Map<String, dynamic>>[
    <String, dynamic>{
      'optionname': 'Coins (100 Coins = \$1)',
      'optionsvg': 'assets/svgs/coin.svg'
    },
    <String, dynamic>{
      'optionname': 'Card Payment',
      'optionsvg': 'assets/svgs/cardlogo.svg'
    },
    <String, dynamic>{
      'optionname': 'PayStack',
      'optionsvg': 'assets/svgs/paystack.svg'
    },
  ];

  Future<void> updatePost(String method) async {
    final Map<String, dynamic> body = <String, dynamic>{
      'promote': true,
      'plan': '$initPlan dollars',
      'paymentMethod': method,
    };
    if (widget.service != null) {
      shopController.updateService(widget.service!.id, body);
    } else {
      shopController.updateProduct(widget.product!.id, body);
    }
  }

  late String initPlan;
  late String myPlan;
  String calculateAmount(String amount) {
    final int calculatedAmount = (int.parse(amount)) * 100;
    return calculatedAmount.toString();
  }

  void displaySheet() async {
    try {
      await Stripe.instance
          .presentPaymentSheet()
          .then((PaymentSheetPaymentOption? value) async {
        await updatePost('card');

        Get.to(() => const Confirmation());

        paymantIntent = null;
      }).onError((Object? error, StackTrace stackTrace) {
        setState(() {
          _isProcessing = false;
        });
        showSnackbar(
            title: 'Oops!', message: 'Something went wrong. Try again');
      });
    } on StripeException {
      setState(() {
        _isProcessing = false;
      });
      // ignore: use_build_context_synchronously
      showSnackbar(title: 'Oops!', message: 'Something went wrong. Try again');
      // print('Here ->>>>>> $e');
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      showSnackbar(title: 'Oops!', message: 'Something went wrong. Try again!');
    }
  }

  Future<dynamic> createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = <String, dynamic>{
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
        'receipt_email': profileController.myProfile.email, // Add user email
        'metadata': <String, dynamic>{
          'user_id': profileController.myProfile.uid, // Store user ID
          'user_name': profileController.myProfile.name, // Store user name
          'product_id': widget.product?.id ?? '',
          'service_id': widget.service?.id ?? '',
        }
      };

      http.Response res = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: <String, String>{
            'Authorization': 'Bearer ${dotenv.env['STRIPE_SEC_KEY']}',
            'Content-Type': 'application/x-www-form-urlencoded'
          });

      // print(res.body);

      return jsonDecode(res.body);
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });

      showSnackbar(
          title: 'OOPS!',
          message: 'An error occurred, please try again!',
          error: true);
    }
  }

  /// Handles payments using coins
  Future<void> makeCoinPayment() async {
    if (profileController.myProfile.coinscount! < (int.parse(initPlan) * 100)) {
      showSnackbar(
          title: 'Insufficient Coins',
          message: 'You do not have enough coins to complete this payment.');
      return;
    }

    try {
      setState(() {
        _isProcessing = true;
      });

      // Deduct coins from user profile
      await ApiService.put(
        path: 'users/${profileController.myProfile.uid}',
        body: <String, dynamic>{
          'coinscount': profileController.myProfile.coinscount! -
              (int.parse(initPlan) * 100),
        },
      );

      // Update post with "coin" as payment method
      await updatePost('coin');

      // Update coin count in profile
      profileController.updateCoinCount(-(int.parse(initPlan) * 100));

      setState(() {
        _isProcessing = false;
      });

      // Navigate to confirmation page
      Get.to(() => const Confirmation());
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      showSnackbar(title: 'Error', message: 'Payment failed. Try again.');
    }
  }

  /// Handles payments using Stripe
  Future<void> makeStripePayment() async {
    try {
      setState(() {
        _isProcessing = true;
      });

      // Create payment intent on Stripe
      paymantIntent = await createPaymentIntent(initPlan, 'USD');

      // Ensure payment intent is valid
      if (paymantIntent == null || paymantIntent!['client_secret'] == null) {
        setState(() {
          _isProcessing = false;
        });
        showSnackbar(
            title: 'Payment Error', message: 'Unable to process payment.');
        return;
      }

      // Initialize Stripe payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymantIntent!['client_secret'],
          merchantDisplayName: 'Business Bosses',
        ),
      );

      // Display Stripe payment sheet
      displaySheet();
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      showSnackbar(title: 'Error', message: 'Payment failed. Try again.');
    }
  }

  void _startPaystack() async {
    // String? publicKey = dotenv.env['PAYSTACK_PUBLIC_KEY'];
    // await payStackClient.initialize(publicKey: publicKey!);
  }

  final String reference =
      'unique_transaction_ref_${Random().nextInt(1000000)}';

  void _makePayment() async {
    // final Charge charge = Charge()
    //   ..email = profileController.myProfile.email
    //   ..amount = (int.parse(initPlan) * 100000)
    //   // ..amount = 10000
    //   ..reference = reference;

    // final CheckoutResponse response = await payStackClient.checkout(context,
    //     charge: charge, method: CheckoutMethod.card);

    // if (response.status && response.reference == reference) {
    //   showSnackbar(message: 'Payment Successful, Thanks for your patronage !');
    // } else {
    //   showSnackbar(title: 'Oops!', message: 'Something went wrong. Try again');
    // }
  }

  @override
  void initState() {
    super.initState();
    initPlan = plans[0]['amount'];
    myPlan = options[0]['optionname'];
    _startPaystack();

    // print(widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Get.offNamed(Routes.marketPlace);
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.clear_outlined,
                    color: primaryColorLT,
                    size: 14,
                  ),
                  SizedBox(width: 2),
                  Text('Cancel boost',
                      style: TextStyle(
                          color: primaryColorLT,
                          fontSize: 15,
                          fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
        ],
        centerTitle: false,
        title: TextWidget(
          text: 'Boost ${widget.service != null ? 'Service' : 'Product'}',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Image.asset(
                  'assets/images/boost_banner.png',
                  width: size.width,
                  height: size.width / 2,
                  fit: BoxFit.cover,
                ),
                const Positioned(
                  bottom: 20,
                  left: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextWidget(
                        text: 'Reach\na Wider Audience',
                        color: Color(0xFFFFFFFF),
                        fontWeight: FontWeight.w800,
                        size: 20,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.check_box,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          TextWidget(
                            text: 'More view on shops',
                            color: Colors.white,
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.check_box,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          TextWidget(
                            text: 'More connections',
                            color: Colors.white,
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.check_box,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          TextWidget(
                            text: 'More referrals',
                            color: Colors.white,
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextWidget(
                text: 'Choose your Plan',
                color: Color(0xFF373737),
                fontWeight: FontWeight.w700,
                size: 20,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: plans
                    .map(
                      (Map<String, dynamic> plan) => BoostPlanCard(
                        plan: plan,
                        activePlan: initPlan,
                        onTap: (String newPlan) {
                          setState(() {
                            initPlan = newPlan;
                          });
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: TextWidget(
                text: 'Select a Payment Option',
                size: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20),
            //   child: Column(
            //     children: <Widget>[
            //       Row(
            //         children: <Widget>[
            //           Checkbox(
            //             value: isCoin,
            //             onChanged: (bool? value) {
            //               setState(() {
            //                 isCoin = value!;
            //               });
            //             },
            //           ),
            //           const Text(
            //             'Pay With Coin (100 Coins = \$1)',
            //           ),
            //         ],
            //       ),
            //       Container(
            //         padding:
            //             const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
            //         decoration: BoxDecoration(
            //           color: const Color(0xFFF4F4F4),
            //           borderRadius: BorderRadius.circular(3.5),
            //         ),
            //         child: isCoin
            //             ? profileController.myProfile.coinscount! <
            //                     (int.parse(initPlan) * 100)
            //                 ? const TextWidget(
            //                     text: 'You do not have enough coins to promote',
            //                     color: Color(0xFF232324),
            //                     fontWeight: FontWeight.w600,
            //                     size: 12)
            //                 : Container()
            //             : Container(),
            //       ),
            //     ],
            //   ),
            // ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Column(
                children: options
                    .map(
                      (Map<String, dynamic> options) => PaymentOptionCard(
                        option: options,
                        activeoption: myPlan,
                        onTap: (String newoption) {
                          setState(() {
                            myPlan = newoption;
                            isCoin = (newoption == 'Coins (100 Coins = \$1)');
                          });
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  if (myPlan == 'Coins (100 Coins = \$1)') ...<Widget>[
                    MyButton(
                      isProcessing: _isProcessing,
                      labelStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                      label: (isCoin &&
                              profileController.myProfile.coinscount! <
                                  (int.parse(initPlan) * 100))
                          ? 'Pay With Card'
                          : 'Continue',
                      onPressed: () async {
                        isCoin = profileController.myProfile.coinscount! >=
                                (int.parse(initPlan) * 100)
                            ? true
                            : false;
                        await makeCoinPayment();
                      },
                    ),
                  ] else if (myPlan == 'Card Payment') ...<Widget>[
                    MyButton(
                      isProcessing: _isProcessing,
                      labelStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                      label: 'Pay With Card',
                      onPressed: () async {
                        await makeStripePayment();
                      },
                    ),
                  ] else if (myPlan == 'PayStack') ...<Widget>[
                    MyButton(
                      onPressed: () async {
                        _makePayment();
                      },
                      labelStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                      label: 'Pay now',
                    )
                  ] else
                    ...<Widget>[]
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}

/// BOOST CARD
class BoostPlanCard extends StatelessWidget {
  /// CONSTRUCTOR
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
      onTap: () {
        onTap(plan['amount']);
        // print(activePlan);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 15),
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: plan['amount'] == activePlan
                ? primaryColorLT
                : const Color.fromRGBO(0, 0, 0, 0.0530),
            width: 3,
          ),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextWidget(
                  text: '\$${plan['amount']}.00',
                  size: 15,
                  fontWeight: FontWeight.w700,
                ),
                if (plan['amount'] == activePlan)
                  const CircleAvatar(
                    radius: 14,
                    backgroundColor: Color(0xFFF01C29),
                    child: CircleAvatar(
                      radius: 9,
                      backgroundColor: Colors.white,
                    ),
                  )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F4F4),
                borderRadius: BorderRadius.circular(3.5),
              ),
              child: plan.containsValue('3')
                  ? const TextWidget(
                      text: 'Duration 3 Days',
                      color: Color(0xFF232324),
                      fontWeight: FontWeight.w600,
                      size: 12)
                  : const TextWidget(
                      text: 'Duration 5 Days',
                      color: Color(0xFF232324),
                      fontWeight: FontWeight.w600,
                      size: 12,
                    ),
            ),
            const SizedBox(
              height: 15,
            ),
            plan.containsValue('3')
                ? const TextWidget(
                    text: 'Reach 500 to 850 people',
                    color: Color(0xFF777777),
                    fontWeight: FontWeight.w400,
                    size: 12,
                  )
                : const TextWidget(
                    text: 'Reach 900 to 1.2k people',
                    color: Color(0xFF777777),
                    fontWeight: FontWeight.w400,
                    size: 12,
                  ),
          ],
        ),
      ),
    );
  }
}
