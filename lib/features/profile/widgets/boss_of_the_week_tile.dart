import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/forum/controller/challenge_controller.dart';
import 'package:business_bosses_v2/features/forum/presentation/bossup_screen.dart';
import 'package:business_bosses_v2/features/moreinfoscreens/bossuppartner.dart';
import 'package:business_bosses_v2/features/profile/widgets/dealssection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

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
  const BossOfWeekProfileTile({super.key, this.isForyou});

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
  final ChallengeController challengeController = Get.find();

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
        path: 'connection/connecteds/referals/${publicUser.uid}');
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
    ChallengeController();
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
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: GestureDetector(
                    onTap: () {
                      Get.to(() => BossUpSection(
                            industry: challengeController.categories[0],
                            bossUp: challengeController.categories[0],
                          ));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              width: 25.0,
                              height: 25.0,
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(
                                color: Colors.transparent,
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                'assets/images/app_logo_2.png',
                                height: 40,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            if (widget.isForyou == true)
                              const Text(
                                'Boss of the week',
                                style: TextStyle(
                                    fontWeight: FontWeight.w900, fontSize: 20),
                              ),
                          ],
                        ),
                        if (widget.isForyou == true)
                          const CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Icon(Icons.chevron_right,
                                  color: textColor, size: 20),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                widget.isForyou == true
                    ? GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.publicProfile, arguments: user);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          width: double.infinity,
                          child: Row(
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
                                      borderRadius: BorderRadius.circular(1000),
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
                              const SizedBox(width: 20.0),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    user?.isSubscribed == true
                                        ? Row(
                                            children: <Widget>[
                                              Text(
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
                                                    fontWeight: FontWeight.bold,
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
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  color: subtextColor,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child:
                                                        outlineButtonHeader(() {
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
                      )
                    : Container(),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => const Bossuppartner());
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Partners\' Deals',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: textColor,
                                    fontSize: 16),
                              ),
                              Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.chevron_right,
                                        color: textColor, size: 20),
                                  ]),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        dealsSection(),
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
                    backgroundColor: primaryColorLT.withValues(alpha: 0.1),
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
    ApiService.post(path: 'connection/disconnect', body: <String, dynamic>{
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
    ApiService.post(path: 'connection/connect', body: <String, dynamic>{
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
}
