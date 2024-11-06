import 'package:business_bosses_v2/bbpro/widgets/button.dart';
import 'package:business_bosses_v2/features/home/widgets/bottom_bar.dart';
import 'package:business_bosses_v2/features/live_event/presentation/live_event.dart';
import 'package:business_bosses_v2/features/posts/presentation/create_post_screen.dart';
import 'package:business_bosses_v2/features/premium/unlockedfeatures.dart';
import 'package:business_bosses_v2/features/profile/widgets/boss_of_the_week_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/theme/theme.dart';
import '../profile/controller/profile_controller.dart';

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
        automaticallyImplyLeading: false,
        title: const Text(
          'Everything you need to grow',
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Get.to(() => const LiveEvent());
            },
            icon: const Icon(Icons.calendar_month),
          ),
        ],
      ),
      body: Stack(children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 0.0, vertical: 15),
              child: Material(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                color: backgroundColor,
                child: TabBar(
                  indicatorPadding: const EdgeInsets.symmetric(horizontal: 15),
                  indicatorColor: primaryColorLT,
                  controller: protabbarcontroller,
                  tabs: const <Widget>[
                    Tab(
                      child: FittedBox(
                        child: Text(
                          'Set up Business',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    Tab(
                      child: FittedBox(
                        child: Text(
                          'Become a Partner',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    Tab(
                      child: FittedBox(
                        child: Text(
                          'Post Ad',
                          style: TextStyle(fontWeight: FontWeight.w700),
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: FeatureTile(
                            feature: FeatureItem(
                              iconPath: 'assets/svgs/businessbb.svg',
                              caption: 'Set Up Your Business',
                              subtext:
                                  'Save time, grow your business 10x faster',
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
                              'Upgrade now to',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: textColor,
                                  fontSize: 14),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '• Create your own business link \n'
                              '• Launch your products and services quickly and easily\n'
                              '• Reach customers in person, online, or on the go\n'
                              '• Track every sale with a seamless POS system\n'
                              '• Manage budget, expenses, tasks, and inventory\n'
                              '• Schedule appointments and set reminders\n'
                              '• Access real-time revenue and analytics\n',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                        const Padding(
                          padding:
                              EdgeInsets.only(left: 15.0, top: 5, bottom: 10),
                          child: Align(
                            alignment: Alignment
                                .centerLeft, // Aligns the text to the left
                            child: Text(
                              'Plus these for free',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: textColor,
                                  fontSize: 14),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '• Pro badge for increased visibility\n'
                              '• 100 coins monthly to boost posts\n'
                              '• Special deals and benefits\n',
                              style: TextStyle(fontSize: 14),
                            ),
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
                          padding:
                              const EdgeInsets.only(bottom: 100.0, top: 10),
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
                                        color: textColor,
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
                            caption: 'Exclusive Partners Awaits You',
                            subtext:
                                'Partner with us, list your deals and gets customers',
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
                                color: textColor,
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
                            '• Listed across multiple media\n'
                            '• Community Engagement\n',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
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
                      const BossOfWeekProfileTile(
                        isForyou: false,
                      ),
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
