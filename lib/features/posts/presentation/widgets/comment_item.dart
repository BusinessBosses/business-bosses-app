import 'package:business_bosses_v2/common/models/comment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

import '../../../../action/action.dart';
import '../../../../common/models/my_response.dart';
import '../../../../common/widgets/user_avatar_with_badge.dart';
import '../../../../functions/my_native_functions.dart';
import '../../../../utils/theme/theme.dart';
import '../../../../utils/time_format.dart';
import 'my_container.dart';

class CommentItem extends StatelessWidget {
  final CommentModel comment;

  const CommentItem(this.comment, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyContainer(
            width: MediaQuery.of(context).size.width * 0.7,
            padding:
                const EdgeInsets.only(bottom: 12.0, left: 12.0, right: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: UserAvatarWithBadge(
                    user: comment.user,
                    height: 36.0,
                    width: 36.0,
                    radius: 30.0,
                    placeHolder: Icons.person,
                  ),
                  title: const Text(
                    'text',
                    style: bodyText1,
                  ),
                  subtitle: Text(
                    TimeFormat.formatString(12222444334),
                    style: bodyText2.copyWith(
                      fontSize: 11.0,
                      color: hintColor,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(0.0),
                ),
                Linkify(
                  text: 'Comment here',
                  style: bodyText2.copyWith(
                    fontWeight: FontWeight.normal,
                  ),
                  onOpen: (LinkableElement linkableElement) =>
                      _onUrlClick(context, linkableElement),
                  options: const LinkifyOptions(humanize: false),
                  linkStyle: bodyText2.copyWith(
                    color: Colors.blue,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                // Text(
                //   '${comment?.comment ?? ''}',
                //   style: bodyText2,
                // ),
                const SizedBox(height: 4.0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onUrlClick(
      BuildContext context, LinkableElement linkableElement) async {
    MyResponse res = await MyNativeFunctions.onUrlLaunch(linkableElement.url);
    if (!res.success) {
      showSnackBar(context, message: res.message);
    }
  }
}
