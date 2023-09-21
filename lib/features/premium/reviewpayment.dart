import 'dart:convert';
import 'dart:io';

import 'package:business_bosses_v2/features/premium/paymentconfig.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pay/pay.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../action/action.dart';
import '../../common/dialogs/snackbar.dart';
import '../../common/models/api_response_model.dart';
import '../../common/widgets/buttons/my_button.dart';
import '../../common/widgets/text_widget.dart';
import '../../navigation/routes.dart';
import '../../services/api_service.dart';
import '../../utils/theme/theme.dart';
import 'package:http/http.dart' as http;

// ignore: public_member_api_docs
class ReviewPayment extends StatefulWidget {
  // ignore: public_member_api_docs
  const ReviewPayment({super.key});

  @override
  State<ReviewPayment> createState() => _ReviewPaymentState();
}

class _ReviewPaymentState extends State<ReviewPayment> {
  bool _isProcessing = false;
  ProfileController profileController = Get.find();

  ///intialize the payment
  Future<void> makePayment() async {
    setState(() {
      _isProcessing = true;
    });
    final ApiResponseModel res =
        await ApiService.post(path: 'subscription', body: {
      'price': argument['price'],
      'plan': argument['plan'],
    });

    if (res.success) {
      if (await canLaunchUrlString(res.data)) {
        await launchUrlString(res.data, mode: LaunchMode.externalApplication);
      }
    } else {
      // ignore: use_build_context_synchronously
      showSnackBar(context, message: res.message);
    }
    setState(() {
      _isProcessing = false;
    });
  }

  ///intialize the payment
  Future<void> makePayPallPayment(String plan) async {
    setState(() {
      _isProcessing = true;
    });
    final ApiResponseModel res = await ApiService.get(
      path: 'payment/plan/$plan',
    );

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

  List<Map<String, dynamic>> applepayplans = <Map<String, dynamic>>[
    <String, dynamic>{
      'price': dotenv.env['TEST_MONTHLY_PRICE'],
      'planid': '1',
    },
    <String, dynamic>{
      'price': dotenv.env['TEST_YEARLY_PRICE'],
      'planid': '2',
    },
  ];

  var argument = Get.arguments;
  List<Map<String, dynamic>> options = <Map<String, dynamic>>[
    <String, dynamic>{
      'optionname': 'Card Payment',
      'optionsvg': 'assets/svgs/cardlogo.svg'
    },
    <String, dynamic>{
      'optionname': 'Google Pay',
      'optionsvg': 'assets/svgs/googlepaylogo.svg'
    },
    if (Platform.isIOS)
      <String, dynamic>{
        'optionname': 'Apple Pay',
        'optionsvg': 'assets/svgs/applepaylogo.svg'
      },
    <String, dynamic>{
      'optionname': 'PayPal',
      'optionsvg': 'assets/svgs/paypallogo.svg'
    },
  ];

  late String initPlan = '';
  late String plan = '';

  Future<void> sendPaymentTokenToWebhook(String paymentToken) async {
    final Map<String, dynamic> requestBody = {
      'paymentToken': paymentToken,
      'userid': profileController.myProfile.uid,
    };

    try {
      final http.Response response = await http.post(
        Uri.parse(
            'https://orca-app-5dg8w.ondigitalocean.app/api/v1/payment/apple-checkout/webhook'),
        body: jsonEncode(requestBody), // Convert to JSON string
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        showSnackbar(
            title: 'Success',
            message: 'Payment made successfully',
            error: false);
        Get.to(Routes.subscriptionconfirmation);
      }
    } catch (e) {
      showSnackbar(
          title: 'OOPS!',
          message: 'An error occurred, please try again!',
          error: true);
      print(e);
    }
  }

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
          text: 'Review Payment',
          size: 20,
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 30,
                top: 35,
              ),
              child: SvgPicture.asset(
                'assets/svgs/dottedline.svg',
                height: 300,
              ),
            ),
            Container(
              height: 20,
              color: backgroundcolorinterface,
            ),
            Padding(
              padding: EdgeInsets.only(top: 40.0, left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: Color(0xFFF01C29),
                          child: CircleAvatar(
                            radius: 6,
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      TextWidget(
                        text: 'About Selected Plan',
                        size: 18,
                        fontWeight: FontWeight.w700,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 20),
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: backgroundcolorinterface, width: 3),
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                        color: backgroundcolorinterface,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: const Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: Text(
                                        'Selected Plan',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    )),
                                const Spacer(),
                                Text(
                                  argument.toString().contains('annually')
                                      ? 'Annually'
                                      : 'Monthly',
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Row(
                                children: [
                                  const Text(
                                    'Total to pay:',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  const Spacer(),
                                  Text(
                                    argument.toString().contains('annually')
                                        ? '\$49.99'
                                        : '\$4.99',
                                    style: const TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.w700),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  'assets/images/planpicture.png',
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  argument.toString().contains('annually')
                                      ? '55%'
                                      : '45%',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                const Text(
                                  ' of our users choose this plan',
                                  style: TextStyle(fontSize: 12),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'Switch',
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: primaryColorLT,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                )
                              ],
                            ),
                          ],
                        )),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: Color(0xFFF01C29),
                          child: CircleAvatar(
                            radius: 6,
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      TextWidget(
                        text: 'Select a Payment Option',
                        size: 18,
                        fontWeight: FontWeight.w700,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 20),
                    child: Column(
                      children: options
                          .map(
                            (Map<String, dynamic> options) => PaymentOptionCard(
                              option: options,
                              activeoption: initPlan,
                              onTap: (String newoption) {
                                setState(() {
                                  initPlan = newoption;
                                });
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        if (initPlan == 'Card Payment') ...[
                          MyButton(
                            labelStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                            label: 'Pay now',
                            onPressed: () async {
                              argument;
                              await makePayment();
                            },
                          )
                        ] else if (initPlan == 'Google Pay') ...[
                          GooglePayButton(
                            paymentConfiguration:
                                PaymentConfiguration.fromJsonString(
                                    defaultGooglePay),
                            paymentItems: [
                              PaymentItem(
                                label: argument.toString().contains('annually')
                                    ? 'Premium Subscription (Annually)'
                                    : 'Premium Subscription (Monthly)',
                                amount: argument.toString().contains('annually')
                                    ? '49.99'
                                    : '4.99',
                                status: PaymentItemStatus.final_price,
                              )
                            ],
                            type: GooglePayButtonType.pay,
                            margin: const EdgeInsets.only(top: 15.0),
                            onPaymentResult: ((result) =>
                                debugPrint('paymentresult: $result')),
                            loadingIndicator: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ] else if (initPlan == 'PayPal') ...[
                          MyButton(
                            onPressed: () async {
                              plan = argument['plan'];
                              await makePayPallPayment(plan);
                            },
                            label: 'Pay with PayPal',
                          )
                        ] else if (initPlan == 'Apple Pay') ...[
                          Container(
                            height: 55,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ApplePayButton(
                                height: 40,
                                width: MediaQuery.of(context).size.width,
                                paymentConfiguration:
                                    PaymentConfiguration.fromJsonString(
                                        defaultApplePay),
                                paymentItems: [
                                  PaymentItem(
                                    label:
                                        argument.toString().contains('annually')
                                            ? 'Premium Subscription (Annually)'
                                            : 'Premium Subscription (Monthly)',
                                    amount:
                                        argument.toString().contains('annually')
                                            ? '49.99'
                                            : '4.99',
                                    status: PaymentItemStatus.final_price,
                                  )
                                ],
                                style: ApplePayButtonStyle.black,
                                type: ApplePayButtonType.subscribe,
                                onPaymentResult: ((result) =>
                                    sendPaymentTokenToWebhook('$result')),
                                loadingIndicator: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            ),
                          )
                        ] else
                          ...[]
                      ],
                    ),
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

///Payment option card
class PaymentOptionCard extends StatelessWidget {
  const PaymentOptionCard({
    Key? key,
    required this.option,
    required this.activeoption,
    required this.onTap,
  }) : super(key: key);

  final Map<String, dynamic> option;
  final String activeoption;
  final Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(option['optionname']); // Update the selected option
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: option['optionname'] == activeoption
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
                Container(
                  width: 30,
                  child: SvgPicture.asset(
                    '${option['optionsvg']}',
                    height: 20,
                    width: 20,
                  ),
                ),
                Text(
                  '${option['optionname']}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.left,
                ),
                option['optionname'] == activeoption
                    ? const CircleAvatar(
                        radius: 8,
                        backgroundColor: Color(0xFFF01C29),
                        child: CircleAvatar(
                          radius: 5,
                          backgroundColor: Colors.white,
                        ),
                      )
                    : const CircleAvatar(
                        radius: 8,
                        backgroundColor: Color(0xFFf4f4f4),
                        child: CircleAvatar(
                          radius: 5,
                          backgroundColor: Colors.white,
                        ),
                      )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
