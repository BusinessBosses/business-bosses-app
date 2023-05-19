import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/models/user_model.dart';
import '../../../common/widgets/buttons/my_outlined_button.dart';
import '../../../utils/theme/theme.dart';

Widget OutlineButtonHeader(
    UserModel _publicUser, UserModel myProfile, VoidCallback onConnect) {
  bool connectedbutton = true;
  // final UserModel _publicUser = UserModel(
  //     achievements: 'jnkknmmk+llllmlhj+jkhkh'.split('+'),
  //     active: true,
  //     ageRange: '10',
  //     bio: 'sdxsdddddfff',
  //     category: 'wee',
  //     companyName: 'ee',
  //     website: 'ee',
  //     username: '2mrt',
  //     deactivated: false,
  //     email: 'DFFG',
  //     gender: 'GGG',
  //     industry: 'FF',
  //     instagram: 'GGG',
  //     location: 'DGG',
  //     name: 'GGG',
  //     photoUrl: '',
  //     productsandservices: 'sdffgg+s+ksf'.split('+'),
  //     surname: 'kkk',
  //     timestamp: 100394,
  //     twitter: '',
  //     uid: '',
  //     unReadCount: 12,
  //     bossOfTheWeekUpTimeStamp: 3455,
  //     bossOfTheWeekTimeStamp: 677);

  return Container(
    height: 50.0,
    padding: const EdgeInsets.all(4.0),
    width: double.infinity,
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Expanded(
          // child: Consumer<UserController>(
          //   builder: (_, userCtrl, __) {
          //     bool isConnected = userCtrl.isConnected(_publicUser.uid);
          child: MCustomButton(
              buttonType: connectedbutton == true
                  ? ButtonType.outline
                  : ButtonType.elevated,
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: FittedBox(
                child: myProfile.connecteds != null &&
                        myProfile.connecteds!.contains(_publicUser.uid)
                    ? const Text(
                        'Connected',
                        style: TextStyle(color: primaryColorLT),
                      )
                    : const Text(
                        'Connect',
                        style: TextStyle(color: primaryColorLT),
                      ),
              ),
              onPressed: () async {
                onConnect();
                //   String connectId =
                //       MyConnect.connectId(userCtrl.user.uid, _publicUser.uid);
                //   String puCountPath = Constants.USERS +
                //       '/' +
                //       _publicUser.uid +
                //       '/' +
                //       'connectionCount';
                //   String myCountPath = Constants.USERS +
                //       '/' +
                //       _profileController.myProfile.uid +
                //       '/' +
                //       'connectedCount';
                //   Map<String, dynamic> map = {};
                //   if (isConnected) {
                //     userCtrl.removeConnect(_publicUser.uid);
                //     if (_publicUser.connectionCount > 0) {
                //       _publicUser.connectionCount--;
                //     }
                //     setState(() {});

                //     map[puCountPath] = _publicUser.connectionCount;
                //     map[myCountPath] = userCtrl.user.connectedCount;
                //     map[Constants.CONNECTIONS + '/' + connectId] = null;
                //   } else {
                //     MyConnect newConnect = MyConnect(
                //       id: connectId,
                //       connectedTo: _publicUser.uid,
                //       connectedBy: _profileController.myProfile.uid,
                //       timestamp: DateTime.now().millisecondsSinceEpoch,
                //     );
                //     userCtrl.updateConnect(newConnect);
                //     map[Constants.CONNECTIONS + '/' + connectId] =
                //         newConnect.toMap();
                //     _sendNotification(_publicUser);
                //     _publicUser.connectionCount++;
                //     setState(() {});
                //     debugPrint('asdfasdf ${_publicUser.connectionCount}');

                //     map[puCountPath] = _publicUser.connectionCount;
                //     map[myCountPath] = userCtrl.user.connectedCount;
                //   }
                //   debugPrint(
                //       '_PublicProfileScreenState.OutlineButtonHeader: map $map');
                //   // if(){
                //   // await _firebase.updateDisconnected(
                //   //     isConnected, _publicUser.uid, userCtrl.user);
                //   // // }
                //   // await _firebase.updateWithBatch(map);
                // },
              })),
      Expanded(
        child: MCustomButton(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          onPressed: () {
            Get.toNamed(Routes.chatRoom, arguments: _publicUser);
          }
          // => navigateTo(
          //   context,
          //   routeName: ChatRoomScreen.routeName,
          //   arguments: _publicUser,
          // ),
          ,
          child: const Text('Message'),
        ),
      ),
      Expanded(
        child: MCustomButton(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            onPressed: () async {
              // final fUser =
              //     Provider.of<UserController>(context, listen: false);
              // if (fUser.user.connectedCount == 0 &&
              //     fUser.user.connectionCount == 0) {
              String message =
                  'Have a look at ${_publicUser.username ?? 'Business Bosses'} on Business Bosses\n'
                  'https://businessbosses.onelink.me/xLWk/36a2ff16';
              _sharePost(message);
              // }
            },
            child: const Text('Refer')
            // _loadUser(Params(arg1: _publicUser.uid));

            ),
      ),
      // child: ,
    ]),
  );
}

class _sharePost {
  _sharePost(String message);
}
