import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/features/marketplace/models/market_model.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';

import '../../posts/widgets/images_viewer_screen.dart';

class PostImagesMarket extends StatelessWidget {
  final MarketModel post;
  const PostImagesMarket({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return post.images?.isEmpty == true ||
            post.images == null ||
            post.images?[0] == ''
        ? const SizedBox()
        : post.images!.length == 1
            ? GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => ImagesViewerScreen(
                        urls: post.images,
                        text: post.description,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 0, right: 0),
                  child: NetworkImageWithPlaceHolder(
                    borderColor: Colors.black12,
                    imageUrl: post.images?[0],
                    width: double.infinity,
                    height: 240.0,
                    fit: BoxFit.cover,
                    placeHolder: Icons.photo,
                    iconSize: 50.0,
                  ),
                ),
              )
            : post.images!.length == 2
                ? Row(
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ImagesViewerScreen(
                                  urls: post.images,
                                  text: post.description,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0, right: 0),
                            child: NetworkImageWithPlaceHolder(
                              borderColor: Colors.black12,
                              imageUrl: post.images?[0],
                              height: 240.0,
                              fit: BoxFit.cover,
                              placeHolder: Icons.photo,
                              iconSize: 50.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                          width: 8.0), // Add spacing between images if needed
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ImagesViewerScreen(
                                  urls: post.images,
                                  text: post.description,
                                  index: 1,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0, right: 0),
                            child: NetworkImageWithPlaceHolder(
                              borderColor: Colors.black12,
                              imageUrl: post.images?[1],
                              height: 240.0,
                              fit: BoxFit.cover,
                              placeHolder: Icons.photo,
                              iconSize: 50.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ImagesViewerScreen(
                                  urls: post.images,
                                  text: post.description,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0, right: 0),
                            child: NetworkImageWithPlaceHolder(
                              borderColor: Colors.black12,
                              imageUrl: post.images?[0],
                              height: 240.0,
                              fit: BoxFit.cover,
                              placeHolder: Icons.photo,
                              iconSize: 50.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .stretch, // Make sure Column takes up full width
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ImagesViewerScreen(
                                      urls: post.images,
                                      index: 1,
                                      text: post.description,
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 0, right: 0),
                                child: ClipRRect(
                                  child: NetworkImageWithPlaceHolder(
                                    borderColor: Colors.black12,
                                    imageUrl: post.images?[1],
                                    height: 116.0,
                                    fit: BoxFit.cover,
                                    placeHolder: Icons.photo,
                                    iconSize: 50.0,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ImagesViewerScreen(
                                      urls: post.images,
                                      text: post.description,
                                    ),
                                  ),
                                );
                              },
                              child: SizedBox(
                                width: double.infinity,
                                height: 116.0,
                                child: Row(
                                  children: <Widget>[
                                    ...<int>[3].map(
                                      (int i) => Expanded(
                                        flex: 1,
                                        child: post.images!.length >= i
                                            ? GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          ImagesViewerScreen(
                                                        urls: post.images,
                                                        index: i - 1,
                                                        text: post.description,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Stack(
                                                  children: <Widget>[
                                                    NetworkImageWithPlaceHolder(
                                                      borderColor:
                                                          Colors.black12,
                                                      imageUrl:
                                                          post.images![i - 1],
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                      placeHolder: Icons.photo,
                                                      iconSize: 18.0,
                                                      radius: 8.0,
                                                    ),
                                                    if (post.images!.length >
                                                            3 &&
                                                        i == 3)
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(0.0),
                                                        alignment:
                                                            Alignment.center,
                                                        color: Colors.white
                                                            .withValues(
                                                                alpha: 0.5),
                                                        child: Text(
                                                          '+${post.images!.length - 3}',
                                                          style: headline6
                                                              .copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
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
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
  }
}
