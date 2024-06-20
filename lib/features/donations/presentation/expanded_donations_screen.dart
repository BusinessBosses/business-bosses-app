import 'package:business_bosses_v2/action/action.dart';
import 'package:business_bosses_v2/common/models/comment_model.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/common/widgets/typography/text_widget.dart';
import 'package:business_bosses_v2/features/donations/controller/donations_controller.dart';
import 'package:business_bosses_v2/features/donations/models/donations_model.dart';
import 'package:business_bosses_v2/features/donations/presentation/boost_donations_screen.dart';
import 'package:business_bosses_v2/features/donations/presentation/create_donations.dart';
import 'package:business_bosses_v2/features/donations/widgets/donation_comment.dart';
import 'package:business_bosses_v2/features/donations/widgets/supporteritem.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ExpandedDonationScreen extends StatefulWidget {
  final DonationModel donation;
  static const String routeName = '/expandedDonationscreen';

  const ExpandedDonationScreen({
    Key? key,
    required this.donation,
  }) : super(key: key);

  @override
  _ExpandedDonationScreenState createState() => _ExpandedDonationScreenState();
}

class _ExpandedDonationScreenState extends State<ExpandedDonationScreen> {
  String? description;
  bool isLoading = false;
  final DonationsController donationsController = Get.find();
  final ProfileController profileController = Get.find();
  final TextEditingController _priceController = TextEditingController();

  NumberFormat formatter = NumberFormat.compact();

  @override
  void initState() {
    super.initState();
    // Initialize data or perform any other necessary setup
  }

  @override
  Widget build(BuildContext context) {
    int timestampMs = widget.donation.timestamp!;

    // Convert milliseconds to DateTime
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestampMs);

    // Calculate the difference between current time and the timestamp
    Duration difference = DateTime.now().difference(dateTime);

    // Format the duration
    String formattedDifference = formatDuration(difference);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
          ),
          centerTitle: true,
          title: const Text(
            'Crowdfund',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
          actions: <Widget>[
            widget.donation.user!.uid == profileController.myProfile.uid
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: GestureDetector(
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
                                                text:
                                                    'Do you want to block user?',
                                                centralize: true,
                                                fontWeight: FontWeight.w700,
                                                size: 20,
                                              ),
                                              content: TextWidget(
                                                text:
                                                    'You will no longer see Donations, posts and comments from this user on your feed',
                                                centralize: true,
                                                color: Colors.black
                                                    .withOpacity(.6),
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
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      vertical: 7,
                                                      horizontal: 14,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: primaryColorLT,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: const TextWidget(
                                                      text: 'Block',
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                        contentPadding: EdgeInsets.zero,
                                        title: GestureDetector(
                                          child: widget.donation.user
                                                      ?.isSubscribed ==
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
                                                color: Colors.black
                                                    .withOpacity(.6),
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
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      vertical: 7,
                                                      horizontal: 14,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: primaryColorLT,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: const TextWidget(
                                                      text: 'Report',
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                        contentPadding: EdgeInsets.zero,
                                        title: const TextWidget(
                                          text: 'Report this Project',
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
                    ),
                  )
          ],
        ),
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Stack(children: <Widget>[
                    SizedBox(
                      height: 300,
                      width: double.infinity,
                      child: widget.donation.images.isNotEmpty
                          ? NetworkImageWithPlaceHolder(
                              radius: 0, imageUrl: widget.donation.images[0])
                          : const SizedBox(),
                    ),
                    Stack(children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(
                          top: 250,
                          left: 15,
                          right: 15,
                          bottom: 50,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 30,
                        ),
                        decoration: BoxDecoration(
                            boxShadow: const <BoxShadow>[
                              BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset.zero,
                                  blurRadius: 50.0,
                                  spreadRadius: 0.0,
                                  blurStyle: BlurStyle.normal)
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          children: <Widget>[
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Donate To - ${widget.donation.title!}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 17),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(
                                      formatter.format(
                                          widget.donation.amountRecieved),
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: subtextColor,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      widget.donation.amountRecieved == 1
                                          ? ' coin raised'
                                          : ' coins raised',
                                      style: const TextStyle(
                                          fontSize: 12, color: subtextColor),
                                    ),
                                  ],
                                ),
                                Text(
                                  '${((widget.donation.amountRecieved / widget.donation.targetAmount!) * 100).toStringAsFixed(1)}%',
                                  style: const TextStyle(
                                      fontSize: 12, color: subtextColor),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
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
                              children: <Widget>[
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: <Widget>[
                                    SvgPicture.asset(
                                      'assets/svgs/coin.svg',
                                      height: 12,
                                    ),
                                    Text(
                                      formatter.format(
                                          widget.donation.targetAmount!),
                                      style: const TextStyle(
                                          color: subtextColor,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12),
                                    ),
                                    const Text(
                                      ' Target',
                                      style: TextStyle(
                                          color: subtextColor, fontSize: 12),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            SupporterItem(
                                              donation: widget.donation,
                                            ));
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      Wrap(
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            formatter.format(widget
                                                .donation.transactions!.length),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: subtextColor,
                                              fontWeight: FontWeight.w700,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                          Text(
                                            widget.donation.transactions!
                                                        .length ==
                                                    1
                                                ? ' Supporter'
                                                : ' Supporters',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: subtextColor,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),

                            ///for when goal has been reached
                            if (widget.donation.amountRecieved >=
                                widget.donation.targetAmount!)
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: <Widget>[
                                  SvgPicture.asset(
                                    'assets/svgs/completed.svg',
                                    height: 20,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Text('Goal Reached'),
                                ],
                              ),

                            /// for when its your own post
                            (widget.donation.user?.uid ==
                                        profileController.myProfile.uid &&
                                    widget.donation.amountRecieved <
                                        widget.donation.targetAmount!)
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          Get.to(() => CreateDonationScreen(
                                                donation: widget.donation,
                                              ));
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 2, color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Wrap(
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            children: <Widget>[
                                              const Text('Edit'),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              SvgPicture.asset(
                                                'assets/svgs/edit.svg',
                                                color: subtextColor,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      // GestureDetector(
                                      //   onTap: () {
                                      //     Get.to(() => BoostDonation(
                                      //           donationId: widget.donation.id,
                                      //           donationTitle:
                                      //               widget.donation.title!,
                                      //         ));
                                      //   },
                                      //   child: Container(
                                      //     padding: const EdgeInsets.symmetric(
                                      //         horizontal: 20, vertical: 10),
                                      //     decoration: BoxDecoration(
                                      //         border: Border.all(
                                      //             width: 2, color: Colors.grey),
                                      //         borderRadius:
                                      //             BorderRadius.circular(10)),
                                      //     child: Wrap(
                                      //       crossAxisAlignment:
                                      //           WrapCrossAlignment.center,
                                      //       children: <Widget>[
                                      //         const Text('Boost'),
                                      //         const SizedBox(
                                      //           width: 5,
                                      //         ),
                                      //         SvgPicture.asset(
                                      //           'assets/svgs/rocket.svg',
                                      //           height: 20,
                                      //           color: subtextColor,
                                      //         )
                                      //       ],
                                      //     ),
                                      //   ),
                                      // ),
                                      GestureDetector(
                                        onTap: () => _sharePost(),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 2, color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Wrap(
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            children: <Widget>[
                                              const Text('Share'),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              SvgPicture.asset(
                                                'assets/svgs/share.svg',
                                                color: subtextColor,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox(
                                    height: 20,
                                  ),

                            /// for when its somesones post
                            if (widget.donation.user?.uid !=
                                    profileController.myProfile.uid &&
                                widget.donation.amountRecieved <
                                    widget.donation.targetAmount!)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                        color: backgroundColor,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: SvgPicture.asset(
                                        'assets/svgs/coin.svg',
                                        height: 30),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    flex:
                                        6, // Adjust the flex value to control the relative sizes
                                    child: Stack(children: <Widget>[
                                      TextFormField(
                                        controller: _priceController,
                                        maxLength: 7,
                                        // onChanged: (String val) => price = val,

                                        textInputAction: TextInputAction.next,
                                        keyboardType: TextInputType.number,

                                        decoration: inputDecoration.copyWith(
                                            hintText: 'Enter Amount',
                                            counterText: '',
                                            fillColor: backgroundColor),
                                      ),
                                      Positioned(
                                          top: 20,
                                          bottom: 0,
                                          right: 10,
                                          child: Text(
                                            '/${formatter.format(widget.donation.targetAmount)} Coin target',
                                            style: TextStyle(
                                                color:
                                                    textColor.withAlpha(100)),
                                          ))
                                    ]),
                                  ),
                                ],
                              ),
                            (widget.donation.user?.uid ==
                                    profileController.myProfile.uid)
                                ? const SizedBox(height: 10)
                                : const SizedBox(
                                    height: 30,
                                  )
                          ],
                        ),
                      ),
                      if (widget.donation.user?.uid !=
                              profileController.myProfile.uid &&
                          widget.donation.amountRecieved <
                              widget.donation.targetAmount!)
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 25,
                          child: Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(150, 45)),
                                onPressed: () async {
                                  if (int.tryParse(_priceController.text) ==
                                      null) {
                                    Get.snackbar(
                                      'Error',
                                      'Invalid Amount',
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                    return;
                                  }
                                  if ((int.tryParse(_priceController.text)! >
                                      profileController
                                          .myProfile.coinscount!)) {
                                    Get.snackbar(
                                      'Error',
                                      'You do not have sufficient coins to donate',
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                    return;
                                  }

                                  setState(() {
                                    isLoading = true;
                                  });
                                  DateTime now = DateTime.now();

                                  // Format the date and time
                                  String formattedDateTime =
                                      DateFormat('yyyy-MM-dd HH:mm:ss')
                                          .format(now);

                                  Map<String, dynamic> data = <String, dynamic>{
                                    'userId': profileController.myProfile.uid,
                                    'donationId': widget.donation.id,
                                    'date': formattedDateTime,
                                    'amount': _priceController.text
                                  };
                                  final bool response =
                                      await donationsController
                                          .contributeDonation(
                                              data, widget.donation.id);
                                  if (response) {
                                    Get.snackbar(
                                        'Success', 'Donation Successful',
                                        backgroundColor: Colors.green,
                                        colorText: Colors.white);
                                    // ignore: use_build_context_synchronously
                                    Navigator.of(context).pop();
                                  } else {
                                    Get.snackbar('Error',
                                        'There\'s an error while trying to donate',
                                        backgroundColor: Colors.red,
                                        colorText: Colors.white);
                                  }
                                  setState(() {
                                    isLoading = false;
                                  });
                                },
                                child:
                                    isLoading // Conditional widget to show loader or donate text
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                                color: Colors.white),
                                          ) // Show loader when _isLoading is true
                                        : const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text(
                                                'Donate',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                              ),
                            ),
                          ),
                        ),
                      if (widget.donation.user?.uid ==
                              profileController.myProfile.uid &&
                          widget.donation.amountRecieved >=
                              widget.donation.targetAmount! &&
                          (widget.donation.isCashoutApproved != null &&
                              !widget.donation.isCashoutApproved!))
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 25,
                          child: Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(150, 45)),
                                onPressed: () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  donationsController
                                      .claimAmount(widget.donation);
                                  setState(() {
                                    isLoading = false;
                                  });
                                },
                                child:
                                    isLoading // Conditional widget to show loader or donate text
                                        ? const CircularProgressIndicator(
                                            color: Colors
                                                .white) // Show loader when _isLoading is true
                                        : const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text(
                                                'Claim Amount',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                              ),
                            ),
                          ),
                        )
                    ])
                  ]),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    color: backgroundColor,
                    height: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.publicProfile,
                                arguments: widget.donation.user);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 30.0,
                                      width: 30.0,
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
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                    widget.donation.user?.isSubscribed == true
                                        ? Wrap(children: <Widget>[
                                            const SizedBox(width: 5),
                                            SvgPicture.asset(
                                              'assets/svgs/premiumbadge.svg',
                                              height: 9,
                                              color: primaryColorLT,
                                            )
                                          ])
                                        : Container()
                                  ]),
                              Text(
                                formattedDifference,
                                style: const TextStyle(color: subtextColor),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        const Text(
                          'Story',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 18),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          widget.donation.description!,
                          style: const TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 200,
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: MediaQuery.sizeOf(context).width,
                height: 90,
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 1,
                      width: MediaQuery.of(context).size.width,
                      color: backgroundcolorinterface,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              formatter.format(widget.donation.likes!.length),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: textColor.withOpacity(0.8),
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
                              formatter
                                  .format(widget.donation.comments?.length),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
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
                              formatter.format(widget.donation.views),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: textColor.withOpacity(0.8),
                                  ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _sharePost(),
                            child: Row(
                              children: <Widget>[
                                SvgPicture.asset(
                                  'assets/svgs/share.svg',
                                  height: 15.0,
                                  width: 15.0,
                                  color: textColor.withOpacity(1.0),
                                ),
                                const SizedBox(
                                  width: 15,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
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
                  children: [
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
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Row(
                          children: [
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
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/svgs/share.svg',
                              color: textColor,
                              height: 16,
                            ),
                            SizedBox(
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
}
