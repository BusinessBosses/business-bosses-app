import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/features/posts/models/post_model.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';

import 'images_viewer_screen.dart';

class PostImages extends StatelessWidget {
  final PostModel post;
  const PostImages({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ImagesViewerScreen(
                      urls: post.images,
                      text: post.title,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 0, right: 0),
                child: NetworkImageWithPlaceHolder(
                  imageUrl: post.images![0],
                  width: double.infinity,
                  height: 240.0,
                  fit: BoxFit.cover,
                  placeHolder: Icons.photo,
                  iconSize: 50.0,
                ),
              ),
            ),
          ],
        ),
        // SizedBox(height: 4.0),
        post.images!.length == 1
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
                            child: post.images!.length >= i
                                ? GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ImagesViewerScreen(
                                            urls: post.images,
                                            index: i - 1,
                                            text: post.title,
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
                                            imageUrl: post.images![i - 1],
                                            width: double.infinity,
                                            height: double.infinity,
                                            placeHolder: Icons.photo,
                                            iconSize: 18.0,
                                            radius: 8.0,
                                          ),
                                        ),
                                        if (post.images!.length > 5 && i == 5)
                                          Container(
                                            padding: const EdgeInsets.all(0.0),
                                            alignment: Alignment.center,
                                            color:
                                                Colors.white.withOpacity(0.5),
                                            child: Text(
                                              '+${post.images!.length - 5}',
                                              style: headline6.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          )
                                        else
                                          Container()
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
