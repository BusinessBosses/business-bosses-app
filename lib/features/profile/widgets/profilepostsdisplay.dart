import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/posts/models/post_model.dart';
import 'package:business_bosses_v2/features/posts/presentation/post_details_screen.dart';
import 'package:business_bosses_v2/features/posts/widgets/post_grid_item.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/widgets/safety_model.dart';

// /// PROFILE POST SCREEN
// Widget profilepostsdisplay(
//     BuildContext context, UserModel publicUser, List<PostModel> posts,
//     {bool loading = true, bool ispublicposts = false}) {
//   final HomeController homeController = Get.find();
//   final ProfileController profileController = Get.find();
//   return loading || posts.isEmpty
//       ? SafetyModel(
//           isLoading: loading,
//           icon: const Icon(
//             Icons.edit,
//             size: 80.0,
//             color: Colors.grey,
//           ),
//           title: 'User does not have a post',
//           subTitle: 'Posts appear here',
//           // clickableText: 'Create post',
//           // onTap: () => navigateTo(
//           //   context,
//           //   routeName: CreatePostScreen.routeName,
//           // ),
//         )
//       : Container(
//           height: double.infinity,
//           width: double.infinity,
//           color: backgroundcolorinterface,
//           child: GridView.builder(
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               mainAxisSpacing: 5,
//               crossAxisSpacing: 5,
//             ),
//             padding: const EdgeInsets.only(
//                 top: 10.0, bottom: 120, left: 10, right: 10),
//             itemCount: posts.length,
//             itemBuilder: (BuildContext context, int i) {
//               final bool hasIncrementedView = homeController
//                   .itemsWithIncrementedViews
//                   .contains(posts[i].postId);
//               return ispublicposts == false
//                   ? posts[i].user!.uid != profileController.myProfile.uid
//                       ? PostGridItem(
//                           post: posts[i],
//                           key: ValueKey<String>(posts[i].postId),
//                           onTap: () {
//                             if (hasIncrementedView == false) {
//                               homeController.itemsWithIncrementedViews
//                                   .add(posts[i].postId);
//                               posts[i].setViews(posts[i].views! + 1);
//                               profileController.updatePostViews(
//                                   posts[i], posts[i].views!);
//                             }
//                             Get.toNamed(Routes.postDetails,
//                                 arguments: posts[i]);
//                           },
//                           // onDeletePost:
//                           //     _onDeletePost,
//                           // onTap: () => _onPostTap(
//                           //     p.posts[i]),
//                         )
//                       : PostGridItem(
//                           post: posts[i],
//                           key: ValueKey<String>(posts[i].postId),
//                           onTap: () {
//                             if ((profileController.myProfile.uid ==
//                                 posts[i].user?.uid)) {
//                               if (hasIncrementedView == false) {
//                                 homeController.itemsWithIncrementedViews
//                                     .add(posts[i].postId);
//                                 posts[i].setViews(posts[i].views! + 1);
//                                 profileController.updatePostViews(
//                                     posts[i], posts[i].views!);
//                               }
//                               Get.toNamed(Routes.postDetails,
//                                   arguments: posts[i]);
//                             }
//                           },
//                           // onDeletePost:
//                           //     _onDeletePost,
//                           // onTap: () => _onPostTap(
//                           //     p.posts[i]),
//                         )
//                   : PostGridItem(
//                       hasMore: false,
//                       post: posts[i],
//                       key: ValueKey<String>(posts[i].postId),
//                       onTap: () {
//                         if (hasIncrementedView == false) {
//                           homeController.itemsWithIncrementedViews
//                               .add(posts[i].postId);
//                           posts[i].setViews(posts[i].views! + 1);
//                           profileController.updatePostViews(
//                               posts[i], posts[i].views!);
//                         }
//                         Get.toNamed(Routes.postDetails, arguments: posts[i]);
//                       },
//                       // onDeletePost:
//                       //     _onDeletePost,
//                       // onTap: () => _onPostTap(
//                       //     p.posts[i]),
//                     );
//             },
//           ),
//         );
// }

Widget profilepostsdisplay(
    BuildContext context, UserModel publicUser, List<PostModel> posts,
    {bool loading = true, bool ispublicposts = false}) {
  final HomeController homeController = Get.find();
  final ProfileController profileController = Get.find();

  return loading || posts.isEmpty
      ? SafetyModel(
          isLoading: loading,
          icon: const Icon(
            Icons.edit,
            size: 80.0,
            color: Colors.grey,
          ),
          title: 'User does not have a post',
          subTitle: 'Posts appear here',
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
              final bool hasIncrementedView = homeController
                  .itemsWithIncrementedViews
                  .contains(posts[i].postId);
              return PostGridItem(
                post: posts[i],
                key: ValueKey<String>(posts[i].postId),
                onTap: () {
                  if (!hasIncrementedView) {
                    homeController.itemsWithIncrementedViews
                        .add(posts[i].postId);
                    posts[i].setViews(posts[i].views! + 1);
                    profileController.updatePostViews(
                        posts[i], posts[i].views!);
                  }
                  Get.to(() => PostDetailsScreen(post: posts[i]));
                },
              );
            },
          ),
        );
}
