import 'package:business_bosses_v2/features/profile/widgets/user_profile_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../action/action.dart';
import '../../../common/models/user_model.dart';
import '../../../common/widgets/buttons/custom_child_button.dart';
import '../../../navigation/routes.dart';
import '../../referrals/referrals_details_screen.dart';

Widget FriendProfileHeader() {
  final UserModel _publicUser = UserModel(
      achievements: 'jnkknmmk+llllmlhj+jkhkh'.split('+'),
      active: true,
      ageRange: '10',
      bio: 'bio text',
      category: 'wee',
      companyName: 'ee',
      website: 'ee',
      username: 'username',
      deactivated: false,
      email: 'email',
      gender: 'male',
      industry: 'FF',
      instagram: 'GGG',
      location: 'DGG',
      name: 'name',
      photoUrl: '',
      productsandservices: 'sdffgg+s+ksf'.split('+'),
      surname: 'surname',
      timestamp: 100394,
      twitter: '',
      uid: '',
      unReadCount: 12,
      bossOfTheWeekUpTimeStamp: 3455,
      bossOfTheWeekTimeStamp: 677);
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserProfileTile(
          myProfile: _publicUser,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: CustomChildButton(
                // TODO: CONNECTS
                value: 0,
                // value: _friendUser?.connects
                //           ?.where((e) => e.status == Constants.CONNECTION)
                //           ?.toList()
                //           ?.length ??
                //       0,
                caption: 'Connections',
                /*'Connections',*/
                onPressed: () {
                  Get.toNamed(Routes.allconnectionsscreen);
                  // navigateTo(
                  //   context,
                  //   routeName: AllConnectionsScreen.routeName,
                  //   arguments: Params(arg1: _publicUser),
                  // );
                },
              ),
            ),
            Expanded(
                child: CustomChildButton(
              // TODO: CONNECTS
              value: 0,

              // value: _friendUser?.connects
              //           ?.where((e) => e.status != Constants.CONNECTION)
              //           ?.toList()
              //           ?.length ??
              //       0,
              caption: 'Connected',
              // 'Connected',
              onPressed: () {
                Get.toNamed(Routes.allconnectionsscreen);
                // navigateTo(
                //   context,
                //   routeName: AllConnectionsScreen.routeName,
                //   arguments: Params(arg1: _publicUser, arg2: 1),
                // );
              },
            )),
            Expanded(
              child: CustomChildButton(
                value: 0,
                //_publicUser.refers == null
                //     ? 0
                //     : MyUser.refCount(_publicUser.refers),
                caption: 'Referrals',
                onPressed: () {
                  // navigateTo(
                  //   context,
                  //   routeName: ReferralsDetailsScreen.routeName,
                  //   arguments: _publicUser.refers,
                  // );
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
