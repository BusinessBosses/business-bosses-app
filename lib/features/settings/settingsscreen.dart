import 'package:business_bosses_v2/features/settings/settingsItemModal.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../action/action.dart';
import '../../functions/my_native_functions.dart';
import '../../navigation/routes.dart';
import '../../services/api_service.dart';
import '../../utils/constants/constants.dart';
import '../posts/presentation/widgets/settings_item.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ApiService _apiService = ApiService();

  String version = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context = context;
    return Scaffold(
      backgroundColor: backgroundcolorinterface,
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        ),
        centerTitle: true,
        title: const Text(
          'Settings',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              primary: false,
              padding: const EdgeInsets.all(16.0),
              itemCount: item.length,
              itemBuilder: (context, i) => SettingsItem(
                isTitle: item[i].isTitle,
                label: item[i].label,
                hasSwitch: item[i].hasSwitch,
                switchValue: item[i].switchValue,
                onTap: _onTab,
              ),
            ),
            const SizedBox(height: 24.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: InkWell(
                onTap: () {
                  logout();
                  Get.toNamed(Routes.login);
                },
                borderRadius: BorderRadius.circular(radiusValue),
                child: Ink(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(radiusValue),
                  ),
                  child: ListTile(
                    title: Text(
                      'Sign Out',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            Image.asset('assets/app/app_logo.png', height: 120.0, width: 120.0),
            Text(
              version,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontSize: 16, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }

  void _onTab(String label) {
    if ('Edit Profile' == label) {
    } else if ('Change password' == label) {
    } else if (label == 'Community Rules') {
    } else if (label == 'Invite a friend terms & conditions') {
    } else if ('Contact us' == label) {
      _contactUs();
    } else if ('Delete Account' == label) {}
  }

  Future<void> _contactUs() async {
    String mailUrl = 'mailto:support@businessbosses.co.uk';
    try {
      MyNativeFunctions.onUrlLaunch(mailUrl);
    } catch (e) {
      debugPrint('Something gone wrong try again later');
      showSnackBar(context, message: '${Constants.STGW}, try again later');
    }
  }

  static List<MySettingsItem> item = [
    MySettingsItem(
      isTitle: false,
      label: 'Community Rules',
    ),
    MySettingsItem(
      isTitle: false,
      label: 'Invite a friend terms & conditions',
    ),
    MySettingsItem(
      isTitle: false,
      label: 'Contact us',
    ),
    MySettingsItem(
      isTitle: false,
      label: 'Change password',
      routeName: 'ChangePasswordScreen.routeName',
    ),
    MySettingsItem(
      isTitle: false,
      label: 'Delete Account',
      routeName: 'ChangePasswordScreen.routeName',
    ),
  ];

  void logout() async {
    await _apiService.logout();
  }
}
