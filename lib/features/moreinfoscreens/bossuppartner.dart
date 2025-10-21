import 'dart:core';

import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/home/widgets/becomeapartnerscreen.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

// import '../../action/action.dart';
// import '../../utils/constants/constants.dart';
import '../../utils/theme/theme.dart';
import '../posts/widgets/images_viewer_screen.dart';

// ignore: public_member_api_docs
class Bossuppartner extends StatefulWidget {
  final bool? isMarketplace;
  // ignore: public_member_api_docs
  const Bossuppartner({super.key, this.isMarketplace});

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
      backgroundColor: backgroundColor,
      appBar: widget.isMarketplace != null
          ? PreferredSize(
              preferredSize: const Size.fromHeight(0),
              child: Container(),
            )
          : AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: SvgPicture.asset(
                  'assets/svgs/backbutton.svg',
                ),
              ),
              centerTitle: true,
              title: const Text(
                'Partner Challenge',
                textAlign: TextAlign.center,
              ),
            ),
      body: Column(
        children: <Widget>[
          if (widget.isMarketplace == null)
            Padding(
              padding: const EdgeInsets.only(
                  left: 15, right: 15, top: 20, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  const Expanded(
                    child: Text(
                      'Partner with us, list deals and get customers.',
                      maxLines: 3,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      height: 45,
                      child: ElevatedButton(
                        child: const Text(
                          'Become a Partner',
                          style: TextStyle(
                            color: Colors.white,
                            // fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        onPressed: () {
                          Get.to(BecomeaPartnerScreen());
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 10, bottom: 100),
              itemCount: homeController.bossUp?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                Map<String, dynamic> partner =
                    homeController.bossUp!.reversed.toList()[index];
                return BossuppartnerItem(
                  companyName: partner['companyName'],
                  companyDescription: partner['companyDescription'],
                  companyUrl: partner['companyUrl'],
                  companyPhoto: partner['companyPhoto'],
                  clicks: partner['clicks'],
                  id: partner['id'],
                  showPartnerMessage: isLastItem(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BossuppartnerItem extends StatelessWidget {
  final String companyName;
  final String companyDescription;
  final String companyUrl;
  final int clicks;
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
    required this.clicks,
  });

  @override
  Widget build(BuildContext context) {
    List<dynamic> photos = <dynamic>[companyPhoto];
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 15),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) => ImagesViewerScreen(
                          urls: photos,
                          index: 0,
                          text: companyName,
                        ),
                      ),
                    );
                  },
                  child: companyPhoto != null
                      ? Container(
                          decoration: BoxDecoration(
                            border:
                                Border.all(width: 0.5, color: Colors.black12),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: CachedNetworkImage(
                              imageUrl: companyPhoto ?? '',
                              width: 80.0,
                              height: 80.0,
                              fit: BoxFit.fill,
                            ),
                          ),
                        )
                      : const SizedBox(),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        companyName,
                        softWrap: true,
                        style: const TextStyle(
                          fontSize: 15,
                          color: textColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: DetectableText(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 100,
                          softWrap: true,
                          trimLength: 100,
                          detectedStyle: bodyText2.copyWith(
                            color: Colors.blue,
                          ),
                          moreStyle: bodyText2.copyWith(
                            color: Colors.redAccent,
                          ),
                          lessStyle: bodyText2.copyWith(
                            color: Colors.redAccent,
                          ),
                          trimExpandedText: '  show less',
                          basicStyle: bodyText2.copyWith(color: textColor),
                          text: companyDescription,
                          detectionRegExp: detectionRegExp(hashtag: false)!,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: OutlinedButton(
                  onPressed: () async {
                    ApiService.put(
                        path: 'partner/$id',
                        body: <String, dynamic>{'clicks': clicks + 1});
                    final Uri url = Uri.parse(companyUrl);
                    if (!await launchUrl(url, mode: LaunchMode.inAppWebView)) {
                      throw Exception('Could not launch $url');
                    }
                  },
                  child: const Text(
                    'Claim Deals',
                    style: TextStyle(
                        color: primaryColorLT, fontWeight: FontWeight.w700),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
