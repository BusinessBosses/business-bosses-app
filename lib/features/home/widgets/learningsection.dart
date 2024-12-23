import 'package:business_bosses_v2/common/widgets/tiles/custom_tile.dart';
import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:business_bosses_v2/features/home/all_communities_screen.dart';
import 'package:business_bosses_v2/features/home/controller/commumities_controller.dart';
import 'package:business_bosses_v2/features/home/widgets/all_learning_posts.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/constants/constants.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class LearningSection extends StatelessWidget {
  const LearningSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommunitiesController>(
        builder: (CommunitiesController controller) {
      return GestureDetector(
        onTap: () {
          Get.to(() => const AllCommunitiesScreen(
                initialBossupTabIndex: 2,
              ));
        },
        child: Container(
          color: backgroundColor,
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
                      'Learning',
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
                  color: backgroundColor,
                  width: double.infinity,
                  height: 150,
                  child: Builder(builder: (BuildContext context) {
                    List<Industry> activeIndustries = controller
                        .getCategoryIndustries(Constants.LEARNINGID)
                        .where((Industry industry) => industry.active!)
                        .toList();
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: activeIndustries.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) {
                          return SizedBox(
                            width: 200,
                            height: 200,
                            child: CustomTile(
                              ishome: true,
                              hideIcon: true,
                              label: 'Launch a Venture 10x Faster',
                              onTap: () async {
                                final Uri url =
                                    Uri.parse('https://business-school.io');
                                if (!await launchUrl(url)) {
                                  throw Exception('Could not launch $url');
                                }
                              },
                              photo: 'assets/images/bbschool.png',
                              isbossup: true,
                            ),
                          );
                        }
                        Industry industry = activeIndustries[index - 1];
                        return SizedBox(
                          width: 200,
                          height: 200,
                          child: CustomTile(
                            hideIcon: true,
                            label: industry.industry!,
                            photo: industry.photo!,
                            ishome: true,
                            onTap: () {
                              if (industry.industryId ==
                                  '4acc0db7-7c89-4122-b15d-7552f590af23') {
                                Get.to(() => const AllLearningPostsScreen(
                                    isCoursesTile: true));
                              } else if (industry.industryId ==
                                  '6bfb3524-f05e-4148-b4b2-a7a47b768b56') {
                                Get.to(() => const AllLearningPostsScreen(
                                    isCoursesTile: false));
                              } else {
                                Get.toNamed(
                                  Routes.allforumscreen,
                                  arguments: industry,
                                );
                              }
                            },
                          ),
                        );
                      },
                    );
                  }))
            ],
          ),
        ),
      );
    });
  }
}
