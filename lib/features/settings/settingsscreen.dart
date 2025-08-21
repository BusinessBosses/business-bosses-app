// ignore_for_file: public_member_api_docs, library_private_types_in_public_api, always_specify_types, deprecated_member_use

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:business_bosses_v2/action/action.dart';
import 'package:business_bosses_v2/common/widgets/buttons/my_outlined_button.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/features/settings/settingsItemModal.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:url_launcher/url_launcher_string.dart';
import 'package:yaml/yaml.dart';

import '../../common/dialogs/snackbar.dart';
import '../../common/models/api_response_model.dart';
import '../../navigation/routes.dart';
import '../../services/api_service.dart';
import '../../services/revenuecat_service.dart';
import '../posts/widgets/settings_item.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

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
      if (res.data['isUrl']) {
        if (await canLaunchUrlString(res.data['url'])) {
          await launchUrlString(res.data, mode: LaunchMode.externalApplication);
        }
      } else if (res.data['isUrl'] == false) {
        showSnackbar(
            title: 'OOPS!', message: res.data['message'], error: false);
      }
    } else {
      showSnackbar(
          title: 'OOPS!',
          message: 'An error occurred, please try again!',
          error: true);
    }
    // setState(() {
    //   _isProcessing = false;
    // });
  }

  void getCustomerInfo() async {
    try {
      CustomerInfo purchaserInfo = await Purchases.getCustomerInfo();
      String managementURL = purchaserInfo.managementURL!;
      await launch(managementURL);
    } catch (e) {
      showSnackbar(
          title: 'OOPS!',
          message: 'An error occurred, please try again!',
          error: true);
    }
  }

  String version = '';

  @override
  void initState() {
    getVersionNumber();
    super.initState();
  }

  void _shareWithFriends() {
    // ignore: unnecessary_null_comparison
    if (profileController.myProfile.inviteId == null) return;
    String message = 'Check out Business Bosses.\n'
        'An app to meet entrepreneurs and grow your business. Join now for FREE promotion\n'
        'https://businessbosses.onelink.me/xLWk/36a2ff16\n'
        'Invite id: $profileController.myProfile.inviteId';
    logEvent(profileController.myProfile.inviteId, 'invite');
    socialShare(message);
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
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(bottom: 30),
                decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Invite friends to get 10 coins',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 16),
                        ),
                        Text(
                          'Invite ID : ${profileController.myProfile.inviteId!}',
                          style: const TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        _shareWithFriends();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        width: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border:
                              Border.all(width: 2, color: Colors.transparent),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text(
                              'Invite',
                              style: TextStyle(
                                  color: primaryColorLT,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16),
                            ),
                            SvgPicture.asset(
                              'assets/svgs/invite.svg',
                              color: primaryColorLT,
                              height: 13,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
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
            profileController.myProfile.isSubscribed && Platform.isAndroid
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
                            'Renew Pro Subscription',
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
                                                color: primaryColorLT,
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
                                              Platform.isAndroid
                                                  ? cancelSubscription(
                                                      profileController
                                                          .myProfile.uid)
                                                  : getCustomerInfo();
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
                                                : const Text(
                                                    'Cancel Subscription',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
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
            ),
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
    }
    // else if ('Contact us' == label) {
    //   _contactUs();
    // }
    else if ('Delete Account' == label) {
      Get.toNamed(Routes.deleteAccount);
    }
  }

  // Future<void> _contactUs() async {
  //   String? encodeQueryParameters(Map<String, String> params) {
  //     return params.entries
  //         .map((MapEntry<String, String> e) =>
  //             '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
  //         .join('&');
  //   }

  //   final Uri mailUrl = Uri(
  //     scheme: 'mailto',
  //     path: 'support@businessbosses.co.uk',
  //     query: encodeQueryParameters(<String, String>{
  //       'subject': 'Contact Business Bosses',
  //     }),
  //   );

  //   try {
  //     if (await canLaunchUrl(mailUrl)) {
  //       await launchUrl(mailUrl);
  //     } else {
  //       throw 'Could not launch $mailUrl';
  //     }
  //   } catch (e) {
  //     showSnackbar(
  //         title: 'OOPS!',
  //         message: 'An error occurred, please try again!',
  //         error: true);
  //   }
  // }

  static List<MySettingsItem> item = [
    MySettingsItem(
      isTitle: false,
      label: 'Community Rules',
    ),
    MySettingsItem(
      isTitle: false,
      label: 'Invite a friend terms & conditions',
    ),
    // MySettingsItem(
    //   isTitle: false,
    //   label: 'Contact us',
    // ),
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
    // Show loading dialog
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible:
          false, // Prevent dialog from closing when tapping outside
    );

    try {
      // Await logout response
      await _apiService.logout();
      await RevenueCatService.logout();
    } catch (error) {
      // Handle error if needed
      // Optionally, show an error message here
    } finally {
      // Remove the loading dialog if it's still open
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
    }
  }

  Future<void> getVersionNumber() async {
    final String pubspecString = await rootBundle.loadString('pubspec.yaml');
    final Map yamlData = jsonDecode(jsonEncode(loadYaml(pubspecString)));
    version = yamlData['version'].toString().split('+')[0];
    setState(() {});
  }
}
