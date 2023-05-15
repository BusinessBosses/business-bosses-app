import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/models/comment_model.dart';
import 'package:business_bosses_v2/common/widgets/text_widget.dart';
import 'package:business_bosses_v2/features/posts/models/post_model.dart';
import 'package:business_bosses_v2/features/posts/repository/post_repository.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:business_bosses_v2/utils/constants/constants.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class PostsController extends GetxController {
  late IO.Socket socket;
  RxList<PostModel> posts = RxList<PostModel>(<PostModel>[]);
  RxInt paginationPage = RxInt(0);
  final int postsSize = 20;
  RxBool error = RxBool(false);
  RxBool loading = RxBool(false);

  /// PROCESS RAW API DATA, MODELIZE AND SAVE TO STATE
  void processPostsToState(dynamic post) {
    final List psts = post;
    for (int i = 0; i < psts.length; i++) {
      posts.add(PostModel.fromMap({
        ...psts[i],
        'likes': psts[i]['likes']
            .map((dynamic like) => like['userId'].toString())
            .toList(),
        'coins': psts[i]['likes']
            .map((dynamic coin) => coin['userId'].toString())
            .toList()
      }));
    }
    update();
  }

  /// LIKE AND UNLIKE FUNCTION
  void postLike(String userId, String postId) {
    final int postIndex =
        posts.indexWhere((PostModel element) => element.postId == postId);
    if (postIndex != -1) {
      final bool checkLiked = posts[postIndex].likes!.contains(userId);
      if (checkLiked) {
        posts[postIndex]
            .likes!
            .removeWhere((String element) => element == userId);
      } else {
        posts[postIndex].likes!.add(userId);
      }
    }
    update();
    socket.emit('like', {
      'postId': postId,
      'userId': userId,
    });
  }

  /// COIN AND UNCOIN FUNCTION
  void postCoin(
      String userId, String postId, ProfileController profileController) {
    final int postIndex =
        posts.indexWhere((PostModel element) => element.postId == postId);
    if (postIndex != -1) {
      final bool checkIfCoined = posts[postIndex].coins!.contains(userId);
      if (checkIfCoined) {
        profileController.updateCoinCount(1);
        posts[postIndex]
            .coins!
            .removeWhere((String element) => element == userId);
      } else {
        profileController.updateCoinCount(-1);
        posts[postIndex].coins!.add(userId);
      }
      socket.emit('coin', {
        'postId': postId,
        'userId': userId,
      });
    }
    update();
  }

  /// ADD NEW POST TO STATE
  void addNewPost(Map<String, dynamic> newPost) {
    PostModel modelizedNewPost = PostModel.fromMap({
      ...newPost,
      'coins': <String>[],
      'likes': <String>[],
      'comments': <CommentModel>[],
      'user': {'username': '', 'email': '', 'uid': '', 'name': ''}
    });

    posts.insert(0, modelizedNewPost);

    update();
  }

  /// LOAD POSTS FROM REMOTE SOURCE
  Future<void> loadPosts() async {
    loading(true);
    error(false);
    final ApiResponseModel response =
        await PostRepository.fetchPosts(paginationPage.value, postsSize);
    if (response.success) {
      paginationPage(paginationPage.value + 1);
      processPostsToState(response.data['rows']);
    } else {
      error(true);
      if (response.message == 'send a valid token') {
        showDialog(
          barrierDismissible: false,
          context: Get.context!,
          builder: (BuildContext context) => AlertDialog(
            title: const TextWidget(
              text: 'Access token expired',
              fontWeight: FontWeight.w700,
              size: 18,
            ),
            content: const TextWidget(
              text:
                  'Your access token has expired. therefore, you will be required to login again to generate a new one. ',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  ApiService().logout();
                  Navigator.of(context).pop(context);
                },
                child: const TextWidget(
                  text: 'Create new Access Token',
                  color: primaryColorLT,
                ),
              )
            ],
          ),
        );
      }
    }

    loading(false);
    update();
  }

  initSocket() {
    socket = IO.io(Constants.socketUrl, <String, dynamic>{
      'autoConnect': false,
      'transports': ['websocket'],
    });
    socket.connect();
    socket.onConnect((_) {
      print('Connection established');
    });

    socket.onDisconnect((_) => print('Connection Disconnection'));
    socket.onConnectError((err) => print(err));
    socket.onError((err) => print(err));
  }

  @override
  void onInit() {
    // TODO: implement onInit
    initSocket();
    super.onInit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    socket.disconnect();
    socket.dispose();
    super.dispose();
  }
}
