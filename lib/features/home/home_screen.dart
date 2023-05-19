import 'package:business_bosses_v2/features/chat/controllers/chat_controller.dart';
import 'package:business_bosses_v2/features/chat/models/my_message.dart';
import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/home/widgets/home_appbar.dart';
import 'package:business_bosses_v2/features/posts/controllers/posts_controller.dart';
import 'package:business_bosses_v2/features/posts/presentation/widgets/userpost_tile.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/theme/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.onPageChange});

  final Function(int)? onPageChange;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProfileController _profileController = Get.find();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (_homeController) {
        return GetBuilder<PostsController>(
          builder: (PostsController controller) {
            return Scaffold(
              backgroundColor: backgroundcolorinterface,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(kToolbarHeight),
                child: GetBuilder<ChatController>(builder: (controller) {
                  final List<MessageModel> unseenChats = controller.chats
                      .where((element) =>
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
                    ),
                  );
                }),
              ),
              body: _homeController.loading.value
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemCount: controller.posts.length,
                      // physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return PostTile(
                          controller: controller,
                          post: controller.posts[index],
                          onPageChange: (int page) {
                            if (widget.onPageChange != null) {
                              widget.onPageChange!(page);
                            }
                          },
                        );
                      },
                    ),
            );
          },
        );
      },
    );
  }
}
