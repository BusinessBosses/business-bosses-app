import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeVideo extends StatefulWidget {
  final String youtubeUrl;

  const YoutubeVideo(this.youtubeUrl, {super.key});

  @override
  State<YoutubeVideo> createState() => _YoutubeVideoState();
}

class _YoutubeVideoState extends State<YoutubeVideo> {
  late YoutubePlayerController _controller;
  final bool _isPlayerReady = false;
  late String videoId;

  @override
  void initState() {
    super.initState();
    videoId = YoutubePlayer.convertUrlToId(widget.youtubeUrl)!;
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {});
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to the next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        if (orientation == Orientation.portrait) {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        } else {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
        }
        return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (orientation == Orientation.portrait)
                  const SizedBox(
                    height: 50,
                    child: BackButton(
                      color: Colors.white,
                    ),
                  ),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 8,
                        right: 8,
                      ),
                      child: YoutubePlayer(
                        showVideoProgressIndicator: true,
                        onEnded: (YoutubeMetaData metaData) {},
                        controller: _controller,
                        aspectRatio: 1.5,
                        progressIndicatorColor: Colors.red,
                        bottomActions: <Widget>[
                          const SizedBox(width: 14.0),
                          CurrentPosition(),
                          const SizedBox(width: 8.0),
                          ProgressBar(
                            isExpanded: true,
                            colors: const ProgressBarColors(),
                          ),
                          RemainingDuration(),
                          const PlaybackSpeedButton(),
                          IconButton(
                            icon: Icon(
                              orientation == Orientation.landscape
                                  ? Icons.fullscreen_exit
                                  : Icons.fullscreen,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              if (orientation == Orientation.landscape) {
                                portraitModeOnly();
                              } else {
                                landscapeModeOnly();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void portraitModeOnly() {
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void landscapeModeOnly() {
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
}
