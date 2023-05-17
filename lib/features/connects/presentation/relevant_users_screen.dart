import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../common/models/my_connect.dart';
import '../../../common/models/my_user.dart';
import '../../../common/widgets/safety_model.dart';
import '../../../utils/constants/constants.dart';
import '../../../utils/theme/theme.dart';
import '../widgets/connection_grid_tile.dart';

class RelevantUsersScreen extends StatelessWidget {
  bool _isInit = false;
  bool _isLoading = true;
  late MyUser _user;
  List<UserModel> _relevantUsers = [];
  Future<void> _loadRelevantUsers() async {}

  void _sendNotification(UserModel user) {
    if (user.deviceTokens == null) return;
  }

  static const String routeName = '/relevant-users-screen';

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
                UserModel specificUser = _relevantUsers[index];
                return Consumer<UserController>(
                  builder: (_, userCtrl, __) {
                    bool isConnected = userCtrl.isConnected(specificUser.uid);
                    return ConnectionGridTile(
                        user: specificUser,
                        status: userCtrl.isConnected(specificUser.uid),
                        onChangeConnectionStatus: () async {
                          String connectId = MyConnect.connectId(
                              userCtrl.user.uid, specificUser.uid);
                          String puCountPath =
                              '${Constants.USERS}/${specificUser.uid}/connectionCount';
                          String myCountPath =
                              '${Constants.USERS}//connectedCount';
                          Map<String, dynamic> map = {};
                          if (isConnected) {
                            userCtrl.removeConnect(specificUser.uid);
                            if (specificUser.connectionCount! > 0) {
                              specificUser?.connectionCount =
                                  (specificUser?.connectionCount ?? 0) - 1;
                            }

                            map[puCountPath] = specificUser.connectionCount;
                            map[myCountPath] = userCtrl.user.connectedCount;
                            map['${Constants.CONNECTIONS}/$connectId'] = null;
                          } else {
                            // MyConnect newConnect = MyConnect(
                            //   id: connectId,
                            //   connectedTo: specificUser.uid,
                            //   connectedBy: _firebase.uid,
                            //   timestamp: DateTime.now().millisecondsSinceEpoch,
                            // );
                            // userCtrl.updateConnect(newConnect);
                            // map[Constants.CONNECTIONS + '/' + connectId] =
                            //     newConnect.toMap();
                            // _sendNotification(specificUser);
                            // specificUser.connectionCount++;
                            // setState(() {});
                            // debugPrint(
                            //     'asdfasdf ${specificUser.connectionCount}');
                            // map[puCountPath] = specificUser.connectionCount;
                            // map[myCountPath] = userCtrl.user.connectedCount;
                          }

                          // await _firebase.updateWithBatch(map);
                        });
                  },
                );
              },
              staggeredTileBuilder: (_) => const StaggeredTile.fit(1),
            ),
    );
  }

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
        subTitle: 'You don\'t have a category or an industry yet',
        clickableText: 'Complete profile',
        onTap: () async {
          // await navigateTo(context,
          //     routeName: UpdateProfileScreen.routeName, arguments: true);
          // _user = Provider.of<UserController>(context, listen: false).user;
          // setState(() {});
          // _loadRelevantUsers();
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
      title: 'You have no matched users for now',
      subTitle: 'All relevant users will be displayed here!',
    );
  }
}
