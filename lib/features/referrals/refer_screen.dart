import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../action/action.dart';
import '../../common/models/my_user.dart';
import '../../common/widgets/network_image_with_placeholder.dart';
import '../../common/widgets/safety_model.dart';
import '../../common/widgets/search/search_bar.dart' as searchBar;
import '../../utils/constants/constants.dart';
import '../../utils/theme/theme.dart';
import '../promotions/presentation/promotionscreen.dart';

class ReferScreen extends StatefulWidget {
  static const routeName = '/refer-screen';

  const ReferScreen({Key? key}) : super(key: key);

  @override
  _ReferScreenState createState() => _ReferScreenState();
}

class _ReferScreenState extends State<ReferScreen> {
  final List<UserModel> _referrableConnections = [];
  final ProfileController _profileController = Get.find();
  late UserModel _specificUser;

  final List<String> _selectedUsers = [];

  bool _isProcessing = false;
  bool _isLoading = false;

  bool _isInit = false;
  final List<String> _alreadyReferredUsers = [];

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   if (!_isInit) {
  //     _specificUser = ModalRoute.of(context)?.settings.arguments as UserModel;

  //     _fetchMyConnections();

  //     _isInit = true;
  //   }
  // }

  Future<void> getData() async {
    setState(() {
      _isLoading = true;
    });
    final res = await ApiService.get(
        path: '/connection/connecteds/${_profileController.myProfile.uid}');

    for (var i = 0; i < res.data.length; i++) {
      final mapData = res.data[i];
      final modelizedConnection = UserModel.fromMap(mapData);
      // print(_specificUser.connections);
      // _referrableConnections.add(modelizedConnection);
      if (_specificUser.connections == null) {
        if (_specificUser.uid != modelizedConnection.uid) {
          _referrableConnections.add(modelizedConnection);
        }
      } else {
        if (!_specificUser.connections!.contains(modelizedConnection.uid) &&
            _specificUser.uid != modelizedConnection.uid) {
          _referrableConnections.add(modelizedConnection);
        }
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Get.arguments == null) {
      Get.back();
    } else {
      _specificUser = Get.arguments['user'];
      getData();
    }
  }

  @override
  Widget build(BuildContext context) {
    // if (_specificUser.connectedCount == 0 &&
    //     _specificUser.connectionCount == 0) {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => const PromotionScreen()),
    //   );
    // }
    // debugPrint('_AllConnectionsScreenState.build');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        ),
        title: searchBar.SearchBar(
          onChange: _onSearch,
          hasSearchIcon: false,
          autofocus: false,
        ),
      ),
      floatingActionButton: (_selectedUsers?.isEmpty ?? true) && !_isProcessing
          ? null
          : FloatingActionButton.extended(
              onPressed: _onReferringToYourConnections,
              icon: const Icon(Icons.check),
              label: Text(
                'Refer (${_selectedUsers.length})',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
      body: _referrableConnections.isEmpty
          ? SafetyModel(
              isLoading: _isLoading,
              icon: const Icon(
                Icons.person,
                size: 80.0,
                color: hintColor,
              ),
              title: 'No user available to refer!',
              subTitle:
                  'You\'ve no connections to refer @${_specificUser.username}',
            )
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 80.0),
              // controller: _controller,
              itemCount: _referrableConnections.length,
              itemBuilder: (context, i) {
                return Column(
                  children: [
                    ListTile(
                      onTap: () {
                        _addRemoveUser(_referrableConnections[i].uid);
                      },
                      leading: NetworkImageWithPlaceHolder(
                        imageUrl: _referrableConnections[i].photoUrl,
                        height: 48.0,
                        width: 48.0,
                        cacheHeight: 90,
                        cacheWidth: 90,
                        radius: 30.0,
                        placeHolder: Icons.person,
                      ),
                      title: Text(_referrableConnections[i].username),
                      subtitle: Text(
                        _referrableConnections[i].bio ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: _isSelected(_referrableConnections[i].uid)
                          ? const Icon(
                              Icons.check_box,
                              color: primaryColorLT,
                            )
                          : const Icon(Icons.check_box_outline_blank),
                    ),
                    const Divider(height: 0.0, indent: 16.0, endIndent: 16.0),
                  ],
                );
              },
            ),
    );
  }

  Future<void> _fetchMyConnections() async {}

  List<MyUser> _searchedList = [];

  void _onSearch(String val) {}

  void _onReferringToYourConnections() async {
    unFocusKeyboard(context);

    final res = await ApiService.post(path: '/referal/refer', body: {
      'referredUserUid': _specificUser.uid,
      'referBy': _profileController.myProfile.uid,
      'referTo': _selectedUsers
    });
    Get.arguments['onRefer'](_selectedUsers.length);
    Get.back();
    // setState(() {
    //   _isProcessing = true;
    // });
  }

  Future<void> _sendNotificationToReferTo(
      List<String> tokens, List<String> receivers) async {}

  Future<void> _sendNotificationToMainUser(
      List<String> tokens, List<String> receivers) async {}

  Future<void> _createMyReferrals(List<String> referToUsers) async {
    String path =
        Constants.USERS + '/' + _specificUser.uid + '/' + Constants.REFERS;
  }

  void _addRemoveUser(String uid) {
    int index = _selectedUsers.indexWhere((u) => u == uid);
    if (index == -1) {
      setState(() {
        _selectedUsers.add(uid);
      });
    } else {
      setState(() {
        _selectedUsers.removeAt(index);
      });
    }
  }

  bool _isSelected(String uid) {
    int index = _selectedUsers.indexWhere((u) => u == uid);
    if (index == -1) {
      return false;
    } else {
      return true;
    }
  }
}
