import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../action/action.dart';
import '../../../common/models/my_connect.dart';
import '../../../common/models/my_user.dart';
import '../../../common/params.dart';
import '../../../common/widgets/safety_model.dart';
import '../../../utils/constants/constants.dart';
import '../../../utils/theme/theme.dart';
import '../../profile/presentation/update_profile_screen.dart';
import '../widgets/connection_grid_tile.dart';

class RelevantUsersScreen extends StatelessWidget {
  bool _isInit = false;
  UserModel? _user;
  List<UserModel> _relevantUsers = [];
  Future<void> _loadRelevantUsers() async {}

  void _sendNotification(UserModel user) {
    if (user.deviceTokens == null) return;
  }

  static const String routeName = '/relevant-users-screen';

  RelevantUsersScreen({Key? key}) : super(key: key);

  Widget _safetyModal(MyUser user) {
    if ((user.category?.isEmpty ?? true) && (user.industry?.isEmpty ?? true)) {
      return SafetyModel(
        icon: const Icon(
          Icons.info_outline,
          size: 80.0,
          color: hintColor,
        ),
        isLoading: _isLoading,
        title: 'You may have incomplete profile!',
        subTitle: 'You don\'t have category or industry yet',
        clickableText: 'Complete profile',
        onTap: () async {
          await navigateTo(context,
              routeName: UpdateProfileScreen.routeName, arguments: true);
          _user = Provider.of<UserController>(context, listen: false).user;
          setState(() {});
          _loadRelevantUsers();
        },
      );
    }
    return SafetyModel(
      icon: SvgPicture.asset(
        'assets/svgs/group.svg',
        color: hintColor,
        height: 80.0,
      ),
      isLoading: _isLoading,
      title: 'You\'ve no matched users for now',
      subTitle: 'All relevant users will be displayed here!',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundcolorinterface,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        ),
        centerTitle: true,
        title: const Text(
          'Connect',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: _relevantUsers.isEmpty
          ? _safetyModal(_user)
          : StaggeredGridView.countBuilder(
              padding: const EdgeInsets.all(8.0),
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              itemCount: _relevantUsers.length,
              itemBuilder: (context, index) {
                MyUser specificUser = _relevantUsers[index];
                return Consumer<UserController>(
                  builder: (_, userCtrl, __) {
                    bool isConnected = userCtrl.isConnected(specificUser.uid);
                    return ConnectionGridTile(
                        user: specificUser,
                        status: userCtrl.isConnected(specificUser.uid),
                        onChangeConnectionStatus: () async {
                          String connectId = MyConnect.connectId(
                              userCtrl.user.uid, specificUser.uid);
                          String puCountPath = Constants.USERS +
                              '/' +
                              specificUser.uid +
                              '/' +
                              'connectionCount';
                          String myCountPath = Constants.USERS +
                              '/' +
                              _firebase.uid +
                              '/' +
                              'connectedCount';
                          Map<String, dynamic> map = {};
                          if (isConnected) {
                            userCtrl.removeConnect(specificUser.uid);
                            if (specificUser.connectionCount > 0) {
                              specificUser.connectionCount--;
                            }

                            map[puCountPath] = specificUser.connectionCount;
                            map[myCountPath] = userCtrl.user.connectedCount;
                            map[Constants.CONNECTIONS + '/' + connectId] = null;
                          } else {
                            MyConnect newConnect = MyConnect(
                              id: connectId,
                              connectedTo: specificUser.uid,
                              connectedBy: _firebase.uid,
                              timestamp: DateTime.now().millisecondsSinceEpoch,
                            );
                            userCtrl.updateConnect(newConnect);
                            map[Constants.CONNECTIONS + '/' + connectId] =
                                newConnect.toMap();
                            _sendNotification(specificUser);
                            specificUser.connectionCount++;
                            setState(() {});
                            debugPrint(
                                'asdfasdf ${specificUser.connectionCount}');
                            map[puCountPath] = specificUser.connectionCount;
                            map[myCountPath] = userCtrl.user.connectedCount;
                          }
                          debugPrint(
                              '_PublicProfileScreenState.OutlineButtonHeader: map $map');
                          await _firebase.updateWithBatch(map);
/*                          String connectId = MyConnect.connectId(
                              userCtrl.user.uid, specificUser.uid);

                          String puCountPath = Constants.USERS +
                              '/' +
                              specificUser.uid +
                              '/' +
                              'connectedCount';
                          String myCountPath = Constants.USERS +
                              '/' +
                              _firebase.uid +
                              '/' +
                              'connectionCount';
                          Map<String, dynamic> map = {};
                          if (isConnection) {
                            userCtrl.removeConnect(specificUser.uid);
                            if (specificUser.connectedCount > 0) {
                              specificUser.connectedCount--;
                            }
                            setState(() {});

                            map[puCountPath] = specificUser.connectedCount;
                            map[myCountPath] = userCtrl.user.connectionCount;
                            map[Constants.CONNECTIONS + '/' + connectId] = null;
                          } else {
                            MyConnect newConnect = MyConnect(
                              id: connectId,
                              connectedTo: specificUser.uid,
                              connectedBy: _firebase.uid,
                              timestamp: DateTime.now().millisecondsSinceEpoch,
                            );
                            userCtrl.updateConnect(newConnect);
                            map[Constants.CONNECTIONS + '/' + connectId] =
                                newConnect.toMap();
                            _sendNotification(specificUser);
                            // _publicUser.connectionCount =
                            specificUser.connectedCount++;
                            setState(() {});
                            debugPrint('asdfasdf ${specificUser.connectedCount}');

                            map[puCountPath] = specificUser.connectedCount;
                            map[myCountPath] = userCtrl.user.connectionCount;
                          }
                          debugPrint(
                              '_PublicProfileScreenState.OutlineButtonHeader: map ${map}');
                          await _firebase.updateWithBatch(map);*/
                        }
                        //     () {
                        //   MyConnect newConnect = MyConnect(
                        //     connectedBy: specificUser.uid,
                        //     timestamp: DateTime.now().millisecondsSinceEpoch,
                        //   );
                        //   debugPrint('_AllConnectionsScreenState: status: $status');
                        //   if (status == Constants.CONNECT) {
                        //     newConnect.status = Constants.CONNECTED;
                        //     appUser.updateConnect(newConnect);
                        //   } else if (status == Constants.CONNECTED) {
                        //     newConnect.status = Constants.CONNECT;
                        //     appUser.removeConnect(specificUser.uid);
                        //   } else if (status == Constants.CONNECTION) {
                        //     newConnect.status = Constants.CONNECT_BACK;
                        //     appUser.removeConnect(specificUser.uid);
                        //   } else if (status == Constants.CONNECT_BACK) {
                        //     newConnect.status = Constants.CONNECTION;
                        //     appUser.updateConnect(newConnect);
                        //   }
                        //   _onChangeConnectionStatus(newConnect, specificUser);
                        //   setState(() {});
                        // },
                        );
                  },
                );
              },
              staggeredTileBuilder: (_) => const StaggeredTile.fit(1),
            ),
    );
  }
}
