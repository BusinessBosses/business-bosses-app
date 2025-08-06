// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:business_bosses_v2/features/chat/ai_chat.dart';
import 'package:business_bosses_v2/features/forum/controller/challenge_controller.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';

class Floatingbutton extends StatefulWidget {
  final bool? isEvent;
  const Floatingbutton({
    super.key,
    this.isEvent,
  });

  @override
  State<Floatingbutton> createState() => FloatingbuttonState();
}

class FloatingbuttonState extends State<Floatingbutton> {
  ChallengeController controller = Get.put(ChallengeController());

  @override
  Widget build(BuildContext context) {
    final ProfileController myProfile = Get.find();
    // final Industry category = controller.categories[0];
    // ignore: unused_local_variable
    int now = DateTime.now().millisecondsSinceEpoch;
    // ignore: unused_local_variable
    int previousStamp = myProfile.myProfile.bossOfTheWeekTimeStamp ?? 0;
    return GestureDetector(
      onTap: () {
        Get.to(() => AiChatScreen());
        // showModalBottomSheet(
        //   context: context,
        //   shape: const RoundedRectangleBorder(
        //     borderRadius: BorderRadius.vertical(
        //       top: Radius.circular(25.0),
        //     ),
        //   ),
        //   builder: (BuildContext context) {
        //     return SizedBox(
        //       height: 380, // Increased height to accommodate the new item
        //       child: Padding(
        //         padding: const EdgeInsets.all(15.0),
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           mainAxisSize: MainAxisSize.min,
        //           children: <Widget>[
        //             Expanded(
        //               child: ListView.separated(
        //                 itemCount: 5, // Changed to 5 items
        //                 separatorBuilder: (BuildContext context, int index) =>
        //                     const Divider(),
        //                 itemBuilder: (BuildContext context, int index) {
        //                   return ListTile(
        //                     onTap: () {
        //                       Navigator.pop(context);
        //                       if (index == 0) {
        //                         Get.to(() => BossUpSection(
        //                               industry: category,
        //                               bossUp: controller.categories[0],
        //                             ));
        //                       } else if (index == 1) {
        //                         Get.toNamed(Routes.createPost);
        //                       } else if (index == 2) {
        //                         sellProduct(context);
        //                       } else if (index == 3) {
        //                         Get.toNamed(Routes.createevent);
        //                       } else if (index == 4) {
        //                         Get.to(() => const CreatePollScreen());
        //                       }
        //                     },
        //                     minVerticalPadding: 0,
        //                     contentPadding: const EdgeInsets.only(left: 10),
        //                     leading: index == 4
        //                         ? const Icon(
        //                             Icons.star,
        //                             color: textColor,
        //                           )
        //                         : index == 0
        //                             ? const Icon(
        //                                 Icons.star,
        //                                 color: Colors.black,
        //                               )
        //                             : SvgPicture.asset(
        //                                 index == 1
        //                                     ? 'assets/svgs/text.svg'
        //                                     : index == 2
        //                                         ? 'assets/svgs/sellicon.svg'
        //                                         : 'assets/svgs/eventu.svg',
        //                                 height: index == 1
        //                                     ? 25
        //                                     : index == 2
        //                                         ? 30
        //                                         : 22,
        //                                 color: textColor.withValues(alpha: 1),
        //                               ),
        //                     title: Text(
        //                       index == 0
        //                           ? 'Generate free promotion'
        //                           : index == 1
        //                               ? 'Post content, discussion, etc'
        //                               : index == 2
        //                                   ? 'Sell your product & service'
        //                                   : index == 3
        //                                       ? 'Create an event'
        //                                       : 'Create polls & surveys',
        //                       style: const TextStyle(
        //                         fontSize: 18,
        //                         fontWeight: FontWeight.w700,
        //                       ),
        //                     ),
        //                   );
        //                 },
        //               ),
        //             )
        //           ],
        //         ),
        //       ),
        //     );
        //   },
        // );
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: Platform.isIOS ? 50 : 80, right: 5),
        child: Align(
          alignment: Alignment.bottomRight,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: LinearGradient(
                colors: <Color>[Color(0xFF6366F1), Color(0xFF818CF8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/svgs/bot.svg',
                width: 20,
                height: 22,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
