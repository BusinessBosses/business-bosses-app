import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/presentation/servicesmanagement.dart';
import 'package:business_bosses_v2/bbpro/presentation/setupshop.dart';
import 'package:business_bosses_v2/bbpro/presentation/shopscreen.dart';
import 'package:business_bosses_v2/bbpro/widgets/notificationbutton.dart';
import 'package:business_bosses_v2/bbpro/presentation/inventory.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
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
    'Edit Shop',
    'Manage Product Inventory',
    'My Services',
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
        actions: const <Widget>[NotificationButton()],
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
                          height: 100.0,
                          width: 100.0,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(1000),
                              child: NetworkImageWithPlaceHolder(
                                imageUrl: shopController.shop!.image ?? '',
                                radius: radius,
                                placeHolder: Icons.person,
                                iconSize: 22.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(shopController.shop!.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20)),
                            const SizedBox(height: 10),
                            Row(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    Get.to(() => const ShopScreen());
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(40)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 8),
                                      child: const Text('View Shop')),
                                ),
                                const SizedBox(width: 5),
                                Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(40)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 8),
                                    child: const Text('Share my link')),
                                // ProIconButton(
                                //   // icon: Icon(
                                //   //   Icons.add,
                                //   //   size: 20,
                                //   //   color: Colors.black,
                                //   // ),
                                //   backgroundColor: Colors.white,
                                //   textColor: proprimaryColor,
                                //   text: 'View Shop',
                                //   onPressed: () {},
                                // ),

                                // ProIconButton(
                                //   // icon: Icon(
                                //   //   Icons.add,
                                //   //   size: 20,
                                //   //   color: Colors.black,
                                //   // ),
                                //   textColor: proprimaryColor,
                                //   backgroundColor: Colors.white,
                                //   text: 'Share my link',
                                //   onPressed: () {},
                                // ),
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
                                title: Text(
                                  titles[index],
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                                onTap: () {
                                  if (titles[index] == 'Edit Shop') {
                                    Get.to(() => Setupshop(
                                          shop: shopController.shop,
                                        ));
                                  }
                                  if (titles[index] == 'My Inventory') {
                                    Get.to(() => const Inventory());
                                  }
                                  if (titles[index] == 'My Services') {
                                    Get.to(() => const ManageServices());
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
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
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
}
