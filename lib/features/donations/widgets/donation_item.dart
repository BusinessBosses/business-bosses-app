import 'package:business_bosses_v2/action/action.dart';
import 'package:business_bosses_v2/common/models/comment_model.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/common/widgets/popup/my_popup_menu_button.dart';
import 'package:business_bosses_v2/common/widgets/typography/text_widget.dart';
import 'package:business_bosses_v2/features/donations/controller/donations_controller.dart';
import 'package:business_bosses_v2/features/donations/models/donations_model.dart';
import 'package:business_bosses_v2/features/donations/presentation/create_donations.dart';
import 'package:business_bosses_v2/features/donations/presentation/expanded_donations_screen.dart';
import 'package:business_bosses_v2/features/donations/widgets/donation_comment.dart';
import 'package:business_bosses_v2/features/posts/widgets/tag.dart';
import 'package:business_bosses_v2/features/posts/widgets/youtube_display.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DonationItem extends StatefulWidget {
  final DonationModel donation;
  final bool isLastItem;
  final bool? isHome;
  const DonationItem({
    required this.isLastItem,
    super.key,
    required this.donation,
    this.isHome,
  });

  // required this.Donation});

  @override
  // ignore: library_private_types_in_public_api
  _DonationItemState createState() => _DonationItemState();
}

class _DonationItemState extends State<DonationItem> {
  final ProfileController profileController = Get.find();
  final DonationsController donationsController = Get.find();
  List<String> blocked = <String>[];
  NumberFormat formatter = NumberFormat.compact();

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
    // const PopupMenuDivider(
    //   height: 0.0,
    // ),
    // const PopupMenuItem<String>(
    //   value: 'Boost',
    //   child: Text(
    //     'Boost',
    //     style: bodyText2,
    //   ),
    // ),
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
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didUpdateWidget(DonationItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLastItem != oldWidget.isLastItem) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    int timestampMs = widget.donation.timestamp!;

    // Convert milliseconds to DateTime
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestampMs);

    // Calculate the difference between current time and the timestamp
    Duration difference = DateTime.now().difference(dateTime);

    // Format the duration
    // ignore: unused_local_variable
    String formattedDifference = formatDuration(difference);

    return widget.isHome == true
        ? GestureDetector(
            onTap: () {
              widget.donation.setViews(widget.donation.views! + 1);
              ApiService.put(
                  path: 'donation/approve/${widget.donation.id}',
                  body: <String, dynamic>{
                    'views': widget.donation.views! + 1,
                    'isActive': true,
                    'isApproved': true,
                  });
              Get.to(() => ExpandedDonationScreen(donation: widget.donation));
            },
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12, width: 0.5),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    height: 90,
                    width: 160,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          // color: Colors.black,
                          height: 200,
                          width: 200,
                          child: widget.donation.images.isNotEmpty
                              ? NetworkImageWithPlaceHolder(
                                  imageUrl: widget.donation.images[0])
                              : widget.donation.youtubeUrls != null
                                  ? YoutubeDisplay(widget.donation.youtubeUrls!)
                                  : const SizedBox(),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.publicProfile,
                          arguments: widget.donation.user);
                    },
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          height: 20.0,
                          width: 20.0,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(1000),
                              child: NetworkImageWithPlaceHolder(
                                imageUrl: widget.donation.user?.photoUrl ?? '',
                                radius: radius,
                                placeHolder: Icons.person,
                                iconSize: 15.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          overflow:
                              TextOverflow.ellipsis, // or TextOverflow.ellipsis
                          maxLines: 1,
                          widget.donation.user?.name ??
                              widget.donation.user!.name!,
                          style: TextStyle(
                              color: widget.isHome == true
                                  ? subtextColor
                                  : textColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w700),
                        ),
                        if (widget.donation.user?.isSubscribed == true)
                          Wrap(children: <Widget>[
                            const SizedBox(width: 3),
                            SvgPicture.asset(
                              'assets/svgs/premiumbadge.svg',
                              height: 7,
                              color: primaryColorLT,
                            )
                          ]),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 160,
                    height: 90,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              widget.donation.title!,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w700),
                            ),
                            Text(
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              widget.donation.description!,
                              style: const TextStyle(
                                  color: Colors.black45, fontSize: 12),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: LinearProgressIndicator(
                                    value: (widget.donation.amountRecieved /
                                        widget.donation.targetAmount!),
                                    minHeight: 4,
                                    backgroundColor: backgroundcolorinterface,
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                            primaryColorLT),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                widget.donation
                                    .setViews(widget.donation.views! + 1);
                                ApiService.put(
                                    path:
                                        'donation/approve/${widget.donation.id}',
                                    body: <String, dynamic>{
                                      'views': widget.donation.views! + 1,
                                      'isActive': true,
                                      'isApproved': true,
                                    });
                                Get.to(() => ExpandedDonationScreen(
                                    donation: widget.donation));
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 7),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  border: Border.all(color: primaryColorLT),
                                ),
                                child: const Text(
                                  'Support',
                                  style: TextStyle(
                                    color: primaryColorLT,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ))
        : GestureDetector(
            onTap: () {
              widget.donation.setViews(widget.donation.views! + 1);
              ApiService.put(
                  path: 'donation/approve/${widget.donation.id}',
                  body: <String, dynamic>{
                    'views': widget.donation.views! + 1,
                    'isActive': true,
                    'isApproved': true,
                  });
              Get.to(() => ExpandedDonationScreen(donation: widget.donation));
            },
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // PostTag(
                  //     label: 'Crowdfund',
                  //     textColor: textColor,
                  //     backgroundColor: backgroundColor),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 15.0, left: 15.0, right: 15.0, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            widget.donation
                                .setViews(widget.donation.views! + 1);
                            ApiService.put(
                                path: 'donation/approve/${widget.donation.id}',
                                body: <String, dynamic>{
                                  'views': widget.donation.views! + 1,
                                  'isActive': true,
                                  'isApproved': true,
                                });
                            Get.to(() => ExpandedDonationScreen(
                                donation: widget.donation));
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 90,
                                width: 160,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: FittedBox(
                                    fit: BoxFit.cover,
                                    child: SizedBox(
                                      // color: Colors.black,
                                      height: 200,
                                      width: 200,
                                      child: widget.donation.images.isNotEmpty
                                          ? NetworkImageWithPlaceHolder(
                                              imageUrl:
                                                  widget.donation.images[0])
                                          : widget.donation.youtubeUrls != null
                                              ? YoutubeDisplay(
                                                  widget.donation.youtubeUrls!)
                                              : const SizedBox(),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed(Routes.publicProfile,
                                      arguments: widget.donation.user);
                                },
                                child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 20.0,
                                      width: 20.0,
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(1000),
                                          child: NetworkImageWithPlaceHolder(
                                            imageUrl: widget
                                                    .donation.user?.photoUrl ??
                                                '',
                                            radius: radius,
                                            placeHolder: Icons.person,
                                            iconSize: 15.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      overflow: TextOverflow
                                          .ellipsis, // or TextOverflow.ellipsis
                                      maxLines: 1,
                                      widget.donation.user?.name ??
                                          widget.donation.user!.name!,
                                      style: TextStyle(
                                          color: widget.isHome == true
                                              ? subtextColor
                                              : textColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    widget.donation.user?.isSubscribed == true
                                        ? Wrap(children: <Widget>[
                                            const SizedBox(width: 3),
                                            SvgPicture.asset(
                                              'assets/svgs/premiumbadge.svg',
                                              height: 7,
                                              color: primaryColorLT,
                                            )
                                          ])
                                        : Container()
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (widget.isHome == false)
                          const SizedBox(
                            width: 10,
                          ),
                        if (widget.isHome == false)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  overflow: TextOverflow
                                      .ellipsis, // or TextOverflow.ellipsis
                                  maxLines: 2,
                                  widget.donation.title!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14),
                                ),
                                Text(
                                  overflow: TextOverflow
                                      .ellipsis, // or TextOverflow.ellipsis
                                  maxLines: 2,
                                  widget.donation.description!,
                                  style: const TextStyle(
                                      color: Colors.black45, fontSize: 12),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Text(
                                                    formatter.format(widget
                                                        .donation
                                                        .amountRecieved),
                                                    style: const TextStyle(
                                                        fontSize: 10,
                                                        color: subtextColor,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  Text(
                                                    widget.donation
                                                                .amountRecieved ==
                                                            1
                                                        ? ' coin raised'
                                                        : ' coins raised',
                                                    style: const TextStyle(
                                                        fontSize: 10,
                                                        color: subtextColor),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                '${((widget.donation.amountRecieved / widget.donation.targetAmount!) * 100).toStringAsFixed(1)}%',
                                                style: const TextStyle(
                                                    fontSize: 10,
                                                    color: subtextColor),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: LinearProgressIndicator(
                                              value: (widget
                                                      .donation.amountRecieved /
                                                  widget
                                                      .donation.targetAmount!),
                                              minHeight: 4,
                                              backgroundColor:
                                                  backgroundcolorinterface,
                                              valueColor:
                                                  const AlwaysStoppedAnimation<
                                                      Color>(primaryColorLT),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Wrap(
                                                crossAxisAlignment:
                                                    WrapCrossAlignment.center,
                                                children: <Widget>[
                                                  SvgPicture.asset(
                                                    'assets/svgs/coin.svg',
                                                    height: 12,
                                                  ),
                                                  Text(
                                                    formatter.format(widget
                                                        .donation
                                                        .targetAmount!),
                                                    style: const TextStyle(
                                                        color: subtextColor,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 12),
                                                  ),
                                                  const Text(
                                                    ' Target',
                                                    style: TextStyle(
                                                        color: subtextColor,
                                                        fontSize: 10),
                                                  ),
                                                ],
                                              ),
                                              Wrap(
                                                crossAxisAlignment:
                                                    WrapCrossAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    formatter.format(widget
                                                        .donation
                                                        .transactions!
                                                        .length),
                                                    style: const TextStyle(
                                                        fontSize: 10,
                                                        color: subtextColor,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  Text(
                                                    widget
                                                                .donation
                                                                .transactions!
                                                                .length ==
                                                            1
                                                        ? ' Supporter'
                                                        : ' Supporters',
                                                    style: const TextStyle(
                                                        fontSize: 10,
                                                        color: subtextColor),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        // const SizedBox(
                        //   width: 10,
                        // ),
                        if (widget.isHome == false)
                          (widget.donation.user!.uid ==
                                      profileController.myProfile.uid &&
                                  widget.donation.amountRecieved <
                                      widget.donation.targetAmount!)
                              ? MyPopupMenuButton(
                                  popupItems: myPopupMore,
                                  icon: const Icon(
                                    Icons.more_horiz,
                                    size: 20,
                                    color: Colors.black,
                                    weight: 100,
                                  ),
                                  onSelected: (String val) {
                                    if (val == 'Edit') {
                                      Get.to(() => CreateDonationScreen(
                                            donation: widget.donation,
                                          ));
                                    } else if (val == 'Delete') {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          title: const Text(
                                            'Delete Donation Post',
                                            style: bodyText1,
                                          ),
                                          content: const Text(
                                              'Are you sure you want to delete this donation post?'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () => Get.back(),
                                              child: const Text('No'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                donationsController
                                                    .deleteDonation(
                                                        widget.donation.id);
                                                Get.back();
                                                setState(() {});
                                              },
                                              child: const Text('Yes'),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                    // else if (val == 'Boost') {
                                    //   Get.to(() => BoostDonation(
                                    //         donationId: widget.donation.id,
                                    //         donationTitle: widget.donation.title!,
                                    //       ));
                                    // }
                                  },
                                )
                              : GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  ListTile(
                                                    onTap: () {
                                                      // Navigator.pop(context);
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                                context) =>
                                                            AlertDialog(
                                                          title:
                                                              const TextWidget(
                                                            text:
                                                                'Do you want to block user?',
                                                            centralize: true,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            size: 20,
                                                          ),
                                                          content: TextWidget(
                                                            text:
                                                                'You will no longer see Donations, posts and comments from this user on your feed',
                                                            centralize: true,
                                                            color: Colors.black
                                                                .withValues(
                                                                    alpha: .6),
                                                          ),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      context),
                                                              child:
                                                                  const TextWidget(
                                                                text: 'Cancel',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                size: 18,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                Navigator.pop(
                                                                    context);
                                                                // print(_post.user.uid);
                                                                setState(() {
                                                                  // blocked.add(
                                                                  //     widget.Donation.user!.uid);
                                                                });
                                                                showSnackBar(
                                                                    context,
                                                                    message:
                                                                        'User has been blocked');
                                                              },
                                                              child: Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                  vertical: 7,
                                                                  horizontal:
                                                                      14,
                                                                ),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color:
                                                                      primaryColorLT,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                ),
                                                                child:
                                                                    const TextWidget(
                                                                  text: 'Block',
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                    contentPadding:
                                                        EdgeInsets.zero,
                                                    title: GestureDetector(
                                                      child: widget
                                                                  .donation
                                                                  .user
                                                                  ?.isSubscribed ==
                                                              true
                                                          ? Row(
                                                              children: <Widget>[
                                                                TextWidget(
                                                                  text:
                                                                      'Block @${widget.donation.user?.name}',
                                                                  color: Colors
                                                                      .blue,
                                                                ),
                                                                const SizedBox(
                                                                    width: 5),
                                                                SvgPicture
                                                                    .asset(
                                                                  'assets/svgs/premiumbadge.svg',
                                                                  height: 9,
                                                                  color:
                                                                      primaryColorLT,
                                                                )
                                                              ],
                                                            )
                                                          : TextWidget(
                                                              text:
                                                                  'Block @${widget.donation.user?.name}',
                                                              color:
                                                                  Colors.blue,
                                                            ),
                                                    ),
                                                  ),
                                                  ListTile(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pop(context);
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                                context) =>
                                                            AlertDialog(
                                                          title:
                                                              const TextWidget(
                                                            text:
                                                                'Do you want to report Donation?',
                                                            centralize: true,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            size: 20,
                                                          ),
                                                          content: TextWidget(
                                                            text:
                                                                'The Donation will be reported to admin to evaluate if it violates any community policy',
                                                            centralize: true,
                                                            color: Colors.black
                                                                .withValues(
                                                                    alpha: .6),
                                                          ),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      context),
                                                              child:
                                                                  const TextWidget(
                                                                text: 'Cancel',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                size: 18,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                Navigator.pop(
                                                                    context);
                                                                showSnackBar(
                                                                    context,
                                                                    message:
                                                                        'Donation has been Reported');
                                                              },
                                                              child: Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                  vertical: 7,
                                                                  horizontal:
                                                                      14,
                                                                ),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color:
                                                                      primaryColorLT,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                ),
                                                                child:
                                                                    const TextWidget(
                                                                  text:
                                                                      'Report',
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                    contentPadding:
                                                        EdgeInsets.zero,
                                                    title: const TextWidget(
                                                      text:
                                                          'Report this Project',
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
                  // const SizedBox(
                  //   height: 10,
                  // ),

                  if (widget.isHome == false)
                    Row(
                      children: <Widget>[
                        TextButton.icon(
                          onPressed: () async {
                            donationsController.postLike(
                              profileController.myProfile.uid,
                              widget.donation.id,
                              widget.donation.user!.uid,
                            );
                            setState(() {});
                          },
                          icon: widget.donation.likes?.contains(
                                      profileController.myProfile.uid) ==
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
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: textColor.withValues(alpha: 0.8),
                                ),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) =>
                                  DonationCommentItem(
                                donation: widget.donation,
                                onComment: (CommentModel newComment) async {
                                  setState(() {});
                                },
                              ),
                            );
                          },
                          icon: SvgPicture.asset(
                            'assets/svgs/comment.svg',
                            height: 15,
                          ),
                          label: Text(
                            '${widget.donation.comments?.length ?? 0}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: textColor.withValues(alpha: 0.8),
                                ),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () async {},
                          icon: const Icon(Icons.remove_red_eye_outlined,
                              size: 19, color: Colors.black),
                          label: Text(
                            widget.donation.views.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: textColor.withValues(alpha: 0.8),
                                ),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        GestureDetector(
                          onTap: () => _sharePost(),
                          child: SvgPicture.asset(
                            'assets/svgs/share.svg',
                            height: 15.0,
                            width: 15.0,
                            color: textColor.withValues(alpha: 1.0),
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: GestureDetector(
                            onTap: () {
                              widget.donation
                                  .setViews(widget.donation.views! + 1);
                              ApiService.put(
                                  path:
                                      'donation/approve/${widget.donation.id}',
                                  body: <String, dynamic>{
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
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5.0, horizontal: 30),
                                  child: Text(
                                    'Support',
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
                        // Padding(
                        //   padding: const EdgeInsets.only(right: 15),
                        //   child: Text(
                        //     formattedDifference,
                        //     style: Theme.of(context)
                        //         .textTheme
                        //         .bodyMedium
                        //         ?.copyWith(color: textColor.withValues(alpha: 0.4)),
                        //   ),
                        // )
                      ],
                    ),
                  if (widget.isHome == false)
                    Container(
                      color: backgroundcolorinterface,
                      height: 7,
                    ),
                ],
              ),
            ),
          );
  }

  String formatDuration(Duration difference) {
    if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'd ago' : 'd ago'}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hr ago' : 'hrs ago'}';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'min ago' : 'mins ago'}';
    } else {
      return 'just now';
    }
  }

  void _sharePost() {
    String message =
        'Have a look at ${widget.donation.user?.username ?? 'Business Bosses'}\'s donation post on Business Bosses\n'
        'https://businessbosses.onelink.me/xLWk/36a2ff16';
    logEvent(widget.donation.id, 'donation');
    widget.donation.user?.uid != profileController.myProfile.uid
        ? socialShare(message)
        : showModalBottomSheet(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            context: context,
            backgroundColor: Colors.white,
            builder: (BuildContext context) => Padding(
              padding: const EdgeInsets.all(15.0),
              child: SizedBox(
                height: 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => Get.toNamed(
                        Routes.createPost,
                        arguments: <String, dynamic>{
                          'sharemessage': 'Hey there! Support this donation',
                          'title': widget.donation.title,
                          'donationdata': widget.donation,
                        },
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Row(
                          children: <Widget>[
                            SvgPicture.asset(
                              'assets/svgs/text.svg',
                              color: textColor,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              'Post on Business Bosses',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 1,
                      color: backgroundColor,
                    ),
                    GestureDetector(
                      onTap: () {
                        String message =
                            'Have a look at ${widget.donation.user?.username ?? 'Business Bosses'}\'s donation post on Business Bosses\n'
                            'https://businessbosses.onelink.me/xLWk/36a2ff16';
                        logEvent(widget.donation.id, 'donation');
                        socialShare(message);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Row(
                          children: <Widget>[
                            SvgPicture.asset(
                              'assets/svgs/share.svg',
                              color: textColor,
                              height: 16,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              'Share',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }

  String formatCount(int count) {
    if (count >= 1000) {
      double countInK = count / 1000;
      if (countInK >= 1000) {
        return '${(countInK / 1000).toStringAsFixed(1)}m';
      } else {
        return '${countInK.toStringAsFixed(1)}k';
      }
    } else {
      return count.toString();
    }
  }
}
