import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/features/marketplace/models/suppliers_model.dart';
import 'package:business_bosses_v2/features/posts/widgets/images_viewer_screen.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/models/user_model.dart';
import '../../../common/widgets/user_avatar_with_badge.dart';
import '../../../utils/theme/theme.dart';

class ExpandedSuppliersPage extends StatefulWidget {
  final SuppliersModel supplier;
  final bool isLoading;
  final bool isSearch;
  final Function(UserModel)? onConnectionChange;

  // ignore: public_member_api_docs
  const ExpandedSuppliersPage({
    Key? key,
    this.isLoading = false,
    this.isSearch = false,
    this.onConnectionChange,
    required this.supplier,
  }) : super(key: key);

  @override
  State<ExpandedSuppliersPage> createState() => _FilterUsersState();
}

class _FilterUsersState extends State<ExpandedSuppliersPage> {
  final bool loadingNext = false;
  String? filterCode;
  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
        backgroundColor: backgroundcolorinterface,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
          ),
          centerTitle: true,
          title: const Text(
            'About Supplier',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    (widget.supplier.images!.isEmpty)
                        ? SizedBox(
                            height: 128.0,
                            width: 128.0,
                            child: CircleAvatar(
                              backgroundColor: Colors.grey.withOpacity(0.5),
                              child: SvgPicture.asset('assets/svgs/person.svg'),
                            ),
                          )
                        : NetworkImageWithPlaceHolder(
                            imageUrl: widget.supplier.images![0],
                            height: 128.0,
                            width: 128.0,
                            radius: 64.0,
                            cacheHeight: 90,
                            cacheWidth: 90,
                            placeHolder: Icons.person,
                          ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          widget.supplier.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: textColor,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                if (!widget.supplier.isVerified)
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.red.withAlpha(20),
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Row(
                      children: <Widget>[
                        SvgPicture.asset(
                          'assets/svgs/report.svg',
                          // ignore: deprecated_member_use
                          color: Colors.red,
                          height: 26,
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'This supplier isn\'t verified by Business Bosses; we cannot guarantee a response',
                            style: TextStyle(color: Colors.red),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (!widget.supplier.isVerified)
                  const SizedBox(
                    height: 20,
                  ),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Text(
                            'Contact Information',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: textColor),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    SvgPicture.asset('assets/svgs/website.svg'),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    SvgPicture.asset(
                                      'assets/svgs/email.svg',
                                      height: 10,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    SvgPicture.asset(
                                      'assets/svgs/phonenumber.svg',
                                      height: 11,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    SvgPicture.asset(
                                        'assets/svgs/locationicon.svg'),
                                  ],
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Website'),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text('Email'),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text('Phone'),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text('Location'),
                                  ],
                                )
                              ]),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                widget.supplier.url!,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  color: textColor.withAlpha(200),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                widget.supplier.email!,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  color: textColor.withAlpha(200),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                widget.supplier.phone!,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  color: textColor.withAlpha(200),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                widget.supplier.location!,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  color: textColor.withAlpha(200),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Description',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: textColor),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text('Category - ${widget.supplier.category}'),
                      const SizedBox(
                        height: 20,
                      ),
                      DetectableText(
                        text: widget.supplier.description,
                        detectionRegExp: detectionRegExp(hashtag: false)!,
                        detectedStyle: bodyText2.copyWith(
                          color: Colors.blue,
                        ),
                        moreStyle: bodyText2.copyWith(
                          color: Colors.redAccent,
                        ),
                        lessStyle: bodyText2.copyWith(
                          color: Colors.redAccent,
                        ),
                        trimLength: 10000,
                        basicStyle: bodyText2.copyWith(color: textColor),
                        onTap: (String text) async {
                          final Uri url = Uri.parse(text);
                          if ((url.scheme == 'http' || url.scheme == 'https')) {
                            if (!await launchUrl(url)) {
                              throw Exception('Could not launch $url');
                            }
                          } else if (text.startsWith('wa.me')) {
                            // Handle "wa.me" links
                            final Uri whatsappUrl = Uri.parse('https://$text');
                            if (await launchUrl(whatsappUrl)) {
                              await launchUrl(whatsappUrl);
                            } else {
                              throw Exception('Could not launch $whatsappUrl');
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      if (widget.supplier.images != null &&
                          widget.supplier.images!.isNotEmpty)
                        Container(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.supplier.images!.length,
                            itemBuilder: (BuildContext context, int i) {
                              return GestureDetector(
                                onTap: () {
                                  Get.to(
                                    () => ImagesViewerScreen(
                                      urls: widget.supplier.images,
                                      text: widget.supplier.description,
                                      index: i,
                                    ),
                                  );
                                },
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, right: 10),
                                      child: NetworkImageWithPlaceHolder(
                                        imageUrl: widget.supplier.images![i],
                                        width: 200,
                                        height: 200,
                                        placeHolder: Icons.photo,
                                        iconSize: 18.0,
                                        radius: 10.0,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ));
  }
}
