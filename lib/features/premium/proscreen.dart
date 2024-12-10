import 'package:business_bosses_v2/bbpro/widgets/button.dart';
import 'package:business_bosses_v2/features/home/widgets/bottom_bar.dart';
import 'package:business_bosses_v2/features/live_event/presentation/live_event.dart';
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

  const ProScreen({Key? key}) : super(key: key);

  @override
  State<ProScreen> createState() => _ProScreenState();
}

class _ProScreenState extends State<ProScreen> with TickerProviderStateMixin {
  late final TabController protabbarcontroller;
  bool isCoin = false;
  bool isSubscribed = false;
  bool loading = false;
  final ProfileController profileController = Get.find();
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
    protabbarcontroller = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    Purchases.logIn(profileController.myProfile.uid.toString());
    return Scaffold(
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
              unselectedLabelColor: Colors.grey, // Set unselected label color
              controller: protabbarcontroller,
              tabs: const <Widget>[
                Tab(
                  child: FittedBox(
                    child: Text(
                      'Upgrade',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                  ),
                ),
                Tab(
                  child: FittedBox(
                    child: Text(
                      'Partner with us',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                  ),
                ),
                Tab(
                  child: FittedBox(
                    child: Text(
                      'Post Ad',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
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
                  const ProSubscribeSection(),
                  Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        child: FeatureTile(
                          feature: FeatureItem(
                            iconPath: 'assets/svgs/partner.svg',
                            caption: 'Exclusive Partner Offers Await You',
                            subtext:
                                'Partner with us, list your deals and gets customers',
                            color:
                                Colors.grey.withOpacity(0.2), // Changed color
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
                            'What you\'ll get',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: textColor,
                                fontSize: 14),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Column(
                          children: _partnerfeatures
                              .map((String feature) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        SvgPicture.asset(
                                          'assets/svgs/procheck.svg',
                                          height: 15,
                                          color: Colors.black45,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Flexible(
                                          child: Text(
                                            feature,
                                            style:
                                                const TextStyle(fontSize: 14),
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

class ProSubscribeSection extends StatefulWidget {
  final bool? isGrow;
  const ProSubscribeSection({Key? key, this.isGrow}) : super(key: key);

  @override
  State<ProSubscribeSection> createState() => _ProSubscribeSectionState();
}

class _ProSubscribeSectionState extends State<ProSubscribeSection> {
  static final List<ProFeatureItem> _profeatures = <ProFeatureItem>[
    ProFeatureItem(
        iconPath: 'assets/svgs/bizcentericon.svg',
        caption: 'Get Your Own Business Center',
        subtext: 'Sell everywhere, convert visits into sales'),
    ProFeatureItem(
      iconPath: 'assets/svgs/income.svg',
      caption: 'Mutiple Income',
      subtext: 'Manage orders from multiple sales channel',
    ),
    ProFeatureItem(
      iconPath: 'assets/svgs/assistant.svg',
      caption: 'Digital Assistant',
      subtext: 'Manage inventory, tasks, schedules & expenses',
    ),
    ProFeatureItem(
        iconPath: 'assets/svgs/connections.svg',
        caption: 'More Customers & Referrals',
        subtext: 'Get discovered in global markets & searches'),
    ProFeatureItem(
        iconPath: 'assets/svgs/campaign.svg',
        caption: 'Campaign & Broadcast',
        subtext: 'Send marketing campaigns & broadcasts'),
    ProFeatureItem(
        iconPath: 'assets/svgs/premiumbadgered.svg',
        caption: 'Professional Virtual Office Address',
        subtext: 'Virtual Business Address to boost your credibility'),
  ];
  String paymentMethodId = 'Proyear';
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              widget.isGrow == null ? prosemibackColor : Colors.white,
              Colors.white,
            ],
            stops: const <double>[0.0, 0.5],
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            if (widget.isGrow == null)
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
                  Text(
                    'Sell everywhere, mange easier, and grow 10x faster,',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'with one simple link',
                    style: TextStyle(
                        color: primaryColorLT,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey.withOpacity(0.2),
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'What\'s included',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: textColor,
                        fontSize: 14),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: _profeatures
                        .map((ProFeatureItem feature) => Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: ProfeatureTile(
                              feature: feature,
                            )))
                        .toList(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            if (widget.isGrow != null)
              const SizedBox(
                height: 30,
              ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: ProCustomButton(
                color: primaryColorLT,
                text: 'Start your \$1/Month Trial',
                onPressed: () {
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
                        builder: (BuildContext context, StateSetter setState) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    const Text(
                                      'Choose your plan',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
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
                                    setState(() {
                                      paymentMethodId = 'Promonth';
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: paymentMethodId == 'Promonth'
                                            ? primaryColorLT
                                            : Colors.transparent,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: RadioListTile<String>(
                                      title: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            'Pro Monthly',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16),
                                          ),
                                          Text('\$14.99/month',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w200,
                                                  fontSize: 16)),
                                        ],
                                      ),
                                      value: 'Promonth',
                                      groupValue: paymentMethodId,
                                      onChanged: (String? value) {
                                        setState(() {
                                          paymentMethodId = value!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: paymentMethodId == 'Proyear'
                                          ? primaryColorLT
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: RadioListTile<String>(
                                    title: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          'Pro Yearly',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16),
                                        ),
                                        Text('\$9.99/month ( 33% off )',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w200,
                                                fontSize: 16)),
                                      ],
                                    ),
                                    value: 'Proyear',
                                    groupValue: paymentMethodId,
                                    onChanged: (String? value) {
                                      setState(() {
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
                                      text: 'Start your \$1/month trial',
                                      loading: loading,
                                      onPressed: () async {
                                        setState(() {
                                          loading = true;
                                        });
                                        if (paymentMethodId == 'Proyear') {
                                          try {
                                            final List<StoreProduct> product =
                                                await Purchases
                                                    .getProducts(<String>[
                                              'xyz.codexia.businessbosses.proyear'
                                            ]);
                                            final CustomerInfo customerInfo =
                                                await Purchases
                                                    .purchaseStoreProduct(
                                                        product[0]);
                                            if (customerInfo
                                                    .entitlements
                                                    .all[
                                                        'xyz.codexia.businessbosses.proyear']
                                                    ?.isActive ??
                                                false) {
                                              // Grant access to premium features
                                              print('User subscribed!');
                                            }
                                          } catch (e) {
                                            // Handle error
                                            print(
                                                'Error purchasing product: $e');
                                          } finally {
                                            setState(() {
                                              loading = false;
                                            });
                                          }
                                        } else {
                                          try {
                                            final List<StoreProduct> product =
                                                await Purchases
                                                    .getProducts(<String>[
                                              'xyz.codexia.businessbosses.promonth'
                                            ]);
                                            final CustomerInfo customerInfo =
                                                await Purchases
                                                    .purchaseStoreProduct(
                                                        product[0]);
                                            if (customerInfo
                                                    .entitlements
                                                    .all[
                                                        'xyz.codexia.businessbosses.promonth']
                                                    ?.isActive ??
                                                false) {
                                              // Grant access to premium features
                                              print('User subscribed!');
                                            }
                                          } catch (e) {
                                            // Handle error
                                            print(
                                                'Error purchasing product: $e');
                                          } finally {
                                            setState(() {
                                              loading = false;
                                            });
                                          }
                                        }
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
                },
              ),
            ),
            if (widget.isGrow == null)
              const SizedBox(
                height: 100,
              )
          ],
        ));
  }
}
