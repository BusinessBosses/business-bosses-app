import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/profile/user_profile_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../action/action.dart';
import '../../common/models/my_connect.dart';
import '../../common/models/my_refers.dart';
import '../../common/models/my_response.dart';
import '../../common/models/my_user.dart';
import '../../common/params.dart';
import '../../common/widgets/buttons/custom_child_button.dart';
import '../../common/widgets/buttons/my_outlined_button.dart';
import '../../common/widgets/safety_model.dart';
import '../../common/widgets/text_widget.dart';
import '../../functions/my_native_functions.dart';
import '../../navigation/routes.dart';
import '../../utils/constants/constants.dart';
import '../../utils/theme/theme.dart';
import '../chat/chat_room_screen.dart';
import '../connects/all_connections_screen.dart';
import '../posts/models/post_model.dart';
import '../posts/presentation/widgets/post_grid_item.dart';
import '../referrals/refer_screen.dart';
import '../referrals/referrals_details_screen.dart';
import 'controller/profile_controller.dart';

bool isExpanded = false;

class PublicProfileScreen extends StatefulWidget {
  static const String routeName = '/public-profile-screen';

  PublicProfileScreen({Key? key}) : super(key: key);

  @override
  _PublicProfileScreenState createState() => _PublicProfileScreenState();
}

class _PublicProfileScreenState extends State<PublicProfileScreen> {
  bool connectedbutton = true;
  final UserModel _publicUser = UserModel(
      achievements: 'jnkknmmk,llllml,hjjkhkh'.split(','),
      active: true,
      ageRange: '10',
      bio: 'sdxsdddddfff',
      category: 'wee',
      companyName: 'ee',
      website: 'ee',
      username: '2mrt',
      deactivated: false,
      email: 'DFFG',
      gender: 'GGG',
      industry: 'FF',
      instagram: 'GGG',
      location: 'DGG',
      name: 'GGG',
      photoUrl: '',
      productsandservices: 'sdffgg,s,ksf'.split(','),
      surname: 'kkk',
      timestamp: 100394,
      twitter: '',
      uid: '',
      unReadCount: 12,
      bossOfTheWeekUpTimeStamp: 3455,
      bossOfTheWeekTimeStamp: 677);
  bool _isInit = false;
  bool _isLoading = true;
  bool blocked = false;
  // bool _isConnected = false;
  // String _connectionStatus;

  List<PostModel> _friendPosts = [];

  // String _userUid;
  bool _hasUser = true;
  MyConnect _connectionData = MyConnect();

  Future<void> report(
      BuildContext context, String type, String publicUserUid) async {}

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInit) {
      // final Params data = ModalRoute.of(context)?.settings.arguments as Params;
      // debugPrint('_PublicProfileScreenState.: ${data?.toMap()}');
      // if (data?.arg1 == null && data?.arg2 == null) {
      //   Navigator.of(context).pop();
      // }
      // _loadUser(data);
      // _isInit = true;
    }
  }

  Future<void> _loadUser(Params params) async {
    MyResponse res;
  }

  Future<void> _loadMyPost() async {
    if (_publicUser != null && _publicUser?.uid != null) {
      String path = Constants.POSTS;
    }
  }

  Widget _buildChoiceChips(String? data) {
    final chipLabels = data
            ?.split(',')
            .map((e) => e.trim().replaceAll('[', '').replaceAll(']', ''))
            .toList() ??
        [];

    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: chipLabels.length,
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
                    chipLabels[index],
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        ),
        title: Text('@${_publicUser?.username ?? ''}'),
        actions: [
          _publicUser.uid != '_profileController.myProfile.uid'
              ? Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  onTap: () {
                                    navigateTo(context);
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
                                          text: blocked
                                              ? 'You will see posts and comments related to user on your feed'
                                              : 'You will no longer see undefined posts and comments on your feed',
                                          centralize: true,
                                          color: Colors.black.withOpacity(.6),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                navigateTo(context),
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
                                              setState(() {
                                                blocked = !blocked;
                                              });
                                              // widget
                                              //     .onBlock(_post.user.uid);
                                              showSnackBar(context,
                                                  message: blocked
                                                      ? 'User has been blocked'
                                                      : 'User has been unblocked');
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
                                              child: TextWidget(
                                                text: blocked
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
                                  title: TextWidget(
                                    text: blocked
                                        ? 'Unblock @${_publicUser.name}'
                                        : 'Block @${_publicUser.name}',
                                    color: Colors.blue,
                                  ),
                                ),
                                ListTile(
                                  onTap: () {
                                    navigateTo(context);
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
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
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                navigateTo(context),
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
                                                _publicUser.uid,
                                              );
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
                                    text: 'Report this user',
                                    color: Colors.red,
                                  ),
                                )
                              ],
                            ),
                          ),
                        );

                        // _showMorePostOptions(context, "accountReport",
                        //     _publicUser?.uid.toString(), "Report this User.");
                      },
                      child: SvgPicture.asset('assets/svgs/more.svg')),
                )
              : Container()
        ],
      ),
      body: !_hasUser
          ? SafetyModel(
              isLoading: false,
              icon: SvgPicture.asset(
                'assets/svgs/person.svg',
                color: hintColor,
                height: 80.0,
              ),
              title: 'User not found',
              subTitle: 'User may not exit',
            )
          : !_isLoading
              ? const Center(child: CircularProgressIndicator.adaptive())
              : NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverStickyHeader(
                        sticky: false,
                        header: FriendProfileHeader(),
                      )
                    ];
                  },
                  body: DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        if (_publicUser.uid !=
                            'FirebaseAuth.instance.currentUser.uid') ...{
                          OutlineButtonHeader(),
                          const SizedBox(height: 8.0),
                        },

                        Material(
                          color: Colors.white,
                          child: TabBar(
                            indicatorColor: primaryColorLT,
                            labelStyle:
                                const TextStyle(fontWeight: FontWeight.w500),
                            labelColor: Colors.black,
                            tabs: [
                              Tab(
                                icon: SvgPicture.asset(
                                    'assets/svgs/portfolio.svg'),
                              ),
                              Tab(
                                  icon: SvgPicture.asset(
                                      'assets/svgs/posts.svg')),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: double.infinity,
                          height: 1.5,
                          child: ColoredBox(color: backgroundcolorinterface),
                        ), // Container(

                        Expanded(
                          child: TabBarView(
                            children: [
                              SingleChildScrollView(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                          text: _publicUser.bio!,
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
                                            if (_publicUser.website
                                                    ?.trim()
                                                    ?.isNotEmpty ??
                                                false)
                                              InkWell(
                                                onTap: () {
                                                  String url = MyNativeFunctions
                                                      .completeURL(
                                                          _publicUser.website!,
                                                          MyUrl.url);
                                                  _onUrlLaunch(url);
                                                },
                                                child: Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      'assets/svgs/link.svg',
                                                      height: 14.0,
                                                      width: 15.0,
                                                    ),
                                                    const SizedBox(width: 4.0),
                                                    Text(
                                                      _publicUser.website!,
                                                      style: const TextStyle(
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          fontSize: 11.0),
                                                    ),
                                                    const SizedBox(width: 8.0),
                                                  ],
                                                ),
                                              ),
                                            if (_publicUser.twitter
                                                    ?.trim()
                                                    ?.isNotEmpty ??
                                                false) ...{
                                              const SizedBox(width: 8.0),
                                              GestureDetector(
                                                onTap: () {
                                                  String url = MyNativeFunctions
                                                      .completeURL(
                                                          _publicUser.twitter!,
                                                          MyUrl.twitter);
                                                  _onUrlLaunch(url);
                                                },
                                                child: Container(
                                                  height: 25.0,
                                                  width: 25.0,
                                                  padding:
                                                      const EdgeInsets.all(6.0),
                                                  decoration: BoxDecoration(
                                                      color:
                                                          backgroundcolorinterface,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.0)),
                                                  child: SvgPicture.asset(
                                                    'assets/svgs/twitter_o.svg',
                                                  ),
                                                ),
                                              ),
                                            },
                                            if (_publicUser.instagram
                                                    ?.trim()
                                                    ?.isNotEmpty ??
                                                false) ...{
                                              const SizedBox(width: 8.0),
                                              GestureDetector(
                                                onTap: () {
                                                  String url = MyNativeFunctions
                                                      .completeURL(
                                                          _publicUser
                                                              .instagram!,
                                                          MyUrl.instagram);
                                                  _onUrlLaunch(url);
                                                },
                                                child: Container(
                                                  height: 25.0,
                                                  width: 25.0,
                                                  padding:
                                                      const EdgeInsets.all(6.0),
                                                  decoration: BoxDecoration(
                                                      color:
                                                          backgroundcolorinterface,
                                                      borderRadius:
                                                          BorderRadius.circular(
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
                                      const SizedBox(
                                        height: 35,
                                      ),
                                      _publicUser.achievements == null ||
                                              _publicUser.achievements!.isEmpty
                                          ? Container()
                                          : Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 15),
                                                  child: Text(
                                                    'Achievements',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: subtextColor),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                SizedBox(
                                                  width: double.infinity,
                                                  child: ListView.builder(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10.0,
                                                            bottom: 20,
                                                            left: 20,
                                                            right: 20),
                                                    shrinkWrap: true,
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    itemCount: _publicUser
                                                                .achievements ==
                                                            null
                                                        ? 0
                                                        : _publicUser
                                                            .achievements!
                                                            .length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 15),
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
                                                              padding:
                                                                  const EdgeInsets
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
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Text(
                                                                      _publicUser
                                                                              .achievements![
                                                                          index],
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight: FontWeight
                                                                              .w700,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ])));
                                                    },
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                              ],
                                            ),
                                      _publicUser.productsandservices == null ||
                                              _publicUser
                                                  .productsandservices!.isEmpty
                                          ? Container()
                                          : Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 15),
                                                  child: Text(
                                                    'Products & Services',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: subtextColor),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                _buildChoiceChips(_publicUser
                                                    .productsandservices
                                                    .toString()),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                              ],
                                            ),
                                      const Padding(
                                        padding: EdgeInsets.only(left: 15),
                                        child: Text(
                                          'Interests',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: subtextColor),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      // Consumer<AppCommunities>(
                                      //   builder: (context, appCommunities, _) {
                                      //     List<Industry> yourIndustries = [];
                                      //     yourIndustries =
                                      //         appCommunities.industriesByUid(
                                      //             _publicUser?.uid);
                                      //     return yourIndustries.isEmpty
                                      //         ? SafetyModel(
                                      //             isLoading: _isLoading,
                                      //             icon: const Icon(
                                      //               Icons.edit,
                                      //               size: 80.0,
                                      //               color: Colors.grey,
                                      //             ),
                                      //             title:
                                      //                 '@${_publicUser.username} have not joined any community yet!',
                                      //             subTitle:
                                      //                 'All joined communities will be shown here.',
                                      //           )
                                      //         : Column(children: [
                                      //             ListView.builder(
                                      //               shrinkWrap: true,
                                      //               physics:
                                      //                   const NeverScrollableScrollPhysics(),
                                      //               padding:
                                      //                   const EdgeInsets.only(
                                      //                       left: 8.0),
                                      //               itemBuilder: (context, i) {
                                      //                 return CustomTileInterest(
                                      //                     label:
                                      //                         yourIndustries[i]
                                      //                             .industry,
                                      //                     onTap: () {
                                      //                       yourIndustries[i]
                                      //                               .industryId
                                      //                               .contains(
                                      //                                   '-MsUPNEHnp8-An5VLI_v')
                                      //                           ? Navigator
                                      //                               .push(
                                      //                               context,
                                      //                               MaterialPageRoute(
                                      //                                 builder: (context) =>
                                      //                                     BottomNavScreen(
                                      //                                         2,
                                      //                                         true),
                                      //                               ),
                                      //                             )
                                      //                           : yourIndustries[
                                      //                                       i]
                                      //                                   .industryId
                                      //                                   .contains(
                                      //                                       '-MsUOGcOT9oRXGakCcJv')
                                      //                               ? Navigator
                                      //                                   .push(
                                      //                                   context,
                                      //                                   MaterialPageRoute(
                                      //                                     builder: (context) => BottomNavScreen(
                                      //                                         1,
                                      //                                         true),
                                      //                                   ),
                                      //                                 )
                                      //                               : navigateTo(
                                      //                                   context,
                                      //                                   routeName:
                                      //                                       AllForumScreen.routeName,
                                      //                                   arguments:
                                      //                                       yourIndustries[i].industryId,
                                      //                                 );
                                      //                     });
                                      //               },
                                      //               itemCount:
                                      //                   yourIndustries.length,
                                      //             ),
                                      //             const SizedBox(
                                      //               width: double.infinity,
                                      //               height: 1,
                                      //               child: ColoredBox(
                                      //                   color:
                                      //                       backgroundcolorinterface),
                                      //             ),
                                      //           ]);
                                      //   },
                                      // ),
                                      const SizedBox(
                                        height: 150,
                                      )
                                    ]),
                              ),
                              _friendPosts.isEmpty
                                  ? SafetyModel(
                                      isLoading: _isLoading,
                                      icon: const Icon(
                                        Icons.edit,
                                        size: 80.0,
                                        color: Colors.grey,
                                      ),
                                      title:
                                          '@${_publicUser.username} has no post',
                                      subTitle:
                                          '@${_publicUser.username}\'s posts will be shown here.',
                                    )
                                  : Container(
                                      color: backgroundcolorinterface,
                                      child: GridView.builder(
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 5,
                                          crossAxisSpacing: 5,
                                        ),
                                        padding: const EdgeInsets.all(10.0),
                                        itemCount: _friendPosts.length,
                                        itemBuilder:
                                            (BuildContext context, int i) {
                                          return PostGridItem(
                                              post: _friendPosts[i],
                                              key: ValueKey(
                                                  _friendPosts[i].postId),
                                              hasMore: false,
                                              onTap: () {
                                                // _onPostTap(_friendPosts[i]);
                                              });
                                        },
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget OutlineButtonHeader() {
    return Container(
      height: 50.0,
      padding: const EdgeInsets.all(4.0),
      width: double.infinity,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Expanded(
            // child: Consumer<UserController>(
            //   builder: (_, userCtrl, __) {
            //     bool isConnected = userCtrl.isConnected(_publicUser.uid);
            child: MCustomButton(
                buttonType: connectedbutton == true
                    ? ButtonType.outline
                    : ButtonType.elevated,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: FittedBox(
                  child: connectedbutton
                      ? const Text(
                          'Connected',
                          style: TextStyle(color: primaryColorLT),
                        )
                      : const Text(
                          'Connect',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
                onPressed: () async {
                  //   String connectId =
                  //       MyConnect.connectId(userCtrl.user.uid, _publicUser.uid);
                  //   String puCountPath = Constants.USERS +
                  //       '/' +
                  //       _publicUser.uid +
                  //       '/' +
                  //       'connectionCount';
                  //   String myCountPath = Constants.USERS +
                  //       '/' +
                  //       _profileController.myProfile.uid +
                  //       '/' +
                  //       'connectedCount';
                  //   Map<String, dynamic> map = {};
                  //   if (isConnected) {
                  //     userCtrl.removeConnect(_publicUser.uid);
                  //     if (_publicUser.connectionCount > 0) {
                  //       _publicUser.connectionCount--;
                  //     }
                  //     setState(() {});

                  //     map[puCountPath] = _publicUser.connectionCount;
                  //     map[myCountPath] = userCtrl.user.connectedCount;
                  //     map[Constants.CONNECTIONS + '/' + connectId] = null;
                  //   } else {
                  //     MyConnect newConnect = MyConnect(
                  //       id: connectId,
                  //       connectedTo: _publicUser.uid,
                  //       connectedBy: _profileController.myProfile.uid,
                  //       timestamp: DateTime.now().millisecondsSinceEpoch,
                  //     );
                  //     userCtrl.updateConnect(newConnect);
                  //     map[Constants.CONNECTIONS + '/' + connectId] =
                  //         newConnect.toMap();
                  //     _sendNotification(_publicUser);
                  //     _publicUser.connectionCount++;
                  //     setState(() {});
                  //     debugPrint('asdfasdf ${_publicUser.connectionCount}');

                  //     map[puCountPath] = _publicUser.connectionCount;
                  //     map[myCountPath] = userCtrl.user.connectedCount;
                  //   }
                  //   debugPrint(
                  //       '_PublicProfileScreenState.OutlineButtonHeader: map $map');
                  //   // if(){
                  //   // await _firebase.updateDisconnected(
                  //   //     isConnected, _publicUser.uid, userCtrl.user);
                  //   // // }
                  //   // await _firebase.updateWithBatch(map);
                  // },
                })),
        Expanded(
          child: MCustomButton(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            onPressed: () => navigateTo(
              context,
              routeName: ChatRoomScreen.routeName,
              arguments: _publicUser,
            ),
            child: const Text('Message'),
          ),
        ),
        Expanded(
          child: MCustomButton(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              onPressed: () async {
                // final fUser =
                //     Provider.of<UserController>(context, listen: false);
                // if (fUser.user.connectedCount == 0 &&
                //     fUser.user.connectionCount == 0) {
                String message =
                    'Have a look at ${_publicUser.username ?? 'Business Bosses'} on Business Bosses\n'
                    'https://businessbosses.onelink.me/xLWk/36a2ff16';
                _sharePost(message);
                // }
              },
              child: const Text('Refer')
              // _loadUser(Params(arg1: _publicUser.uid));

              ),
        ),
        // child: ,
      ]),
    );
  }

  // Future<void> _onChangeConnectionStatus(
  //     MyConnect myNewConnect, MyUser publicUser) async {
  //   final meUser = Provider.of<UserController>(context, listen: false).user;
  //   String puCountPath =
  //       Constants.USERS + '/' + publicUser.uid + '/' + 'connectionCount';
  //   String myCountPath =
  //       Constants.USERS + '/' + _firebase.uid + '/' + 'connectedCount';
  //
  //   // String connectionPath = '${Constants.CONNECTIONS}/${myNewConnect.id}';
  //
  //   Map<String, dynamic> map = {};
  //   if (myNewConnect.id?.isNotEmpty ?? false) {
  //     map[puCountPath] = publicUser.connectionCount + 1;
  //     map[myCountPath] = meUser.connectedCount + 1;
  //     String key = _firebase.uniqueKey(Constants.CONNECTION);
  //
  //     // map[connectionPath] = myNewConnect.toMap();
  //     _sendNotification(_publicUser);
  //   } else if (myNewConnect.status == Constants.CONNECT) {
  //     // map[connectionPath] = null;
  //     map[puCountPath] = publicUser.connectionCount <= 0
  //         ? null
  //         : publicUser.connectionCount - 1;
  //     map[myCountPath] =
  //         meUser.connectionCount <= 0 ? null : meUser.connectedCount - 1;
  //   }
  //
  //   debugPrint('_AllConnectionsScreenState: status:  ${myNewConnect.status}');
  //
  //   MyResponse res = await _firebase.updateWithBatch(map);
  //   if (!res.success) {
  //     showSnackBar(context, message: res.message);
  //   }
  // }

// Future<void> _onChangeConnectionStatus(
//     MyConnect myNewConnect, MyUser publicUser) async {
//   final meUser = Provider.of<UserController>(context, listen: false).user;
//   // String myPath =
//   //     '${Constants.USERS}/${_firebase.uid}/${Constants.CONNECTS}/';
//   // String otherPath =
//   //     '${Constants.USERS}/${otherUser.uid}/${Constants.CONNECTS}/';
//
//   String puCountPath =
//       Constants.USERS + '/' + publicUser.uid + '/' + 'connectionCount';
//   String myCountPath =
//       Constants.USERS + '/' + _firebase.uid + '/' + 'connectedCount';
//   String connectionPath = '${Constants.CONNECTIONS}/${myNewConnect.id}';
//
//   Map<String, dynamic> map = {};
//   if (myNewConnect.status == Constants.CONNECTED) {
//     map[puCountPath] = publicUser.connectionCount + 1;
//     map[myCountPath] = meUser.connectedCount + 1;
//     map[connectionPath] = myNewConnect.toMap();
//     _sendNotification(_publicUser);
//   } else if (myNewConnect.status == Constants.CONNECT) {
//     map[connectionPath] = null;
//     map[puCountPath] = publicUser.connectionCount <= 0
//         ? null
//         : publicUser.connectionCount - 1;
//     map[myCountPath] =
//         meUser.connectionCount <= 0 ? null : meUser.connectedCount - 1;
//   }
//   // else if (myNewConnect.status == Constants.CONNECT_BACK) {
//   //   map['$myPath/${publicUser.uid}'] = null;
//   //   MyConnect otherConnect = MyConnect(status: Constants.CONNECTED);
//   //   map['$otherPath/${_firebase.uid}/status'] = otherConnect.status;
//   // } else if (myNewConnect.status == Constants.CONNECTION) {
//   //   _sendNotification(_friendUser);
//   //   map['$myPath/${publicUser.uid}'] = myNewConnect.toMap();
//   //   MyConnect otherConnect = MyConnect(status: Constants.CONNECTION);
//   //   map['$otherPath/${_firebase.uid}/status'] = otherConnect.status;
//   // }
//   debugPrint('_AllConnectionsScreenState: status:  ${myNewConnect.status}');
//
//   MyResponse res = await _firebase.updateWithBatch(map);
//   if (!res.success) {
//     showSnackBar(context, message: res.message);
//   }
// }

  // void _onPostTap(MyPost post) {
  //   navigateTo(context,
  //       routeName: PublicUserPostDetailsScreen.routeName, arguments: post);
  // }

  void _sendNotification(MyUser user) {
    if (user.deviceTokens == null) return;

    // String notiId = _firebase.uniqueKey(Constants.NOTIFICATIONS);
    // MyNotification noti = MyNotification();
    // noti.notificationId = notiId;
    // noti.dataId = _firebase.uid;
    // noti.senderUid = _firebase.uid;
    // noti.message = Provider.of<UserController>(context, listen: false).name +
    //     ' added you to their Connections.';
    // noti.title = 'Connection';
    // noti.readBy = [];
    // noti.timestamp = DateTime.now().millisecondsSinceEpoch;
    // noti.notificationType = Constants.NOTI_CONNECTION;
    // noti.tokens = user.deviceTokens;
    // noti.receiverUid = [user.uid];
    // noti.users = [user];
    // CloudFunctions cloudFunctions = CloudFunctions();
    // cloudFunctions.sendNotificationWithData(notification: noti);
  }

  Future<void> _onUrlLaunch(String url) async {
    try {
      await MyNativeFunctions.onUrlLaunch(url);
    } catch (e) {
      showSnackBar(context, message: e.toString());
    }
  }

  void _sharePost(message) {
    socialShare(message);
  }

  Widget FriendProfileHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserProfileTile(
            myProfile: _publicUser,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: CustomChildButton(
                  // TODO: CONNECTS
                  value: 0,
                  // value: _friendUser?.connects
                  //           ?.where((e) => e.status == Constants.CONNECTION)
                  //           ?.toList()
                  //           ?.length ??
                  //       0,
                  caption: 'Connections',
                  /*'Connections',*/
                  onPressed: () {
                    Get.toNamed(Routes.allconnectionsscreen);
                    // navigateTo(
                    //   context,
                    //   routeName: AllConnectionsScreen.routeName,
                    //   arguments: Params(arg1: _publicUser),
                    // );
                  },
                ),
              ),
              Expanded(
                  child: CustomChildButton(
                // TODO: CONNECTS
                value: 0,

                // value: _friendUser?.connects
                //           ?.where((e) => e.status != Constants.CONNECTION)
                //           ?.toList()
                //           ?.length ??
                //       0,
                caption: 'Connected',
                // 'Connected',
                onPressed: () {
                  Get.toNamed(Routes.allconnectionsscreen);
                  // navigateTo(
                  //   context,
                  //   routeName: AllConnectionsScreen.routeName,
                  //   arguments: Params(arg1: _publicUser, arg2: 1),
                  // );
                },
              )),
              Expanded(
                child: CustomChildButton(
                  value: 0,
                  //_publicUser.refers == null
                  //     ? 0
                  //     : MyUser.refCount(_publicUser.refers),
                  caption: 'Referrals',
                  onPressed: () {
                    navigateTo(
                      context,
                      routeName: ReferralsDetailsScreen.routeName,
                      arguments: _publicUser.refers,
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }

  // Future<void> _onSetProfileView(MyUser friend) async {
  //   int index = friend.profileViews
  //       ?.indexWhere((element) => element.uid == _firebase.uid);
  //   if (index != -1) return;
  //   String path = Constants.USERS + '/' + friend.uid + '/profileViews';

  //   ProfileViewer profileViewer = ProfileViewer(
  //       uid: _firebase.uid, timestamp: DateTime.now().millisecondsSinceEpoch);
  //   await _firebase.createANode(
  //     id: _firebase.uid,
  //     path: path,
  //     map: profileViewer.toMap(),
  //   );

  // showSnackBar(context, message: res.message);
  //}
}

// if ((_friendUser.ageRange?.isNotEmpty ?? false) ||
//     (_friendUser.gender?.isNotEmpty ?? false)) ...{
//   const SizedBox(height: 12.0),
//   Wrap(
//     children: [
//       if (_friendUser.ageRange?.isNotEmpty ?? false) ...{
//         RichText(
//           text: TextSpan(
//             children: [
//               TextSpan(
//                 text: 'Age Range: ',
//                 style:
//                     bodyText2.copyWith(fontWeight: FontWeight.w500),
//               ),
//               TextSpan(
//                 text: '${_friendUser.ageRange}',
//                 style: bodyText2,
//               ),
//             ],
//           ),
//         ),
//       },
//       if (_friendUser.gender?.isNotEmpty ?? false) ...{
//         SizedBox(
//           width: 12.0,
//         ),
//         RichText(
//           text: TextSpan(
//             children: [
//               TextSpan(
//                 text: 'Gender: ',
//                 style:
//                     bodyText2.copyWith(fontWeight: FontWeight.w500),
//               ),
//               TextSpan(
//                 text: '${_friendUser.gender}',
//                 style: bodyText2,
//               ),
//             ],
//           ),
//         ),
//       },
//     ],
//   ),
// },
/// /
//   () {
// final userCtrl =
//     Provider.of<UserController>(context, listen: false);
// // MyConnect newConnect = MyConnect(
// //   id: _firebase.uniqueKey(Constants.CONNECTIONS),
// //   connectedTo: _publicUser.uid,
// //   connectedBy: _firebase.uid,
// //   timestamp: DateTime.now().millisecondsSinceEpoch,
// // );
//
// debugPrint(
//     '_AllConnectionsScreenState: status: $_connectionStatus');
// if (_connectionStatus == Constants.CONNECT) {
//   _connectionStatus = Constants.CONNECTED;
//   userCtrl
//       .updateConnect(newConnect..status = _connectionStatus);
// } else if (_connectionStatus == Constants.CONNECTED) {
//   _connectionStatus = Constants.CONNECT;
//   userCtrl.removeConnect(_publicUser.uid);
// }
// _onChangeConnectionStatus(newConnect, _publicUser);
//
// // else if (_connectionStatus == Constants.CONNECTION) {
// //   newConnect.status = Constants.CONNECT_BACK;
// //   userCtrl.removeConnect(_friendUser.uid);
// // } else if (_connectionStatus == Constants.CONNECT_BACK) {
// //   newConnect.status = Constants.CONNECTION;
// //   userCtrl.updateConnect(newConnect);
// // }
//
// // setState(() {
// //   _connectionStatus = userCtrl.connectionStatus(_publicUser);
// // });
// }
_showMorePostOptions(
    BuildContext context, String type, String publicUserUid, String title) {
  // var user = Provider.of<UserController>(context, listen: false);
  // showModalBottomSheet<void>(
  //   context: context,
  //   isScrollControlled: true,
  //   shape: const RoundedRectangleBorder(
  //     borderRadius: BorderRadius.only(
  //       topLeft: Radius.circular(12.0),
  //       topRight: Radius.circular(12.0),
  //     ),
  //   ),
  //   builder: (BuildContext context) {
  //     return SizedBox(
  //       height: 140.0,
  //       child: Column(
  //         children: [
  //           const Padding(
  //             padding: EdgeInsets.all(8.0),
  //             child: Text(
  //               'Report',
  //               style: TextStyle(
  //                 fontSize: 20.0,
  //                 color: Colors.black,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //           ),
  //           ListTile(
  //             title: Text(title),
  //             // contentPadding: EdgeInsets.only(
  //             //   left: 2,
  //             //   right: 2
  //             // ),
  //             minLeadingWidth: 0.0,
  //             horizontalTitleGap: 3,
  //             leading: SizedBox(
  //                 height: 30,
  //                 width: 30,
  //                 // color: Colors.green,
  //                 child: SvgPicture.asset(
  //                   "assets/svgs/report.svg",
  //                   height: 40,
  //                 )),
  //             onTap: () async {
  //               var snackBar = SnackBar(
  //                 content: Text(type == "postReport"
  //                     ? 'Post reported Successfully.'
  //                     : 'Account reported Successfully'),
  //               );
  //               try {
  //                 // Navigator.pop(context);
  //                 String id = FirebaseDatabase.instance
  //                     .reference()
  //                     .child("reports")
  //                     .push()
  //                     .key;
  //                 Report report = Report(
  //                     timeStamp:
  //                         DateTime.now().millisecondsSinceEpoch.toString(),
  //                     reportedBy: user.user.uid,
  //                     type: type,
  //                     reportedAccountId: publicUserUid,
  //                     id: id);

  //                 await FirebaseDatabase.instance
  //                     .reference()
  //                     .child("reports")
  //                     .child(id)
  //                     .update(report.toMap());

  //                 Navigator.pop(context);
  //                 ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //               } catch (e) {
  //                 Navigator.pop(context);
  //                 const snackBarError = SnackBar(
  //                   content: Text('An error occurred. Try again later.'),
  //                 );
  //                 ScaffoldMessenger.of(context).showSnackBar(snackBarError);
  //               }
  //             },
  //           ),
  //           const SizedBox(height: 12.0),
  //         ],
  //       ),
  //     );
  //   },
  // );
}
