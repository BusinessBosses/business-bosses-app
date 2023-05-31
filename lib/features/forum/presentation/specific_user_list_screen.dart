import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../action/action.dart';
import '../../../common/models/user_model.dart';
import '../../../common/params.dart';
import '../../../common/widgets/safety_model.dart';
import '../../../common/widgets/user_avatar_with_badge.dart';
import '../../../utils/theme/theme.dart';
import '../../profile/presentation/publicprofilescreen.dart';

class SpecificUserListScreen extends StatefulWidget {
  static const routeName = '/specificuserlistScreen';

  const SpecificUserListScreen({Key? key}) : super(key: key);

  @override
  _SpecificUserListScreenState createState() => _SpecificUserListScreenState();
}

class _SpecificUserListScreenState extends State<SpecificUserListScreen> {
  final ScrollController _controller = ScrollController();

  final List<UserModel> _users = [];
  late ParamData _prarams;
  List<String> _userUids = [];

  bool _isLoading = true;
  bool _isLoadingNext = false;
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      _controller.addListener(_scrollListener);
      _prarams = ModalRoute.of(context)!.settings.arguments as ParamData;
      if (_prarams == null) {
        navigateTo(context);
        return;
      } else {
        // _userUids = _prarams.data;
        // _loadNextConnections();
      }
      _isInit = true;
    }
  }

  _scrollListener() {
    // if (_controller.position.atEdge) {
    //   if (_controller.position.pixels == 0) {
    //   } else {
    //     _loadNextConnections();
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        ),
        centerTitle: true,
        title: Text(
          // _prarams.title ??
          'Members',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20),
        ),
      ),
      body: _users.isEmpty
          ? SafetyModel(
              isLoading: _isLoading,
              icon: const Icon(
                Icons.person,
                size: 80.0,
                color: hintColor,
              ),
              title: 'There is no ${_prarams?.title ?? 'user'}',
              // subTitle: 'Be the first one to like!',
            )
          : Stack(
              children: [
                ListView.builder(
                  padding: const EdgeInsets.only(bottom: 48.0),
                  controller: _controller,
                  itemCount: _users.length,
                  itemBuilder: (context, i) {
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
                              Navigator.of(context).pop();
                            }
                          },
                          leading: UserAvatarWithBadge(
                            user: _users[i],
                            height: 48.0,
                            width: 48.0,
                            radius: 30.0,
                            placeHolder: Icons.person,
                          ),
                          // NetworkImageWithPlaceHolder(
                          //   imageUrl: _users[i].photoUrl,
                          //   height: 48.0,
                          //   width: 48.0,
                          //   radius: 30.0,
                          //   placeHolder: Icons.person,
                          // ),
                          title: Text(_users[i].name!),
                          subtitle: Text(
                            _users[i].bio!,
                            maxLines: 1,
                          ),
                        ),
                        const Divider(height: 0.0, indent: 0.0, endIndent: 0.0),
                      ],
                    );
                  },
                ),
                // if (_isLoadingNext)
                //   Positioned(
                //     child: SafetyModel(isLoading: true),
                //     bottom: 10.0,
                //     right: 0.0,
                //     left: 0.0,
                //   ),
              ],
            ),
    );
  }

  Future<void> _loadNextConnections() async {
    if (_userUids.isEmpty) {
      setState(() {
        _isLoading = false;
      });
    }

    int l = _users.length;
    if (l >= _userUids.length || _isLoadingNext) return;
    final List<UserModel> newUsers = [];
    setState(() {
      _isLoadingNext = true;
    });

    // await FirebaseDatabase.instance
    //     .reference()
    //     .child(Constants.USERS)
    //     .once()
    //     .then((value) {
    //   if (value.value != null) {
    //     List keys = value.value.keys.toList();
    //     for (int i = 0; i < keys.length; i++) {
    //       if (_userUids.contains(keys[i])) {
    //         MyUser myUser = MyUser();
    //         myUser = MyUser.fromMap(value.value[keys[i]]);
    //         if (myUser.hasCompleteData() && myUser.active != false) {
    //           newUsers.add(myUser);
    //         }
    //       }
    //     }
    //     setState(() {
    //       _users.addAll(newUsers as Iterable<UserModel>);
    //       _isLoading = false;
    //     });
    //   } else {
    //     setState(() {
    //       _isLoading = false;
    //     });
    //   }
    // }).onError((error, stackTrace) {
    //   setState(() {
    //     _isLoading = false;
    //   });
    // });

    // for (int i = l; i < min(_userUids.length, _loadedItems); i++) {
    //   debugPrint('Running loop');
    //   MyResponse res =
    //   await _firebase.fetchANode(path: Constants.USERS, id: _userUids[i]);
    //   if (res.success) {
    //    MyUser us= MyUser.fromSnapshot(res.data);
    //     if(us.uid!=null){
    //       newUsers.add(us);
    //       _users.add(us);
    //     }
    //     setState((){
    //       _isLoadingNext = false;
    //     });
    //   }
    // }
  }
}

class ParamData {
  String title;
  dynamic data;

  ParamData(
    this.title,
    this.data,
  );
}
