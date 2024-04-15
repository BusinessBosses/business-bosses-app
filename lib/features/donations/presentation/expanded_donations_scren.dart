import 'package:business_bosses_v2/action/action.dart';
import 'package:business_bosses_v2/common/widgets/typography/text_widget.dart';
import 'package:business_bosses_v2/features/donations/models/donations_model.dart';
import 'package:business_bosses_v2/features/donations/widgets/supporteritem.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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

  @override
  void initState() {
    super.initState();
    // Initialize data or perform any other necessary setup
  }

  @override
  Widget build(BuildContext context) {
    String ytUrl = 'https://www.youtube.com/watch?v=3gm6eBtWfi4';
    ScrollController scrollController = ScrollController();

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
            'Donation',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
          actions: [
            Padding(
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
                                    child: widget.donation.user?.isSubscribed ==
                                            true
                                        ? Row(
                                            children: <Widget>[
                                              const TextWidget(
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
                                        : const TextWidget(
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
              ),
            )
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Stack(children: [
                    Container(
                      color: Colors.black,
                      height: 300,
                    ),
                    Stack(children: [
                      Container(
                        margin: const EdgeInsets.only(
                            top: 250, left: 15, right: 15, bottom: 50),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 30),
                        decoration: BoxDecoration(
                            boxShadow: const [
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
                          children: [
                            Text(
                              widget.donation.title!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 17),
                            ),
                            const SizedBox(
                              height: 20,
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
                                  style: TextStyle(
                                      fontSize: 10, color: subtextColor),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: const LinearProgressIndicator(
                                value: 0.4,
                                minHeight: 4,
                                backgroundColor: backgroundcolorinterface,
                                valueColor: AlwaysStoppedAnimation<Color>(
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
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            const SupporterItem());
                                  },
                                  child: Column(
                                    children: [
                                      Wrap(
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
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
                                                fontSize: 10,
                                                color: subtextColor),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        color: Colors.black54,
                                        height: 1,
                                        width: 70,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),

                            ///for when goal has been reached
                            // Wrap(
                            //   crossAxisAlignment: WrapCrossAlignment.center,
                            //   children: [
                            //   SvgPicture.asset('assets/svgs/completed.svg', height: 20,),
                            //   const SizedBox(width: 5,),
                            //   const Text('Goal Reached'),
                            // ],),

                            /// for when its your own post
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     GestureDetector(
                            //       onTap: () {},
                            //       child: Container(
                            //         padding: EdgeInsets.symmetric(
                            //             horizontal: 20, vertical: 10),
                            //         decoration: BoxDecoration(
                            //             border: Border.all(
                            //                 width: 2, color: Colors.grey),
                            //             borderRadius:
                            //                 BorderRadius.circular(10)),
                            //         child: Wrap(
                            //           crossAxisAlignment:
                            //               WrapCrossAlignment.center,
                            //           children: [
                            //             Text('Edit'),
                            //             SizedBox(
                            //               width: 5,
                            //             ),
                            //             SvgPicture.asset(
                            //               'assets/svgs/edit.svg',
                            //               color: subtextColor,
                            //             )
                            //           ],
                            //         ),
                            //       ),
                            //     ),
                            //     GestureDetector(
                            //       onTap: () {},
                            //       child: Container(
                            //         padding: EdgeInsets.symmetric(
                            //             horizontal: 20, vertical: 10),
                            //         decoration: BoxDecoration(
                            //             border: Border.all(
                            //                 width: 2, color: Colors.grey),
                            //             borderRadius:
                            //                 BorderRadius.circular(10)),
                            //         child: Wrap(
                            //           crossAxisAlignment:
                            //               WrapCrossAlignment.center,
                            //           children: [
                            //             Text('Boost'),
                            //             SizedBox(
                            //               width: 5,
                            //             ),
                            //             SvgPicture.asset(
                            //               'assets/svgs/rocket.svg',
                            //               height: 20,
                            //               color: subtextColor,
                            //             )
                            //           ],
                            //         ),
                            //       ),
                            //     ),
                            //     GestureDetector(
                            //       onTap: () {},
                            //       child: Container(
                            //         padding: EdgeInsets.symmetric(
                            //             horizontal: 20, vertical: 10),
                            //         decoration: BoxDecoration(
                            //             border: Border.all(
                            //                 width: 2, color: Colors.grey),
                            //             borderRadius:
                            //                 BorderRadius.circular(10)),
                            //         child: Wrap(
                            //           crossAxisAlignment:
                            //               WrapCrossAlignment.center,
                            //           children: [
                            //             Text('Share'),
                            //             SizedBox(
                            //               width: 5,
                            //             ),
                            //             SvgPicture.asset(
                            //               'assets/svgs/share.svg',
                            //               color: subtextColor,
                            //             )
                            //           ],
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // ),

                            /// for when its somesones post
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                      color: backgroundColor,
                                      borderRadius: BorderRadius.circular(10)),
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
                                  child: Stack(children: [
                                    TextFormField(
                                      // controller: _priceController,
                                      // onChanged: (String val) => price = val,

                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.number,

                                      decoration: inputDecoration.copyWith(
                                          hintText: 'Enter Amount',
                                          fillColor: backgroundColor),
                                    ),
                                    Positioned(
                                        top: 20,
                                        bottom: 0,
                                        right: 10,
                                        child: Text(
                                          '/${widget.donation.targetAmount.toString()} Coin target',
                                          style: TextStyle(
                                              color: textColor.withAlpha(100)),
                                        ))
                                  ]),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            )
                          ],
                        ),
                      ),
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
                                onPressed: () {},
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      'Donate' ?? 'Claim Amount',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            )),
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
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Story',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 18),
                            ),
                            Text(
                              'Posted 5 days ago',
                              style: TextStyle(color: subtextColor),
                            )
                          ],
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
                  children: [
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
                        children: [
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
                              'Views',
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
                            // onTap: () => _sharePost(),
                            child: Row(
                              children: [
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
}
