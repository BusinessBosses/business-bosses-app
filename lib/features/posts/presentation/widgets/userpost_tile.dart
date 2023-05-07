import 'package:business_bosses_v2/features/posts/models/post_model.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../../action/action.dart';
import '../../../../common/widgets/ranking_badge.dart';
import '../../../../common/widgets/text_widget.dart';
import '../../../../common/widgets/user_avatar_with_badge.dart';
import '../../../../utils/theme/theme.dart';
import '../../../../utils/time_format.dart';

// import 'rep';
class MyPostItem extends StatefulWidget {
  final PostModel? post;
  final Function(PostModel latestPost)? onLikeTap;
  final Function(PostModel latestPost)? onComment;
  final Function(PostModel latestPost)? coinUncoinForum;
  // final Function(String id) onBlock;
  final int i;
  const MyPostItem({
    Key? key,
    this.post,
    this.onLikeTap,
    this.onComment,
    this.coinUncoinForum,
    this.i = 0,
    // this.onBlock,
  }) : super(key: key);

  @override
  _MyPostItemState createState() => _MyPostItemState();
}

class _MyPostItemState extends State<MyPostItem> {
  bool commentMode = false;
  bool _isInit = false;
  List<String> blocked = [];

  PostModel _post = PostModel(isRanked: false, postId: '', title: '');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (blocked.contains(_post.user?.uid)) {
      return Column();
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(0.0),
            margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.only(left: 15, right: 15),
                  leading: GestureDetector(
                    onTap: () {},
                    child: UserAvatarWithBadge(
                      user: _post.user,
                      height: 55.0,
                      width: 55.0,
                      radius: 50.0,
                      placeHolder: Icons.person,
                      iconSize: 24.0,
                    ),
                  ),
                  title: GestureDetector(
                    onTap: () {},
                    child: Text(
                      '_post.user?.name',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  trailing: SizedBox(
                    height: 30,
                    width: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        !(_post.isRanked)
                            ? Container()
                            : Container(
                                width: leadingWidth(_post),
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
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 15, right: 10),
                              child: SvgPicture.asset(
                                'assets/svgs/more.svg',
                                width: 5,
                                height: 3,
                              ),
                            )),
                      ],
                    ),
                  ),
                  subtitle: Text(
                    _post.user?.bio ?? '',
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
                      // Padding(
                      //   padding: const EdgeInsets.only(left: 0, right: 0),
                      //   child: MyPostItemText(
                      //     _post,
                      //     onDetectableTextTap: _onDetectableTextTap,
                      //   ),
                      // ),
                      // if (_post.images?.isNotEmpty ?? false) ...[
                      //   AllImagesItem(
                      //     _post.images,
                      //     post: _post,
                      //     text: _post.title,
                      //     isVideo: _post.videoUrl != null &&
                      //             _post.videoUrl.isNotEmpty
                      //         ? true
                      //         : false,
                      //   ),
                      // ]
                    ],
                  ),
                ),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: _onLikeTap,
                      icon: SvgPicture.asset('assets/svgs/like.svg'),
                      label: Text(
                        '${_post.likes?.length ?? 0}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: textColor.withOpacity(0.8),
                            ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _showBottomSheet,
                      icon: SvgPicture.asset('assets/svgs/comment.svg'),
                      label: Text(
                        '${_post.comments?.length ?? 0}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: textColor.withOpacity(0.8),
                            ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () async {},
                      icon: SvgPicture.asset('assets/svgs/coin.svg'),
                      label: Text(
                        '${_post.coins?.length ?? 0}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: textColor.withOpacity(0.8),
                            ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    GestureDetector(
                      onTap: () => _sharePost(widget.post),
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
                        TimeFormat.formatString(_post.timestamp),
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
          const SizedBox(
            height: 7,
          )
        ],
      );
    }
  }

  _sharePost(PostModel? post) {}

  void _onLikeTap() {}

  void _showBottomSheet() {}

  double leadingWidth(PostModel p) {
    double w = 0;
    if (p.isRanked) w = w + 42;
    if (p.postId == 'currentuser.uid') {
      w = w + 42;
    }
    return w;
  }
}
