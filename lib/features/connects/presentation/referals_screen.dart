import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/connects/controller/referrals_controller.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
// import '../../../common/models/my_connect.dart';
import '../../../common/widgets/safety_model.dart';
import '../../../utils/theme/theme.dart';
import '../../search/widgets/search_app_bar.dart';
import '../widgets/connection_user_tile.dart';

class ReferalsScreen extends StatelessWidget {
  const ReferalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find();
    return GetBuilder<ReferralsController>(
      builder: (ReferralsController controller) {
        return Scaffold(
          appBar: controller.isSearching
              ? SearchAppBar(
                  hintText: 'Search person by name',
                  onClose: () {
                    controller.toggleSearchState();
                  },
                  onSubmit: (String username) {
                    controller.search(username);
                  })
              : AppBar(
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
                  ),
                  centerTitle: true,
                  title: const Text(
                    'Referrals',
                    textAlign: TextAlign.center,
                  ),
                  actions: <Widget>[
                    IconButton(
                      onPressed: () {
                        controller.toggleSearchState();
                      },
                      icon: SvgPicture.asset('assets/svgs/search.svg'),
                    )
                  ],
                ),
          body: Stack(
            children: <Widget>[
              controller.loading
                  ? const Center(child: CircularProgressIndicator.adaptive())
                  : Column(
                      children: <Widget>[
                        Expanded(
                          child: controller.referrals.isEmpty
                              ? getSafetyModel(
                                  '${profileController.myProfile.uid == Get.arguments ? 'You don\'t have any' : 'User has no'} referrals yet')
                              : ListView.separated(
                                  separatorBuilder: (_, __) =>
                                      const Divider(height: 0.0),
                                  itemCount: controller.referrals.length,
                                  itemBuilder: (BuildContext context, int i) {
                                    final int checkConnected = controller
                                        .connecteds
                                        .indexWhere((String element) =>
                                            element ==
                                            controller.referrals[i].uid);
                                    return ConnectionUserItem(
                                      label: 'skd',
                                      user: controller.referrals[i],
                                      status:
                                          checkConnected == -1 ? false : true,
                                      isMe: controller.referrals[i].uid ==
                                              profileController.myProfile.uid
                                          ? true
                                          : false,
                                      onChangeConnectionStatus:
                                          (UserModel user) {
                                        controller.connectToUser(user);
                                      },
                                    );
                                  },
                                ),
                        )
                      ],
                    ),
              if (controller.isSearching)
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: controller.searchedUsers.isEmpty
                      ? SafetyModel(
                          isLoading: controller.loadingSearch,
                          icon: SvgPicture.asset(
                            'assets/svgs/search.svg',
                            colorFilter:
                                ColorFilter.mode(hintColor, BlendMode.srcIn),
                            height: 80.0,
                          ),
                          title: 'Search users',
                          subTitle: 'Matched users will be displayed here!',
                        )
                      : ListView.builder(
                          itemCount: controller.searchedUsers.length,
                          itemBuilder: (BuildContext context, int i) {
                            final int checkConnected = controller.connecteds
                                .indexWhere((String element) =>
                                    element == controller.searchedUsers[i].uid);
                            return ConnectionUserItem(
                              label: 'skd',
                              user: controller.searchedUsers[i],
                              status: checkConnected == -1 ? false : true,
                              isMe: controller.searchedUsers[i].uid ==
                                      profileController.myProfile.uid
                                  ? true
                                  : false,
                              onChangeConnectionStatus: (UserModel user) {
                                controller.connectToUser(user);
                              },
                            );
                          },
                        ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget getSafetyModel(String title) {
    return SafetyModel(
      isLoading: false,
      icon: SvgPicture.asset(
        'assets/svgs/group.svg',
        colorFilter: ColorFilter.mode(hintColor, BlendMode.srcIn),
        height: 80.0,
      ),
      title: title,
      subTitle: '',
    );
  }
}
