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
  final bool loadingNext = false;
  @override
  Widget build(
    BuildContext context,
  ) {
    final ProfileController profileController = Get.find();
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
                        itemCount: widget.filterItems.length,
                        itemBuilder: (BuildContext context, int i) {
                          final int checkConnected =
                              _profileController.myProfile.connecteds != null
                                  ? _profileController.myProfile.connecteds!
                                      .indexWhere(
                                      (String element) =>
                                          element ==
                                          (i == 0 && !widget.isSearch
                                              ? profileController
                                                  .bossOfTheWeek?.uid
                                              : widget.filterItems[i].uid),
                                    )
                                  : -1;
                          // ignore: curly_braces_in_flow_control_structures
                          // if (!widget.isSearch) if (i == 0) {
                          //   return Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: <Widget>[
                          //       Container(
                          //         width: MediaQuery.of(context).size.width,
                          //         color: backgroundcolorinterface,
                          //         child: const Padding(
                          //           padding: EdgeInsets.only(
                          //               left: 20,
                          //               right: 20,
                          //               top: 10,
                          //               bottom: 10),
                          //           child: Text(
                          //             'Recommended Connections',
                          //             style: TextStyle(
                          //                 fontWeight: FontWeight.w500,
                          //                 fontSize: 16),
                          //           ),
                          //         ),
                          //       ),
                          //       ListTile(
                          //         onTap: () async {
                          //           Get.toNamed(Routes.publicProfile,
                          //               arguments:
                          //                   profileController.bossOfTheWeek);
                          //         },
                          //         leading: UserAvatarWithBadge(
                          //           user: _profileController.bossOfTheWeek,
                          //           height: 48.0,
                          //           width: 48.0,
                          //           radius: 30.0,
                          //           placeHolder: Icons.person,
                          //         ),
                          //         trailing: MCustomButton(
                          //           width: 120,
                          //           height: 40,
                          //           buttonType: checkConnected != -1
                          //               ? ButtonType.outline
                          //               : ButtonType.elevated,
                          //           margin: const EdgeInsets.symmetric(
                          //               horizontal: 4.0),
                          //           child: FittedBox(
                          //             child: _profileController
                          //                             .myProfile.connecteds !=
                          //                         null &&
                          //                     _profileController
                          //                         .myProfile.connecteds!
                          //                         .contains(
                          //                       profileController
                          //                           .bossOfTheWeek?.uid,
                          //                     )
                          //                 ? const Text(
                          //                     'Connected',
                          //                     style: TextStyle(
                          //                         color: primaryColorLT),
                          //                   )
                          //                 : const Text(
                          //                     'Connect',
                          //                     style: TextStyle(
                          //                         color: Colors.white),
                          //                   ),
                          //           ),
                          //           onPressed: () async {
                          //             if (widget.onConnectionChange != null) {
                          //               widget.onConnectionChange!(
                          //                 profileController.bossOfTheWeek!,
                          //               );
                          //             }
                          //           },
                          //         ),
                          //         title: profileController
                          //                     .bossOfTheWeek?.isSubscribed ==
                          //                 true
                          //             ? Row(
                          //                 children: <Widget>[
                          //                   Text(profileController
                          //                               .bossOfTheWeek!
                          //                               .name!
                          //                               .length <=
                          //                           20
                          //                       ? profileController
                          //                               .bossOfTheWeek?.name ??
                          //                           profileController
                          //                               .bossOfTheWeek
                          //                               ?.username ??
                          //                           ''
                          //                       : profileController
                          //                                   .bossOfTheWeek!
                          //                                   .name !=
                          //                               null
                          //                           ? '${profileController.bossOfTheWeek!.name!.substring(0, 12)}...}'
                          //                           : '${profileController.bossOfTheWeek!.username.substring(0, 12)}...)}'),
                          //                   const SizedBox(width: 5),
                          //                   SvgPicture.asset(
                          //                     'assets/svgs/premiumbadge.svg',
                          //                     height: 9,
                          //                     color: primaryColorLT,
                          //                   )
                          //                 ],
                          //               )
                          //             : Text(profileController.bossOfTheWeek!
                          //                         .name!.length <=
                          //                     20
                          //                 ? profileController
                          //                         .bossOfTheWeek?.name ??
                          //                     profileController
                          //                         .bossOfTheWeek?.username ??
                          //                     ''
                          //                 : profileController
                          //                             .bossOfTheWeek!.name !=
                          //                         null
                          //                     ? '${profileController.bossOfTheWeek!.name!.substring(0, 12)}...}'
                          //                     : '${profileController.bossOfTheWeek!.username.substring(0, 12)}...)}'),
                          //         subtitle: Text(
                          //           profileController.bossOfTheWeek?.bio ??
                          //               profileController
                          //                   .bossOfTheWeek?.category ??
                          //               '',
                          //           maxLines: 1,
                          //         ),
                          //       ),
                          //       const Divider(
                          //           height: 0.0, indent: 16.0, endIndent: 16.0),
                          //     ],
                          //   );
                          // }
                          return widget.filterItems[i].isRanked == true
                              ? Container()
                              : Column(
                                  children: <Widget>[
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
                                            child: checkConnected != -1
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
                                      title: widget.filterItems[i]
                                                  .isSubscribed ==
                                              true
                                          ? Row(
                                              children: <Widget>[
                                                Text(widget.filterItems[i]
                                                                .name !=
                                                            null &&
                                                        widget.filterItems[i]
                                                                .name!.length <=
                                                            20
                                                    ? widget
                                                        .filterItems[i].name!
                                                    : widget.filterItems[i]
                                                                .name !=
                                                            null
                                                        ? '${widget.filterItems[i].name!.substring(0, 15)}...'
                                                        : widget.filterItems[i]
                                                            .username),
                                                const SizedBox(width: 5),
                                                SvgPicture.asset(
                                                  'assets/svgs/premiumbadge.svg',
                                                  height: 9,
                                                  color: primaryColorLT,
                                                )
                                              ],
                                            )
                                          : Text(widget.filterItems[i].name !=
                                                      null &&
                                                  widget.filterItems[i].name!
                                                          .length <=
                                                      20
                                              ? widget.filterItems[i].name!
                                              : widget.filterItems[i].name !=
                                                      null
                                                  ? '${widget.filterItems[i].name!.substring(0, 15)}...'
                                                  : widget
                                                      .filterItems[i].username),
                                      subtitle: Text(
                                        widget.filterItems[i].bio ??
                                            widget.filterItems[i].category ??
                                            '',
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
