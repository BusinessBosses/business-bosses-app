import 'package:business_bosses_v2/action/action.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../common/models/user_model.dart';
import '../../../navigation/routes.dart';
import '../../../utils/theme/theme.dart';

///this is the connect and refer button for only those that have made premium subscription
Widget premiumButtonHeader(
  UserModel publicUser,
  UserModel myProfile,
  VoidCallback onConnect,
  BuildContext context,
) {
  // ignore: unused_local_variable
  bool connectedbutton = true;
  return Container(
    height: 30.0,
    padding: const EdgeInsets.all(0.0),
    width: 80,
    child: Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
      Expanded(
          child: myProfile.connecteds != null &&
                  myProfile.connecteds!.contains(publicUser.uid)
              ? GestureDetector(
                  onTap: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
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
                        logEvent(publicUser.uid, 'user');
                        socialShare(message);
                      } else {
                        Get.toNamed(
                          Routes.referscreen,
                          arguments: <String, dynamic>{'user': publicUser},
                        );
                      }
                    }
                  },
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey.shade100,
                    child: Icon(
                      LucideIcons.forward,
                      size: 16,
                      color: textColor,
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: () async {
                    onConnect();
                  },
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey.shade100,
                    child: Icon(
                      LucideIcons.userPlus,
                      size: 16,
                      color: textColor,
                    ),
                  ),
                )),
    ]),
  );
}

// class _sharePost {
//   _sharePost(String message);
// }
