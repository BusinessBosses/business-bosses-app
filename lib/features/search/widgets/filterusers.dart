import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:flutter/material.dart';
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
      this.filterItems = const [],
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
  final bool loadingNext = false;
  @override
  Widget build(
    BuildContext context,
  ) {
    final ProfileController profileController = Get.find();
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Recommended Connections',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 182,
            color: Colors.white,
            child: widget.filterItems.isEmpty
                ? SafetyModel(
                    isLoading: widget.isLoading,
                    icon: const Icon(
                      Icons.person,
                      size: 80.0,
                      color: hintColor,
                    ),
                    title: 'There is no user',
                    // subTitle: 'Be the first one to like!',
                  )
                : Stack(
                    children: [
                      ListView.builder(
                        padding: const EdgeInsets.only(bottom: 48.0),
                        controller: _controller,
                        itemCount: widget.filterItems.length,
                        itemBuilder: (BuildContext context, int i) {
                          final int checkConnected =
                              _profileController.myProfile.connecteds != null
                                  ? _profileController.myProfile.connecteds!
                                      .indexWhere(
                                      (String element) =>
                                          element ==
                                          (i == 0
                                              ? profileController
                                                  .bossOfTheWeek?.uid
                                              : widget.filterItems[i].uid),
                                    )
                                  : -1;
                          // ignore: curly_braces_in_flow_control_structures
                          if (!widget.isSearch) if (i == 0) {
                            return Column(
                              children: [
                                ListTile(
                                  onTap: () async {
                                    Get.toNamed(Routes.publicProfile,
                                        arguments:
                                            profileController.bossOfTheWeek);
                                  },
                                  leading: UserAvatarWithBadge(
                                    user: _profileController.bossOfTheWeek,
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
                                      child: _profileController
                                                      .myProfile.connecteds !=
                                                  null &&
                                              _profileController
                                                  .myProfile.connecteds!
                                                  .contains(
                                                profileController
                                                    .bossOfTheWeek?.uid,
                                              )
                                          ? const Text(
                                              'Connected',
                                              style: TextStyle(
                                                  color: primaryColorLT),
                                            )
                                          : const Text(
                                              'Connect',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                    ),
                                    onPressed: () async {
                                      if (widget.onConnectionChange != null) {
                                        widget.onConnectionChange!(
                                          profileController.bossOfTheWeek!,
                                        );
                                      }
                                    },
                                  ),
                                  title: Text(
                                      profileController.bossOfTheWeek?.name ??
                                          profileController
                                              .bossOfTheWeek?.username ??
                                          ''),
                                  subtitle: Text(
                                    profileController.bossOfTheWeek?.bio ?? '',
                                    maxLines: 1,
                                  ),
                                ),
                                const Divider(
                                    height: 0.0, indent: 16.0, endIndent: 16.0),
                              ],
                            );
                          }
                          return widget.filterItems[i].isRanked == true
                              ? Container()
                              : Column(
                                  children: [
                                    ListTile(
                                      onTap: () async {
                                        Get.toNamed(Routes.publicProfile,
                                            arguments: widget.filterItems[i]);
                                      },
                                      leading: UserAvatarWithBadge(
                                        user: widget.filterItems[i],
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
                                            child: _profileController.myProfile
                                                            .connecteds !=
                                                        null &&
                                                    _profileController
                                                        .myProfile.connecteds!
                                                        .contains(
                                                      widget.filterItems[i].uid,
                                                    )
                                                ? const Text(
                                                    'Connected',
                                                    style: TextStyle(
                                                      color: primaryColorLT,
                                                    ),
                                                  )
                                                : const Text(
                                                    'Connect',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                          ),
                                          onPressed: () async {
                                            if (widget.onConnectionChange !=
                                                null) {
                                              widget.onConnectionChange!(
                                                widget.filterItems[i],
                                              );
                                            }
                                            // onConnect();
                                          },
                                        ),
                                      ),
                                      title: Text(widget.filterItems[i].name !=
                                                  null &&
                                              widget.filterItems[i].name!
                                                      .length <=
                                                  20
                                          ? widget.filterItems[i].name!
                                          : widget.filterItems[i].name != null
                                              ? '${widget.filterItems[i].name!.substring(0, 20)}...'
                                              : widget.filterItems[i].username),
                                      subtitle: Text(
                                        widget.filterItems[i].bio ?? '',
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
