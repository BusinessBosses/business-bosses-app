import 'package:business_bosses_v2/action/action.dart';
import 'package:business_bosses_v2/common/models/comment_model.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/common/widgets/typography/text_widget.dart';
import 'package:business_bosses_v2/features/chat/chat_room_screen.dart';
import 'package:business_bosses_v2/features/donations/controller/donations_controller.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/market_controller.dart';
import 'package:business_bosses_v2/features/marketplace/models/market_model.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/seller_reviews.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/post_images_market.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/post_like_comment.dart';
import 'package:business_bosses_v2/features/posts/widgets/images_viewer_screen.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class ExpandedMarketplaceScreen extends StatefulWidget {
  final MarketModel market;
  static const String routeName = '/expandedMarketplacescreen';

  const ExpandedMarketplaceScreen({
    Key? key,
    required this.market,
  }) : super(key: key);

  @override
  _ExpandedMarketplaceScreenState createState() =>
      _ExpandedMarketplaceScreenState();
}

class _ExpandedMarketplaceScreenState extends State<ExpandedMarketplaceScreen> {
  String? description;
  bool isLoading = false;
  final DonationsController donationsController = Get.find();
  final ProfileController profileController = Get.find();
  final TextEditingController _priceController = TextEditingController();
  final MarketController _marketController = Get.find();

  NumberFormat formatter = NumberFormat.compact();

  @override
  void initState() {
    super.initState();
    // Initialize data or perform any other necessary setup
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

  @override
  Widget build(BuildContext context) {
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
          '',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
        actions: <Widget>[
          widget.market.user!.uid == profileController.myProfile.uid
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
                                              color:
                                                  Colors.black.withOpacity(.6),
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
                                                  // print(widget.market.user.uid);
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
                                            widget.market.user?.isSubscribed ==
                                                    true
                                                ? Row(
                                                    children: <Widget>[
                                                      TextWidget(
                                                        text:
                                                            'Block @${widget.market.user?.name}',
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
                                                        'Block @${widget.market.user?.name}',
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
                                              color:
                                                  Colors.black.withOpacity(.6),
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
                    child: GestureDetector(
                      onTap: () {
                        widget.market.images == null
                            ? null
                            : Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ImagesViewerScreen(
                                    urls: widget.market.images,
                                    text: widget.market.description,
                                  ),
                                ),
                              );
                      },
                      child: Container(
                        color: backgroundColor,
                        child: NetworkImageWithPlaceHolder(
                          radius: 0,
                          imageUrl: widget.market.images != null
                              ? widget.market.images![0]
                              : '',
                          width: double.infinity,
                          height: 240.0,
                          fit: BoxFit.cover,
                          placeHolder: Icons.photo,
                          iconSize: 50.0,
                        ),
                      ),
                    )),
              ]),
              Container(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15),
                child: PostImagesMarket(post: widget.market),
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
                            arguments: widget.market.user);
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
                                      borderRadius: BorderRadius.circular(1000),
                                      child: NetworkImageWithPlaceHolder(
                                        imageUrl:
                                            widget.market.user?.photoUrl ?? '',
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
                                  widget.market.user?.name ??
                                      widget.market.user!.username,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700),
                                ),
                                widget.market.user?.isSubscribed == true
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
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    widget.market.userId == profileController.myProfile.uid
                        ? const SizedBox()
                        : Center(
                            child: ElevatedButton(
                              onPressed: () {
                                Get.to(
                                  () => ChatRoomScreen(
                                    frommarketplace: true,
                                    market: widget.market,
                                  ),
                                  arguments: widget.market.user,
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  widget.market.location!.contains('delivery')
                                      ? 'Place Order'
                                      : 'Book Now',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(
                      height: 30,
                    ),

                    Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Price - ${widget.market.price.toString()}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w800, fontSize: 16),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            widget.market.discount.toString() == '0' ||
                                    widget.market.discount == null ||
                                    widget.market.discount == ''
                                ? Container()
                                : Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color:
                                            Colors.greenAccent.withAlpha(80)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0, vertical: 2),
                                      child: Text(
                                        '${widget.market.discount}% off',
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: <Widget>[
                            widget.market.location != null &&
                                    widget.market.category != null
                                ? Row(
                                    children: <Widget>[
                                      widget.market.location!
                                              .contains('delivery')
                                          ? SvgPicture.asset(
                                              'assets/svgs/location.svg')
                                          : const Icon(
                                              Icons.timelapse,
                                              size: 16,
                                              color: subtextColor,
                                            ),
                                      const SizedBox(
                                        width: 1,
                                      ),
                                      Text(
                                        widget.market.location!.length > 50
                                            ? '${widget.market.location!.substring(0, 50)}...'
                                            : widget.market.location!,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16,
                                            color: subtextColor),
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      SvgPicture.asset(
                                          'assets/svgs/category.svg'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        widget.market.category!.length > 50
                                            ? '${widget.market.category!.substring(0, 50)}...'
                                            : widget.market.category!,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16,
                                            color: subtextColor),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                    ],
                                  )
                                : const Row(
                                    children: <Widget>[
                                      SizedBox(),
                                    ],
                                  ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  color: backgroundColor,
                                  borderRadius: BorderRadius.circular(20)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Wrap(children: <Widget>[
                                const Icon(
                                  Icons.star,
                                  color: Color.fromRGBO(255, 202, 40, 1),
                                  size: 16,
                                ),
                                Text(
                                  widget.market.user!.averageRating!
                                      .toStringAsFixed(1),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ]),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.to(() => SellerReviewScreen(
                                    user: widget.market.user!));
                              },
                              child: const Text(
                                'Seller reviews',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      'Description',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                    ),
                    //       const SizedBox(
                    //         height: 20,
                    //       ),
                    // Padding(
                    //       padding: const EdgeInsets.only(right: 15),
                    //       child: Text(
                    //         TimeFormat.formatString(widget.market.timestamp),
                    //         style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    //               color: textColor.withOpacity(0.4),
                    //             ),
                    //       ),
                    //     ),
                    DetectableText(
                      text: widget.market.description,
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
                    //     ],
                    //   ),
                    // ),
                    const SizedBox(
                      height: 200,
                    )
                  ],
                ),
              ),
            ],
          )),
          Positioned(
            bottom: 0,
            child: Container(
                width: MediaQuery.sizeOf(context).width,
                height: 90,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextButton.icon(
                      onPressed: () async {
                        _marketController.like(
                            profileController.myProfile.uid,
                            widget.market.marketId,
                            'market',
                            widget.market.userId);
                        setState(() {});
                      },
                      icon: widget.market.likes
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
                        '${widget.market.likes?.length ?? 0}',
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
                          builder: (BuildContext context) =>
                              PostLikeCommentItem(
                            post: widget.market,
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
                        '${widget.market.comments?.length ?? 0}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: textColor.withOpacity(0.8),
                            ),
                      ),
                    ),
                    widget.market.user!.uid != profileController.myProfile.uid
                        ? TextButton.icon(
                            onPressed: () async {
                              _marketController.coin(
                                profileController.myProfile.uid,
                                widget.market.marketId,
                                profileController,
                                'market',
                                widget.market.user!.uid,
                              );
                              setState(() {});
                            },
                            icon: widget.market.coins?.contains(
                                        profileController.myProfile.uid) ==
                                    true
                                ? SvgPicture.asset(
                                    'assets/svgs/coin.svg',
                                    height: 20,
                                  )
                                : SvgPicture.asset(
                                    'assets/svgs/coin.svg',
                                    height: 20,
                                  ),
                            label: Text(
                              '${widget.market.coins?.length ?? 0}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: textColor.withOpacity(0.8),
                                  ),
                            ),
                          )
                        : Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 10.0),
                            child: Row(
                              children: <Widget>[
                                SvgPicture.asset('assets/svgs/coin.svg'),
                                const SizedBox(width: 5),
                                Text(
                                  '${widget.market.coins?.length ?? 0}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: textColor.withOpacity(0.8),
                                      ),
                                ),
                              ],
                            ),
                          ),
                    TextButton.icon(
                      onPressed: () async {},
                      icon: const Icon(Icons.remove_red_eye_outlined,
                          size: 19, color: Colors.black),
                      label: Text(
                        formatCount(widget.market.views!),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: textColor.withOpacity(0.8),
                            ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Wrap(children: <Widget>[
                      GestureDetector(
                        onTap: () => _sharePost(),
                        child: SvgPicture.asset(
                          'assets/svgs/share.svg',
                          height: 18.0,
                          width: 18.0,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      )
                    ]),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  void _sharePost() {
    String message =
        'Have a look at ${widget.market.user!.username}\'s post on Business Bosses\n'
        'https://vm.businessbosses.co.uk/share/post';
    logEvent(widget.market.marketId, 'marketplace');
    socialShare(message);
  }
}
