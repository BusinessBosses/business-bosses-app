import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../action/action.dart';
import '../../../common/widgets/safety_model.dart';
import '../../posts/presentation/create_post_screen.dart';
import '../controller/profile_controller.dart';

Widget profilepostsdisplay(BuildContext context) {
  final ProfileController _profileController = Get.find();
  return // ChangeNotifierProvider<MyPosts>(
      //   create: (_) => MyPosts(),
      //   child: Consumer<MyPosts>(
      //     builder: (BuildContext context, MyPosts p,
      //             _) =>
      //         p.posts.isEmpty
      //?
      SafetyModel(
    isLoading: false,
    icon: const Icon(
      Icons.edit,
      size: 80.0,
      color: Colors.grey,
    ),
    title: 'You\'ve no post',
    subTitle: 'Create a post to view here',
    clickableText: 'Create post',
    onTap: () => navigateTo(
      context,
      routeName: CreatePostScreen.routeName,
    ),
  );
  // : Container(
  //     height: double.infinity,
  //     width: double.infinity,
  //     color:
  //         backgroundcolorinterface,
  //     child: GridView.builder(
  //       gridDelegate:
  //           const SliverGridDelegateWithFixedCrossAxisCount(
  //         crossAxisCount: 2,
  //         mainAxisSpacing: 5,
  //         crossAxisSpacing: 5,
  //       ),
  //       padding:
  //           const EdgeInsets.only(
  //               top: 10.0,
  //               bottom: 120,
  //               left: 10,
  //               right: 10),
  //       itemCount: p.posts.length,
  //       itemBuilder:
  //           (BuildContext context,
  //               int i) {
  //         return PostGridItem(
  //           post: p.posts[i],
  //           key: ValueKey(
  //               p.posts[i].postId),
  //           onDeletePost:
  //               _onDeletePost,
  //           onTap: () => _onPostTap(
  //               p.posts[i]),
  //         );
  //       },
  //     ),
  //   ),
}
