import 'package:business_bosses_v2/features/forum/models/forum_model.dart';
import 'package:business_bosses_v2/features/posts/widgets/youtube_display.dart';
import 'package:business_bosses_v2/features/posts/widgets/yt_player.dart';
import 'package:flutter/material.dart';

import '../../../common/widgets/network_image_with_placeholder.dart';
import '../../../utils/theme/theme.dart';
import 'images_viewer_screen.dart';

class AllForumsImagesItem extends StatelessWidget {
  final List<String> fileUrls;
  final String? text;
  final bool isYt;
  final bool isVideo;
  final int i;
  final ForumModel post;

  const AllForumsImagesItem(
    this.fileUrls, {
    Key? key,
    this.text,
    this.isYt = false,
    this.i = 0,
    required this.post,
    this.isVideo = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
                        urls: fileUrls,
                        text: text,
                      ),
                    ),
                  );
                }
              },
              child: isYt
                  ? YoutubeDisplay(post.ytUrl!)
                  : Padding(
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
          ],
        ),
        // SizedBox(height: 4.0),
        fileUrls.length == 1
            ? Container()
            : SizedBox(
                width: double.infinity,
                height: 72.0,
                child: Row(
                  children: <Widget>[
                    ...<int>[2, 3, 4, 5]
                        .map(
                          (int i) => Expanded(
                            flex: 1,
                            child: fileUrls.length >= i
                                ? GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              ImagesViewerScreen(
                                            urls: fileUrls,
                                            index: i - 1,
                                            text: text,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Stack(
                                      children: <Widget>[
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
