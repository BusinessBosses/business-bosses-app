import 'package:business_bosses_v2/common/models/comment_model.dart';
import 'package:business_bosses_v2/features/forum/models/all_comments.dart';
import 'package:business_bosses_v2/features/forum/models/forum_model.dart';
import 'package:business_bosses_v2/features/posts/widgets/write_comment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../action/action.dart';
import '../../../common/models/user_model.dart';
import '../../../common/widgets/safety_model.dart';
import '../../../utils/constants/constants.dart';
import '../../../utils/theme/theme.dart';
import '../models/all_likes.dart';

class ForumLikeCommentScreen extends StatefulWidget {
  static const String routeName = '/forum-like-comment-screen';

  const ForumLikeCommentScreen({Key? key, this.forum, this.commented})
      : super(key: key);
  final ForumModel? forum;
  final VoidCallback? commented;
  @override
  _ForumLikeCommentScreenState createState() => _ForumLikeCommentScreenState();
}

class _ForumLikeCommentScreenState extends State<ForumLikeCommentScreen> {
  String? commentBasePath;
  ForumModel? _forum;

  final bool _isInit = false;

  List<UserModel> _forumLikedByUser = [];
  List<UserModel> _forumCoinedByUser = [];
  List<CommentModel> _comments = [];

  bool _isLoadingComments = true;

  @override
  void initState() {
    super.initState();

    if (widget.forum == null) {
      Navigator.of(context).pop();
    } else {
      _forum = widget.forum;
      if (_forum == null) {
        navigateTo(context);
      } else {
        commentBasePath =
            '${Constants.FORUMS}/${_forum!.forumId}/${Constants.COMMENTS}';

        if (_forum!.likes!.isNotEmpty) {
          _comments = [];
          _loadForumLikedByUser();
        } else {}

        if (_forum!.comments!.isNotEmpty) {
          _forumLikedByUser = [];
          _forumCoinedByUser = [];
          _loadComments();
        } else {
          _isLoadingComments = false;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('_ForumLikeCommentScreenState.build');
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Forum'),
            bottom: TabBar(
              tabs: [
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
          body: Column(
            children: [
              Expanded(
                child: TabBarView(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: double.infinity,
                            width: double.infinity,
                            child: _comments.isEmpty
                                ? SafetyModel(
                                    isLoading: _isLoadingComments,
                                    icon: SvgPicture.asset(
                                      'assets/svgs/comment.svg',
                                      height: 80.0,
                                      color: hintColor,
                                    ),
                                    title: 'There is no comment for this forum',
                                    subTitle: 'Be the first one to comment!',
                                  )
                                : AllComments(_comments),
                          ),
                        ),
                        WriteAComment(onCommentSend: _onSend)
                      ],
                    ),
                    _forumLikedByUser.isEmpty
                        ? SafetyModel(
                            isLoading: _isLoadingComments,
                            icon: const Icon(
                              Icons.favorite,
                              size: 80.0,
                              color: hintColor,
                            ),
                            title: 'There is no like for this forum',
                            subTitle: 'Be the first one to like!',
                          )
                        : AllLikes(_forumLikedByUser),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loadForumLikedByUser() async {}
  void _sendNotification(ForumModel forum) {}
  Future<void> _loadComments() async {}

  _onSend(CommentModel p1) {}
}
