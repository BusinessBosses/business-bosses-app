import 'dart:core';
import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../utils/theme/theme.dart';

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
          'Our Boss Up Partner',
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
  final bool showPartnerMessage;

  const BossuppartnerItem({
    required this.companyName,
    required this.companyDescription,
    required this.companyUrl,
    required this.showPartnerMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          width: double.infinity,
          height: 20,
          child: ColoredBox(color: backgroundcolorinterface),
        ),
        const SizedBox(
          height: 35,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                companyName,
                style: const TextStyle(
                  fontSize: 25,
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
        ),
        const SizedBox(height: 10),
        Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
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
                  GestureDetector(
                    onTap: () async {},
                    child: Text(
                      companyUrl,
                      style: const TextStyle(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          width: double.infinity,
          height: 1,
          child: ColoredBox(color: backgroundcolorinterface),
        ),
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
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(
          width: double.infinity,
          height: 1,
          child: ColoredBox(color: backgroundcolorinterface),
        ),
      ],
    );
  }
}
