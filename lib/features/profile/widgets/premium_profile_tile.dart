import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../action/action.dart';
import '../../../common/models/user_model.dart';
import '../../../common/widgets/buttons/my_outlined_button.dart';
import '../../../utils/theme/theme.dart';
import '../controller/profile_controller.dart';

///this is the connect and refer button for only those that have made premium subscription
Widget premiumButtonHeader(
  UserModel publicUser,
  UserModel myProfile,
  VoidCallback onConnect,
) {
  final ProfileController profileController = Get.find();
  bool connectedbutton = true;
  return Container(
    height: 38.0,
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
            onPressed: () async {
              if (profileController.myProfile.connectedCount == 0 &&
                  profileController.myProfile.connectionCount == 0) {
                String message =
                    'Have a look at ${publicUser.username}\'s profile on Business Bosses\n'
                    'https://businessbosses.onelink.me/xLWk/36a2ff16';
                socialShare(message);
              } else {
                Get.toNamed(Routes.referscreen,
                    arguments: {'user': publicUser});
              }
            },
            child: const Text('Refer')),
      ),
    ]),
  );
}

class _sharePost {
  _sharePost(String message);
}
