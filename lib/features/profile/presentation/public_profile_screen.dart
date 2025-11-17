import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/presentation/user_shop_screen.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/posts/models/post_model.dart';
import 'package:business_bosses_v2/features/profile/widgets/profileinfodisplay.dart';
import 'package:business_bosses_v2/features/profile/widgets/profilepostsdisplay.dart';

import 'package:business_bosses_v2/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../action/action.dart';
import '../../../common/widgets/text_widget.dart';
import '../../../utils/theme/theme.dart';
import '../controller/profile_controller.dart';
import '../widgets/friendoutlinebuttonheader.dart';
import '../widgets/friend_profile_header.dart';

// ignore: public_member_api_docs, must_be_immutable
class PublicProfileScreen extends StatefulWidget {
  static const String routeName = '/public-profile-screen';
  bool? store;
  final int? selectedIndex;
  final int? currentIndex;
  // ignore: public_member_api_docs
  PublicProfileScreen(
      {super.key, this.store, this.selectedIndex, this.currentIndex});

  @override
  State<PublicProfileScreen> createState() => _PublicProfileScreenState();
}

class _PublicProfileScreenState extends State<PublicProfileScreen> {
  final ProfileController _profileController = Get.find();
  final ShopController shopController = Get.find();
  List<PostModel> _posts = <PostModel>[];
  late UserModel publicUser;
  bool isLoading = true;
  bool blocked = false;
  bool hasShop = false;

  bool hasUser = true;

  late PageController _pageController;

  int? _selectedIndex;
  int _currentIndex = 0;

  Future<void> loadData() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
    });

    try {
      final Map<String, dynamic> res =
          await _profileController.loadData(publicUser.uid);

      // Process user model outside of setState
      final UserModel modelizedUser = UserModel.fromMap(
        <dynamic, dynamic>{...res['user'], 'interests': res['industries']},
      );

      // Assign values locally first
      UserModel updatedUser = modelizedUser;
      bool userHasShop = false;

      // Initialize shop asynchronously and await result
      userHasShop = await shopController.initUserShop(modelizedUser);

      // All state updates at once
      if (mounted) {
        setState(() {
          publicUser = updatedUser;
          _posts = res['posts'];
          hasShop = userHasShop;
          isLoading = false; // Done loading
        });
      }
    } catch (e) {
      // Handle errors
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> report(
      BuildContext context, String type, String publicUserUid) async {}

  Future<void> connect(String userId) async {
    // ignore: unused_local_variable
    final ApiResponseModel res = await ApiService.post(
        path: 'connection/connect',
        body: <String, dynamic>{
          'userId': _profileController.myProfile.uid,
          'connectedId': userId,
          'timestamp': DateTime.now().millisecondsSinceEpoch
        });
  }

  Future<void> disconnect(String userId) async {
    // ignore: unused_local_variable
    final ApiResponseModel res = await ApiService.post(
        path: 'connection/disconnect',
        body: <String, dynamic>{
          'userId': _profileController.myProfile.uid,
          'connectedId': userId,
          'timestamp': DateTime.now().millisecondsSinceEpoch
        });
  }

  void connectToUser() async {
    final int checkConnected = _profileController.myProfile.connecteds == null
        ? -1
        : _profileController.myProfile.connecteds!
            .indexWhere((String element) => element == publicUser.uid);
    if (checkConnected == -1) {
      // connecteds.add(user);
      _profileController.updateConnections(publicUser.uid);
      setState(() {
        publicUser = UserModel.fromMap(<dynamic, dynamic>{
          ...publicUser.toMap(),
          'connectionCount': publicUser.connectionCount == null
              ? 1
              : publicUser.connectionCount! + 1
        });
      });
      await connect(publicUser.uid);
    } else {
      _profileController.updateConnections(publicUser.uid);

      setState(() {
        publicUser = UserModel.fromMap(<dynamic, dynamic>{
          ...publicUser.toMap(),
          'connectionCount': publicUser.connectionCount == null
              ? null
              : publicUser.connectionCount! - 1
        });
      });
      // connecteds.removeAt(checkConnected);
      await disconnect(publicUser.uid);
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController =
        PageController(initialPage: widget.currentIndex ?? _currentIndex);
    _selectedIndex = widget.selectedIndex ?? 0;
    _currentIndex = widget.currentIndex ?? 0;

    if (Get.arguments == null) {
      // print("back");
      Get.back();
    } else {
      // print("yo");

      publicUser = Get.arguments;
      // print(publicUser.productsandservices);
      loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: !hasShop
            ? AppBar(
                actions: <Widget>[
                  threeDots(),
                ],
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
                ),
                title: Text(publicUser.name ?? publicUser.username),
              )
            : PreferredSize(
                preferredSize: Size.fromHeight(
                    (_selectedIndex == 0 || _selectedIndex == 4)
                        ? kToolbarHeight
                        : 0),
                child: Stack(children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      if (_selectedIndex == 0 || _selectedIndex == 4)
                        if (hasShop) ...<Widget>{
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: CupertinoSlidingSegmentedControl<int>(
                              backgroundColor: backgroundColor,
                              padding: const EdgeInsets.all(5),
                              children: <int, Widget>{
                                0: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Text('Profile',
                                      style: _currentIndex == 0
                                          ? const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            )
                                          : const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: textColor)),
                                ),
                                1: Text(
                                  'Biz-Center',
                                  style: _currentIndex == 1
                                      ? const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14)
                                      : const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: textColor,
                                        ),
                                ),
                              },
                              onValueChanged: (int? value) {
                                if (value != null) {
                                  setState(() {
                                    _selectedIndex == 0;
                                    _currentIndex = value;
                                    _pageController.animateToPage(
                                      _currentIndex,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.ease,
                                    );
                                  });
                                }
                              },
                              groupValue: _currentIndex,
                            ),
                          )
                        },
                      if (_selectedIndex == 0 || _selectedIndex == 4)
                        const SizedBox(height: 10.0),
                    ],
                  ),
                  Positioned(
                      bottom: 10,
                      right: 0,
                      child: publicUser.uid != _profileController.myProfile.uid
                          ? threeDots()
                          : Container()),
                  Positioned(
                    bottom: 5,
                    left: 0,
                    child: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
                    ),
                  ),
                ]),
              ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator.adaptive())
            : PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                onPageChanged: (int index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                children: <Widget>[
                    NestedScrollView(
                      headerSliverBuilder:
                          (BuildContext context, bool innerBoxIsScrolled) {
                        return <Widget>[
                          SliverStickyHeader(
                            sticky: false,
                            header: friendProfileHeader(publicUser),
                          )
                        ];
                      },
                      body: DefaultTabController(
                        length: 2,
                        initialIndex: widget.store != null ? 2 : 0,
                        child: Column(
                          children: <Widget>[
                            outlineButtonHeader(
                              publicUser,
                              _profileController.myProfile,
                              connectToUser,
                              context,
                            ),
                            const SizedBox(height: 15.0),
                            // },
                            const SizedBox(
                              width: double.infinity,
                              height: 1.5,
                              child:
                                  ColoredBox(color: backgroundcolorinterface),
                            ),

                            Material(
                              color: const Color(0xFFF9F9F9),
                              child: TabBar(
                                indicatorColor: primaryColorLT,
                                labelStyle: const TextStyle(
                                    fontWeight: FontWeight.w500),
                                labelColor: Colors.black,
                                tabs: <Widget>[
                                  const Tab(
                                    text: 'About',
                                  ),
                                  const Tab(
                                    text: 'Posts',
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: double.infinity,
                              height: 1.5,
                              child:
                                  ColoredBox(color: backgroundcolorinterface),
                            ), // Container(

                            Expanded(
                              child: TabBarView(children: <Widget>[
                                SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      profileinfodisplay(context, publicUser),
                                    ],
                                  ),
                                ),
                                // Container()
                                profilepostsdisplay(
                                  ispublicposts: true,
                                  context,
                                  publicUser,
                                  _posts,
                                  loading: isLoading,
                                ),
                              ]),
                            ),
                          ],
                        ),
                      ),
                    ),
                    UserShopScreen(
                      user: publicUser,
                      ismyshop: false,
                    )
                  ]));
  }

  Widget threeDots() {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          onTap: () {
                            navigateTo(context);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const TextWidget(
                                  text: 'Do you want to block user?',
                                  centralize: true,
                                  fontWeight: FontWeight.w700,
                                  size: 20,
                                ),
                                content: TextWidget(
                                  text: blocked == true
                                      ? 'You will see posts and comments related to user on your feed'
                                      : 'You will no longer see undefined posts and comments on your feed',
                                  centralize: true,
                                  color: Colors.black.withValues(alpha: .6),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => navigateTo(context),
                                    child: const TextWidget(
                                      text: 'Cancel',
                                      fontWeight: FontWeight.w700,
                                      size: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      navigateTo(context);
                                      // print(_post.user.uid);

                                      // widget
                                      //     .onBlock(_post.user.uid);
                                      showSnackBar(context,
                                          message: blocked == true
                                              ? 'User has been blocked'
                                              : 'User has been unblocked');
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 7,
                                        horizontal: 14,
                                      ),
                                      decoration: BoxDecoration(
                                        color: primaryColorLT,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: TextWidget(
                                        text: blocked == true
                                            ? 'Unblock'
                                            : 'Block',
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
                          title: publicUser.isSubscribed == true
                              ? Row(
                                  children: <Widget>[
                                    TextWidget(
                                      text: blocked == true
                                          ? 'Unblock @${publicUser.name}'
                                          : 'Block @${publicUser.name}',
                                      color: Colors.blue,
                                    ),
                                    const SizedBox(width: 5),
                                    SvgPicture.asset(
                                      'assets/svgs/premiumbadge.svg',
                                      height: 9,
                                      colorFilter: ColorFilter.mode(
                                          primaryColorLT, BlendMode.src),
                                    )
                                  ],
                                )
                              : TextWidget(
                                  text: blocked == true
                                      ? 'Unblock @${publicUser.name}'
                                      : 'Block @${publicUser.name}',
                                  color: Colors.blue,
                                ),
                        ),
                        ListTile(
                          onTap: () {
                            navigateTo(context);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const TextWidget(
                                  text: 'Do you want to report user?',
                                  centralize: true,
                                  fontWeight: FontWeight.w700,
                                  size: 20,
                                ),
                                content: TextWidget(
                                  text:
                                      'The user will be reported to admin to evaluate if it violates any community policy',
                                  centralize: true,
                                  color: Colors.black.withValues(alpha: .6),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => navigateTo(context),
                                    child: const TextWidget(
                                      text: 'Cancel',
                                      fontWeight: FontWeight.w700,
                                      size: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      navigateTo(context);
                                      await report(
                                        context,
                                        'accountReport',
                                        publicUser.uid,
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 7,
                                        horizontal: 14,
                                      ),
                                      decoration: BoxDecoration(
                                        color: primaryColorLT,
                                        borderRadius: BorderRadius.circular(5),
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
                            text: 'Report this user',
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
              child: CircleAvatar(
                  backgroundColor: backgroundColor,
                  child: SvgPicture.asset('assets/svgs/more.svg'))),
        ),
      ],
    );
  }

  Widget optionsButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      onTap: () {
                        navigateTo(context);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const TextWidget(
                              text: 'Do you want to block user?',
                              centralize: true,
                              fontWeight: FontWeight.w700,
                              size: 20,
                            ),
                            content: TextWidget(
                              text: blocked == true
                                  ? 'You will see posts and comments related to user on your feed'
                                  : 'You will no longer see undefined posts and comments on your feed',
                              centralize: true,
                              color: Colors.black.withValues(alpha: .6),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => navigateTo(context),
                                child: const TextWidget(
                                  text: 'Cancel',
                                  fontWeight: FontWeight.w700,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  navigateTo(context);
                                  // print(_post.user.uid);

                                  // widget
                                  //     .onBlock(_post.user.uid);
                                  showSnackBar(context,
                                      message: blocked == true
                                          ? 'User has been blocked'
                                          : 'User has been unblocked');
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 7,
                                    horizontal: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: primaryColorLT,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: TextWidget(
                                    text: blocked == true ? 'Unblock' : 'Block',
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
                      title: publicUser.isSubscribed == true
                          ? Row(
                              children: <Widget>[
                                TextWidget(
                                  text: blocked == true
                                      ? 'Unblock @${publicUser.name}'
                                      : 'Block @${publicUser.name}',
                                  color: Colors.blue,
                                ),
                                const SizedBox(width: 5),
                                SvgPicture.asset(
                                  'assets/svgs/premiumbadge.svg',
                                  height: 9,
                                  colorFilter: ColorFilter.mode(
                                      primaryColorLT, BlendMode.srcIn),
                                )
                              ],
                            )
                          : TextWidget(
                              text: blocked == true
                                  ? 'Unblock @${publicUser.name}'
                                  : 'Block @${publicUser.name}',
                              color: Colors.blue,
                            ),
                    ),
                    ListTile(
                      onTap: () {
                        navigateTo(context);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const TextWidget(
                              text: 'Do you want to report user?',
                              centralize: true,
                              fontWeight: FontWeight.w700,
                              size: 20,
                            ),
                            content: TextWidget(
                              text:
                                  'The user will be reported to admin to evaluate if it violates any community policy',
                              centralize: true,
                              color: Colors.black.withValues(alpha: .6),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => navigateTo(context),
                                child: const TextWidget(
                                  text: 'Cancel',
                                  fontWeight: FontWeight.w700,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  navigateTo(context);
                                  await report(
                                    context,
                                    'accountReport',
                                    publicUser.uid,
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 7,
                                    horizontal: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: primaryColorLT,
                                    borderRadius: BorderRadius.circular(5),
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
                        text: 'Report this user',
                        color: Colors.red,
                      ),
                    )
                  ],
                ),
              ),
            );
          },
          child: CircleAvatar(
              backgroundColor: backgroundColor,
              child: SvgPicture.asset('assets/svgs/more.svg'))),
    );
  }
}
