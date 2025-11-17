import 'dart:core';

import 'package:business_bosses_v2/analytics/presentation/howtouseapp.dart';
import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/aipromote/ai_promote_sheet.dart';
import 'package:business_bosses_v2/features/chat/ai_chat.dart';
import 'package:business_bosses_v2/features/invitepage/invitepage.dart';
import 'package:business_bosses_v2/features/settings/settingsscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/params.dart';
import '../../features/profile/controller/profile_controller.dart';
import '../../navigation/routes.dart';
import '../../utils/theme/theme.dart';

class AnalyserScreen extends StatefulWidget {
  static const String routeName = '/analyser-screen';

  const AnalyserScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AnalyserScreenState createState() => _AnalyserScreenState();
}

class _AnalyserScreenState extends State<AnalyserScreen> {
  bool _isInit = false;
  final ProfileController profileController = Get.find();
  ShopController shopController = Get.find();

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  // void _shareWithFriends() {
  //   // ignore: unnecessary_null_comparison
  //   if (profileController.myProfile.inviteId == null) return;
  //   String message = 'Check out Business Bosses.\n'
  //       'An app to meet entrepreneurs and grow your business. Join now for FREE promotion\n'
  //       'https://businessbosses.onelink.me/xLWk/36a2ff16\n'
  //       'Invite id: $profileController.myProfile.inviteId';
  //   logEvent(profileController.myProfile.inviteId, 'invite');
  //   socialShare(message);
  // }

  @override
  Widget build(BuildContext context) {
    void showPromoteSheet() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) => AIPromoteSheet(),
      );
    }

    UserModel user = UserModel();
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
        title: const Text(
          'Help',
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Get.to(SettingsScreen());
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 15.0, bottom: 5),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: backgroundColor,
                child: Icon(
                  LucideIcons.settings,
                  size: 20,
                  color: textColor,
                ),
              ),
            ),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            width: double.infinity,
            height: 10,
            child: ColoredBox(color: backgroundcolorinterface),
          ),
          const SizedBox(
            height: 35,
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            const Text(
                              'Hi',
                              style: TextStyle(
                                  fontSize: 25,
                                  color: textColor,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        Text(
                          '@${profileController.myProfile.username}',
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: primaryColorLT),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(15),
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
                                      'Invite friends to increase rank',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16),
                                    ),
                                    Text(
                                      'Invite ID : ${profileController.myProfile.inviteId!}',
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w700),
                                    )
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.to(Invitepage());
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          width: 2, color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        const Text(
                                          'Invite',
                                          style: TextStyle(
                                              color: primaryColorLT,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16),
                                        ),
                                        SizedBox(width: 5),
                                        SvgPicture.asset(
                                          'assets/svgs/invite.svg',
                                          colorFilter: const ColorFilter.mode(
                                              primaryColorLT, BlendMode.srcIn),
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
                      ]),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          const SizedBox(
            width: double.infinity,
            height: 1.5,
            child: ColoredBox(color: backgroundcolorinterface),
          ),
          ListTile(
              leading: SvgPicture.asset('assets/svgs/analyze.svg'),
              title: const Text(
                'Analyse Profile',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: textColor),
              ),
              onTap: () {
                String uid = profileController.myProfile.uid;
                Params params = Params(arg1: uid);
                Get.toNamed(Routes.profileanalysescreen,
                    arguments: Params(arg1: params));
              },
              trailing: SvgPicture.asset('assets/svgs/nexticon.svg')),
          const SizedBox(
            width: double.infinity,
            height: 1.5,
            child: ColoredBox(color: backgroundcolorinterface),
          ),
          ListTile(
              leading: SvgPicture.asset('assets/svgs/connectrelevant.svg'),
              title: const Text(
                'Follow relevant people',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: textColor),
              ),
              onTap: () {
                Get.toNamed(Routes.relevantusersscreen,
                    arguments: Params(arg1: user));
              },
              trailing: SvgPicture.asset('assets/svgs/nexticon.svg')),
          const SizedBox(
            width: double.infinity,
            height: 1.5,
            child: ColoredBox(color: backgroundcolorinterface),
          ),
          ListTile(
              leading: Icon(
                LucideIcons.rocket,
                color: Colors.grey.shade400,
              ),
              title: const Text(
                'Generate Free Business Promotion',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: textColor),
              ),
              onTap: () {
                showPromoteSheet();
              },
              trailing: SvgPicture.asset('assets/svgs/nexticon.svg')),
          const SizedBox(
            width: double.infinity,
            height: 1.5,
            child: ColoredBox(color: backgroundcolorinterface),
          ),
          ListTile(
              leading: SvgPicture.asset('assets/svgs/explore.svg'),
              title: const Text(
                'How to use Business Bosses App',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: textColor),
              ),
              onTap: () {
                Get.to(() => const HowToUseAppScreen());
              },
              trailing: SvgPicture.asset('assets/svgs/nexticon.svg')),
          const SizedBox(
            width: double.infinity,
            height: 1.5,
            child: ColoredBox(color: backgroundcolorinterface),
          ),
          ListTile(
              leading: SvgPicture.asset('assets/svgs/mail.svg'),
              title: const Text(
                'Contact us',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: textColor),
              ),
              onTap: () {
                _contactUs();
              },
              trailing: SvgPicture.asset('assets/svgs/nexticon.svg')),
          const SizedBox(
            width: double.infinity,
            height: 1.5,
            child: ColoredBox(color: backgroundcolorinterface),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: GestureDetector(
              onTap: () {
                Get.to(() => AiChatScreen());
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(16),
                  // boxShadow: <BoxShadow>[
                  //   BoxShadow(
                  //     color:
                  //         profileController.myProfile.isSubscribed
                  //             ? Color(0xFF6366F1)
                  //                 .withValues(alpha: 0.3)
                  //             : Color(0xFFF59E0B)
                  //                 .withValues(alpha: 0.3),
                  //     blurRadius: 12,
                  //     offset: const Offset(0, 4),
                  //   ),
                  // ],
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: textColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: SvgPicture.asset(
                          'assets/svgs/bot.svg',
                          width: 10,
                          height: 18,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        )),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              const Text(
                                'SmartChat AI',
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 6),
                              if (!profileController.myProfile.isSubscribed)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    'PRO',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFEF4444),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            profileController.myProfile.isSubscribed
                                ? 'Get AI-powered business insights'
                                : 'Unlock AI-powered features',
                            style: TextStyle(
                              color: textColor.withValues(alpha: 0.9),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
    showSnackbar(
        title: 'OOPS!',
        message: 'An error occurred, please try again!',
        error: true);
  }
}

class MyAnalyserItem {
  String id;
  String label;

  MyAnalyserItem({
    this.id = '',
    this.label = '',
  });
}

enum Analyser { location, industry, category }
