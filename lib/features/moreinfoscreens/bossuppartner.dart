import 'dart:core';

import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../action/action.dart';
import '../../utils/constants/constants.dart';
import '../../utils/theme/theme.dart';
import '../posts/widgets/images_viewer_screen.dart';

// ignore: public_member_api_docs
class Bossuppartner extends StatefulWidget {
  // ignore: public_member_api_docs
  const Bossuppartner({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BossuppartnerState createState() => _BossuppartnerState();
}

class _BossuppartnerState extends State<Bossuppartner> {
  bool _isInit = false;
  final HomeController homeController = Get.find();

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

  bool isLastItem(int index) {
    return index == homeController.bossUp!.length - 1;
  }

  @override
  Widget build(BuildContext context) {
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
          'Our Partners',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: ListView.builder(
        itemCount: homeController.bossUp?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          Map<String, dynamic> partner =
              homeController.bossUp!.reversed.toList()[index];
          return BossuppartnerItem(
            companyName: partner['companyName'],
            companyDescription: partner['companyDescription'],
            companyUrl: partner['companyUrl'],
            companyPhoto: partner['companyPhoto'],
            id: partner['id'],
            showPartnerMessage: isLastItem(index),
          );
        },
      ),
    );
  }
}

class BossuppartnerItem extends StatelessWidget {
  final String companyName;
  final String companyDescription;
  final String companyUrl;
  final String? companyPhoto;
  final bool showPartnerMessage;
  final int id;

  const BossuppartnerItem({
    super.key,
    required this.companyName,
    required this.companyDescription,
    required this.companyUrl,
    required this.showPartnerMessage,
    this.companyPhoto,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    List<dynamic> photos = [companyPhoto];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        id != 5
            ? const SizedBox(
                width: double.infinity,
                height: 20,
                child: ColoredBox(color: backgroundcolorinterface),
              )
            : const SizedBox(),
        id != 5
            ? const SizedBox(
                height: 35,
              )
            : const SizedBox(),
        id != 5
            ? Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ImagesViewerScreen(
                              urls: photos,
                              index: 0,
                              text: companyName,
                            ),
                          ),
                        );
                      },
                      child: Align(
                        alignment: Alignment.center,
                        child: companyPhoto != null
                            ? CachedNetworkImage(
                                imageUrl: companyPhoto!,
                                memCacheWidth: 750,
                              )
                            : const SizedBox(),
                      ),
                    ),
                    Text(
                      companyName,
                      style: const TextStyle(
                        fontSize: 18,
                        color: textColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Text(
                        companyDescription,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox(),
        const SizedBox(height: 10),
        id != 5
            ? Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 10),
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 20),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/svgs/link.svg',
                          height: 14.0,
                          width: 15.0,
                        ),
                        const SizedBox(width: 4.0),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              final Uri url = Uri.parse(companyUrl);
                              if (!await launchUrl(url)) {
                                throw Exception('Could not launch $url');
                              }
                            },
                            child: Text(
                              companyUrl,
                              style: const TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : const SizedBox(),
        id != 5
            ? const SizedBox(
                width: double.infinity,
                height: 1,
                child: ColoredBox(color: backgroundcolorinterface),
              )
            : const SizedBox(),
        if (showPartnerMessage)
          Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'Want to be a Partner?',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: OutlinedButton(
                      child: const Text(
                        'Message Us',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      onPressed: () async {
                        if (await canLaunchUrl(Uri.parse(
                            'https://businessbosses.news/our-partners/'))) {
                          await launchUrl(Uri.parse(
                              'https://businessbosses.news/our-partners/'));
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(
          width: double.infinity,
          height: 10,
          child: ColoredBox(color: backgroundcolorinterface),
        ),
      ],
    );
  }

  Future<void> _contactUs(BuildContext context) async {
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
        'subject': 'BossUp Partner',
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
}
