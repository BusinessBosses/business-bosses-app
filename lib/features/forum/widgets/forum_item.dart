import 'package:business_bosses_v2/features/forum/controller/bossup_controller.dart';
import 'package:business_bosses_v2/features/forum/controller/forum_controller.dart';
import 'package:business_bosses_v2/features/forum/models/forum_model.dart';
import 'package:business_bosses_v2/features/forum/widgets/bossup_like_comment.dart';
import 'package:business_bosses_v2/functions/my_native_functions.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../action/action.dart';
import '../../../common/models/api_response_model.dart';
import '../../../common/models/comment_model.dart';
import '../../../common/models/user_model.dart';
import '../../../common/widgets/popup/my_popup_menu_button.dart';
import '../../../common/widgets/text_widget.dart';
import '../../../common/widgets/user_avatar_with_badge.dart';
import '../../../services/api_service.dart';
import '../../../utils/theme/theme.dart';
import '../../../utils/time_format.dart';
import '../../posts/widgets/all_images_item.dart';
import '../../profile/controller/profile_controller.dart';
import '../../profile/widgets/premium_profile_tile.dart';
import 'forum_like_comment.dart';

class ForumItem extends StatefulWidget {
  final ForumModel forum;
  final bool isBossUp;

  // final VoidCallback? commented;
  // final Function? likeUnlikeForum;
  // final Function? onUpdateForum;
  // final Function? coinUncoinForum;

  final dynamic controller;

  // ignore: public_member_api_docs
  const ForumItem({
    Key? key,
    required this.forum,
    // this.commented,
    // this.likeUnlikeForum,
    // this.coinUncoinForum,
    // this.onUpdateForum,
    this.controller,
    this.isBossUp = false,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ForumItemState createState() => _ForumItemState();
}

class _ForumItemState extends State<ForumItem> {
  List<String> blocked = [];
  final ProfileController profileController = Get.find();

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
    final int checkConnected = profileController.myProfile.connecteds == null
        ? -1
        : profileController.myProfile.connecteds!
            .indexWhere((String element) => element == widget.forum.user!.uid);
    if (checkConnected == -1) {
      profileController.updateConnections(widget.forum.user!.uid);
      setState(() {
        UserModel.fromMap({
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
        UserModel.fromMap({
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
    final ProfileController profileController = Get.find();
    // print(widget.forum.user!.uid);
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
                  children: [
                    ListTile(
                      contentPadding:
                          const EdgeInsets.only(left: 15.0, right: 0),
                      trailing: widget.forum.user!.uid !=
                              profileController.myProfile.uid
                          ? SizedBox(
                              height: 30,
                              width: 140,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
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
                                                children: [
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
                                                                .withOpacity(
                                                                    .6),
                                                          ),
                                                          actions: [
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
                                                              children: [
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
                                                                  color:
                                                                      primaryColorLT,
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
                                                                .withOpacity(
                                                                    .6),
                                                          ),
                                                          actions: [
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
                                children: [
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
                                                  arguments: {
                                                    'isUpdating': true,
                                                    'forum': widget.forum,
                                                    'isBossUp': widget.isBossUp,
                                                  });
                                            } else if (val == 'Delete') {
                                              _showDialog(widget.forum.forumId);
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
                                  //                     textColor.withOpacity(1),
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
                                children: [
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
                                        children: [
                                          Container(
                                            height: 90 / 3.4,
                                            width: 90 / 3.4,
                                            padding: const EdgeInsets.all(3),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                              // ignore: prefer_const_literals_to_create_immutables
                                              boxShadow: [
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
                                  children: [
                                    Text(
                                      widget.forum.user?.name != null &&
                                              widget.forum.user!.name!.length <=
                                                  15
                                          ? widget.forum.user!.name!
                                          : widget.forum.user?.name != null
                                              ? '${widget.forum.user!.name!.substring(0, 15)}...'
                                              : '',
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    const SizedBox(width: 5),
                                    SvgPicture.asset(
                                      'assets/svgs/premiumbadge.svg',
                                      height: 9,
                                      color: primaryColorLT,
                                    )
                                  ],
                                ),
                              )
                            : Text(
                                widget.forum.user?.name != null &&
                                        widget.forum.user!.name!.length <= 15
                                    ? widget.forum.user!.name!
                                    : widget.forum.user?.name != null
                                        ? '${widget.forum.user!.name!.substring(0, 15)}...'
                                        : '',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                      ),
                      subtitle: Text(
                        widget.forum.user?.bio ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                                detectionRegExp:
                                    detectionRegExp(hashtag: false)!,
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
                                onTap: (String link) async {
                                  String url = MyNativeFunctions.completeURL(
                                      link, MyUrl.url);
                                  await launchUrlString(url);
                                }),
                          ),
                    widget.forum.images == null
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, top: 10),
                            child: AllImagesItem(
                              widget.forum.images!
                                  .where((element) => element.isNotEmpty)
                                  .toList(),
                            ),
                          ),
                    Row(
                      children: [
                        TextButton.icon(
                          onPressed: () async {
                            widget.controller.postLike(
                                profileController.myProfile.uid,
                                widget.forum.forumId,
                                'forum',
                                widget.forum.user?.uid);
                          },
                          icon: widget.forum.likes?.contains(
                                      profileController.myProfile.uid) ==
                                  true
                              ? SvgPicture.asset('assets/svgs/likefilled.svg')
                              : SvgPicture.asset('assets/svgs/like.svg'),
                          label: Text(
                            '${widget.forum.likes?.length ?? 0}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: textColor.withOpacity(0.8),
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
                                    ),
                                  );
                          },
                          icon: SvgPicture.asset('assets/svgs/comment.svg'),
                          label: Text(
                            '${widget.forum.comments!.length}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: textColor.withOpacity(0.8),
                                ),
                          ),
                        ),
                        widget.forum.user!.uid !=
                                profileController.myProfile.uid
                            ? TextButton.icon(
                                onPressed: () async {
                                  widget.controller!.postCoin(
                                    profileController.myProfile.uid,
                                    widget.forum.forumId,
                                    profileController,
                                    'forum',
                                    widget.forum.user!.uid,
                                  );
                                },
                                icon: widget.forum.coins?.contains(
                                            profileController.myProfile.uid) !=
                                        true
                                    ? SvgPicture.asset('assets/svgs/coin.svg')
                                    : SvgPicture.asset('assets/svgs/coin.svg'),
                                label: Text(
                                  '${widget.forum.coins?.length ?? 0}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: textColor.withOpacity(0.8),
                                      ),
                                ))
                            : Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 10.0),
                                child: Row(
                                  children: [
                                    SvgPicture.asset('assets/svgs/coin.svg'),
                                    const SizedBox(width: 5),
                                    Text(
                                      '${widget.forum.coins?.length ?? 0}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: textColor.withOpacity(0.8),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                        const SizedBox(width: 8.0),
                        GestureDetector(
                          onTap: () => _sharePost(),
                          child: SvgPicture.asset(
                            'assets/svgs/share.svg',
                            height: 18.0,
                            width: 18.0,
                            color: textColor.withOpacity(1.0),
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Text(
                            TimeFormat.formatString(widget.forum.timestamp!),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: textColor.withOpacity(0.4)),
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
        'Have a look at ${widget.forum.user?.username ?? 'Business Bosses'}\'s post on Business Bosses\n'
        'https://businessbosses.onelink.me/xLWk/36a2ff16';
    logEvent(widget.forum.forumId, 'forum');
    socialShare(message);
  }

  leadingWidth(ForumModel? forum) {}

  void _showDialog(String forumId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const TextWidget(
              text: 'Are you sure you want to delete this forum?'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const TextWidget(
                  text: 'Cancel',
                )),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();

                  if (Get.isRegistered<ForumController>()) {
                    final ForumController controller = Get.find();

                    controller.deleteForum(forumId);
                  }

                  if (Get.isRegistered<BossUpController>()) {
                    Get.find<BossUpController>()
                        .deleteForum(widget.forum.forumId);
                  }
                },
                child: const TextWidget(
                  text: 'Delete',
                  color: primaryColorLT,
                ))
          ],
        );
      },
    );
  }
}
