import 'package:business_bosses_v2/features/courses/models/course_comment_model.dart';
import 'package:business_bosses_v2/features/posts/widgets/my_container.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../common/models/my_response.dart';
import '../../../common/models/user_model.dart';
import '../../../common/widgets/user_avatar_with_badge.dart';
import '../../../functions/my_native_functions.dart';
import '../../../navigation/routes.dart';
import '../../../utils/theme/theme.dart';
import '../../../utils/time_format.dart';

class CourseCommentItem extends StatefulWidget {
  final CourseCommentModel comment;
  final Function(int)? onPageChange;

  ///
  const CourseCommentItem(this.comment, {super.key, this.onPageChange});

  @override
  State<CourseCommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CourseCommentItem> {
  final ProfileController profileController = Get.find();
  UserModel user = UserModel();
  bool loaded = false;

  @override
  Widget build(BuildContext context) {
    return widget.comment.user != null
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                MyContainer(
                  width: MediaQuery.of(context).size.width * 0.7,
                  padding: const EdgeInsets.only(
                      bottom: 12.0, left: 12.0, right: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ListTile(
                        onTap: () {
                          if (profileController.myProfile.uid ==
                              widget.comment.userId!) {
                            if (widget.onPageChange != null) {
                              widget.onPageChange!(3);
                            }
                          } else {
                            Get.toNamed(Routes.publicProfile,
                                arguments: widget.comment.user);
                          }
                        },
                        leading: UserAvatarWithBadge(
                          user: user,
                          height: 36.0,
                          width: 36.0,
                          radius: 30.0,
                          placeHolder: Icons.person,
                        ),
                        title: widget.comment.user!.isSubscribed == true
                            ? Row(
                                children: <Widget>[
                                  Text(
                                    widget.comment.user?.name ??
                                        widget.comment.user!.username,
                                    style: bodyText1,
                                  ),
                                  const SizedBox(width: 5),
                                  SvgPicture.asset(
                                    'assets/svgs/premiumbadge.svg',
                                    height: 9,
                                    colorFilter: ColorFilter.mode(
                                        primaryColorLT, BlendMode.srcIn),
                                  )
                                ],
                              )
                            : Text(
                                widget.comment.user?.name ??
                                    widget.comment.user!.username,
                                style: bodyText1,
                              ),
                        subtitle: Text(
                          TimeFormat.formatString(widget.comment.timestamp!),
                          style: bodyText2.copyWith(
                            fontSize: 11.0,
                            color: hintColor,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(0.0),
                      ),
                      Linkify(
                        text: '${widget.comment.comment}',
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
                      const SizedBox(height: 4.0),
                    ],
                  ),
                ),
              ],
            ),
          )
        : const SizedBox();
  }

  Future<void> _onUrlClick(
      BuildContext context, LinkableElement linkableElement) async {
    MyResponse res = await MyNativeFunctions.onUrlLaunch(linkableElement.url);
    if (!res.success) {
      Get.snackbar('Error', res.message);
    }
  }
}
