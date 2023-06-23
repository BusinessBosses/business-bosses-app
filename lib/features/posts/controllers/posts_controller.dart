import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/models/comment_model.dart';
import 'package:business_bosses_v2/common/widgets/text_widget.dart';
import 'package:business_bosses_v2/features/forum/models/forum_model.dart';
import 'package:business_bosses_v2/features/posts/models/post_model.dart';
import 'package:business_bosses_v2/features/posts/repository/post_repository.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:business_bosses_v2/utils/constants/constants.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class PostsController extends GetxController {
  late IO.Socket socket;
  RxList<PostModel> posts = RxList<PostModel>(<PostModel>[]);
  RxList<ForumModel> forums = RxList<ForumModel>(<ForumModel>[]);
  List<Map<String, dynamic>> mixedPosts = [];
  RxInt paginationPage = RxInt(0);
  final int postsSize = 20;
  RxBool error = RxBool(false);
  RxBool loading = RxBool(false);
  // final ProfileController _profileController = Get.find();

  /// PROCESS RAW API DATA, MODELIZE AND SAVE TO STATE
  void processPostsToState(dynamic post) {
    final List psts = post;
    for (int i = 0; i < psts.length; i++) {
      posts.add(PostModel.fromMap({
        ...psts[i],
        'likes': psts[i]['likes']
            .map((dynamic like) => like['userId'].toString())
            .toList(),
        'coins': psts[i]['coins']
            .map((dynamic coin) => coin['userId'].toString())
            .toList()
      }));
    }
    // update();
  }

  /// PROCESS RAW API Forums, MODELIZE AND SAVE TO STATE
  void processForumsToState(dynamic forum) {
    final List frms = forum;
    for (int i = 0; i < frms.length; i++) {
      forums.add(ForumModel.fromMap({
        ...frms[i],
        'likes': frms[i]['likes']
            .map((dynamic like) => like['userId'].toString())
            .toList(),
        'coins': frms[i]['coins']
            .map((dynamic coin) => coin['userId'].toString())
            .toList()
      }));
    }
    // update();
  }

  void joinPostsAndForums() {
    List<Map<String, dynamic>> frms = [];
    List<Map<String, dynamic>> psts = [];
    for (int i = 0; i < forums.length; i++) {
      frms.add({'isForum': true, 'data': forums[i]});
    }
    for (int i = 0; i < posts.length; i++) {
      psts.add({'isForum': false, 'data': posts[i]});
    }

    mixedPosts = [...frms, ...psts]..sort(
        (Map<String, dynamic> a, Map<String, dynamic> b) =>
            b['data'].timestamp - a['data'].timestamp);

    // mixedPosts = Iterable.generate(math.max(posts.length, forums.length))
    //     .expand((i) sync* {
    //   if (i < posts.length) {
    //     yield {'isForum': false, 'data': posts[i]};
    //   }
    //   if (i < forums.length) yield {'isForum': true, 'data': forums[i]};
    // }).toList();
    // update();
  }

  void processPostsAndForumsData(dynamic data) {
    processPostsToState(data['posts']['rows']);
    processForumsToState(data['forums']['rows']);
    joinPostsAndForums();
    update();
  }

  /// LIKE AND UNLIKE FUNCTION
  void postLike(String userId, String postId, String type, String receiverUid) {
    if (type == 'post') {
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
    } else {
      final int postIndex =
          forums.indexWhere((ForumModel element) => element.forumId == postId);
      if (postIndex != -1) {
        final bool checkLiked = forums[postIndex].likes!.contains(userId);
        if (checkLiked) {
          forums[postIndex]
              .likes!
              .removeWhere((String element) => element == userId);
        } else {
          forums[postIndex].likes!.add(userId);
        }
      }
    }
    update();
    socket.emit('like', {
      'postId': postId,
      'userId': userId,
      'type': type,
      'receiverUid': receiverUid,
    });
  }

  /// COMMENT FUNCTION
  void comment(String postId, CommentModel comment) {
    final int postIndex =
        posts.indexWhere((PostModel element) => element.postId == postId);
    if (postIndex != -1) {
      posts[postIndex].comments!.add(comment);
    }
    update();
  }

  /// COIN AND UNCOIN FUNCTION
  void postCoin(String userId, String postId,
      ProfileController profileController, String type, String receiverUid) {
    if (type == 'post') {
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
          'type': type,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'receiverUid': receiverUid,
        });
      }
      print(postId);
    } else {
      final int postIndex =
          forums.indexWhere((ForumModel element) => element.forumId == postId);
      if (postIndex != -1) {
        final bool checkIfCoined = forums[postIndex].coins!.contains(userId);
        if (checkIfCoined) {
          profileController.updateCoinCount(1);
          forums[postIndex]
              .coins!
              .removeWhere((String element) => element == userId);
        } else {
          profileController.updateCoinCount(-1);
          forums[postIndex].coins!.add(userId);
        }
        socket.emit('coin', {
          'postId': postId,
          'userId': userId,
          'type': type,
          'timestamp': DateTime.now().millisecondsSinceEpoch
        });
      }
    }
    update();
  }

  /// ADD NEW POST TO STATE
  void addNewPost(
      Map<String, dynamic> newPost, ProfileController profileController) async {
    PostModel modelizedNewPost = PostModel.fromMap({
      ...newPost,
      'coins': <String>[],
      'likes': <String>[],
      'comments': <CommentModel>[],
      'user': {
        'username': profileController.myProfile.username,
        'email': profileController.myProfile.email,
        'uid': profileController.myProfile.uid,
        'name': profileController.myProfile.name,
      }
    });
    mixedPosts.insert(0, {'isForum': false, 'data': modelizedNewPost});
    // posts.insert(0, modelizedNewPost);

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
