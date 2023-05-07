import 'package:business_bosses_v2/features/posts/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common/widgets/network_image_with_placeholder.dart';
import '../../../../utils/theme/theme.dart';
import 'images_viewer_screen.dart';

class AllImagesItem extends StatelessWidget {
  final List<String> fileUrls;
  final String? text;
  final bool isVideo;
  final int i;
  final PostModel? post;

  const AllImagesItem(
    this.fileUrls, {
    Key? key,
    this.text,
    this.isVideo = false,
    this.i = 0,
    this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            GestureDetector(
              onTap: () {
                // if (isVideo) {
                //   Navigator.of(context).push(
                //     MaterialPageRoute(
                //       builder: (context) => VideoScreen(
                //         onComment: (Post latestPost) {
                //           allPostsForumProv.customPosts[i].comments =
                //               latestPost.comments;
                //         },
                //         onLikeTap: (Post latestPost) {
                //           allPostsForumProv.customPosts[i].likes =
                //               latestPost.likes;
                //         },
                //         post: post,
                //       ),
                //     ),
                //   );
                // } else {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ImagesViewerScreen(
                      urls: fileUrls,
                      text: text,
                    ),
                  ),
                );
                // }
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 0, right: 0),
                child: NetworkImageWithPlaceHolder(
                  imageUrl: fileUrls[0],
                  width: double.infinity,
                  height: 240.0,
                  fit: BoxFit.cover,
                  placeHolder: Icons.photo,
                  iconSize: 50.0,
                ),
              ),
            ),
            // if (isVideo)
            //   Positioned(
            //     top: 0,
            //     bottom: 0,
            //     right: 0,
            //     left: 0,
            //     child: GestureDetector(
            //       onTap: () {
            //         Navigator.of(context).push(
            //           MaterialPageRoute(
            //             builder: (context) => VideoScreen(
            //               // onComment: (latestPost) {
            //               //   allPostsForumProv.customPosts[i].comments =
            //               //       latestPost.comments;
            //               // },
            //               // onLikeTap: (latestPost) {
            //               //   allPostsForumProv.customPosts[i].likes =
            //               //       latestPost.likes;
            //               // },
            //               post: post,
            //             ),
            //           ),
            //         );
            //       },
            //       child: Icon(
            //         Icons.play_circle_outlined,
            //         color: Colors.white.withOpacity(.8),
            //         size: 48,
            //       ),
            //     ),
            //   )
          ],
        ),
        // SizedBox(height: 4.0),
        fileUrls.length == 1
            ? Container()
            : SizedBox(
                width: double.infinity,
                height: 72.0,
                child: Row(
                  children: [
                    ...[2, 3, 4, 5]
                        .map(
                          (i) => Expanded(
                            flex: 1,
                            child: fileUrls.length >= i
                                ? GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ImagesViewerScreen(
                                            urls: fileUrls,
                                            index: i - 1,
                                            text: text,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Stack(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.only(
                                              top: 10.0, right: 10),
                                          child: NetworkImageWithPlaceHolder(
                                            imageUrl: fileUrls[i - 1],
                                            width: double.infinity,
                                            height: double.infinity,
                                            placeHolder: Icons.photo,
                                            iconSize: 18.0,
                                            radius: 8.0,
                                          ),
                                        ),
                                        (fileUrls.length > 5 && i == 5)
                                            ? Container(
                                                padding:
                                                    const EdgeInsets.all(0.0),
                                                alignment: Alignment.center,
                                                color: Colors.white
                                                    .withOpacity(0.5),
                                                child: Text(
                                                  '+${fileUrls.length - 5}',
                                                  style: headline6.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              )
                                            : Container()
                                      ],
                                    ),
                                  )
                                : Container(),
                          ),
                        )
                        .toList()
                  ],
                ),
              ),
      ],
    );
  }
}

/*Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.all(2.0),
                        child: NetworkImageWithPlaceHolder(
                          imageUrl: fileUrls[0],
                          width: double.infinity,
                          height: double.infinity,
                          placeHolder: Icons.photo,
                          iconSize: 18.0,
                          radius: 4.0,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.all(2.0),
                        child: NetworkImageWithPlaceHolder(
                          imageUrl: fileUrls[0],
                          width: double.infinity,
                          height: double.infinity,
                          placeHolder: Icons.photo,
                          iconSize: 18.0,
                          radius: 4.0,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.all(2.0),
                        child: NetworkImageWithPlaceHolder(
                          imageUrl: fileUrls[0],
                          width: double.infinity,
                          height: double.infinity,
                          placeHolder: Icons.photo,
                          iconSize: 18.0,
                          radius: 4.0,
                        ),
                      ),
                    ),*/
