import 'package:business_bosses_v2/features/posts/controllers/posts_controller.dart';
import 'package:business_bosses_v2/features/posts/models/post_model.dart';
import 'package:business_bosses_v2/features/posts/presentation/widgets/post_images.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/features/profile/presentation/publicprofilescreen.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/constants/constants.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../common/widgets/ranking_badge.dart';
import '../../../../common/widgets/text_widget.dart';
import '../../../../common/widgets/user_avatar_with_badge.dart';
import '../../../../utils/theme/theme.dart';
import '../../../../utils/time_format.dart';

// import 'rep';
class PostTile extends StatelessWidget {
  final PostModel post;
  final PostsController controller;
  final Function(int)? onPageChange;

  ///
  const PostTile(
      {Key? key,
      required this.post,
      required this.controller,
      this.onPageChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find();

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
                  onTap: () {
                    if (profileController.myProfile.uid == post.user!.uid) {
                      if (onPageChange != null) {
                        onPageChange!(3);
                      }
                    } else {
                      Get.toNamed(Routes.publicProfile, arguments: post.user);
                    }
                  },
                  child: UserAvatarWithBadge(
                    user: post.user,
                    height: 55.0,
                    width: 55.0,
                    radius: 50.0,
                    placeHolder: Icons.person,
                    iconSize: 24.0,
                  ),
                ),
                title: GestureDetector(
                  onTap: () {
                    // Get.to(() => PublicProfileScreen());
                    if (profileController.myProfile.uid == post.user!.uid) {
                      if (onPageChange != null) {
                        onPageChange!(3);
                      }
                    } else {
                      Get.toNamed(Routes.publicProfile, arguments: post.user);
                    }
                  },
                  child: Text(
                    '${post.user?.username}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                trailing: SizedBox(
                  height: 30,
                  width: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      post.isRanked
                          ? Container()
                          : Container(
                              width: leadingWidth(post),
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
                          padding: const EdgeInsets.only(left: 15, right: 10),
                          child: SvgPicture.asset(
                            'assets/svgs/more.svg',
                            width: 5,
                            height: 3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                subtitle: Text(
                  post.user?.bio ?? '',
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
                    if (post.promote ?? false)
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
                          text: post.title,
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
                    if (post.images?.isNotEmpty ?? false)
                      PostImages(
                        post: post,
                      ),
                  ],
                ),
              ),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () {
                      controller.postLike(
                          profileController.myProfile.uid, post.postId);
                    },
                    icon:
                        post.likes?.contains(profileController.myProfile.uid) ??
                                false
                            ? SvgPicture.asset('assets/svgs/likefilled.svg')
                            : SvgPicture.asset('assets/svgs/like.svg'),
                    label: Text(
                      '${post.likes?.length ?? 0}',
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
                      '${post.comments?.length ?? 0}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: textColor.withOpacity(0.8),
                          ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () async {
                      // final sandBox = GetStorage();
                      // final String uid = sandBox.read(Constants.USER_ID);
                      controller.postCoin(profileController.myProfile.uid,
                          post.postId, profileController);
                    },
                    icon:
                        post.coins?.contains(profileController.myProfile.uid) ??
                                false
                            ? SvgPicture.asset('assets/svgs/coin.svg')
                            : SvgPicture.asset('assets/svgs/coin.svg'),
                    label: Text(
                      '${post.coins?.length ?? 0}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: textColor.withOpacity(0.8),
                          ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  GestureDetector(
                    onTap: () => _sharePost(post),
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
                      TimeFormat.formatString(post.timestamp),
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
