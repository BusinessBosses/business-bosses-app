import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../common/models/user_model.dart';
import '../../../common/widgets/buttons/my_outlined_button.dart';
import '../../../utils/theme/theme.dart';

///this is the connect and refer button for only those that have made premium subscription
Widget premiumButtonHeader(
  UserModel publicUser,
  UserModel myProfile,
  VoidCallback onConnect,
) {
  bool connectedbutton = true;
  return Container(
    height: 30.0,
    padding: const EdgeInsets.all(0.0),
    width: myProfile.connecteds != null &&
            myProfile.connecteds!.contains(publicUser.uid)
        ? 90
        : 80,
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Expanded(
          child: MCustomButton(
              buttonType: myProfile.connecteds != null &&
                      myProfile.connecteds!.contains(publicUser.uid)
                  ? ButtonType.outlinegrey
                  : ButtonType.grey,
              margin: const EdgeInsets.only(right: 0.0),
              child: FittedBox(
                child: myProfile.connecteds != null &&
                        myProfile.connecteds!.contains(publicUser.uid)
                    ? const Text(
                        'Connected',
                        style: TextStyle(
                            color: textColor, fontWeight: FontWeight.w400),
                      )
                    : const Text(
                        'Connect',
                        style: TextStyle(
                            color: textColor, fontWeight: FontWeight.w400),
                      ),
              ),
              onPressed: () async {
                onConnect();
              })),
      // Expanded(
      //     child: MCustomButton(
      //   buttonType: ButtonType.outlinegrey,
      //   margin: const EdgeInsets.only(right: 20.0),
      //   onPressed: () async {
      //     if (myProfile.connectedCount == 0 && myProfile.connectionCount == 0) {
      //       String message =
      //           'Have a look at ${publicUser.username}\'s profile on Business Bosses\n'
      //           'https://businessbosses.onelink.me/xLWk/36a2ff16';
      //       socialShare(message);
      //     } else {
      //       Get.toNamed(Routes.referscreen, arguments: {'user': publicUser});
      //     }
      //   },
      //   child: const Text('Refer',
      //       style: TextStyle(
      //           color: Color(0xFF4B4B4B), fontWeight: FontWeight.w600)),
      // )),
    ]),
  );
}

class _sharePost {
  _sharePost(String message);
}
