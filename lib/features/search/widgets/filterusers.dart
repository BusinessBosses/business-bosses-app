import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../common/models/user_model.dart';
import '../../../common/widgets/buttons/my_outlined_button.dart';
import '../../../common/widgets/safety_model.dart';
import '../../../common/widgets/user_avatar_with_badge.dart';
import '../../../utils/theme/theme.dart';

class FilterUsers extends StatefulWidget {
  final List<UserModel> filterItems;
  final bool isLoading;
  final bool isSearch;
  final Function(UserModel)? onConnectionChange;

  // ignore: public_member_api_docs
  const FilterUsers(
      {Key? key,
      this.filterItems = const <UserModel>[],
      this.isLoading = false,
      this.isSearch = false,
      this.onConnectionChange})
      : super(key: key);

  @override
  State<FilterUsers> createState() => _FilterUsersState();
}

class _FilterUsersState extends State<FilterUsers> {
  final ScrollController _controller = ScrollController();
  final ProfileController _profileController = Get.find();
  final HomeController homeController = Get.find();
  final bool loadingNext = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: double.infinity,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          widget.filterItems.isEmpty
              ? SafetyModel(
                  isLoading: widget.isLoading,
                  icon: const Icon(
                    Icons.person,
                    size: 80.0,
                    color: hintColor,
                  ),
                  title: 'There is no user',
                  subTitle: 'Search by name or username',
                )
              : Expanded(
                  child: Stack(
                    children: <Widget>[
                      ListView.builder(
                        padding: const EdgeInsets.only(bottom: 48.0),
                        controller: _controller,
                        itemCount: widget.filterItems.length +
                            (widget.isSearch
                                ? 0
                                : 1), // Add 1 for bossOfTheWeek
                        itemBuilder: (BuildContext context, int i) {
                          // Handle bossOfTheWeek at the top if not in search mode
                          if (!widget.isSearch && i == 0) {
                            final int checkConnected =
                                _profileController.myProfile.connecteds != null
                                    ? _profileController.myProfile.connecteds!
                                        .indexWhere(
                                        (String element) =>
                                            element ==
                                            homeController.bossOfTheWeek?.uid,
                                      )
                                    : -1;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ListTile(
                                  onTap: () async {
                                    Get.toNamed(Routes.publicProfile,
                                        arguments:
                                            homeController.bossOfTheWeek);
                                  },
                                  leading: UserAvatarWithBadge(
                                    user: homeController.bossOfTheWeek,
                                    height: 48.0,
                                    width: 48.0,
                                    radius: 30.0,
                                    placeHolder: Icons.person,
                                  ),
                                  trailing: MCustomButton(
                                    width: 120,
                                    height: 40,
                                    buttonType: checkConnected != -1
                                        ? ButtonType.outline
                                        : ButtonType.elevated,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    child: FittedBox(
                                      child: checkConnected != -1
                                          ? const Text(
                                              'Following',
                                              style: TextStyle(
                                                  color: primaryColorLT),
                                            )
                                          : const Text(
                                              'Follow',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                    ),
                                    onPressed: () async {
                                      if (widget.onConnectionChange != null) {
                                        widget.onConnectionChange!(
                                          homeController.bossOfTheWeek!,
                                        );
                                      }
                                    },
                                  ),
                                  title: homeController
                                              .bossOfTheWeek?.isSubscribed ==
                                          true
                                      ? Row(
                                          children: <Widget>[
                                            Text(homeController.bossOfTheWeek!
                                                        .name!.length <=
                                                    20
                                                ? homeController
                                                        .bossOfTheWeek?.name ??
                                                    homeController.bossOfTheWeek
                                                        ?.username ??
                                                    ''
                                                : homeController.bossOfTheWeek!
                                                            .name !=
                                                        null
                                                    ? '${homeController.bossOfTheWeek!.name!.substring(0, 12)}...}'
                                                    : '${homeController.bossOfTheWeek!.username.substring(0, 12)}...)}'),
                                            const SizedBox(width: 5),
                                            SvgPicture.asset(
                                              'assets/svgs/premiumbadge.svg',
                                              height: 9,
                                              color: primaryColorLT,
                                            )
                                          ],
                                        )
                                      : Text(homeController.bossOfTheWeek!.name!
                                                  .length <=
                                              20
                                          ? homeController
                                                  .bossOfTheWeek?.name ??
                                              homeController
                                                  .bossOfTheWeek?.username ??
                                              ''
                                          : homeController
                                                      .bossOfTheWeek!.name !=
                                                  null
                                              ? '${homeController.bossOfTheWeek!.name!.substring(0, 12)}...}'
                                              : '${homeController.bossOfTheWeek!.username.substring(0, 12)}...)}'),
                                  subtitle: Text(
                                    homeController.bossOfTheWeek?.bio ??
                                        homeController
                                            .bossOfTheWeek?.category ??
                                        '',
                                    maxLines: 1,
                                  ),
                                ),
                                const Divider(
                                    height: 0.0, indent: 16.0, endIndent: 16.0),
                              ],
                            );
                          }

                          // Adjust index for the rest of the items
                          final int adjustedIndex = widget.isSearch ? i : i - 1;
                          final UserModel user =
                              widget.filterItems[adjustedIndex];

                          final int checkConnected =
                              _profileController.myProfile.connecteds != null
                                  ? _profileController.myProfile.connecteds!
                                      .indexWhere(
                                      (String element) => element == user.uid,
                                    )
                                  : -1;

                          return user.isRanked == true
                              ? Container()
                              : Column(
                                  children: <Widget>[
                                    ListTile(
                                      onTap: () async {
                                        Get.toNamed(Routes.publicProfile,
                                            arguments: user);
                                      },
                                      leading: UserAvatarWithBadge(
                                        user: user,
                                        height: 48.0,
                                        width: 48.0,
                                        radius: 30.0,
                                        placeHolder: Icons.person,
                                      ),
                                      trailing: SizedBox(
                                        height: 40,
                                        width: 120,
                                        child: MCustomButton(
                                          buttonType: checkConnected != -1
                                              ? ButtonType.outline
                                              : ButtonType.elevated,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 4.0),
                                          child: FittedBox(
                                            child: checkConnected != -1
                                                ? const Text(
                                                    'Following',
                                                    style: TextStyle(
                                                      color: primaryColorLT,
                                                    ),
                                                  )
                                                : const Text(
                                                    'Follow',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                          ),
                                          onPressed: () async {
                                            if (widget.onConnectionChange !=
                                                null) {
                                              widget.onConnectionChange!(user);
                                            }
                                          },
                                        ),
                                      ),
                                      title: user.isSubscribed == true
                                          ? Row(
                                              children: <Widget>[
                                                Text(user.name != null &&
                                                        user.name!.length <= 20
                                                    ? user.name!
                                                    : user.name != null
                                                        ? '${user.name!.substring(0, 15)}...'
                                                        : user.username),
                                                const SizedBox(width: 5),
                                                SvgPicture.asset(
                                                  'assets/svgs/premiumbadge.svg',
                                                  height: 9,
                                                  color: primaryColorLT,
                                                )
                                              ],
                                            )
                                          : Text(user.name != null &&
                                                  user.name!.length <= 20
                                              ? user.name!
                                              : user.name != null
                                                  ? '${user.name!.substring(0, 15)}...'
                                                  : user.username),
                                      subtitle: Text(
                                        user.bio ?? user.category ?? '',
                                        maxLines: 1,
                                      ),
                                    ),
                                    const Divider(
                                        height: 0.0,
                                        indent: 16.0,
                                        endIndent: 16.0),
                                  ],
                                );
                        },
                      ),
                      if (loadingNext)
                        const Positioned(
                          bottom: 10.0,
                          right: 0.0,
                          left: 0.0,
                          child: SafetyModel(isLoading: true),
                        ),
                    ],
                  ),
                )
        ],
      ),
    );
  }
}
