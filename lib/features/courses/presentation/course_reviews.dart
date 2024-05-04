import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/common/widgets/buttons/my_outlined_button.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/features/courses/controller/course_controller.dart';
import 'package:business_bosses_v2/features/courses/models/course_model.dart';
import 'package:business_bosses_v2/features/courses/widgets/course_review_tile.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:business_bosses_v2/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../../../common/widgets/safety_model.dart';
import '../../../utils/theme/theme.dart';

class CourseReviewScreen extends StatefulWidget {
  final CourseModel course;
  const CourseReviewScreen({Key? key, required this.course}) : super(key: key);

  @override
  State<CourseReviewScreen> createState() => _CourseReviewScreenState();
}

class _CourseReviewScreenState extends State<CourseReviewScreen> {
  UserModel? cUser;
  int rater = 0;
  final CourseController courseController = Get.find();
  ProfileController profileController = Get.find();
  String reviewText = '';
  List<dynamic>? reviews;
  bool isSending = false;
  int oneStar = 0;
  int twoStar = 0;
  int threeStar = 0;
  int fourStar = 0;
  int fiveStar = 0;
  double currentRating = 0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    courseController.getReviews(widget.course.id).then((_) {
      processData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Course Reviews'),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
          ),
        ),
        body: Obx(
          () => courseController.rLoading.value || loading
              ? const SafetyModel(
                  isLoading: true,
                )
              : SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 20,
                        color: backgroundcolorinterface,
                      ),
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 0.0,
                        ),
                        margin: const EdgeInsets.only(
                          top: 16.0,
                        ),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: backgroundColor,
                                    borderRadius: BorderRadius.circular(15)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      widget.course.title!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black,
                                            fontSize: 18,
                                          ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      widget.course.description!,
                                      style: bodyText2,
                                      textAlign: TextAlign.left,
                                    ),
                                    const SizedBox(
                                      height: 18,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        NetworkImageWithPlaceHolder(
                                          imageUrl:
                                              widget.course.user!.photoUrl!,
                                          radius: 200,
                                          width: 25,
                                          height: 25,
                                          placeHolder: Icons.person,
                                          iconSize: 20.0,
                                          fit: BoxFit.cover,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          child: Text(
                                            widget.course.user!.name!,
                                            style: const TextStyle(
                                                color: Colors.black),
                                            overflow: TextOverflow.visible,
                                            softWrap: true,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    SizedBox(
                                      height: SizeConfig.safeBlockVertical * 3,
                                    ),
                                    SizedBox(
                                      height:
                                          SizeConfig.safeBlockHorizontal * 3,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            StatefulBuilder(
                              builder:
                                  (BuildContext context, StateSetter setState) {
                                return Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color:
                                        const Color.fromRGBO(244, 244, 244, 1),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          const Text(
                                            'Rating',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                  widget.course.averageRating
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                  )),
                                              const SizedBox(
                                                width: 3,
                                              ),
                                              const Text('out of 5',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                            ],
                                          ),
                                          Text(
                                              'Based on ${courseController.reviews.length} reviews'),
                                          Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.star,
                                                color: widget.course
                                                            .averageRating! >=
                                                        1
                                                    ? const Color.fromRGBO(
                                                        255, 202, 40, 1)
                                                    : const Color.fromRGBO(
                                                        229, 229, 229, 1),
                                                size: 30,
                                              ),
                                              Icon(
                                                Icons.star,
                                                color: widget.course
                                                            .averageRating! >=
                                                        2
                                                    ? const Color.fromRGBO(
                                                        255, 202, 40, 1)
                                                    : const Color.fromRGBO(
                                                        229, 229, 229, 1),
                                                size: 30,
                                              ),
                                              Icon(
                                                Icons.star,
                                                color: widget.course
                                                            .averageRating! >=
                                                        3
                                                    ? const Color.fromRGBO(
                                                        255, 202, 40, 1)
                                                    : const Color.fromRGBO(
                                                        229, 229, 229, 1),
                                                size: 30,
                                              ),
                                              Icon(
                                                Icons.star,
                                                color: widget.course
                                                            .averageRating! >=
                                                        4
                                                    ? const Color.fromRGBO(
                                                        255, 202, 40, 1)
                                                    : const Color.fromRGBO(
                                                        229, 229, 229, 1),
                                                size: 30,
                                              ),
                                              Icon(
                                                Icons.star,
                                                color: widget.course
                                                            .averageRating! ==
                                                        5
                                                    ? const Color.fromRGBO(
                                                        255, 202, 40, 1)
                                                    : const Color.fromRGBO(
                                                        229, 229, 229, 1),
                                                size: 30,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              const Text(
                                                '5 Stars',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              SizedBox(
                                                width: 80,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child:
                                                      LinearProgressIndicator(
                                                    value: courseController
                                                            .reviews.isEmpty
                                                        ? 0
                                                        : (fiveStar /
                                                                courseController
                                                                    .reviews
                                                                    .length)
                                                            .toDouble(),
                                                    minHeight: 10,
                                                    backgroundColor:
                                                        Colors.grey,
                                                    valueColor:
                                                        const AlwaysStoppedAnimation<
                                                                Color>(
                                                            Color.fromRGBO(255,
                                                                202, 40, 1)),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              const Text(
                                                '4 Stars',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              SizedBox(
                                                width: 80,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child:
                                                      LinearProgressIndicator(
                                                    value: courseController
                                                            .reviews.isEmpty
                                                        ? 0
                                                        : (fourStar /
                                                                courseController
                                                                    .reviews
                                                                    .length)
                                                            .toDouble(),
                                                    minHeight: 10,
                                                    backgroundColor:
                                                        Colors.grey,
                                                    valueColor:
                                                        const AlwaysStoppedAnimation<
                                                                Color>(
                                                            Color.fromRGBO(255,
                                                                202, 40, 1)),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              const Text(
                                                '3 Stars',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              SizedBox(
                                                width: 80,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child:
                                                      LinearProgressIndicator(
                                                    value: courseController
                                                            .reviews.isEmpty
                                                        ? 0
                                                        : (threeStar /
                                                                courseController
                                                                    .reviews
                                                                    .length)
                                                            .toDouble(),
                                                    minHeight: 10,
                                                    backgroundColor:
                                                        Colors.grey,
                                                    valueColor:
                                                        const AlwaysStoppedAnimation<
                                                                Color>(
                                                            Color.fromRGBO(255,
                                                                202, 40, 1)),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              const Text(
                                                '2 Stars',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              SizedBox(
                                                width: 80,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child:
                                                      LinearProgressIndicator(
                                                    value: courseController
                                                            .reviews.isEmpty
                                                        ? 0
                                                        : (twoStar /
                                                                courseController
                                                                    .reviews
                                                                    .length)
                                                            .toDouble(),
                                                    minHeight: 10,
                                                    backgroundColor:
                                                        Colors.grey,
                                                    valueColor:
                                                        const AlwaysStoppedAnimation<
                                                                Color>(
                                                            Color.fromRGBO(255,
                                                                202, 40, 1)),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              const Text(
                                                '1 Star',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              SizedBox(
                                                width: 80,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child:
                                                      LinearProgressIndicator(
                                                    value: courseController
                                                            .reviews.isEmpty
                                                        ? 0
                                                        : (oneStar /
                                                                courseController
                                                                    .reviews
                                                                    .length)
                                                            .toDouble(),
                                                    minHeight: 10,
                                                    backgroundColor:
                                                        Colors.grey,
                                                    valueColor:
                                                        const AlwaysStoppedAnimation<
                                                                Color>(
                                                            Color.fromRGBO(255,
                                                                202, 40, 1)),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            if (widget.course.user?.uid !=
                                profileController.myProfile.uid)
                              MCustomButton(
                                height: 50,
                                buttonType: ButtonType.elevated,
                                onPressed: () async {
                                  await rateCourse();
                                },
                                width: 200,
                                child: const Text(
                                  'Rate Course',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            courseController.reviews.isEmpty
                                ? const Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 60,
                                      ),
                                      Center(
                                        child: SafetyModel(
                                          isLoading: false,
                                          icon: Icon(
                                            Icons.warning,
                                            size: 100,
                                          ),
                                          title: 'No Review For This Course',
                                          subTitle: 'Be the first to review',
                                        ),
                                      ),
                                    ],
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 100, top: 20),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount:
                                          courseController.reviews.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final dynamic review =
                                            courseController.reviews[index];

                                        return CourseReviewTile(
                                          post: review,
                                          process: processData,
                                          edit: editRating,
                                        );
                                      },
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ));
  }

  Future<void> processData() async {
    int fiveCount = courseController.reviews
        .where((dynamic review) => review['rating'] == 5)
        .length;
    int fourCount = courseController.reviews
        .where((dynamic review) => review['rating'] == 4)
        .length;
    int threeCount = courseController.reviews
        .where((dynamic review) => review['rating'] == 3)
        .length;
    int twoCount = courseController.reviews
        .where((dynamic review) => review['rating'] == 2)
        .length;
    int oneCount = courseController.reviews
        .where((dynamic review) => review['rating'] == 1)
        .length;
    setState(() {
      fiveStar = fiveCount;
      fourStar = fourCount;
      threeStar = threeCount;
      twoStar = twoCount;
      oneStar = oneCount;
    });

    setState(() {
      loading = false;
    });
  }

  Future<void> rateCourse() async {
    String reviewText = '';

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
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          maxLines: 4,
                          onChanged: (String value) {
                            reviewText = value;
                          },
                          decoration: const InputDecoration(
                            hintText: 'Write your Review here...',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(10),
                          ),
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
                            final ApiResponseModel response =
                                await ApiService.post(
                              path: 'course-ratings',
                              body: <String, dynamic>{
                                'raterId': profileController.myProfile.uid,
                                'courseId': widget.course.id,
                                'authorId': widget.course.user!.uid,
                                'rating': rater,
                                'review': reviewText,
                              },
                            );
                            if (response.success) {
                            setState(() {
                              courseController.reviews.add(<String, dynamic>{
                                ...response.data,
                                'rater': <String, dynamic>{
                                  'username':
                                      profileController.myProfile.username,
                                  'email': profileController.myProfile.email,
                                  'uid': profileController.myProfile.uid,
                                  'bio': profileController.myProfile.bio,
                                  'companyName':
                                      profileController.myProfile.companyName,
                                  'surname': null,
                                  'name': profileController.myProfile.name ??
                                      profileController.myProfile.username,
                                  'coinscount':
                                      profileController.myProfile.coinsCount,
                                  'photoUrl':
                                      profileController.myProfile.photoUrl,
                                  'isRanked':
                                      profileController.myProfile.isRanked,
                                  'isSubscribed':
                                      profileController.myProfile.isSubscribed,
                                },
                              });
                            });
                            }
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
                                'username': widget.course.user?.username,
                                'user': widget.course.user?.toMap(),
                              },
                            );
                            setState(() {
                              isSending = false;
                            });
                            Get.back();
                          },
                          child: const Text('Rate'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> editRating(int Id, int rate, String revText) async {
    setState(
      () {
        rater = rate;
        reviewText = revText;
        isSending = false;
      },
    );
    TextEditingController textEditingController =
        TextEditingController(text: revText);
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
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text(
                              'Rate Seller',
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
                                    reviewText = '';
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
                          borderRadius: BorderRadius.circular(12),
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
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: textEditingController,
                          maxLines: 4,
                          onChanged: (String value) {
                            reviewText = value;
                          },
                          decoration: const InputDecoration(
                            hintText: 'Write your Review here...',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(10),
                          ),
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
                            await ApiService.put(
                              path: 'course-ratings/$Id',
                              body: <String, dynamic>{
                                'rating': rater,
                                'review': reviewText,
                              },
                            );
                            if (mounted) {
                              setState(
                                () {
                                  rater = 0;
                                  reviewText = '';
                                  isSending = false;
                                },
                              );
                            }
                            Get.back();
                          },
                          child: const Text('Edit Rating'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
