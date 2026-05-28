import 'package:business_bosses_v2/action/action.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../common/models/user_model.dart';
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
                    String message =
                        'Have a look at ${publicUser.username}\'s profile on Business Bosses\n'
                        'https://businessbosses.onelink.me/xLWk/36a2ff16';
                    logEvent(publicUser.uid, 'user');
                    socialShare(message);
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
