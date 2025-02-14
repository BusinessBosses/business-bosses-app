import 'package:business_bosses_v2/action/action.dart';
import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/presentation/services_management.dart';
import 'package:business_bosses_v2/bbpro/presentation/setup_shop.dart';
import 'package:business_bosses_v2/bbpro/presentation/shop_screen.dart';
import 'package:business_bosses_v2/bbpro/widgets/iconbutton.dart';
import 'package:business_bosses_v2/bbpro/widgets/notificationbutton.dart';
import 'package:business_bosses_v2/bbpro/presentation/inventory.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/features/chat/chat_screen.dart';
import 'package:business_bosses_v2/utils/constants/constants.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Setup extends StatefulWidget {
  const Setup({super.key});

  @override
  State<Setup> createState() => _SetupState();
}

class _SetupState extends State<Setup> {
  final ShopController shopController = Get.find();
  final List<String> titles = <String>[
    'Edit Biz-Center',
    'Manage Product Inventory',
    'My Services',
    'Contact Us'
  ];

  // final List<String> remtitles = <String>[
  //   'Privacy Policy & Terms of Use',
  //   'Contact Us',
  //   // 'Manage Subscription'
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Set Up',
          style: TextStyle(
            color: proprimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Get.to(() => const ChatScreen());
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 10.0,
                  ),
                  child: CircleAvatar(
                      radius: 20,
                      backgroundColor: prosemibackColor,
                      child: SvgPicture.asset(
                        'assets/svgs/prochat.svg',
                        height: 15,
                      )),
                ),
              ),
              const NotificationButton(),
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              color: probackgroundColor,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        SizedBox(
                          height: 70.0,
                          width: 70.0,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(1000),
                              child: GetBuilder<ShopController>(
                                builder: (ShopController controller) =>
                                    NetworkImageWithPlaceHolder(
                                  imageUrl: controller.shop?.image ?? '',
                                  radius: radius,
                                  placeHolder: Icons.person,
                                  iconSize: 22.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            GetBuilder<ShopController>(
                              builder: (ShopController controller) => Text(
                                (controller.shop?.name ?? '').length > 30
                                    ? '${(controller.shop?.name ?? '').substring(0, 30)}...'
                                    : controller.shop?.name ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: <Widget>[
                                ProIconButton(
                                  textsize: 12,
                                  padding: 10,
                                  shadow: Colors.transparent,
                                  icon: SvgPicture.asset(
                                    'assets/svgs/expandform.svg',
                                    height: 10,
                                  ),
                                  backgroundColor: Colors.white,
                                  textColor: proprimaryColor,
                                  text: 'View Biz-Center',
                                  onPressed: () {
                                    Get.to(() => const ShopScreen());
                                  },
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                ProIconButton(
                                  textsize: 12,
                                  padding: 10,
                                  shadow: Colors.transparent,
                                  icon: const Icon(
                                    Icons.share_outlined,
                                    size: 10,
                                    color: Colors.black,
                                  ),
                                  textColor: proprimaryColor,
                                  backgroundColor: Colors.white,
                                  text: 'Share my link',
                                  onPressed: () {
                                    _sharePost();
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(color: Colors.white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const SizedBox(height: 15),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: titles.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: backgroundColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ListTile(
                                  leading: titles[index] ==
                                          'Manage Product Inventory'
                                      ? SvgPicture.asset(
                                          'assets/svgs/inventory.svg',
                                          height: 18,
                                        )
                                      : titles[index] == 'My Services'
                                          ? SvgPicture.asset(
                                              'assets/svgs/myservices.svg',
                                              height: 20,
                                            )
                                          : titles[index] == 'Edit Biz-Center'
                                              ? SvgPicture.asset(
                                                  'assets/svgs/editshop.svg',
                                                  height: 20,
                                                )
                                              : SvgPicture.asset(
                                                  'assets/svgs/support.svg',
                                                  height: 20,
                                                ),
                                  title: Text(
                                    titles[index],
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                  onTap: () {
                                    if (titles[index] ==
                                        'Manage Product Inventory') {
                                      Get.to(() => const Inventory());
                                    }
                                    if (titles[index] == 'My Services') {
                                      Get.to(() => const ManageServices());
                                    }
                                    if (titles[index] == 'Edit Biz-Center') {
                                      Get.to(() => Setupshop(
                                            shop: shopController.shop,
                                          ));
                                    }
                                    if (titles[index] == 'Contact Us') {
                                      _contactUs();
                                    }
                                    // Get.toNamed(
                                    //   Routes.explorebusinessbossesscreen,
                                    //   arguments: 'Description',
                                    // );
                                  },
                                  trailing: const Icon(
                                    Icons.chevron_right,
                                    color: proprimaryColor,
                                    size: 20,
                                  )),
                            ),
                          ),
                          const SizedBox(height: 15),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                  // ListView.builder(
                  //   shrinkWrap: true,
                  //   physics: const NeverScrollableScrollPhysics(),
                  //   itemCount: remtitles.length,
                  //   itemBuilder: (BuildContext context, int index) {
                  //     return Column(
                  //       children: <Widget>[
                  //         Padding(
                  //           padding:
                  //               const EdgeInsets.symmetric(horizontal: 15.0),
                  //           child: ListTile(
                  //               contentPadding: EdgeInsets.zero,
                  //               title: Text(
                  //                 remtitles[index],
                  //                 style: TextStyle(
                  //                   fontSize: 15,
                  //                   fontWeight: FontWeight.w700,
                  //                   color: textColor.withOpacity(0.7),
                  //                 ),
                  //               ),
                  //               onTap: () {
                  //                 if (index == 0) {
                  //                   launchPolicy();
                  //                 } else if (index == 1) {
                  //                   _contactUs();
                  //                 } else if (index == 2) {
                  //                   try {
                  //                     Purchases.presentCodeRedemptionSheet();
                  //                   } catch (e) {
                  //                     showSnackbar(
                  //                       title: 'Error',
                  //                       message:
                  //                           'Unable to open subscription management. Please try again later.',
                  //                       error: true,
                  //                     );
                  //                   }
                  //                 }
                  //               },
                  //               trailing: const Icon(
                  //                 Icons.chevron_right,
                  //                 color: proprimaryColor,
                  //                 size: 20,
                  //               )),
                  //         ),
                  //         // const SizedBox(height: 15),
                  //       ],
                  //     );
                  //   },
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _contactUs() async {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri mailUrl = Uri(
      scheme: 'mailto',
      path: 'support@businessbosses.co.uk',
      query: encodeQueryParameters(<String, String>{
        'subject': 'Contact Business Bosses',
      }),
    );

    try {
      if (await canLaunchUrl(mailUrl)) {
        await launchUrl(mailUrl);
      } else {
        throw 'Could not launch $mailUrl';
      }
    } catch (e) {
      showSnackbar(
          title: 'OOPS!',
          message: 'An error occurred, please try again!',
          error: true);
    }
  }

  void _sharePost() {
    String message =
        'Have a look at ${shopController.shop!.user?.username}\'s biz-center on Business Bosses\n'
        'https://my-biz.io/${shopController.shop?.name.toLowerCase().replaceAll(' ', '-')}';
    socialShare(message);
  }

  Future<void> launchPolicy() async {
    String url = Constants.PRIVACY_POLICY_LINK;
    bool canLunchLink = await canLaunchUrlString(url);
    if (canLunchLink) {
      await launchUrlString(url);
    } else {
      showSnackbar(
          title: 'OOPS!',
          message: 'An error occurred, please try again!',
          error: true);
    }
  }
}
