import 'package:business_bosses_v2/features/marketplace/presentation/boost_market_screen.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/post_images_market.dart';
import 'package:business_bosses_v2/features/posts/models/post_model.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../action/action.dart';
import '../../../../common/widgets/popup/my_popup_menu_button.dart';
import '../../../../common/widgets/text_widget.dart';
import '../../../../common/widgets/user_avatar_with_badge.dart';
import '../../../../navigation/routes.dart';
import '../../../../utils/theme/theme.dart';
import '../../../common/models/api_response_model.dart';
import '../../../common/models/comment_model.dart';
import '../../../common/models/user_model.dart';
import '../../../common/widgets/buttons/my_outlined_button.dart';
import '../../../common/widgets/ranking_badge.dart';
import '../../chat/chat_room_screen.dart';
import '../../profile/presentation/publicprofilescreen.dart';
import '../../profile/widgets/premium_profile_tile.dart';
import '../controllers/market_controller.dart';
import '../models/market_model.dart';
import '../presentation/sell_screen.dart';
import '../presentation/seller_reviews.dart';
import 'post_like_comment.dart';

/// import 'rep';
class MarketTile extends StatefulWidget {
  final MarketModel post;
  final Function(int)? onPageChange;

  ///
  const MarketTile({Key? key, required this.post, this.onPageChange})
      : super(key: key);

  @override
  State<MarketTile> createState() => _MarketTileState();
}

class _MarketTileState extends State<MarketTile> {
  bool hide = false;
  final MarketController _marketController = Get.find();
  final ProfileController profileController = Get.find();
  late MarketModel _post;

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _post = widget.post;
  }

  @override
  void didUpdateWidget(covariant MarketTile oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    _post = widget.post;
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
        if (_post.promote == false)
          const PopupMenuDivider(
            height: 0.0,
          ),
        if (_post.promote == false)
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
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.only(left: 15, right: 15),
                  leading: GestureDetector(
                    onTap: () {
                      if (profileController.myProfile.uid == _post.user.uid) {
                        if (widget.onPageChange != null) {
                          widget.onPageChange!(3);
                        }
                      } else {
                        Get.toNamed(Routes.publicProfile,
                            arguments: _post.user);
                      }
                    },
                    child: UserAvatarWithBadge(
                      user: _post.user,
                      height: 40.0,
                      width: 40.0,
                      radius: 50.0,
                      placeHolder: Icons.person,
                      iconSize: 24.0,
                    ),
                  ),
                  title: GestureDetector(
                    onTap: () {
                      if (profileController.myProfile.uid == _post.user.uid) {
                        if (widget.onPageChange != null) {
                          widget.onPageChange!(3);
                        }
                      } else {
                        Get.toNamed(Routes.publicProfile,
                            arguments: _post.user);
                      }
                    },
                    child: _post.user.isSubscribed
                        ? Padding(
                            padding: const EdgeInsets.only(top: 0.0),
                            child: Row(
                              children: [
                                Text(
                                  _post.user.name != null &&
                                          _post.user.name!.length <= 20
                                      ? _post.user.name!
                                      : _post.user.name != null
                                          ? "${_post.user!.name!.substring(0, 20)}..."
                                          : _post.user.username,
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
                            _post.user!.name != null &&
                                    _post.user!.name!.length <= 20
                                ? _post.user!.name!
                                : _post.user!.name != null
                                    ? "${_post.user!.name!.substring(0, 15)}..."
                                    : _post.user!.username,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                  ),
                  trailing: SizedBox(
                    height: 30,
                    width: profileController.myProfile.connecteds != null &&
                            profileController.myProfile.connecteds!
                                .contains(_post.user!.uid)
                        ? 140
                        : 130,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _post.user!.isSubscribed &&
                                _post.user!.uid !=
                                    profileController.myProfile.uid
                            ? premiumButtonHeader(widget.post.user!,
                                profileController.myProfile, connectToUser)
                            : Container(),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: double.infinity,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: _post.user.uid ==
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
                                        Get.to(
                                          () => CreateSellingitemScreen(
                                            isUpd: true,
                                            market: _post,
                                          ),
                                        );
                                      } else if (val == 'Delete') {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                            title: const Text(
                                              'Delete Listing',
                                              style: bodyText1,
                                            ),
                                            content: const Text(
                                                'Are you sure to delete this listing?'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () => Get.back(),
                                                child: const Text('No'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  _marketController
                                                      .removeListing(
                                                          _post.marketId);
                                                  ApiService.delete(
                                                      path:
                                                          'markets/${_post.marketId}');
                                                  // setState(() {
                                                  //   hide = true;
                                                  // });
                                                  Get.back();
                                                },
                                                child: const Text('Yes'),
                                              ),
                                            ],
                                          ),
                                        );
                                      } else if (val == 'Boost') {
                                        Get.to(
                                          () => BoostMarket(
                                              postId: _post.marketId),
                                        );
                                      }
                                    },
                                  )
                                : _post.promote
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
                                                'postId': _post.marketId
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
                        ),
                      ],
                    ),
                  ),
                  subtitle: Text(
                    _post.user.bio != null && _post.user.bio!.isNotEmpty
                        ? _post.user.bio!
                        : '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 0, right: 0, bottom: 0, top: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_post.promote)
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0, right: 15),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 5,
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
                        ),
                      const SizedBox(
                        height: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, right: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  _post.price.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, right: 15),
                            child: DetectableText(
                              text: _post.description,
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
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, right: 15),
                            child: Row(
                              children: [
                                SvgPicture.asset('assets/svgs/location.svg'),
                                const SizedBox(
                                  width: 1,
                                ),
                                Text(
                                  _post.location.length > 11
                                      ? '${_post.location.substring(0, 11)}...'
                                      : _post.location,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12,
                                      color: subtextColor),
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                SvgPicture.asset('assets/svgs/category.svg'),
                                const SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  _post.category.length > 15
                                      ? '${_post.category.substring(0, 15)}...'
                                      : _post.category,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12,
                                      color: subtextColor),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                _post.user.averageRating == 0
                                    ? Container()
                                    : Row(
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            color:
                                                Color.fromRGBO(255, 202, 40, 1),
                                            size: 16,
                                          ),
                                          Text(
                                            _post.user.averageRating!
                                                .toStringAsFixed(1),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Get.to(() => SellerReviewScreen(
                                                  user: _post.user));
                                            },
                                            child: const Text(
                                              'Seller reviews',
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, right: 15),
                            child: PostImagesMarket(post: _post),
                          ),
                          Row(
                            children: [
                              TextButton.icon(
                                onPressed: () async {
                                  _marketController.like(
                                      profileController.myProfile.uid,
                                      _post.marketId,
                                      'market',
                                      _post.userId);
                                },
                                icon: _post.likes?.contains(
                                            profileController.myProfile.uid) ==
                                        true
                                    ? SvgPicture.asset(
                                        'assets/svgs/likefilled.svg')
                                    : SvgPicture.asset('assets/svgs/like.svg'),
                                label: Text(
                                  '${_post.likes?.length ?? 0}',
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
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        PostLikeCommentItem(
                                      post: _post,
                                      onComment:
                                          (CommentModel newComment) async {},
                                    ),
                                  );
                                },
                                icon:
                                    SvgPicture.asset('assets/svgs/comment.svg'),
                                label: Text(
                                  '${_post.comments?.length ?? 0}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: textColor.withOpacity(0.8),
                                      ),
                                ),
                              ),
                              _post.user.uid != profileController.myProfile.uid
                                  ? TextButton.icon(
                                      onPressed: () async {
                                        _marketController.coin(
                                          profileController.myProfile.uid,
                                          _post.marketId,
                                          profileController,
                                          'market',
                                        );
                                      },
                                      icon: _post.coins?.contains(
                                                  profileController
                                                      .myProfile.uid) ==
                                              true
                                          ? SvgPicture.asset(
                                              'assets/svgs/coin.svg')
                                          : SvgPicture.asset(
                                              'assets/svgs/coin.svg'),
                                      label: Text(
                                        '${_post.coins?.length ?? 0}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                              color: textColor.withOpacity(0.8),
                                            ),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 10.0),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                              'assets/svgs/coin.svg'),
                                          const SizedBox(width: 5),
                                          Text(
                                            '${_post.coins?.length ?? 0}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w700,
                                                  color: textColor
                                                      .withOpacity(0.8),
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
                                ),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              _post.userId == profileController.myProfile.uid
                                  ? const SizedBox()
                                  : Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 15.0),
                                        child: MCustomButton(
                                          height: 40,
                                          margin: const EdgeInsets.only(
                                              right: 0.0, bottom: 10, top: 10),
                                          onPressed: () {
                                            Get.to(
                                              () => ChatRoomScreen(
                                                frommarketplace: true,
                                                market: _post,
                                              ),
                                              arguments: _post.user,
                                            );
                                          },
                                          child: const Text(
                                            'Message Seller',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 15),
                                          ),
                                        ),
                                      ),
                                    ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const Row(
                  children: <Widget>[
                    // const SizedBox(width: 8.0),
                    // GestureDetector(
                    //   onTap: () => _sharePost(),
                    //   child: SvgPicture.asset(
                    //     'assets/svgs/share.svg',
                    //     height: 18.0,
                    //     width: 18.0,
                    //   ),
                    // ),
                    // const Spacer(),
                    // Padding(
                    //   padding: const EdgeInsets.only(right: 15),
                    //   child: Text(
                    //     TimeFormat.formatString(_post),
                    //     style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    //           color: textColor.withOpacity(0.4),
                    //         ),
                    //   ),
                    // )
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
        'Have a look at ${_post.user.username}\'s post on Business Bosses\n'
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
                  text: 'Block @${_post.user.username}',
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
                                'postId': _post.marketId,
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
            ),
            ListTile(
              onTap: () {
                Get.to(
                  () => PublicProfileScreen(
                    store: true,
                  ),
                  arguments: _post.user,
                );
              },
              contentPadding: EdgeInsets.zero,
              title: const TextWidget(
                text: 'View Store',
                color: Colors.blue,
              ),
            )
          ],
        ),
      ),
    );
  }

  void connectToUser() async {
    print(
        "This are my connected users ${profileController.myProfile.connecteds}");
    final int checkConnected = profileController.myProfile.connecteds == null
        ? -1
        : profileController.myProfile.connecteds!
            .indexWhere((String element) => element == _post.user!.uid);
    if (checkConnected == -1) {
      // connecteds.add(user);
      profileController.updateConnections(_post.user!.uid);
      setState(() {
        UserModel.fromMap({
          ..._post.user!.toMap(),
          'connectionCount': _post.user!.connectionCount == null
              ? 1
              : _post.user!.connectionCount! + 1
        });
      });
      await connect(widget.post.user!.uid);
    } else {
      profileController.updateConnections(_post.user!.uid);

      setState(() {
        UserModel.fromMap({
          ..._post.user!.toMap(),
          'connectionCount': _post.user!.connectionCount == null
              ? null
              : _post.user!.connectionCount! - 1
        });
      });
      // connecteds.removeAt(checkConnected);
      await disconnect(_post.user!.uid);
    }
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
