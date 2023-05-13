import 'package:business_bosses_v2/common/models/comment_model.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../common/widgets/user_avatar_with_badge.dart';
import '../../../../utils/theme/theme.dart';
import 'my_container.dart';

class WriteAComment extends StatefulWidget {
  final Function(CommentModel) onCommentSend;

  const WriteAComment({Key? key, required this.onCommentSend})
      : super(key: key);

  @override
  _WriteACommentState createState() => _WriteACommentState();
}

class _WriteACommentState extends State<WriteAComment> {
  final _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MyContainer(
      margin: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
      padding: const EdgeInsets.all(8.0),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          UserAvatarWithBadge(
            user: ProfileController().myProfile,
            height: 32.0,
            width: 32.0,
            radius: 30.0,
            placeHolder: Icons.person,
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: TextFormField(
              controller: _commentController,
              textInputAction: TextInputAction.newline,
              maxLines: 2,
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Write a Comment...',
                contentPadding: const EdgeInsets.all(0.0),
                hintStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: hintColor),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(width: 4.0),
          IconButton(
            onPressed: () {
              if (_commentController.text.isEmpty) {
                return;
              }
              String text = _commentController.text;
              final appUser = ProfileController().myProfile;

              setState(() {
                _commentController.text = '';
              });
            },
            icon: SvgPicture.asset(
              'assets/svgs/send.svg',
              height: 20.0,
              width: 20.0,
            ),
          ),
        ],
      ),
    );
  }
}
