import 'package:business_bosses_v2/features/forum/controller/challenge_controller.dart';
import 'package:business_bosses_v2/features/forum/presentation/bossup_screen.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../common/widgets/safety_model.dart';
import '../../../common/widgets/tiles/custom_tile.dart';
import '../../../utils/theme/theme.dart';
import '../../forum/models/industry.dart';

class MySearchIndustries extends StatelessWidget {
  final List<Industry> searchIndustries;
  final ChallengeController challengeController = Get.find();
  final bool isLoading;

  MySearchIndustries({
    Key? key,
    this.searchIndustries = const <Industry>[],
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return searchIndustries.isEmpty
        ? SafetyModel(
            mainAxisAlignment: MainAxisAlignment.start,
            isLoading: isLoading,
            icon: SvgPicture.asset('assets/svgs/search.svg',
                color: hintColor, height: 80.0, width: 80.0),
            title: 'Search for industries',
            subTitle: 'Search for specific industry!',
          )
        : ListView.builder(
            padding: const EdgeInsets.only(
              top: 8.0,
              right: 8.0,
              left: 8.0,
              bottom: 120.0,
            ),
            itemCount: searchIndustries.length,
            itemBuilder: (BuildContext context, int i) {
              return CustomTile(
                label: searchIndustries[i].industry!,
                photo: searchIndustries[i].photo!,
                onTap: () {
                  if (searchIndustries[i].categoryId ==
                      Constants.BOSS_UP_CHALLENGE_CATEGORY_ID) {
                    Get.to(() => BossUpSection(
                          industry: searchIndustries[i],
                          bossUp: challengeController.categories[0],
                        ));
                  } else {
                    Get.toNamed(
                      Routes.allforumscreen,
                      arguments: searchIndustries[i],
                    );
                  }
                },
              );
            },
          );
  }
}
