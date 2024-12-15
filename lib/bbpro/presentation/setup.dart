import 'package:business_bosses_v2/action/action.dart';
import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/presentation/availability.dart';
import 'package:business_bosses_v2/bbpro/presentation/services_management.dart';
import 'package:business_bosses_v2/bbpro/presentation/setup_shop.dart';
import 'package:business_bosses_v2/bbpro/presentation/shop_screen.dart';
import 'package:business_bosses_v2/bbpro/widgets/iconbutton.dart';
import 'package:business_bosses_v2/bbpro/widgets/notificationbutton.dart';
import 'package:business_bosses_v2/bbpro/presentation/inventory.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class Setup extends StatefulWidget {
  const Setup({super.key});

  @override
  State<Setup> createState() => _SetupState();
}

class _SetupState extends State<Setup> {
  final ShopController shopController = Get.find();
  final List<String> titles = <String>[
    'Manage Product Inventory',
    'My Services',
    'Appointments'
  ];

  final List<String> remtitles = <String>[
    'Privacy Policy & Terms of Use',
    'Contact Us',
    'Manage Subscription'
  ];

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
                  Get.to(() => Setupshop(
                        shop: shopController.shop,
                      ));
                },
                child: Container(
                    margin: const EdgeInsets.only(bottom: 0),
                    decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(40)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: Row(
                      children: <Widget>[
                        SvgPicture.asset(
                          'assets/svgs/editshop.svg',
                          height: 15,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Text(
                          'Edit',
                          style: TextStyle(
                              fontSize: 14,
                              color: textColor,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    )),
              ),
              const SizedBox(
                width: 5,
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
                                // GestureDetector(
                                //   onTap: () {
                                //     Get.to(() => const ShopScreen());
                                //   },
                                //   child: Container(
                                //       decoration: BoxDecoration(
                                //           color: Colors.white,
                                //           borderRadius:
                                //               BorderRadius.circular(40)),
                                //       padding: const EdgeInsets.symmetric(
                                //           horizontal: 8, vertical: 8),
                                //       child: const Text('View Shop')),
                                // ),
                                // const SizedBox(width: 5),
                                // Container(
                                //     decoration: BoxDecoration(
                                //         color: Colors.white,
                                //         borderRadius:
                                //             BorderRadius.circular(40)),
                                //     padding: const EdgeInsets.symmetric(
                                //         horizontal: 8, vertical: 8),
                                //     child: const Text('Share my link')),
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
                                color: Colors.grey.shade200,
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
                                          : SvgPicture.asset(
                                              'assets/svgs/calendar.svg',
                                              height: 25,
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
                                    if (titles[index] == 'Appointments') {
                                      Get.to(() => const AppointmentsScreen());
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
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: remtitles.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  remtitles[index],
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: textColor.withOpacity(0.7),
                                  ),
                                ),
                                onTap: () {},
                                trailing: const Icon(
                                  Icons.chevron_right,
                                  color: proprimaryColor,
                                  size: 20,
                                )),
                          ),
                          // const SizedBox(height: 15),
                        ],
                      );
                    },
                  ),
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
        ' ${shopController.shop?.url}';
    socialShare(message);
  }
}
