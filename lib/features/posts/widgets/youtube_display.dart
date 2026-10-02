import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeDisplay extends StatefulWidget {
  final String youtubeUrl;
  final BorderRadiusGeometry? corner;

  const YoutubeDisplay(this.youtubeUrl, {this.corner, super.key});

  @override
  State<YoutubeDisplay> createState() => _YoutubeDisplayState();
}

class _YoutubeDisplayState extends State<YoutubeDisplay> {
  late YoutubePlayerController _controller;
  late TextEditingController _idController;
  late TextEditingController _seekToController;
  String? videoId;

  @override
  void initState() {
    super.initState();
    videoId = YoutubePlayerController.convertUrlToId(widget.youtubeUrl);
    _controller = YoutubePlayerController.fromVideoId(
      videoId: videoId ?? '',
      autoPlay: false,
      params: const YoutubePlayerParams(
        mute: false,
        showControls: true,
        showFullscreenButton: true,
      ),
    );
    _idController = TextEditingController();
    _seekToController = TextEditingController();
  }

  @override
  void didUpdateWidget(covariant YoutubeDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.youtubeUrl != widget.youtubeUrl) {
      videoId = YoutubePlayerController.convertUrlToId(widget.youtubeUrl);
      if (videoId != null && videoId!.isNotEmpty) {
        _controller.loadVideoById(videoId: videoId!);
      }
    }
  }

  @override
  void deactivate() {
    _controller.pauseVideo();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.close();
    _idController.dispose();
    _seekToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: widget.corner ?? BorderRadius.circular(50),
        color: Colors.blue,
      ),
      height: 200,
      child: VisibilityDetector(
        key: const Key('unique key'),
        onVisibilityChanged: (VisibilityInfo info) {
          if (info.visibleFraction == 0) {
            _controller.pauseVideo();
          } else {
            if (_controller.value.playerState == PlayerState.paused) {
              _controller.playVideo();
            }
          }
        },
        child: ClipRRect(
          borderRadius: widget.corner ?? BorderRadius.circular(10),
          child: YoutubePlayer(
            controller: _controller,
          ),
        ),
      ),
    );
  }
}
