import 'dart:math';
import 'package:business_bosses_v2/action/action.dart';
import 'package:flutter/material.dart';

import '../../common/models/my_refers.dart';
import '../../common/models/my_user.dart';
import '../../common/params.dart';
import '../../common/widgets/safety_model.dart';
import '../../common/widgets/user_avatar_with_badge.dart';
import '../profile/publicprofilescreen.dart';

class ReferralsDetailsScreen extends StatefulWidget {
  static const routeName = '/referrals-details-screen';

  const ReferralsDetailsScreen({Key? key}) : super(key: key);

  @override
  _ReferralsDetailsScreenState createState() => _ReferralsDetailsScreenState();
}

class _ReferralsDetailsScreenState extends State<ReferralsDetailsScreen> {
  final ScrollController _controller = ScrollController();

  List<MyRefers> _referrals = [];
  List<String> _userUids = [];

  final List<MyUser> _users = [];

  int _loadedItemsCount = 0;

  bool _isInit = false;
  bool _isLoadingNext = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      _controller.addListener(_scrollListener);
      _referrals = ModalRoute.of(context)?.settings.arguments as List<MyRefers>;
      if (_referrals.isEmpty) navigateTo(context);
      _userUids = MyRefers.uniqueUserUidList(referralsList: _referrals);
      _loadNextConnections();
      _isInit = true;
    }
  }

  _scrollListener() {
    if (_controller.position.atEdge) {
      if (_controller.position.pixels == 0) {
      } else {
        _loadNextConnections();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('_AllConnectionsScreenState.build');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Referrals'),
      ),
      body: _users.isEmpty
          ? const SafetyModel(isLoading: true)
          : Stack(
              children: [
                ListView.builder(
                  padding: const EdgeInsets.only(bottom: 48.0),
                  controller: _controller,
                  itemCount: _users.length,
                  itemBuilder: (BuildContext context, int i) {
                    return Column(
                      children: [
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
                          //   iconSize: 24.0,
                          // ),

                          title: Text(_users[i].name),
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
