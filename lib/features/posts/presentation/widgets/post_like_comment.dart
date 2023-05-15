import 'package:business_bosses_v2/common/models/comment_model.dart';
import 'package:business_bosses_v2/features/posts/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../common/models/api_response_model.dart';
import '../../../../common/models/my_user.dart';
import '../../../../common/models/user_model.dart';
import '../../../../common/widgets/safety_model.dart';
import '../../../../common/widgets/user_avatar_with_badge.dart';
import '../../../../services/api_service.dart';
import '../../../../utils/constants/constants.dart';
import '../../../../utils/theme/theme.dart';
import '../../../profile/controller/profile_controller.dart';
import 'comment_item.dart';
import 'write_comment.dart';

class PostLikeCommentItem extends StatefulWidget {
  final Function(CommentModel comment) onComment;
  final PostModel post;

  const PostLikeCommentItem({
    Key? key,
    required this.onComment,
    required this.post,
  }) : super(key: key);

  @override
  _PostLikeCommentItemState createState() => _PostLikeCommentItemState();
}

class _PostLikeCommentItemState extends State<PostLikeCommentItem> {
  bool _isInit = false;
  bool _isLoadingLikes = true, _isLoadingComments = true;

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      _loadCommentWithDetails();
      _loadLikesWithDetails();
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
          children: [
            Material(
              color: Colors.grey.withOpacity(0.1),
              child: TabBar(
                tabs: [
                  Tab(
                    child: Text(
                      'Comments',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Likes',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: _comments.isEmpty
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
                                      _comments.length - 1 - i; // reverse index
                                  return CommentItem(_comments[j]);
                                },
                                itemCount: _comments.length,
                              ),
                      ),
                      WriteAComment(
                        onCommentSend: (CommentModel comment) {
                          widget.onComment(comment);
                          setState(() {
                            _comments.add(comment);
                          });
                        },
                        postId: widget.post.postId,
                      )
                    ],
                  ),
                  _users.isEmpty
                      ? SafetyModel(
                          isLoading: _isLoadingLikes,
                          icon: const Icon(
                            Icons.favorite,
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
                                user: ProfileController().myProfile,
                                height: 48.0,
                                width: 48.0,
                                radius: 30.0,
                                placeHolder: Icons.person,
                              ),
                              title: Text('${_users[i].name}'),
                              subtitle: Text(
                                '${_users[i].bio}',
                                maxLines: 1,
                              ),
                            );
                          },
                        )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  final List<CommentModel> _comments = <CommentModel>[];

  Future<void> _loadCommentWithDetails() async {
    for (CommentModel c in widget.post.comments ?? []) {
      _comments.add(CommentModel(
        commentId: c.commentId,
        userId: c.userId,
        comment: c.comment,
        timestamp: c.timestamp,
      ));
    }
    setState(() {
      _isLoadingComments = false;
    });
  }

  final List<UserModel> _users = [];

  Future<void> _loadLikesWithDetails() async {
    final ApiResponseModel response =
        await ApiService.get(path: 'users/${widget.post.user!.uid}');
    for (dynamic l in widget.post.likes ?? []) {
      _users.add(UserModel(
          uid: widget.post.user!.uid,
          name: response.data['name'],
          bio: response.data['bio']));
    }
    setState(() {
      _isLoadingLikes = false;
    });
  }
}
