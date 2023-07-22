import 'package:business_bosses_v2/features/home/widgets/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../utils/theme/theme.dart';
import '../chat/controllers/chat_controller.dart';
import '../chat/models/my_message.dart';
import '../forum/models/forum_model.dart';
import '../home/controller/home_controller.dart';
import '../home/widgets/home_appbar.dart';
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

class _HomeScreenState extends State<HomeScreen> {
  // final ProfileController _profileController = Get.find();
  // int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
  // final GetStorage sandBox = GetStorage();
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    final HomeController homeController = Get.find();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !homeController.loadingMore.value) {
        homeController.fetchPosts();
      }
    });

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   addCoinDaily();
    // });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
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
                ? const Center(
                    child: CircularProgressIndicator(),
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
                            child: SingleChildScrollView(
                              controller: _scrollController,
                              child: Column(
                                children: <Widget>[
                                  const BossOfWeekProfileTile(),
                                  if (!controller.refreshing.value)
                                    ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: controller.mixedPosts.length,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        bool currentIndexIsForum = controller
                                            .mixedPosts[index]['isForum'];

                                        ForumModel? forumDetails =
                                            currentIndexIsForum
                                                ? controller.mixedPosts[index]
                                                    ['data']
                                                : null;
                                        PostModel? postDetails =
                                            currentIndexIsForum
                                                ? null
                                                : controller.mixedPosts[index]
                                                    ['data'];

                                        if (currentIndexIsForum) {
                                          return ForumItem(
                                            forum: forumDetails!,
                                            controller: controller,
                                          );
                                        } else {
                                          return PostTile(
                                            controller: controller,
                                            post: postDetails!,
                                            onPageChange: (int page) {
                                              if (widget.onPageChange != null) {
                                                widget.onPageChange!(page);
                                              }
                                            },
                                          );
                                        }
                                      },
                                    ),
                                  if (controller.loadingMore.value)
                                    const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  const SizedBox(
                                    height: 100,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        const BottomBar(
                          activeIndex: 0,
                        ),
                      ],
                    ),
                  ),
            // bottomNavigationBar: const BottomBar(activeIndex: 0),
          );
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
