import 'package:business_bosses_v2/features/impact/presentation/impact_screen.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/features/profile/widgets/public_profile_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../common/models/user_model.dart';
import '../../../common/widgets/buttons/custom_child_button.dart';
import '../../../navigation/routes.dart';

Widget friendProfileHeader(UserModel publicUser) {
  final ProfileController profileController = Get.find();
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        PublicProfileTile(
          myProfile: publicUser,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: CustomChildButton(
                value: publicUser.connectionCount ?? 0,
                caption: 'Followers',
                onPressed: () {
                  Get.toNamed(Routes.allconnectionsscreen,
                      arguments: <String, Object>{
                        'uid': publicUser.uid,
                        'pageIndex': 0
                      });
                },
              ),
            ),
            Expanded(
                child: CustomChildButton(
              value: publicUser.connectedCount ?? 0,
              caption: 'Following',
              onPressed: () {
                Get.toNamed(Routes.allconnectionsscreen,
                    arguments: <String, Object>{
                      'uid': publicUser.uid,
                      'pageIndex': 1
                    });
              },
            )),
            Expanded(
              child: CustomChildButton(
                value: profileController.impact['totalLikes'] +
                    profileController.impact['totalViews'],
                caption: 'Reach',
                onPressed: () {
                  Get.to(() => ReachScreen(user: publicUser));
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16.0),
      ],
    ),
  );
}
