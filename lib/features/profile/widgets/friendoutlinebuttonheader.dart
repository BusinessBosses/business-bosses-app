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

Widget OutlineButtonHeader(UserModel publicUser, UserModel myProfile,
    VoidCallback onConnect, BuildContext context) {
  return Container(
    height: 50.0,
    padding: const EdgeInsets.all(4.0),
    width: double.infinity,
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
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
                    'Connected',
                    style: TextStyle(color: primaryColorLT),
                  )
                : const Text(
                    'Connect',
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
              () => ChatRoomScreen(
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
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                      ],
                    ),
                  );
                },
              );
              final ApiResponseModel res = await ApiService.get(
                  path: '/connection/connecteds/referals/${publicUser.uid}');
              Navigator.pop(context);

              if (res.success) {
                if (res.data.isEmpty) {
                  String message =
                      'Have a look at ${publicUser.username}\'s profile on Business Bosses\n'
                      'https://businessbosses.onelink.me/xLWk/36a2ff16';
                  socialShare(message);
                } else {
                  Get.toNamed(
                    Routes.referscreen,
                    arguments: <String, dynamic>{'user': publicUser},
                  );
                }
              }

              // if (profileController.myProfile.connectedCount == 0 &&
              //     profileController.myProfile.connectionCount == 0) {
              //   String message =
              //       'Have a look at ${publicUser.username}\'s profile on Business Bosses\n'
              //       'https://businessbosses.onelink.me/xLWk/36a2ff16';
              //   socialShare(message);
              // } else {
              //   Get.toNamed(Routes.referscreen,
              //       arguments: {'user': publicUser});
              // }
            },
            child: const Text('Refer')),
      ),
    ]),
  );
}

class _sharePost {
  _sharePost(String message);
}
