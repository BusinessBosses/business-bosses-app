import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../common/models/my_user.dart';
import '../../../common/widgets/safety_model.dart';
import '../../../utils/theme/theme.dart';

class RelevantUsersScreen extends StatelessWidget {
  final bool _isInit = false;
  final bool _isLoading = true;
  late MyUser _user;
  final List<UserModel> _relevantUsers = [];

  RelevantUsersScreen({super.key});
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
              itemBuilder: (BuildContext context, int index) {
                UserModel specificUser = _relevantUsers[index];
                return Container();
              },
              staggeredTileBuilder: (_) => const StaggeredTile.fit(1),
            ),
    );
  }

  Widget _safetyModal(MyUser user) {
    if ((user.category.isEmpty ?? true) && (user.industry.isEmpty ?? true)) {
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
