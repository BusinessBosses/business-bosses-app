import 'package:business_bosses_v2/action/action.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/common/widgets/popup/my_popup_menu_button.dart';
import 'package:business_bosses_v2/common/widgets/typography/text_widget.dart';
import 'package:business_bosses_v2/features/chat/chat_room_screen.dart';
import 'package:business_bosses_v2/features/courses/controller/course_controller.dart';
import 'package:business_bosses_v2/features/courses/models/course_comment_model.dart';
import 'package:business_bosses_v2/features/courses/models/course_model.dart';
import 'package:business_bosses_v2/features/courses/models/reviews_model.dart';
import 'package:business_bosses_v2/features/courses/presentation/course_reviews.dart';
import 'package:business_bosses_v2/features/courses/presentation/create_course.dart';
import 'package:business_bosses_v2/features/courses/widgets/course_comment_bottomsheet.dart';
import 'package:business_bosses_v2/features/courses/widgets/downloadable_item.dart';
import 'package:business_bosses_v2/features/courses/widgets/unpaidcoursepopup.dart';
import 'package:business_bosses_v2/features/posts/presentation/boost_post_screen.dart';
import 'package:business_bosses_v2/features/posts/widgets/youtube_display.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

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
      backgroundColor: Colors.white,
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
                style: const TextStyle(fontSize: 20),
              ),
              expandedHeight: 300.0,
              collapsedHeight: 300.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.only(top: 120.0),
                  child: Stack(
                    children: <Widget>[
                      !widget.course.youtubeUrls![selectedVideo]
                              .contains('youtube')
                          ? GestureDetector(
                              onTap: () async {
                                if (await canLaunchUrl(Uri.parse(widget
                                    .course.youtubeUrls![selectedVideo]))) {
                                  await launchUrl(Uri.parse(widget
                                      .course.youtubeUrls![selectedVideo]));
                                }
                              },
                              child: NetworkImageWithPlaceHolder(
                                imageUrl: widget.course.thumbnail ?? '',
                                height: 300.0,
                                width: 300.0,
                                // cacheHeight: 120,
                                // cacheWidth: 120,
                              ),
                            )
                          : YoutubeDisplay(
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
        body: Stack(children: <Widget>[
          SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
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
                                                          widget.course.id);
                                                  Get.back();
                                                },
                                                child: const Text('Yes'),
                                              ),
                                            ],
                                          ),
                                        );
                                      } else if (val == 'Boost') {
                                        Get.to(() => BoostPost(
                                              postId: widget.course.id,
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
                          style:
                              const TextStyle(fontSize: 15, color: textColor),
                        ),
                        Row(
                          children: <Widget>[
                            Stack(children: <Widget>[
                              Row(
                                children: <Widget>[
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
                                  widget.course.user?.isSubscribed == true
                                      ? Wrap(children: <Widget>[
                                          const SizedBox(width: 3),
                                          SvgPicture.asset(
                                            'assets/svgs/premiumbadge.svg',
                                            height: 7,
                                            color: primaryColorLT,
                                          )
                                        ])
                                      : Container()
                                ],
                              ),
                              SpeedDial(
                                buttonSize: const Size(100, 30),
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
                                children: <SpeedDialChild>[
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
                            GestureDetector(
                              onTap: () {
                                Get.to(
                                    CourseReviewScreen(course: widget.course));
                              },
                              child: Wrap(
                                children: <Widget>[
                                  const Icon(
                                    Icons.star,
                                    color: Color.fromRGBO(255, 202, 40, 1),
                                    size: 16,
                                  ),
                                  Text(
                                    widget.course.averageRating!
                                        .toStringAsFixed(2),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
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
                            ? SizedBox(
                                height: 90,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount:
                                        widget.course.youtubeUrls!.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Row(
                                        children: <Widget>[
                                          Stack(children: <Widget>[
                                            SizedBox(
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
                                                children: <Widget>[
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
                                        children: <Widget>[
                                          const Text('Buy Course for '),
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
                                    children: <Widget>[
                                      const Text('Video Transcript'),
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
                                          'https://businessbosses.com.ng/documents/${widget.course.documents?[index]}');

                                      // Return DownloadableItem widget
                                      return DownloadableItem(
                                        link:
                                            'https://businessbosses.com.ng/documents/${widget.course.documents?[index]}',
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
                children: <Widget>[
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
                      children: <Widget>[
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
                            children: <Widget>[
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
                            Get.to(() =>
                                CourseReviewScreen(course: widget.course));
                          },
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: <Widget>[
                              SvgPicture.asset(
                                'assets/svgs/star.svg',
                                height: 18,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text('Reviews'),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _sharePost(),
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: <Widget>[
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
}
