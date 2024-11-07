import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/common/widgets/tiles/custom_tile.dart';
import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:business_bosses_v2/features/home/controller/commumities_controller.dart';
import 'package:business_bosses_v2/features/home/widgets/all_learning_posts.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/constants/constants.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class LearningPage extends StatefulWidget {
  const LearningPage({super.key});

  @override
  State<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {
  // ignore: unused_field
  final CommunitiesController _communitiesController =
      Get.put(CommunitiesController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommunitiesController>(
        builder: (CommunitiesController controller) {
      return Scaffold(
        backgroundColor: backgroundColor,
        // appBar: AppBar(
        //   leading: IconButton(
        //     onPressed: () {
        //       Navigator.pop(context);
        //     },
        //     icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        //   ),
        //   centerTitle: true,
        //   title: const Text(
        //     'Learning',
        //     textAlign: TextAlign.center,
        //   ),
        // ),
        body: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: controller.loading.value
              ? SafetyModel(isLoading: controller.loading.value, title: '')
              : controller.error.value
                  ? SafetyModel(
                      isLoading: false,
                      title: 'Something went wrong',
                      clickableText: 'Reload',
                      onTap: () async {
                        await controller.fetchIndustries();
                      },
                    )
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 80),
                      child: Builder(
                        builder: (BuildContext context) {
                          List<Industry> activeIndustries = controller
                              .getCategoryIndustries(Constants.LEARNINGID)
                              .where((Industry industry) => industry.active!)
                              .toList();

                          return GridView.builder(
                            itemCount: activeIndustries.length + 1,
                            itemBuilder: (BuildContext context, int index) {
                              if (index == 0) {
                                return CustomTile(
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
                                );
                              }
                              Industry industry = activeIndustries[index - 1];
                              return CustomTile(
                                label: industry.industry!,
                                photo: industry.photo!,
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
                              );
                            },
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisSpacing: 15.0,
                              crossAxisSpacing: 15.0,
                              crossAxisCount: 2,
                            ),
                          );
                        },
                      ),
                    ),
        ),
      );
    });
  }
}
