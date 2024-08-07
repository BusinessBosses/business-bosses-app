import 'package:business_bosses_v2/bbpro/common/widgets/iconbutton.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/features/live_event/widgets/custom_icon_button.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class Setup extends StatefulWidget {
  const Setup({super.key});

  @override
  State<Setup> createState() => _SetupState();
}

class _SetupState extends State<Setup> {
  final List<String> titles = [
    'Edit Shop',
    'Manage Inventory',
    'Availability',
    'Privacy Policy & Terms of Use',
    'Contact Us',
    'Manage Subscription'
  ];

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find();
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0, bottom: 15),
            child: CircleAvatar(
              backgroundColor: prosemibackColor,
              radius: 30, // This sets the circle's radius
              child: Padding(
                padding: const EdgeInsets.all(
                    10), // Adjust padding to fit the icon nicely
                child: SvgPicture.asset(
                  'assets/svgs/notificationicon.svg',
                  height: 20,
                ),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: probackgroundColor,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          height: 100.0,
                          width: 100.0,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(1000),
                              child: NetworkImageWithPlaceHolder(
                                imageUrl:
                                    profileController.myProfile.photoUrl ?? '',
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
                          children: [
                            const Text('Shop Name',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20)),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(40)),
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                  child: Text('View Shop')),
                                SizedBox(width: 5),
                               Container(
                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(40)),
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                  child: Text('Share my link')),
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
                children: [
                  const SizedBox(height: 15),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: titles.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
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
                                  // Get.toNamed(
                                  //   Routes.explorebusinessbossesscreen,
                                  //   arguments: 'Description',
                                  // );
                                },
                                trailing: Icon(
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
}
