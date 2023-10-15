import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/posts/widgets/post_like_comment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../common/models/comment_model.dart';
import '../../../utils/theme/theme.dart';
import '../../../utils/time_format.dart';
import '../../profile/controller/profile_controller.dart';
import '../models/post_model.dart';

class PostInteractionsWidget extends StatelessWidget {
  final PostModel post;
  final ProfileController profileController;

  final Function() sharePost;

  const PostInteractionsWidget({
    super.key,
    required this.post,
    required this.profileController,
    required this.sharePost,
  });

  @override
  Widget build(BuildContext context) {
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
                        post.likes?.contains(profileController.myProfile.uid) ==
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
                      '${post.likes?.length ?? 0}',
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
                            color: textColor.withOpacity(0.8),
                          ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: post.user!.uid == profileController.myProfile.uid
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
                        post.coins?.contains(profileController.myProfile.uid) ==
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
                      '${post.coins?.length ?? 0}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: textColor.withOpacity(0.8),
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
                            color: textColor.withOpacity(0.8),
                          ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  GestureDetector(
                    onTap: sharePost,
                    child: SvgPicture.asset(
                      'assets/svgs/share.svg',
                      height: 15.0,
                      width: 15.0,
                    ),
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
                                    color: textColor.withOpacity(0.4),
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
  }
}
