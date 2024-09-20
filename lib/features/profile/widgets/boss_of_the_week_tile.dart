import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/common/widgets/popup/bossup_challenge_popuphome.dart';
import 'package:business_bosses_v2/features/moreinfoscreens/bossuppartner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../action/action.dart';
import '../../../common/widgets/network_image_with_placeholder.dart';
import '../../../navigation/routes.dart';
import '../../../services/api_service.dart';
import '../../../utils/theme/theme.dart';
import '../controller/profile_controller.dart';
import '../../home/controller/home_controller.dart';

// final GlobalKey<NavigatorState> connectbuttonkey = GlobalKey<NavigatorState>();

/// BOSS OF THE WEEK HOMEPAGE TILE
class BossOfWeekProfileTile extends StatefulWidget {
// Add this line
  final bool? isForyou;
  const BossOfWeekProfileTile({Key? key, this.isForyou}) : super(key: key);

  @override
  State<BossOfWeekProfileTile> createState() => _BossOfWeekProfileTileState();
}

class _BossOfWeekProfileTileState extends State<BossOfWeekProfileTile> {
  int a = 0;
  String? companyurl;
  bool connectedbutton = true;
  final ProfileController _profileController = Get.find();
  late UserModel? user;
  final HomeController homeController = Get.find();
  late Color startColor;
  final List<Color> startColors = <Color>[backgroundColor];

  Future<void> onRefer(UserModel publicUser) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircularProgressIndicator(),
            ],
          ),
        );
      },
    );
    final ApiResponseModel res = await ApiService.get(
        path: '/connection/connecteds/referals/${publicUser.uid}');
    Get.back();

    if (res.success) {
      if (res.data.isEmpty) {
        String message =
            'Have a look at ${publicUser.username}\'s profile on Business Bosses\n'
            'https://businessbosses.onelink.me/xLWk/36a2ff16';
        logEvent(publicUser.uid, 'user');
        socialShare(message);
      } else {
        Get.toNamed(
          Routes.referscreen,
          arguments: <String, dynamic>{'user': publicUser},
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    startColor = startColors[0];
    user = homeController.bossOfTheWeek;
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> quotes = <Map<String, dynamic>>[
      <String, dynamic>{
        'by': 'Napoleon Hill',
        'message': 'A goal is a dream with a deadline.',
      }
    ];
    // if (widget.isForyou == true) return Text('data');
    return Container(
      width: double.infinity,
      color: widget.isForyou == true ? backgroundColor : Colors.white,
      child: user != null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      children: <Widget>[
                        if (widget.isForyou == true)
                          CircleAvatar(
                            radius: 48 / 3,
                            backgroundColor: primaryColorLT.withOpacity(0.1),
                            child: SvgPicture.asset(
                              'assets/app/app_icon_only.svg',
                            ),
                          ),
                        if (widget.isForyou == true)
                          const SizedBox(
                            width: 10,
                          ),
                        const Text(
                          'Boss of the week',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 18),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  const BossUpChallangePopUpHome(),
                            );
                          },
                          child: Container(
                            color: Colors.transparent,
                            width: 50,
                            height: 50,
                            child: SvgPicture.asset(
                              'assets/svgs/more.svg',
                              height: 20,
                              fit: BoxFit.none,
                              alignment: Alignment.centerRight,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                widget.isForyou == true
                    ? Align(
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.publicProfile, arguments: user);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            width: double.infinity,
                            child: Row(
                              children: <Widget>[
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: (() {
                                        Get.toNamed(Routes.publicProfile,
                                            arguments: user);
                                      }),
                                      child: SizedBox(
                                        height: 90.0,
                                        width: 90.0,
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(1000),
                                            child: user?.photoUrl != null
                                                ? NetworkImageWithPlaceHolder(
                                                    imageUrl: user?.photoUrl,
                                                    height: 90.0,
                                                    width: 90.0,
                                                    radius: radius,
                                                    placeHolder: Icons.person,
                                                    iconSize: 64.0,
                                                  )
                                                : const CircleAvatar(
                                                    radius: 50,
                                                    backgroundImage: AssetImage(
                                                        'assets/images/bb_avatar.jpg'),
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (user?.isRanked ?? false)
                                      Positioned(
                                        right: 7.0,
                                        bottom: -3.0,
                                        child: Container(
                                          height: 32,
                                          width: 32,
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                            // ignore: prefer_const_literals_to_create_immutables
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(width: 20.0),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      if (user?.category == null &&
                                          user?.companyName == null &&
                                          user?.location == null)
                                        const SizedBox(height: 12.0),
                                      user?.isSubscribed == true
                                          ? Row(
                                              children: <Widget>[
                                                Text(
                                                    user?.name != null &&
                                                            user!.name!
                                                                    .length <=
                                                                20
                                                        ? user!.name!
                                                        : user?.name != null
                                                            ? '${user!.name!.substring(0, 20)}...'
                                                            : '',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )),
                                                const SizedBox(width: 5),
                                                SvgPicture.asset(
                                                  'assets/svgs/premiumbadge.svg',
                                                  height: 9,
                                                  color: primaryColorLT,
                                                )
                                              ],
                                            )
                                          : Text(
                                              user?.name != null &&
                                                      user!.name!.length <= 20
                                                  ? user!.name!
                                                  : user?.name != null
                                                      ? '${user!.name!.substring(0, 20)}...'
                                                      : '',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              )),
                                      user?.bio == null
                                          ? Container()
                                          : Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  user!.bio.toString(),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    color: subtextColor,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      child:
                                                          outlineButtonHeader(
                                                              () {
                                                        onRefer(user!);
                                                      }),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: const DecorationImage(
                              image: AssetImage(
                                  'assets/images/bossoftheweekback.png'), // Replace with your image path
                              fit: BoxFit
                                  .cover, // Adjust the image to cover the entire container
                            ),
                          ),
                          child: Align(
                            child: GestureDetector(
                              onTap: () {
                                Get.toNamed(Routes.publicProfile,
                                    arguments: user);
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.transparent,
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          if (user?.category == null &&
                                              user?.companyName == null &&
                                              user?.location == null)
                                            const SizedBox(height: 12.0),
                                          user?.isSubscribed == true
                                              ? Row(
                                                  children: <Widget>[
                                                    Text(
                                                        user?.name != null &&
                                                                user!.name!
                                                                        .length <=
                                                                    20
                                                            ? user!.name!
                                                            : user?.name != null
                                                                ? '${user!.name!.substring(0, 20)}...'
                                                                : '',
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white)),
                                                    const SizedBox(width: 5),
                                                    SvgPicture.asset(
                                                      'assets/svgs/premiumbadge.svg',
                                                      height: 9,
                                                      // ignore: deprecated_member_use
                                                      color: primaryColorLT,
                                                    )
                                                  ],
                                                )
                                              : Text(
                                                  user?.name != null &&
                                                          user!.name!.length <=
                                                              20
                                                      ? user!.name!
                                                      : user?.name != null
                                                          ? '${user!.name!.substring(0, 20)}...'
                                                          : '',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white)),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          user?.bio == null
                                              ? Container()
                                              : Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      user!.bio.toString(),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                          child:
                                                              outlineButtonHeader(
                                                                  () {
                                                            onRefer(user!);
                                                          }),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 10.0),
                                    Stack(
                                      clipBehavior: Clip.none,
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: (() {
                                            Get.toNamed(Routes.publicProfile,
                                                arguments: user);
                                          }),
                                          child: SizedBox(
                                            height: 90.0,
                                            width: 90.0,
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(1000),
                                                child: user?.photoUrl != null
                                                    ? NetworkImageWithPlaceHolder(
                                                        imageUrl:
                                                            user?.photoUrl,
                                                        height: 90.0,
                                                        width: 90.0,
                                                        radius: radius,
                                                        placeHolder:
                                                            Icons.person,
                                                        iconSize: 64.0,
                                                      )
                                                    : const CircleAvatar(
                                                        radius: 50,
                                                        backgroundImage: AssetImage(
                                                            'assets/images/bb_avatar.jpg'),
                                                      ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        if (user?.isRanked ?? false)
                                          Positioned(
                                            right: 7.0,
                                            bottom: -3.0,
                                            child: Container(
                                              height: 32,
                                              width: 32,
                                              decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                                // ignore: prefer_const_literals_to_create_immutables
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(const Bossuppartner());
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              const Text(
                                'Deals',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 18),
                              ),
                              Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: <Widget>[
                                    const Text(
                                      'View all',
                                      style: TextStyle(fontSize: 11),
                                    ),
                                    const SizedBox(width: 5.0),
                                    SvgPicture.asset(
                                      'assets/svgs/nexticon.svg',
                                      // ignore: deprecated_member_use
                                      color: textColor,
                                      height: 8,
                                    ),
                                  ]),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: homeController.bossUp!.reversed
                                .toList()
                                .map((Map<String, dynamic> item) {
                              final Color startColor = startColors[
                                  homeController.bossUp!.indexOf(item) %
                                      startColors.length];
                              return widget.isForyou == true
                                  ? LayoutBuilder(
                                      builder: (BuildContext context,
                                          BoxConstraints constraints) {
                                        return GestureDetector(
                                          onTap: () async {
                                            final Uri companyUrl =
                                                Uri.parse(item['companyUrl']);
                                            if (!await launchUrl(companyUrl)) {
                                              throw Exception(
                                                  'Could not launch $companyUrl');
                                            }
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                4,
                                            margin: const EdgeInsets.only(
                                                left: 10.0),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: startColor,
                                                width: 1.0,
                                              ),
                                              gradient: LinearGradient(
                                                colors: <Color>[
                                                  startColor,
                                                  backgroundColor
                                                ],
                                                begin: Alignment.topRight,
                                                end: Alignment.bottomLeft,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0,
                                                          right: 8,
                                                          top: 8,
                                                          bottom: 5),
                                                  child: SizedBox(
                                                    height: 35.0,
                                                    width: 35.0,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 0.5,
                                                            color:
                                                                Colors.black12),
                                                        color: backgroundColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    100.0),
                                                      ),
                                                      child:
                                                          NetworkImageWithPlaceHolder(
                                                        imageUrl: item[
                                                                'companyPhoto'] ??
                                                            '',
                                                        radius: 200,
                                                        placeHolder:
                                                            Icons.person,
                                                        iconSize: 15.0,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 3,
                                                ),
                                                Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 8.0,
                                                    ),
                                                    child: Column(
                                                      children: <Widget>[
                                                        Text(
                                                          item['companyName'],
                                                          textAlign:
                                                              TextAlign.left,
                                                          maxLines: 2,
                                                          style:
                                                              const TextStyle(
                                                            color: textColor,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis, // Add this line to handle overflow
                                                        ),
                                                      ],
                                                    )),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: SizedBox(
                                                    width: double.infinity,
                                                    child: Wrap(
                                                        crossAxisAlignment:
                                                            WrapCrossAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Container(
                                                            decoration:
                                                                const BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    shape: BoxShape
                                                                        .circle),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4),
                                                            child: SvgPicture
                                                                .asset(
                                                              'assets/svgs/upicon.svg',
                                                              color: const Color(
                                                                  0xFF0F132D),
                                                              height: 8,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          const Text(
                                                            'Learn more',
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                color:
                                                                    textColor),
                                                          ),
                                                        ]),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : LayoutBuilder(
                                      builder: (BuildContext context,
                                          BoxConstraints constraints) {
                                        return GestureDetector(
                                          onTap: () async {
                                            final Uri companyUrl =
                                                Uri.parse(item['companyUrl']);
                                            if (!await launchUrl(companyUrl)) {
                                              throw Exception(
                                                  'Could not launch $companyUrl');
                                            }
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.5,
                                            height: 120,
                                            margin: const EdgeInsets.only(
                                                left: 15.0),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.black12,
                                                width: 0.5,
                                              ),
                                              gradient: LinearGradient(
                                                colors: <Color>[
                                                  startColor,
                                                  Colors.white
                                                ],
                                                begin: Alignment.topRight,
                                                end: Alignment.bottomLeft,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 10,
                                                                right: 10,
                                                                top: 10,
                                                                bottom: 5),
                                                        child: SizedBox(
                                                          height: 68.0,
                                                          width: 68.0,
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border.all(
                                                                  width: 0.5,
                                                                  color: Colors
                                                                      .black12),
                                                              color:
                                                                  backgroundColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                            ),
                                                            child:
                                                                NetworkImageWithPlaceHolder(
                                                              imageUrl: item[
                                                                      'companyPhoto'] ??
                                                                  '',
                                                              radius: 10,
                                                              placeHolder:
                                                                  Icons.person,
                                                              iconSize: 15.0,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 10.0),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Text(
                                                                item[
                                                                    'companyName'],
                                                                softWrap: true,
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                maxLines: 1,
                                                                style:
                                                                    const TextStyle(
                                                                  color:
                                                                      textColor,
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                              Text(
                                                                item[
                                                                    'companyDescription'],
                                                                softWrap: true,
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                maxLines: 3,
                                                                style:
                                                                    const TextStyle(
                                                                  color:
                                                                      textColor,
                                                                  fontSize: 12,
                                                                ),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ]),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: SizedBox(
                                                    width: double.infinity,
                                                    child: Wrap(
                                                        crossAxisAlignment:
                                                            WrapCrossAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Container(
                                                            decoration:
                                                                const BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    shape: BoxShape
                                                                        .circle),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4),
                                                            child: SvgPicture
                                                                .asset(
                                                              'assets/svgs/upicon.svg',
                                                              // ignore: deprecated_member_use
                                                              color: const Color(
                                                                  0xFF0F132D),
                                                              height: 8,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          const Text(
                                                            'Learn more',
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                color:
                                                                    textColor),
                                                          ),
                                                        ]),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 7,
                ),
              ],
            )
          : qouteWidget(quotes),
    );
  }

  Widget qouteWidget(List<Map<String, dynamic>> quote) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          "Today's Quote",
          style: TextStyle(
              fontWeight: FontWeight.w900, fontSize: 25, color: primaryColorLT),
        ),
        Container(
          padding:
              const EdgeInsets.only(top: 20.0, bottom: 20, left: 10, right: 10),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                    radius: 48 / 2,
                    backgroundColor: primaryColorLT.withOpacity(0.1),
                    child: SvgPicture.asset(
                      'assets/app/app_icon_only.svg',
                    )),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        quote[0]['by'] ?? 'Brian Tracy',
                        style: bodyText1,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              ' ${quote[0]['message'] ?? "Always give without remembering and always receive without forgetting."}',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget outlineButtonHeader(Function onRefer) {
    return Container(
      height: 50.0,
      padding: const EdgeInsets.all(0.0),
      width: double.infinity,
      child: Row(
        children: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  widget.isForyou == true ? primaryColorLT : Colors.white,
              elevation: 0,
            ),
            onPressed: () async {
              connectToUser();
            },
            child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  Text(
                    user?.connecteds != null &&
                            _profileController.myProfile.connecteds!
                                .contains(user!.uid)
                        ? 'Following'
                        : 'Follow',
                    style: TextStyle(
                        color: widget.isForyou == true
                            ? Colors.white
                            : primaryColorLT),
                  ),
                ]),
          ),
          const SizedBox(
            width: 10,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              elevation: 0,
              side: BorderSide(
                color: widget.isForyou == true ? primaryColorLT : Colors.white,
                width: 1.5,
              ),
            ),
            onPressed: () {
              onRefer();
            },
            child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  Text(
                    'Refer',
                    style: TextStyle(
                        color: widget.isForyou == true
                            ? primaryColorLT
                            : Colors.white),
                  ),
                ]),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }

  void connectToUser() async {
    final int checkConnected = _profileController.myProfile.connecteds == null
        ? -1
        : _profileController.myProfile.connecteds!
            .indexWhere((String element) => element == user?.uid);
    if (checkConnected == -1) {
      _profileController.updateConnections(user!.uid);
      setState(() {
        user = UserModel.fromMap(<dynamic, dynamic>{
          ...user!.toMap(),
          'connectionCount':
              user?.connectionCount == null ? 1 : user!.connectionCount! + 1
        });
      });
      await connect(user!.uid);
    } else {
      _profileController.updateConnections(user!.uid);

      setState(() {
        user = UserModel.fromMap(<dynamic, dynamic>{
          ...user!.toMap(),
          'connectionCount':
              user?.connectionCount == null ? null : user!.connectionCount! - 1
        });
      });
      // connecteds.removeAt(checkConnected);
      await disconnect(user!.uid);
    }
  }

  void updateReferals(int refs) {
    user = UserModel.fromMap(<dynamic, dynamic>{
      ...user!.toMap(),
      'referalCount':
          user?.referals == null ? refs : user!.referals!.length + refs
    });
    setState(() {});
  }

  Future<void> disconnect(String userId) async {
    ApiService.post(path: '/connection/disconnect', body: <String, dynamic>{
      'userId': _profileController.myProfile.uid,
      'connectedId': userId,
      'timestamp': DateTime.now().millisecondsSinceEpoch
    });
    setState(() {
      homeController.bossOfTheWeek?.connecteds?.removeWhere(
          (String string) => string == _profileController.myProfile.uid);

      user?.connecteds?.removeWhere(
          (String string) => string == _profileController.myProfile.uid);
    });
  }

  Future<void> connect(String userId) async {
    ApiService.post(path: '/connection/connect', body: <String, dynamic>{
      'userId': _profileController.myProfile.uid,
      'connectedId': userId,
      'timestamp': DateTime.now().millisecondsSinceEpoch
    });
    setState(() {
      homeController.bossOfTheWeek?.connecteds
          ?.add(_profileController.myProfile.uid);

      user?.connecteds?.add(_profileController.myProfile.uid);
    });
  }

  void _share() {
    String message =
        'Have a look at ${user?.username}\'s profile on Business Bosses\n'
        'https://businessbosses.onelink.me/xLWk/36a2ff16';
    logEvent(user?.uid, 'user');
    socialShare(message);
  }
}
