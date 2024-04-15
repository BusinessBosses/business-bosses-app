// ignore_for_file: always_specify_types

import 'package:business_bosses_v2/action/action.dart';
import 'package:business_bosses_v2/common/widgets/typography/text_widget.dart';
import 'package:business_bosses_v2/features/donations/models/donations_model.dart';
import 'package:business_bosses_v2/features/donations/presentation/expanded_donations_scren.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class DonationItem extends StatefulWidget {
  final DonationModel donation;
  final bool isLastItem;
  const DonationItem({
    required this.isLastItem,
    Key? key,
    required this.donation,
  }) : super(key: key);

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
                  GestureDetector(
                    onTap: () {
                      Get.to(() =>
                          ExpandedDonationScreen(donation: widget.donation));
                    },
                    child: SizedBox(
                      height: 90,
                      width: 160,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Container(
                            color: Colors.black,
                            height: 200,
                            width: 200,
                          ),
                        ),
                      ),
                    ),
                  ),
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
                        widget.donation.title!,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        overflow:
                            TextOverflow.ellipsis, // or TextOverflow.ellipsis
                        maxLines: 2,
                        widget.donation.description!,
                        style: const TextStyle(color: Colors.black45),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.donation.amountRecieved.toString(),
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: subtextColor,
                                    fontWeight: FontWeight.w700),
                              ),
                              const Text(
                                ' coins raised',
                                style: TextStyle(
                                    fontSize: 10, color: subtextColor),
                              ),
                            ],
                          ),
                          const Text(
                            '70%',
                            style: TextStyle(fontSize: 10, color: subtextColor),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: const LinearProgressIndicator(
                          value: 0.4,
                          minHeight: 4,
                          backgroundColor: backgroundcolorinterface,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(primaryColorLT),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/svgs/coin.svg',
                                height: 12,
                              ),
                              Text(
                                widget.donation.targetAmount.toString(),
                                style: const TextStyle(
                                    color: subtextColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12),
                              ),
                              const Text(
                                'Target',
                                style: TextStyle(
                                    color: subtextColor, fontSize: 10),
                              ),
                            ],
                          ),
                          const Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                '100',
                                style: TextStyle(
                                    fontSize: 10,
                                    color: subtextColor,
                                    fontWeight: FontWeight.w700),
                              ),
                              Text(
                                ' Supporters',
                                style: TextStyle(
                                    fontSize: 10, color: subtextColor),
                              ),
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
                                                      text:
                                                          'Block @${widget.donation.user?.name}',
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
                                                  text:
                                                      'Block @${widget.donation.user?.name}',
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
                icon: SvgPicture.asset(
                  'assets/svgs/like.svg',
                  height: 15,
                ),
                label: Text(
                  widget.donation.likes!.length.toString(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: textColor.withOpacity(0.8),
                      ),
                ),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: SvgPicture.asset(
                  'assets/svgs/comment.svg',
                  height: 15,
                ),
                label: Text(
                  '${widget.donation.comments?.length.toString()} Comments',
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
                  '${widget.donation.views.toString()} Views',
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
          ),
          if (widget.isLastItem)
            Container(
              color: backgroundColor,
              height: 80,
            ),
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
