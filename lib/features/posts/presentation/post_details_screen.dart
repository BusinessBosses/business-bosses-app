import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../action/action.dart';
import '../../../common/generic_slider.dart';
import '../../../common/models/comment_model.dart';
import '../../../common/widgets/text_widget.dart';
import '../../../utils/theme/theme.dart';
import '../../../utils/time_format.dart';
import '../../profile/analysescreen.dart';
import '../../profile/controller/profile_controller.dart';
import '../models/post_model.dart';
import '../widgets/all_images_item.dart';
import '../widgets/create_post_user_tile.dart';
import '../widgets/post_like_comment.dart';
import 'boost_post_screen.dart';

// ignore: public_member_api_docs
class PostDetailsScreen extends StatelessWidget {
  // final PostModel post;
  const PostDetailsScreen({Key? key}) : super(key: key);

  // ignore: public_member_api_docs
  // static const String routeName = '/post-details-screen';

  @override
  Widget build(BuildContext context) {
    // if (Get.arguments == null) {
    //   Get.back();
    // }
    PostModel post = Get.arguments;
    // PostModel? post;
    // String? postId;
    // int? postIndex;
    ProfileController profileController = Get.find();
    return WillPopScope(
        onWillPop: () async {
          // navigateTo(context, arguments: post);
          return false;
        },
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
              ),
              centerTitle: true,
              title: const Text('View Post'),
            ),
            body: post == null
                ? const Center(
                    child: CircularProgressIndicator.adaptive(),
                  )
                : SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        const SizedBox(
                          width: double.infinity,
                          height: 20,
                          child: ColoredBox(color: backgroundcolorinterface),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: CreatePostUserTile(
                            user: post.user,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const SizedBox(
                          width: double.infinity,
                          height: 1,
                          child: ColoredBox(color: backgroundcolorinterface),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, bottom: 10),
                          child: post.promote != null && post.promote == true
                              ? Container(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 5, bottom: 5),
                                  decoration: const BoxDecoration(
                                      color: backgroundcolorinterface,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: TextWidget(
                                    text: post.approved!
                                        ? 'Ongoing Ad'
                                        : 'Pending Ad',
                                    fontWeight: FontWeight.w700,
                                    size: 17,
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(
                          height: 0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: post.title.isNotEmpty
                              ? Linkify(
                                  text: post.title,
                                  style: bodyText1.copyWith(
                                      fontWeight: FontWeight.normal),
                                  onOpen: onUrlClick,
                                  options:
                                      const LinkifyOptions(humanize: false),
                                  linkStyle: bodyText1.copyWith(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.normal),
                                )
                              : null,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child:
                              post.videoUrl != null && post.videoUrl!.isNotEmpty
                                  ? AllImagesItem(
                                      post.images!,
                                      post: post,
                                      text: post.title,
                                      isVideo: true,
                                      // i: postIndex!,
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(
                                        left: 0,
                                        right: 0,
                                        top: 0,
                                      ),
                                      child: post.images != null &&
                                              post.images!.isNotEmpty
                                          ? Container(
                                              height: 200,
                                              decoration: const BoxDecoration(
                                                color: Colors.black,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(15),
                                                ),
                                              ),
                                              child: GenericSlider(
                                                images: post.images!,
                                              ),
                                            )
                                          : null,
                                    ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  TextButton.icon(
                                    onPressed: () async {},
                                    icon: post.likes?.contains(profileController
                                                .myProfile.uid) ==
                                            true
                                        ? SvgPicture.asset(
                                            'assets/svgs/likefilled.svg')
                                        : SvgPicture.asset(
                                            'assets/svgs/like.svg'),
                                    label: Text(
                                      '${post.likes?.length ?? 0}',
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
                                          post: post,
                                          onComment: (CommentModel
                                              newComment) async {},
                                        ),
                                      );
                                    },
                                    icon: SvgPicture.asset(
                                        'assets/svgs/comment.svg'),
                                    label: Text(
                                      '${post.comments?.length ?? 0}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: textColor.withOpacity(0.8),
                                          ),
                                    ),
                                  ),
                                  post.user!.uid !=
                                          profileController.myProfile.uid
                                      ? TextButton.icon(
                                          onPressed: () async {},
                                          icon: post.coins?.contains(
                                                      profileController
                                                          .myProfile.uid) ==
                                                  true
                                              ? SvgPicture.asset(
                                                  'assets/svgs/coin.svg')
                                              : SvgPicture.asset(
                                                  'assets/svgs/coin.svg'),
                                          label: Text(
                                            '${post.coins?.length ?? 0}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w700,
                                                  color: textColor
                                                      .withOpacity(0.8),
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
                                      TimeFormat.formatString(post.timestamp),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: textColor.withOpacity(0.4),
                                          ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: double.infinity,
                          height: 1,
                          child: ColoredBox(color: backgroundcolorinterface),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 0),
                              child: post.promote != null &&
                                      post.promote == true
                                  ? Align(
                                      alignment: Alignment.centerRight,
                                      child: GestureDetector(
                                        onTap: () {
                                          navigateTo(context,
                                              routeName:
                                                  AnalyserScreen.routeName);
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 5.0,
                                          ),
                                          decoration: BoxDecoration(
                                            color: primaryColorLT,
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              TextWidget(
                                                text: 'View Analytics',
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                size: 18,
                                              ),
                                              SizedBox(
                                                width: 10.0,
                                              ),
                                              Icon(
                                                Icons
                                                    .stacked_line_chart_rounded,
                                                color: Colors.white,
                                                size: 23,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  : ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          minimumSize: const Size(150,
                                              50) // put the width and height you want
                                          ),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          // ignore: always_specify_types
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                BoostPost(postId: post.postId),
                                          ),
                                        );
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        // ignore: always_specify_types
                                        children: [
                                          const Text(
                                            '  Boost Post   ',
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          SvgPicture.asset(
                                            'assets/svgs/rocket.svg',
                                            color: Colors.white,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                        ],
                                      )),
                            ),
                          ),
                        )
                      ]))));
  }

  void onUrlClick(LinkableElement link) {}

  void _sharePost() {}
}
