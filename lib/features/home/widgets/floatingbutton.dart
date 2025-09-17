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
        //Get.to(() => AiChatScreen());
        Get.to(() => ExpandedMatchesScreen());
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
