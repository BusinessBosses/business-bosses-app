// ignore_for_file: unused_field

import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeDisplayItem extends StatefulWidget {
  final String youtubeUrl;
  final BorderRadiusGeometry? corner;

  const YoutubeDisplayItem(this.youtubeUrl, {this.corner, super.key});

  @override
  _YoutubeDisplayState createState() => _YoutubeDisplayState();
}

class _YoutubeDisplayState extends State<YoutubeDisplayItem> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  late TextEditingController _idController;
  late TextEditingController _seekToController;
  final bool _isPlayerReady = false;
  String? videoId;
  String? _thumbnailUrl;

  @override
  void initState() {
    super.initState();
    videoId = YoutubePlayer.convertUrlToId(widget.youtubeUrl);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
    _loadThumbnail();
  }

  Future<void> _loadThumbnail() async {
    if (videoId != null) {
      _thumbnailUrl = 'https://img.youtube.com/vi/$videoId/0.jpg';
    }
  }

  @override
  void didUpdateWidget(covariant YoutubeDisplayItem oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void listener() {}

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    _idController.dispose();
    _seekToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  VisibilityDetector(
        key: const Key('unique key'),
        onVisibilityChanged: (VisibilityInfo info) {},
        child: ClipRRect(
          borderRadius: widget.corner ?? BorderRadius.circular(10),
          child: _thumbnailUrl == null
              ? Container(
                  color: backgroundColor,
                  height: 90,
                  width: 160,
                )
              : Image.network(_thumbnailUrl!),
        ),
      )
    ;
  }
}
