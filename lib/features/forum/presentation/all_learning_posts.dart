import 'package:business_bosses_v2/common/widgets/tiles/custom_tile_learning.dart';
import 'package:business_bosses_v2/features/courses/widgets/coursespopup.dart';
import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:business_bosses_v2/features/forum/presentation/all_forum_screen.dart';
import 'package:business_bosses_v2/features/home/controller/commumities_controller.dart';
import 'package:business_bosses_v2/utils/constants/constants.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class AllLearningPostsScreen extends StatefulWidget {
  static const String routeName = '/AllLearningPostsscreen';

  final bool? isCoursesTile;

  const AllLearningPostsScreen({super.key, this.isCoursesTile = false});

  @override
  // ignore: library_private_types_in_public_api
  _AllLearningPostsScreenState createState() => _AllLearningPostsScreenState();
}

class _AllLearningPostsScreenState extends State<AllLearningPostsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommunitiesController>(
        builder: (CommunitiesController controller) {
      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
          ),
          centerTitle: true,
          title: Text(
            widget.isCoursesTile == true
                ? 'Community & Networking'
                : 'Learn New Skills',
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => const CoursesPopup(),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: SvgPicture.asset(
                    'assets/svgs/info.svg',
                    height: 22,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: MasonryGridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 15.0,
            itemCount:
                controller.getCategoryIndustries(Constants.LEARNINGID).length,
            itemBuilder: (BuildContext context, int index) {
              return controller
                          .getCategoryIndustries(Constants.LEARNINGID)[index]
                          .active ==
                      true
                  ? Container()
                  : CustomTileLearning(
                      url: controller
                          .getCategoryIndustries(Constants.LEARNINGID)[index]
                          .photo,
                      label: controller
                          .getCategoryIndustries(Constants.LEARNINGID)[index]
                          .industry!,
                      count: controller
                          .getCategoryIndustries(Constants.LEARNINGID)[index]
                          .industry
                          ?.length
                          .toString(),
                      onTap: () {
                        final Industry industry = controller
                            .getCategoryIndustries(Constants.LEARNINGID)[index];

                        if (industry.industry == null ||
                            industry.industryId == null) {
                          Get.snackbar('Error', 'Invalid industry category');
                          return;
                        }

                        Get.to(() => const AllForumScreen(isCourses: true),
                            arguments: industry);
                      },
                    );
            },
          ),
        ),
      );
    });
  }
}
