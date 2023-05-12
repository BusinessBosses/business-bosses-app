import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../action/action.dart';
import '../../common/models/my_connect.dart';
import '../../common/params.dart';
import '../../common/widgets/safety_model.dart';
import '../../utils/constants/constants.dart';
import '../../utils/theme/theme.dart';
import '../profile/update_profile_screen.dart';
import 'connection_grid_tile.dart';

class RelevantUsersScreen extends StatefulWidget {
  static const routeName = '/relevant-users-screen';

  const RelevantUsersScreen({Key? key}) : super(key: key);

  @override
  _RelevantUsersScreenState createState() => _RelevantUsersScreenState();
}

class _RelevantUsersScreenState extends State<RelevantUsersScreen> {
  bool _isInit = false;
  UserModel? _user;
  List<UserModel> _relevantUsers = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      _isInit = true;
      final Params data = ModalRoute.of(context)?.settings.arguments as Params;
      if (data?.arg1 != null) {
        _user = data.arg1;
      } else {
        navigateTo(context);
        return;
      }
      _loadRelevantUsers();
    }
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
        body: Container());
  }

  Future<void> _loadRelevantUsers() async {}

  void _sendNotification(UserModel user) {
    if (user.deviceTokens == null) return;
  }
}
