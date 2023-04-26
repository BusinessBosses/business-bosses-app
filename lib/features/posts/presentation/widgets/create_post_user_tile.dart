// ignore_for_file: public_member_api_docs

import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/common/widgets/user_avatar_with_badge.dart';
import 'package:flutter/material.dart';

class CreatePostUserTile extends StatelessWidget {
  const CreatePostUserTile({Key? key, required this.user}) : super(key: key);

  final UserModel user;

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
          child: Text(
            user.name!,
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
