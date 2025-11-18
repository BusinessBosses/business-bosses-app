import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/features/forum/models/forum_model.dart';
import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class LearningPostsController extends GetxController {
  late IO.Socket socket;
  final HomeController _homeController = Get.find();
  final ProfileController _profileController = Get.find();

  List<ForumModel> learningPosts = <ForumModel>[];
  RxInt totalPosts = 0.obs;
  RxInt page = 0.obs;
  RxBool loading = false.obs;
  RxBool loadingMore = false.obs;
  RxBool error = false.obs;
  RxBool hasMore = true.obs;
  final int pageSize = 20;

  @override
  void onInit() {
    socket = _homeController.socket;
    fetchLearningPosts();
    super.onInit();
  }

  Future<void> fetchLearningPosts({bool isLoadMore = false}) async {
    if (isLoadMore) {
      if (loadingMore.value || !hasMore.value) return;
      loadingMore(true);
    } else {
      loading(true);
      error(false);
      learningPosts.clear();
      page(0);
      hasMore(true);
    }

    update();

    try {
      final String endpoint = 'forum/get?page=${page.value}&size=$pageSize';

      // Wrap the API call in try/catch to prevent FormatException
      ApiResponseModel response;
      try {
        response = await ApiService.get(path: endpoint);
      } catch (_) {
        response = ApiResponseModel(
            success: false,
            message: 'Invalid response',
            data: <dynamic, dynamic>{});
      }

      if (response.success) {
        final dynamic responseData = response.data;
        List<dynamic> rows = <dynamic>[];

        if (responseData is Map) {
          rows = responseData['rows'] ??
              responseData['content'] ??
              responseData['data'] ??
              <dynamic>[];
          if (responseData['count'] != null) {
            totalPosts(int.parse(responseData['count'].toString()));
          } else if (responseData['totalElements'] != null) {
            totalPosts(int.parse(responseData['totalElements'].toString()));
          }
        } else if (responseData is List) {
          rows = responseData;
        }

        for (int i = 0; i < rows.length; i++) {
          try {
            if (rows[i]['user'] != null) {
              final Map<String, dynamic> cleanedData = <String, dynamic>{
                ...rows[i],
                'likes': rows[i]['likes'] is List
                    ? rows[i]['likes']
                        .map((like) =>
                            like is String ? like : like['userId'].toString())
                        .toList()
                    : <String>[],
                'coins': rows[i]['coins'] is List
                    ? rows[i]['coins']
                        .map((coin) =>
                            coin is String ? coin : coin['userId'].toString())
                        .toList()
                    : <String>[],
                'comments': rows[i]['comments'] ?? <dynamic>[],
                'views': rows[i]['views'] ?? 0,
              };
              learningPosts.add(ForumModel.fromMap(cleanedData));
            }
          } catch (_) {
            // silently ignore individual post parsing errors
          }
        }

        if (rows.length < pageSize) hasMore(false);
        page(page.value + 1);
      } else {
        error(true); // show error UI, no toast
      }
    } catch (_) {
      error(true); // silently handle unexpected errors
    } finally {
      loading(false);
      loadingMore(false);
      update();
    }
  }

  void updatePostViews(ForumModel post) {
    final int postIndex =
        learningPosts.indexWhere((ForumModel e) => e.forumId == post.forumId);
    if (postIndex != -1) {
      post.setViews(post.views! + 1);
      update();

      // optionally update backend
      ApiService.post(
        path: 'forum/update-views',
        body: <String, dynamic>{'forumId': post.forumId, 'views': post.views},
      );
    }
  }

  void postLike(String userId, String postId, String type, String receiverUid) {
    final int postIndex =
        learningPosts.indexWhere((ForumModel e) => e.forumId == postId);
    if (postIndex != -1) {
      final bool alreadyLiked =
          learningPosts[postIndex].likes!.contains(userId);
      if (alreadyLiked) {
        learningPosts[postIndex].likes!.remove(userId);
      } else {
        learningPosts[postIndex].likes!.add(userId);
      }
    }
    update();

    final Map<String, String> payload = <String, String>{
      'postId': postId,
      'userId': userId,
      'type': type,
    };
    if (_profileController.myProfile.uid != receiverUid) {
      payload['receiverUid'] = receiverUid;
    }

    socket.emit('like', payload);
  }

  void postCoin(String userId, String postId,
      ProfileController profileController, String type, String receiverUid) {
    final int postIndex =
        learningPosts.indexWhere((ForumModel e) => e.forumId == postId);
    if (postIndex != -1) {
      final bool alreadyCoined =
          learningPosts[postIndex].coins!.contains(userId);
      if (alreadyCoined) {
        profileController.updateCoinCount(1);
        learningPosts[postIndex].coins!.remove(userId);
      } else {
        profileController.updateCoinCount(-1);
        learningPosts[postIndex].coins!.add(userId);
      }

      socket.emit('coin', <String, String>{
        'postId': postId,
        'userId': userId,
        'type': type,
        'receiverUid': receiverUid,
      });
    }
    update();
  }

  Future<void> deleteForum(String forumId) async {
    learningPosts.removeWhere((ForumModel e) => e.forumId == forumId);
    update();
    await ApiService.delete(path: 'forum/delete/$forumId');
  }
}
