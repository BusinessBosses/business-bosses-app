// ignore_for_file: library_prefixes, public_member_api_docs, always_specify_types, always_declare_return_types, avoid_print

import 'dart:convert';

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
import 'package:business_bosses_v2/features/posts/controllers/create_post_controller.dart';
import 'package:business_bosses_v2/features/posts/models/post_model.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:business_bosses_v2/utils/constants/constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../navigation/routes.dart';

class HomeController extends GetxController {
  late IO.Socket socket;
  // final PostsController _postsController = Get.find();
  late final ProfileController profileController;
  late final ChatController _chatController;
  // ignore: unused_field
  late final CreatePostController _createPostController;
  // final MarketController _marketController = Get.put(MarketController());
  // final CommunitiesController _communitiesController =
  //     Get.put(CommunitiesController());

  RxBool error = RxBool(false);
  RxBool noConnection = RxBool(false);
  List<Industry> industries = [];
  List<UserModel> bossupMembers = [];

  List<ForumModel> bossupForums = [];

  RxInt paginationPage = RxInt(1);
  RxBool loading = RxBool(false);
  RxBool loadingMore = RxBool(false);
  List<Map<String, dynamic>>? bossUp = [];
  RxBool refreshing = RxBool(false);
  List<Map<String, dynamic>> mixedPosts = [
    {'isForum': false, 'data': {}, 'shouldCount': false, 'isSponsored': false}
  ];
  List<Map<String, dynamic>> sponsoredPosts = [
    {'isForum': false, 'data': {}, 'shouldCount': false, 'isSponsored': true}
  ];
  List<String> blocked = [];
  String bossUpTitle = 'Boss Up By';
  String bossUpLink = '';
  RxList<MarketModel> markets = RxList<MarketModel>(<MarketModel>[]);
  RxList<UserModel> marketMembers = RxList<UserModel>(<UserModel>[]);
  Set<dynamic> itemsWithIncrementedViews = {};

  void addIndustries(List<Industry> data) {
    industries = data;
  }

  void addBossupForums(List<ForumModel> data) {
    bossupForums = data;
  }

  void addMarkets(RxList<MarketModel> data) {
    markets = data;
  }

  void addBossupMembers(List<UserModel> data) {
    bossupMembers = data;
  }

  void addMarketMembers(RxList<UserModel> data) {
    marketMembers = data;
  }

  void pollVote(PostModel post, String selectedOption) {
    ApiService.post(path: 'pollvote', body: {
      'postId': post.postId,
      'selectedOption': selectedOption,
    });
  }

  /// PROCESS RAW API DATA, MODELIZE AND SAVE TO STATE
  RxList<PostModel> processPostsToState(dynamic post) {
    RxList<PostModel> posts = RxList<PostModel>(<PostModel>[]);

    // print(post.length);
    final List psts = post;
    for (int i = 0; i < psts.length; i++) {
      posts.add(PostModel.fromMap({
        ...psts[i],
        'likes': psts[i]['likes']
            .map((dynamic like) => like['userId'].toString())
            .toList(),
        'reposts': psts[i]['reposts']
            .map((dynamic repost) => repost['userId'].toString())
            .toList(),
        'coins': psts[i]['coins']
            .map((dynamic coin) => coin['userId'].toString())
            .toList()
      }));
    }
    return posts;
  }

  RxList<PostModel> processPromotedPostsToState(dynamic post) {
    RxList<PostModel> promotedPosts = RxList<PostModel>(<PostModel>[]);

    // print(post.length);
    final List psts = post;
    for (int i = 0; i < psts.length; i++) {
      promotedPosts.add(PostModel.fromMap({
        ...psts[i],
        'likes': psts[i]['likes']
            .map((dynamic like) => like['userId'].toString())
            .toList(),
        'reposts': psts[i]['reposts']
            .map((dynamic like) => like['userId'].toString())
            .toList(),
        'coins': psts[i]['coins']
            .map((dynamic coin) => coin['userId'].toString())
            .toList()
      }));
    }
    return promotedPosts;
  }

  /// PROCESS RAW API Forums, MODELIZE AND SAVE TO STATE
  RxList<ForumModel> processForumsToState(dynamic forum) {
    RxList<ForumModel> forums = RxList<ForumModel>(<ForumModel>[]);

    final List frms = forum;
    for (int i = 0; i < frms.length; i++) {
      forums.add(ForumModel.fromMap({
        ...frms[i],
        'likes': frms[i]['likes']
            .map((dynamic like) => like['userId'].toString())
            .toList(),
        'coins': frms[i]['coins']
            .map((dynamic coin) => coin['userId'].toString())
            .toList(),
      }));
    }
    return forums;
  }

  // void joinPostsAndForums(RxList<PostModel> posts, RxList<ForumModel> forums) {
  //   List<Map<String, dynamic>> frms = [];
  //   List<Map<String, dynamic>> psts = [];
  //   for (int i = 0; i < forums.length; i++) {
  //     frms.add({'isForum': true, 'data': forums[i], 'isSponsored': false});
  //   }
  //   for (int i = 0; i < posts.length; i++) {
  //     psts.add({'isForum': false, 'data': posts[i], 'isSponsored': false});
  //   }

  //   final List<Map<String, dynamic>> joinedPosts = [...frms, ...psts]..sort(
  //       (Map<String, dynamic> a, Map<String, dynamic> b) =>
  //           b['data'].timestamp - a['data'].timestamp);

  //   mixedPosts.addAll(joinedPosts);
  // }

  // void processPostsAndForumsData(dynamic data) {
  //   final RxList<PostModel> posts = processPostsToState(data['posts']['rows']);
  //   final RxList<ForumModel> forums =
  //       processForumsToState(data['forums']['rows']);
  //   joinPostsAndForums(posts, forums);
  //   update();
  // }

  // void joinPostsAndForums(RxList<PostModel> posts,
  //     RxList<PostModel> sponsoredPosts, RxList<ForumModel> forums) {
  //   List<Map<String, dynamic>> frms = [];
  //   List<Map<String, dynamic>> psts = [];
  //   List<Map<String, dynamic>> promotedPst = [];
  //   for (int i = 0; i < forums.length; i++) {
  //     frms.add({'isForum': true, 'data': forums[i], 'isPromotedPost': false});
  //   }

  //   for (int i = 0; i < posts.length; i++) {
  //     psts.add({'isForum': false, 'data': posts[i], 'isPromotedPost': false});
  //   }

  //   for (int i = 0; i < sponsoredPosts.length; i++) {
  //     promotedPst.add({
  //       'isForum': false,
  //       'data': sponsoredPosts[i],
  //       'isPromotedPost': true
  //     });
  //   }

  //   final List<Map<String, dynamic>> joinedPosts = [...frms, ...psts]..sort(
  //       (Map<String, dynamic> a, Map<String, dynamic> b) =>
  //           b['data'].timestamp - a['data'].timestamp);

  //   final List<Map<String, dynamic>> joinedPromotedPosts = [...promotedPst]
  //     ..sort((Map<String, dynamic> a, Map<String, dynamic> b) =>
  //         b['data'].timestamp - a['data'].timestamp);

  //   mixedPosts.addAll(joinedPosts);
  // }

  void joinPostsAndForums(RxList<PostModel> posts,
      RxList<PostModel> promotedPosts, RxList<ForumModel> forums) {
    List<Map<String, dynamic>> frms = [];
    List<Map<String, dynamic>> psts = [];
    List<Map<String, dynamic>> sponsoredPst = [];

    // Convert forum and regular posts into map entries
    for (int i = 0; i < forums.length; i++) {
      frms.add({'isForum': true, 'data': forums[i], 'isSponsored': false});
    }

    // for (int i = 0; i < promotedPosts.length; i++) {
    //   psts.add(
    //       {'isForum': false, 'data': promotedPosts[i], 'isSponsored': true});
    // }

    for (int i = 0; i < posts.length; i++) {
      psts.add({'isForum': false, 'data': posts[i], 'isSponsored': false});
    }

    // for (int i = 0; i < promotedPosts.length; i++) {
    //   psts.add(
    //       {'isForum': false, 'data': promotedPosts[i], 'isSponsored': true});
    // }

    for (int i = 0; i < promotedPosts.length; i++) {
      sponsoredPst.add(
          {'isForum': false, 'data': promotedPosts[i], 'isSponsored': true});
    }

    final List<Map<String, dynamic>> joinedPosts = [...frms, ...psts]..sort(
        (Map<String, dynamic> a, Map<String, dynamic> b) =>
            b['data'].timestamp - a['data'].timestamp);

    final List<Map<String, dynamic>> joinedSponsoredPosts = sponsoredPst
      ..sort((Map<String, dynamic> a, Map<String, dynamic> b) =>
          b['data'].timestamp - a['data'].timestamp);

    mixedPosts.addAll(joinedPosts);
    sponsoredPosts.addAll(joinedSponsoredPosts);
  }

  void processPostsAndForumsData(dynamic data) {
    final RxList<PostModel> posts = processPostsToState(data['posts']['rows']);
    final RxList<PostModel> promotedPosts =
        processPromotedPostsToState(data['promotedPosts']['rows']);
    final RxList<ForumModel> forums =
        processForumsToState(data['forums']['rows']);
    joinPostsAndForums(posts, promotedPosts, forums);
    update();
  }

  /// LIKE AND UNLIKE FUNCTION
  void postLike(String userId, String postId, String type, String receiverUid) {
    if (type == 'post') {
      //Non-sponsored posts
      final int postIndex = mixedPosts.indexWhere((Map<String, dynamic> post) =>
          post['shouldCount'] == null &&
          !post['isForum'] &&
          !post['isSponsored'] &&
          post['data'].postId == postId);
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

      //Sponsored posts
      final int spIndex = sponsoredPosts.indexWhere(
          (Map<String, dynamic> post) =>
              post['shouldCount'] == null &&
              !post['isForum'] &&
              post['isSponsored'] &&
              post['data'].postId == postId);
      if (spIndex != -1) {
        final bool checkLiked =
            sponsoredPosts[spIndex]['data'].likes!.contains(userId);
        if (checkLiked) {
          sponsoredPosts[spIndex]['data']
              .likes!
              .removeWhere((element) => element == userId);
        } else {
          sponsoredPosts[spIndex]['data'].likes!.add(userId);
        }
      }
    } else {
      final int postIndex = mixedPosts.indexWhere((Map<String, dynamic> post) =>
          post['shouldCount'] == null &&
          post['isForum'] &&
          post['data'].forumId == postId);
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
    int spIndex;
    if (type == 'post') {
      //non-sponsored posts
      postIndex = mixedPosts.indexWhere((Map<String, dynamic> post) =>
          post['shouldCount'] == null &&
          !post['isForum'] &&
          !post['isSponsored'] &&
          post['data'].postId == postId);

      //sponsored posts
      spIndex = sponsoredPosts.indexWhere((Map<String, dynamic> post) =>
          post['shouldCount'] == null &&
          !post['isForum'] &&
          post['isSponsored'] &&
          post['data'].postId == postId);
    } else {
      //non-sponsored posts
      postIndex = mixedPosts.indexWhere((Map<String, dynamic> post) =>
          post['shouldCount'] == null &&
          post['isForum'] &&
          !post['isSponsored'] &&
          post['data'].forumId == postId);

      //sponsored posts
      spIndex = sponsoredPosts.indexWhere((Map<String, dynamic> post) =>
          post['shouldCount'] == null &&
          post['isForum'] &&
          post['isSponsored'] &&
          post['data'].forumId == postId);
    }
    if (postIndex != -1) {
      mixedPosts[postIndex]['data'].comments!.add(comment);
    } else if (spIndex != -1) {
      sponsoredPosts[spIndex]['data'].comments!.add(comment);
    }
    update();
  }

  /// COIN AND UNCOIN FUNCTION
  void postCoin(String userId, String postId,
      ProfileController profileController, String type, String receiverUid) {
    if (type == 'post') {
      //Non-sponsored Posts
      final int postIndex = mixedPosts.indexWhere((Map<String, dynamic> item) =>
          item['shouldCount'] == null &&
          !item['isForum'] &&
          !item['isSponsored'] &&
          item['data'].postId == postId);
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

      //sponsored posts
      final int spIndex = sponsoredPosts.indexWhere(
          (Map<String, dynamic> item) =>
              item['shouldCount'] == null &&
              !item['isForum'] &&
              item['isSponsored'] &&
              item['data'].postId == postId);
      if (spIndex != -1) {
        final bool checkIfCoined =
            sponsoredPosts[spIndex]['data'].coins!.contains(userId);
        if (checkIfCoined) {
          profileController.updateCoinCount(1);
          sponsoredPosts[spIndex]['data']
              .coins!
              .removeWhere((String element) => element == userId);
        } else {
          profileController.updateCoinCount(-1);
          sponsoredPosts[spIndex]['data'].coins!.add(userId);
        }
      }
    } else {
      final int forumIndex = mixedPosts.indexWhere(
          (Map<String, dynamic> item) =>
              item['shouldCount'] == null &&
              item['isForum'] &&
              item['data'].forumId == postId);
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
      socket.emit('coin', {
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

  // /// REPOST AND UNDO REPOST FUNCTION
  // Future<void> postRepost(String userId, String postId, String type,
  //     int timestamp, String receiverUid) async {
  //   if (type == 'post') {
  //     //Non-sponsored posts
  //     final int postIndex = mixedPosts.indexWhere((Map<String, dynamic> post) =>
  //         post['shouldCount'] == null &&
  //         !post['isForum'] &&
  //         !post['isSponsored'] &&
  //         post['data'].postId == postId);
  //     if (postIndex != -1) {
  //       final bool checkReposted =
  //           mixedPosts[postIndex]['data'].reposts?.contains(userId);

  //       if (checkReposted) {
  //         mixedPosts[postIndex]['data']
  //             .reposts!
  //             .removeWhere((element) => element == userId);
  //         // _createPostController.onDeletePost(postId);
  //       } else {
  //         mixedPosts[postIndex]['data'].reposts?.add(userId);
  //         // mixedPosts[postIndex]['data']['timestamp'] =
  //         //     DateTime.now().millisecondsSinceEpoch.toString();
  //         // mixedPosts[postIndex]['data']['oldtimestamp'] = timestamp;
  //       }
  //     }
  //         // profileController.addNewPost(response.data);

  //     //Sponsored posts
  //     final int spIndex = sponsoredPosts.indexWhere(
  //         (Map<String, dynamic> post) =>
  //             post['shouldCount'] == null &&
  //             !post['isForum'] &&
  //             post['isSponsored'] &&
  //             post['data'].postId == postId);
  //     if (spIndex != -1) {
  //       final bool checkReposts =
  //           sponsoredPosts[spIndex]['data'].reposts!.contains(userId);
  //       if (checkReposts) {
  //         sponsoredPosts[spIndex]['data']
  //             .reposts!
  //             .removeWhere((element) => element == userId);
  //       } else {
  //         sponsoredPosts[spIndex]['data'].reposts!.add(userId);
  //         // mixedPosts[postIndex]['data']['timestamp'] =
  //         //     DateTime.now().millisecondsSinceEpoch.toString();
  //         // mixedPosts[postIndex]['data']['oldtimestamp'] = timestamp;
  //       }
  //     }
  //   }
  //   update();

  //   // Prepare the data for the repost request
  //   Map<String, dynamic> repostData = {
  //     'postId': postId,
  //     'oldtimestamp': timestamp,
  //   };

  //   try {
  //     ApiResponseModel response =
  //         await ApiService.post(path: 'post/create-repost', body: repostData);

  //     // Handle the response if needed
  //     if (response.success) {
  //       print('Repost successful');
  //     } else {
  //       print('Repost failed with status code: $response');
  //     }
  //   } catch (e) {
  //     print('Error during repost API request: $e');
  //   }
  // }

  /// REPOST AND UNDO REPOST FUNCTION
  Future<void> postRepost(String userId, String postId, String type,
      int timestamp, String receiverUid, int ? oldtimestamp) async {
    if (type == 'post') {
      //Non-sponsored posts
      final int postIndex = mixedPosts.indexWhere((Map<String, dynamic> post) =>
          post['shouldCount'] == null &&
          !post['isForum'] &&
          !post['isSponsored'] &&
          post['data'].postId == postId);
      if (postIndex != -1) {
        final bool checkReposted =
            mixedPosts[postIndex]['data'].reposts?.contains(userId);

        if (checkReposted) {
          mixedPosts[postIndex]['data']
              .reposts!
              .removeWhere((element) => element == userId);
          showSnackbar(
              title: 'Success!',
              message: 'Post successfully unreposted',
              error: false);
        } else {
          mixedPosts[postIndex]['data'].reposts?.add(userId);
          showSnackbar(
              title: 'Success!',
              message: 'Post successfully reposted',
              error: false);
        }
      }

      //Sponsored posts
      final int spIndex = sponsoredPosts.indexWhere(
          (Map<String, dynamic> post) =>
              post['shouldCount'] == null &&
              !post['isForum'] &&
              post['isSponsored'] &&
              post['data'].postId == postId);
      if (spIndex != -1) {
        final bool checkReposts =
            sponsoredPosts[spIndex]['data'].reposts!.contains(userId);
        if (checkReposts) {
          sponsoredPosts[spIndex]['data']
              .reposts!
              .removeWhere((element) => element == userId);
          showSnackbar(
              title: 'Success!',
              message: 'Post successfully unreposted',
              error: false);
        } else {
          sponsoredPosts[spIndex]['data'].reposts!.add(userId);
          showSnackbar(
              title: 'Success!',
              message: 'Post successfully reposted',
              error: false);
        }
      }
    }
    update();

    // Prepare the data for the repost request
    Map<String, dynamic> repostData = {
      'postId': postId,
      'oldtimestamp': timestamp,
    };

    Map<String, dynamic> timestampData = {
      'oldtimestamp' : timestamp,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };

      Map<String, dynamic> timestampDataoldpost = {
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };

    try {
      ApiResponseModel response =
          await ApiService.post(path: 'post/create-repost', body: repostData);
      //if repost is deleted this is the response "repost":{"success":true,"message":"reposted post deleted"}
      // Handle the response if needed

      if (response.success) {
        print('Repost successful');
        var reposted = response.data['repost']['reposted'];
        if (reposted) {
          profileController.addRePost(response.data);
          final ApiResponseModel timeresponse = await ApiService.put(
              path: 'post/update-post/${postId}', body: oldtimestamp == 0 ? timestampData : timestampDataoldpost);
              if(timeresponse.success){
                print('true');
              }else{
                print('false');
              }
        } else {
          profileController.removePost(response.data["postId"]);
        }
      } else {
        print('Repost failed with status code: $response');
      }
    } catch (e) {
      print('Error during repost API request: $e');
    }
  }

  /// ADD NEW POST TO STATE
  void addNewPost(
      Map<String, dynamic> newPost, ProfileController profileController) async {
    PostModel modelizedNewPost = PostModel.fromMap({
      ...newPost,
      'coins': <String>[],
      'likes': <String>[],
      'reposts': <String>[],
      'comments': <CommentModel>[],
      'user': {
        'username': profileController.myProfile.username,
        'email': profileController.myProfile.email,
        'uid': profileController.myProfile.uid,
        'name': profileController.myProfile.name,
        'bio': profileController.myProfile.bio
      }
    });
    mixedPosts.insert(
        1, {'isForum': false, 'data': modelizedNewPost, 'isSponsored': false});

    // posts.insert(0, modelizedNewPost);
    update();
    socket.emit('newPostEvent', {
      'newPost': newPost,
      'user': {
        'username': profileController.myProfile.username,
        'email': profileController.myProfile.email,
        'uid': profileController.myProfile.uid,
        'name': profileController.myProfile.name,
        'bio': profileController.myProfile.bio
      }
    });
  }

  void removePostsByUserId(String? userId) {
    ApiService.post(
      path: 'blockedpost',
      body: <String, dynamic>{'postId': userId},
    );
    mixedPosts.removeWhere((Map<String, dynamic> post) =>
        post['shouldCount'] == null && post['data'].user.uid == userId);
    update();
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
            text: 'Access Expired',
            fontWeight: FontWeight.w700,
            size: 18,
          ),
          content: const TextWidget(
            text:
                'Your Session Has Expired. Login Again To Continue Using Business Bosses!',
          ),
          actions: [
            TextButton(
              onPressed: () {
                ApiService().logout();
                Navigator.of(context).pop(context);
              },
              child: const TextWidget(
                text: 'Login',
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
    if (profileController.myProfile.isUpdated == true) {
      ApiService.put(
        path: 'users/${profileController.myProfile.uid}',
        body: <String, dynamic>{
          'coinscount': profileController.myProfile.coinscount! + 100,
          'bossOfTheWeekUpTimeStamp': currentTimestamp,
          'isUpdated': false,
        },
      );
      profileController.myProfile = UserModel.fromMap(
          {...profileController.myProfile.toMap(), 'isUpdated': false});
      sandBox.write('lastExecutionTimestamp', currentTimestamp);
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

  Future<void> fetchPosts({bool fromBackground = false}) async {
    if (fromBackground) {
      mixedPosts.removeRange(1, mixedPosts.length);
      loading(true);
    } else {
      loadingMore(true);
    }
    update();
    final ApiResponseModel response = await HomeRepository.fetchPosts(
        fromBackground ? 0 : paginationPage.value,
        fromBackground
            ? DateTime.now().millisecondsSinceEpoch
            : mixedPosts[mixedPosts.length - 1]['data'].timestamp);
    if (response.success) {
      paginationPage(paginationPage.value + 1);
      processPostsAndForumsData(response.data);
    } else {
      // showSnackbar(
      //     title: 'OOPS!',
      //     message: 'An error occurred, please try again!',
      //     error: true);

      // error(true);
    }

    if (fromBackground) {
      loading(false);
    } else {
      loadingMore(false);
    }
    update();
  }

  Future<void> sinkPosts(Map<String, dynamic> data) async {
    if (profileController.myProfile.uid != data['user']['uid']) {
      PostModel modelizedNewPost = PostModel.fromMap({
        ...data['newPost'],
        'coins': <String>[],
        'likes': <String>[],
        'reposts': <String>[],
        'comments': <CommentModel>[],
        'user': data['user']
      });
      mixedPosts.insert(1,
          {'isForum': false, 'data': modelizedNewPost, 'isSponsored': false});

      update();
    }
  }

  void removePost(String postId) {
    mixedPosts.removeWhere((Map<String, dynamic> element) =>
        element['shouldCount'] == null &&
        !element['isForum'] &&
        element['data'].postId == postId);
    update();
  }

  void removeForum(String forumId) {
    mixedPosts.removeWhere((Map<String, dynamic> element) =>
        element['shouldCount'] == null &&
        element['isForum'] &&
        element['data'].forumId == forumId);

    bossupForums
        .removeWhere((ForumModel element) => element.forumId == forumId);
    update();
  }

  void updatePost(PostModel post) {
    final int postIndex = mixedPosts.indexWhere(
        (Map<String, dynamic> element) =>
            element['shouldCount'] == null &&
            !element['isForum'] &&
            element['data'].postId == post.postId);
    if (postIndex != -1) {
      mixedPosts[postIndex]['data'] = post;
      update();
    }
  }

  void updateViews(PostModel post) {
    HomeRepository.updateViews(post.postId, post.views! + 1);
    final int postIndex = mixedPosts.indexWhere(
        (Map<String, dynamic> element) =>
            element['shouldCount'] == null &&
            !element['isForum'] &&
            element['data'].postId == post.postId);
    if (postIndex != -1) {
      // Increment the view count of the post by 1
      mixedPosts[postIndex]['data'].setViews(post.views! + 1);
      update();
    }
  }

  void updateForumViews(ForumModel post) {
    final int postIndex = mixedPosts.indexWhere(
        (Map<String, dynamic> element) =>
            element['shouldCount'] == null &&
            element['isForum'] &&
            element['data'].forumId == post.forumId);
    if (postIndex != -1) {
      // Increment the view count of the post by 1
      mixedPosts[postIndex]['data'].setViews(post.views! + 1);
      update();
      HomeRepository.updateForumViews(post.forumId, post.views!);
    }
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
          response.data['interests'],
          response.data['userRanking']);
      _chatController.processDataToState(
          response.data['chats'], profileController.myProfile.uid);
      socket.emit('handshake', profileController.myProfile.uid);
      addCoinDaily();
      if (partner.data['count'] > 0) {
        bossUp?.addAll(partner.data['rows'].cast<Map<String, dynamic>>());
        // Find the item with id = 5
        final Map<String, dynamic> getTitle =
            bossUp!.firstWhere((Map<String, dynamic> item) => item['id'] == 5);

        bossUpTitle = getTitle['companyName'];
        bossUpLink = getTitle['companyUrl'];
        bossUp?.removeWhere((Map<String, dynamic> item) => item['id'] == 5);
      }
      FirebaseMessaging.instance.getToken().then((String? value) {
        Map<String, dynamic> data = <String, dynamic>{
          'deviceToken': value,
        };
        ApiService.post(path: 'users/add-device-token', body: data);
      });
      if (profileController.myProfile.bio == null) {
        Get.offAndToNamed(Routes.updateProfile,
            arguments: profileController.myProfile);
      }
    } else {
      error(true);
      update();
      socket.disconnect();
      if (response.message == 'send a valid token') {
        showAccessTokenDialog();
      } else {
        // showSnackbar(
        //     title: 'OOPS!',
        //     message: 'An error occurred, please try again!',
        //     error: true);
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
    final ApiResponseModel response = await HomeRepository.fetchRefreshData();
    final ApiResponseModel partner = await HomeRepository.fetchPartner();
    if (response.success) {
      processPostsAndForumsData(response.data['posts']);
      // profileController.processDataToState(
      //     response.data['user'], response.data['interests']);
      bossUp?.clear();
      if (partner.data['count'] > 0) {
        bossUp?.addAll(partner.data['rows'].cast<Map<String, dynamic>>());
        // Find the item with id = 5
        final Map<String, dynamic> getTitle =
            bossUp!.firstWhere((Map<String, dynamic> item) => item['id'] == 5);

        bossUpTitle = getTitle['companyName'];
        bossUpLink = getTitle['companyUrl'];
      }
    } else {
      error(true);
      // showSnackbar(
      //     title: 'OOPS!',
      //     message: 'An error occurred, please try again!',
      //     error: true);
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
      // print(data);
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
    profileController = Get.put(ProfileController());
    _chatController = Get.put(ChatController());
    // _createPostController = Get.put(CreatePostController());
    initSocket();
    loadData();
    super.onInit();
  }

  @override
  void dispose() {
    socket.disconnect();
    socket.dispose();
    super.dispose();
  }
}
