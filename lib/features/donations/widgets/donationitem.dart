// ignore_for_file: always_specify_types

import 'package:business_bosses_v2/action/action.dart';
import 'package:business_bosses_v2/common/models/comment_model.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/common/widgets/typography/text_widget.dart';
import 'package:business_bosses_v2/features/posts/widgets/youtube_display.dart';
import 'package:business_bosses_v2/features/posts/widgets/yt_player.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:business_bosses_v2/utils/time_format.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class DonationItem extends StatefulWidget {
  // final DonationModel Donation;
  const DonationItem({
    super.key,
  });
  // required this.Donation});

  @override
  // ignore: library_private_types_in_public_api
  _DonationItemState createState() => _DonationItemState();
}

class _DonationItemState extends State<DonationItem> {
  ProfileController profileController = Get.find();
  List<String> blocked = <String>[];

  final List<PopupMenuEntry<String>> myPopupMore = <PopupMenuEntry<String>>[
    const PopupMenuItem<String>(
      value: 'Edit',
      child: Text(
        'Edit',
        style: bodyText2,
      ),
    ),
    const PopupMenuDivider(
      height: 0.0,
    ),
    const PopupMenuItem<String>(
      value: 'Delete',
      child: Text(
        'Delete',
        style: bodyText2,
      ),
    ),
    const PopupMenuDivider(
      height: 0.0,
    ),
    const PopupMenuItem<String>(
      value: 'Boost',
      child: Text(
        'Boost',
        style: bodyText2,
      ),
    ),
  ];

  final List<PopupMenuEntry<String>> myPopup = <PopupMenuEntry<String>>[
    const PopupMenuItem<String>(
      value: 'Hide',
      child: Text(
        'Hide',
        style: bodyText2,
      ),
    ),
    const PopupMenuDivider(
      height: 0.0,
    ),
    const PopupMenuItem<String>(
      value: 'Report',
      child: Text(
        'Report',
        style: bodyText2,
      ),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(children: [
                  SizedBox(
                    height: 90,
                    width: 160,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              color: Colors.black,
                              height: 200,
                              width: 200,
                            )),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Get.to(() => ExpandedDonationScreen(Donation: widget.Donation));
                    },
                    child: Container(
                      height: 90,
                      width: 160,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(12.0)),
                    ),
                  )
                ]),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        overflow:
                            TextOverflow.ellipsis, // or TextOverflow.ellipsis
                        maxLines: 2,
                        'widget.Donation.title!',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        overflow:
                            TextOverflow.ellipsis, // or TextOverflow.ellipsis
                        maxLines: 2,
                        'widget.Donation.description!',
                        style: const TextStyle(color: Colors.black45),
                      ),
                      // Row(
                      //   children: [
                      //     const Text('by'),
                      //     const SizedBox(
                      //       width: 5,
                      //     ),
                      //     SizedBox(
                      //       height: 20.0,
                      //       width: 20.0,
                      //       child: Align(
                      //         alignment: Alignment.topLeft,
                      //         child: ClipRRect(
                      //           borderRadius: BorderRadius.circular(1000),
                      //           child: NetworkImageWithPlaceHolder(
                      //             imageUrl: widget.Donation.user?.photoUrl ?? '',
                      //             radius: radius,
                      //             placeHolder: Icons.person,
                      //             iconSize: 15.0,
                      //             fit: BoxFit.cover,
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //     const SizedBox(
                      //       width: 5,
                      //     ),
                      //     Text(
                      //       overflow: TextOverflow
                      //           .ellipsis, // or TextOverflow.ellipsis
                      //       maxLines: 1,
                      //       widget.Donation.user?.name ??
                      //           widget.Donation.user!.name!,
                      //       style: const TextStyle(fontWeight: FontWeight.w700),
                      //     ),
                      //   ],
                      // ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('100'),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text('Target:'),
                              SvgPicture.asset('assets/svgs/coin.svg'),
                              Text('200')
                            ],
                          )
                        ],
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: const LinearProgressIndicator(
                          value: 0.4,
                          minHeight: 4,
                          backgroundColor: Colors.grey,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(primaryColorLT),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('70%'),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text('200'),
                              Text(' Supporters'),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    onTap: () {
                                      // Navigator.pop(context);
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          title: const TextWidget(
                                            text: 'Do you want to block user?',
                                            centralize: true,
                                            fontWeight: FontWeight.w700,
                                            size: 20,
                                          ),
                                          content: TextWidget(
                                            text:
                                                'You will no longer see Donations, posts and comments from this user on your feed',
                                            centralize: true,
                                            color: Colors.black.withOpacity(.6),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const TextWidget(
                                                text: 'Cancel',
                                                fontWeight: FontWeight.w700,
                                                size: 18,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                                // print(_post.user.uid);
                                                setState(() {
                                                  // blocked.add(
                                                  //     widget.Donation.user!.uid);
                                                });
                                                showSnackBar(context,
                                                    message:
                                                        'User has been blocked');
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 7,
                                                  horizontal: 14,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: primaryColorLT,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: const TextWidget(
                                                  text: 'Block',
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
                                    title: GestureDetector(
                                      child:
                                          'widget.Donation.user?.isSubscribed' ==
                                                  true
                                              ? Row(
                                                  children: <Widget>[
                                                    TextWidget(
                                                      text: 'Block @${''
                                                          // widget.Donation.user?.name
                                                          }',
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
                                                  text: 'Block @${''
                                                      // widget.Donation.user?.name
                                                      }',
                                                  color: Colors.blue,
                                                ),
                                    ),
                                  ),
                                  ListTile(
                                    onTap: () {
                                      Navigator.of(context).pop(context);
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          title: const TextWidget(
                                            text:
                                                'Do you want to report Donation?',
                                            centralize: true,
                                            fontWeight: FontWeight.w700,
                                            size: 20,
                                          ),
                                          content: TextWidget(
                                            text:
                                                'The Donation will be reported to admin to evaluate if it violates any community policy',
                                            centralize: true,
                                            color: Colors.black.withOpacity(.6),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const TextWidget(
                                                text: 'Cancel',
                                                fontWeight: FontWeight.w700,
                                                size: 18,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                                showSnackBar(context,
                                                    message:
                                                        'Donation has been Reported');
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
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
                                      text: 'Report this Donation',
                                      color: Colors.red,
                                    ),
                                  )
                                ],
                              ),
                            ));
                  },
                  child: const Icon(
                    Icons.more_horiz,
                    size: 20,
                    color: Colors.black,
                    weight: 100,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              TextButton.icon(
                onPressed: () async {},
                icon:
                    // post.likes?.contains(profileController.myProfile.uid) ==
                    //         true
                    //     ? SvgPicture.asset(
                    //         'assets/svgs/likefilled.svg',
                    //         height: 15,
                    //       )
                    //     :
                    SvgPicture.asset(
                  'assets/svgs/like.svg',
                  height: 15,
                ),
                label: Text(
                  '0',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: textColor.withOpacity(0.8),
                      ),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  // showModalBottomSheet(
                  //   context: context,
                  //   builder: (BuildContext context) => DonationCommentItem(
                  //     Donation: widget.Donation,
                  //     onComment: (CommentModel newComment) async {},
                  //   ),
                  // );
                },
                icon: SvgPicture.asset(
                  'assets/svgs/comment.svg',
                  height: 15,
                ),
                label: Text(
                  'Comments',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: textColor.withOpacity(0.8),
                      ),
                ),
              ),
              TextButton.icon(
                onPressed: () async {},
                icon: const Icon(Icons.remove_red_eye_outlined,
                    size: 19, color: Colors.black),
                label: Text(
                  'Views',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: textColor.withOpacity(0.8),
                      ),
                ),
              ),
              const SizedBox(width: 8.0),
              GestureDetector(
                // onTap: () => _sharePost(),
                child: SvgPicture.asset(
                  'assets/svgs/share.svg',
                  height: 15.0,
                  width: 15.0,
                  color: textColor.withOpacity(1.0),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Text(
                  '    Time',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: textColor.withOpacity(0.4)),
                ),
              )
            ],
          ),
          Container(
            color: backgroundcolorinterface,
            height: 7,
          )
        ],
      ),
    );
  }

  // void _sharePost() {
  //   String message =
  //       'Have a look at ${widget.Donation.user?.username ?? 'Business Bosses'}\'s Donation on Business Bosses\n'
  //       'https://businessbosses.onelink.me/xLWk/36a2ff16';
  //   logEvent(widget.Donation.id, 'Donation');
  //   socialShare(message);
  // }
}
