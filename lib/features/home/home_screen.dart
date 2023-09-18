import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/forum/controller/bossup_controller.dart';
import 'package:business_bosses_v2/features/home/widgets/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../utils/theme/theme.dart';
import '../chat/controllers/chat_controller.dart';
import '../chat/models/my_message.dart';
import '../forum/models/forum_model.dart';
import '../home/controller/home_controller.dart';
import '../home/widgets/home_appbar.dart';
import '../marketplace/controllers/market_controller.dart';
import '../posts/models/post_model.dart';
import '../posts/widgets/userpost_tile.dart';
import '../profile/controller/profile_controller.dart';
import '../profile/widgets/boss_of_the_week_tile.dart';
import 'widgets/forum_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.onPageChange});

  final Function(int)? onPageChange;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final ProfileController _profileController = Get.find();
  // int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
  // final GetStorage sandBox = GetStorage();
  final ScrollController _scrollController = ScrollController();
  final MarketController marketController = Get.put(MarketController());
  final BossUpController bossUpController = Get.put(BossUpController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final HomeController homeController = Get.find();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 300 &&
          !homeController.loadingMore.value) {
        homeController.fetchPosts();
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final HomeController homeController = Get.find();

    if (state.index == 0) {
      homeController.fetchPosts(fromBackground: true);
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Exit App'),
                content: const Text('Are you sure you want to exit?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text('Yes'),
                  ),
                ],
              );
            }).then((dynamic exit) {
          if (exit == true) {
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          }
        });
        return false;
      },
      child: GetBuilder<HomeController>(
        builder: (HomeController controller) {
          return Scaffold(
            backgroundColor: backgroundcolorinterface,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: GetBuilder<ChatController>(
                  builder: (ChatController chatController) {
                final List<MessageModel> unseenChats = chatController.chats
                    .where((MessageModel element) =>
                        element.receiverUid ==
                            controller.profileController.myProfile.uid &&
                        !element.seen)
                    .toList();
                final bool hasBadge = unseenChats.isNotEmpty;
                return GetBuilder<ProfileController>(
                  builder: (ProfileController profileController) => Homeappbar(
                    hasBadge: hasBadge,
                    coinsCount:
                        profileController.myProfile.coinscount?.toString() ??
                            '',
                    hasUnreadNotification:
                        profileController.myProfile.unReadCount != null &&
                            profileController.myProfile.unReadCount! > 0,
                  ),
                );
              }),
            ),
            body: controller.loading.value
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 50.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    'assets/app/app_logo_2.png',
                                    height: 40,
                                    width: 40,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 45,
                                height: 45,
                                child: CircularProgressIndicator(),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Text(
                              'Start, Grow and Promote Your Business Globally',
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : controller.error.value
                    ? SafetyModel(
                        isLoading: false,
                        title:
                            'Error While Loading Data\nCheck your Internet Connection',
                        subTitle: 'Try Reloading Again',
                        clickableText: 'Refresh',
                        onTap: () {
                          controller.loadData();
                          _profileController.fetchData();
                          _profileController.loadBoss();
                          marketController.initMarket();
                          marketController.initUsers();
                          bossUpController.fetchForums();
                        },
                        icon: const Icon(
                          Icons.warning,
                          size: 60,
                        ),
                      )
                    : SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Stack(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.white,
                              child: RefreshIndicator(
                                onRefresh: refreshData,
                                child: ListView.builder(
                                  controller: _scrollController,
                                  shrinkWrap: true,
                                  itemCount: controller.mixedPosts.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final bool hasIncrementedView = controller
                                        .itemsWithIncrementedViews
                                        .contains(index);
                                    if (index == 0) {
                                      return const BossOfWeekProfileTile();
                                    } else {
                                      final mixedPost =
                                          controller.mixedPosts[index];

                                      if (mixedPost['isForum']) {
                                        // Handle ForumModel
                                        final forumModel =
                                            mixedPost['data'] as ForumModel;
                                        return ForumItem(
                                          forum: forumModel,
                                          controller: controller,
                                        );
                                      } else if (mixedPost['isSponsored']) {
                                        // Handle Sponsored PostModel
                                        final sponsoredIndex =
                                            (index / 3).floor();
                                        if (sponsoredIndex <
                                            controller.sponsoredPosts.length) {
                                          final promotedPosts =
                                              controller.sponsoredPosts[
                                                  sponsoredIndex]['data'];
                                          return VisibilityDetector(
                                            key: Key(index.toString()),
                                            onVisibilityChanged:
                                                (VisibilityInfo info) {
                                              if (info.visibleFraction == 1.0 &&
                                                  !hasIncrementedView) {
                                                controller
                                                    .updateViews(promotedPosts);
                                                setState(() {
                                                  controller
                                                      .itemsWithIncrementedViews
                                                      .add(
                                                          index); // Set the flag to prevent further increments
                                                });
                                              }
                                            },
                                            child: PostTile(
                                              controller: controller,
                                              post: promotedPosts,
                                              onPageChange: (int page) {
                                                if (widget.onPageChange !=
                                                    null) {
                                                  widget.onPageChange!(page);
                                                }
                                              },
                                            ),
                                          );
                                        } else {
                                          // Handle case where there are no more sponsored posts
                                          return const SizedBox(); // You can return an empty widget or something else
                                        }
                                      } else if (index % 3 == 0) {
                                        // Display Sponsored Post after every 3 non-sponsored posts
                                        final sponsoredIndex =
                                            (index / 3).floor();
                                        if (sponsoredIndex <
                                            controller.sponsoredPosts.length) {
                                          final promotedPosts =
                                              controller.sponsoredPosts[
                                                  sponsoredIndex]['data'];
                                          return VisibilityDetector(
                                            key: Key(index.toString()),
                                            onVisibilityChanged:
                                                (VisibilityInfo info) {
                                              if (info.visibleFraction == 1.0 &&
                                                  !hasIncrementedView) {
                                                controller
                                                    .updateViews(promotedPosts);
                                                setState(() {
                                                  controller
                                                      .itemsWithIncrementedViews
                                                      .add(index);
                                                });
                                              }
                                            },
                                            child: PostTile(
                                              controller: controller,
                                              post: promotedPosts,
                                              onPageChange: (int page) {
                                                if (widget.onPageChange !=
                                                    null) {
                                                  widget.onPageChange!(page);
                                                }
                                              },
                                            ),
                                          );
                                        } else {
                                          // Handle case where there are no more sponsored posts
                                          return const SizedBox(); // You can return an empty widget or something else
                                        }
                                      } else {
                                        // Handle regular non-promoted PostModel
                                        final nonPromotedPostModel =
                                            mixedPost['data'] as PostModel;
                                        return VisibilityDetector(
                                          key: Key(index.toString()),
                                          onVisibilityChanged:
                                              (VisibilityInfo info) {
                                            if (info.visibleFraction == 1.0 &&
                                                !hasIncrementedView) {
                                              controller.updateViews(
                                                  nonPromotedPostModel);
                                              setState(() {
                                                controller
                                                    .itemsWithIncrementedViews
                                                    .add(index);
                                              });
                                            }
                                          },
                                          child: PostTile(
                                            controller: controller,
                                            post: nonPromotedPostModel,
                                            onPageChange: (int page) {
                                              if (widget.onPageChange != null) {
                                                widget.onPageChange!(page);
                                              }
                                            },
                                          ),
                                        );
                                      }
                                    }
                                  },
                                ),
                              ),
                            ),
                            const BottomBar(
                              activeIndex: 0,
                            ),
                          ],
                        ),
                      ),
          );
          // return Scaffold(
          // backgroundColor: backgroundcolorinterface,
          // appBar: PreferredSize(
          //   preferredSize: const Size.fromHeight(kToolbarHeight),
          //   child: GetBuilder<ChatController>(
          //       builder: (ChatController chatController) {
          //     final List<MessageModel> unseenChats = chatController.chats
          //         .where((MessageModel element) =>
          //             element.receiverUid ==
          //                 controller.profileController.myProfile.uid &&
          //             !element.seen)
          //         .toList();
          //     final bool hasBadge = unseenChats.isNotEmpty;
          //     return GetBuilder<ProfileController>(
          //       builder: (ProfileController profileController) => Homeappbar(
          //         hasBadge: hasBadge,
          //         coinsCount:
          //             profileController.myProfile.coinscount?.toString() ??
          //                 '',
          //         hasUnreadNotification:
          //             profileController.myProfile.unReadCount != null &&
          //                 profileController.myProfile.unReadCount! > 0,
          //       ),
          //     );
          //   }),
          // ),
          // body: controller.loading.value
          //     ? const Center(
          //         child: CircularProgressIndicator(),
          //       )
          //     : SizedBox(
          //         height: MediaQuery.of(context).size.height,
          //         width: MediaQuery.of(context).size.width,
          //         child: Stack(
          //           children: [
          //             Container(
          //               height: MediaQuery.of(context).size.height,
          //               width: MediaQuery.of(context).size.width,
          //               color: Colors.white,
          //               child: RefreshIndicator(
          //                 onRefresh: refreshData,
          //                 child: SingleChildScrollView(
          //                   controller: _scrollController,
          //                   child: Column(
          //                     children: <Widget>[
          //                       const BossOfWeekProfileTile(),
          //                       if (!controller.refreshing.value)
          // ListView.builder(
          //   shrinkWrap: true,
          //   itemCount: controller.mixedPosts.length,
          //   physics:
          //       const NeverScrollableScrollPhysics(),
          //   itemBuilder:
          //       (BuildContext context, int index) {
          //     bool currentIndexIsForum = controller
          //         .mixedPosts[index]['isForum'];

          //     ForumModel? forumDetails =
          //         currentIndexIsForum
          //             ? controller.mixedPosts[index]
          //                 ['data']
          //             : null;
          //     PostModel? postDetails =
          //         currentIndexIsForum
          //             ? null
          //             : controller.mixedPosts[index]
          //                 ['data'];

          //     if (currentIndexIsForum) {
          //       return ForumItem(
          //         forum: forumDetails!,
          //         controller: controller,
          //       );
          //     } else {
          //       return PostTile(
          //         controller: controller,
          //         post: postDetails!,
          //         onPageChange: (int page) {
          //           if (widget.onPageChange != null) {
          //             widget.onPageChange!(page);
          //           }
          //         },
          //       );
          //     }
          //   },
          // ),
          //                       if (controller.loadingMore.value)
          //                         const Center(
          //                           child: CircularProgressIndicator(),
          //                         ),
          //                       const SizedBox(
          //                         height: 100,
          //                       )
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //             ),
          //             const BottomBar(
          //               activeIndex: 0,
          //             ),
          //           ],
          //         ),
          //       ),
          //   // bottomNavigationBar: const BottomBar(activeIndex: 0),
          // );
        },
      ),
    );
  }

  Future<void> loadData() async {
    setState(() {});

    // Call the loadPosts() function from the PostsController
    // await Get.find<PostsController>().loadPosts();
    await Get.find<HomeController>().refreshData();

    setState(() {});
  }

  Future<void> refreshData() async {
    await loadData(); // Trigger data reload
  }
}
