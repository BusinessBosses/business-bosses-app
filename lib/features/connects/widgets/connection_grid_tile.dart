import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../common/models/user_model.dart';
import '../../../common/widgets/user_avatar_with_badge.dart';
import '../../../navigation/routes.dart';
import '../../../utils/theme/theme.dart';

class ConnectionGridTile extends StatefulWidget {
  final UserModel user;
  final bool status;
  final Function()? onChangeConnectionStatus;
  final Function()? onTap;
  final Color? color;

  @override
  State<ConnectionGridTile> createState() => _ConnectionGridTileState();

  const ConnectionGridTile({
    super.key,
    required this.user,
    required this.status,
    this.onChangeConnectionStatus,
    this.onTap,
    this.color,
  });
}

class _ConnectionGridTileState extends State<ConnectionGridTile> {
  String truncateWithEllipsis(int maxLength, String text) {
    return (text.length <= maxLength)
        ? text
        : '${text.substring(0, maxLength)}...';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(Routes.publicProfile, arguments: widget.user);
      },
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: widget.color ?? Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Avatar
            UserAvatarWithBadge(
              user: widget.user,
              height: 64.0,
              width: 64.0,
              radius: 64.0,
              placeHolder: Icons.person,
            ),

            const SizedBox(height: 8.0),

            // Name and Badge Section - Fixed Height
            SizedBox(
              height: 40,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Name with optional premium badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          truncateWithEllipsis(
                            15,
                            widget.user.name ?? widget.user.username,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      if (widget.user.isSubscribed == true) ...<Widget>[
                        const SizedBox(width: 4),
                        SvgPicture.asset(
                          'assets/svgs/premiumbadge.svg',
                          height: 12,
                          colorFilter: ColorFilter.mode(
                            primaryColorLT,
                            BlendMode.srcIn,
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 4.0),

                  // Category
                  Text(
                    widget.user.category?.toString() ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF616161),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8.0),

            // Follow Button
            SizedBox(
              width: double.infinity,
              height: 36,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      widget.status ? Colors.white : primaryColorLT,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(radius),
                    side: BorderSide(
                      color: widget.status ? primaryColorLT : Colors.white,
                      width: 1.0,
                    ),
                  ),
                ),
                onPressed: widget.onChangeConnectionStatus,
                child: Text(
                  widget.status ? 'Following' : 'Follow',
                  style: TextStyle(
                    color: widget.status ? primaryColorLT : Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
