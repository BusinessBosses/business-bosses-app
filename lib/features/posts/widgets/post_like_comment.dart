import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/models/comment_model.dart';
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
  bool _isLoadingLikes = true, _isLoadingComments = true;
  final CommentController _commentController = Get.put(CommentController());
  final HomeController _homeController = Get.find();

  @override
  void initState() {
    _loadCommentWithDetails();
    _loadLikesWithDetails(widget.post.postId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length:
          widget.post.reposts != null && widget.post.reposts!.isEmpty ? 2 : 3,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Material(
              color: Colors.grey.withOpacity(0.1),
              child: TabBar(
                tabs:
                    widget.post.reposts != null && widget.post.reposts!.isEmpty
                        ? <Widget>[
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
                          ]
                        : <Widget>[
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
                            Tab(
                              child: Text(
                                'Reposts',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: widget.post.reposts != null &&
                        widget.post.reposts!.isEmpty
                    ? <Widget>[
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
                                      itemBuilder:
                                          (BuildContext context, int i) {
                                        final int j =
                                            _commentController.comments.length -
                                                1 -
                                                i; // reverse index
                                        return CommentItem(
                                            _commentController.comments[j]);
                                      },
                                      itemCount:
                                          _commentController.comments.length,
                                    ),
                            ),
                            WriteAComment(
                              onCommentSend: (CommentModel comment) {
                                widget.onComment(comment);
                                ApiService.post(
                                    path: 'comments',
                                    body: <String, dynamic>{
                                      ...comment.toMap(),
                                      'receiverUid': widget.post.user?.uid
                                    });
                                setState(() {
                                  _commentController.comments.add(comment);
                                });
                                _homeController.comment(
                                  widget.post.postId,
                                  comment,
                                  'post',
                                );
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
                                    onTap: () {
                                      Get.toNamed(Routes.publicProfile,
                                          arguments: _users[i]);
                                    },
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
                                              Text(_users[i].name!),
                                              const SizedBox(width: 5),
                                              SvgPicture.asset(
                                                'assets/svgs/premiumbadge.svg',
                                                height: 9,
                                                color: primaryColorLT,
                                              )
                                            ],
                                          )
                                        : Text(_users[i].name!),
                                    subtitle: Text(
                                      '${_users[i].bio}',
                                      maxLines: 1,
                                    ),
                                  );
                                },
                              )
                      ]
                    : <Widget>[
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
                                      itemBuilder:
                                          (BuildContext context, int i) {
                                        final int j =
                                            _commentController.comments.length -
                                                1 -
                                                i; // reverse index
                                        return CommentItem(
                                            _commentController.comments[j]);
                                      },
                                      itemCount:
                                          _commentController.comments.length,
                                    ),
                            ),
                            WriteAComment(
                              onCommentSend: (CommentModel comment) {
                                widget.onComment(comment);
                                ApiService.post(
                                    path: 'comments',
                                    body: <String, dynamic>{
                                      ...comment.toMap(),
                                      'receiverUid': widget.post.user?.uid
                                    });
                                setState(() {
                                  _commentController.comments.add(comment);
                                });
                                _homeController.comment(
                                  widget.post.postId,
                                  comment,
                                  'post',
                                );
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
                                    onTap: () {
                                      Get.toNamed(Routes.publicProfile,
                                          arguments: _users[i]);
                                    },
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
                                              Text(_users[i].name!),
                                              const SizedBox(width: 5),
                                              SvgPicture.asset(
                                                'assets/svgs/premiumbadge.svg',
                                                height: 9,
                                                color: primaryColorLT,
                                              )
                                            ],
                                          )
                                        : Text(_users[i].name!),
                                    subtitle: Text(
                                      '${_users[i].bio}',
                                      maxLines: 1,
                                    ),
                                  );
                                },
                              ),
                        _reposters.isEmpty
                            ? SafetyModel(
                                isLoading: _isLoadingLikes,
                                icon: const Icon(
                                  Icons.favorite,
                                  size: 0.0,
                                  color: hintColor,
                                ),
                                title: 'There are no reposts for now',
                                subTitle: 'Be the first one to repost!',
                              )
                            : ListView.builder(
                                itemCount: _reposters.length,
                                itemBuilder: (BuildContext context, int i) {
                                  return ListTile(
                                    onTap: () {
                                      Get.toNamed(Routes.publicProfile,
                                          arguments: _reposters[i]);
                                    },
                                    leading: UserAvatarWithBadge(
                                      user: _reposters[i],
                                      height: 48.0,
                                      width: 48.0,
                                      radius: 30.0,
                                      placeHolder: Icons.person,
                                    ),
                                    title: _reposters[i].isSubscribed == true
                                        ? Row(
                                            children: <Widget>[
                                              Text(_users[i].name!),
                                              const SizedBox(width: 5),
                                              SvgPicture.asset(
                                                'assets/svgs/premiumbadge.svg',
                                                height: 9,
                                                color: primaryColorLT,
                                              )
                                            ],
                                          )
                                        : Text(_reposters[i].name!),
                                    subtitle: Text(
                                      '${_reposters[i].bio}',
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

  Future<void> _loadCommentWithDetails() async {
    await _commentController.fetchComments(widget.post.postId);
    setState(() {
      _isLoadingComments = _commentController.loading.value;
    });
  }

  final List<UserModel> _users = <UserModel>[];

  Future<void> _loadLikesWithDetails(String postId) async {
    final ApiResponseModel response =
        await ApiService.get(path: 'likes/post/$postId');
    if (response.success) {
      for (int i = 0; i < response.data['rows'].length; i++) {
        _users.add(UserModel.fromMap(response.data['rows'][i]['user']));
      }
    }
    // for (dynamic l in widget.post.likes ?? []) {
    //   final Map<String, dynamic> response = await ProfileController.loadData(l);
    //   _users.add(
    //     UserModel(
    //         uid: l,
    //         name: response['user']['name'] ?? response['user']['username'],
    //         bio: response['user']['bio']),
    //   );
    // }
    if (mounted) {
      setState(() {
        _isLoadingLikes = false;
      });
    }
  }

  final List<UserModel> _reposters = <UserModel>[];

  Future<void> _loadRepostsWithDetails(String postId) async {
    final ApiResponseModel response =
        await ApiService.get(path: 'reposts/post/$postId');
    if (response.success) {
      for (int i = 0; i < response.data['rows'].length; i++) {
        _reposters.add(UserModel.fromMap(response.data['rows'][i]['user']));
      }
    }
    // for (dynamic l in widget.post.likes ?? []) {
    //   final Map<String, dynamic> response = await ProfileController.loadData(l);
    //   _users.add(
    //     UserModel(
    //         uid: l,
    //         name: response['user']['name'] ?? response['user']['username'],
    //         bio: response['user']['bio']),
    //   );
    // }
    if (mounted) {
      setState(() {
        _isLoadingLikes = false;
      });
    }
  }
}
