import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:flutter/material.dart';

import '../../../action/action.dart';
import '../../../common/params.dart';
import '../../../common/widgets/buttons/my_outlined_button.dart';
import '../../../common/widgets/user_avatar_with_badge.dart';
import '../../../utils/theme/theme.dart';
import '../../profile/presentation/publicprofilescreen.dart';

class ConnectionUserItem extends StatelessWidget {
  final UserModel user;
  final bool status;
  final String? label;
  final Function(UserModel)? onChangeConnectionStatus;
  final Function()? onTap;
  final bool? isMe;

  const ConnectionUserItem(
      {Key? key,
      required this.user,
      this.status = false,
      this.label,
      this.onChangeConnectionStatus,
      this.onTap,
      this.isMe})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return user == null
        ? const ListTile(
            title: Text('User may not exist any more'),
          )
        : ListTile(
            onTap: () async {
              var result = await navigateTo(
                context,
                routeName: PublicProfileScreen.routeName,
                arguments: Params(arg1: user.uid),
              );
              if (result == null) {
                Navigator.of(context).pop();
              }
            },
            leading: UserAvatarWithBadge(
              user: user,
              height: 48.0,
              width: 48.0,
              radius: 30.0,
              placeHolder: Icons.person,
              iconSize: 24.0,
            ),
            title: Text(
              user.username,
              maxLines: 1,
            ),
            subtitle: Text(
              user.category ?? user.companyName ?? user.bio ?? '',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            trailing:
                //status == null ||
                //     FirebaseAuth.instance.currentUser.uid == user.uid
                // ? const SizedBox()
                // :
                isMe != null && isMe!
                    ? null
                    : MCustomButton(
                        buttonType:
                            status ? ButtonType.outline : ButtonType.elevated,
                        onPressed: () {
                          onChangeConnectionStatus!(user);
                        },
                        height: 36.0,
                        width: 120.0,
                        child: status
                            ? const Text(
                                'Connected',
                                style: TextStyle(color: primaryColorLT),
                              )
                            : const Text(
                                'Connect',
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
          );
  }
}
