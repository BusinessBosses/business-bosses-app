import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/posts/models/post_model.dart';
import 'package:business_bosses_v2/features/posts/presentation/widgets/post_grid_item.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../action/action.dart';
import '../../../common/widgets/safety_model.dart';
import '../../posts/presentation/create_post_screen.dart';
import '../controller/profile_controller.dart';

Widget profilepostsdisplay(
    BuildContext context, UserModel publicUser, List<PostModel> posts,
    {bool loading = true}) {
  // final ProfileController _profileController = Get.find();
  return // ChangeNotifierProvider<MyPosts>(
      //   create: (_) => MyPosts(),
      //   child: Consumer<MyPosts>(
      //     builder: (BuildContext context, MyPosts p,
      //             _) =>
      //         p.posts.isEmpty
      //?
      loading || posts.isEmpty
          ? SafetyModel(
              isLoading: loading,
              icon: const Icon(
                Icons.edit,
                size: 80.0,
                color: Colors.grey,
              ),
              title: 'User does not have a post',
              subTitle: 'Posts appear here',
              // clickableText: 'Create post',
              // onTap: () => navigateTo(
              //   context,
              //   routeName: CreatePostScreen.routeName,
              // ),
            )
          : Container(
              height: double.infinity,
              width: double.infinity,
              color: backgroundcolorinterface,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                ),
                padding: const EdgeInsets.only(
                    top: 10.0, bottom: 120, left: 10, right: 10),
                itemCount: posts.length,
                itemBuilder: (BuildContext context, int i) {
                  return PostGridItem(
                    post: posts[i],
                    key: ValueKey(posts[i].postId),
                    // onDeletePost:
                    //     _onDeletePost,
                    // onTap: () => _onPostTap(
                    //     p.posts[i]),
                  );
                },
              ),
            );
}
