import 'dart:core';

import 'package:business_bosses_v2/analytics/presentation/howtouseapp.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/common/widgets/buttons/subscribe_to_premium_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/params.dart';
import '../../features/profile/controller/profile_controller.dart';
import '../../navigation/routes.dart';
import '../../utils/theme/theme.dart';

class AnalyserScreen extends StatefulWidget {
  static const String routeName = '/analyser-screen';

  const AnalyserScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AnalyserScreenState createState() => _AnalyserScreenState();
}

class _AnalyserScreenState extends State<AnalyserScreen> {
  bool _isInit = false;
  final ProfileController profileController = Get.find();

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

  @override
  Widget build(BuildContext context) {
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
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.premiumscreen);
                          },
                          child: Column(
                            children: <Widget>[
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                  decoration: BoxDecoration(
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.09),
                                        blurRadius: 500.0,
                                        spreadRadius: 0.0,
                                      ),
                                    ],
                                  ),
                                  child:
                                      !profileController.myProfile.isSubscribed
                                          ? subscribetopremiumbutton()
                                          : Container()),
                            ],
                          ),
                        ),
                      )
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
                    height: 5,
                  ),
                  const Text(
                    'how may I help you?',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w100),
                  ),
                ]),
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
                'Analyse my Profile',
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
              leading: SvgPicture.asset('assets/svgs/ranking.svg'),
              title: const Text(
                'Show my ranking',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: textColor),
              ),
              onTap: () {
                Get.toNamed(Routes.rankingscreen);
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
