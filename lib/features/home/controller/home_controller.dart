import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/models/comment_model.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/common/widgets/text_widget.dart';
import 'package:business_bosses_v2/features/chat/controllers/chat_controller.dart';
import 'package:business_bosses_v2/features/forum/models/forum_model.dart';
import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:business_bosses_v2/features/home/repository/home_repository.dart';
import 'package:business_bosses_v2/features/marketplace/models/market_model.dart';
import 'package:business_bosses_v2/features/posts/models/post_model.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:business_bosses_v2/utils/constants/constants.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class HomeController extends GetxController {
  late IO.Socket socket;
  // final PostsController _postsController = Get.find();
  late final ProfileController profileController;
  late final ChatController _chatController;
  // final MarketController _marketController = Get.put(MarketController());
  // final CommunitiesController _communitiesController =
  //     Get.put(CommunitiesController());

  RxBool error = RxBool(false);
  List<Industry> industries = [];
  List<ForumModel> bossupForums = [];

  RxInt paginationPage = RxInt(1);
  RxBool loading = RxBool(false);
  RxBool loadingMore = RxBool(false);
  List<Map<String, dynamic>>? bossUp = [];
  RxBool refreshing = RxBool(false);
  RxList<PostModel> posts = RxList<PostModel>(<PostModel>[]);
  RxList<ForumModel> forums = RxList<ForumModel>(<ForumModel>[]);
  List<Map<String, dynamic>> mixedPosts = [];
  List<String> blocked = [];
  String bossUpTitle = 'Boss Up By';
  RxList<MarketModel> markets = RxList<MarketModel>(<MarketModel>[]);
  RxList<UserModel> marketMembers = RxList<UserModel>(<UserModel>[]);

  void addIndustries(List<Industry> data) {
    industries = data;
  }

  void addBossupForums(List<ForumModel> data) {
    bossupForums = data;
  }

  void addMarkets(RxList<MarketModel> data) {
    markets = data;
  }

  void addMarketMembers(RxList<UserModel> data) {
    marketMembers = data;
  }

  /// PROCESS RAW API DATA, MODELIZE AND SAVE TO STATE
  void processPostsToState(dynamic post) {
    // print(post.length);
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
    update();
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

    // posts.clear();
    // forums.clear();

    final List<Map<String, dynamic>> joinedPosts = [...frms, ...psts]..sort(
        (Map<String, dynamic> a, Map<String, dynamic> b) =>
            b['data'].timestamp - a['data'].timestamp);

    mixedPosts.addAll(joinedPosts);
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
      final int postIndex = mixedPosts.indexWhere(
          (Map<String, dynamic> post) => post['data'].postId == postId);
      if (postIndex != -1) {
        final bool checkLiked =
            mixedPosts[postIndex]['data'].likes!.contains(userId);
        if (checkLiked) {
          mixedPosts[postIndex]['data']
              .likes!
              .removeWhere((element) => element == userId);
        } else {
          mixedPosts[postIndex]['data'].likes!.add(userId);
        }
      }
    } else {
      final int postIndex = mixedPosts.indexWhere(
          (dynamic post) => post['isForum'] && post['data'].forumId == postId);
      if (postIndex != -1) {
        final bool checkLiked =
            mixedPosts[postIndex]['data'].likes!.contains(userId);
        if (checkLiked) {
          mixedPosts[postIndex]['data']
              .likes!
              .removeWhere((element) => element == userId);
        } else {
          mixedPosts[postIndex]['data'].likes!.add(userId);
        }
      }
    }
    update();
    if (profileController.myProfile.uid != receiverUid) {
      socket.emit('like', {
        'postId': postId,
        'userId': userId,
        'type': type,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'receiverUid': receiverUid,
      });
    } else {
      socket.emit('like', {
        'postId': postId,
        'userId': userId,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'type': type,
      });
    }
  }

  /// COMMENT FUNCTION
  void comment(String postId, CommentModel comment, String type) {
    int postIndex;
    if (type == 'post') {
      postIndex = mixedPosts.indexWhere(
          (Map<String, dynamic> post) => post['data'].postId == postId);
    } else {
      postIndex = mixedPosts.indexWhere((Map<String, dynamic> post) =>
          post['isForum'] && post['data'].forumId == postId);
    }
    if (postIndex != -1) {
      mixedPosts[postIndex]['data'].comments!.add(comment);
    }
    update();
  }

  // /// COMMENT FUNCTION
  // void comment(String postId, CommentModel comment) {
  //   final int postIndex =
  //       mixedPosts.indexWhere((element) => element["data"].postId == postId);
  //   if (postIndex != -1) {
  //     posts[postIndex].comments!.add(comment);
  //   } else {
  //     final int forumIndex = mixedPosts
  //         .indexWhere((element) => element["isForum"].forumId == postId);
  //     if (forumIndex != -1) {
  //       posts[forumIndex].comments!.add(comment);
  //     }
  //   }
  //   update();
  // }

  /// COIN AND UNCOIN FUNCTION
  void postCoin(String userId, String postId,
      ProfileController profileController, String type, String receiverUid) {
    if (type == 'post') {
      final int postIndex = mixedPosts.indexWhere(
          (Map<String, dynamic> item) => item['data'].postId == postId);
      if (postIndex != -1) {
        final bool checkIfCoined =
            mixedPosts[postIndex]['data'].coins!.contains(userId);
        if (checkIfCoined) {
          profileController.updateCoinCount(1);
          mixedPosts[postIndex]['data']
              .coins!
              .removeWhere((String element) => element == userId);
        } else {
          profileController.updateCoinCount(-1);
          mixedPosts[postIndex]['data'].coins!.add(userId);
        }
      }
    } else {
      final int forumIndex = mixedPosts.indexWhere(
          (Map<String, dynamic> item) =>
              item['isForum'] && item['data'].forumId == postId);
      if (forumIndex != -1) {
        final bool checkIfCoined =
            mixedPosts[forumIndex]['data'].coins!.contains(userId);
        if (checkIfCoined) {
          profileController.updateCoinCount(1);
          mixedPosts[forumIndex]['data']
              .coins!
              .removeWhere((String element) => element == userId);
        } else {
          profileController.updateCoinCount(-1);
          mixedPosts[forumIndex]['data'].coins!.add(userId);
        }
      }
    }
    update();
    if (profileController.myProfile.uid != receiverUid) {
      socket.emit('con', {
        'postId': postId,
        'userId': userId,
        'type': type,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'receiverUid': receiverUid,
      });
    } else {
      socket.emit('coin', {
        'postId': postId,
        'userId': userId,
        'type': type,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
    }
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

  void removePostsByUserId(String? userId) {
    mixedPosts.removeWhere(
        (Map<String, dynamic> post) => post['user']['uid'] == userId);
    update();
  }

  void clearData() {
    // Reset the data variables to their initial state
    posts.clear();
    forums.clear();
  }

  // void loadBlocked() async {
  //   final ApiResponseModel data = await HomeRepository.fetchBlocked();
  //   var rows = data.data['rows'];
  //   for (var row in rows) {
  //     blocked.addAll(List<String>.from(row['postsId']));
  //   }
  // }

  /// SHOW WHEN ACCESS TOKEN EXPIRES
  void showAccessTokenDialog() {
    showDialog(
      barrierDismissible: false,
      context: Get.context!,
      builder: (BuildContext context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
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
      ),
    );
  }

  void showCoinDialog() {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) => AlertDialog(
        title: const TextWidget(
          text: 'Congratulations',
          fontWeight: FontWeight.bold,
          size: 20,
        ),
        content: TextWidget(
          text: 'You have earned 1 coin for logging into Business Bosses today',
          color: Colors.black.withOpacity(.8),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const TextWidget(
              text: 'OK',
            ),
          )
        ],
      ),
    );
  }

  void showCoinDialogFirst() {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) => AlertDialog(
        title: const TextWidget(
          text: 'Congratulations',
          fontWeight: FontWeight.bold,
          size: 20,
        ),
        content: TextWidget(
          text:
              'You have earned 100 coins for upgrading your Business Bosses App',
          color: Colors.black.withOpacity(.8),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const TextWidget(
              text: 'OK',
            ),
          )
        ],
      ),
    );
  }

  /// DailyCoin
  void addCoinDaily() {
    int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
    int dataTime = profileController.myProfile.bossOfTheWeekUpTimeStamp ?? 0;
    int lastExecutionTimestamp = sandBox.read('lastExecutionTimestamp') ?? 0;
    if (profileController.myProfile.bossOfTheWeekTimeStamp == null) {
      ApiService.put(
        path: 'users/${profileController.myProfile.uid}',
        body: <String, dynamic>{
          'coinscount': profileController.myProfile.coinscount! + 100,
          'bossOfTheWeekUpTimeStamp': currentTimestamp,
        },
      );
      profileController.updateCoinCount(100);
      showCoinDialogFirst();
    } else {
      if ((currentTimestamp - lastExecutionTimestamp >= 24 * 60 * 60 * 1000) &&
          (currentTimestamp - dataTime >= 24 * 60 * 60 * 1000)) {
        // The action hasn't been executed today, save the current timestamp
        sandBox.write('lastExecutionTimestamp', currentTimestamp);
        ApiService.put(
          path: 'users/${profileController.myProfile.uid}',
          body: <String, dynamic>{
            'coinscount': profileController.myProfile.coinscount! + 1,
            'bossOfTheWeekUpTimeStamp': currentTimestamp,
          },
        );
        profileController.updateCoinCount(1);
        showCoinDialog();
      }
    }
  }

  Future<void> fetchPosts() async {
    loadingMore(true);
    update();
    final ApiResponseModel response =
        await HomeRepository.fetchPosts(paginationPage.value);
    if (response.success) {
      processPostsAndForumsData(response.data);
    } else {
      showSnackbar(title: 'OOPS!', message: response.message, error: true);

      error(true);
    }

    loadingMore(false);
    update();
  }

  void removePost(String postId) {
    mixedPosts.removeWhere((Map<String, dynamic> element) =>
        !element['isForum'] && element['data'].postId == postId);
    update();
  }

  void updatePost(PostModel? post) {
    int postIndex;
    postIndex = mixedPosts
        .indexWhere((element) => element['data'].postId == post?.postId);
    if (postIndex != -1) {
      mixedPosts[postIndex]['data'] = post;
      update();
    } else {
      postIndex = mixedPosts.indexWhere((element) =>
          element['isForum'] && element['data'].forumId == post?.postId);
      if (postIndex != -1) {
        mixedPosts[postIndex]['data'] = post;
      }
    }
    update();
  }

  /// LOAD POSTS FROM REMOTE SOURCE
  Future<void> loadData() async {
    loading(true);
    error(false);
    update();
    final ApiResponseModel response = await HomeRepository.fetchData();
    final ApiResponseModel partner = await HomeRepository.fetchPartner();
    if (response.success) {
      processPostsAndForumsData(response.data['posts']);
      profileController.processDataToState(
          {...response.data['user'], 'connecteds': response.data['connecteds']},
          response.data['interests']);
      _chatController.processDataToState(
          response.data['chats'], profileController.myProfile.uid);
      socket.emit('handshake', profileController.myProfile.uid);
      // _marketController.initMarket();
      // _marketController.initUsers();
      addCoinDaily();
      if (partner.data['count'] > 0) {
        bossUp?.addAll(partner.data['rows'].cast<Map<String, dynamic>>());
        // Find the item with id = 5
        final Map<String, dynamic> getTitle =
            bossUp!.firstWhere((Map<String, dynamic> item) => item['id'] == 5);

        bossUpTitle = getTitle['companyName'];
      }
    } else {
      error(true);
      socket.disconnect();
      if (response.message == 'send a valid token') {
        showAccessTokenDialog();
      } else {
        showSnackbar(title: 'OOPS!', message: response.message, error: true);
      }
    }

    loading(false);
    update();
  }

  Future<void> fetchIndustries() async {
    loading(true);
    error(false);
    update();

    final ApiResponseModel response = await HomeRepository.fetchIndustries();
    if (response.success) {
      industries = Industry.toIndustries(snapshot: response.data['rows']);
    } else {
      error(true);
    }
    loading(false);

    update();
  }

  /// LOAD POSTS FROM REMOTE SOURCE
  Future<void> refreshData() async {
    refreshing(true);
    // error(false);
    update();
    clearData();
    final ApiResponseModel response = await HomeRepository.fetchRefreshData();
    final ApiResponseModel partner = await HomeRepository.fetchPartner();
    if (response.success) {
      processPostsAndForumsData(response.data['posts']);
      // profileController.processDataToState(
      //     response.data['user'], response.data['interests']);
      if (partner.data['count'] > 0) {
        bossUp?.addAll(partner.data['rows'].cast<Map<String, dynamic>>());
        // Find the item with id = 5
        final Map<String, dynamic> getTitle =
            bossUp!.firstWhere((Map<String, dynamic> item) => item['id'] == 5);

        bossUpTitle = getTitle['companyName'];
      }
    } else {
      error(true);
      showSnackbar(title: 'OOPS!', message: response.message, error: true);
    }

    refreshing(false);
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

    socket.on('handshake', (data) {
      print(data);
    });

    socket.on('new-message', (data) {
      // print(data);
      _chatController.newMessage(data);
    });

    socket.on('new-notification', (data) {
      // print(data);
      profileController.updateProfile(
          {...profileController.myProfile.toMap(), 'unReadCount': 1});
    });

    socket.onReconnect((_) {
      socket.emit('handshake', profileController.myProfile.uid);

      print('reconnected');
    });

    socket.onDisconnect((_) => print('Connection Disconnection'));
    socket.onConnectError((err) => print(err));
    socket.onError((err) => print(err));
  }

  @override
  void onInit() {
    // TODO: implement onInit
    profileController = Get.put(ProfileController());
    _chatController = Get.put(ChatController());
    initSocket();
    loadData();
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
