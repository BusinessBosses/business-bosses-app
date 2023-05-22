import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/models/user_model.dart';
import '../../../common/widgets/buttons/my_outlined_button.dart';
import '../../../utils/theme/theme.dart';

Widget OutlineButtonHeader(UserModel publicUser, UserModel myProfile,
    VoidCallback onConnect, onRefer) {
  bool connectedbutton = true;

  return Container(
    height: 50.0,
    padding: const EdgeInsets.all(4.0),
    width: double.infinity,
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Expanded(
          child: MCustomButton(
              buttonType: connectedbutton == true
                  ? ButtonType.outline
                  : ButtonType.elevated,
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: FittedBox(
                child: myProfile.connecteds != null &&
                        myProfile.connecteds!.contains(publicUser.uid)
                    ? const Text(
                        'Connected',
                        style: TextStyle(color: primaryColorLT),
                      )
                    : const Text(
                        'Connect',
                        style: TextStyle(color: primaryColorLT),
                      ),
              ),
              onPressed: () async {
                onConnect();
              })),
      Expanded(
        child: MCustomButton(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          onPressed: () {
            Get.toNamed(Routes.chatRoom, arguments: publicUser);
          },
          child: const Text('Message'),
        ),
      ),
      Expanded(
        child: MCustomButton(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            onPressed: () async {
              Get.toNamed(Routes.referscreen,
                  arguments: {'user': publicUser, 'onRefer': onRefer});
            },
            child: const Text('Refer')),
      ),
    ]),
  );
}

class _sharePost {
  _sharePost(String message);
}
