import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/posts/widgets/post_like_comment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../common/models/comment_model.dart';
import '../../../utils/theme/theme.dart';
import '../../../utils/time_format.dart';
import '../../profile/controller/profile_controller.dart';
import '../models/post_model.dart';

class PostInteractionsWidget extends StatelessWidget {
  final PostModel post;
  final ProfileController profileController;

  final Function() sharePost;
  final Function() repost;

  const PostInteractionsWidget({
    super.key,
    required this.post,
    required this.profileController,
    required this.sharePost,
    required this.repost,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final List<String> postLikes =
          profileController.getLikes(post.postId, post.likes);
      final List<String> postCoins =
          profileController.getCoins(post.postId, post.coins);
      final List<String> postReposts =
          profileController.getReposts(post.postId, post.reposts);

      return GetBuilder<HomeController>(
        builder: (HomeController controller) {
          return Container(
          padding: const EdgeInsets.only(left: 0, right: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  TextButton.icon(
                    onPressed: () async {
                      controller.postLike(profileController.myProfile.uid,
                          post.postId, 'post', post.user!.uid);
                    },
                    icon:
                        postLikes.contains(profileController.myProfile.uid)
                            ? SvgPicture.asset(
                                'assets/svgs/likefilled.svg',
                                height: 15,
                              )
                            : SvgPicture.asset(
                                'assets/svgs/like.svg',
                                height: 15,
                              ),
                    label: Text(
                      '${postLikes.length}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: textColor.withValues(alpha: 0.8),
                          ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) => PostLikeCommentItem(
                          post: post,
                          onComment: (CommentModel newComment) async {},
                        ),
                      );
                    },
                    icon: SvgPicture.asset(
                      'assets/svgs/comment.svg',
                      height: 15,
                    ),
                    label: Text(
                      '${post.comments?.length ?? 0}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: textColor.withValues(alpha: 0.8),
                          ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: post.user!.uid != profileController.myProfile.uid
                        ? () async {
                            controller.postCoin(
                                profileController.myProfile.uid,
                                post.postId,
                                profileController,
                                'post',
                                post.user!.uid);
                          }
                        : null,
                    icon:
                        postCoins.contains(profileController.myProfile.uid)
                            ? SvgPicture.asset(
                                'assets/svgs/coin.svg',
                                height: 20,
                              )
                            : SvgPicture.asset(
                                'assets/svgs/coin.svg',
                                height: 20,
                              ),
                    label: Text(
                      '${postCoins.length}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: textColor.withValues(alpha: 0.8),
                          ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () async {},
                    icon: const Icon(Icons.remove_red_eye_outlined,
                        size: 19, color: Colors.black),
                    label: Text(
                      '${post.views ?? 0}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Expanded(
                                      // Set a specific height
                                      child: ListView.separated(
                                        itemCount: 2,
                                        separatorBuilder:
                                            (BuildContext context, int index) =>
                                                const Divider(),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return ListTile(
                                            onTap: () {
                                              Navigator.pop(context);
                                              index == 0
                                                  ? sharePost()
                                                  : repost();
                                            },
                                            minVerticalPadding: 0,
                                            contentPadding:
                                                const EdgeInsets.only(left: 10),
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
                                              index == 0
                                                  ? 'Share Post'
                                                  : postReposts.contains(
                                                              profileController
                                                                  .myProfile
                                                                  .uid)
                                                      ? 'Undo Repost'
                                                      : 'Repost',
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700),
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
                        size: 18.0, color: textColor.withValues(alpha: 1)),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Text(
                          TimeFormat.formatString(post.timestamp),
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: textColor.withValues(alpha: 0.4),
                                  ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
          );
        },
      );
    });
  }
}
