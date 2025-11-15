import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../action/action.dart';
import '../../../common/models/user_model.dart';
import '../../../common/widgets/buttons/my_outlined_button.dart';
import '../../../utils/theme/theme.dart';
import '../../chat/chat_room_screen.dart';

Widget outlineButtonHeader(UserModel publicUser, UserModel myProfile,
    VoidCallback onConnect, BuildContext context) {
  return Container(
    height: 50.0,
    padding: const EdgeInsets.all(4.0),
    width: double.infinity,
    child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: MCustomButton(
              buttonType: myProfile.connecteds != null &&
                      myProfile.connecteds!.contains(publicUser.uid)
                  ? ButtonType.outline
                  : ButtonType.elevated,
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: FittedBox(
                child: myProfile.connecteds != null &&
                        myProfile.connecteds!.contains(publicUser.uid)
                    ? const Text(
                        'Following',
                        style: TextStyle(color: primaryColorLT),
                      )
                    : const Text(
                        'Follow',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
              onPressed: () async {
                onConnect();
              },
            ),
          ),
          Expanded(
            child: MCustomButton(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              onPressed: () {
                Get.to(
                  () => const ChatRoomScreen(
                    frommarketplace: false,
                  ),
                  arguments: publicUser,
                );
              },
              child: const Text('Message'),
            ),
          ),
          Expanded(
            child: MCustomButton(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                onPressed: () async {
                  String message =
                      'Check out ${publicUser.username}\'s profile on Business Bosses\n'
                      'https://businessbosses.onelink.me/xLWk/36a2ff16';
                  socialShare(message);
                },
                child: const Text('Share')),
          ),
        ]),
  );
}

// class _sharePost {
//   _sharePost(String message);
// }
