import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/widgets/button.dart';
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/home/widgets/bottom_bar.dart';
import 'package:business_bosses_v2/features/posts/presentation/create_post_screen.dart';
import 'package:business_bosses_v2/features/premium/profeatures.dart';
import 'package:business_bosses_v2/features/premium/unlockedfeatures.dart';
import 'package:business_bosses_v2/features/profile/widgets/boss_of_the_week_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/theme/theme.dart';
import '../profile/controller/profile_controller.dart';

class ProScreen extends StatefulWidget {
  static const String routeName = '/proScreen';

  const ProScreen({super.key});

  @override
  State<ProScreen> createState() => _ProScreenState();
}

class _ProScreenState extends State<ProScreen> with TickerProviderStateMixin {
  late final TabController protabbarcontroller;
  bool isCoin = false;
  bool isSubscribed = false;
  bool loading = true;
  final ProfileController profileController = Get.find();
  final ShopController shopController = Get.find();
  final List<String> reviews = <String>[
    'Best app ever! So easy to use and manage everything.',
    'This app transformed my business! Highly recommend.',
    'Streamline operations and grow your business with this app!'
  ];

  static final List<String> _partnerfeatures = <String>[
    'More Customers',
    'Selected Referrals',
    'Exclusive Brand Positioning',
    'Entrepreneurial Support',
    'Listed across multiple media',
    'Community Engagement',
  ];

  @override
  void initState() {
    super.initState();
    if (shopController.shop == null) {
      shopController.initShop().then((bool value) {
        loading = false;
        setState(() {});
      });
    } else {
      loading = false;
      setState(() {});
    }
    protabbarcontroller =
        TabController(length: shopController.shop != null ? 2 : 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    Purchases.logIn(profileController.myProfile.uid.toString());
    return loading
        ? Scaffold(
            appBar: AppBar(),
            body: const SafetyModel(),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(0),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: TabBar(
                    isScrollable: false,
                    indicatorColor: primaryColorLT,
                    labelColor: primaryColorLT, // Set label color
                    unselectedLabelColor:
                        Colors.grey, // Set unselected label color
                    controller: protabbarcontroller,
                    tabs: <Widget>[
                      if (shopController.shop == null)
                        const Tab(
                          child: FittedBox(
                            child: Text(
                              'My Biz',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 14),
                            ),
                          ),
                        ),
                      const Tab(
                        child: FittedBox(
                          child: Text(
                            'Partner with us',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 14),
                          ),
                        ),
                      ),
                      const Tab(
                        child: FittedBox(
                          child: Text(
                            'Generate free Ad',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: Stack(children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                      child: TabBarView(
                          controller: protabbarcontroller,
                          children: <Widget>[
                        if (shopController.shop == null)
                          const ProSubscribeSection(),
                        Column(
                          children: <Widget>[
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0.0),
                              child: FeatureTile(
                                feature: FeatureItem(
                                  iconPath: 'assets/svgs/partner.svg',
                                  caption: 'Exclusive Partner Offers Await You',
                                  subtext:
                                      'Partner with us, list your deals and gets customers',
                                  color: Colors.grey
                                      .withValues(alpha: 0.2), // Changed color
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(
                                  left: 15.0, top: 5, bottom: 10),
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
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Column(
                                children: _partnerfeatures
                                    .map((String feature) => Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              SvgPicture.asset(
                                                'assets/svgs/checkfilled.svg',
                                                height: 15,
                                                colorFilter: ColorFilter.mode(
                                                    proprimaryColor,
                                                    BlendMode.srcIn),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Flexible(
                                                child: Text(
                                                  'feature',
                                                  style: const TextStyle(
                                                      fontSize: 14),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 0.0, top: 10, bottom: 10),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
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
              BottomBar(activeIndex: 2),
            ]),
          );
  }
}

class ProSubscribeSection extends StatefulWidget {
  final bool? isGrow;
  const ProSubscribeSection({super.key, this.isGrow});

  @override
  State<ProSubscribeSection> createState() => _ProSubscribeSectionState();
}

class _ProSubscribeSectionState extends State<ProSubscribeSection> {
  static final List<ProFeatureItem> _profeatures = <ProFeatureItem>[
    ProFeatureItem(
        iconPath: 'assets/svgs/checkfilled.svg',
        caption: 'Your Own Mini Business Site',
        subtext:
            'Showcase your products/services and convert visits into sales'),
    ProFeatureItem(
      iconPath: 'assets/svgs/checkfilled.svg',
      caption: 'Monetize Your Expertise',
      subtext:
          'Launch your brand as a coach, consultant, freelancer, solopreneur or a small business owner',
    ),
    ProFeatureItem(
      iconPath: 'assets/svgs/checkfilled.svg',
      caption: 'Smart Business Tools',
      subtext: 'Manage inventory, tasks, schedules & expenses',
    ),
    ProFeatureItem(
        iconPath: 'assets/svgs/checkfilled.svg',
        caption: 'Centralised Dashboard',
        subtext: 'Track all orders from different sales channel'),
    ProFeatureItem(
        iconPath: 'assets/svgs/checkfilled.svg',
        caption: 'Customer Engagement',
        subtext: 'Manage customer records and communications'),
    ProFeatureItem(
        iconPath: 'assets/svgs/checkfilled.svg',
        caption: 'Virtual Office Address',
        subtext:
            'Boost your professional image with your own onlinen business address'),
  ];
  String paymentMethodId = 'Proyear';
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // if (widget.isGrow == null)
        //   SvgPicture.asset(
        //     'assets/svgs/premiumback.svg',
        //     width: MediaQuery.of(context).size.width,
        //     fit: BoxFit.fitWidth,
        //   ),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 15,
                  ),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          'Benefits of having your own biz-center',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Column(
                          children: _profeatures
                              .map((ProFeatureItem feature) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: ProfeatureTile(
                                    backgroundColor: Colors.transparent,
                                    feature: feature,
                                  )))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  if (widget.isGrow != null)
                    const SizedBox(
                      height: 10,
                    ),
                  if (widget.isGrow == null)
                    const SizedBox(
                      height: 100,
                    )
                ],
              ),
            )),
      ],
    );
  }
}
