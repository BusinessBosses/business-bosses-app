import 'package:business_bosses_v2/common/models/comment_model.dart';
import 'package:business_bosses_v2/features/courses/models/course_comment_model.dart';
import 'package:business_bosses_v2/features/posts/widgets/my_container.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../common/widgets/user_avatar_with_badge.dart';
import '../../../utils/theme/theme.dart';


class WriteAComment extends StatefulWidget {
  final Function(CourseCommentModel) onCommentSend;
  final String? courseId;
    final String? receiverUid;

  const WriteAComment({Key? key, required this.onCommentSend, this.courseId, this.receiverUid,})
      : super(key: key);

  @override
  _WriteACommentState createState() => _WriteACommentState();
}

class _WriteACommentState extends State<WriteAComment> {
  final TextEditingController _commentController = TextEditingController();
  final ProfileController _profileController = Get.find();

  @override
  Widget build(BuildContext context) {
    return MyContainer(
      margin: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
      padding: const EdgeInsets.all(8.0),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          UserAvatarWithBadge(
            user: _profileController.myProfile,
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
            onPressed: () async {
              if (_commentController.text.trim().isEmpty) {
                // Text is empty or contains only whitespace characters
                return;
              }
              String text = _commentController.text;
              CourseCommentModel comment = CourseCommentModel(
                receiverUid: widget.receiverUid,
                courseId: widget.courseId,
                comment: text,
                userId: _profileController.myProfile.uid,
                timestamp: DateTime.now().millisecondsSinceEpoch,
              );
              widget.onCommentSend(comment);

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
