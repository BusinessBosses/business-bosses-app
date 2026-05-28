import 'package:business_bosses_v2/action/action.dart';
import 'package:business_bosses_v2/features/partners/models/partner_model.dart';
import 'package:business_bosses_v2/features/posts/widgets/images_viewer_screen.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:detectable_text_field/detectable_text_field.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class BossuppartnerItem extends StatelessWidget {
  final String companyName;
  final String companyDescription;
  final String companyUrl;
  final int clicks;
  final String? companyPhoto;
  final bool showPartnerMessage;
  final int id;
  final Partner? partner;

  const BossuppartnerItem({
    super.key,
    required this.companyName,
    required this.companyDescription,
    required this.companyUrl,
    required this.showPartnerMessage,
    this.companyPhoto,
    required this.id,
    required this.clicks,
    this.partner,
  });

  @override
  Widget build(BuildContext context) {
    void sharePartner() {
      String message = 'Have a look at $companyName on Business Bosses\n'
          'https://vm.businessbosses.co.uk/share/post';
      socialShare(message);
    }

    List<dynamic> photos = <dynamic>[companyPhoto];
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 15),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
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
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              companyName,
                              softWrap: true,
                              style: const TextStyle(
                                fontSize: 15,
                                color: textColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              sharePartner();
                            },
                            child: CircleAvatar(
                              backgroundColor: backgroundColor,
                              radius: 16,
                              child: Icon(
                                LucideIcons.share,
                                color: Colors.black,
                                size: 16,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: DetectableText(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 100,
                          softWrap: true,
                          trimLength: 45,
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
            const SizedBox(height: 5),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: OutlinedButton(
                onPressed: () async {
                  ApiService.put(
                    path: 'partner/$id',
                    body: <String, dynamic>{'clicks': clicks + 1},
                  );
                  final Uri url = Uri.parse(companyUrl);
                  if (!await launchUrl(url, mode: LaunchMode.inAppWebView)) {
                    throw Exception('Could not launch $url');
                  }
                },
                child: const Text(
                  'Claim Deals',
                  style: TextStyle(
                    color: primaryColorLT,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
