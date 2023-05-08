import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;

import '../../../action/action.dart';
import '../../../common/models/my_response.dart';
import '../../../common/widgets/buttons/my_button.dart';
import '../../../common/widgets/text_widget.dart';
import '../../../utils/constants/constants.dart';
import '../../../utils/theme/theme.dart';
import 'confirmation.dart';

class BoostPost extends StatefulWidget {
  const BoostPost({Key? key, required this.postId, this.postTitle = ""})
      : super(key: key);
  final String postTitle;
  final String postId;
  @override
  State<BoostPost> createState() => _BoostPostState();
}

class _BoostPostState extends State<BoostPost> {
  bool _isProcessing = false;
  late Map<String, dynamic>? paymantIntent;

  late String duration;
  List<Map<String, dynamic>> plans = [
    {
      'amount': '3',
      'duration': 'Duration 3 days',
      'reach': 'Reach 500 to 850 people'
    },
    {
      'amount': '5',
      'duration': 'Duration 5 Days',
      'reach': 'Reach 900 to 1.2k people'
    },
  ];

  Future<void> updatePost() async {
    // MyResponse res = await _firebase.updateNode(
    //   id: widget.postId,
    //   path: Constants.POSTS,
    //   map: {
    //     'amount': initPlan,
    //     'paid': true,
    //     'promote': true,
    //     'approved': true,
    //     'promoted_at': DateTime.now().millisecondsSinceEpoch,
    //     'promotion_duration': DateTime.now()
    //         .add(
    //           Duration(
    //             days: int.parse(initPlan),
    //           ),
    //         )
    //         .millisecondsSinceEpoch,
    //     'promotion_views': 0
    //   },
    // );
  }

  late String initPlan;
  calculateAmount(String amount) {
    final int calculatedAmount = (int.parse(amount)) * 100;
    return calculatedAmount.toString();
  }

  displaySheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {
        await updatePost();

        Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => const Confirmation(),
        ));

        paymantIntent = null;
      }).onError((Object? error, StackTrace stackTrace) {
        setState(() {
          _isProcessing = false;
        });
        log(' =>> $error');
        showSnackBar(context,
            message: "Opps!! Something went wrong. Try again");
      });
    } on StripeException {
      setState(() {
        _isProcessing = false;
      });
      showSnackBar(context, message: "Opps!! Something went wrong. Try again");
      // print('Here ->>>>>> $e');
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      log('Here ->>>>>> $e');

      showSnackBar(context, message: "Opps!! Something went wrong. Try again");
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      http.Response res = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer ${dotenv.env['STRIPE_SEC_KEY']}',
            'Content-Type': 'application/x-www-form-urlencoded'
          });

      // log(res.body);

      return jsonDecode(res.body);
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      log('Here ->>>>>> $e');

      showSnackBar(context, message: "Opps!! Something went wrong. Try again");
    }
  }

  Future<void> makePayment() async {
    try {
      setState(() {
        _isProcessing = true;
      });
      paymantIntent = await createPaymentIntent(initPlan, 'USD');
      await Stripe.instance
          .initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymantIntent!['client_secret'],
          merchantDisplayName: 'Adam',
        ),
      )
          .then((value) {
        // log(value.toString());
      });

      displaySheet();
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlan = plans[0]['amount'];

    log(widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
          text: 'Boost Post',
          size: 20,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 15,
            ),
            Stack(
              children: [
                Image.asset(
                  'assets/images/boost_banner.png',
                  width: size.width,
                  height: size.width / 2,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TextWidget(
                        text: "Reach\na Wider Audience",
                        color: Color(0xFFFFFFFF),
                        fontWeight: FontWeight.w800,
                        size: 20,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: const [
                          Icon(
                            Icons.check_box,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          TextWidget(
                            text: "More likes on posts",
                            color: Colors.white,
                          ),
                        ],
                      ),
                      Row(
                        children: const [
                          Icon(
                            Icons.check_box,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          TextWidget(
                            text: "More connections",
                            color: Colors.white,
                          )
                        ],
                      ),
                      Row(
                        children: const [
                          Icon(
                            Icons.check_box,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          TextWidget(
                            text: "More referrals",
                            color: Colors.white,
                          )
                        ],
                      ),

                      // ListTile(
                      //   leading: Icon(
                      //     Icons.check_box,
                      //     color: Colors.white,
                      //   ),
                      //   title: TextWidget(
                      //     text: "More likes",
                      //     color: Colors.white,
                      //   ),
                      // )
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
              height: 30,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: MyButton(
                  isProcessing: _isProcessing,
                  labelStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                  label: "Continue",
                  onPressed: () async {
                    await makePayment();
                  }),
            ),
            const SizedBox(
              height: 50,
            )
            // BoostPlanCard()
          ],
        ),
      ),
    );
  }
}

class BoostPlanCard extends StatelessWidget {
  const BoostPlanCard({
    Key? key,
    required this.plan,
    required this.activePlan,
    required this.onTap,
  }) : super(key: key);
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
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                  )
          ],
        ),
      ),
    );
  }
}
