import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../action/action.dart';
import '../../common/models/my_refers.dart';
import '../../common/models/my_user.dart';
import '../../common/widgets/network_image_with_placeholder.dart';
import '../../common/widgets/safety_model.dart';
import '../../common/widgets/search/search_bar.dart';
import '../../utils/constants/constants.dart';
import '../../utils/theme/theme.dart';
import '../profile/promotionscreen.dart';

class ReferScreen extends StatefulWidget {
  static const routeName = '/refer-screen';

  const ReferScreen({Key? key}) : super(key: key);

  @override
  _ReferScreenState createState() => _ReferScreenState();
}

class _ReferScreenState extends State<ReferScreen> {
  final List<UserModel> _referrableConnections = [];

  UserModel _specificUser = UserModel();

  final List<MyUser> _selectedUsers = [];

  bool _isProcessing = false;
  bool _isLoading = true;

  bool _isInit = false;
  final List<String> _alreadyReferredUsers = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      _specificUser = ModalRoute.of(context)?.settings.arguments as UserModel;

      _fetchMyConnections();

      _isInit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_specificUser.connectedCount == 0 &&
        _specificUser.connectionCount == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PromotionScreen()),
      );
    }
    debugPrint('_AllConnectionsScreenState.build');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        ),
        title: SearchBar(
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
      body: _searchedList?.isEmpty ?? true
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
              itemCount: _searchedList.length,
              itemBuilder: (context, i) {
                return Column(
                  children: [
                    ListTile(
                      onTap: () {
                        _addRemoveUser(_searchedList[i]);
                      },
                      leading: NetworkImageWithPlaceHolder(
                        imageUrl: _searchedList[i].photoUrl,
                        height: 48.0,
                        width: 48.0,
                        cacheHeight: 90,
                        cacheWidth: 90,
                        radius: 30.0,
                        placeHolder: Icons.person,
                      ),
                      title: Text(_searchedList[i].name),
                      subtitle: Text(
                        _searchedList[i].bio,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: _isSelected(_searchedList[i])
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

  void _onReferringToYourConnections() {
    unFocusKeyboard(context);
    setState(() {
      _isProcessing = true;
    });
  }

  Future<void> _sendNotificationToReferTo(
      List<String> tokens, List<String> receivers) async {}

  Future<void> _sendNotificationToMainUser(
      List<String> tokens, List<String> receivers) async {}

  Future<void> _createMyReferrals(List<String> referToUsers) async {
    String path =
        Constants.USERS + '/' + _specificUser.uid + '/' + Constants.REFERS;
  }

  void _addRemoveUser(MyUser user) {
    int index = _selectedUsers.indexWhere((u) => u.uid == user.uid);
    if (index == -1) {
      setState(() {
        _selectedUsers.add(user);
      });
    } else {
      setState(() {
        _selectedUsers.removeAt(index);
      });
    }
  }

  bool _isSelected(MyUser user) {
    int index = _selectedUsers.indexWhere((u) => u.uid == user.uid);
    if (index == -1) {
      return false;
    } else {
      return true;
    }
  }
}
