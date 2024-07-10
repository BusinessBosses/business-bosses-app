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

class FilterDonationsUsers extends StatefulWidget {
  final List<UserModel> filterItems;
  final List<UserModel> members;
  final bool isLoading;
  final bool isSearch;
  final Function(UserModel)? onConnectionChange;

  // ignore: public_member_api_docs
  const FilterDonationsUsers(
      {Key? key,
      this.filterItems = const <UserModel>[],
      this.isLoading = false,
      this.isSearch = false,
      this.onConnectionChange,
      this.members = const <UserModel>[]})
      : super(key: key);

  @override
  State<FilterDonationsUsers> createState() => _FilterUsersState();
}

class _FilterUsersState extends State<FilterDonationsUsers> {
  final ScrollController _controller = ScrollController();
  final ProfileController _profileController = Get.find();
  final bool loadingNext = false;
  @override
  Widget build(
    BuildContext context,
  ) {
    final ProfileController profileController = Get.find();
    return widget.filterItems.isEmpty
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
            children: <Widget>[
              NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollNotification) {
                  FocusScope.of(context).unfocus();
                  return false;
                },
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 48.0),
                  controller: _controller,
                  itemCount: widget.filterItems.length,
                  itemBuilder: (BuildContext context, int i) {
                    final int checkConnected = _profileController
                                .myProfile.connecteds !=
                            null
                        ? _profileController.myProfile.connecteds!.indexWhere(
                            (String element) =>
                                element == (widget.filterItems[i].uid),
                          )
                        : -1;

                    return widget.filterItems[i].isRanked == true
                        ? Container()
                        : Container(
                            color: Colors.white,
                            child: Column(
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
                                        if (widget.onConnectionChange != null) {
                                          widget.onConnectionChange!(
                                            widget.filterItems[i],
                                          );
                                        }
                                        // onConnect();
                                      },
                                    ),
                                  ),
                                  title: widget.filterItems[i].isSubscribed ==
                                          true
                                      ? Row(
                                          children: <Widget>[
                                            Text(widget.filterItems[i].name !=
                                                        null &&
                                                    widget.filterItems[i].name!
                                                            .length <=
                                                        20
                                                ? widget.filterItems[i].name!
                                                : widget.filterItems[i].name !=
                                                        null
                                                    ? '${widget.filterItems[i].name!.substring(0, 20)}...'
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
                                          : widget.filterItems[i].name != null
                                              ? '${widget.filterItems[i].name!.substring(0, 20)}...'
                                              : widget.filterItems[i].username),
                                  subtitle: Text(
                                    widget.filterItems[i].bio ??
                                        widget.filterItems[i].category ??
                                        '',
                                    maxLines: 1,
                                  ),
                                ),
                                const Divider(
                                    height: 0.0, indent: 16.0, endIndent: 16.0),
                              ],
                            ),
                          );
                  },
                ),
              ),
              if (loadingNext)
                const Positioned(
                  bottom: 10.0,
                  right: 0.0,
                  left: 0.0,
                  child: SafetyModel(isLoading: true),
                ),
            ],
          );
  }
}
