import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:visibility_detector/visibility_detector.dart';

class YoutubeDisplayItem extends StatefulWidget {
  final String youtubeUrl;
  final BorderRadiusGeometry? corner;

  const YoutubeDisplayItem(this.youtubeUrl, {this.corner, Key? key})
      : super(key: key);

  @override
  _YoutubeDisplayState createState() => _YoutubeDisplayState();
}

class _YoutubeDisplayState extends State<YoutubeDisplayItem> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  late TextEditingController _idController;
  late TextEditingController _seekToController;
  final bool _isPlayerReady = false;
  late String? videoId;

  String? _thumbnailUrl;

  @override
  void initState() {
    super.initState();
    videoId = YoutubePlayer.convertUrlToId(widget.youtubeUrl)!;
    if (videoId != null) {
      setState(() {
        _thumbnailUrl = 'https://img.youtube.com/vi/$videoId/0.jpg';
      });
    }
    _idController = TextEditingController();
    _seekToController = TextEditingController();
  }

  @override
  void didUpdateWidget(covariant YoutubeDisplayItem oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void listener() {}

  @override
  void deactivate() {
    // Pauses video while navigating to the next page.

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
    return Container(
      decoration: BoxDecoration(
        borderRadius: widget.corner ??
            BorderRadius.circular(50), // Adjust the radius as needed
        color: backgroundColor,
      ),
      height: 250,
      child: VisibilityDetector(
        key: const Key('unique key'),
        onVisibilityChanged: (VisibilityInfo info) {},
        child: ClipRRect(
          borderRadius: widget.corner ?? BorderRadius.circular(10),
          child: Image.network(_thumbnailUrl ?? ''  ),
        ),
      ),
    );
  }
}
