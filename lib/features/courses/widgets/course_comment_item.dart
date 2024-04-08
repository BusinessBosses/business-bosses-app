import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/models/comment_model.dart';
import 'package:business_bosses_v2/features/courses/models/course_model.dart';
import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/posts/models/post_model.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../common/models/user_model.dart';
import '../../../../common/widgets/safety_model.dart';
import '../../../../common/widgets/user_avatar_with_badge.dart';
import '../../../../utils/theme/theme.dart';

import '../../../common/controllers/comment_controller.dart';
import '../../../services/api_service.dart';
import '../../posts/widgets/comment_item.dart';
import '../../posts/widgets/write_comment.dart';

class CourseCommentItem extends StatefulWidget {
  final Function(CommentModel comment) onComment;
  final CourseModel course;

  const CourseCommentItem({
    Key? key,
    required this.onComment,
    required this.course,
  }) : super(key: key);

  @override
  _CourseCommentItemState createState() => _CourseCommentItemState();
}

class _CourseCommentItemState extends State<CourseCommentItem> {
  bool _isLoadingComments = true;

  final CommentController _commentController = Get.put(CommentController());

  @override
  void initState() {
    _loadCommentWithDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Material(
              color: Colors.grey.withOpacity(0.1),
              child: TabBar(
                indicatorColor: Colors.transparent,
                tabs: <Widget>[
                  Tab(
                    child: Text(
                      'Comments',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: _commentController.comments.isEmpty
                          ? SafetyModel(
                              isLoading: _isLoadingComments,
                              icon: SvgPicture.asset(
                                'assets/svgs/comment.svg',
                                height: 80.0,
                                color: hintColor,
                              ),
                              title: 'There is no comment for now',
                              subTitle: 'Be the first one to comment!',
                            )
                          : ListView.builder(
                              reverse: true,
                              itemBuilder: (BuildContext context, int i) {
                                final int j =
                                    _commentController.comments.length -
                                        1 -
                                        i; // reverse index
                                return CommentItem(
                                    _commentController.comments[j]);
                              },
                              itemCount: _commentController.comments.length,
                            ),
                    ),
                    WriteAComment(
                      onCommentSend: (CommentModel comment) {
                        widget.onComment(comment);
                        ApiService.post(
                            path: 'comments',
                            body: <String, dynamic>{
                              ...comment.toMap(),
                              'receiverUid': widget.course.user?.uid
                            });
                        setState(() {
                          _commentController.comments.add(comment);
                        });
                        // _homeController.comment(
                        //   widget.post.postId,
                        //   comment,
                        //   'post',
                        // );
                      },
                      postId: widget.course.id,
                    )
                  ],
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadCommentWithDetails() async {
    await _commentController.fetchComments(widget.course.id);
    setState(() {
      _isLoadingComments = _commentController.loading.value;
    });
  }

  final List<UserModel> _users = <UserModel>[];
}
