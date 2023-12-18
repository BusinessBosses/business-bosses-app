import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../common/models/user_model.dart';
import '../../../common/widgets/buttons/my_outlined_button.dart';
import '../../../common/widgets/user_avatar_with_badge.dart';
import '../../../navigation/routes.dart';
import '../../../utils/theme/theme.dart';
import '../../search/controller/search_controller.dart';

class ConnectionGridTile extends StatefulWidget {
  final UserModel user;
  final bool status;
  final Function()? onChangeConnectionStatus;
  final Function()? onTap;

  @override
  State<ConnectionGridTile> createState() => _ConnectionGridTileState();

  const ConnectionGridTile({
    Key? key,
    required this.user,
    required this.status,
    this.onChangeConnectionStatus,
    this.onTap,
  }) : super(key: key);
}

class _ConnectionGridTileState extends State<ConnectionGridTile> {
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    CompleteSearchController controller = Get.find();
    return InkWell(
      onTap: () {
        Get.toNamed(Routes.publicProfile, arguments: widget.user);
      },
      borderRadius: BorderRadius.circular(radius),
      child: Ink(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius), color: Colors.white),
        child: Column(
          children: <Widget>[
            UserAvatarWithBadge(
              user: widget.user,
              height: 64.0,
              width: 64.0,
              radius: 64.0,
              placeHolder: Icons.person,
            ),
            const SizedBox(height: 8.0),
            widget.user.isSubscribed == true
                ? Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          widget.user.name ?? widget.user.username,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(width: 5),
                        SvgPicture.asset(
                          'assets/svgs/premiumbadge.svg',
                          height: 9,
                          color: primaryColorLT,
                        )
                      ],
                    ),
                  )
                : Text(
                    widget.user.name ?? widget.user.username,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
            const SizedBox(height: 4.0),
            if (widget.user.category != null)
              Text(widget.user.category.toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                  )),
            const SizedBox(height: 12.0),
            MCustomButton(
              buttonType:
                  widget.status ? ButtonType.outline : ButtonType.elevated,
              onPressed: widget.onChangeConnectionStatus,
              height: 36.0,
              width: 120.0,
              child: Text(
                widget.status ? 'Connected' : 'Connect',
                style: TextStyle(
                    color: widget.status ? primaryColorLT : Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
