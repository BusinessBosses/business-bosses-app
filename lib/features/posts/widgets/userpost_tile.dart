import 'dart:convert';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/live_event/models/events_model.dart';
import 'package:business_bosses_v2/features/live_event/presentation/create_event.dart';
import 'package:business_bosses_v2/features/live_event/widgets/call_room.dart';
import 'package:business_bosses_v2/features/posts/controllers/create_post_controller.dart';
import 'package:business_bosses_v2/features/posts/models/post_model.dart';
import 'package:business_bosses_v2/features/posts/widgets/post_images.dart';
import 'package:business_bosses_v2/features/posts/widgets/post_like_comment.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/features/profile/widgets/premium_profile_tile.dart';
import 'package:business_bosses_v2/functions/my_native_functions.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher_string.dart';
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
    final ApiResponseModel res = await ApiService.post(
        path: '/connection/connect',
        body: <String, dynamic>{
          'userId': profileController.myProfile.uid,
          'connectedId': userId,
          'timestamp': DateTime.now().millisecondsSinceEpoch
        });
  }

  Future<void> disconnect(String userId) async {
    // ignore: unused_local_variable
    final ApiResponseModel res = await ApiService.post(
        path: '/connection/disconnect',
        body: <String, dynamic>{
          'userId': profileController.myProfile.uid,
          'connectedId': userId,
          'timestamp': DateTime.now().millisecondsSinceEpoch
        });
  }

  void connectToUser() async {
    // print(
    //     'This are my connected users ${profileController.myProfile.connecteds}');
    final int checkConnected = profileController.myProfile.connecteds == null
        ? -1
        : profileController.myProfile.connecteds!
            .indexWhere((String element) => element == widget.post.user!.uid);
    if (checkConnected == -1) {
      // connecteds.add(user);
      profileController.updateConnections(widget.post.user!.uid);
      setState(() {
        UserModel.fromMap(<dynamic, dynamic>{
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
        UserModel.fromMap(<dynamic, dynamic>{
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

  String formatCount(int count) {
    if (count >= 1000) {
      double countInK = count / 1000;
      if (countInK >= 1000) {
        return '${(countInK / 1000).toStringAsFixed(1)}m';
      } else {
        return '${countInK.toStringAsFixed(1)}k';
      }
    } else {
      return count.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    String? title, roomid, date, starttime, host, photourl, startat, endat;

    if (widget.post.livedata != null) {
      try {
        final jsonData = jsonDecode(widget.post.livedata!.toString());

        title = jsonData['title'];
        roomid = jsonData['roomId'];
        date = jsonData['date'];
        starttime = jsonData['starttime'];
        host = jsonData['host'];
        photourl = jsonData['photourl'];
        startat = jsonData['startat'];
        endat = jsonData['endat'];
      } catch (e) {}
    } else {}

    EventModel event = EventModel(
      title: title,
      roomId: roomid ?? '',
      startAt: DateTime.parse(startat ?? '2023-11-07T10:45:00.000Z'),
      endAt: DateTime.parse(endat ?? '2023-11-07T10:45:00.000Z'),
      startTime: starttime ?? '',
      user: widget.post.user,
    );

    if (hide == false) {
      final List<PopupMenuEntry<String>> myPopupMore = <PopupMenuEntry<String>>[
        if (widget.post.livedata == null)
          const PopupMenuItem<String>(
            value: 'Edit',
            child: Text(
              'Edit',
              style: bodyText2,
            ),
          ),
        if (widget.post.livedata == null)
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
              children: <Widget>[
                if (widget.post.reposts?.length != null &&
                    widget.post.reposts?.length != 0) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, top: 10),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/svgs/repost.svg',
                          height: 13,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        widget.post.reposts?.contains(
                                    profileController.myProfile.uid) !=
                                true
                            ? Row(
                                children: [
                                  const Text(
                                    'You Reposted',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    width: 3.0,
                                    height: 3.0,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                ],
                              )
                            : Container(),
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            '${widget.post.reposts?.length.toString()} Reposts',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
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
                        ? profileController.myProfile.uid ==
                                widget.post.user!.uid
                            ? Padding(
                                padding: const EdgeInsets.only(top: 0.0),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      widget.post.user!.name != null &&
                                              widget.post.user!.name!.length <=
                                                  20
                                          ? widget.post.user!.name!
                                          : widget.post.user!.name != null
                                              ? '${widget.post.user!.name!.substring(0, 20)}...'
                                              : widget.post.user!.username,
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
                            : Padding(
                                padding: const EdgeInsets.only(top: 0.0),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      widget.post.user!.name != null &&
                                              widget.post.user!.name!.length <=
                                                  15
                                          ? widget.post.user!.name!
                                          : widget.post.user!.name != null
                                              ? '${widget.post.user!.name!.substring(0, 12)}...'
                                              : widget.post.user!.username,
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
                            widget.post.user!.name != null &&
                                    widget.post.user!.name!.length <= 20
                                ? widget.post.user!.name!
                                : widget.post.user!.name != null
                                    ? '${widget.post.user!.name!.substring(0, 12)}...'
                                    : widget.post.user!.username,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                  ),
                  trailing: SizedBox(
                    height: 30,
                    width:
                        profileController.myProfile.uid != widget.post.user!.uid
                            ? 140
                            : 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        widget.post.user!.isSubscribed &&
                                widget.post.user!.uid !=
                                    profileController.myProfile.uid
                            ? premiumButtonHeader(
                                widget.post.user!,
                                profileController.myProfile,
                                connectToUser,
                                context)
                            : Container(),
                        widget.post.isRanked
                            ? Container()
                            : Container(
                                width: leadingWidth(widget.post),
                                height: double.infinity,
                                alignment: Alignment.center,
                                child: const RankingBadge(),
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
                                            postDetail: widget.post,
                                            images: widget.post.images,
                                          ));
                                    } else if (val == 'updateevent') {
                                      Get.to(() => CreateEvent(
                                            event: event,
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
                                              'Are you sure you want to delete this post?'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () => Get.back(),
                                              child: const Text('No'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                // ApiService.delete(
                                                //     path:
                                                //         'post/delete-post/${widget.post.postId}');
                                                // setState(() {
                                                //   hide = true;
                                                // });
                                                CreatePostController()
                                                    .onDeletePost(
                                                        widget.post.postId);
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
                                      padding: const EdgeInsets.only(
                                          left: 14, right: 15.0),
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (widget.post.promote! && widget.post.approved!)
                        const Column(
                          children: <Widget>[
                            TextWidget(
                              text: 'Sponsored',
                              fontWeight: FontWeight.w700,
                              size: 10,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      if (widget.post.title.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
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
                              onTap: (String link) async {
                                String url = MyNativeFunctions.completeURL(
                                    link, MyUrl.url);
                                await launchUrlString(url);
                              },
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      if (widget.post.livedata != null) ...<Widget>[
                        GestureDetector(
                          onTap: () {
                            // Add2Calendar.addEvent2Cal(Event(
                            //     title: '$title',
                            //     startDate: DateTime.parse(startat!),
                            //     endDate: DateTime.parse(endat!)));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: const DecorationImage(
                                image:
                                    AssetImage('assets/images/liveeventt.png'),
                                fit: BoxFit.cover,
                              ),
                              // You can also add other properties like boxShadow for a more realistic effect
                            ),
                            child: Stack(children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white.withAlpha(70),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Row(
                                                children: <Widget>[
                                                  (DateTime.now().isAfter(DateTime
                                                              .parse(startat ??
                                                                  '2023-11-07T10:45:00.000Z')) &&
                                                          DateTime.now().isBefore(
                                                              DateTime.parse(endat ??
                                                                  DateTime.now()
                                                                      .toIso8601String())))
                                                      ? Lottie.asset(
                                                          'assets/anim/liveeventwhite.json',
                                                          height: 12,
                                                        )
                                                      : SvgPicture.asset(
                                                          'assets/svgs/liveeventt.svg',
                                                          height: 12,
                                                          // ignore: deprecated_member_use
                                                          color: Colors.white,
                                                        ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    (DateTime.now().isAfter(
                                                                DateTime.parse(
                                                                    startat ??
                                                                        '2023-11-07T10:45:00.000Z')) &&
                                                            DateTime.now().isBefore(
                                                                DateTime.parse(endat ??
                                                                    DateTime.now()
                                                                        .toIso8601String())))
                                                        ? 'Ongoing Live Event'
                                                        : DateTime.now().isAfter(
                                                                DateTime.parse(
                                                                    startat ??
                                                                        '2023-11-07T10:45:00.000Z'))
                                                            ? 'Ended event'
                                                            : 'Upcoming Live event',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Text(
                                            'ID: $roomid',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w900),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          '$title',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            NetworkImageWithPlaceHolder(
                                              imageUrl: '$photourl',
                                              height: 25,
                                              width: 25,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              '$host',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white
                                                      .withAlpha(200)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        DateTime.now().isAfter(DateTime.parse(
                                                endat ??
                                                    DateTime.now()
                                                        .toIso8601String()))
                                            ? 'Ended'
                                            : DateTime.now().isAfter(DateTime
                                                        .parse(startat ??
                                                            '2023-11-07T10:45:00.000Z')) &&
                                                    DateTime.now().isBefore(
                                                        DateTime.parse(endat ??
                                                            DateTime.now()
                                                                .toIso8601String()))
                                                ? 'Happening now'
                                                : '$date, $starttime',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ]),
                          ),
                        )
                      ],
                      if (widget.post.images?.isNotEmpty ?? false)
                        PostImages(
                          post: widget.post,
                          isYt: widget.post.ytUrl != null &&
                                  widget.post.ytUrl != ''
                              ? true
                              : false,
                        ),
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(right: 0.0),
                      child: TextButton.icon(
                        onPressed: () async {
                          widget.controller.postLike(
                              profileController.myProfile.uid,
                              widget.post.postId,
                              'post',
                              widget.post.user!.uid);
                        },
                        icon: widget.post.likes?.contains(
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
                          '${widget.post.likes?.length ?? 0}',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: textColor.withOpacity(0.8),
                                  ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 0.0),
                      child: TextButton.icon(
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
                        icon: SvgPicture.asset('assets/svgs/comment.svg',
                            height: 15),
                        label: Text(
                          '${widget.post.comments?.length ?? 0}',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: textColor.withOpacity(0.8),
                                  ),
                        ),
                      ),
                    ),
                    // widget.post.user!.uid != profileController.myProfile.uid
                    Container(
                      padding: const EdgeInsets.only(right: 0.0),
                      child: TextButton.icon(
                        onPressed: () async {
                          if (widget.post.user!.uid !=
                              profileController.myProfile.uid) {
                            homeController.postCoin(
                                profileController.myProfile.uid,
                                widget.post.postId,
                                profileController,
                                'post',
                                widget.post.user!.uid);
                          }
                        },
                        icon: widget.post.coins?.contains(
                                    profileController.myProfile.uid) ==
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
                          '${widget.post.coins?.length ?? 0}',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: textColor.withOpacity(0.8),
                                  ),
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () async {},
                      icon: const Icon(Icons.remove_red_eye_outlined,
                          size: 19, color: Colors.black),
                      label: Text(
                        formatCount(widget.post.views!),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: textColor.withOpacity(0.8),
                            ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    if (widget.post.livedata != null) ...<Widget>[
                      (DateTime.now().isAfter(DateTime.parse(startat ??
                                  DateTime.now().toIso8601String())) &&
                              DateTime.now().isBefore(DateTime.parse(
                                  endat ?? DateTime.now().toIso8601String())))
                          ? Expanded(
                              child: Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: ElevatedButton(
                                  onPressed: () {
                                    final String enteredRoomID = event.roomId!;
                                    if (profileController.myProfile.uid !=
                                        event.user?.uid) {
                                      jumpToLivePage(
                                        context,
                                        title: event.title!,
                                        roomID: enteredRoomID,
                                        isHost: false,
                                      );
                                    } else {
                                      jumpToLivePage(
                                        context,
                                        title: event.title!,
                                        roomID: enteredRoomID,
                                        isHost: true,
                                      );
                                    }
                                  },
                                  child: const Text('Join')),
                            ))
                          : Expanded(
                              child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                        context: context,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(25.0),
                                          ),
                                        ),
                                        builder: (context) {
                                          return SizedBox(
                                            height: 250,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
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
                                                            Navigator.pop(
                                                                context);
                                                            index == 0
                                                                ? _sharePost()
                                                                : () async {
                                                                    widget.controller.postRepost(
                                                                        profileController
                                                                            .myProfile
                                                                            .uid,
                                                                        widget
                                                                            .post
                                                                            .postId,
                                                                        'post',
                                                                        widget
                                                                            .post
                                                                            .timestamp,
                                                                        widget
                                                                            .post
                                                                            .user!
                                                                            .uid);
                                                                  };
                                                          },
                                                          minVerticalPadding: 0,
                                                          contentPadding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 10),
                                                          leading:
                                                              SvgPicture.asset(
                                                            index == 0
                                                                ? 'assets/svgs/share.svg'
                                                                : 'assets/svgs/repost.svg',
                                                            height: index == 0
                                                                ? 18
                                                                : 25,
                                                            color: textColor
                                                                .withOpacity(1),
                                                          ),
                                                          title: Text(
                                                            index == 0
                                                                ? 'Share Post'
                                                                : widget.post.reposts?.contains(profileController
                                                                            .myProfile
                                                                            .uid) ==
                                                                        true
                                                                    ? 'Undo Repost'
                                                                    : 'Repost',
                                                            style: const TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
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
                                  child: SvgPicture.asset(
                                    'assets/svgs/share.svg',
                                    height: 15.0,
                                    width: 15.0,
                                  ),
                                ),
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: Text(
                                    widget.post.oldtimestamp != null ||
                                            widget.post.oldtimestamp == 1
                                        ? TimeFormat.formatString(
                                            widget.post.oldtimestamp)
                                        : TimeFormat.formatString(
                                            widget.post.timestamp),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: textColor.withOpacity(0.4),
                                        ),
                                  ),
                                )
                              ],
                            ))
                    ],
                    if (widget.post.livedata == null) ...<Widget>[
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(25.0),
                                ),
                              ),
                              builder: (context) {
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
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return ListTile(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  index == 0
                                                      ? _sharePost()
                                                      : () async {
                                                          widget.controller
                                                              .postRepost(
                                                                  profileController
                                                                      .myProfile
                                                                      .uid,
                                                                  widget.post
                                                                      .postId,
                                                                  'post',
                                                                  widget.post
                                                                      .timestamp,
                                                                  widget
                                                                      .post
                                                                      .user!
                                                                      .uid);
                                                        };
                                                },
                                                minVerticalPadding: 0,
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        left: 10),
                                                leading: SvgPicture.asset(
                                                  index == 0
                                                      ? 'assets/svgs/share.svg'
                                                      : 'assets/svgs/repost.svg',
                                                  height: index == 0 ? 18 : 25,
                                                  color:
                                                      textColor.withOpacity(1),
                                                ),
                                                title: Text(
                                                  index == 0
                                                      ? 'Share Post'
                                                      : widget.post.reposts?.contains(
                                                                  profileController
                                                                      .myProfile
                                                                      .uid) ==
                                                              true
                                                          ? 'Undo Repost'
                                                          : 'Repost',
                                                  style: const TextStyle(
                                                      fontSize: 18,
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
                        child: SvgPicture.asset(
                          'assets/svgs/share.svg',
                          height: 15.0,
                          width: 15.0,
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Text(
                          widget.post.oldtimestamp != null ||
                                  widget.post.oldtimestamp == 1
                              ? TimeFormat.formatString(
                                  widget.post.oldtimestamp)
                              : TimeFormat.formatString(widget.post.timestamp),
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: textColor.withOpacity(0.4),
                                  ),
                        ),
                      )
                    ],
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
    logEvent(widget.post.postId, 'post');
    socialShare(message);
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
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
                    actions: <Widget>[
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
                    actions: <Widget>[
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

  void jumpToLivePage(
    BuildContext context, {
    required String roomID,
    required bool isHost,
    required String title,
  }) {
    Navigator.push(
      context,
      // ignore: always_specify_types
      MaterialPageRoute(
        builder: (BuildContext context) => CallRoom(
          title: title,
          roomID: roomID,
          isHost: isHost,
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
