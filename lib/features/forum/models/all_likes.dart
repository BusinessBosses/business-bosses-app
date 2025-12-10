import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../common/models/user_model.dart';
import '../../../common/widgets/user_avatar_with_badge.dart';
import '../../../utils/theme/theme.dart';

class AllLikes extends StatelessWidget {
  final List<UserModel> postLikedByUser;

  const AllLikes(this.postLikedByUser, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: postLikedByUser.length,
      itemBuilder: (BuildContext context, int i) {
        return ListTile(
          leading: UserAvatarWithBadge(
            user: postLikedByUser[i],
            height: 48.0,
            width: 48.0,
            radius: 30.0,
            placeHolder: Icons.person,
          ),
          title: postLikedByUser[i].isSubscribed == true
              ? Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: Row(
                    children: <Widget>[
                      Text(postLikedByUser[i].name!),
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
              : Text(postLikedByUser[i].name!),
          subtitle: Text(
            postLikedByUser[i].bio!,
            maxLines: 1,
          ),
        );
      },
    );
  }
}
