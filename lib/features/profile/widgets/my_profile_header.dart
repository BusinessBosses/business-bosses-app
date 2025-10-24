import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/impact/presentation/impactscreen.dart';
import 'package:business_bosses_v2/features/matching_feature/widgets/banner.dart';
import 'package:business_bosses_v2/features/profile/widgets/user_profile_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/buttons/custom_child_button.dart';
import '../../../navigation/routes.dart';
import '../../../utils/theme/theme.dart';

class MyProfileHeader extends StatelessWidget {
  const MyProfileHeader({super.key, required this.myProfile});
  final UserModel myProfile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (myProfile.matchType == null)
          PersonalizationBanner(
            onSetupPressed: () => print('Setup pressed'),
            onClosePressed: () => print('Close pressed'),
          ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              UserProfileTile(
                myProfile: myProfile,
              ),
              const SizedBox(
                height: 13,
              ),
              Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                        child: CustomChildButton(
                      onPressed: () {
                        Get.toNamed(Routes.allconnectionsscreen,
                            arguments: <String, Object>{
                              'uid': myProfile.uid,
                              'pageIndex': 0
                            });
                        // return navigateTo(
                        //   context,
                        //   routeName: AllConnectionsScreen.routeName,
                        //   arguments: Params(arg1: myProfile),
                        // );
                      },
                      caption: 'Followers',
                      value: myProfile.connectionCount ?? 0,
                    )),
                    Expanded(
                        child: CustomChildButton(
                      onPressed: () {
                        Get.toNamed(Routes.allconnectionsscreen,
                            arguments: <String, Object>{
                              'uid': myProfile.uid,
                              'pageIndex': 1
                            });
                        // Get.toNamed(Routes.allconnectionsscreen);
                        // navigateTo(
                        //   context,
                        //   routeName: AllConnectionsScreen.routeName,
                        //   arguments: Params(arg1: myProfile, arg2: 1),
                        // );
                      },
                      caption: 'Following',
                      value: myProfile.connecteds?.length ?? 0,
                    )),
                    Expanded(
                      child: CustomChildButton(
                        value: 0,
                        caption: 'Impact',
                        onPressed: () {
                          Get.to(() => ImpactScreen());
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ],
    );
  }

  Widget OutlinedContainer(BuildContext context, Widget child,
      {required Function onTap}) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        // padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        margin: const EdgeInsets.only(right: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radiusValue),
          border: Border.all(color: Theme.of(context).primaryColor, width: 1),
        ),
        child: child,
      ),
    );
  }

  Widget LRCL(context, String value, String caption) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          value,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          caption,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: textColor.withValues(alpha: 0.52),
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
        )
      ],
    );
  }
}
