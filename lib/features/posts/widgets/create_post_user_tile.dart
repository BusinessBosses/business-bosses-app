// ignore_for_file: public_member_api_docs

import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/common/widgets/user_avatar_with_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../utils/theme/theme.dart';

class CreatePostUserTile extends StatelessWidget {
  const CreatePostUserTile({super.key, this.user});

  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        UserAvatarWithBadge(
          user: user,
          height: 36.0,
          width: 36.0,
          radius: 36.0,
          placeHolder: Icons.person,
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: user!.isSubscribed == true
              ? Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        user!.name ?? user!.username,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(width: 5),
                      SvgPicture.asset(
                        'assets/svgs/premiumbadge.svg',
                        height: 9,
                        colorFilter: const ColorFilter.mode(
                            primaryColorLT, BlendMode.srcIn),
                      )
                    ],
                  ),
                )
              : Text(
                  user!.name ?? user!.username,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
        ),
      ],
    );
  }
}
