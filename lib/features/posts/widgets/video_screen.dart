import 'dart:async';

import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/posts/models/post_model.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../../action/action.dart';
import '../../../common/models/comment_model.dart';
import '../../../common/models/my_response.dart';
import '../../../common/params.dart';
import '../../../functions/my_native_functions.dart';
import 'package:business_bosses_v2/features/posts/widgets/post_like_comment.dart';
import '../../../utils/theme/theme.dart';
import '../../../utils/time_format.dart';
import '../../profile/controller/profile_controller.dart';
import '../../profile/presentation/public_profile_screen.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({
    super.key,
    required this.post,
  });

  final PostModel post;
  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late ChewieController chewieController;
  late VideoPlayerController videoPlayerController;
  bool showActions = true;
  late PostModel _post;
  final ProfileController profileController = Get.find();
  final HomeController controller = Get.find();

  int _start = 0;
  late Timer _timer;

  void startTimer() {
    setState(() {
      _start = 3;
      showActions = false;
    });
    const Duration oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            showActions = true;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  initializeVideo() {
    // videoPlayerController = VideoPlayerController.network(_post.videoUrl);
    // await videoPlayerController.initialize();

    videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.post.videoUrl ?? ''))
          ..initialize().then(
            (_) {
              // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
              setState(
                () {
                  videoPlayerController.play();
                  videoPlayerController.setLooping(true);
                },
              );
            },
          );

    chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        autoPlay: true,
        looping: true,
        placeholder: Image.network(
          _post.images?[0] ?? '',
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
        fullScreenByDefault: true,
        allowedScreenSleep: false,
        autoInitialize: true,
        hideControlsTimer: const Duration(seconds: 3));
  }

  Future<void> _onDetectableTextTap(String val) async {
    if (val.startsWith('#')) {
      showSnackBar(context, message: val);
      debugPrint('DetectableText >>>>>>> #');
    } else if (val.startsWith('@')) {
      navigateTo(context,
          routeName: PublicProfileScreen.routeName,
          arguments: Params(arg2: val));
    } else if (val.startsWith('http')) {
      debugPrint('DetectableText >>>>>>> http');
      MyResponse res = await MyNativeFunctions.onUrlLaunch(val);
      {
        if (!res.success) {
          showSnackBar(context, message: res.message);
        }
      }
    }
  }

  void _sharePost() {
    String message =
        'Have a look at ${widget.post.user?.username ?? 'Business Bosses'}\'s post on Business Bosses\n'
        'https://businessbosses.onelink.me/xLWk/36a2ff16';
    logEvent(widget.post.postId, 'post');
    socialShare(message);
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => PostLikeCommentItem(
        post: widget.post,
        onComment: (CommentModel newComment) async {},
      ),
    );
  }

  void onLikeTap() async {
    controller.postLike(profileController.myProfile.uid, widget.post.postId,
        'post', widget.post.user!.uid);
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: <SystemUiOverlay>[
          SystemUiOverlay.bottom,
        ]);
    _post = widget.post;
    initializeVideo();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    _timer.cancel();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: <SystemUiOverlay>[SystemUiOverlay.bottom, SystemUiOverlay.top],
    );
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          if (videoPlayerController.value.isInitialized)
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onDoubleTap: onLikeTap,
                      onLongPress: () {
                        startTimer();
                      },
                      child: Chewie(controller: chewieController)),
                ),
              ),
            )
          else
            const Center(
              child: CircularProgressIndicator(
                color: primaryColorLT,
                strokeWidth: 3,
              ),
            ),
          Positioned(
            top: 10,
            left: 10,
            child: Column(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.black.withOpacity(.3)),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (showActions)
            Positioned(
              width: MediaQuery.of(context).size.width,
              bottom: 0,
              child: GestureDetector(
                onDoubleTap: onLikeTap,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  color: const Color(0XFF000000).withOpacity(.3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // SizedBox(
                      //   width: MediaQuery.of(context).size.width,
                      //   child: MyPostItemText(
                      //     _post,
                      //     isDarkView: true,
                      //     onDetectableTextTap: _onDetectableTextTap,
                      //   ),
                      // ),
                      // const SizedBox(height: 5.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // crossAxisAlignment: CrossAxisAlignment.,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              TextButton.icon(
                                onPressed: onLikeTap,
                                icon: widget.post.likes?.contains(
                                            profileController.myProfile.uid) ==
                                        true
                                    ? const Icon(Icons.favorite)
                                    : const Icon(
                                        Icons.favorite_outline,
                                        color: Colors.white,
                                      ),
                                label: Text(
                                  '${widget.post.likes?.length ?? 0}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                ),
                              ),
                              TextButton.icon(
                                onPressed: _showBottomSheet,
                                icon: SvgPicture.asset(
                                  'assets/svgs/comment.svg',
                                  color: Colors.white,
                                ),
                                label: Text(
                                  '${_post.comments?.length ?? 0}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              GestureDetector(
                                onTap: () => _sharePost(),
                                child: SvgPicture.asset(
                                  'assets/svgs/share.svg',
                                  height: 20.0,
                                  width: 20.0,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          // Spacer(),
                          Text(
                            TimeFormat.formatString(_post.timestamp),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.white,
                                ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          // Positioned(
          //   // bottom: 10,
          //   child: Container(
          // padding: const EdgeInsets.all(20),
          // color: const Color(0xFFCBC3BC).withOpacity(.3),
          //     child: Column(
          //       children: [
          // MyPostItemText(
          //   _post,
          //   isDarkView: true,
          //   onDetectableTextTap: _onDetectableTextTap,
          // ),
          // const SizedBox(height: 17.0),
          //         Row(
          //           children: [
          // TextButton.icon(
          //   onPressed: _onLikeTap,
          //   icon: _post.likes.contains(_firebase.uid)
          //       ? const Icon(Icons.favorite)
          //       : const Icon(
          //           Icons.favorite_outline,
          //           color: Colors.white,
          //         ),
          //   label: Text(
          //     '${_post.likes?.length ?? 0}',
          //     style: Theme.of(context).textTheme.bodyText2.copyWith(
          //           fontWeight: FontWeight.w700,
          //           color: Colors.white,
          //         ),
          //   ),
          // ),
          // TextButton.icon(
          //   onPressed: _showBottomSheet,
          //   icon: SvgPicture.asset(
          //     'assets/svgs/comment.svg',
          //     color: Colors.white,
          //   ),
          //   label: Text(
          //     '${_post.comments?.length ?? 0}',
          //     style: Theme.of(context).textTheme.bodyText2.copyWith(
          //           fontWeight: FontWeight.w700,
          //           color: Colors.white,
          //         ),
          //   ),
          // ),
          // const SizedBox(width: 8.0),
          // GestureDetector(
          //   onTap: () => _sharePost(widget.post),
          //   child: SvgPicture.asset(
          //     'assets/svgs/share.svg',
          //     height: 20.0,
          //     width: 20.0,
          //     color: Colors.white,
          //   ),
          // ),
          //             const Spacer(),
          // Text(
          //   TimeFormat.formatString(_post.timestamp),
          //   style: Theme.of(context).textTheme.bodyText2.copyWith(
          //         color: Colors.white,
          //       ),
          // ),
          //           ],
          //         )
          //       ],
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
