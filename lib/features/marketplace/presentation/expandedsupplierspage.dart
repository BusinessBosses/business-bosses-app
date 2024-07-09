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
            'About Supplier',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (!widget.supplier.isVerified)
                Container(
                  decoration: BoxDecoration(
                      color: Colors.red.withAlpha(20),
                      borderRadius: BorderRadius.circular(8)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                  height: 30,
                ),
              Row(
                children: <Widget>[
                  UserAvatarWithBadge(
                    user: widget.supplier.user,
                    height: 128.0,
                    width: 128.0,
                    radius: 64.0,
                    placeHolder: Icons.person,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.supplier.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: textColor,
                        ),
                      ),
                      Text(
                        widget.supplier.phone,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                          color: textColor.withAlpha(200),
                        ),
                      ),
                      Text(
                        widget.supplier.email!,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                          color: textColor.withAlpha(200),
                        ),
                      ),
                      Text(
                        widget.supplier.url!,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: textColor.withAlpha(200),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Text('Location - ${widget.supplier.location}'),
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
              const SizedBox(
                height: 10,
              ),
              if (widget.supplier.images != null &&
                  widget.supplier.images!.isNotEmpty)
                Expanded(
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
                              padding:
                                  const EdgeInsets.only(top: 10.0, right: 10),
                              child: NetworkImageWithPlaceHolder(
                                imageUrl: widget.supplier.images![i],
                                width: 200,
                                height: 200,
                                placeHolder: Icons.photo,
                                iconSize: 18.0,
                                radius: 20.0,
                              ),
                            ),
                            // if (post.images!.length > 5 &&
                            //     i == 5)
                            //   Container(
                            //     padding:
                            //         const EdgeInsets.all(0.0),
                            //     alignment: Alignment.center,
                            //     color: Colors.white
                            //         .withOpacity(0.5),
                            //     child: Text(
                            //       '+${post.images!.length - 5}',
                            //       style: headline6.copyWith(
                            //         fontWeight:
                            //             FontWeight.bold,
                            //       ),
                            //     ),
                            //   )
                            // else
                            //   Container()
                          ],
                        ),
                      );
                    },
                  ),
                )
            ],
          ),
        ));
  }
}
