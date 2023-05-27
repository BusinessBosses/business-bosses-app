import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/features/chat/controllers/chat_controller.dart';
import 'package:business_bosses_v2/features/chat/models/my_message.dart';
import 'package:business_bosses_v2/features/forum/models/forum_model.dart';
import 'package:business_bosses_v2/features/forum/widgets/forum_item.dart';
import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/home/widgets/home_appbar.dart';
import 'package:business_bosses_v2/features/posts/controllers/posts_controller.dart';
import 'package:business_bosses_v2/features/posts/models/post_model.dart';
import 'package:business_bosses_v2/features/posts/widgets/userpost_tile.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/features/profile/widgets/boss_of_the_week_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/widgets/text_widget.dart';
import '../../services/api_service.dart';
import '../../utils/constants/constants.dart';
import '../../utils/theme/theme.dart';

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
                    ),
                  );
                }),
              ),
              body: homeController.loading.value
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          BossOfWeekProfileTile(_profileController.myProfile,
                              myProfile: _profileController.myProfile),
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
                          SizedBox(
                            height: 100,
                          )
                        ],
                      ),
                    ),
            );
          },
        );
      },
    );
  }

  // /// DailyCoin
  // void addCoinDaily() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   int lastExecutionTimestamp = sandBox.read('lastExecutionTimestamp') ?? 0;
  //   DateTime currentDateTime =
  //       DateTime.fromMillisecondsSinceEpoch(currentTimestamp);
  //   DateTime lastExecutionDateTime =
  //       DateTime.fromMillisecondsSinceEpoch(lastExecutionTimestamp);
  //   if (currentDateTime.year != lastExecutionDateTime.year ||
  //       currentDateTime.month != lastExecutionDateTime.month ||
  //       currentDateTime.day != lastExecutionDateTime.day) {
  //     // The action hasn't been executed today, save the current timestamp
  //     ApiResponseModel user = await ApiService.get(
  //         path: 'users/${prefs.getString(Constants.USER_ID)}');
  //     sandBox.write('lastExecutionTimestamp', currentTimestamp);
  //     await ApiService.put(
  //       path: 'users/${prefs.getString(Constants.USER_ID)}',
  //       body: <String, dynamic>{
  //         'coinscount': (user.data['coinscount']) + 1,
  //       },
  //     );
  //     showCoinDialog();
  //   }
  // }

  // /// Show daily coin dialog
  // void showCoinDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) => AlertDialog(
  //       title: const TextWidget(
  //         text: 'Congratulations',
  //         fontWeight: FontWeight.bold,
  //         size: 20,
  //       ),
  //       content: TextWidget(
  //         text: 'You have earned 1 coin for logging into Business Bosses today',
  //         color: Colors.black.withOpacity(.8),
  //       ),
  //       actions: <Widget>[
  //         TextButton(
  //           onPressed: () {
  //             Navigator.of(context).pop();
  //           },
  //           child: const TextWidget(
  //             text: 'OK',
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }
}
