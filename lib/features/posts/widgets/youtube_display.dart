import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:visibility_detector/visibility_detector.dart';

class YoutubeDisplay extends StatefulWidget {
  final String youtubeUrl;
  final BorderRadiusGeometry? corner;

  const YoutubeDisplay(this.youtubeUrl, {this.corner, super.key});

  @override
  _YoutubeDisplayState createState() => _YoutubeDisplayState();
}

class _YoutubeDisplayState extends State<YoutubeDisplay> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  late YoutubePlayerController _controller;
  late TextEditingController _idController;
  late TextEditingController _seekToController;
  final bool _isPlayerReady = false;
  late String? videoId;

  @override
  void initState() {
    super.initState();
    videoId = YoutubePlayer.convertUrlToId(widget.youtubeUrl)!;
    _controller = YoutubePlayerController(
      initialVideoId: videoId!,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
  }

  @override
  void didUpdateWidget(covariant YoutubeDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.youtubeUrl != widget.youtubeUrl) {
      videoId = YoutubePlayer.convertUrlToId(widget.youtubeUrl)!;
      _controller.load(videoId!);
    }
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
    _idController.dispose();
    _seekToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: widget.corner ??
            BorderRadius.circular(50), // Adjust the radius as needed
        color: Colors.blue,
      ),
      height: 200,
      child: VisibilityDetector(
        key: const Key('unique key'),
        onVisibilityChanged: (VisibilityInfo info) {
          if (info.visibleFraction == 0) {
            _controller.pause();
          } else {
            _controller.value.isPlaying
                ? _controller.play()
                : _controller.pause();
          }
        },
        child: ClipRRect(
          // Use ClipRRect to round the player
          borderRadius: widget.corner ??
              BorderRadius.circular(10), // Adjust the radius as needed
          child: YoutubePlayerBuilder(
            onExitFullScreen: () {
              // The player forces portraitUp after exiting fullscreen. This overrides the behavior.
              SystemChrome.setPreferredOrientations(DeviceOrientation.values);
            },
            player: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.blueAccent,
              topActions: <Widget>[
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    _controller.metadata.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
              onReady: () {
                _controller.addListener(listener);
              },
              onEnded: (YoutubeMetaData data) {},
            ),
            builder: (BuildContext context, Widget player) => Scaffold(
              key: _scaffoldKey,
              body: ListView(
                children: <Widget>[
                  player,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
