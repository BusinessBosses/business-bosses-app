import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/models/user_model.dart';
import '../../../common/widgets/buttons/my_outlined_button.dart';
import '../../../common/widgets/safety_model.dart';
import '../../../common/widgets/user_avatar_with_badge.dart';
import '../../../utils/theme/theme.dart';
import '../../profile/presentation/publicprofilescreen.dart';

class FilterUsers extends StatefulWidget {
  final List<UserModel> filterItems;
  final bool isLoading;

  // ignore: public_member_api_docs
  const FilterUsers({
    Key? key,
    this.filterItems = const [],
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<FilterUsers> createState() => _FilterUsersState();
}

class _FilterUsersState extends State<FilterUsers> {
  final ScrollController _controller = ScrollController();
  final ProfileController _profileController = Get.find();
  final bool loadingNext = false;

  final List<UserModel> _users = [];

  final List<String> _userUids = [];

  int _loadedItems = 0;

  bool _isLoading = true;

  bool _isLoadingNext = false;

  bool _isInit = false;

  UserModel usersample = UserModel(
      name: 'Ernest', username: 'ernestjr', email: 'awukeurnesu@djd.com');

  _scrollListener() {
    if (_controller.position.atEdge) {
      if (_controller.position.pixels == 0) {
      } else {
        _loadNextConnections();
      }
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      getConnectedsConnections();
    });
    super.initState();
  }

  getConnectedsConnections() async {}

  Future<void> _loadNextConnections() async {}

  Future<void> connectUserPressed() async {}

  @override
  Widget build(
    BuildContext context,
  ) {
    return widget.filterItems.isEmpty
        ? SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Recommended Connections',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
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
                                final int checkConnected = _profileController
                                            .myProfile.connecteds !=
                                        null
                                    ? _profileController.myProfile.connecteds!
                                        .indexWhere((String element) =>
                                            element ==
                                            widget.filterItems[i].uid)
                                    : -1;
                                if (i == 0) {
                                  return Column(
                                    children: [
                                      ListTile(
                                        onTap: () async {
                                          Get.toNamed(Routes.publicProfile,
                                              arguments: widget.filterItems[i]);
                                        },
                                        leading: UserAvatarWithBadge(
                                          user: _profileController.myProfile,
                                          height: 48.0,
                                          width: 48.0,
                                          radius: 30.0,
                                          placeHolder: Icons.person,
                                        ),
                                        trailing: MCustomButton(
                                            buttonType: checkConnected != -1
              ),
              Container(
                height: MediaQuery.of(context).size.height - 182,
                color: Colors.white,
                child: _users.isNotEmpty
                    ? SafetyModel(
                        isLoading: _isLoading,
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
                            itemCount: 3,
                            itemBuilder: (BuildContext context, int i) {
                              if (i == 0) {
                                return Column(
                                  children: [
                                    ListTile(
                                      onTap: () async {
                                        var result = await navigateTo(
                                          context,
                                          routeName:
                                              PublicProfileScreen.routeName,
                                          arguments:
                                              Params(arg1: 'bossoftheweekuid'),
                                        );
                                        if (result == null) {
                                          Navigator.of(context).pop();
                                        }
                                      },
                                      leading: UserAvatarWithBadge(
                                        user: usersample,
                                        height: 48.0,
                                        width: 48.0,
                                        radius: 30.0,
                                        placeHolder: Icons.person,
                                      ),
                                      trailing: SizedBox(
                                        height: 40,
                                        width: 120,
                                        child: MCustomButton(
                                            buttonType: connectedbutton == false
                                                ? ButtonType.outline
                                                : ButtonType.elevated,
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 4.0),
                                            child: FittedBox(
                                              child: _profileController
                                                              .myProfile
                                                              .connecteds !=
                                                          null &&
                                                      _profileController
                                                          .myProfile.connecteds!
                                                          .contains(
                                                        widget
                                                            .filterItems[i].uid,
                                                      )
                                              child: myProfile.connecteds !=
                                                          null &&
                                                      myProfile.connecteds!
                                                          .contains(
                                                              publicUser.uid)
                                                  ? const Text(
                                                      'Connected',
                                                      style: TextStyle(
                                                          color:
                                                              primaryColorLT),
                                                    )
                                                  : const Text(
                                                      'Connect',
                                                      style: TextStyle(
                                                          color:
                                                              primaryColorLT),
                                                    ),
                                            ),
                                            onPressed: () async {}),
                                        title: const Text('bossoftheweekname'),
                                        subtitle: const Text(
                                          'bossoftheweekbio',
                                          maxLines: 1,
                                        ),
                                      ),
                                      const Divider(
                                          height: 0.0,
                                          indent: 16.0,
                                          endIndent: 16.0),
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
                                                  arguments:
                                                      widget.filterItems[i]);
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
                                                    buttonType:
                                                        checkConnected != -1
                                                            ? ButtonType.outline
                                                            : ButtonType
                                                                .elevated,
                                                    margin: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 4.0),
                                                    child: FittedBox(
                                                      child: _profileController
                                                                      .myProfile
                                                                      .connecteds !=
                                                                  null &&
                                                              _profileController
                                                                  .myProfile
                                                                  .connecteds!
                                                                  .contains(
                                                                widget
                                                                    .filterItems[
                                                                        i]
                                                                    .uid,
                                                              )
                                                          ? const Text(
                                                              'Connected',
                                                              style: TextStyle(
                                                                  color:
                                                                      primaryColorLT),
                                                            )
                                                          : const Text(
                                                              'Connect',
                                                              style: TextStyle(
                                                                  color:
                                                                      primaryColorLT),
                                                            ),
                                                    ),
                                                    onPressed: () async {
                                                      // onConnect();
                                                    })),
                                            title: Text(widget
                                                    .filterItems[i].name ??
                                                widget.filterItems[i].username),
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
                                                          color: Colors.white),
                                                    ),
                                            ),
                                            onPressed: () async {
                                              onConnect();
                                            }),
                                      ),
                                      title: Text('bossoftheweekname'),
                                      subtitle: Text(
                                        'bossoftheweekbio',
                                        maxLines: 1,
                                      ),
                                    ),
                                    const Divider(
                                        height: 0.0,
                                        indent: 16.0,
                                        endIndent: 16.0),
                                  ],
                                );
                              }
                              return Column(
                                children: [
                                  ListTile(
                                    onTap: () async {
                                      var result = await navigateTo(
                                        context,
                                        routeName:
                                            PublicProfileScreen.routeName,
                                        arguments: Params(arg1: _users[i].uid),
                                      );
                                      if (result == null) {
                                        Navigator.of(context).pop();
                                      }
                                    },
                                    leading: UserAvatarWithBadge(
                                      user: usersample,
                                      height: 48.0,
                                      width: 48.0,
                                      radius: 30.0,
                                      placeHolder: Icons.person,
                                    ),
                                    trailing: SizedBox(
                                        height: 40,
                                        width: 120,
                                        child: MCustomButton(
                                            buttonType: connectedbutton == false
                                                ? ButtonType.outline
                                                : ButtonType.elevated,
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 4.0),
                                            child: FittedBox(
                                              child: myProfile.connecteds !=
                                                          null &&
                                                      myProfile.connecteds!
                                                          .contains(
                                                              publicUser.uid)
                                                  ? const Text(
                                                      'Connected',
                                                      style: TextStyle(
                                                          color:
                                                              primaryColorLT),
                                                    )
                                                  : const Text(
                                                      'Connect',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                            ),
                                            onPressed: () async {
                                              onConnect();
                                            })),
                                    title: Text('_users[i].name!'),
                                    subtitle: Text(
                                      '_users[i].bio!',
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
                          if (_isLoadingNext)
                            const Positioned(
                              child: SafetyModel(isLoading: true),
                              bottom: 10.0,
                              right: 0.0,
                              left: 0.0,
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
          )
        : ListView.separated(
            key: ValueKey(widget.filterItems),
            separatorBuilder: (_, __) => const SizedBox(height: 8.0),
            padding: const EdgeInsets.all(16.0),
            itemCount: widget.filterItems.length,
            itemBuilder: (BuildContext context, int i) {
              return ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                tileColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                leading: UserAvatarWithBadge(
                  user: usersample,
                  height: 52.0,
                  width: 52.0,
                  radius: 50.0,
                  iconSize: 24.0,
                  placeHolder: Icons.person,
                ),
                title: Text(
                  widget.filterItems[i].name ?? widget.filterItems[i].username,
                  'widget.filterItems[i].name!',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                subtitle: Text(
                  'widget.filterItems[i].username',
                  maxLines: 1,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: textColor.withOpacity(0.6),
                      ),
                ),
                onTap: () {
                  Get.toNamed(Routes.publicProfile,
                      arguments: widget.filterItems[i]);
                },
              );
            },
          );
  }
}
