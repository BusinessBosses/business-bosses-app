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
import '../../common/widgets/buttons/custom_button.dart';
import '../profile/controller/profile_controller.dart';
import '../../navigation/routes.dart';
import '../../services/api_service.dart';

class ProScreen extends StatefulWidget {
  static const String routeName = '/proScreen';

  const ProScreen({Key? key}) : super(key: key);

  @override
  State<ProScreen> createState() => _ProScreenState();
}

class _ProScreenState extends State<ProScreen> {
  String paymentMethodId = '';
  bool isCoin = false;
  bool isSubscribed = false;
  final ProfileController profileController = Get.find();

  ///intialize the payment

  @override
  Widget build(BuildContext context) {
    Purchases.logIn(profileController.myProfile.uid.toString());
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
          'Become a pro member',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 10,
              color: backgroundcolorinterface,
            ),
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
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 50.0, right: 50, top: 50),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                            children: <InlineSpan>[
                              TextSpan(
                                text:
                                    'Everything you need to grow your business successfully',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          'Manage all your business operations in one place; Set up biz-centre, POS, CRM, project, invoices, payment, inventory, appointments & more.',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 12,
                            fontWeight: FontWeight.w100,
                          ),
                          textAlign: TextAlign.center, // Center-aligns the text
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10),
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20.0, left: 30),
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
                                        const SizedBox(height: 10),
                                        const Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.check_circle,
                                              size: 17,
                                              color: proprimaryColor,
                                            ),
                                            SizedBox(width: 15),
                                            Text(
                                              'Easily Set up your online Biz- Centre website',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        const Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.check_circle,
                                              size: 17,
                                              color: proprimaryColor,
                                            ),
                                            SizedBox(width: 15),
                                            Text(
                                              'Quick POS to receive online & in-person sales',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        const Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.check_circle,
                                              size: 17,
                                              color: proprimaryColor,
                                            ),
                                            SizedBox(width: 15),
                                            Text(
                                              'Accept online or cash payment for orders & invoices',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        const Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.check_circle,
                                              size: 17,
                                              color: proprimaryColor,
                                            ),
                                            SizedBox(width: 15),
                                            Text(
                                              'Manage Project, Expenses, Budget & Inventory',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        const Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.check_circle,
                                              size: 17,
                                              color: proprimaryColor,
                                            ),
                                            SizedBox(width: 15),
                                            Text(
                                              'Appointment booking, scheduling & Reminders',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        const Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.check_circle,
                                              size: 17,
                                              color: proprimaryColor,
                                            ),
                                            SizedBox(width: 15),
                                            Text(
                                              'Manage clients & customers contacts (CRM)',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        const Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.check_circle,
                                              size: 17,
                                              color: proprimaryColor,
                                            ),
                                            SizedBox(width: 15),
                                            Text(
                                              'Access Real time Revenue dashboard analytics',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: <Widget>[
                                            SvgPicture.asset(
                                              'assets/svgs/goldcheckmark.svg',
                                              height: 15,
                                              color: primaryColorLT,
                                            ),
                                            const SizedBox(width: 15),
                                            const Text(
                                              'Premium Badge',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: <Widget>[
                                            SvgPicture.asset(
                                                'assets/svgs/coin.svg',
                                                height: 15),
                                            const SizedBox(width: 10),
                                            const Text(
                                              'Earn 100 coins per month',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: <Widget>[
                                            SvgPicture.asset(
                                                'assets/svgs/rocket.svg',
                                                height: 12),
                                            const SizedBox(width: 15),
                                            const Text(
                                              'Boost post FREE with coins',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 15),
                                        Row(
                                          children: <Widget>[
                                            SvgPicture.asset(
                                                'assets/svgs/moreconnections.svg',
                                                height: 10),
                                            const SizedBox(width: 15),
                                            const Text(
                                              'More connections & referrals',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 15),
                                        Row(
                                          children: <Widget>[
                                            SvgPicture.asset(
                                                'assets/svgs/rankingicon.svg',
                                                height: 12),
                                            const SizedBox(width: 15),
                                            const Text(
                                              'Recognition on posts search',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 15),
                                        Row(
                                          children: <Widget>[
                                            SvgPicture.asset(
                                                'assets/svgs/handshake.svg',
                                                height: 10),
                                            const SizedBox(width: 18),
                                            const Text(
                                              'Exclusive Partner Offers',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 15),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 7),
                            Container(
                              width: double.infinity,
                              child: ProCustomButton(
                                text: 'Start free trial',
                                onPressed: () {},
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Get 3 days free then 1 month for £1',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 12,
                                fontWeight: FontWeight.w100,
                              ),
                              textAlign:
                                  TextAlign.center, // Center-aligns the text
                            ),
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
