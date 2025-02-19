import 'package:business_bosses_v2/bbpro/widgets/menubutton.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/products.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    Key? key,
    this.hasBadge = false,
    required this.coinsCount,
    this.hasUnreadNotification = false,
    this.isTabVisible = false,
    required this.controller,
    this.hasevent,
    this.onMenuClick,
  }) : super(key: key);

  final VoidCallback? onMenuClick;
  final bool hasBadge;
  final bool isTabVisible;
  final String coinsCount;
  final bool hasUnreadNotification;
  final TabController controller;
  final bool? hasevent;

  String getGreeting() {
    final int hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // controller.index == 0
                //     ? Row(
                //         children: [
                //           GestureDetector(
                //             onTap: () {
                //               // Get.toNamed(Routes.myProfile);
                //             },
                //             child: SizedBox(
                //               height: 40.0,
                //               width: 40.0,
                //               child: ClipRRect(
                //                 borderRadius: BorderRadius.circular(10),
                //                 child: NetworkImageWithPlaceHolder(
                //                   imageUrl:
                //                       profileController.myProfile.photoUrl ??
                //                           '',
                //                   radius: 10,
                //                   placeHolder: Icons.person,
                //                   iconSize: 22.0,
                //                   fit: BoxFit.cover,
                //                 ),
                //               ),
                //             ),
                //           ),
                //           const SizedBox(width: 10),
                //           Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Text(
                //                 profileName.length > 12
                //                     ? '${profileName.substring(0, 12)}...'
                //                     : profileName,
                //                 overflow: TextOverflow.ellipsis,
                //                 maxLines: 1,
                //                 style: const TextStyle(
                //                   fontSize: 14,
                //                   fontWeight: FontWeight.bold,
                //                 ),
                //               ),
                //               Text(
                //                 '👋' + getGreeting(),
                //                 style: const TextStyle(
                //                   fontSize: 12,
                //                   color: Colors.grey,
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ],
                //       )
                //     :
                // GestureDetector(
                //   onTap: () {
                //     Get.to(const HowToUseAppScreen());
                //   },
                //   child: Padding(
                //     padding: const EdgeInsets.only(right: 10.0),
                //     child: CircleAvatar(
                //       radius: 48 / 3,
                //       backgroundColor: primaryColorLT.withOpacity(0.1),
                //       child: SvgPicture.asset(
                //         'assets/app/app_icon_only.svg',
                //       ),
                //     ),
                //   ),
                // ),
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.completesearchingscreen);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: backgroundColor,
                    ),
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: backgroundColor,
                          child: SvgPicture.asset(
                            'assets/svgs/homesearch.svg',
                            colorFilter: const ColorFilter.mode(
                              textColor,
                              BlendMode.srcIn,
                            ),
                            height: 20,
                          ),
                        ),
                        const Text(
                          'Search',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
                const SizedBox(
                  width: 15,
                ),

                Row(
                  children: <Widget>[
                    // PopupMenuButton<String>(
                    //   onSelected: (String item) {
                    //     switch (item) {
                    //       case 'Item 1':
                    //         Get.toNamed(Routes.createPost);
                    //         break;
                    //       case 'Item 2':
                    //         sellProduct(context);
                    //         break;
                    //       case 'Item 3':
                    //         Get.toNamed(Routes.createevent);
                    //         break;
                    //       case 'Item 4':
                    //         Get.to(() => const CreatePollScreen());
                    //         break;
                    //     }
                    //   },
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(10.0),
                    //   ),
                    //   itemBuilder: (BuildContext context) {
                    //     return <PopupMenuEntry<String>>[
                    //       PopupMenuItem<String>(
                    //         value: 'Item 1',
                    //         child: Row(
                    //           children: <Widget>[
                    //             SvgPicture.asset(
                    //               'assets/svgs/text.svg',
                    //               colorFilter: const ColorFilter.mode(
                    //                 textColor,
                    //                 BlendMode.srcIn,
                    //               ),
                    //               height: 15,
                    //             ),
                    //             const SizedBox(width: 8),
                    //             const Text(
                    //               'Create a Post',
                    //               style: TextStyle(
                    //                 fontSize: 13,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //       PopupMenuItem<String>(
                    //         value: 'Item 2',
                    //         child: Row(
                    //           children: <Widget>[
                    //             SvgPicture.asset(
                    //               'assets/svgs/sellicon.svg',
                    //               height: 20,
                    //               colorFilter: const ColorFilter.mode(
                    //                 textColor,
                    //                 BlendMode.srcIn,
                    //               ),
                    //             ),
                    //             const SizedBox(width: 8),
                    //             const Text(
                    //               'Sell your products & services',
                    //               style: TextStyle(
                    //                 fontSize: 13,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //       PopupMenuItem<String>(
                    //         value: 'Item 3',
                    //         child: Row(
                    //           children: <Widget>[
                    //             SvgPicture.asset(
                    //               'assets/svgs/eventu.svg',
                    //               colorFilter: const ColorFilter.mode(
                    //                 textColor,
                    //                 BlendMode.srcIn,
                    //               ),
                    //               height: 15,
                    //             ),
                    //             const SizedBox(width: 8),
                    //             const Text(
                    //               'Create an Event',
                    //               style: TextStyle(
                    //                 fontSize: 13,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //       const PopupMenuItem<String>(
                    //         value: 'Item 4',
                    //         child: Row(
                    //           children: <Widget>[
                    //             Icon(
                    //               Icons.poll,
                    //               color: textColor,
                    //               size: 18,
                    //             ),
                    //             SizedBox(width: 8),
                    //             Text(
                    //               'Create Polls & Surveys',
                    //               style: TextStyle(
                    //                 fontSize: 13,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ];
                    //   },
                    //   offset: const Offset(0, 40),
                    //   child: Container(
                    //     padding: const EdgeInsets.symmetric(
                    //         horizontal: 4, vertical: 4),
                    //     decoration: BoxDecoration(
                    //       color: backgroundcolorinterface,
                    //       borderRadius: BorderRadius.circular(20),
                    //     ),
                    //     child: const Icon(Icons.add),
                    //   ),
                    // ),
                    // const SizedBox(
                    //   width: 8,
                    // ),
                    GestureDetector(
                      onTap: () => Get.toNamed(Routes.promotionscreen),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 5),
                        decoration: BoxDecoration(
                          color: backgroundcolorinterface,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: <Widget>[
                            SvgPicture.asset('assets/svgs/coin.svg',
                                height: 22),
                            const SizedBox(width: 5),
                            Text(
                              formatCount(int.parse(coinsCount)),
                              style: const TextStyle(
                                color: textColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Stack(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () => Get.toNamed(Routes.liveEvents),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: backgroundcolorinterface,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: SvgPicture.asset(
                                      'assets/svgs/eventu.svg',
                                      height: 16),
                                ),
                                const SizedBox(width: 5),
                                const Text(
                                  'Events',
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    Stack(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () => Get.toNamed(Routes.notifications),
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: SvgPicture.asset(
                              'assets/svgs/notificationicon.svg',
                              height: 20,
                              colorFilter: const ColorFilter.mode(
                                Colors.black,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                        if (hasUnreadNotification)
                          Positioned(
                            top: 5,
                            right: 6,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white, // Border color
                                  width: 2.0, // Border width
                                ),
                              ),
                              child: const CircleAvatar(
                                backgroundColor: primaryColorLT,
                                radius: 5,
                              ),
                            ),
                          )
                      ],
                    ),

                    GestureDetector(
                        onTap: onMenuClick, child: const CustomMenuButton())
                  ],
                ),
              ],
            ),
          ),
        ),
        if (isTabVisible)
          Container(
            color: Colors.white,
            child: TabBar(
              controller: controller,
              indicatorColor: Colors.transparent,
              tabs: <Widget>[
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      if (controller.index == 0)
                        Container(
                          margin: const EdgeInsets.only(right: 8.0),
                          width: 8.0,
                          height: 8.0,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      Text(
                        'For you',
                        style: TextStyle(
                          color: controller.index == 0
                              ? primaryColorLT
                              : Colors.grey,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      if (controller.index == 1)
                        Container(
                          margin: const EdgeInsets.only(right: 8.0),
                          width: 8.0,
                          height: 8.0,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      Text(
                        'Following',
                        style: TextStyle(
                          color: controller.index == 1
                              ? primaryColorLT
                              : Colors.grey,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        if (isTabVisible)
          const Divider(
            height: 0.5,
            color: Colors.black12,
          ),
        Container(
          height: 1,
          color: backgroundColor,
        ),
      ],
    );
  }
}
