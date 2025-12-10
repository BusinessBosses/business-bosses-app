import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/connects/controller/connection_controller.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../action/action.dart';
// import '../../../common/models/my_connect.dart';
import '../../../common/widgets/safety_model.dart';
import '../../../utils/theme/theme.dart';
import '../../search/widgets/search_app_bar.dart';
import '../widgets/connection_user_tile.dart';

class AllConnectionsScreen extends StatelessWidget {
  static const String routeName = '/all-connections-screen';
  // ignore: unused_field
  final ConnectionController _connectionController =
      Get.put(ConnectionController());
  final ProfileController _profileController = Get.find();

  AllConnectionsScreen({super.key});

  // int initialIndex = 0;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConnectionController>(
      builder: (ConnectionController controller) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (bool didPop, dynamic result) {
            if (didPop) {
              return;
            }
            if (controller.isSearching) {}
            navigateTo(context);
          },
          child: DefaultTabController(
            length: 3,
            initialIndex: Get.arguments['pageIndex'],
            child: Scaffold(
              appBar: controller.isSearching
                  ? searchAppBar(
                      hintText: 'Search person by name',
                      onClose: () {
                        controller.toggleSearchState();
                      },
                      onChange: _onChange,
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
                        'Followers',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
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
                      ? const Center(
                          child: CircularProgressIndicator.adaptive())
                      : Column(
                          children: <Widget>[
                            Material(
                              color: Colors.white,
                              child: TabBar(
                                tabs: <Widget>[
                                  Tab(
                                    child: FittedBox(
                                      child: Text(
                                        'Followers',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                    ),
                                  ),
                                  Tab(
                                    child: FittedBox(
                                      child: Text(
                                        'Following',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                    ),
                                  ),
                                  Tab(
                                    child: FittedBox(
                                      child: Text(
                                        'Suggested',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: TabBarView(children: <Widget>[
                                controller.connections.isEmpty
                                    ? getSafetyModel(
                                        '${_profileController.myProfile.uid == Get.arguments['uid'] ? 'You don\'t have any' : 'User has no'} connections yet')
                                    : ListView.separated(
                                        separatorBuilder: (_, __) =>
                                            const Divider(height: 0.0),
                                        itemCount:
                                            controller.connections.length,
                                        itemBuilder:
                                            (BuildContext context, int i) {
                                          final int checkConnected = controller
                                              .connecteds
                                              .indexWhere((UserModel element) =>
                                                  element.uid ==
                                                  controller
                                                      .connections[i].uid);
                                          return ConnectionUserItem(
                                            label: 'skd',
                                            user: controller.connections[i],
                                            status: checkConnected == -1
                                                ? false
                                                : true,
                                            isMe:
                                                controller.connections[i].uid ==
                                                        _profileController
                                                            .myProfile.uid
                                                    ? true
                                                    : false,
                                            onChangeConnectionStatus:
                                                (UserModel user) {
                                              controller.connectToUser(user);
                                            },
                                          );
                                        },
                                      ),
                                controller.connecteds.isEmpty
                                    ? getSafetyModel(
                                        '${_profileController.myProfile.uid == Get.arguments['uid'] ? 'You are' : 'User is'}  not connected yet')
                                    : ListView.separated(
                                        separatorBuilder: (_, __) =>
                                            const Divider(height: 0.0),
                                        itemCount: controller.connecteds.length,
                                        itemBuilder:
                                            (BuildContext context, int i) {
                                          final int checkConnected = controller
                                              .connecteds
                                              .indexWhere((UserModel element) =>
                                                  element.uid ==
                                                  controller.connecteds[i].uid);
                                          return ConnectionUserItem(
                                            user: controller.connecteds[i],
                                            status: checkConnected == -1
                                                ? false
                                                : true,
                                            isMe:
                                                controller.connecteds[i].uid ==
                                                        _profileController
                                                            .myProfile.uid
                                                    ? true
                                                    : false,
                                            onChangeConnectionStatus:
                                                (UserModel user) {
                                              controller.connectToUser(user);
                                            },
                                          );
                                        },
                                      ),
                                controller.suggestedUsers.isEmpty &&
                                        !controller.loading
                                    ? getSafetyModel(
                                        'We\'ve no users to suggest you!')
                                    : ListView.separated(
                                        separatorBuilder: (_, __) =>
                                            const Divider(height: 0.0),
                                        itemCount:
                                            controller.suggestedUsers.length,
                                        itemBuilder:
                                            (BuildContext context, int i) {
                                          final int checkConnected = controller
                                              .connecteds
                                              .indexWhere((UserModel element) =>
                                                  element.uid ==
                                                  controller
                                                      .suggestedUsers[i].uid);
                                          return ConnectionUserItem(
                                            label: 'skd',
                                            user: controller.suggestedUsers[i],
                                            status: checkConnected == -1
                                                ? false
                                                : true,
                                            isMe: controller.suggestedUsers[i]
                                                        .uid ==
                                                    _profileController
                                                        .myProfile.uid
                                                ? true
                                                : false,
                                            onChangeConnectionStatus:
                                                (UserModel user) {
                                              controller.connectToUser(user);
                                            },
                                          );
                                        },
                                      ),
                              ]),
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
                                colorFilter: ColorFilter.mode(
                                    hintColor, BlendMode.srcIn),
                                height: 80.0,
                              ),
                              title: 'Search users',
                              subTitle: 'Matched users will be displayed here!',
                            )
                          : ListView.builder(
                              itemCount: controller.searchedUsers.length,
                              itemBuilder: (BuildContext context, int i) {
                                final int checkConnected = controller.connecteds
                                    .indexWhere((UserModel element) =>
                                        element.uid ==
                                        controller.searchedUsers[i].uid);
                                return ConnectionUserItem(
                                  label: 'skd',
                                  user: controller.searchedUsers[i],
                                  status: checkConnected == -1 ? false : true,
                                  isMe: controller.searchedUsers[i].uid ==
                                          _profileController.myProfile.uid
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
            ),
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

  // void _sendNotification(UserModel specificUser) {}

  // void _onChangeSearching() {}

  void _onChange(String val) {}
}
