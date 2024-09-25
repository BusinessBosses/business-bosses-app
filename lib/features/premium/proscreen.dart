import 'dart:developer';

import 'package:business_bosses_v2/bbpro/widgets/button.dart';
import 'package:business_bosses_v2/features/home/widgets/bottom_bar.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/subscription_confirmation.dart';
import 'package:business_bosses_v2/features/premium/unlockedfeatures.dart';
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
  final List<FeatureItem> features = <FeatureItem>[
    FeatureItem(
      iconPath: 'assets/svgs/bizcenter.svg',
      caption: 'Biz-Centre Website',
      subtext: 'Easily build your online presence',
      color: Colors.pink.withOpacity(0.2), // Changed color
    ),
    FeatureItem(
      iconPath: 'assets/svgs/pos.svg',
      caption: 'POS Management',
      subtext: 'Quick POS for seamless transactions',
      color: Colors.orange.withOpacity(0.2), // Changed color
    ),
    FeatureItem(
      iconPath: 'assets/svgs/payment.svg',
      caption: 'Payment Management',
      subtext: 'Online or cash payments for orders & invoices',
      color: Colors.yellow.withOpacity(0.2), // Changed color
    ),
    FeatureItem(
      iconPath: 'assets/svgs/business.svg',
      caption: 'Bundled Business Management',
      subtext: 'Track projects, expenses, orders, & inventory',
      color: Colors.green.withOpacity(0.2), // Changed color
    ),
    FeatureItem(
      iconPath: 'assets/svgs/appointment.svg',
      caption: 'Appointment Management',
      subtext: 'Book, manage, and send reminders',
      color: Colors.blue.withOpacity(0.2), // Changed color
    ),
    FeatureItem(
      iconPath: 'assets/svgs/crm.svg',
      caption: 'Customer Relationship Management',
      subtext: 'Manage contacts and client interactions with CRM',
      color: Colors.indigo.withOpacity(0.2), // Changed color
    ),
    FeatureItem(
      iconPath: 'assets/svgs/analytics.svg',
      caption: 'Performance Analytics',
      subtext: 'Access real-time revenue and analytics',
      color: Colors.purple.withOpacity(0.2), // Changed color
    ),
    FeatureItem(
      iconPath: 'assets/svgs/premiumbadgered.svg',
      caption: 'Premium Badge',
      subtext: 'Showcase your Pro status',
      color: Colors.red.withOpacity(0.2), // Changed color
    ),
    FeatureItem(
      iconPath: 'assets/svgs/coin.svg',
      caption: 'Coin Rewards',
      subtext: 'Get 100 coins per month',
      color: Colors.orange.withOpacity(0.2), // Changed color
    ),
    FeatureItem(
      iconPath: 'assets/svgs/rocket.svg',
      caption: 'Boosted Posts',
      subtext: 'Reach more customers with no fees',
      color: Colors.lime.withOpacity(0.2), // Changed color
    ),
    FeatureItem(
      iconPath: 'assets/svgs/networkgrowth.svg',
      caption: 'Network Growth',
      subtext: 'Get more connections and referrals',
      color: Colors.cyan.withOpacity(0.2), // Changed color
    ),
    FeatureItem(
      iconPath: 'assets/svgs/visibility.svg',
      caption: 'Increased Visibility',
      subtext: 'Get discovered in post searches',
      color: Colors.brown.withOpacity(0.2), // Changed color
    ),
    FeatureItem(
      iconPath: 'assets/svgs/partner.svg',
      caption: 'Exclusive Partner Offers',
      subtext: 'Access special deals and benefits',
      color: Colors.grey.withOpacity(0.2), // Changed color
    ),
  ];

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
          'Upgrade to Pro',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Stack(children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 10,
              color: backgroundcolorinterface,
            ),
            Expanded(
              // Wrap the Stack with Expanded
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
                      Expanded(
                        child: ListView.builder(
                          itemCount: features.length + 3,
                          itemBuilder: (BuildContext context, int index) {
                            if (index == 0) {
                              return const Padding(
                                padding: EdgeInsets.only(
                                    left: 15.0, top: 30, bottom: 5),
                                child: Text(
                                  'See what you\'ll unlock',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              );
                            } else if (index == 1) {
                              return const Padding(
                                padding: EdgeInsets.only(
                                    left: 15.0, top: 0, bottom: 15),
                                child: Text(
                                  'Everything you need to grow your business successfully',
                                  style: TextStyle(fontSize: 14),
                                ),
                              );
                            } else if (index == features.length + 2) {
                              // Check for the last position
                              return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 0.0, top: 30, bottom: 90),
                                  child: ProCustomButton(
                                      text: 'Start Free Trial',
                                      onPressed: () {}));
                            } else {
                              return FeatureTile(feature: features[index - 2]);
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const BottomBar(activeIndex: 2),
      ]),
    );
  }
}
