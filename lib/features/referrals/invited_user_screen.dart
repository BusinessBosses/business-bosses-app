import 'package:flutter/material.dart';

import '../../action/action.dart';
import '../../common/models/my_user.dart';
import '../../common/params.dart';
import '../../common/widgets/safety_model.dart';
import '../profile/presentation/public_profile_screen.dart';
import '../promotions/invite.dart';

class InvitedUsersScreen extends StatefulWidget {
  static const String routeName = '/invited-users-screen';

  const InvitedUsersScreen({super.key});

  @override
  _InvitedUsersScreenState createState() => _InvitedUsersScreenState();
}

class _InvitedUsersScreenState extends State<InvitedUsersScreen> {
  final ScrollController _controller = ScrollController();

  final List<MyUser> _users = <MyUser>[];
  List<Invite> invitedUsers = <Invite>[];

  final bool _isLoadingNext = false;
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      _controller.addListener(_scrollListener);
      invitedUsers = ModalRoute.of(context)!.settings.arguments as List<Invite>;
      if (invitedUsers.isEmpty) navigateTo(context);
      invitedUsers.sort(
          (Invite a, Invite b) => b.timestamp!.compareTo(a.timestamp as num));
      _loadNextConnections();
      _isInit = true;
    }
  }

  // ignore: always_declare_return_types
  void _scrollListener() {
    if (_controller.position.atEdge) {
      if (_controller.position.pixels == 0) {
      } else {
        _loadNextConnections();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('_InvitedUsersScreenState.build');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accepted Invitation Users'),
      ),
      body: _users.isEmpty
          ? const SafetyModel(isLoading: true)
          : Stack(
              children: <Widget>[
                ListView.builder(
                  padding: const EdgeInsets.only(bottom: 48.0),
                  controller: _controller,
                  itemCount: _users.length,
                  itemBuilder: (BuildContext context, int i) {
                    return Column(
                      children: <Widget>[
                        ListTile(
                          onTap: () async {
                            var result = await navigateTo(
                              context,
                              routeName: PublicProfileScreen.routeName,
                              arguments: Params(arg1: _users[i].uid),
                            );
                            if (result == null) {
                              // ignore: use_build_context_synchronously
                              Navigator.of(context).pop();
                            }
                          },
                          // leading: UserAvatarWithBadge(
                          //   user: _users[i],
                          //   height: 48.0,
                          //   width: 48.0,
                          //   radius: 30.0,
                          //   placeHolder: Icons.person,
                          // ),
                          title: Text(_users[i].name.length <= 20
                              ? _users[i].name
                              : '${_users[i].name.substring(0, 20)}...'),
                          subtitle: Text(
                            _users[i].bio,
                            maxLines: 1,
                          ),
                        ),
                        const Divider(
                            height: 0.0, indent: 16.0, endIndent: 16.0),
                      ],
                    );
                  },
                ),
                if (_isLoadingNext)
                  const Positioned(
                    bottom: 10.0,
                    right: 0.0,
                    left: 0.0,
                    child: SafetyModel(isLoading: true),
                  ),
              ],
            ),
    );
  }

  Future<void> _loadNextConnections() async {}
}
