import 'package:business_bosses_v2/features/connects/widgets/connection_grid_tile.dart';
import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart'; // Import StaggeredGridView
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

  const FilterUsers({
    Key? key,
    this.filterItems = const <UserModel>[],
    this.isLoading = false,
    this.isSearch = false,
    this.onConnectionChange,
  }) : super(key: key);

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
      color: backgroundColor,
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
                      StaggeredGridView.countBuilder(
                        controller: _controller,
                        padding: const EdgeInsets.all(8.0),
                        crossAxisCount: 2, // Number of columns
                        crossAxisSpacing: 8.0, // Spacing between columns
                        mainAxisSpacing: 8.0, // Spacing between rows
                        itemCount: widget.filterItems.length +
                            (widget.isSearch ? 0 : 1), // +1 for bossOfTheWeek
                        itemBuilder: (BuildContext context, int index) {
                          // Handle bossOfTheWeek at the top if not in search mode
                          if (!widget.isSearch && index == 0) {
                            final bool checkConnected = _profileController
                                        .myProfile.connecteds !=
                                    null
                                ? _profileController.myProfile.connecteds!
                                    .contains(homeController.bossOfTheWeek?.uid)
                                : false;

                            return ConnectionGridTile(
                              user: homeController.bossOfTheWeek!,
                              status: checkConnected,
                              onChangeConnectionStatus: () {
                                if (widget.onConnectionChange != null) {
                                  widget.onConnectionChange!(
                                    homeController.bossOfTheWeek!,
                                  );
                                }
                              },
                            );
                          }

                          // Adjust index for the rest of the items
                          final int adjustedIndex =
                              widget.isSearch ? index : index - 1;
                          final UserModel user =
                              widget.filterItems[adjustedIndex];

                          final bool checkConnected =
                              _profileController.myProfile.connecteds != null
                                  ? _profileController.myProfile.connecteds!
                                      .contains(user.uid)
                                  : false;

                          return user.isRanked == true
                              ? Container()
                              : ConnectionGridTile(
                                  user: user,
                                  status: checkConnected,
                                  onChangeConnectionStatus: () {
                                    if (widget.onConnectionChange != null) {
                                      widget.onConnectionChange!(user);
                                    }
                                  },
                                );
                        },
                        staggeredTileBuilder: (int index) =>
                            const StaggeredTile.fit(1),
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
