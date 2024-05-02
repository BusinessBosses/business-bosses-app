import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/common/widgets/buttons/my_outlined_button.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/features/courses/models/course_model.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/review_item.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../../../common/models/api_response_model.dart';
import '../../../common/widgets/safety_model.dart';
import '../../../services/api_service.dart';
import '../../../utils/theme/theme.dart';
import '../../profile/widgets/public_profile_tile.dart';
import '../models/reviews_model.dart';

class CourseReviewScreen extends StatefulWidget {
  final CourseModel course;
  const CourseReviewScreen({Key? key, required this.course}) : super(key: key);

  @override
  State<CourseReviewScreen> createState() => _CourseReviewScreenState();
}

class _CourseReviewScreenState extends State<CourseReviewScreen> {
  UserModel? cUser;
  int rater = 0;
  String reviewText = '';
  List<ReviewModel>? reviews;
  bool isSending = false;
  int oneStar = 0;
  int twoStar = 0;
  int threeStar = 0;
  int fourStar = 0;
  int fiveStar = 0;
  double currentRating = 0;
  bool loading = true;
  final ProfileController _profileController = Get.find();

  @override
  void initState() {
    super.initState();
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
      body: SingleChildScrollView(
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
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(15)
                      ),
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              NetworkImageWithPlaceHolder(
                                imageUrl: widget.course.user!.photoUrl!,
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
                                  style: const TextStyle(color: Colors.black),
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
                            height: SizeConfig.safeBlockHorizontal * 3,
                          ),
                        ],
                      ),
                    ),
                  ),
                 

                 
                  const SizedBox(
                    height: 20,
                  ),
                  StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromRGBO(244, 244, 244, 1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text('0.0',
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
                                Text('Based on ${0} reviews'),
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.star,
                                      color: const Color.fromRGBO(
                                          229, 229, 229, 1),
                                      size: 30,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: const Color.fromRGBO(
                                          229, 229, 229, 1),
                                      size: 30,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: const Color.fromRGBO(
                                          229, 229, 229, 1),
                                      size: 30,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: const Color.fromRGBO(
                                          229, 229, 229, 1),
                                      size: 30,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: const Color.fromRGBO(
                                          229, 229, 229, 1),
                                      size: 30,
                                    )
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.end,
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
                                        borderRadius: BorderRadius.circular(10),
                                        child: LinearProgressIndicator(
                                          value: 0,
                                          minHeight: 10,
                                          backgroundColor: Colors.grey,
                                          valueColor:
                                              const AlwaysStoppedAnimation<
                                                      Color>(
                                                  Color.fromRGBO(
                                                      255, 202, 40, 1)),
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
                                        borderRadius: BorderRadius.circular(10),
                                        child: LinearProgressIndicator(
                                          value: 0,
                                          minHeight: 10,
                                          backgroundColor: Colors.grey,
                                          valueColor:
                                              const AlwaysStoppedAnimation<
                                                      Color>(
                                                  Color.fromRGBO(
                                                      255, 202, 40, 1)),
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
                                        borderRadius: BorderRadius.circular(10),
                                        child: LinearProgressIndicator(
                                          value: 0,
                                          minHeight: 10,
                                          backgroundColor: Colors.grey,
                                          valueColor:
                                              const AlwaysStoppedAnimation<
                                                      Color>(
                                                  Color.fromRGBO(
                                                      255, 202, 40, 1)),
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
                                        borderRadius: BorderRadius.circular(10),
                                        child: LinearProgressIndicator(
                                          value: 0,
                                          minHeight: 10,
                                          backgroundColor: Colors.grey,
                                          valueColor:
                                              const AlwaysStoppedAnimation<
                                                      Color>(
                                                  Color.fromRGBO(
                                                      255, 202, 40, 1)),
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
                                        borderRadius: BorderRadius.circular(10),
                                        child: LinearProgressIndicator(
                                          value: 0,
                                          minHeight: 10,
                                          backgroundColor: Colors.grey,
                                          valueColor:
                                              const AlwaysStoppedAnimation<
                                                      Color>(
                                                  Color.fromRGBO(
                                                      255, 202, 40, 1)),
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
                  const SizedBox(height: 20,),
                   MCustomButton(
                    height: 50,
                    buttonType: ButtonType.elevated,
                    onPressed: () async {},
                    width: 200,
                    child: const Text(
                      'Rate Course',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Column(
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

                  //  Padding(
                  //     padding:
                  //         const EdgeInsets.only(bottom: 100, top: 20),
                  //     child: ListView.builder(
                  //       shrinkWrap: true,
                  //       physics: const NeverScrollableScrollPhysics(),
                  //       itemCount: reviews?.length,
                  //       itemBuilder: (BuildContext context, int index) {
                  //         final ReviewModel review = reviews![index];

                  //         return ReviewTile(
                  //           post: 'review',
                  //           process: processData,
                  //           edit: editRating,
                  //         );
                  //       },
                  //     ),
                  //   ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
