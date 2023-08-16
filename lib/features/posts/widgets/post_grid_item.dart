import 'package:business_bosses_v2/features/posts/controllers/create_post_controller.dart';
import 'package:business_bosses_v2/features/posts/models/post_model.dart';
import 'package:business_bosses_v2/features/posts/presentation/boost_post_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';

import '../../../action/action.dart';
import '../../../common/models/my_response.dart';
import '../../../common/widgets/network_image_with_placeholder.dart';
import '../../../common/widgets/popup/my_popup_menu_button.dart';
import '../../../functions/my_native_functions.dart';
import '../../../utils/theme/theme.dart';
import '../presentation/create_post_screen.dart';
import 'images_viewer_screen.dart';

class PostGridItem extends StatelessWidget {
  final PostModel post;
  final CreatePostController createPostController = CreatePostController();
  // final Function(String postId)? onDeletePost;
  final bool hasMore;
  final Function? onTap;

  PostGridItem({
    Key? key,
    required this.post,
    // this.onDeletePost,
    this.onTap,
    this.hasMore = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap!();
      },
      child: Container(
        key: key,
        margin: const EdgeInsets.all(7.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radiusValue),
        ),
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(radiusValue),
                child: post.images?.isNotEmpty == true
                    ? NetworkImageWithPlaceHolder(
                        imageUrl: post.images![0],
                        fit: BoxFit.cover,
                        placeHolder: Icons.photo,
                        iconSize: 48.0,
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: hasMore
                              ? const EdgeInsets.only(right: 26.0)
                              : const EdgeInsets.all(0.0),
                          child: Linkify(
                            text: post.title,
                            style: bodyText2.copyWith(
                              fontWeight: FontWeight.normal,
                            ),
                            onOpen: (LinkableElement linkableElement) =>
                                _onUrlClick(context, linkableElement),
                            options: const LinkifyOptions(humanize: false),
                            linkStyle: bodyText2.copyWith(
                              color: Colors.blue,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        // Text(
                        //   '${post.title}',
                        //   style: bodyText2.copyWith(fontSize: 16.0),
                        //   maxLines: 7,
                        //   overflow: TextOverflow.ellipsis,
                        // ),
                      ),
              ),
            ),
            if (post.images != null && post.images!.isNotEmpty)
              Positioned(
                bottom: 10.0,
                right: 10.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => ImagesViewerScreen(
                          urls: post.images,
                          text: post.title,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    padding: const EdgeInsets.only(
                        top: 8.0, bottom: 8.0, left: 8.0, right: 8.0),
                    // height: 30.0,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.copy,
                          size: 18.0,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          '${post.images?.length}',
                          style: bodyText1.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            if (hasMore)
              Positioned(
                top: 10.0,
                right: 10.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  height: 26.0,
                  width: 26.0,
                  child: MyPopupMenuButton(
                    popupItems: _popupItemPostMore,
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                      size: 16.0,
                    ),
                    onSelected: (String val) {
                      if (val == 'Edit') {
                        Get.to(() => CreatePostScreen(
                              postId: post.postId,
                              post: post.title,
                              postDetail: post,
                              images: post.images,
                            ));
                      } else if (val == 'Delete') {
                        _showDialog(context);
                      } else if (val == 'Boost') {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => BoostPost(
                                postId: post.postId, postTitle: post.title),
                          ),
                        );
                      }
                    },
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  Future<void> _onUrlClick(
      BuildContext context, LinkableElement linkableElement) async {
    MyResponse res = await MyNativeFunctions.onUrlLaunch(linkableElement.url);
    if (!res.success) {
      showSnackBar(context, message: res.message);
    }
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'Delete Post',
          style: bodyText1,
        ),
        content: const Text('Are you sure to delete this post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              createPostController.onDeletePost(post.postId);
              navigateTo(context);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  final List<PopupMenuEntry<String>> _popupItemPostMore = [
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
    const PopupMenuDivider(
      height: 0.0,
    ),
    const PopupMenuItem<String>(
      value: 'Boost',
      child: Text(
        'Boost',
        style: bodyText2,
      ),
    ),
  ];
}
