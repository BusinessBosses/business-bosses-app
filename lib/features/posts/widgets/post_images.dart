import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/features/posts/widgets/youtube_display.dart';
import 'package:business_bosses_v2/features/posts/widgets/yt_player.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';

import '../models/post_model.dart';
import 'images_viewer_screen.dart';

class PostImages extends StatelessWidget {
  final PostModel post;
  final bool isVideo;
  final bool isYt;
  const PostImages(
      {super.key, required this.post, this.isVideo = false, this.isYt = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      // children: <Widget>[
      //   Stack(
      //     children: <Widget>[
      //       GestureDetector(
      //         onTap: () {
      //           if (isVideo) {
      //             Navigator.of(context).push(
      //               MaterialPageRoute(
      //                 builder: (BuildContext context) => VideoScreen(
      //                   post: post,
      //                 ),
      //               ),
      //             );
      //           } else {
      //             Navigator.of(context).push(
      //               MaterialPageRoute(
      //                 builder: (BuildContext context) => ImagesViewerScreen(
      //                   urls: post.images,
      //                   text: post.title,
      //                 ),
      //               ),
      //             );
      //           }
      //         },
      //         child: Padding(
      //           padding: const EdgeInsets.only(left: 0, right: 0),
      //           child: NetworkImageWithPlaceHolder(
      //             imageUrl: post.images![0],
      //             width: double.infinity,
      //             height: 240.0,
      //             fit: BoxFit.cover,
      //             placeHolder: Icons.photo,
      //             iconSize: 50.0,
      //           ),
      //         ),
      //       ),
      //       if (isVideo)
      //         Positioned(
      //           top: 0,
      //           bottom: 0,
      //           right: 0,
      //           left: 0,
      //           child: GestureDetector(
      //             onTap: () {
      //               Navigator.of(context).push(
      //                 MaterialPageRoute(
      //                   builder: (BuildContext context) => VideoScreen(
      //                     post: post!,
      //                   ),
      //                 ),
      //               );
      //             },
      //             child: Icon(
      //               Icons.play_circle_outlined,
      //               color: Colors.black.withOpacity(0.5),
      //               size: 48,
      //             ),
      //           ),
      //         ),
      //       Positioned(
      //         bottom: 10,
      //         right: 10,
      //         child: Container(
      //             decoration: BoxDecoration(
      //                 color: Colors.black.withOpacity(0.5),
      //                 borderRadius: BorderRadius.circular(6)),
      //             child: const Padding(
      //               padding:
      //                   EdgeInsets.only(top: 3.0, bottom: 3, left: 6, right: 6),
      //               child: Text(
      //                 'time',
      //                 style: TextStyle(color: Colors.white),
      //               ),
      //             )),
      //       )
      //     ],
      //   ),
      //   // SizedBox(height: 4.0),
      //   post.images!.length == 1
      //       ? Container()
      //       : SizedBox(
      //           width: double.infinity,
      //           height: 72.0,
      //           child: Row(
      //             children: <Widget>[
      //               ...<int>[2, 3, 4, 5]
      //                   .map(
      //                     (int i) => Expanded(
      //                       flex: 1,
      //                       child: post.images!.length >= i
      //                           ? GestureDetector(
      //                               onTap: () {
      //                                 Navigator.of(context).push(
      //                                   MaterialPageRoute(
      //                                     builder: (BuildContext context) =>
      //                                         ImagesViewerScreen(
      //                                       urls: post.images,
      //                                       index: i - 1,
      //                                       text: post.title,
      //                                     ),
      //                                   ),
      //                                 );
      //                               },
      //                               child: Stack(
      //                                 children: <Widget>[
      //                                   Container(
      //                                     padding: const EdgeInsets.only(
      //                                         top: 10.0, right: 10),
      //                                     child: NetworkImageWithPlaceHolder(
      //                                       imageUrl: post.images![i - 1],
      //                                       width: double.infinity,
      //                                       height: double.infinity,
      //                                       placeHolder: Icons.photo,
      //                                       iconSize: 18.0,
      //                                       radius: 8.0,
      //                                     ),
      //                                   ),
      //                                   if (post.images!.length > 5 && i == 5)
      //                                     Container(
      //                                       padding: const EdgeInsets.all(0.0),
      //                                       alignment: Alignment.center,
      //                                       color:
      //                                           Colors.white.withOpacity(0.5),
      //                                       child: Text(
      //                                         '+${post.images!.length - 5}',
      //                                         style: headline6.copyWith(
      //                                           fontWeight: FontWeight.bold,
      //                                         ),
      //                                       ),
      //                                     )
      //                                   else
      //                                     Container()
      //                                 ],
      //                               ),
      //                             )
      //                           : Container(),
      //                     ),
      //                   )
      //                   .toList()
      //             ],
      //           ),
      //         ),
      // ],

      // children: <Widget>[
      //   Stack(
      //     children: <Widget>[
      //       GestureDetector(
      //         onTap: () {
      //           if (isYt) {
      //             Navigator.of(context).push(
      //               MaterialPageRoute(
      //                 builder: (BuildContext context) => YoutubeVideo(
      //                   post.ytUrl ?? "",
      //                 ),
      //               ),
      //             );
      //           } else {
      //             Navigator.of(context).push(
      //               MaterialPageRoute(
      //                 builder: (BuildContext context) => ImagesViewerScreen(
      //                   urls: post.images,
      //                   text: post.title,
      //                 ),
      //               ),
      //             );
      //           }
      //         },
      //         child: isYt
      //             ? Padding(
      //                 padding: const EdgeInsets.only(left: 0, right: 0),
      //                 child: NetworkImageWithPlaceHolder(
      //                   imageUrl: post.images![0],
      //                   width: double.infinity,
      //                   height: 240.0,
      //                   fit: BoxFit.cover,
      //                   placeHolder: Icons.photo,
      //                   iconSize: 50.0,
      //                 ),
      //               )
      //             : YoutubeVideo("https://www.youtube.com/watch?v=YMx8Bbev6T4"),
      //       ),
      //       // if (isVideo)
      //       //   Positioned(
      //       //     top: 0,
      //       //     bottom: 0,
      //       //     right: 0,
      //       //     left: 0,
      //       //     child: GestureDetector(
      //       //       onTap: () {
      //       //         Navigator.of(context).push(
      //       //           MaterialPageRoute(
      //       //             builder: (BuildContext context) => VideoScreen(
      //       //               post: post!,
      //       //             ),
      //       //           ),
      //       //         );
      //       //       },
      //       //       child: Icon(
      //       //         Icons.play_circle_outlined,
      //       //         color: Colors.black.withOpacity(0.5),
      //       //         size: 48,
      //       //       ),
      //       //     ),
      //       //   ),
      //       // Positioned(
      //       //   bottom: 10,
      //       //   right: 10,
      //       //   child: Container(
      //       //       decoration: BoxDecoration(
      //       //           color: Colors.black.withOpacity(0.5),
      //       //           borderRadius: BorderRadius.circular(6)),
      //       //       child: const Padding(
      //       //         padding:
      //       //             EdgeInsets.only(top: 3.0, bottom: 3, left: 6, right: 6),
      //       //         child: Text(
      //       //           'time',
      //       //           style: TextStyle(color: Colors.white),
      //       //         ),
      //       //       )),
      //       // )
      //     ],
      //   ),
      //   // SizedBox(height: 4.0),
      //   post.images!.length == 1
      //       ? Container()
      //       : SizedBox(
      //           width: double.infinity,
      //           height: 72.0,
      //           child: Row(
      //             children: <Widget>[
      //               ...<int>[2, 3, 4, 5]
      //                   .map(
      //                     (int i) => Expanded(
      //                       flex: 1,
      //                       child: post.images!.length >= i
      //                           ? GestureDetector(
      //                               onTap: () {
      //                                 Navigator.of(context).push(
      //                                   MaterialPageRoute(
      //                                     builder: (BuildContext context) =>
      //                                         ImagesViewerScreen(
      //                                       urls: post.images,
      //                                       index: i - 1,
      //                                       text: post.title,
      //                                     ),
      //                                   ),
      //                                 );
      //                               },
      //                               child: Stack(
      //                                 children: <Widget>[
      //                                   Container(
      //                                     padding: const EdgeInsets.only(
      //                                         top: 10.0, right: 10),
      //                                     child: NetworkImageWithPlaceHolder(
      //                                       imageUrl: post.images![i - 1],
      //                                       width: double.infinity,
      //                                       height: double.infinity,
      //                                       placeHolder: Icons.photo,
      //                                       iconSize: 18.0,
      //                                       radius: 8.0,
      //                                     ),
      //                                   ),
      //                                   if (post.images!.length > 5 && i == 5)
      //                                     Container(
      //                                       padding: const EdgeInsets.all(0.0),
      //                                       alignment: Alignment.center,
      //                                       color:
      //                                           Colors.white.withOpacity(0.5),
      //                                       child: Text(
      //                                         '+${post.images!.length - 5}',
      //                                         style: headline6.copyWith(
      //                                           fontWeight: FontWeight.bold,
      //                                         ),
      //                                       ),
      //                                     )
      //                                   else
      //                                     Container()
      //                                 ],
      //                               ),
      //                             )
      //                           : Container(),
      //                     ),
      //                   )
      //                   .toList()
      //             ],
      //           ),
      //         ),
      // ],

      children: <Widget>[
        Stack(
          children: <Widget>[
            GestureDetector(
                onTap: () {
                  if (isYt) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => YoutubeVideo(
                          post.ytUrl!,
                        ),
                      ),
                    );
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => ImagesViewerScreen(
                          urls: post.images,
                          text: post.title,
                        ),
                      ),
                    );
                  }
                  // if (!isYt) {
                  //   Navigator.of(context).push(
                  //     MaterialPageRoute(
                  //       builder: (BuildContext context) => ImagesViewerScreen(
                  //         urls: post.images,
                  //         text: post.title,
                  //       ),
                  //     ),
                  //   );
                  // }
                },
                child: isYt
                    ? YoutubeDisplay(post.ytUrl!)
                    : post.images?.isEmpty == true ||
                            post.images == null ||
                            post.images?[0] == ''
                        ? const SizedBox()
                        : post.images!.length == 1
                            ? GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ImagesViewerScreen(
                                        urls: post.images,
                                        text: post.title,
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 0, right: 0),
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
                                                builder:
                                                    (BuildContext context) =>
                                                        ImagesViewerScreen(
                                                  urls: post.images,
                                                  text: post.title,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 0, right: 0),
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
                                          width:
                                              8.0), // Add spacing between images if needed
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        ImagesViewerScreen(
                                                  urls: post.images,
                                                  text: post.title,
                                                  index: 1,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 0, right: 0),
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
                                                builder:
                                                    (BuildContext context) =>
                                                        ImagesViewerScreen(
                                                  urls: post.images,
                                                  text: post.title,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 0, right: 0),
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
                                                    builder: (BuildContext
                                                            context) =>
                                                        ImagesViewerScreen(
                                                      urls: post.images,
                                                      text: post.title,
                                                      index: 1,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 0, right: 0),
                                                child: ClipRRect(
                                                  child:
                                                      NetworkImageWithPlaceHolder(
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
                                                    builder: (BuildContext
                                                            context) =>
                                                        ImagesViewerScreen(
                                                      urls: post.images,
                                                      text: post.title,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: SizedBox(
                                                width: double.infinity,
                                                height: 116.0,
                                                child: Row(
                                                  children: <Widget>[
                                                    ...<int>[3]
                                                        .map(
                                                          (int i) => Expanded(
                                                            flex: 1,
                                                            child: post.images!
                                                                        .length >=
                                                                    i
                                                                ? GestureDetector(
                                                                    onTap: () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .push(
                                                                        MaterialPageRoute(
                                                                          builder: (BuildContext context) =>
                                                                              ImagesViewerScreen(
                                                                            urls:
                                                                                post.images,
                                                                            index:
                                                                                i - 1,
                                                                            text:
                                                                                post.title,
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                    child:
                                                                        Stack(
                                                                      children: <Widget>[
                                                                        Container(
                                                                          child:
                                                                              NetworkImageWithPlaceHolder(
                                                                            borderColor:
                                                                                Colors.black12,
                                                                            imageUrl:
                                                                                post.images![i - 1],
                                                                            width:
                                                                                double.infinity,
                                                                            height:
                                                                                double.infinity,
                                                                            placeHolder:
                                                                                Icons.photo,
                                                                            iconSize:
                                                                                18.0,
                                                                            radius:
                                                                                8.0,
                                                                          ),
                                                                        ),
                                                                        if (post.images!.length >
                                                                                3 &&
                                                                            i ==
                                                                                3)
                                                                          Container(
                                                                            padding:
                                                                                const EdgeInsets.all(0.0),
                                                                            alignment:
                                                                                Alignment.center,
                                                                            color:
                                                                                Colors.white.withOpacity(0.5),
                                                                            child:
                                                                                Text(
                                                                              '+${post.images!.length - 3}',
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
                                                        
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
            if (isYt)
              Positioned(
                top: 0,
                bottom: 0,
                right: 0,
                left: 0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => YoutubeVideo(
                          post.ytUrl!,
                        ),
                      ),
                    );
                  },
                  child: Icon(
                    Icons.play_circle_outlined,
                    color: Colors.black.withOpacity(0.5),
                    size: 48,
                  ),
                ),
              ),
            // if (!isYt)
            //   Positioned(
            //     bottom: 10,
            //     right: 10,
            //     child: Container(
            //         decoration: BoxDecoration(
            //             color: Colors.black.withOpacity(0.5),
            //             borderRadius: BorderRadius.circular(6)),
            //         child: const Padding(
            //           padding: EdgeInsets.only(
            //               top: 3.0, bottom: 3, left: 6, right: 6),
            //           child: Text(
            //             'time',
            //             style: TextStyle(color: Colors.white),
            //           ),
            //         )),
            //   )
          ],
        ),
        // SizedBox(height: 4.0),
        // post.images!.length == 1
        //     ? Container()
        //     : SizedBox(
        //         width: double.infinity,
        //         height: 72.0,
        //         child: Row(
        //           children: <Widget>[
        //             ...<int>[2, 3, 4, 5]
        //                 .map(
        //                   (int i) => Expanded(
        //                     flex: 1,
        //                     child: post.images!.length >= i
        //                         ? GestureDetector(
        //                             onTap: () {
        //                               Navigator.of(context).push(
        //                                 MaterialPageRoute(
        //                                   builder: (BuildContext context) =>
        //                                       ImagesViewerScreen(
        //                                     urls: post.images,
        //                                     index: i - 1,
        //                                     text: post.title,
        //                                   ),
        //                                 ),
        //                               );
        //                             },
        //                             child: Stack(
        //                               children: <Widget>[
        //                                 Container(
        //                                   padding: const EdgeInsets.only(
        //                                       top: 10.0, right: 10),
        //                                   child: NetworkImageWithPlaceHolder(
        //                                     imageUrl: post.images![i - 1],
        //                                     width: double.infinity,
        //                                     height: double.infinity,
        //                                     placeHolder: Icons.photo,
        //                                     iconSize: 18.0,
        //                                     radius: 8.0,
        //                                   ),
        //                                 ),
        //                                 if (post.images!.length > 5 && i == 5)
        //                                   Container(
        //                                     padding: const EdgeInsets.all(0.0),
        //                                     alignment: Alignment.center,
        //                                     color:
        //                                         Colors.white.withOpacity(0.5),
        //                                     child: Text(
        //                                       '+${post.images!.length - 5}',
        //                                       style: headline6.copyWith(
        //                                         fontWeight: FontWeight.bold,
        //                                       ),
        //                                     ),
        //                                   )
        //                                 else
        //                                   Container()
        //                               ],
        //                             ),
        //                           )
        //                         : Container(),
        //                   ),
        //                 )
        //                 .toList()
        //           ],
        //         ),
        //       ),
      ],
    );
  }
}
