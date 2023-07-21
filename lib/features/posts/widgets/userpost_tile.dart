import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/posts/models/post_model.dart';
import 'package:business_bosses_v2/features/posts/widgets/post_images.dart';
import 'package:business_bosses_v2/features/posts/widgets/post_like_comment.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/features/profile/widgets/premium_profile_tile.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../action/action.dart';
import '../../../common/models/api_response_model.dart';
import '../../../common/models/comment_model.dart';
import '../../../common/models/user_model.dart';
import '../../../common/widgets/popup/my_popup_menu_button.dart';
import '../../../common/widgets/ranking_badge.dart';
import '../../../common/widgets/text_widget.dart';
import '../../../common/widgets/user_avatar_with_badge.dart';
import '../../../navigation/routes.dart';
import '../../../utils/theme/theme.dart';
import '../../../utils/time_format.dart';
import '../presentation/boost_post_screen.dart';
import '../presentation/create_post_screen.dart';

// import 'rep';
class PostTile extends StatefulWidget {
  final PostModel post;
  final HomeController controller;
  final Function(int)? onPageChange;

  ///
  const PostTile(
      {Key? key,
      required this.post,
      required this.controller,
      this.onPageChange})
      : super(key: key);

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  bool hide = false;
  final ProfileController profileController = Get.find();
  final HomeController homeController = Get.find();

  Future<void> connect(String userId) async {
    // ignore: unused_local_variable
    final ApiResponseModel res =
        await ApiService.post(path: '/connection/connect', body: {
      'userId': profileController.myProfile.uid,
      'connectedId': userId,
      'timestamp': DateTime.now().millisecondsSinceEpoch
    });
  }

  Future<void> disconnect(String userId) async {
    // ignore: unused_local_variable
    final ApiResponseModel res =
        await ApiService.post(path: '/connection/disconnect', body: {
      'userId': profileController.myProfile.uid,
      'connectedId': userId,
      'timestamp': DateTime.now().millisecondsSinceEpoch
    });
  }

  void connectToUser() async {
    print(
        'This are my connected users ${profileController.myProfile.connecteds}');
    final int checkConnected = profileController.myProfile.connecteds == null
        ? -1
        : profileController.myProfile.connecteds!
            .indexWhere((String element) => element == widget.post.user!.uid);
    if (checkConnected == -1) {
      // connecteds.add(user);
      profileController.updateConnections(widget.post.user!.uid);
      setState(() {
        UserModel.fromMap({
          ...widget.post.user!.toMap(),
          'connectionCount': widget.post.user!.connectionCount == null
              ? 1
              : widget.post.user!.connectionCount! + 1
        });
      });
      await connect(widget.post.user!.uid);
    } else {
      profileController.updateConnections(widget.post.user!.uid);

      setState(() {
        UserModel.fromMap({
          ...widget.post.user!.toMap(),
          'connectionCount': widget.post.user!.connectionCount == null
              ? null
              : widget.post.user!.connectionCount! - 1
        });
      });
      // connecteds.removeAt(checkConnected);
      await disconnect(widget.post.user!.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (hide == false) {
      final List<PopupMenuEntry<String>> myPopupMore = <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'Edit',
          child: Text(
            'Edit',
            style: bodyText2,
          ),
        ),
        const PopupMenuDivider(
          height: 0.0,
        ),
        const PopupMenuItem<String>(
          value: 'Delete',
          child: Text(
            'Delete',
            style: bodyText2,
          ),
        ),
        if (widget.post.promote == false)
          const PopupMenuDivider(
            height: 0.0,
          ),
        if (widget.post.promote == false)
          const PopupMenuItem<String>(
            value: 'Boost',
            child: Text(
              'Boost',
              style: bodyText2,
            ),
          ),
      ];

      final List<PopupMenuEntry<String>> myPopup = <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'Hide',
          child: Text(
            'Hide',
            style: bodyText2,
          ),
        ),
        const PopupMenuDivider(
          height: 0.0,
        ),
        const PopupMenuItem<String>(
          value: 'Report',
          child: Text(
            'Report',
            style: bodyText2,
          ),
        )
      ];

      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.only(left: 15, right: 0),
                  leading: GestureDetector(
                    onTap: () {
                      if (profileController.myProfile.uid ==
                          widget.post.user!.uid) {
                        if (widget.onPageChange != null) {
                          widget.onPageChange!(3);
                        }
                      } else {
                        Get.toNamed(Routes.publicProfile,
                            arguments: widget.post.user);
                      }
                    },
                    child: UserAvatarWithBadge(
                      user: widget.post.user,
                      height: 40.0,
                      width: 40.0,
                      radius: 50.0,
                      placeHolder: Icons.person,
                      iconSize: 24.0,
                    ),
                  ),
                  title: GestureDetector(
                    onTap: () {
                      if (profileController.myProfile.uid ==
                          widget.post.user!.uid) {
                        if (widget.onPageChange != null) {
                          widget.onPageChange!(3);
                        }
                      } else {
                        Get.toNamed(Routes.publicProfile,
                            arguments: widget.post.user);
                      }
                    },
                    child: widget.post.user!.isSubscribed
                        ? Padding(
                            padding: const EdgeInsets.only(top: 0.0),
                            child: Row(
                              children: [
                                Text(
                                  widget.post.user!.name != null &&
                                          widget.post.user!.name!.length <= 20
                                      ? widget.post.user!.name!
                                      : widget.post.user!.name != null
                                          ? '${widget.post.user!.name!.substring(0, 20)}...'
                                          : widget.post.user!.username,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                const SizedBox(width: 7),
                                SvgPicture.asset(
                                  'assets/svgs/premiumbadge.svg',
                                  height: 16,
                                )
                              ],
                            ),
                          )
                        : Text(
                            widget.post.user!.name != null &&
                                    widget.post.user!.name!.length <= 20
                                ? widget.post.user!.name!
                                : widget.post.user!.name != null
                                    ? '${widget.post.user!.name!.substring(0, 15)}...'
                                    : widget.post.user!.username,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                  ),
                  trailing: SizedBox(
                    height: 30,
                    width: profileController.myProfile.connecteds != null &&
                            profileController.myProfile.connecteds!
                                .contains(widget.post.user!.uid)
                        ? 140
                        : 130,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        widget.post.user!.isSubscribed &&
                                widget.post.user!.uid !=
                                    profileController.myProfile.uid
                            ? premiumButtonHeader(widget.post.user!,
                                profileController.myProfile, connectToUser)
                            : Container(),
                        widget.post.isRanked
                            ? Container()
                            : Container(
                                width: leadingWidth(widget.post),
                                height: double.infinity,
                                alignment: Alignment.center,
                                child: const RankingBadge(),
                              ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: double.infinity,
                          color: Colors.white,
                          child: widget.post.user!.uid ==
                                  profileController.myProfile.uid
                              ? MyPopupMenuButton(
                                  popupItems: myPopupMore,
                                  icon: const Icon(
                                    Icons.more_horiz,
                                    size: 20,
                                    color: Colors.black,
                                    weight: 100,
                                  ),
                                  onSelected: (String val) {
                                    if (val == 'Edit') {
                                      Get.to(() => CreatePostScreen(
                                            postId: widget.post.postId,
                                            post: widget.post.title,
                                          ));
                                    } else if (val == 'Delete') {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          title: const Text(
                                            'Delete Post',
                                            style: bodyText1,
                                          ),
                                          content: const Text(
                                              'Are you sure to delete this post?'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () => Get.back(),
                                              child: const Text('No'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                ApiService.delete(
                                                    path:
                                                        'post/delete-post/${widget.post.postId}');
                                                setState(() {
                                                  hide = true;
                                                });
                                                Get.back();
                                              },
                                              child: const Text('Yes'),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else if (val == 'Boost') {
                                      Get.to(() => BoostPost(
                                            postId: widget.post.postId,
                                            postTitle: widget.post.title,
                                          ));
                                    }
                                  },
                                )
                              : widget.post.promote!
                                  ? MyPopupMenuButton(
                                      popupItems: myPopup,
                                      icon: const Icon(
                                        Icons.more_horiz,
                                        size: 20,
                                        color: Colors.black,
                                        weight: 100,
                                      ),
                                      onSelected: (String val) {
                                        if (val == 'Hide') {
                                          ApiService.post(
                                            path: 'blockedpost',
                                            body: <String, dynamic>{
                                              'postId': widget.post.postId
                                            },
                                          );
                                          setState(() {
                                            hide = true;
                                          });
                                        } else if (val == 'Report') {
                                          _showDialog();
                                        }
                                      },
                                    )
                                  : Padding(
                                      padding:
                                          const EdgeInsets.only(right: 15.0),
                                      child: InkWell(
                                        onTap: () {
                                          _showDialog();
                                        },
                                        child: const Icon(
                                          Icons.more_horiz,
                                          size: 20,
                                          color: Colors.black,
                                          weight: 100,
                                        ),
                                      ),
                                    ),
                        ),
                      ],
                    ),
                  ),
                  subtitle: Text(
                    widget.post.user?.bio != null &&
                            widget.post.user!.bio!.isNotEmpty
                        ? widget.post.user!.bio!
                        : '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, bottom: 0, top: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.post.promote ?? false)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 15,
                          ),
                          decoration: const BoxDecoration(
                            color: backgroundcolorinterface,
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: const TextWidget(
                            text: 'Sponsored',
                            fontWeight: FontWeight.w700,
                            size: 10,
                          ),
                        ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DetectableText(
                            text: widget.post.title,
                            detectionRegExp: detectionRegExp(hashtag: false)!,
                            detectedStyle: bodyText2.copyWith(
                              color: Colors.blue,
                            ),
                            moreStyle: bodyText2.copyWith(
                              color: Colors.redAccent,
                            ),
                            lessStyle: bodyText2.copyWith(
                              color: Colors.redAccent,
                            ),
                            trimExpandedText: '  show less',
                            basicStyle: bodyText2.copyWith(color: textColor),
                            onTap: (_) {},
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                      if (widget.post.images?.isNotEmpty ?? false)
                        PostImages(
                          post: widget.post,
                        ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () async {
                        homeController.postLike(profileController.myProfile.uid,
                            widget.post.postId, 'post', widget.post.user!.uid);
                      },
                      icon: widget.post.likes
                                  ?.contains(profileController.myProfile.uid) ==
                              true
                          ? SvgPicture.asset('assets/svgs/likefilled.svg')
                          : SvgPicture.asset('assets/svgs/like.svg'),
                      label: Text(
                        '${widget.post.likes?.length ?? 0}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: textColor.withOpacity(0.8),
                            ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) =>
                              PostLikeCommentItem(
                            post: widget.post,
                            onComment: (CommentModel newComment) async {},
                          ),
                        );
                      },
                      icon: SvgPicture.asset('assets/svgs/comment.svg'),
                      label: Text(
                        '${widget.post.comments?.length ?? 0}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: textColor.withOpacity(0.8),
                            ),
                      ),
                    ),
                    widget.post.user!.uid != profileController.myProfile.uid
                        ? TextButton.icon(
                            onPressed: () async {
                              homeController.postCoin(
                                  profileController.myProfile.uid,
                                  widget.post.postId,
                                  profileController,
                                  'post',
                                  widget.post.user!.uid);
                            },
                            icon: widget.post.coins?.contains(
                                        profileController.myProfile.uid) ==
                                    true
                                ? SvgPicture.asset('assets/svgs/coin.svg')
                                : SvgPicture.asset('assets/svgs/coin.svg'),
                            label: Text(
                              '${widget.post.coins?.length ?? 0}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: textColor.withOpacity(0.8),
                                  ),
                            ),
                          )
                        : const SizedBox(),
                    const SizedBox(width: 8.0),
                    GestureDetector(
                      onTap: () => _sharePost(),
                      child: SvgPicture.asset(
                        'assets/svgs/share.svg',
                        height: 18.0,
                        width: 18.0,
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Text(
                        TimeFormat.formatString(widget.post.timestamp),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: textColor.withOpacity(0.4),
                            ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Container(
            color: backgroundcolorinterface,
            height: 7,
          )
        ],
      );
    } else {
      return const SizedBox();
    }
  }

  void _sharePost() {
    String message =
        'Have a look at ${widget.post.user?.username ?? 'Business Bosses'}\'s post on Business Bosses\n'
        'https://businessbosses.onelink.me/xLWk/36a2ff16';
    socialShare(message);
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: () {
                navigateTo(context);
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const TextWidget(
                      text: 'Do you want to block user?',
                      centralize: true,
                      fontWeight: FontWeight.w700,
                      size: 20,
                    ),
                    content: TextWidget(
                      text:
                          'You will no longer see undefined posts and comments on your feed',
                      centralize: true,
                      color: Colors.black.withOpacity(.6),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => navigateTo(context),
                        child: const TextWidget(
                          text: 'Cancel',
                          fontWeight: FontWeight.w700,
                          size: 18,
                          color: Colors.grey,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          ApiService.post(
                            path: 'blockedpost',
                            body: <String, dynamic>{
                              'postId': widget.post.user?.uid
                            },
                          );
                          widget.controller
                              .removePostsByUserId(widget.post.user?.uid);
                          navigateTo(context);
                          showSnackBar(context,
                              message: 'User has been blocked');
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 7,
                            horizontal: 14,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColorLT,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const TextWidget(
                            text: 'Block',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
              contentPadding: EdgeInsets.zero,
              title: GestureDetector(
                child: TextWidget(
                  text: 'Block @${widget.post.user!.username}',
                  color: Colors.blue,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                navigateTo(context);
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const TextWidget(
                      text: 'Do you want to report post?',
                      centralize: true,
                      fontWeight: FontWeight.w700,
                      size: 20,
                    ),
                    content: TextWidget(
                      text:
                          'The post will be reported to admin to evaluate if it violates any community policy',
                      centralize: true,
                      color: Colors.black.withOpacity(.6),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => navigateTo(context),
                        child: const TextWidget(
                          text: 'Cancel',
                          fontWeight: FontWeight.w700,
                          size: 18,
                          color: Colors.grey,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          navigateTo(context);
                          ApiService.post(
                              path: 'reportedpost',
                              body: <String, dynamic>{
                                'postId': widget.post.postId,
                                'reason': 'This is a bad post',
                              });
                          showSnackBar(context,
                              message: 'Post has been Reported');
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 7,
                            horizontal: 14,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColorLT,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const TextWidget(
                            text: 'Report',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
              contentPadding: EdgeInsets.zero,
              title: const TextWidget(
                text: 'Report this post',
                color: Colors.red,
              ),
            )
          ],
        ),
      ),
    );
  }
}

double leadingWidth(PostModel p) {
  double w = 0;
  if (p.isRanked) w = w + 42;
  if (p.postId == 'currentuser.uid') {
    w = w + 42;
  }
  return w;
}
