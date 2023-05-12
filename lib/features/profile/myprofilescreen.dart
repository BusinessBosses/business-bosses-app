import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/posts/models/post_model.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/features/profile/providers/my_posts.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../action/action.dart';
import '../../common/models/industry.dart';
import '../../common/widgets/safety_model.dart';
import '../../common/widgets/tiles/custom_tileinterests.dart';
import '../../common/widgets/tiles/outlinebuttonheader.dart';
import '../../functions/my_native_functions.dart';
import '../../navigation/routes.dart';
import '../home/bottom_nav.dart';
import '../posts/presentation/create_post_screen.dart';
import '../posts/presentation/widgets/post_grid_item.dart';
import 'my_profile_header.dart';

bool isExpanded = false;

class MyProfileScreen extends StatefulWidget {
  static const String routeName = '/my-profile-screen';

  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final ProfileController _profileController = Get.find();
  List<String> achievements = <String>[];
  final List<int> msgCount = <int>[2, 0, 10, 6, 52, 4, 0, 2];

  TextEditingController nameController = TextEditingController();

  void addItemToList() {
    setState(() {
      achievements.insert(0, nameController.text);
      msgCount.insert(0, 0);
    });
  }

  bool _isInit = false;
  bool _isLoading = false;
  int activeIndex = 0;

  late UserModel _user;

  double headHeight = 440.0;
  dynamic myDataStream;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> _onUrlLaunch(context, String url) async {
    try {
      await MyNativeFunctions.onUrlLaunch(url);
    } catch (e) {
      showSnackBar(context, message: e.toString());
      debugPrint('_MyProfileScreenState.onUrlLaunch catch: e: $e');
    }
  }

  Widget _buildChoiceChips(String data) {
    return SizedBox(
        child: Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        // ignore: unnecessary_null_comparison
        itemCount: data == null ? 0 : data.split('+').length,
        itemBuilder: (BuildContext context, int index) {
          return Wrap(
            spacing: 8.0, // gap between adjacent chips
            runSpacing: 4.0, // gap between lines
            children: <Widget>[
              Chip(
                backgroundColor: backgroundcolorinterface,
                avatar: const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 5,
                ),
                label: Text(
                  data.split('+')[index],
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          );
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (ProfileController controller) {
        return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(_profileController.myProfile.username),
              actions: [
                IconButton(
                    icon: SvgPicture.asset(
                      'assets/svgs/settings.svg',
                      height: 24.0,
                    ),
                    onPressed: () {
                      // Navigator.pushNamed(context, '/settingsScreen');
                      Get.toNamed(Routes.settings);
                    })
              ],
            ),
            body: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverStickyHeader(
                      sticky: false,
                      header: MyProfileHeader(
                          myProfile: _profileController.myProfile),
                    ),
                  ];
                },
                body: DefaultTabController(
                    length: 2,
                    child: Column(children: [
                      OutlineButtonHeader(
                          context, _profileController.myProfile),
                      const SizedBox(height: 8.0),

                      TabBar(
                        labelStyle:
                            const TextStyle(fontWeight: FontWeight.w500),
                        labelColor: Colors.black,
                        indicatorColor: primaryColorLT,
                        tabs: [
                          Tab(
                            icon: SvgPicture.asset(
                              'assets/svgs/portfolio.svg',
                              height: 20.0,
                            ),
                          ),
                          Tab(
                            icon: SvgPicture.asset(
                              'assets/svgs/posts.svg',
                              height: 20.0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: double.infinity,
                        height: 1.5,
                        child: ColoredBox(color: backgroundcolorinterface),
                      ),
                      // Container(

                      Expanded(
                        child: TabBarView(
                          children: [
                            Expanded(
                              child: TabBarView(
                                children: [
                                  SingleChildScrollView(
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.only(left: 15),
                                            child: Text(
                                              'Bio',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: subtextColor),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15, right: 15),
                                            child: Linkify(
                                              text: _profileController
                                                  .myProfile.bio
                                                  .toString(),
                                              maxLines: 5,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600),
                                              options: const LinkifyOptions(
                                                  humanize: false),
                                              linkStyle: bodyText2.copyWith(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 15),
                                            child: Row(
                                              children: [
                                                if (_profileController
                                                        .myProfile.website
                                                        ?.trim()
                                                        .isNotEmpty ??
                                                    false)
                                                  InkWell(
                                                    onTap: () {
                                                      String url =
                                                          MyNativeFunctions
                                                              .completeURL(
                                                                  _user
                                                                      .website!,
                                                                  MyUrl.url);
                                                      debugPrint(
                                                          'complete url : $url');
                                                      _onUrlLaunch(
                                                          context, url);
                                                    },
                                                    child: Row(
                                                      children: [
                                                        SvgPicture.asset(
                                                          'assets/svgs/link.svg',
                                                          height: 14.0,
                                                          width: 15.0,
                                                        ),
                                                        const SizedBox(
                                                            width: 4.0),
                                                        Text(
                                                          _user.website!,
                                                          style: const TextStyle(
                                                              decoration:
                                                                  TextDecoration
                                                                      .underline,
                                                              fontSize: 11.0),
                                                        ),
                                                        const SizedBox(
                                                            width: 8.0),
                                                      ],
                                                    ),
                                                  ),
                                                if (_profileController
                                                        .myProfile.twitter
                                                        ?.trim()
                                                        .isNotEmpty ??
                                                    false) ...{
                                                  const SizedBox(width: 8.0),
                                                  GestureDetector(
                                                    onTap: () {
                                                      String url =
                                                          MyNativeFunctions
                                                              .completeURL(
                                                                  _user
                                                                      .twitter!,
                                                                  MyUrl
                                                                      .twitter);
                                                      _onUrlLaunch(
                                                          context, url);
                                                    },
                                                    child: Container(
                                                      height: 25.0,
                                                      width: 25.0,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              6.0),
                                                      decoration: BoxDecoration(
                                                          color:
                                                              backgroundcolorinterface,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      30.0)),
                                                      child: SvgPicture.asset(
                                                        'assets/svgs/twitter_o.svg',
                                                      ),
                                                    ),
                                                  ),
                                                },
                                                if (_profileController
                                                        .myProfile.instagram
                                                        ?.trim()
                                                        .isNotEmpty ??
                                                    false) ...{
                                                  const SizedBox(width: 8.0),
                                                  GestureDetector(
                                                    onTap: () {
                                                      String url = MyNativeFunctions
                                                          .completeURL(
                                                              _user.instagram!,
                                                              MyUrl.instagram);
                                                      _onUrlLaunch(
                                                          context, url);
                                                    },
                                                    child: Container(
                                                      height: 25.0,
                                                      width: 25.0,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              6.0),
                                                      decoration: BoxDecoration(
                                                          color:
                                                              backgroundcolorinterface,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      30.0)),
                                                      child: SvgPicture.asset(
                                                        'assets/svgs/instagram_o.svg',
                                                      ),
                                                    ),
                                                  ),
                                                },
                                              ],
                                            ),
                                          ),
                                          _profileController.myProfile
                                                          .achievements ==
                                                      null ||
                                                  // ignore: unrelated_type_equality_checks
                                                  _profileController.myProfile
                                                          .achievements ==
                                                      ''
                                              ? Container()
                                              : Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(
                                                      height: 35,
                                                    ),
                                                    const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 15),
                                                      child: Text(
                                                        'Achievements',
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                subtextColor),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    SizedBox(
                                                      width: double.infinity,
                                                      child: ListView.builder(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 10.0,
                                                                bottom: 10,
                                                                left: 20,
                                                                right: 20),
                                                        shrinkWrap: true,
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        scrollDirection:
                                                            Axis.vertical,
                                                        itemCount: _profileController
                                                                    .myProfile
                                                                    .achievements ==
                                                                null
                                                            ? 0
                                                            : _profileController
                                                                .myProfile
                                                                .achievements
                                                                .toString()
                                                                .split('+')
                                                                .length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          return Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          15),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color:
                                                                    backgroundcolorinterface,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                              ),
                                                              child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 15,
                                                                      bottom:
                                                                          15,
                                                                      left: 15,
                                                                      right:
                                                                          20),
                                                                  child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        SvgPicture
                                                                            .asset(
                                                                          'assets/svgs/trophy.svg',
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Text(
                                                                          _profileController
                                                                              .myProfile
                                                                              .achievements
                                                                              .toString()
                                                                              .split('+')[index],
                                                                          style: const TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.w700,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ])));
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                          const SizedBox(
                                            height: 25,
                                          ),
                                          _profileController.myProfile
                                                          .productsandservices ==
                                                      null ||
                                                  // ignore: unrelated_type_equality_checks
                                                  _profileController.myProfile
                                                          .productsandservices ==
                                                      ''
                                              ? Container()
                                              : Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 15),
                                                      child: Text(
                                                        'Products & Services',
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: subtextColor,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    _buildChoiceChips(
                                                      _profileController
                                                              .myProfile
                                                              .productsandservices
                                                          as String,
                                                    ),
                                                  ],
                                                ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.only(left: 15),
                                            child: Text(
                                              'Interests',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: subtextColor,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          // Consumer<AppCommunities>(
                                          //   builder:
                                          //       (context, appCommunities, _) {
                                          //     List<Industry> yourIndustries =
                                          //         [];
                                          //     yourIndustries = appCommunities
                                          //         .industriesByUid(
                                          //             _profileController.myProfile.industry);
                                          //     return yourIndustries.isEmpty
                                          //         ? SafetyModel(
                                          //             isLoading: _isLoading,
                                          //             icon: const Icon(
                                          //               Icons.edit,
                                          //               size: 80.0,
                                          //               color: Colors.grey,
                                          //             ),
                                          //             title:
                                          //                 'You\'ve not joined any tiles',
                                          //             subTitle:
                                          //                 'All joined communities will be shown here.',
                                          //           )
                                          //         : Column(children: [
                                          //             ListView.builder(
                                          //               shrinkWrap: true,
                                          //               physics:
                                          //                   const NeverScrollableScrollPhysics(),
                                          //               padding:
                                          //                   const EdgeInsets
                                          //                           .only(
                                          //                       left: 8.0,
                                          //                       right: 8.0,
                                          //                       top: 8.0),
                                          //               itemBuilder:
                                          //                   (context, i) {
                                          //                 return Column(
                                          //                   children: [
                                          //                     CustomTileInterest(
                                          //                         label: yourIndustries[
                                          //                                 i]
                                          //                             .industry,
                                          //                         onTap: () {
                                          //                           yourIndustries[i]
                                          //                                   .industryId
                                          //                                   .contains(
                                          //                                       '-MsUPNEHnp8-An5VLI_v')
                                          //                               ? Navigator
                                          //                                   .push(
                                          //                                   context,
                                          //                                   MaterialPageRoute(
                                          //                                     builder: (BuildContext context) => const BottomNavScreen(2, true),
                                          //                                   ),
                                          //                                 )
                                          //                               : yourIndustries[i].industryId.contains('-MsUOGcOT9oRXGakCcJv')
                                          //                                   ? Navigator.push(
                                          //                                       context,
                                          //                                       MaterialPageRoute(
                                          //                                         builder: (context) => BottomNavScreen(1, true),
                                          //                                       ),
                                          //                                     )
                                          //                                   : navigateTo(
                                          //                                       context,
                                          //                                       routeName: AllForumScreenOld.routeName,
                                          //                                       arguments: yourIndustries[i].industryId,
                                          //                                     );
                                          //                         }),
                                          //                   ],
                                          //                 );
                                          //               },
                                          //               itemCount:
                                          //                   yourIndustries
                                          //                       .length,
                                          //             ),
                                          //             const SizedBox(
                                          //               width: double.infinity,
                                          //               height: 1,
                                          //               child: ColoredBox(
                                          //                   color:
                                          //                       backgroundcolorinterface),
                                          //             ),
                                          //             const SizedBox(
                                          //               height: 150,
                                          //             )
                                          //           ]);
                                          //   },
                                          // ),
                                          const SizedBox(
                                            height: 35,
                                          ),
                                        ]),
                                  ),
                                  ChangeNotifierProvider<MyPosts>(
                                    create: (_) => MyPosts(),
                                    child: Consumer<MyPosts>(
                                      builder: (BuildContext context, MyPosts p,
                                              _) =>
                                          p.posts.isEmpty
                                              ? SafetyModel(
                                                  isLoading: false,
                                                  icon: const Icon(
                                                    Icons.edit,
                                                    size: 80.0,
                                                    color: Colors.grey,
                                                  ),
                                                  title: 'You\'ve no post',
                                                  subTitle:
                                                      'Create a post to view here',
                                                  clickableText: 'Create post',
                                                  onTap: () => navigateTo(
                                                    context,
                                                    routeName: CreatePostScreen
                                                        .routeName,
                                                  ),
                                                )
                                              : Container(
                                                  height: double.infinity,
                                                  width: double.infinity,
                                                  color:
                                                      backgroundcolorinterface,
                                                  child: GridView.builder(
                                                    gridDelegate:
                                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 2,
                                                      mainAxisSpacing: 5,
                                                      crossAxisSpacing: 5,
                                                    ),
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10.0,
                                                            bottom: 120,
                                                            left: 10,
                                                            right: 10),
                                                    itemCount: p.posts.length,
                                                    itemBuilder: (context, i) {
                                                      return PostGridItem(
                                                        post: p.posts[i],
                                                        key: ValueKey(
                                                            p.posts[i].postId),
                                                        onDeletePost:
                                                            _onDeletePost,
                                                        onTap: () => _onPostTap(
                                                            p.posts[i]),
                                                      );
                                                    },
                                                  ),
                                                ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ]))));
      },
    );
  }

  _onDeletePost(String postId) {}

  _onPostTap(post) {}
}
