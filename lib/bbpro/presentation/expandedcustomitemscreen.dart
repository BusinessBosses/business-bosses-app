import 'package:business_bosses_v2/action/action.dart';
import 'package:business_bosses_v2/bbpro/models/customitem_model.dart';
import 'package:business_bosses_v2/bbpro/widgets/button.dart';
import 'package:business_bosses_v2/common/generic_slider.dart';
import 'package:business_bosses_v2/common/widgets/text_widget.dart';
import 'package:business_bosses_v2/features/profile/presentation/public_profile_screen.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ExpandedCustomItemScreen extends StatefulWidget {
  final Customitem? customitem;
  const ExpandedCustomItemScreen({super.key, this.customitem});

  @override
  State<ExpandedCustomItemScreen> createState() =>
      _ExpandedCustomItemScreenState();
}

class _ExpandedCustomItemScreenState extends State<ExpandedCustomItemScreen> {
  bool blocked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        titleSpacing: 0,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            onTap: () {
                              navigateTo(context);
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const TextWidget(
                                    text: 'Do you want to block user?',
                                    centralize: true,
                                    fontWeight: FontWeight.w700,
                                    size: 20,
                                  ),
                                  content: TextWidget(
                                    text: blocked == true
                                        ? 'You will see posts and comments related to user on your feed'
                                        : 'You will no longer see undefined posts and comments on your feed',
                                    centralize: true,
                                    color: Colors.black.withOpacity(.6),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => navigateTo(context),
                                      child: const TextWidget(
                                        text: 'Cancel',
                                        fontWeight: FontWeight.w700,
                                        size: 18,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        navigateTo(context);
                                        // print(_post.user.uid);

                                        // widget
                                        //     .onBlock(_post.user.uid);
                                        showSnackBar(context,
                                            message: blocked == true
                                                ? 'User has been blocked'
                                                : 'User has been unblocked');
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 7,
                                          horizontal: 14,
                                        ),
                                        decoration: BoxDecoration(
                                          color: primaryColorLT,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: TextWidget(
                                          text: blocked == true
                                              ? 'Unblock'
                                              : 'Block',
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                            contentPadding: EdgeInsets.zero,
                            title: widget.customitem!.user!.isSubscribed
                                ? Row(
                                    children: <Widget>[
                                      TextWidget(
                                        text: blocked == true
                                            ? 'Unblock @${widget.customitem!.user!.name ?? widget.customitem!.user!.username}'
                                            : 'Block @${widget.customitem!.user!.name ?? widget.customitem!.user!.username}',
                                        color: Colors.blue,
                                      ),
                                      const SizedBox(width: 5),
                                      SvgPicture.asset(
                                        'assets/svgs/premiumbadge.svg',
                                        height: 9,
                                        color: primaryColorLT,
                                      )
                                    ],
                                  )
                                : TextWidget(
                                    text: blocked == true
                                        ? 'Unblock @${widget.customitem!.user!.name ?? widget.customitem!.user!.username}'
                                        : 'Block @${widget.customitem!.user!.name ?? widget.customitem!.user!.username}',
                                    color: Colors.blue,
                                  ),
                          ),
                          ListTile(
                            onTap: () {
                              navigateTo(context);
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const TextWidget(
                                    text: 'Do you want to report user?',
                                    centralize: true,
                                    fontWeight: FontWeight.w700,
                                    size: 20,
                                  ),
                                  content: TextWidget(
                                    text:
                                        'The user will be reported to admin to evaluate if it violates any community policy',
                                    centralize: true,
                                    color: Colors.black.withOpacity(.6),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => navigateTo(context),
                                      child: const TextWidget(
                                        text: 'Cancel',
                                        fontWeight: FontWeight.w700,
                                        size: 18,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        navigateTo(context);
                                        await _reportUser(
                                            context,
                                            'accountReport',
                                            widget.customitem!.user!.uid,
                                            widget.customitem!.user!.username);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 7,
                                          horizontal: 14,
                                        ),
                                        decoration: BoxDecoration(
                                          color: primaryColorLT,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: const TextWidget(
                                          text: 'Report',
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                            contentPadding: EdgeInsets.zero,
                            title: const TextWidget(
                              text: 'Report this user',
                              color: Colors.red,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
                child: CircleAvatar(
                    backgroundColor: backgroundColor,
                    child: SvgPicture.asset('assets/svgs/more.svg'))),
          )
        ],
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        ),
        title: GestureDetector(
          onTap: () {
            if (Get.previousRoute == Routes.publicProfile) {
              Get.back();
            } else {
              Get.to(
                () => PublicProfileScreen(
                  currentIndex: 1,
                ),
                arguments: widget.customitem!.user,
              );
            }
          },
          // Get.to(UserShopScreen(
          //   user: widget.customitem!.user!,
          // ));

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.customitem!.shop!.name,
                style: const TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: probackgroundColor,
                    borderRadius: BorderRadius.circular(radius)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Visit Biz-Center',
                      style: TextStyle(
                        fontSize: 10,
                        color: proprimaryColor,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: textColor,
                      size: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView(children: <Widget>[
        if (widget.customitem!.images != null &&
            widget.customitem!.images!.isNotEmpty)
          SizedBox(
            height: 250,
            child: GenericSlider(
              radius: 0,
              images: widget.customitem!.images ?? <String>[],
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.customitem!.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              DetectableText(
                text: widget.customitem!.description,
                detectionRegExp: detectionRegExp(hashtag: false)!,
                detectedStyle: bodyText2.copyWith(color: Colors.blue),
                moreStyle: bodyText2.copyWith(
                    color: Colors.black, fontWeight: FontWeight.bold),
                lessStyle: bodyText2.copyWith(
                    color: Colors.black, fontWeight: FontWeight.bold),
                trimLength: 100,
                trimExpandedText: '  show less',
                basicStyle: bodyText2.copyWith(color: textColor),
                onTap: (_) {},
              ),
              if (widget.customitem!.link != null &&
                  widget.customitem!.link!.isNotEmpty)
                SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: ProCustomButton(
                          text: 'Visit Page',
                          onPressed: () async {
                            try {
                              await _launchURL(widget.customitem!.link!);
                            } catch (e) {
                              // Show a snackbar or other error feedback if desired.
                              print(e.toString());
                              showSnackBar(context,
                                  message: 'Could not open the link.');
                            }
                          }),
                    ))
            ],
          ),
        )
      ]),
    );
  }

  Future<void> _reportUser(BuildContext context, String reportType,
      String userId, String username) async {}

  Future<void> _launchURL(String urlString) async {
    if (!urlString.startsWith('http://') && !urlString.startsWith('https://')) {
      urlString = 'https://$urlString';
    }
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $urlString');
    }
  }
}
