import 'package:flutter/material.dart';

import '../../../action/action.dart';
import '../../../common/models/user_model.dart';
import '../../../common/params.dart';
import '../../../common/widgets/buttons/my_outlined_button.dart';
import '../../../common/widgets/user_avatar_with_badge.dart';
import '../../../utils/theme/theme.dart';
import '../../profile/presentation/publicprofilescreen.dart';

class ConnectionGridTile extends StatelessWidget {
  final UserModel user;
  final bool status;
  final Function()? onChangeConnectionStatus;
  final Function()? onTap;

  const ConnectionGridTile({
    Key? key,
    required this.user,
    required this.status,
    this.onChangeConnectionStatus,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        navigateTo(context,
            routeName: PublicProfileScreen.routeName,
            arguments: Params(arg1: user.uid));
      },
      borderRadius: BorderRadius.circular(radius),
      child: Ink(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius), color: Colors.white),
        child: Column(
          children: [
            UserAvatarWithBadge(
              user: user,
              height: 64.0,
              width: 64.0,
              radius: 64.0,
              placeHolder: Icons.person,
            ),
            const SizedBox(height: 8.0),
            Text(
              'user.name',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 4.0),
            Text(
              user.category ?? user.industry ?? '@${user.username}',
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
            const SizedBox(height: 12.0),
            MCustomButton(
              buttonType: status ? ButtonType.outline : ButtonType.elevated,
              onPressed: onChangeConnectionStatus,
              height: 36.0,
              width: 120.0,
              child: Text(
                status ? 'Connected' : 'Connect',
                style: TextStyle(color: status ? primaryColorLT : Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
