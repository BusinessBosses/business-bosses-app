import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/search/search_bar.dart';
import 'package:business_bosses_v2/features/search/tabs_pages_filter_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../action/action.dart';
import '../../common/params.dart';
import '../../common/widgets/safety_model.dart';
import '../../common/widgets/user_avatar_with_badge.dart';
import '../../utils/theme/theme.dart';
import '../forum/models/forum_model.dart';
import '../forum/presentation/specific_user_list_screen.dart';
import '../posts/models/post_model.dart';
import '../profile/presentation/publicprofilescreen.dart';
import 'my_search_tab.dart';

class CompleteSearchingScreen extends StatefulWidget {
  static const String routeName = '/complete-searching-screen';

  const CompleteSearchingScreen({Key? key}) : super(key: key);

  @override
  _CompleteSearchingScreenState createState() =>
      _CompleteSearchingScreenState();
}

class _CompleteSearchingScreenState extends State<CompleteSearchingScreen>
    with TickerProviderStateMixin {
  TabController _tabController;

  UserController userController;
  AllPostsForumsProvider postsForumsProvider;

  bool _isInit = false;

  List<MySearchTab> _tabs = [];
  List<MySearchTab>? _selectedTabs = [];

  List<UserModel> _allUsers = [];
  List<UserModel> _searchUsers = [];

  List<PostModel> _searchPosts = [];
  List<ForumModel> _searchForum = [];

  bool _hasFilter = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      _isInit = true;
      _fetchAllUsers();
      _initList();

      final List<MySearchTab> data =
          ModalRoute.of(context)?.settings.arguments as List<MySearchTab>;
      if (data != null) {
        _hasFilter = false;
        _selectedTabs = data;
      } else {
        _hasFilter = true;

        _selectedTabs?.addAll([..._tabs]);
      }

      _tabController =
          TabController(vsync: this, length: _selectedTabs!.length);
    }
  }

  void _initList() {
    _tabs = [
      MySearchTab(
        label: 'Users',
        widget: FilterUsers(),
      ),
      MySearchTab(
        label: 'Posts',
        widget: FilterPosts(),
      ),
      MySearchTab(
        label: 'Communities',
        widget: FilterForum(),
      ),
    ];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _selectedTabs!.length,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          titleSpacing: 0.0,
          automaticallyImplyLeading: false,
          leadingWidth: 48.0,
          leading: IconButton(
            alignment: Alignment.centerRight,
            onPressed: () => navigateTo(context),
            icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
          ),
          title: Searchbar(
            hintText: 'Search',
            onSubmit: _onSubmit,
          ),
          actions: [
            if (_hasFilter)
              IconButton(
                icon: SvgPicture.asset('assets/svgs/filter.svg'),
                onPressed: _filterPage,
              ),
          ],
          bottom: _selectedTabs!.length <= 1
              ? null
              : TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  tabs: _selectedTabs!
                      .map(
                        (MySearchTab e) => Tab(text: e.label),
                      )
                      .toList(),
                ),
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: _selectedTabs!
                    .map(
                      (MySearchTab e) => e.widget!,
                    )
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }

  int _pageIndex(String label) {
    return _selectedTabs!
        .indexWhere((MySearchTab element) => element.label == label);
  }

  void _filterPage() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0.0),
          content: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width * 0.9,
              child: TabsPagesFilterItem(
                allTab: MySearchTab.cloneList(_tabs),
                selectedTabs: MySearchTab.cloneList(_selectedTabs!),
                onFilterChange: _onFilterChange,
              ),
            ),
          ),
        );
      },
    );
  }

  void _onFilterChange(List<MySearchTab> newTabs) {
    _selectedTabs = newTabs;
    _tabController = TabController(vsync: this, length: _selectedTabs.length);
    setState(() {});
  }

  Future<void> _fetchAllUsers() async {}

  bool _isLoadingUser = false, _isLoadingPost = false, _isLoadingForum = false;

  Future<void> _onSubmit(String val) async {}
}

class FilterUsers extends StatefulWidget {
  final List<UserModel> filterItems;
  final bool isLoading;

  // ignore: public_member_api_docs
  const FilterUsers({
    Key? key,
    this.filterItems = const [],
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<FilterUsers> createState() => _FilterUsersState();
}

class _FilterUsersState extends State<FilterUsers> {
  final ScrollController _controller = ScrollController();

  final List<UserModel> _users = [];

  final List<String> _userUids = [];

  int _loadedItems = 0;

  bool _isLoading = true;

  bool _isLoadingNext = false;

  bool _isInit = false;

  _scrollListener() {
    if (_controller.position.atEdge) {
      if (_controller.position.pixels == 0) {
      } else {
        _loadNextConnections();
      }
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      getConnectedsConnections();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.filterItems.isEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Recommended Connections',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height - 182,
                color: Colors.white,
                child: _users.isEmpty
                    ? SafetyModel(
                        isLoading: _isLoading,
                        icon: const Icon(
                          Icons.person,
                          size: 80.0,
                          color: hintColor,
                        ),
                        title: 'There is no ${_prarams?.title ?? 'user'}',
                        // subTitle: 'Be the first one to like!',
                      )
                    : Stack(
                        children: [
                          ListView.builder(
                            padding: const EdgeInsets.only(bottom: 48.0),
                            controller: _controller,
                            itemCount: _users.length,
                            itemBuilder: (BuildContext context, int i) {
                              if (i == 0) {
                                return Consumer<UserController>(
                                  builder: (context, appUser, _) {
                                    bool isConnectd = appUser.isConnected(
                                        appUser
                                            .recommendedConnections.first.uid);
                                    if (!isConnectd &&
                                        appUser.recommendedConnections.first
                                                .isRanked ==
                                            true) {
                                      return Column(
                                        children: [
                                          ListTile(
                                            onTap: () async {
                                              var result = await navigateTo(
                                                context,
                                                routeName: PublicProfileScreen
                                                    .routeName,
                                                arguments: Params(
                                                    arg1: appUser
                                                        .recommendedConnections
                                                        .first
                                                        .uid),
                                              );
                                              if (result == null) {
                                                Navigator.of(context).pop();
                                              }
                                            },
                                            leading: UserAvatarWithBadge(
                                              user: appUser
                                                  .recommendedConnections.first,
                                              height: 48.0,
                                              width: 48.0,
                                              radius: 30.0,
                                              placeHolder: Icons.person,
                                            ),
                                            // NetworkImageWithPlaceHolder(
                                            //   imageUrl: _users[i].photoUrl,
                                            //   height: 48.0,
                                            //   width: 48.0,
                                            //   radius: 30.0,
                                            //   placeHolder: Icons.person,
                                            // ),
                                            trailing: SizedBox(
                                              height: 40,
                                              width: 120,
                                              child: Consumer<UserController>(
                                                builder: (_, userCtrl, __) {
                                                  bool isConnected = userCtrl
                                                      .isConnected(appUser
                                                          .recommendedConnections
                                                          .first
                                                          .uid);
                                                  return ElevatedButton(
                                                    child: Text(
                                                      isConnected
                                                          ? 'Connected'
                                                          : 'Connect',
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    onPressed: () async {
                                                      String connectId =
                                                          MyConnect.connectId(
                                                              userCtrl.user.uid,
                                                              appUser
                                                                  .recommendedConnections
                                                                  .first
                                                                  .uid);
                                                      String puCountPath =
                                                          Constants.USERS +
                                                              '/' +
                                                              appUser
                                                                  .recommendedConnections
                                                                  .first
                                                                  .uid +
                                                              '/' +
                                                              'connectionCount';
                                                      String myCountPath =
                                                          Constants.USERS +
                                                              '/' +
                                                              _firebase.uid +
                                                              '/' +
                                                              'connectedCount';
                                                      Map<String, dynamic> map =
                                                          {};
                                                      if (isConnected) {
                                                        userCtrl.removeConnect(
                                                            appUser
                                                                .recommendedConnections
                                                                .first
                                                                .uid);
                                                        if (appUser
                                                                .recommendedConnections
                                                                .first
                                                                .connectionCount >
                                                            0) {
                                                          appUser
                                                              .recommendedConnections
                                                              .first
                                                              .connectionCount--;
                                                        }
                                                        setState(() {});

                                                        map[puCountPath] = appUser
                                                            .recommendedConnections
                                                            .first
                                                            .connectionCount;
                                                        map[myCountPath] =
                                                            userCtrl.user
                                                                .connectedCount;
                                                        map[Constants
                                                                .CONNECTIONS +
                                                            '/' +
                                                            connectId] = null;
                                                      } else {
                                                        MyConnect newConnect =
                                                            MyConnect(
                                                          id: connectId,
                                                          connectedTo: appUser
                                                              .recommendedConnections
                                                              .first
                                                              .uid,
                                                          connectedBy:
                                                              _firebase.uid,
                                                          timestamp: DateTime
                                                                  .now()
                                                              .millisecondsSinceEpoch,
                                                        );
                                                        userCtrl.updateConnect(
                                                            newConnect);
                                                        map[Constants
                                                                    .CONNECTIONS +
                                                                '/' +
                                                                connectId] =
                                                            newConnect.toMap();
                                                        _sendNotification(appUser
                                                            .recommendedConnections
                                                            .first);
                                                        appUser
                                                            .recommendedConnections
                                                            .first
                                                            .connectionCount++;
                                                        setState(() {});
                                                        debugPrint(
                                                            'asdfasdf ${appUser.recommendedConnections.first.connectionCount}');

                                                        map[puCountPath] = appUser
                                                            .recommendedConnections
                                                            .first
                                                            .connectionCount;
                                                        map[myCountPath] =
                                                            userCtrl.user
                                                                .connectedCount;
                                                      }
                                                      // if(){
                                                      await _firebase.updateDisconnected(
                                                          isConnected,
                                                          appUser
                                                              .recommendedConnections
                                                              .first
                                                              .uid,
                                                          userCtrl.user);
                                                      // }
                                                      await _firebase
                                                          .updateWithBatch(map);
                                                    },
                                                  );
                                                },
                                                // child: ,
                                              ),
                                            ),
                                            title: Text(appUser
                                                .recommendedConnections
                                                .first
                                                .name),
                                            subtitle: Text(
                                              appUser.recommendedConnections
                                                  .first.bio,
                                              maxLines: 1,
                                            ),
                                          ),
                                          const Divider(
                                              height: 0.0,
                                              indent: 16.0,
                                              endIndent: 16.0),
                                        ],
                                      );
                                    } else {
                                      return Container();
                                    }
                                  },
                                );
                              }
                              return _users[i].isRanked == true
                                  ? Container()
                                  : Column(
                                      children: [
                                        ListTile(
                                          onTap: () async {
                                            var result = await navigateTo(
                                              context,
                                              routeName:
                                                  PublicProfileScreen.routeName,
                                              arguments:
                                                  Params(arg1: _users[i].uid),
                                            );
                                            if (result == null) {
                                              Navigator.of(context).pop();
                                            }
                                          },
                                          leading: UserAvatarWithBadge(
                                            user: _users[i],
                                            height: 48.0,
                                            width: 48.0,
                                            radius: 30.0,
                                            placeHolder: Icons.person,
                                          ),
                                          // NetworkImageWithPlaceHolder(
                                          //   imageUrl: _users[i].photoUrl,
                                          //   height: 48.0,
                                          //   width: 48.0,
                                          //   radius: 30.0,
                                          //   placeHolder: Icons.person,
                                          // ),
                                          trailing: SizedBox(
                                            height: 40,
                                            width: 120,
                                            child: Consumer<UserController>(
                                              builder: (_, userCtrl, __) {
                                                bool isConnected = userCtrl
                                                    .isConnected(_users[i].uid);
                                                return MCustomButton(
                                                    buttonType: isConnected
                                                        ? ButtonType.outline
                                                        : ButtonType.elevated,
                                                    margin: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 4.0),
                                                    child: FittedBox(
                                                      child: isConnected
                                                          ? const Text(
                                                              'Connected')
                                                          : const Text(
                                                              'Connect',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                    ),
                                                    onPressed: () =>
                                                        connectUserPressed(
                                                            i: i,
                                                            userCtrl: userCtrl,
                                                            isConnected:
                                                                isConnected));
                                              },
                                              // child: ,
                                            ),
                                          ),
                                          title: Text(_users[i].name),
                                          subtitle: Text(
                                            _users[i].bio,
                                            maxLines: 1,
                                          ),
                                        ),
                                        const Divider(
                                            height: 0.0,
                                            indent: 16.0,
                                            endIndent: 16.0),
                                      ],
                                    );
                            },
                          ),
                          if (_isLoadingNext)
                            const Positioned(
                              child: SafetyModel(isLoading: true),
                              bottom: 10.0,
                              right: 0.0,
                              left: 0.0,
                            ),
                        ],
                      ),
              )
            ],
          )
        : ListView.separated(
            key: ValueKey(widget.filterItems),
            separatorBuilder: (_, __) => const SizedBox(height: 8.0),
            padding: const EdgeInsets.all(16.0),
            itemCount: widget.filterItems.length,
            itemBuilder: (BuildContext context, int i) {
              return ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                tileColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                leading: UserAvatarWithBadge(
                  user: widget.filterItems[i],
                  height: 52.0,
                  width: 52.0,
                  radius: 50.0,
                  iconSize: 24.0,
                  placeHolder: Icons.person,
                ),
                title: Text(
                  widget.filterItems[i].name!,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                subtitle: Text(
                  widget.filterItems[i].username,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: textColor.withOpacity(0.6),
                      ),
                ),
                onTap: () {
                  navigateTo(
                    context,
                    routeName: PublicProfileScreen.routeName,
                    arguments: Params(arg1: widget.filterItems[i].uid),
                  );
                },
              );
            },
          );
  }

  getConnectedsConnections() async {
    if (userController.connectedList.isEmpty) {
      await postsForumsProvider.loadConnecteds(context);
    }

    if (!_isInit) {
      _controller.addListener(_scrollListener);
      // _prarams = ModalRoute.of(context).settings.arguments as ParamData;
      // if (_prarams == null) {
      //   navigateTo(context);
      //   return;
      // } else {
      //   _userUids = _prarams.data;
      _loadNextConnections();
      // }
      _isInit = true;
    }
  }

  Future<void> _loadNextConnections() async {}

  Future<void> connectUserPressed() async {}
}

class FilterPosts extends StatelessWidget {
  final List<MyPost> filterItems;
  final bool isLoading;

  const FilterPosts({
    Key key,
    this.filterItems = const [],
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('FilterPosts.build: $filterItems');
    return filterItems.isEmpty
        ? SafetyModel(
            icon: const Icon(
              Icons.edit,
              size: 80.0,
              color: hintColor,
            ),
            title: 'No post found',
            subTitle: 'Your search posts will be displayed here!',
            isLoading: isLoading,
          )
        : ListView.separated(
            key: key,
            separatorBuilder: (_, __) => const SizedBox(height: 8.0),
            padding: const EdgeInsets.all(16.0),
            itemCount: filterItems?.length ?? 0,
            itemBuilder: (BuildContext context, int i) {
              return UpdatedPostItem(
                  post: filterItems[i],
                  onLikeTap: (MyPost latestPost) {
                    filterItems[i] = latestPost;
                  },
                  onComment: (MyPost latestPost) {
                    filterItems[i] = latestPost;
                  });
            },
          );
  }
}

class FilterForum extends StatefulWidget {
  final List<MyForum> filterItems;
  final bool isLoading;

  const FilterForum({
    Key key,
    this.filterItems = const [],
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<FilterForum> createState() => _FilterForumState();
}

class _FilterForumState extends State<FilterForum> {
  @override
  Widget build(BuildContext context) {
    return widget.filterItems.isEmpty
        ? SafetyModel(
            icon: SvgPicture.asset(
              'assets/svgs/group.svg',
              height: 80.0,
              color: hintColor,
            ),
            title: 'No forum to show you',
            subTitle: 'Your search forums will be displayed here!',
            isLoading: widget.isLoading,
          )
        : ListView.separated(
            key: ValueKey(widget.filterItems),
            separatorBuilder: (_, __) => const SizedBox(height: 8.0),
            itemCount: widget.filterItems.length,
            itemBuilder: (BuildContext context, int i) {
              return UpdatedForumItem(widget.filterItems[i],
                  onLikeTap: (MyForum forum) async {
                widget.filterItems[i].likes = forum.likes;

                //                widget.filterItems[i].comments = forum.comments;
                // MyResponse res = await _firebase.fetchANode(
                //     id: forum.forumId, path: Constants.FORUMS);
                // if (res.success) {
                //   Forum latestForum = Forum.formSnapshot(res.data);
                //   if (latestForum.likes.contains(_firebase.uid)) {
                //     latestForum.likes.remove(_firebase.uid);
                //   } else {
                //     latestForum.likes.add(_firebase.uid);
                //   }
                //   MyResponse res2 = await _firebase.updateNode(
                //       id: forum.forumId,
                //       path: Constants.FORUMS,
                //       map: latestForum.toUpdateLikeMap());
                //   if (res2.success) {
                //     widget.filterItems[i].likes = latestForum.likes;
                //     setState(() {});
                //     // _sendNotification(latestForum, PostForumStatus.like);
                //   }
                // } else {
                //   showSnackBar(context, message: res.message);
                // }
              }, onCommentSent: (forum) {
                widget.filterItems[i].comments = forum.comments;
                setState(() {});
                // showBarModalBottomSheet(
                //     context: context,
                //     builder: (context) {
                //       return UpdatedForumLikeCommentItem(
                //         forum: forum,
                //         onComment: (Comment comment) async {
                //           final String path =
                //               '${Constants.FORUMS}/${forum.forumId}/${Constants.COMMENTS}';
                //           MyResponse res = await _firebase.createANode(
                //             id: comment.commentId,
                //             path: path,
                //             map: comment.toMap(),
                //           );
                //           if (res.success) {
                //             widget.filterItems[i].comments.add(comment);
                //             setState(() {});
                //             // _sendNotification(forum, PostForumStatus.comment);
                //             // Provider.of<AppCommunities>(context, listen: false)
                //             //     .oppForumsAddComment(forum.forumId, comment);
                //           }
                //         },
                //       );
                //     });
              });
            },
          );
  }
}
