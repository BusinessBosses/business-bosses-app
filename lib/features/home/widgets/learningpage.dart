import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/common/widgets/tiles/custom_tile.dart';
import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:business_bosses_v2/features/home/controller/commumities_controller.dart';
import 'package:business_bosses_v2/features/home/widgets/all_learning_posts.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/constants/constants.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class LearningPage extends StatefulWidget {
  const LearningPage({super.key});

  @override
  State<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {
  final CommunitiesController _communitiesController =
      Get.put(CommunitiesController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommunitiesController>(
      builder: (CommunitiesController controller) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
            ),
            centerTitle: true,
            title: const Text(
              'Learning',
              textAlign: TextAlign.center,
            ),
          ),
          backgroundColor: backgroundColor,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: controller.loading.value
                ? SafetyModel(isLoading: controller.loading.value, title: '')
                : controller.error.value
                    ? SafetyModel(
                        isLoading: false,
                        title: 'Something went wrong',
                        clickableText: 'Reload',
                        onTap: controller.fetchIndustries,
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
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 15,
                                crossAxisSpacing: 15,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                // First special tile
                                if (index == 0) {
                                  return CustomTile(
                                    label: 'Launch a Venture 10x Faster',
                                    onTap: () async {
                                      final Uri url = Uri.parse(
                                          'https://business-school.io');
                                      if (!await launchUrl(url)) {
                                        throw Exception(
                                            'Could not launch $url');
                                      }
                                    },
                                    photo: 'assets/images/bbschool.png',
                                    isbossup: true,
                                  );
                                }

                                // Industry tiles
                                final Industry industry =
                                    activeIndustries[index - 1];
                                return CustomTile(
                                  label: industry.industry!,
                                  photo: industry.photo!,
                                  onTap: () {
                                    // Courses & Tutorials tiles
                                    if (industry.industryId ==
                                        '4acc0db7-7c89-4122-b15d-7552f590af23') {
                                      Get.to(() => const AllLearningPostsScreen(
                                          isCoursesTile: true));
                                    } else if (industry.industryId ==
                                        '6bfb3524-f05e-4148-b4b2-a7a47b768b56') {
                                      Get.to(() => const AllLearningPostsScreen(
                                          isCoursesTile: false));
                                    } else {
                                      // Pass only the ID to avoid type error
                                      Get.toNamed(
                                        Routes.allforumscreen,
                                        arguments: industry.industryId,
                                      );
                                    }
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
          ),
        );
      },
    );
  }
}
