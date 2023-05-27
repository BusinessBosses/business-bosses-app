import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../action/action.dart';
import '../../../common/widgets/buttons/my_outlined_button.dart';
import '../../../common/widgets/network_image_with_placeholder.dart';
import '../../../common/widgets/popup/bossup_challenge_popup.dart';
import '../../../navigation/routes.dart';
import '../../../services/api_service.dart';
import '../../../utils/theme/theme.dart';
import '../../moreinfoscreens/bossuppartner.dart';
import '../controller/profile_controller.dart';

/// BOSS OF THE WEEK HOMEPAGE TILE
class BossOfWeekProfileTile extends StatefulWidget {
  final UserModel user;
  final UserModel myProfile;

  /// BOSS OF THE WEEK PROFILE
  const BossOfWeekProfileTile(this.user, {Key? key, required this.myProfile})
      : super(key: key);

  @override
  State<BossOfWeekProfileTile> createState() => _BossOfWeekProfileTileState();
}

class _BossOfWeekProfileTileState extends State<BossOfWeekProfileTile> {
  int a = 0;
  String? companyurl;
  bool connectedbutton = true;
  final ProfileController _profileController = Get.find();
  late UserModel user;

  @override
  void initState() {
    super.initState();
    user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> quotes = <Map<String, dynamic>>[
      <String, dynamic>{
        'by': 'Napoleon Hill',
        'message': 'A goal is a dream with a deadline.',
      }
    ];
    return GestureDetector(
      onTap: () {},
      child: Container(
          width: double.infinity,
          color: backgroundcolorinterface,
          padding: const EdgeInsets.only(
              top: 0.0, bottom: 15.0, left: 15, right: 15),
          child: user.isRanked == true
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 48 / 3,
                            backgroundColor: primaryColorLT.withOpacity(0.1),
                            child: SvgPicture.asset(
                              'assets/app/app_icon_only.svg',
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            'Boss of the week',
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 25,
                                color: Color(0xff333333)),
                          ),
                          Expanded(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                  child: Container(
                                      color: Colors.transparent,
                                      width: 50,
                                      height: 50,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: SvgPicture.asset(
                                          'assets/svgs/more.svg',
                                          height: 20,
                                          fit: BoxFit.none,
                                        ),
                                      )),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          const BossUpChallangePopUpcopy(),
                                    );
                                  })
                            ],
                          ))
                        ],
                      ),
                    ),
                    Align(
                      child: Container(
                        padding: const EdgeInsets.only(
                            top: 3.0, bottom: 0, left: 0, right: 0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.transparent,
                        ),
                        child: Row(
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                GestureDetector(
                                  onTap: (() {}),
                                  child: SizedBox(
                                    height: 90.0,
                                    width: 90.0,
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(1000),
                                        child: user.photoUrl != null
                                            ? NetworkImageWithPlaceHolder(
                                                imageUrl: user.photoUrl,
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
                                if (user.isRanked ?? false)
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (user.category == null &&
                                      user.companyName == null &&
                                      user.location == null)
                                    const SizedBox(height: 12.0),
                                  Text(user.name ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  if (user.category != null)
                                    Text(user.category.toString(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        )),
                                  user.bio == null
                                      ? Container()
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              user.bio.toString(),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: subtextColor,
                                                fontSize: 13,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: outlineButtonHeader(),
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
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const Bossuppartner()),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15, top: 5),
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4F4F4),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 20,
                                blurRadius: 500,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 10,
                                ),
                                child: Container(
                                  height: 25,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEAEAEA),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(2),
                                      child: Text('Boss Up by'),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Partner',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : qouteWidget(quotes)),
    );
  }

  Widget qouteWidget(List<Map<String, dynamic>> quote) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              children: [
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
                    children: [
                      Text(
                        quote[0]['by'] ?? 'Brian Tracy',
                        style: bodyText1,
                      ),
                      Row(
                        children: [
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

  Widget outlineButtonHeader() {
    return Container(
      height: 50.0,
      padding: const EdgeInsets.all(0.0),
      width: double.infinity,
      child: Row(
        children: [
          MCustomButton(
              buttonType: connectedbutton == true
                  ? ButtonType.outline
                  : ButtonType.elevated,
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: FittedBox(
                child: widget.myProfile.connecteds != null &&
                        widget.myProfile.connecteds!.contains(user.uid)
                    ? const Text(
                        'Connected',
                        style: TextStyle(color: primaryColorLT),
                      )
                    : const Text(
                        'Connect',
                        style: TextStyle(color: primaryColorLT),
                      ),
              ),
              onPressed: () async {
                connectToUser();
              }),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: MCustomButton(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                onPressed: () async {
                  Get.toNamed(Routes.referscreen, arguments: {
                    'user': user,
                    'onRefer': (refs) {
                      updateReferals(refs);
                    }
                  });
                },
                child: const Text('Refer')),
          ),
        ],
      ),
    );
  }

  void _navigateTo(BuildContext context, {String? routeName, var argument}) {
    if (routeName != null) {
      Navigator.of(context).pushNamed(routeName, arguments: argument);
    } else {
      Navigator.of(context).pop();
    }
  }

  void _sharePost(dynamic message) {
    socialShare(message);
  }

  void connectToUser() async {
    final int checkConnected = widget.myProfile.connecteds == null
        ? -1
        : widget.myProfile.connecteds!
            .indexWhere((String element) => element == user.uid);
    if (checkConnected == -1) {
      _profileController.updateConnections(user.uid);
      setState(() {
        user = UserModel.fromMap({
          ...user.toMap(),
          'connectionCount':
              user.connectionCount == null ? 1 : user.connectionCount! + 1
        });
      });
      await connect(user.uid);
    } else {
      _profileController.updateConnections(user.uid);

      setState(() {
        user = UserModel.fromMap({
          ...user.toMap(),
          'connectionCount':
              user.connectionCount == null ? null : user.connectionCount! - 1
        });
      });
      // connecteds.removeAt(checkConnected);
      await disconnect(user.uid);
    }
  }

  void updateReferals(int refs) {
    user = UserModel.fromMap({
      ...user.toMap(),
      'referalCount':
          user.referals == null ? refs : user.referals!.length + refs
    });
    setState(() {});
  }

  Future<void> disconnect(String userId) async {
    await ApiService.post(path: '/connection/disconnect', body: {
      'userId': _profileController.myProfile.uid,
      'connectedId': userId
    });
  }

  Future<void> connect(String userId) async {
    await ApiService.post(path: '/connection/connect', body: {
      'userId': _profileController.myProfile.uid,
      'connectedId': userId
    });
  }
}
