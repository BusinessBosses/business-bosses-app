import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../common/models/my_user.dart';
import '../../common/widgets/network_image_with_placeholder.dart';
import '../../common/widgets/safety_model.dart';
import '../../common/widgets/search/search_bar.dart';
import '../../utils/theme/theme.dart';
import '../promotions/presentation/promotionscreen.dart';

// ignore: public_member_api_docs
class ReferScreen extends StatelessWidget {
  // ignore: public_member_api_docs
  static const String routeName = '/refer-screen';

  final List<MyUser> _selectedUsers = [];

  MyUser _specificUser = MyUser(
      achievements: '',
      active: true,
      ageRange: '',
      bio: 'bio',
      bossOfTheWeekTimeStamp: 122,
      bossOfTheWeekUpTimeStamp: 3444,
      category: '',
      website: '',
      companyName: '',
      deactivated: false,
      email: 'test@gmail.com',
      gender: '',
      industry: '',
      instagram: '',
      location: '',
      name: 'name',
      photoUrl: 'eee',
      productsandservices: '',
      surname: '',
      timestamp: 2324,
      twitter: '',
      uid: '',
      unReadCount: 3,
      username: 'username');

  final List<MyUser> _searchedList = [];
  late bool isLoading;
  late bool isProcessing;

  @override
  Widget build(BuildContext context) {
    if (_specificUser.connectedCount == 0 &&
        _specificUser.connectionCount == 0) {
      Navigator.push(
        context,
        // ignore: always_specify_types
        MaterialPageRoute(
            builder: (BuildContext context) => const PromotionScreen()),
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
      floatingActionButton: (_selectedUsers?.isEmpty ?? true) && !isProcessing
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
              isLoading: isLoading,
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
              itemBuilder: (BuildContext context, int i) {
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

  _onSearch(String val) {}

  void _onReferringToYourConnections() {}

  _isSelected(MyUser searchedList) {}

  void _addRemoveUser(MyUser searchedList) {}
}
