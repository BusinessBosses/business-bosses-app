import 'dart:developer';

import 'package:business_bosses_v2/bbpro/widgets/button.dart';
import 'package:business_bosses_v2/features/home/widgets/bottom_bar.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/subscription_confirmation.dart';
import 'package:business_bosses_v2/features/notifications/widgets/quotewidget.dart';
import 'package:business_bosses_v2/features/posts/presentation/create_post_screen.dart';
import 'package:business_bosses_v2/features/premium/unlockedfeatures.dart';
import 'package:business_bosses_v2/features/profile/widgets/boss_of_the_week_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
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

class _ProScreenState extends State<ProScreen> with TickerProviderStateMixin {
  String paymentMethodId = '';
  late final TabController protabbarcontroller;
  bool isCoin = false;
  bool isSubscribed = false;
  final ProfileController profileController = Get.find();
  final List<String> reviews = <String>[
    'Best app ever! So easy to use and manage everything.',
    'This app transformed my business! Highly recommend.',
    'Streamline operations and grow your business with this app!'
  ];
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
  void initState() {
    super.initState();
    protabbarcontroller = TabController(length: 3, vsync: this);
  }

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
          'Grow',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: Stack(children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Center(
                child: Text(
              'Everything you need to grow your business',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: proprimaryColor),
            )),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
              child: Material(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: probackgroundColor,
                child: TabBar(
                  indicatorPadding: const EdgeInsets.symmetric(horizontal: 15),
                  indicatorColor: Colors.black,
                  controller: protabbarcontroller,
                  tabs: const <Widget>[
                    Tab(
                      child: FittedBox(
                        child: Text(
                          'Upgrade to Pro',
                          style: TextStyle(
                              fontSize: 11, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    Tab(
                      child: FittedBox(
                        child: Text(
                          'Become a Partner',
                          style: TextStyle(
                              fontSize: 11, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    Tab(
                      child: FittedBox(
                        child: Text(
                          'Boost Posts',
                          style: TextStyle(
                              fontSize: 11, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
                child: TabBarView(
                    controller: protabbarcontroller,
                    children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                          child: Text(
                            'Save time, save money, set up and manage your business 10x faster',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        Expanded(
                          child: Stack(children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: features.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return FeatureTile(feature: features[index]);
                                },
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 200,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: <Color>[
                                      Colors.white,
                                      Colors.white10,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ]),
                        ),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              isScrollControlled: true,
                              builder: (BuildContext context) {
                                return FractionallySizedBox(
                                  heightFactor: 0.8,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0),
                                    child: ListView.builder(
                                      itemCount: features.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return FeatureTile(
                                            feature: features[index]);
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: const Text(
                            'See all',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 0.0, top: 10, bottom: 10),
                            child: Container(
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: ProCustomButton(
                                  color: primaryColorLT,
                                  text: 'Start Free Trial',
                                  onPressed: () {}),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 100.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Center(
                                  child: Text(
                                    'Our Happy Customers',
                                    style: TextStyle(
                                        color: proprimaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  width: double
                                      .infinity, // Occupy the available width
                                  height: 80, // Adjust height as needed
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: reviews.length + 2,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return index == 0
                                          ? const SizedBox(
                                              width: 5,
                                            )
                                          : index == reviews.length + 1
                                              ? const SizedBox(
                                                  width: 15,
                                                )
                                              : SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2.8,
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 10, left: 10),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: backgroundColor,
                                                    ),
                                                    child: Text(
                                                      reviews[index - 1],
                                                      style: const TextStyle(
                                                          fontSize: 12),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                );
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: FeatureTile(
                          feature: FeatureItem(
                            iconPath: 'assets/svgs/partner.svg',
                            caption: 'Exclusive Partner Offers Awaits You',
                            subtext: 'Access special deals and benefits',
                            color:
                                Colors.grey.withOpacity(0.2), // Changed color
                          ),
                        ),
                      ),
                      const Padding(
                        padding:
                            EdgeInsets.only(left: 15.0, top: 15, bottom: 10),
                        child: Align(
                          alignment: Alignment
                              .centerLeft, // Aligns the text to the left
                          child: Text(
                            'What you\'ll get',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: proprimaryColor,
                                fontSize: 14),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '• More Customers\n'
                            '• Selected Referrals\n'
                            '• Exclusive Brand Positioning\n'
                            '• Entrepreneurial Support\n'
                            '• Economic Development\n'
                            '• Community Engagement\n',
                          ),
                        ),
                      ),
                      const BossOfWeekProfileTile(
                        isForyou: false,
                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 0.0, top: 10, bottom: 10),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: ProCustomButton(
                                color: primaryColorLT,
                                text: 'Partner with us',
                                onPressed: () async {
                                  if (await canLaunchUrl(Uri.parse(
                                      'https://businessbosses.co.uk/landingpageforpartners'))) {
                                    await launchUrl(Uri.parse(
                                        'https://businessbosses.co.uk/landingpageforpartners'));
                                  }
                                }),
                          )),
                    ],
                  ),
                  const CreatePostScreen(
                    isGrow: true,
                  )
                ])),
          ],
        ),
        const BottomBar(activeIndex: 2),
      ]),
    );
  }
}
