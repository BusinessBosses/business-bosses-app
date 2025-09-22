import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/features/courses/controller/course_comment_controller.dart';
import 'package:business_bosses_v2/features/courses/models/course_comment_model.dart';
import 'package:business_bosses_v2/features/courses/models/course_model.dart';
import 'package:business_bosses_v2/features/courses/widgets/course_comment_item.dart';
import 'package:business_bosses_v2/features/courses/widgets/write_coursecomment.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../common/models/user_model.dart';
import '../../../../common/widgets/safety_model.dart';
import '../../../../common/widgets/user_avatar_with_badge.dart';
import '../../../../utils/theme/theme.dart';

import '../../../services/api_service.dart';

class CourseCommentBottomSheet extends StatefulWidget {
  final Function(CourseCommentModel comment) onComment;
  final CourseModel course;

  const CourseCommentBottomSheet({
    super.key,
    required this.onComment,
    required this.course,
  });

  @override
  State<CourseCommentBottomSheet> createState() =>
      _CourseCommentBottomSheetState();
}

class _CourseCommentBottomSheetState extends State<CourseCommentBottomSheet> {
  bool _isLoadingComments = true, _isLoadingLikes = true;

  final CourseCommentController _commentController =
      Get.put(CourseCommentController());
  final ProfileController profileController = Get.find();

  @override
  void initState() {
    _loadCommentWithDetails();
    _loadLikesWithDetails(widget.course.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Material(
              color: Colors.grey.withValues(alpha: 0.1),
              child: TabBar(
                indicatorColor: primaryColorLT,
                tabs: <Widget>[
                  Tab(
                    child: Text(
                      'Comments',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Likes',
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
                                colorFilter: ColorFilter.mode(
                                    hintColor, BlendMode.srcIn),
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
                                return CourseCommentItem(
                                    _commentController.comments[j]);
                              },
                              itemCount: _commentController.comments.length,
                            ),
                    ),
                    WriteAComment(
                      onCommentSend: (CourseCommentModel comment) {
                        widget.onComment(comment);
                        ApiService.post(
                            path: 'course-comments',
                            body: <String, dynamic>{
                              ...comment.toMap(),
                              'receiverUid': widget.course.user?.uid
                            });
                        setState(() {
                          _commentController.comments
                              .add(CourseCommentModel.fromMap(<String, dynamic>{
                            ...comment.toMap(),
                            'user': profileController.myProfile.toMap(),
                          }));
                          widget.course.comments?.add(
                              CourseCommentModel.fromMap(<String, dynamic>{
                            ...comment.toMap(),
                            'user': profileController.myProfile.toMap(),
                          }));
                        });
                      },
                      courseId: widget.course.id,
                      receiverUid: widget.course.userId,
                    )
                  ],
                ),
                _users.isEmpty
                    ? SafetyModel(
                        isLoading: _isLoadingLikes,
                        icon: const Icon(
                          Icons.thumb_up,
                          size: 80.0,
                          color: hintColor,
                        ),
                        title: 'There is no like for now',
                        subTitle: 'Be the first one to like!',
                      )
                    : ListView.builder(
                        itemCount: _users.length,
                        itemBuilder: (BuildContext context, int i) {
                          return ListTile(
                            leading: UserAvatarWithBadge(
                              user: _users[i],
                              height: 48.0,
                              width: 48.0,
                              radius: 30.0,
                              placeHolder: Icons.person,
                            ),
                            title: _users[i].isSubscribed == true
                                ? Row(
                                    children: <Widget>[
                                      Text('${_users[i].name}'),
                                      const SizedBox(width: 5),
                                      SvgPicture.asset(
                                        'assets/svgs/premiumbadge.svg',
                                        height: 9,
                                        colorFilter: ColorFilter.mode(
                                            primaryColorLT, BlendMode.srcIn),
                                      )
                                    ],
                                  )
                                : Text('${_users[i].name}'),
                            subtitle: Text(
                              '${_users[i].bio}',
                              maxLines: 1,
                            ),
                          );
                        },
                      )
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

  Future<void> _loadLikesWithDetails(String forumId) async {
    final ApiResponseModel response =
        await ApiService.get(path: 'likes/post/$forumId');
    if (response.success) {
      for (int i = 0; i < response.data['rows'].length; i++) {
        _users.add(UserModel.fromMap(response.data['rows'][i]['user']));
      }
    }
    if (mounted) {
      setState(() {
        _isLoadingLikes = false;
      });
    }
  }
}
