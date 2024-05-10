import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/models/comment_model.dart';
import 'package:business_bosses_v2/features/donations/controller/donations_controller.dart';
import 'package:business_bosses_v2/features/donations/models/donations_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:get/get.dart';
import '../../../../common/models/user_model.dart';
import '../../../../common/widgets/safety_model.dart';
import '../../../../common/widgets/user_avatar_with_badge.dart';
import '../../../../utils/theme/theme.dart';
import '../../../common/controllers/comment_controller.dart';
import '../../../services/api_service.dart';
import '../../home/controller/home_controller.dart';
import '../../posts/widgets/comment_item.dart';
import '../../posts/widgets/write_comment.dart';

class DonationCommentItem extends StatefulWidget {
  final Function(CommentModel comment) onComment;
  final DonationModel donation;
  final String? type;

  const DonationCommentItem({
    Key? key,
    required this.onComment,
    required this.donation,
    this.type,
  }) : super(key: key);

  @override
  _DonationCommentItemState createState() => _DonationCommentItemState();
}

class _DonationCommentItemState extends State<DonationCommentItem> {
  bool _isLoadingLikes = true, _isLoadingComments = true;
  final DonationsController _donationsController =
      Get.put(DonationsController());
  final HomeController _homeController = Get.find();
  final ProfileController profileController = Get.find();
  final CommentController _commentController = Get.put(CommentController());

  @override
  void initState() {
    _loadCommentWithDetails();
    _loadLikesWithDetails(widget.donation.id);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Material(
              color: Colors.grey.withOpacity(0.1),
              child: TabBar(
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
              child: TabBarView(
                children: <Widget>[
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
                                'receiverUid': widget.donation.user?.uid
                              });
                          setState(() {
                            _commentController.comments.add(comment);
                          });
                          if (widget.type != null && widget.type == 'forum') {
                            _homeController.comment(
                              widget.donation.id,
                              comment,
                              'donation',
                            );
                          }
                        },
                        postId: widget.donation.id,
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
                                          color: primaryColorLT,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadCommentWithDetails() async {
    await _commentController.fetchComments(widget.donation.id);
    if (mounted) {
      setState(() {
        _isLoadingComments = _commentController.loading.value;
      });
    }
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
