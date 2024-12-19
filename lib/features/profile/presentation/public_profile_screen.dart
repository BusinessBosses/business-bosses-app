import 'package:business_bosses_v2/bbpro/presentation/user_shop_screen.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/service_item.dart';
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
import '../../../common/widgets/safety_model.dart';
import '../../../common/widgets/text_widget.dart';
import '../../../utils/theme/theme.dart';
import '../../marketplace/controllers/market_controller.dart';
import '../../marketplace/models/market_model.dart';
import '../../marketplace/widgets/marketplace_item.dart';
import '../controller/profile_controller.dart';
import '../widgets/friendoutlinebuttonheader.dart';
import '../widgets/friendprofileheader.dart';

// ignore: public_member_api_docs, must_be_immutable
class PublicProfileScreen extends StatefulWidget {
  static const String routeName = '/public-profile-screen';
  bool? store;

  // ignore: public_member_api_docs
  PublicProfileScreen({Key? key, this.store}) : super(key: key);

  @override
  State<PublicProfileScreen> createState() => _PublicProfileScreenState();
}

class _PublicProfileScreenState extends State<PublicProfileScreen> {
  final ProfileController _profileController = Get.find();
  final MarketController _marketController = Get.find();
  List<PostModel> _posts = <PostModel>[];
  late UserModel publicUser;
  bool isLoading = true;
  bool blocked = false;

  bool hasUser = true;
  List<MarketModel> filteredMarkets = <MarketModel>[];

  late PageController _pageController;

  int? _selectedIndex;
  int _currentIndex = 0;

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final Map<String, dynamic> res =
          await ProfileController.loadData(publicUser.uid);
      final UserModel modelizedUser = UserModel.fromMap(
          <dynamic, dynamic>{...res['user'], 'interests': res['industries']});
      publicUser = modelizedUser;
      _posts = res['posts'];
      filteredMarkets = _marketController.markets
          .where((MarketModel market) => market.userId == publicUser.uid)
          .toList();

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      // Handle any errors here.
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
        path: '/connection/connect',
        body: <String, dynamic>{
          'userId': _profileController.myProfile.uid,
          'connectedId': userId,
          'timestamp': DateTime.now().millisecondsSinceEpoch
        });
  }

  Future<void> disconnect(String userId) async {
    // ignore: unused_local_variable
    final ApiResponseModel res = await ApiService.post(
        path: '/connection/disconnect',
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
    _selectedIndex = 0;
    _pageController = PageController(initialPage: _currentIndex);
    if (Get.arguments == null) {
      // print("back");
      Get.back();
    } else {
      // print("yo");

      publicUser = Get.arguments;
      // print(publicUser.productsandservices);
      filteredMarkets.clear();
      loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: publicUser.isSubscribed
            ? PreferredSize(
                preferredSize: Size.fromHeight(
                    (_selectedIndex == 0 || _selectedIndex == 4)
                        ? kToolbarHeight
                        : 0),
                child: Stack(children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      if (_selectedIndex == 0 || _selectedIndex == 4)
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: CupertinoSlidingSegmentedControl<int>(
                            backgroundColor: Colors.grey[200]!,
                            padding: const EdgeInsets.all(5),
                            children: <int, Widget>{
                              0: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Text('Profile',
                                    style: _currentIndex == 0
                                        ? const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          )
                                        : const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: Colors.grey)),
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
                                        color: Colors.grey,
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
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.ease,
                                  );
                                });
                              }
                            },
                            groupValue: _currentIndex,
                          ),
                        ),
                      if (_selectedIndex == 0 || _selectedIndex == 4)
                        const SizedBox(height: 10.0),
                    ],
                  ),
                  Positioned(
                      bottom: 10,
                      right: 0,
                      child: publicUser.uid != _profileController.myProfile.uid
                          ? Padding(
                              padding: const EdgeInsets.only(right: 15.0),
                              child: InkWell(
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
                                                navigateTo(context);
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          AlertDialog(
                                                    title: const TextWidget(
                                                      text:
                                                          'Do you want to block user?',
                                                      centralize: true,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      size: 20,
                                                    ),
                                                    content: TextWidget(
                                                      text: blocked == true
                                                          ? 'You will see posts and comments related to user on your feed'
                                                          : 'You will no longer see undefined posts and comments on your feed',
                                                      centralize: true,
                                                      color: Colors.black
                                                          .withOpacity(.6),
                                                    ),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () =>
                                                            navigateTo(context),
                                                        child: const TextWidget(
                                                          text: 'Cancel',
                                                          fontWeight:
                                                              FontWeight.w700,
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
                                                              message: blocked ==
                                                                      true
                                                                  ? 'User has been blocked'
                                                                  : 'User has been unblocked');
                                                        },
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            vertical: 7,
                                                            horizontal: 14,
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
                                                          child: TextWidget(
                                                            text:
                                                                blocked == true
                                                                    ? 'Unblock'
                                                                    : 'Block',
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
                                              title: publicUser.isSubscribed ==
                                                      true
                                                  ? Row(
                                                      children: <Widget>[
                                                        TextWidget(
                                                          text: blocked == true
                                                              ? 'Unblock @${publicUser.name}'
                                                              : 'Block @${publicUser.name}',
                                                          color: Colors.blue,
                                                        ),
                                                        const SizedBox(
                                                            width: 5),
                                                        SvgPicture.asset(
                                                          'assets/svgs/premiumbadge.svg',
                                                          height: 9,
                                                          color: primaryColorLT,
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
                                                  builder:
                                                      (BuildContext context) =>
                                                          AlertDialog(
                                                    title: const TextWidget(
                                                      text:
                                                          'Do you want to report user?',
                                                      centralize: true,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      size: 20,
                                                    ),
                                                    content: TextWidget(
                                                      text:
                                                          'The user will be reported to admin to evaluate if it violates any community policy',
                                                      centralize: true,
                                                      color: Colors.black
                                                          .withOpacity(.6),
                                                    ),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () =>
                                                            navigateTo(context),
                                                        child: const TextWidget(
                                                          text: 'Cancel',
                                                          fontWeight:
                                                              FontWeight.w700,
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
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            vertical: 7,
                                                            horizontal: 14,
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
                                      child: SvgPicture.asset(
                                          'assets/svgs/more.svg'))),
                            )
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
              )
            : AppBar(
                title: Text(publicUser.name ?? publicUser.username),
              ),
        // : AppBar(
        //     leading: IconButton(
        //       onPressed: () {
        //         Get.back();
        //       },
        //       icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        //     ),
        //     title: Text('@${publicUser.username}'),
        //     actions: <Widget>[optionsButton()],
        //   ),
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
                            header: FriendProfileHeader(publicUser),
                          )
                        ];
                      },
                      body: DefaultTabController(
                        length: filteredMarkets.isEmpty ? 2 : 3,
                        initialIndex: widget.store != null ? 2 : 0,
                        child: Column(
                          children: <Widget>[
                            OutlineButtonHeader(
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
                                tabs: filteredMarkets.isEmpty
                                    ? <Widget>[
                                        const Tab(
                                          text: 'About',
                                        ),
                                        const Tab(
                                          text: 'Posts',
                                        ),
                                      ]
                                    : <Widget>[
                                        const Tab(
                                          text: 'About',
                                        ),
                                        const Tab(
                                          text: 'Posts',
                                        ),
                                        if (!publicUser.isSubscribed)
                                          const Tab(
                                            text: 'Listings',
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
                              child: TabBarView(
                                children: filteredMarkets.isEmpty
                                    ? <Widget>[
                                        SingleChildScrollView(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              const SizedBox(
                                                height: 30,
                                              ),
                                              profileinfodisplay(
                                                  context, publicUser),
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
                                      ]
                                    : <Widget>[
                                        // Container(),
                                        SingleChildScrollView(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              const SizedBox(
                                                height: 30,
                                              ),
                                              profileinfodisplay(
                                                  context, publicUser),
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

                                        if (!publicUser.isSubscribed)
                                          SingleChildScrollView(
                                            child: Stack(
                                              children: <Widget>[
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(0),
                                                  height: 100,
                                                  width: double.infinity,
                                                  child: ClipRRect(
                                                    child: FittedBox(
                                                      fit: BoxFit.fill,
                                                      child: Image.asset(
                                                          'assets/images/sellerbackground.jpg'),
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    filteredMarkets.isEmpty
                                                        ? const SafetyModel(
                                                            isLoading: false,
                                                            icon: Icon(
                                                              Icons.warning,
                                                              color:
                                                                  Colors.grey,
                                                              size: 80.0,
                                                            ),
                                                            title:
                                                                'This user has no items in store',
                                                            // subTitle: '',
                                                          )
                                                        : ListView.builder(
                                                            shrinkWrap: true,
                                                            physics:
                                                                const NeverScrollableScrollPhysics(),
                                                            itemCount:
                                                                filteredMarkets
                                                                    .length,
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    int index) {
                                                              final MarketModel
                                                                  market =
                                                                  filteredMarkets[
                                                                      index];

                                                              return market
                                                                      .isProduct
                                                                  ? MarketTile(
                                                                      post:
                                                                          market,
                                                                      controller:
                                                                          _marketController,
                                                                      key: ValueKey(
                                                                          market
                                                                              .marketId),
                                                                    )
                                                                  : ServiceTile(
                                                                      post:
                                                                          market,
                                                                      controller:
                                                                          _marketController,
                                                                      key: ValueKey(
                                                                          market
                                                                              .marketId),
                                                                    );
                                                            },
                                                          ),
                                                    const SizedBox(
                                                      height: 200,
                                                    )
                                                  ],
                                                ),
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
                    UserShopScreen(
                      user: publicUser,
                      ismyshop: false,
                    )
                  ]));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
                              color: Colors.black.withOpacity(.6),
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
                                  color: primaryColorLT,
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
                              color: Colors.black.withOpacity(.6),
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
