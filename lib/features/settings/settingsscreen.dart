import 'dart:convert';

import 'package:business_bosses_v2/features/settings/settingsItemModal.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:yaml/yaml.dart';

import '../../action/action.dart';
import '../../navigation/routes.dart';
import '../../services/api_service.dart';
import '../../utils/constants/constants.dart';
import '../posts/widgets/settings_item.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ApiService _apiService = ApiService();

  String version = '';

  @override
  void initState() {
    getVersionNumber();
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
              itemBuilder: (BuildContext context, int i) => SettingsItem(
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
              'Version ($version)',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }

  void _onTab(String label) {
    if ('Edit Profile' == label) {
    } else if ('Change password' == label) {
      Get.toNamed(Routes.changePassword);
    } else if (label == 'Community Rules') {
      Get.toNamed(Routes.communityrulesscreen, arguments: 'community rules');
    } else if (label == 'Invite a friend terms & conditions') {
      Get.toNamed(Routes.inviteafriendscreen,
          arguments: 'Invite a friend text');
    } else if ('Contact us' == label) {
      _contactUs();
    } else if ('Delete Account' == label) {
      Get.toNamed(Routes.deleteAccount);
    }
  }

  Future<void> _contactUs() async {
    print('pressed');
    String mailUrl = 'mailto:support@businessbosses.co.uk';
    try {
      if (await canLaunch(mailUrl)) {
        await launch(mailUrl);
      } else {
        throw 'Could not launch $mailUrl';
      }
    } catch (e) {
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
      routeName: Routes.changePassword,
    ),
    MySettingsItem(
      isTitle: false,
      label: 'Delete Account',
      routeName: Routes.deleteAccount,
    ),
  ];

  void logout() async {
    await _apiService.logout();
  }

  Future<void> getVersionNumber() async {
    final String pubspecString = await rootBundle.loadString('pubspec.yaml');
    final Map yamlData = jsonDecode(jsonEncode(loadYaml(pubspecString)));
    version = yamlData['version'].toString().split('+')[0];
    setState(() {});
  }
}
