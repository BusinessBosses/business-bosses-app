import 'package:business_bosses_v2/features/forum/controller/bossup_controller.dart';
import 'package:business_bosses_v2/features/forum/models/forum_model.dart';
import 'package:business_bosses_v2/features/forum/widgets/bossup_like_comment.dart';
import 'package:business_bosses_v2/features/posts/widgets/all_forum_images.dart';
import 'package:business_bosses_v2/features/posts/widgets/tag.dart';
import 'package:business_bosses_v2/features/profile/presentation/public_profile_screen.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/time_format.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../action/action.dart';
import '../../../common/models/api_response_model.dart';
import '../../../common/models/comment_model.dart';
import '../../../common/models/user_model.dart';
import '../../../common/widgets/popup/my_popup_menu_button.dart';
import '../../../common/widgets/text_widget.dart';
import '../../../common/widgets/user_avatar_with_badge.dart';
import '../../../services/api_service.dart';
import '../../../utils/theme/theme.dart';
import '../../forum/widgets/forum_like_comment.dart';
import '../../profile/controller/profile_controller.dart';
import '../../profile/widgets/premium_profile_tile.dart';
import '../controller/home_controller.dart';

class ForumItem extends StatefulWidget {
  final ForumModel forum;
  final bool isBossUp;

  // final VoidCallback? commented;
  // final Function? likeUnlikeForum;
  // final Function? onUpdateForum;
  // final Function? coinUncoinForum;

  final HomeController controller;

  // ignore: public_member_api_docs
  const ForumItem({
    super.key,
    required this.forum,
    // this.commented,
    // this.likeUnlikeForum,
    // this.coinUncoinForum,
    // this.onUpdateForum,
    required this.controller,
    this.isBossUp = false,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ForumItemState createState() => _ForumItemState();
}

class _ForumItemState extends State<ForumItem> {
  List<String> blocked = <String>[];
  final ProfileController profileController = Get.find();

  Future<void> connect(String userId) async {
    // ignore: unused_local_variable
    final ApiResponseModel res = await ApiService.post(
        path: 'connection/connect',
        body: <String, dynamic>{
          'userId': profileController.myProfile.uid,
          'connectedId': userId,
          'timestamp': DateTime.now().millisecondsSinceEpoch
        });
  }

  Future<void> disconnect(String userId) async {
    // ignore: unused_local_variable
    final ApiResponseModel res = await ApiService.post(
        path: 'connection/disconnect',
        body: <String, dynamic>{
          'userId': profileController.myProfile.uid,
          'connectedId': userId,
          'timestamp': DateTime.now().millisecondsSinceEpoch
        });
  }

  void connectToUser() async {
    final int checkConnected = profileController.myProfile.connecteds == null
        ? -1
        : profileController.myProfile.connecteds!
            .indexWhere((String element) => element == widget.forum.user!.uid);
    if (checkConnected == -1) {
      profileController.updateConnections(widget.forum.user!.uid);
      setState(() {
        UserModel.fromMap(<dynamic, dynamic>{
          ...widget.forum.user!.toMap(),
          'connectionCount': widget.forum.user!.connectionCount == null
              ? 1
              : widget.forum.user!.connectionCount! + 1
        });
      });
      await connect(widget.forum.user!.uid);
    } else {
      profileController.updateConnections(widget.forum.user!.uid);
      setState(() {
        UserModel.fromMap(<dynamic, dynamic>{
          ...widget.forum.user!.toMap(),
          'connectionCount': widget.forum.user!.connectionCount == null
              ? null
              : widget.forum.user!.connectionCount! - 1
        });
      });
      await disconnect(widget.forum.user!.uid);
    }
  }

  final List<PopupMenuEntry<String>> myPopup = <PopupMenuEntry<String>>[
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
    )
  ];

  @override
  Widget build(BuildContext context) {
    return widget.forum.user == null
        ? const SizedBox()
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (widget.forum.industry != null)
                      PostTag(
                        label: widget.forum.industry!.industry.toString(),
                        backgroundColor: backgroundColor,
                      ),
                    ListTile(
                      contentPadding:
                          const EdgeInsets.only(left: 15.0, right: 0),
                      trailing: widget.forum.user!.uid !=
                              profileController.myProfile.uid
                          ? SizedBox(
                              height: 30,
                              width: profileController.myProfile.connecteds !=
                                          null &&
                                      profileController.myProfile.connecteds!
                                          .contains(widget.forum.user!.uid)
                                  ? 140
                                  : 130,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  widget.forum.user!.isSubscribed &&
                                          widget.forum.user!.uid !=
                                              profileController.myProfile.uid
                                      ? premiumButtonHeader(
                                          widget.forum.user!,
                                          profileController.myProfile,
                                          connectToUser,
                                          context)
                                      : Container(),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 15.0),
                                    child: GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  ListTile(
                                                    onTap: () {
                                                      // Navigator.pop(context);
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                                context) =>
                                                            AlertDialog(
                                                          title:
                                                              const TextWidget(
                                                            text:
                                                                'Do you want to block user?',
                                                            centralize: true,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            size: 20,
                                                          ),
                                                          content: TextWidget(
                                                            text:
                                                                'You will no longer see undefined posts and comments on your feed',
                                                            centralize: true,
                                                            color: Colors.black
                                                                .withValues(
                                                                    alpha: .6),
                                                          ),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      context),
                                                              child:
                                                                  const TextWidget(
                                                                text: 'Cancel',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                size: 18,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                Navigator.pop(
                                                                    context);
                                                                // print(_post.user.uid);
                                                                setState(() {
                                                                  blocked.add(
                                                                      widget
                                                                          .forum
                                                                          .user!
                                                                          .uid);
                                                                });
                                                                // widget
                                                                //     .onBlock(_post.user.uid);
                                                                showSnackBar(
                                                                    context,
                                                                    message:
                                                                        'User has been blocked');
                                                              },
                                                              child: Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                  vertical: 7,
                                                                  horizontal:
                                                                      14,
                                                                ),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color:
                                                                      primaryColorLT,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                ),
                                                                child:
                                                                    const TextWidget(
                                                                  text: 'Block',
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                    contentPadding:
                                                        EdgeInsets.zero,
                                                    title: GestureDetector(
                                                      child: widget.forum.user
                                                                  ?.isSubscribed ==
                                                              true
                                                          ? Row(
                                                              children: <Widget>[
                                                                TextWidget(
                                                                  text:
                                                                      'Block @${widget.forum.user?.name}',
                                                                  color: Colors
                                                                      .blue,
                                                                ),
                                                                const SizedBox(
                                                                    width: 5),
                                                                SvgPicture
                                                                    .asset(
                                                                  'assets/svgs/premiumbadge.svg',
                                                                  height: 9,
                                                                  colorFilter: const ColorFilter
                                                                      .mode(
                                                                      primaryColorLT,
                                                                      BlendMode
                                                                          .srcIn),
                                                                )
                                                              ],
                                                            )
                                                          : TextWidget(
                                                              text:
                                                                  'Block @${widget.forum.user?.name}',
                                                              color:
                                                                  Colors.blue,
                                                            ),
                                                    ),
                                                  ),
                                                  ListTile(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pop(context);
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                                context) =>
                                                            AlertDialog(
                                                          title:
                                                              const TextWidget(
                                                            text:
                                                                'Do you want to report post?',
                                                            centralize: true,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            size: 20,
                                                          ),
                                                          content: TextWidget(
                                                            text:
                                                                'The post will be reported to admin to evaluate if it violates any community policy',
                                                            centralize: true,
                                                            color: Colors.black
                                                                .withValues(
                                                                    alpha: .6),
                                                          ),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      context),
                                                              child:
                                                                  const TextWidget(
                                                                text: 'Cancel',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                size: 18,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                Navigator.pop(
                                                                    context);
                                                                showSnackBar(
                                                                    context,
                                                                    message:
                                                                        'Post has been Reported');
                                                              },
                                                              child: Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                  vertical: 7,
                                                                  horizontal:
                                                                      14,
                                                                ),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color:
                                                                      primaryColorLT,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                ),
                                                                child:
                                                                    const TextWidget(
                                                                  text:
                                                                      'Report',
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                    contentPadding:
                                                        EdgeInsets.zero,
                                                    title: const TextWidget(
                                                      text: 'Report this post',
                                                      color: Colors.red,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );

                                          // _showMorePostOptions(context, "forumReport",
                                          //     widget.forum.forumId, "Report this Topic.");
                                        },
                                        child: Container(
                                            height: double.infinity,
                                            color: Colors.white,
                                            child: const Icon(
                                              Icons.more_horiz,
                                              size: 20,
                                              color: Colors.black,
                                              weight: 100,
                                            ))

                                        // color: Colors.redAccent,
                                        ),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(
                              width: 60,
                              // width: leadingWidth(widget.forum),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  const SizedBox(height: 0.0, width: 0.0),
                                  widget.forum.user!.uid ==
                                          profileController.myProfile.uid
                                      ? MyPopupMenuButton(
                                          popupItems: myPopup,
                                          icon: const Icon(Icons.more_horiz,
                                              size: 20),
                                          onSelected: (String val) {
                                            if (val == 'Edit') {
                                              Get.toNamed(Routes.createForum,
                                                  arguments: <String, Object>{
                                                    'isUpdating': true,
                                                    'forum': widget.forum,
                                                  });
                                            } else if (val == 'Delete') {
                                              _showDialog();
                                            }
                                          },
                                        )
                                      : Container(),

                                  // if (widget.forum.isRanked ?? false)
                                  //   Column(
                                  //     children: [
                                  //       const RankingBadge(size: 30.0),
                                  //       const SizedBox(
                                  //         height: 2,
                                  //       ),
                                  //       Text(
                                  //         'Boss of the week',
                                  //         style: Theme.of(context)
                                  //             .textTheme
                                  //             .bodyMedium
                                  //             ?.copyWith(
                                  //                 fontWeight: FontWeight.w700,
                                  //                 color:
                                  //                     textColor.withValues(alpha: 1),
                                  //                 fontSize: 7.5),
                                  //       ),
                                  //     ],
                                  //   )

                                  // if(widget.forum.uid != _firebase.uid)
                                ],
                              ),
                            ),
                      leading: (widget.forum.isRanked ?? false)
                          ? SizedBox(
                              height: 55,
                              width: 55,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: <Widget>[
                                  Center(
                                    child: UserAvatarWithBadge(
                                      user: widget.forum.user,
                                      height: 52.0,
                                      width: 52.0,
                                      radius: 50.0,
                                      placeHolder: Icons.person,
                                      iconSize: 36.0,
                                      showText: true,
                                    ),
                                  ),
                                  if (widget.forum.isRanked ?? false)
                                    Positioned(
                                      bottom: -10,
                                      right: -10,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          Container(
                                            height: 90 / 3.4,
                                            width: 90 / 3.4,
                                            padding: const EdgeInsets.all(3),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                              // ignore: prefer_const_literals_to_create_immutables
                                              boxShadow: <BoxShadow>[
                                                const BoxShadow(
                                                  color: Colors.black,
                                                  blurRadius:
                                                      500.0, // soften the shadow
                                                  spreadRadius:
                                                      0.02, //extend the shadow
                                                )
                                              ],
                                            ),
                                            child: SvgPicture.asset(
                                              'assets/svgs/bosseek.svg',
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                        ],
                                      ),
                                    )
                                ],
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                Get.toNamed(Routes.publicProfile,
                                    arguments: widget.forum.user);
                              },
                              child: UserAvatarWithBadge(
                                user: widget.forum.user,
                                height: 40.0,
                                width: 40.0,
                                radius: 50.0,
                                placeHolder: Icons.person,
                                iconSize: 24.0,
                              ),
                            ),
                      title: GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.publicProfile,
                              arguments: widget.forum.user);
                        },
                        child: widget.forum.user!.isSubscribed == true
                            ? Padding(
                                padding: const EdgeInsets.only(top: 0.0),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      widget.forum.user?.name != null
                                          ? widget.forum.user!.name!
                                          : widget.forum.user!.username,
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    const SizedBox(width: 5),
                                    SvgPicture.asset(
                                      'assets/svgs/premiumbadge.svg',
                                      height: 9,
                                      colorFilter: const ColorFilter.mode(
                                          primaryColorLT, BlendMode.srcIn),
                                    ),
                                  ],
                                ),
                              )
                            : Text(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                widget.forum.user?.name != null
                                    ? widget.forum.user!.name!
                                    : widget.forum.user!.username,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                      ),
                      subtitle: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.forum.user?.bio ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (widget.forum.user?.hasShop == true)
                            GestureDetector(
                              onTap: () {
                                Get.to(
                                  () => PublicProfileScreen(
                                    currentIndex: 1,
                                  ),
                                  arguments: widget.forum.user,
                                );
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  const Text(
                                    'Visit My Biz-Center',
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 9, 93, 237),
                                        fontSize: 14),
                                  ),
                                  const Icon(
                                    LucideIcons.chevronRight,
                                    size: 15,
                                    color: Color.fromARGB(255, 9, 93, 237),
                                  ),
                                ],
                              ),
                            )
                        ],
                      ),
                    ),
                    widget.forum.title == null
                        ? Container()
                        : widget.forum.title!.trim().isEmpty
                            ? Container()
                            : Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, right: 15),
                                child: Text(
                                  widget.forum.title!,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                    widget.forum.description == null ||
                            widget.forum.description!.trim().isEmpty
                        ? Container()
                        : Container(
                            margin: const EdgeInsets.only(
                                bottom: 0.0, left: 15, right: 15),
                            child: DetectableText(
                              text: widget.forum.description!,
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
                              maxLines: 100,
                              basicStyle: bodyText2,
                              onTap: (String val) =>
                                  onDetectableTextTap(context, val),
                            ),
                          ),
                    widget.forum.images == null
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, top: 10),
                            // child: AllImagesItem(
                            //   widget.forum.images!,
                            // ),
                            child: AllForumsImagesItem(
                              post: widget.forum,
                              widget.forum.images!,
                              isYt: widget.forum.ytUrl != null &&
                                      widget.forum.ytUrl != ''
                                  ? true
                                  : false,
                            ),
                          ),
                    Row(
                      children: <Widget>[
                        TextButton.icon(
                          onPressed: () async {
                            widget.controller.postLike(
                              profileController.myProfile.uid,
                              widget.forum.forumId,
                              'forum',
                              widget.forum.user!.uid,
                            );
                            setState(() {});
                          },
                          icon: widget.forum.likes?.contains(
                                      profileController.myProfile.uid) ==
                                  true
                              ? SvgPicture.asset(
                                  'assets/svgs/likefilled.svg',
                                  height: 15,
                                )
                              : SvgPicture.asset(
                                  'assets/svgs/like.svg',
                                  height: 15,
                                ),
                          label: Text(
                            '${widget.forum.likes?.length ?? 0}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: textColor.withValues(alpha: 0.8),
                                ),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            widget.isBossUp
                                ? showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        BossUpLikeCommentItem(
                                      forum: widget.forum,
                                      onComment:
                                          (CommentModel newComment) async {},
                                    ),
                                  )
                                : showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        ForumLikeCommentItem(
                                      forum: widget.forum,
                                      onComment:
                                          (CommentModel newComment) async {},
                                      type: 'forum',
                                    ),
                                  );
                          },
                          icon: SvgPicture.asset(
                            'assets/svgs/comment.svg',
                            height: 15,
                          ),
                          label: Text(
                            '${widget.forum.comments!.length}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: textColor.withValues(alpha: 0.8),
                                ),
                          ),
                        ),
                        widget.forum.user!.uid !=
                                profileController.myProfile.uid
                            ? TextButton.icon(
                                onPressed: () async {
                                  widget.controller.postCoin(
                                    profileController.myProfile.uid,
                                    widget.forum.forumId,
                                    profileController,
                                    'forum',
                                    widget.forum.user!.uid,
                                  );
                                  setState(() {});
                                },
                                icon: widget.forum.coins?.contains(
                                            profileController.myProfile.uid) !=
                                        true
                                    ? SvgPicture.asset(
                                        'assets/svgs/coin.svg',
                                        height: 20,
                                      )
                                    : SvgPicture.asset(
                                        'assets/svgs/coin.svg',
                                        height: 20,
                                      ),
                                label: Text(
                                  '${widget.forum.coins?.length ?? 0}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: textColor.withValues(alpha: 0.8),
                                      ),
                                ))
                            : Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 10.0),
                                child: Row(
                                  children: <Widget>[
                                    SvgPicture.asset('assets/svgs/coin.svg'),
                                    const SizedBox(width: 5),
                                    Text(
                                      '${widget.forum.coins?.length ?? 0}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: textColor.withValues(
                                                alpha: 0.8),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                        TextButton.icon(
                          onPressed: () async {},
                          icon: const Icon(Icons.remove_red_eye_outlined,
                              size: 19, color: Colors.black),
                          label: Text(
                            '${widget.forum.views ?? 0}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: textColor.withValues(alpha: 0.8),
                                ),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(25.0),
                                  ),
                                ),
                                builder: (BuildContext context) {
                                  return SizedBox(
                                    height: 250,
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Expanded(
                                            // Set a specific height
                                            child: ListView.separated(
                                              itemCount: 2,
                                              separatorBuilder:
                                                  (BuildContext context,
                                                          int index) =>
                                                      const Divider(),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return ListTile(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    index == 0
                                                        ? _sharePost()
                                                        : () async {
                                                            // widget.controller.postRepost(
                                                            //     profileController
                                                            //         .myProfile
                                                            //         .uid,
                                                            //     widget.forum
                                                            //         .forumId,
                                                            //     'post',
                                                            //     widget.forum
                                                            //         .timestamp,
                                                            //     widget.forum
                                                            //         .user!.uid,
                                                            //     widget.forum
                                                            //         .oldtimestamp);
                                                          };
                                                  },
                                                  minVerticalPadding: 0,
                                                  contentPadding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  leading: Icon(
                                                    index == 0
                                                        ? LucideIcons.share
                                                        : LucideIcons.repeat,
                                                    size: 18,
                                                    color: textColor.withValues(
                                                      alpha: 1,
                                                    ),
                                                  ),
                                                  title: Text(
                                                    'Share Post',
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                );
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                          child: Icon(LucideIcons.share,
                              size: 18.0,
                              color: textColor.withValues(alpha: 1)),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Text(
                            TimeFormat.formatString(widget.forum.timestamp!),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: textColor.withValues(alpha: 0.4)),
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
              ),
            ],
          );
  }

  void _sharePost() {
    String message =
        'Vote for ${widget.forum.user?.username ?? 'Business Bosses'}\'s post on Business Bosses\n'
        'https://vm.businessbosses.co.uk/share/post';
    logEvent(widget.forum.forumId, 'forum');
    socialShare(message);
  }

  void leadingWidth(ForumModel? forum) {}

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'Delete Post',
          style: bodyText1,
        ),
        content: const Text('Are you sure you want to delete this post?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              await widget.controller.removeForum(widget.forum.forumId);
              if (Get.isRegistered<BossUpController>()) {
                Get.find<BossUpController>().deleteForum(widget.forum.forumId);
              }
              setState(() {});
              Get.back();
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
}
