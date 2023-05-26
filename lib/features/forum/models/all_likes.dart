import 'package:flutter/material.dart';

import '../../../common/models/user_model.dart';
import '../../../common/widgets/user_avatar_with_badge.dart';

class AllLikes extends StatelessWidget {
  final List<UserModel> postLikedByUser;

  const AllLikes(this.postLikedByUser, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: postLikedByUser.length,
      itemBuilder: (context, i) {
        return ListTile(
          leading: UserAvatarWithBadge(
            user: postLikedByUser[i],
            height: 48.0,
            width: 48.0,
            radius: 30.0,
            placeHolder: Icons.person,
          ),
          title: Text(postLikedByUser[i].name!),
          subtitle: Text(
            postLikedByUser[i].bio!,
            maxLines: 1,
          ),
        );
      },
    );
  }
}
