import 'dart:convert';

import 'package:business_bosses_v2/common/widgets/buttons/my_outlined_button.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/features/settings/settingsItemModal.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:url_launcher/url_launcher_string.dart';
import 'package:yaml/yaml.dart';

import '../../action/action.dart';
import '../../common/models/api_response_model.dart';
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
  ProfileController profileController = Get.find();
  bool _isProcessing = false;

  Future<void> cancelSubscription(String userId) async {
    // setState(() {
    //   _isProcessing = true;
    // });
    final ApiResponseModel res = await ApiService.get(
      path: 'subscription/cancel/$userId',
    );

    if (res.success) {
      if (await canLaunchUrlString(res.data)) {
        await launchUrlString(res.data, mode: LaunchMode.externalApplication);
      }
    } else {
      showSnackBar(context, message: res.message);
    }
    // setState(() {
    //   _isProcessing = false;
    // });
  }

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
            profileController.myProfile.isSubscribed
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: InkWell(
                      onTap: () async {
                        await cancelSubscription(
                            profileController.myProfile.uid);
                      },
                      borderRadius: BorderRadius.circular(radiusValue),
                      child: Ink(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(radiusValue),
                        ),
                        child: ListTile(
                          title: Text(
                            'Renew Premium Subscription',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
            const SizedBox(height: 10.0),
            profileController.myProfile.isSubscribed
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(builder:
                                  (BuildContext context, StateSetter setState) {
                                return Container(
                                  height: 700,
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Are you sure?',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                  fontSize:
                                                      20, // Set your desired font size
                                                ),
                                          ),
                                          const Spacer(),
                                          GestureDetector(
                                            onTap: () {
                                              Get.back();
                                            },
                                            child: SvgPicture.asset(
                                                'assets/svgs/close.svg'),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      const Text(
                                        'By unsubscribing, you will lose access to the following features:',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 16),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 30),
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                'assets/svgs/goldcheckmark.svg',
                                                height: 25,
                                              ),
                                              const SizedBox(width: 15),
                                              const Expanded(
                                                child: Text(
                                                  'Your profile will no longer display the Premium Badge',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                  'assets/svgs/coin.svg',
                                                  height: 30),
                                              const SizedBox(width: 15),
                                              const Expanded(
                                                child: Text(
                                                  'You will no longer receive 500 coins every month.',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                  'assets/svgs/rocket.svg',
                                                  height: 25),
                                              const SizedBox(width: 15),
                                              const Expanded(
                                                child: Text(
                                                  'You won\'t be able to boost your posts for free using coins.',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 15),
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                  'assets/svgs/moreconnections.svg',
                                                  height: 20),
                                              const SizedBox(width: 15),
                                              const Expanded(
                                                child: Text(
                                                  'Your connections and referrals may be limited compared to Premium members.',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 15),
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                  'assets/svgs/rankingicon.svg',
                                                  height: 23),
                                              const SizedBox(width: 15),
                                              const Expanded(
                                                child: Text(
                                                  'Your posts and listings may not rank as high as they did.',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        children: [
                                          ElevatedButton(
                                            onPressed: () async {
                                              setState(() {
                                                _isProcessing = true;
                                              });
                                              await cancelSubscription(
                                                  profileController
                                                      .myProfile.uid);
                                              setState(() {
                                                _isProcessing = false;
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              fixedSize: const Size(
                                                  double.infinity,
                                                  40), // Set the desired height (e.g., 50 pixels)
                                            ),
                                            child: _isProcessing
                                                ? const SizedBox(
                                                    width: 24.0,
                                                    height: 24.0,
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                : const Text('Cancel Subscription'),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          MCustomButton(
                                            buttonType: ButtonType.outlinegrey,
                                            onPressed: () {
                                              Get.back();
                                            },
                                            height: 40,
                                            width: 80,
                                            child: const Text(
                                              'Keep',
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              });
                            });
                      },
                      borderRadius: BorderRadius.circular(radiusValue),
                      child: Ink(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(radiusValue),
                        ),
                        child: ListTile(
                          title: Text(
                            'Cancel Subscription',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
            const SizedBox(height: 10.0),
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
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri mailUrl = Uri(
      scheme: 'mailto',
      path: 'support@businessbosses.co.uk',
      query: encodeQueryParameters(<String, String>{
        'subject': 'Contact Business Bosses',
      }),
    );

    try {
      if (await canLaunchUrl(mailUrl)) {
        await launchUrl(mailUrl);
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
