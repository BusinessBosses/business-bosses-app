import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../action/action.dart';
import '../../common/models/my_connect.dart';
import '../../common/params.dart';
import '../../common/widgets/buttons/custom_child_button.dart';
import '../../common/widgets/buttons/my_outlined_button.dart';
import '../../common/widgets/safety_model.dart';
import '../../functions/my_native_functions.dart';
import '../../utils/theme/theme.dart';
import '../chat/chat_room_screen.dart';
import '../connects/all_connections_screen.dart';
import '../posts/models/post_model.dart';
import '../posts/presentation/widgets/post_grid_item.dart';

var isExpanded = false;

class PublicProfileScreen extends StatefulWidget {
  static const routeName = '/public-profile-screen';

  const PublicProfileScreen({Key? key}) : super(key: key);

  @override
  _PublicProfileScreenState createState() => _PublicProfileScreenState();
}

class _PublicProfileScreenState extends State<PublicProfileScreen> {
  UserModel _publicUser = UserModel();
  bool _isInit = false;
  bool _isLoading = false;
  bool blocked = false;

  List<PostModel> _friendPosts = [];

  bool _hasUser = true;
  MyConnect _connectionData = MyConnect();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> _loadUser(Params params) async {}

  Future<void> _loadMyPost() async {}

  // Widget _buildChoiceChips(String data) {
  //   return SizedBox(
  //       child: Padding(
  //     padding: const EdgeInsets.only(left: 20, right: 20),
  //     child: ListView.builder(
  //       shrinkWrap: true,
  //       physics: const NeverScrollableScrollPhysics(),
  //       // ignore: unnecessary_null_comparison
  //       itemCount: data == null ? 0 : data.split('+').length,
  //       itemBuilder: (BuildContext context, int index) {
  //         return Wrap(
  //           spacing: 8.0, // gap between adjacent chips
  //           runSpacing: 4.0, // gap between lines
  //           children: <Widget>[
  //             Chip(
  //               backgroundColor: backgroundcolorinterface,
  //               avatar: const CircleAvatar(
  //                 backgroundColor: Colors.white,
  //                 radius: 5,
  //               ),
  //               label: Text(
  //                 data.split('+')[index],
  //                 style: const TextStyle(
  //                     fontSize: 15, fontWeight: FontWeight.w700),
  //               ),
  //             ),
  //           ],
  //         );
  //       },
  //     ),
  //   ));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        ),
        title: Text('@${_publicUser.username ?? ''}'),
        actions: [
          _publicUser.uid != '_firebase.uid'
              ? Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: InkWell(
                      onTap: () {},
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
          : _isLoading
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
                        // if (_publicUser.uid !=
                        //     FirebaseAuth.instance.currentUser.uid) ...{
                        OutlineButtonHeader(),
                        //   const SizedBox(height: 8.0),
                        // },

                        Material(
                          color: Colors.white,
                          child: TabBar(
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
                                        text: '_publicUser.bio',
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
                                      padding: const EdgeInsets.only(left: 15),
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
                                                        '_publicUser.website',
                                                        MyUrl.url);
                                                debugPrint(
                                                    'complete url : $url');
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
                                                    '_publicUser.website',
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
                                                        '_publicUser.twitter',
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
                                                        '_publicUser.instagram',
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
                                  ])),
                              _friendPosts.isEmpty
                                  ? SingleChildScrollView(
                                      child: SafetyModel(
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
                                      ),
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
                                        itemBuilder: (context, i) {
                                          return PostGridItem(
                                              post: _friendPosts[i],
                                              key: ValueKey(
                                                  _friendPosts[i].postId),
                                              hasMore: false,
                                              onTap: () {
                                                _onPostTap(_friendPosts[i]);
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
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
              onPressed: () async {},
              child: const Text('Refer'),
            ),
          ),
        ],
      ),
    );
  }

  void _onPostTap(PostModel post) {
    // navigateTo(context,
    //     routeName: PublicUserPostDetailsScreen.routeName, arguments: post);
  }

  void _sendNotification(UserModel user) {
    if (user.deviceTokens == null) return;
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
          // UserProfileTile(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: CustomChildButton(
                  value: _publicUser?.connectionCount ?? 0,
                  caption: 'Connections',
                  /*'Connections',*/
                  onPressed: () {
                    navigateTo(
                      context,
                      routeName: AllConnectionsScreen.routeName,
                      arguments: Params(arg1: _publicUser),
                    );
                  },
                ),
              ),
              // Expanded(
              //   child: Consumer<AppCommunities>(
              //     builder: (context, appForum, _) {
              //       return CustomChildButton(
              //         // TODO: CONNECTS
              //         value: _publicUser?.connectedCount ?? 0,

              //         caption: 'Connected',
              //         // 'Connected',
              //         onPressed: () {
              //           navigateTo(
              //             context,
              //             routeName: AllConnectionsScreen.routeName,
              //             arguments: Params(arg1: _publicUser, arg2: 1),
              //           );
              //         },
              //       );
              //     },
              //   ),
              // ),
              Expanded(
                child: CustomChildButton(
                  value: _publicUser?.refers == null ? 0 : 10,
                  caption: 'Referrals',
                  onPressed: () {
                    // navigateTo(
                    //   context,
                    //   routeName: ReferralsDetailsScreen.routeName,
                    //   arguments: _publicUser.refers,
                    // );
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

  Future<void> _onSetProfileView(UserModel friend) async {}
}

_showMorePostOptions(
    BuildContext context, String type, String publicUserUid, String title) {}
