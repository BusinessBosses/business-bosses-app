import 'package:business_bosses_v2/common/widgets/tiles/custom_tile.dart';
import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:business_bosses_v2/features/forum/presentation/all_forum_screen.dart';
import 'package:business_bosses_v2/features/home/controller/commumities_controller.dart';
import 'package:business_bosses_v2/features/home/widgets/all_learning_posts.dart';
import 'package:business_bosses_v2/utils/constants/constants.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class LearningSection extends StatelessWidget {
  const LearningSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommunitiesController>(
        builder: (CommunitiesController controller) {
      return GestureDetector(
        onTap: () {
          Get.to(() => const AllLearningPostsScreen(isCoursesTile: false));
        },
        child: Container(
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              // const Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 15.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: <Widget>[
              //       Text(
              //         'Learning',
              //         style:
              //             TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              //       ),
              //     ],
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      'Courses & Tutorials',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                    Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: <Widget>[
                          const Text(
                            'View all',
                            style: TextStyle(fontSize: 11),
                          ),
                          const SizedBox(width: 5.0),
                          SvgPicture.asset(
                            'assets/svgs/nexticon.svg',
                            // ignore: deprecated_member_use
                            color: textColor,
                            height: 8,
                          ),
                        ]),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                color: Colors.white,
                width: double.infinity,
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    Industry industry = controller
                        .getCategoryIndustries(Constants.LEARNINGID)
                        .where((Industry industry) => !industry.active!)
                        .toList()[index];
                    return SizedBox(
                      width: 200,
                      height: 200,
                      child: CustomTile(
                        hideIcon: true,
                        label: industry.industry!,
                        photo: industry.photo!,
                        ishome: true,
                        onTap: () {
                          print('object');
                          Get.to(const AllForumScreen(isCourses: true),
                              arguments: controller
                                  .getCategoryIndustries(Constants.LEARNINGID)
                                  .where(
                                      (Industry industry) => !industry.active!)
                                  .toList()[index]);
                        },
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
