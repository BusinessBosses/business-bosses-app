import 'package:business_bosses_v2/action/action.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/models/comment_model.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/common/widgets/buttons/my_outlined_button.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/common/widgets/popup/my_popup_menu_button.dart';
import 'package:business_bosses_v2/common/widgets/typography/text_widget.dart';
import 'package:business_bosses_v2/features/chat/chat_room_screen.dart';
import 'package:business_bosses_v2/features/courses/controller/course_controller.dart';
import 'package:business_bosses_v2/features/courses/models/course_comment_model.dart';
import 'package:business_bosses_v2/features/courses/models/course_model.dart';
import 'package:business_bosses_v2/features/courses/models/reviews_model.dart';
import 'package:business_bosses_v2/features/courses/presentation/course_item.dart';
import 'package:business_bosses_v2/features/courses/presentation/create_course.dart';
import 'package:business_bosses_v2/features/courses/widgets/course_comment_bottomsheet.dart';
import 'package:business_bosses_v2/features/courses/widgets/downloadable_item.dart';
import 'package:business_bosses_v2/features/courses/widgets/unpaidcoursepopup.dart';
import 'package:business_bosses_v2/features/posts/presentation/boost_post_screen.dart';
import 'package:business_bosses_v2/features/posts/widgets/my_container.dart';
import 'package:business_bosses_v2/features/posts/widgets/youtube_display.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';

int selectedVideo = 0;

class ExpandedCourseScreen extends StatefulWidget {
  static const String routeName = '/expandedcoursescreen';
  final CourseModel course;

  const ExpandedCourseScreen({Key? key, required this.course})
      : super(key: key);

  @override
  _ExpandedCourseScreenState createState() => _ExpandedCourseScreenState();
}

class _ExpandedCourseScreenState extends State<ExpandedCourseScreen> {
  String? description;
  bool isLoading = false;
  bool isSending = false;
  bool loading = true;
  bool insufficientBalance = false;
  List<String> blocked = <String>[];
  List<ReviewModel>? reviews;
  int oneStar = 0;
  int twoStar = 0;
  int threeStar = 0;
  int fourStar = 0;
  int fiveStar = 0;

  ProfileController profileController = Get.find();
  final List<PopupMenuEntry<String>> myPopupMore = <PopupMenuEntry<String>>[
    const PopupMenuItem<String>(
      value: 'Edit',
      child: Text(
        'Edit',
        style: bodyText2,
      ),
    ),
    const PopupMenuDivider(
      height: 0.0,
    ),
    const PopupMenuItem<String>(
      value: 'Delete',
      child: Text(
        'Delete',
        style: bodyText2,
      ),
    ),
    const PopupMenuDivider(
      height: 0.0,
    ),
    const PopupMenuItem<String>(
      value: 'Boost',
      child: Text(
        'Boost',
        style: bodyText2,
      ),
    ),
  ];

  final List<PopupMenuEntry<String>> myPopup = <PopupMenuEntry<String>>[
    const PopupMenuItem<String>(
      value: 'Hide',
      child: Text(
        'Hide',
        style: bodyText2,
      ),
    ),
    const PopupMenuDivider(
      height: 0.0,
    ),
    const PopupMenuItem<String>(
      value: 'Report',
      child: Text(
        'Report',
        style: bodyText2,
      ),
    )
  ];

  @override
  void initState() {
    super.initState();
    // Initialize data or perform any other necessary setup
  }

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();
    return Scaffold(
      backgroundColor:Colors.white,
      body: NestedScrollView(
        controller: scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
              ),
              centerTitle: true,
              title: Text(
                widget.course.title!,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              expandedHeight: 300.0,
              collapsedHeight: 300.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.only(top: 120.0),
                  child: Stack(
                    children: [
                      YoutubeDisplay(
                        widget.course.youtubeUrls![selectedVideo],
                        corner: BorderRadius.circular(0),
                      ),
                      Visibility(
                        visible: widget.course.courseType == 'paid',
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              barrierColor: Colors.black.withAlpha(240),
                              context: context,
                              builder: (BuildContext context) =>
                                  UnpaidCoursePopUp(
                                course: widget.course,
                              ),
                            );
                          },
                          child: Container(
                            color: Colors.transparent,
                            height: 200,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: Stack(children: [
          SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                widget.course.title!,
                                overflow: TextOverflow
                                    .ellipsis, // or TextOverflow.ellipsis
                                maxLines: 5,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            widget.course.user!.uid ==
                                    profileController.myProfile.uid
                                ? MyPopupMenuButton(
                                    popupItems: myPopupMore,
                                    icon: const Icon(
                                      Icons.more_horiz,
                                      size: 20,
                                      color: Colors.black,
                                      weight: 100,
                                    ),
                                    onSelected: (String val) {
                                      if (val == 'Edit') {
                                        Get.to(() => CreateCourseScreen(
                                              industryId:
                                                  widget.course.industryId,
                                              course: widget.course,
                                            ));
                                      } else if (val == 'Delete') {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                            title: const Text(
                                              'Delete Course',
                                              style: bodyText1,
                                            ),
                                            content: const Text(
                                                'Are you sure you want to delete this course?'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () => Get.back(),
                                                child: const Text('No'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  CourseController()
                                                      .onDeleteCourse(
                                                          widget.course.id!);
                                                  Get.back();
                                                },
                                                child: const Text('Yes'),
                                              ),
                                            ],
                                          ),
                                        );
                                      } else if (val == 'Boost') {
                                        Get.to(() => BoostPost(
                                              postId: widget.course.id!,
                                              postTitle: widget.course.title!,
                                            ));
                                      }
                                    },
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    ListTile(
                                                      onTap: () {
                                                        // Navigator.pop(context);
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                                  context) =>
                                                              AlertDialog(
                                                            title:
                                                                const TextWidget(
                                                              text:
                                                                  'Do you want to block user?',
                                                              centralize: true,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              size: 20,
                                                            ),
                                                            content: TextWidget(
                                                              text:
                                                                  'You will no longer see courses, posts and comments from this user on your feed',
                                                              centralize: true,
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      .6),
                                                            ),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        context),
                                                                child:
                                                                    const TextWidget(
                                                                  text:
                                                                      'Cancel',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  size: 18,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                  // print(_post.user.uid);
                                                                  setState(() {
                                                                    blocked.add(widget
                                                                        .course
                                                                        .user!
                                                                        .uid);
                                                                  });
                                                                  showSnackBar(
                                                                      context,
                                                                      message:
                                                                          'User has been blocked');
                                                                },
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .symmetric(
                                                                    vertical: 7,
                                                                    horizontal:
                                                                        14,
                                                                  ),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color:
                                                                        primaryColorLT,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                  ),
                                                                  child:
                                                                      const TextWidget(
                                                                    text:
                                                                        'Block',
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                      title: GestureDetector(
                                                        child: widget
                                                                    .course
                                                                    .user
                                                                    ?.isSubscribed ==
                                                                true
                                                            ? Row(
                                                                children: <Widget>[
                                                                  TextWidget(
                                                                    text:
                                                                        'Block @${widget.course.user?.name}',
                                                                    color: Colors
                                                                        .blue,
                                                                  ),
                                                                  const SizedBox(
                                                                      width: 5),
                                                                  SvgPicture
                                                                      .asset(
                                                                    'assets/svgs/premiumbadge.svg',
                                                                    height: 9,
                                                                    color:
                                                                        primaryColorLT,
                                                                  )
                                                                ],
                                                              )
                                                            : TextWidget(
                                                                text:
                                                                    'Block @${widget.course.user?.name}',
                                                                color:
                                                                    Colors.blue,
                                                              ),
                                                      ),
                                                    ),
                                                    ListTile(
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .pop(context);
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                                  context) =>
                                                              AlertDialog(
                                                            title:
                                                                const TextWidget(
                                                              text:
                                                                  'Do you want to report course?',
                                                              centralize: true,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              size: 20,
                                                            ),
                                                            content: TextWidget(
                                                              text:
                                                                  'The course will be reported to admin to evaluate if it violates any community policy',
                                                              centralize: true,
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      .6),
                                                            ),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        context),
                                                                child:
                                                                    const TextWidget(
                                                                  text:
                                                                      'Cancel',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  size: 18,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                  showSnackBar(
                                                                      context,
                                                                      message:
                                                                          'Course has been Reported');
                                                                },
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .symmetric(
                                                                    vertical: 7,
                                                                    horizontal:
                                                                        14,
                                                                  ),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color:
                                                                        primaryColorLT,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                  ),
                                                                  child:
                                                                      const TextWidget(
                                                                    text:
                                                                        'Report',
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                      title: const TextWidget(
                                                        text:
                                                            'Report this course',
                                                        color: Colors.red,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ));
                                    },
                                    child: const Icon(
                                      Icons.more_horiz,
                                      size: 20,
                                      color: Colors.black,
                                      weight: 100,
                                    ),
                                  )
                          ],
                        ),
                        Text(
                          widget.course.description!,
                          style: TextStyle(fontSize: 15, color: textColor),
                        ),
                        Row(
                          children: <Widget>[
                            Stack(children: [
                              Row(
                                children: [
                                  SizedBox(
                                    height: 30.0,
                                    width: 30.0,
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(1000),
                                        child: NetworkImageWithPlaceHolder(
                                          imageUrl:
                                              widget.course.user?.photoUrl ??
                                                  '',
                                          radius: radius,
                                          placeHolder: Icons.person,
                                          iconSize: 15.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    overflow: TextOverflow
                                        .ellipsis, // or TextOverflow.ellipsis
                                    maxLines: 1,
                                    widget.course.user?.name ??
                                        widget.course.user!.name!,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                              SpeedDial(
                                buttonSize: Size(100, 30),
                                backgroundColor: Colors.transparent,
                                iconTheme: const IconThemeData(
                                    color: Colors.transparent),
                                activeIcon: Icons.close,
                                spacing: 3,
                                childPadding: const EdgeInsets.all(5),
                                spaceBetweenChildren: 4,
                                switchLabelPosition: true,
                                visible: true,
                                direction: SpeedDialDirection.down,
                                closeManually: false,
                                renderOverlay: true,
                                overlayColor: Colors.black,
                                overlayOpacity: 0.8,
                                useRotationAnimation: true,
                                tooltip: 'Open Speed Dial',
                                elevation: 0.0,
                                animationCurve: Curves.elasticInOut,
                                isOpenOnStart: false,
                                children: [
                                  SpeedDialChild(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: SvgPicture.asset(
                                          'assets/svgs/person.svg',
                                          height: 20,
                                          color: textColor.withOpacity(1.0),
                                        ),
                                      ),
                                      backgroundColor: Colors.white,
                                      label: 'View Instructor\'s Profile',
                                      labelStyle: const TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w700),
                                      onTap: () {
                                        Get.toNamed(Routes.publicProfile,
                                            arguments: widget.course.user);
                                      }),
                                  SpeedDialChild(
                                    child: Padding(
                                      padding: const EdgeInsets.all(14.0),
                                      child: SvgPicture.asset(
                                        'assets/svgs/message.svg',
                                        height: 20.0,

                                        // ignore: deprecated_member_use
                                        color: textColor.withOpacity(1.0),
                                      ),
                                    ),
                                    backgroundColor: Colors.white,
                                    label: 'Message Instructor',
                                    labelStyle: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w700),
                                    onTap: () {
                                      Get.to(
                                        () => const ChatRoomScreen(
                                          frommarketplace: false,
                                        ),
                                        arguments: widget.course.user,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ]),
                            const SizedBox(
                              width: 5,
                            ),
                            const Icon(
                              Icons.star,
                              color: Color.fromRGBO(255, 202, 40, 1),
                              size: 16,
                            ),
                            Text(
                              widget.course.averageRating.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () async {},
                              icon: const Icon(Icons.remove_red_eye_outlined,
                                  size: 19, color: Colors.black),
                              label: Text(
                                '${widget.course.views.toString()} ${widget.course.views == 1 ? 'View' : 'Views'}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: textColor.withOpacity(0.8),
                                    ),
                              ),
                            ),
                          ],
                        ),
                        widget.course.youtubeUrls!.length > 1
                            ? Container(
                                height: 90,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount:
                                        widget.course.youtubeUrls!.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Row(
                                        children: [
                                          Stack(children: [
                                            Container(
                                              height: 90,
                                              width: 160,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                                child: FittedBox(
                                                  fit: BoxFit.fill,
                                                  child: Stack(
                                                    children: <Widget>[
                                                      YoutubeDisplay(
                                                        widget.course
                                                                .youtubeUrls![
                                                            index],
                                                      ),
                                                      Positioned(
                                                        top: 0,
                                                        bottom: 0,
                                                        right: 0,
                                                        left: 0,
                                                        child: selectedVideo ==
                                                                index
                                                            ? Container()
                                                            : Icon(
                                                                Icons
                                                                    .play_circle_outlined,
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.5),
                                                                size: 70,
                                                              ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectedVideo = index;
                                                });
                                              },
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Container(
                                                    height: 90,
                                                    width: 160,
                                                    decoration: BoxDecoration(
                                                      color: selectedVideo ==
                                                              index
                                                          ? Colors.black
                                                              .withAlpha(150)
                                                          : Colors.transparent,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                  ),
                                                  selectedVideo == index
                                                      ? const Center(
                                                          child: Text(
                                                            'Playing',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        )
                                                      : Container(),
                                                ],
                                              ),
                                            ),
                                          ]),
                                          const SizedBox(
                                            width: 10,
                                          )
                                        ],
                                      );
                                    }),
                              )
                            : Container(),
                        widget.course.youtubeUrls!.length > 1
                            ? const SizedBox(
                                height: 20,
                              )
                            : Container(),
                        widget.course.courseType == 'free'
                            ? Container()
                            : Center(
                                child: ElevatedButton(
                                    onPressed: () {
                                      if (num.parse(widget.course.price!) >
                                          num.parse(profileController
                                              .myProfile.coinscount
                                              .toString())) {
                                        showSnackbar(
                                          title: 'OOPS!',
                                          message:
                                              'Insufficient Coin balance, please top up!',
                                          error: true,
                                        );

                                        setState(() {
                                          insufficientBalance = true;
                                        });
                                      } else {
                                        // if (widget.post.user!.uid !=
                                        //     profileController.myProfile.uid) {
                                        //   homeController.postCoin(
                                        //       profileController.myProfile.uid,
                                        //       widget.post.postId,
                                        //       profileController,
                                        //       'post',
                                        //       widget.post.user!.uid);
                                        // }
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Wrap(
                                        runAlignment: WrapAlignment.center,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: [
                                          Text('Buy Course for '),
                                          SvgPicture.asset(
                                              'assets/svgs/coin.svg'),
                                          Text(' ${widget.course.price!}')
                                        ],
                                      ),
                                    ))),
                        const SizedBox(
                          height: 20,
                        ),
                        widget.course.transcript != null
                            ? Container(
                                color: backgroundcolorinterface,
                                height: 1,
                              )
                            : Container(),
                        const SizedBox(
                          height: 20,
                        ),
                        widget.course.transcript != null
                            ? Container(
                                decoration: BoxDecoration(
                                  color: backgroundcolorinterface,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                width: MediaQuery.sizeOf(context).width,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Video Transcript'),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20.0),
                                        child: Text(widget
                                            .course.transcript![selectedVideo]),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Container(),
                        const SizedBox(
                          height: 30,
                        ),
                        widget.course.documents != null
                            ? const Text(
                                'Downloadable Resources',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              )
                            : Container(),
                        widget.course.documents != null
                            ? SizedBox(
                                height: 150,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: widget.course.documents!.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      // Define getFileExtension function here
                                      String getFileExtension(String link) {
                                        int dotIndex = link.lastIndexOf('.');
                                        int slashIndex = link.lastIndexOf('/');

                                        // Check if there is no dot in the filename or if the dot is before the last slash
                                        if (dotIndex == -1 ||
                                            dotIndex < slashIndex) {
                                          return '';
                                        }

                                        return link.substring(dotIndex + 1);
                                      }

                                      // Use getFileExtension to get the file extension
                                      String fileExtension = getFileExtension(
                                          'https://miro.medium.com/v2/resize:fit:1200/1*5JFH1YSl7NHZ4kPghfXfEg.jpeg');

                                      // Return DownloadableItem widget
                                      return DownloadableItem(
                                        link:
                                            'https://miro.medium.com/v2/resize:fit:1200/1*5JFH1YSl7NHZ4kPghfXfEg.jpeg',
                                        filename:
                                            '${widget.course.title} resource ${index + 1}.$fileExtension', // Ensure to add the extension to the filename
                                      );
                                    }),
                              )
                            : Container(),
                        const SizedBox(
                          height: 100,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.sizeOf(context).width,
              height: 90,
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    height: 1,
                    width: MediaQuery.of(context).size.width,
                    color: backgroundcolorinterface,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) =>
                                  CourseCommentBottomSheet(
                                course: widget.course,
                                onComment:
                                    (CourseCommentModel newComment) async {},
                              ),
                            );
                          },
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              SvgPicture.asset('assets/svgs/comment.svg'),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text('Comment'),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await rateCourse();
                          },
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/svgs/star.svg',
                                height: 18,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text('Rate'),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _sharePost(),
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/svgs/share.svg',
                                height: 18,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text('Share'),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }

  void _sharePost() {
    String message =
        'Have a look at ${widget.course.user?.username ?? 'Business Bosses'}\'s course on Business Bosses\n'
        'https://businessbosses.onelink.me/xLWk/36a2ff16';
    logEvent(widget.course.id, 'course');
    socialShare(message);
  }

  Future<void> rateCourse() async {
    int rater = 0;
    ProfileController profileController = Get.find();
    CourseModel? cCourse;
    double currentRating = 0;
    String reviewText = '';
    CourseController _courseController = Get.find();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return FractionallySizedBox(
                heightFactor: 0.5,
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  onVerticalDragDown: (_) {
                    FocusScope.of(context).unfocus();
                  },
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              const Text(
                                'Rate Course',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  setState(
                                    () {
                                      rater = 0;
                                    },
                                  );
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(
                              12,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(
                                  Icons.star,
                                  color: rater >= 1
                                      ? const Color.fromRGBO(255, 202, 40, 1)
                                      : const Color.fromRGBO(229, 229, 229, 1),
                                  size: 40,
                                ),
                                onPressed: () {
                                  setState(() {
                                    rater = 1;
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.star,
                                  color: rater >= 2
                                      ? const Color.fromRGBO(255, 202, 40, 1)
                                      : const Color.fromRGBO(229, 229, 229, 1),
                                  size: 40,
                                ),
                                onPressed: () {
                                  setState(() {
                                    rater = 2;
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.star,
                                  color: rater >= 3
                                      ? const Color.fromRGBO(255, 202, 40, 1)
                                      : const Color.fromRGBO(229, 229, 229, 1),
                                  size: 40,
                                ),
                                onPressed: () {
                                  setState(() {
                                    rater = 3;
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.star,
                                  color: rater >= 4
                                      ? const Color.fromRGBO(255, 202, 40, 1)
                                      : const Color.fromRGBO(229, 229, 229, 1),
                                  size: 40,
                                ),
                                onPressed: () {
                                  setState(() {
                                    rater = 4;
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.star,
                                  color: rater >= 5
                                      ? const Color.fromRGBO(255, 202, 40, 1)
                                      : const Color.fromRGBO(229, 229, 229, 1),
                                  size: 40,
                                ),
                                onPressed: () {
                                  setState(() {
                                    rater = 5;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: MCustomButton(
                            isProcessing: isSending,
                            buttonType: ButtonType.elevated,
                            onPressed: () async {
                              setState(() {
                                isSending = true;
                              });
                              await ApiService.post(
                                path: 'course-ratings',
                                body: <String, dynamic>{
                                  'raterId': profileController.myProfile.uid,
                                  'courseId': widget.course.id,
                                  'authorId': widget.course.user!.uid,
                                  'rating': rater,
                                  'review': ""
                                },
                              );
                              await ApiService.post(
                                path: 'notification',
                                body: <String, dynamic>{
                                  'senderUid': profileController.myProfile.uid,
                                  'receiverUid': widget.course.user!.uid,
                                  'title': 'Seller Review',
                                  'message':
                                      '${profileController.myProfile.username} has rated your course',
                                  'timestamp':
                                      DateTime.now().millisecondsSinceEpoch,
                                  'notificationType': 'Review',
                                  'username': widget.course.user!.username,
                                  'user': widget.course.user,
                                },
                              );
                              await processData();
                            },
                            child: const Text('Rate'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> processData() async {
    final ApiResponseModel response = await ApiService.get(
        path: '/course-ratings/user/${widget.course.user!.uid}');
    final List<dynamic> psts = response.data['rows'];
    if (mounted) {
      setState(() {
        reviews = psts
            .map((dynamic reviewData) => ReviewModel.fromMap(reviewData))
            .toList();
      });
    }
    if (reviews!.isEmpty) {
      if (mounted) {
        setState(() {
          reviews = null;
        });
      }
    } else {
      int fiveCount =
          reviews!.where((ReviewModel review) => review.rating == 5).length;
      int fourCount =
          reviews!.where((ReviewModel review) => review.rating == 4).length;
      int threeCount =
          reviews!.where((ReviewModel review) => review.rating == 3).length;
      int twoCount =
          reviews!.where((ReviewModel review) => review.rating == 2).length;
      int oneCount =
          reviews!.where((ReviewModel review) => review.rating == 1).length;
      if (mounted) {
        setState(() {
          fiveStar = fiveCount;
          fourStar = fourCount;
          threeStar = threeCount;
          twoStar = twoCount;
          oneStar = oneCount;
        });
      }
    }
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }
}
