import 'package:business_bosses_v2/features/home/widgets/all_learning_posts.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:visibility_detector/visibility_detector.dart';

class CourseList extends StatefulWidget {
  const CourseList({Key? key}) : super(key: key);

  @override
  CourseListState createState() => CourseListState();
}

class CourseListState extends State<CourseList>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  late PageController _pageController;
  late List<YoutubePlayerController> _controllers;
  int _currentPage = 0;
  bool _isVisible = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _pageController = PageController(viewportFraction: 0.8);
    _initializeControllers();
  }

  void _initializeControllers() {
    final List<String> videoIds = <String>[
      'dQw4w9WgXcQ',
      'jNQXAC9IVRw',
      'kJQP7kiw5Fk',
    ];

    _controllers = List<YoutubePlayerController>.generate(
      videoIds.length,
      (int index) => YoutubePlayerController(
        initialVideoId: videoIds[index],
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: true,
          disableDragSeek: true,
          enableCaption: false,
          isLive: false,
          forceHD: false,
          hideControls: false,
        ),
      )..addListener(() {
          if (mounted) {
            setState(() {});
          }
        }),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pageController.dispose();
    for (YoutubePlayerController controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _controllers[_currentPage].pause();
    }
  }

  void pauseAllVideos() {
    for (YoutubePlayerController controller in _controllers) {
      controller.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return VisibilityDetector(
      key: const Key('CourseList'),
      onVisibilityChanged: (VisibilityInfo info) {
        if (info.visibleFraction == 0 && _isVisible) {
          setState(() {
            _isVisible = false;
          });
          pauseAllVideos();
        } else if (info.visibleFraction > 0 && !_isVisible) {
          setState(() {
            _isVisible = true;
          });
        }
      },
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: GestureDetector(
              onTap: () {
                Get.to(
                    () => const AllLearningPostsScreen(isCoursesTile: false));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'Courses & Tutorials',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                  ),
                  Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        // const Text(
                        //   'View all',
                        //   style: TextStyle(fontSize: 11),
                        // ),
                        // const SizedBox(width: 5.0),
                        SvgPicture.asset(
                          'assets/svgs/nexticon.svg',
                          color: textColor,
                          height: 8,
                        ),
                      ]),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 250, // Adjust this height as needed
            child: PageView.builder(
              controller: _pageController,
              padEnds: false,
              itemCount: _controllers.length,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
                pauseAllVideos(); // Pause all videos when the page changes
              },
              itemBuilder: (BuildContext context, int index) {
                return _buildCourseItem(index);
              },
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildCourseItem(int index) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            YoutubePlayer(
              controller: _controllers[index],
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.red,
              progressColors: const ProgressBarColors(
                playedColor: Colors.red,
                handleColor: Colors.redAccent,
              ),
              onReady: () {
                _controllers[index].addListener(() {});
              },
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      _controllers[index].value.volume == 0
                          ? Icons.volume_off
                          : Icons.volume_up,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (_controllers[index].value.volume == 0) {
                        _controllers[index].setVolume(100);
                        _controllers[index].unMute();
                      } else {
                        _controllers[index].setVolume(0);
                        _controllers[index].mute();
                      }
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
            Positioned(
              left: 10,
              bottom: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Course ${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Posted by User ${index + 1}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
