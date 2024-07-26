import 'package:business_bosses_v2/common/widgets/tiles/custom_tile_learning.dart';
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

  final isCoursesTile;

  const AllLearningPostsScreen({Key? key, this.isCoursesTile})
      : super(key: key);

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
                Navigator.pop(context);
              },
              icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
            ),
            centerTitle: true,
            title: Text(
              widget.isCoursesTile == true
                  ? 'Networking & Community'
                  : 'Courses and Tutorials',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Expanded(
              child: StaggeredGridView.countBuilder(
                crossAxisCount: 2,
                crossAxisSpacing: 15.0,
                itemCount: controller
                    .getCategoryIndustries(Constants.LEARNINGID)
                    .length,
                itemBuilder: (BuildContext context, int index) {
                  return CustomTileLearning(
                    label: controller
                        .getCategoryIndustries(Constants.LEARNINGID)[index]
                        .industry!,
                    onTap: () {
                      if (widget.isCoursesTile == true) {
                        Get.to(const AllForumScreen(isCourses: false),
                            arguments: controller.getCategoryIndustries(
                                Constants.LEARNINGID)[index]);
                      } else {
                        Get.to(const AllForumScreen(isCourses: true),
                            arguments: controller.getCategoryIndustries(
                                Constants.LEARNINGID)[index]);
                      }
                      // Get.toNamed(
                      //   Routes.allforumscreen,
                      //   arguments: controller
                      //       .getCategoryIndustries(Constants.LEARNINGID)[index],
                      // );
                    },
                  );
                },
                staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
              ),
            ),
          ));
    });
  }
}
