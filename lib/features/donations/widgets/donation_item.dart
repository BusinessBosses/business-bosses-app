// ignore_for_file: always_specify_types

import 'package:business_bosses_v2/action/action.dart';
import 'package:business_bosses_v2/common/models/comment_model.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/common/widgets/typography/text_widget.dart';
import 'package:business_bosses_v2/features/donations/controller/donations_controller.dart';
import 'package:business_bosses_v2/features/donations/models/donations_model.dart';
import 'package:business_bosses_v2/features/donations/presentation/expanded_donations_screen.dart';
import 'package:business_bosses_v2/features/donations/widgets/donation_comment.dart';
import 'package:business_bosses_v2/features/posts/widgets/youtube_display.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/services/api_service.dart';
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
  final ProfileController profileController = Get.find();
  final DonationsController donationsController = Get.find();
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
    int timestampMs = widget.donation.timestamp!;

    // Convert milliseconds to DateTime
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestampMs);

    // Calculate the difference between current time and the timestamp
    Duration difference = DateTime.now().difference(dateTime);

    // Format the duration
    String formattedDifference = formatDuration(difference);

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
                      widget.donation.setViews(widget.donation.views! + 1);
                      ApiService.put(
                          path: 'donation/approve/${widget.donation.id}',
                          body: {
                            'views': widget.donation.views! + 1,
                            'isActive': true,
                            'isApproved': true,
                          });
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
                            child: widget.donation.images.isNotEmpty
                                ? NetworkImageWithPlaceHolder(
                                    imageUrl: widget.donation.images[0])
                                : widget.donation.youtubeUrls != null
                                    ? YoutubeDisplay(
                                        widget.donation.youtubeUrls!)
                                    : const SizedBox(),
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
                          Text(
                            '${((widget.donation.amountRecieved / widget.donation.targetAmount!) * 100).toString()}%',
                            style: const TextStyle(
                                fontSize: 10, color: subtextColor),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: LinearProgressIndicator(
                          value: (widget.donation.amountRecieved /
                              widget.donation.targetAmount!),
                          minHeight: 4,
                          backgroundColor: backgroundcolorinterface,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              primaryColorLT),
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
                onPressed: () async {
                  donationsController.postLike(
                    profileController.myProfile.uid,
                    widget.donation.id,
                    widget.donation.user!.uid,
                  );
                },
                icon: widget.donation.likes
                            ?.contains(profileController.myProfile.uid) ==
                        true
                    ? SvgPicture.asset(
                        'assets/svgs/likefilled.svg',
                        height: 15,
                      )
                    : SvgPicture.asset(
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
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) => DonationCommentItem(
                      donation: widget.donation,
                      onComment: (CommentModel newComment) async {},
                    ),
                  );
                },
                icon: SvgPicture.asset(
                  'assets/svgs/comment.svg',
                  height: 15,
                ),
                label: Text(
                  '${widget.donation.comments?.length.toString()}',
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
                  widget.donation.views.toString(),
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
              widget.donation.user!.uid == profileController.myProfile.uid
                  ? Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Text(
                        formattedDifference,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: textColor.withOpacity(0.4)),
                      ),
                    )
                  : Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: GestureDetector(
                          onTap: () {
                            widget.donation
                                .setViews(widget.donation.views! + 1);
                            ApiService.put(
                                path: 'donation/approve/${widget.donation.id}',
                                body: {
                                  'views': widget.donation.views! + 1,
                                  'isActive': true,
                                  'isApproved': true,
                                });
                            Get.to(() => ExpandedDonationScreen(
                                donation: widget.donation));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    width: 1.5, color: primaryColorLT)),
                            child: const Center(
                              child: Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Text(
                                  'Donate',
                                  style: TextStyle(
                                    color: primaryColorLT,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
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

  String formatDuration(Duration difference) {
    if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day ago' : 'days ago'}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour ago' : 'hours ago'}';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute ago' : 'minutes ago'}';
    } else {
      return 'just now';
    }
  }

  // void _sharePost() {
  //   String message =
  //       'Have a look at ${widget.Donation.user?.username ?? 'Business Bosses'}\'s Donation on Business Bosses\n'
  //       'https://businessbosses.onelink.me/xLWk/36a2ff16';
  //   logEvent(widget.Donation.id, 'Donation');
  //   socialShare(message);
  // }
}
