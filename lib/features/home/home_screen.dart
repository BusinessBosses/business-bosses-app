import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../utils/theme/theme.dart';
import '../chat/controllers/chat_controller.dart';
import '../chat/models/my_message.dart';
import '../forum/models/forum_model.dart';
import '../forum/widgets/forum_item.dart';
import '../home/controller/home_controller.dart';
import '../home/widgets/home_appbar.dart';
import '../posts/controllers/posts_controller.dart';
import '../posts/models/post_model.dart';
import '../posts/widgets/userpost_tile.dart';
import '../profile/controller/profile_controller.dart';
import '../profile/widgets/boss_of_the_week_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.onPageChange});

  final Function(int)? onPageChange;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProfileController _profileController = Get.find();
  int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
  final GetStorage sandBox = GetStorage();

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   addCoinDaily();
    // });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (HomeController homeController) {
        return GetBuilder<PostsController>(
          builder: (PostsController controller) {
            return Scaffold(
              backgroundColor: backgroundcolorinterface,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight),
                child: GetBuilder<ChatController>(
                    builder: (ChatController controller) {
                  final List<MessageModel> unseenChats = controller.chats
                      .where((MessageModel element) =>
                          element.receiverUid ==
                              _profileController.myProfile.uid &&
                          !element.seen)
                      .toList();
                  final bool hasBadge = unseenChats.isNotEmpty;
                  return GetBuilder<ProfileController>(
                    builder: (ProfileController profileController) =>
                        Homeappbar(
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
              body: homeController.loading.value
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : RefreshIndicator(
                      onRefresh: refreshData,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            const BossOfWeekProfileTile(),
                            if (!homeController.refreshing.value)
                              //   const Center(
                              //     child: CircularProgressIndicator(),
                              //   )
                              // else
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: controller.mixedPosts.length,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  bool currentIndexIsForum =
                                      controller.mixedPosts[index]['isForum'];

                                  ForumModel? forumDetails = currentIndexIsForum
                                      ? controller.mixedPosts[index]['data']
                                      : null;
                                  PostModel? postDetails = currentIndexIsForum
                                      ? null
                                      : controller.mixedPosts[index]['data'];

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
                            const SizedBox(
                              height: 100,
                            )
                          ],
                        ),
                      ),
                    ),
            );
          },
        );
      },
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
