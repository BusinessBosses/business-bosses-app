import 'package:business_bosses_v2/action/action.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/models/user_model.dart';
import '../../../common/widgets/buttons/my_outlined_button.dart';
import '../../../navigation/routes.dart';
import '../../../utils/theme/theme.dart';

///this is the connect and refer button for only those that have made premium subscription
Widget premiumButtonHeader(
  UserModel publicUser,
  UserModel myProfile,
  VoidCallback onConnect,
  BuildContext context,
) {
  bool connectedbutton = true;
  return Container(
    height: 30.0,
    padding: const EdgeInsets.all(0.0),
    width: 80,
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Expanded(
          child: myProfile.connecteds != null &&
                  myProfile.connecteds!.contains(publicUser.uid)
              ? MCustomButton(
                  buttonType: ButtonType.outlinegrey,
                  margin: const EdgeInsets.only(right: 0.0),
                  child: const FittedBox(
                    child: Text(
                      'Refer',
                      style: TextStyle(
                          color: textColor, fontWeight: FontWeight.w400),
                    ),
                  ),
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
                        path:
                            '/connection/connecteds/referals/${publicUser.uid}');
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
                  })
              : MCustomButton(
                  buttonType: ButtonType.grey,
                  margin: const EdgeInsets.only(right: 0.0),
                  child: const FittedBox(
                    child: Text(
                      'Connect',
                      style: TextStyle(
                          color: textColor, fontWeight: FontWeight.w400),
                    ),
                  ),
                  onPressed: () async {
                    onConnect();
                  }))
    ]),
  );
}

class _sharePost {
  _sharePost(String message);
}
