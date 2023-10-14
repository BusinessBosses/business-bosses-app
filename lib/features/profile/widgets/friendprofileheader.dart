import 'package:business_bosses_v2/features/profile/widgets/public_profile_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../common/models/user_model.dart';
import '../../../common/widgets/buttons/custom_child_button.dart';
import '../../../navigation/routes.dart';

Widget FriendProfileHeader(UserModel publicUser) {
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
                caption: 'Connections',
                onPressed: () {
                  Get.toNamed(Routes.allconnectionsscreen,
                      arguments: <String, Object>{'uid': publicUser.uid, 'pageIndex': 0});
                },
              ),
            ),
            Expanded(
                child: CustomChildButton(
              value: publicUser.connectedCount ?? 0,
              caption: 'Connected',
              onPressed: () {
                Get.toNamed(Routes.allconnectionsscreen,
                    arguments: <String, Object>{'uid': publicUser.uid, 'pageIndex': 1});
              },
            )),
            Expanded(
              child: CustomChildButton(
                value: publicUser.referalCount ?? 0,
                caption: 'Referrals',
                onPressed: () {
                  Get.toNamed(Routes.referalsscreen, arguments: publicUser.uid);
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
