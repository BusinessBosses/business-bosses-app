import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../action/action.dart';
import '../../../common/models/my_connect.dart';
import '../../../common/models/my_user.dart';
import '../../../common/widgets/safety_model.dart';
import '../../../utils/constants/constants.dart';
import '../../../utils/theme/theme.dart';
import '../../search/search_app_bar.dart';
import '../widgets/connection_user_tile.dart';

class AllConnectionsScreen extends StatelessWidget {
  static const String routeName = '/all-connections-screen';

  bool _isSearching = false;

  UserModel? _specificUser;

  final bool _isLoading = true;

  final List<UserModel> _allUsers = [];
  final List<UserModel> _suggestedUsers = [];
  final List<UserModel> _searchedUsers = [];
  final List<MyConnect> _myConnections = [];
  final List<MyConnect> _myConnected = [];

  AllConnectionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int initialIndex = 0;
    return WillPopScope(
      onWillPop: () async {
        if (_isSearching) {}
        navigateTo(context);
        return false;
      },
      child: DefaultTabController(
        length: 3,
        initialIndex: initialIndex,
        child: Scaffold(
          appBar: _isSearching
              ? SearchAppBar(
                  hintText: 'Search person by name',
                  onClose: _onChangeSearching,
                  onChange: _onChange,
                )
              : AppBar(
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
                  ),
                  centerTitle: true,
                  title: const Text(
                    'Connections',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  actions: [
                    IconButton(
                      onPressed: _onChangeSearching,
                      icon: SvgPicture.asset('assets/svgs/search.svg'),
                    )
                  ],
                ),
          body: Stack(
            children: [
              _isLoading == false
                  ? const Center(child: CircularProgressIndicator.adaptive())
                  : Column(
                      children: [
                        Material(
                          color: Colors.white,
                          child: TabBar(
                            tabs: [
                              Tab(
                                child: FittedBox(
                                  child: Text(
                                    'Connections',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ),
                              ),
                              Tab(
                                child: FittedBox(
                                  child: Text(
                                    'Connected',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ),
                              ),
                              Tab(
                                child: FittedBox(
                                  child: Text(
                                    'Suggested',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: TabBarView(children: [
                            _myConnections.isEmpty
                                ? getSafetyModel(
                                    '@${_specificUser?.username} has no connections yet')
                                : ListView.separated(
                                    separatorBuilder: (_, __) =>
                                        const Divider(height: 0.0),
                                    itemCount: _myConnections.length,
                                    itemBuilder: (context, i) {
                                      UserModel specificUser =
                                          _allUsers.firstWhere(
                                        (UserModel u) =>
                                            u.uid ==
                                            _myConnections[i].connectedBy,
                                        orElse: () => UserModel(),
                                      );

                                      if (specificUser == null) {
                                        const ListTile(
                                          title: Text(
                                              'Something may not exist any more'),
                                          subtitle: Text(
                                              'Your may be blocked or delete'),
                                        );
                                      }

                                      return ConnectionUserItem(
                                        label: 'skd',
                                        user: specificUser,
                                        status: false,
                                        onChangeConnectionStatus: () async {},
                                      );
                                    },
                                  ),
                            _myConnected.isEmpty
                                ? getSafetyModel(
                                    '@${_specificUser?.username} is not connected yet')
                                : ListView.separated(
                                    separatorBuilder: (_, __) =>
                                        const Divider(height: 0.0),
                                    itemCount: _myConnected.length,
                                    itemBuilder: (context, i) {
                                      UserModel specificUser =
                                          _allUsers.firstWhere(
                                              (u) =>
                                                  u.uid ==
                                                  _myConnected[i].connectedTo,
                                              orElse: () => UserModel());
                                      if (specificUser == null) {
                                        const ListTile(
                                          title: Text(
                                              'Something may not exit any more'),
                                          subtitle: Text(
                                              'Your may be blocked or delete'),
                                        );
                                      }

                                      return ConnectionUserItem(
                                        user: specificUser,
                                        status: true,
                                        onChangeConnectionStatus: () async {},
                                      );
                                    },
                                  ),
                            _suggestedUsers.isEmpty
                                ? getSafetyModel(
                                    'We\'ve no users to suggest you!')
                                : ListView.separated(
                                    separatorBuilder: (_, __) =>
                                        const Divider(height: 0.0),
                                    itemCount: _suggestedUsers.length,
                                    itemBuilder: (context, i) {
                                      UserModel specificUser =
                                          _suggestedUsers.firstWhere(
                                              (u) =>
                                                  u.uid ==
                                                  _suggestedUsers[i].uid,
                                              orElse: () => UserModel());
                                      if (specificUser == null) {
                                        const ListTile(
                                          title: Text(
                                              'Something may not exit any more'),
                                          subtitle: Text(
                                              'Your may be blocked or delete'),
                                        );
                                      }
                                      return ConnectionUserItem(
                                        label: 'skd',
                                        user: specificUser,
                                        status: false,
                                        onChangeConnectionStatus: () async {},
                                      );
                                    },
                                  ),
                          ]),
                        )
                      ],
                    ),
              if (_isSearching)
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: _searchedUsers.isEmpty
                      ? SafetyModel(
                          isLoading: false,
                          icon: SvgPicture.asset(
                            'assets/svgs/search.svg',
                            color: hintColor,
                            height: 80.0,
                          ),
                          title: 'Search users',
                          subTitle: 'Matched users will be displayed here!',
                        )
                      : ListView.builder(
                          itemCount: _searchedUsers.length,
                          itemBuilder: (context, i) {
                            UserModel specificUser = _searchedUsers.firstWhere(
                                (u) => u.uid == _searchedUsers[i].uid,
                                orElse: () => UserModel());
                            if (specificUser == null) {
                              const ListTile(
                                title: Text('Something may not exit any more'),
                                subtitle: Text('Your may be blocked or delete'),
                              );
                            }

                            return ConnectionUserItem(
                              label: 'skd',
                              user: specificUser,
                              status: false,
                              onChangeConnectionStatus: () async {},
                            );
                          },
                        ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getSafetyModel(String title) {
    return SafetyModel(
      isLoading: false,
      icon: SvgPicture.asset(
        'assets/svgs/group.svg',
        color: hintColor,
        height: 80.0,
      ),
      title: title,
      subTitle: '',
    );
  }

  void _sendNotification(UserModel specificUser) {}

  void _onChangeSearching() {}

  _onChange(String val) {}
}
