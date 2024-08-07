// ignore_for_file: library_prefixes, public_member_api_docs, always_specify_types, always_declare_return_types, avoid_print

import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/models/comment_model.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/common/widgets/text_widget.dart';
import 'package:business_bosses_v2/features/chat/controllers/chat_controller.dart';
import 'package:business_bosses_v2/features/courses/models/course_model.dart';
import 'package:business_bosses_v2/features/forum/models/forum_model.dart';
import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:business_bosses_v2/features/home/repository/home_repository.dart';
import 'package:business_bosses_v2/features/live_event/models/events_model.dart';
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

  RxInt paginationPage = RxInt(1);
  RxBool loading = RxBool(false);
  RxBool loadingMore = RxBool(false);
  List<Map<String, dynamic>>? bossUp = [];
  RxBool refreshing = RxBool(false);
  List<Map<String, dynamic>> mixedPosts = [
    {'type': 'notype'},
  ];
  List<Map<String, dynamic>> sponsoredPosts = [
    {'isForum': false, 'data': {}, 'shouldCount': false, 'isSponsored': true}
  ];
  List<String> blocked = [];
  RxList<PostModel> promotedPosts = RxList<PostModel>(<PostModel>[]);
  RxList<MarketModel> promotedMarkets = RxList<MarketModel>(<MarketModel>[]);
  RxList<CourseModel> promotedCourses = RxList<CourseModel>(<CourseModel>[]);
  String bossUpTitle = 'Boss Up By';
  String bossUpLink = '';
  RxList<MarketModel> markets = RxList<MarketModel>(<MarketModel>[]);
  RxList<EventModel> events = RxList<EventModel>(<EventModel>[]);
  RxList<EventModel> myEvents = RxList<EventModel>(<EventModel>[]);
  RxList<UserModel> marketMembers = RxList<UserModel>(<UserModel>[]);
  Set<dynamic> itemsWithIncrementedViews = {};
  String notificationDescription = '';
  String notificationStatus = '';
  Map<String, String> votes = {};
  RxList<PostModel> posts = RxList<PostModel>(<PostModel>[]);
  RxList<ForumModel> forums = RxList<ForumModel>(<ForumModel>[]);

  void addIndustries(List<Industry> data) {
    industries = data;
  }

  void addMarkets(RxList<MarketModel> data) {
    markets = data;
  }

  void addEvents(RxList<EventModel> data) {
    events = data;
  }

  void addMyEvents(RxList<EventModel> data) {
    myEvents = data;
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
    votes[post.postId] = selectedOption;
    update();
  }

  String? getSelectedVote(String postId) {
    return votes[postId];
  }

  Future<void> attendEvent(EventModel event) async {
    final ApiResponseModel response = await ApiService.put(
        path: 'event/join-leave-event/${event.id}', body: <String, dynamic>{});
    if (response.success) {
      if (myEvents.any((EventModel eventt) => eventt.id == event.id)) {
        myEvents.removeWhere((EventModel eventt) => eventt.id == event.id);
        event.setAttendCount(event.totalAttendees! - 1);
      } else {
        myEvents.add(event);
        event.setAttendCount(event.totalAttendees! + 1);
      }
    }
    update();
  }

  void _showMyDialog() async {
    if (notificationStatus == 'active') {
      showDialog(
        context: Get.context!,
        builder: (BuildContext context) => AlertDialog(
          title: const TextWidget(
            text: 'Notification',
            fontWeight: FontWeight.bold,
            size: 20,
          ),
          content: TextWidget(
            text: notificationDescription,
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
        'reposts': psts[i]['reposts']
            .map((dynamic repost) => repost['userId'].toString())
            .toList(),
        'coins': psts[i]['coins']
            .map((dynamic coin) => coin['userId'].toString())
            .toList()
      }));
    }
    mixPostandPromoted();
  }

  /// PROCESS RAW API DATA, MODELIZE AND SAVE TO STATE
  void processForumsToState(dynamic post) {
    // print(post.length);
    final List psts = post;
    for (int i = 0; i < psts.length; i++) {
      forums.add(ForumModel.fromMap({
        ...psts[i],
        'likes': psts[i]['likes']
            .map((dynamic like) => like['userId'].toString())
            .toList(),
        'coins': psts[i]['coins']
            .map((dynamic coin) => coin['userId'].toString())
            .toList()
      }));
    }
    mixPostandPromoted();
  }

  void processPromotedPostsToState(dynamic post) {
    final List psts = post;
    if (psts.isNotEmpty) {
      for (int i = 0; i < psts.length; i++) {
        promotedPosts.add(PostModel.fromMap({
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
    }
  }

  void processPromotedMarketsToState(dynamic post) {
    final List psts = post;
    if (psts.isNotEmpty) {
      for (int i = 0; i < psts.length; i++) {
        promotedMarkets.add(MarketModel.fromMap({
          ...psts[i],
          'likes': psts[i]['likes']
              .map((dynamic like) => like['userId'].toString())
              .toList(),
          'coins': psts[i]['coins']
              .map((dynamic coin) => coin['userId'].toString())
              .toList()
        }));
      }
    }
  }

  void processPromotedCoursesToState(dynamic post) {
    final List psts = post;
    if (psts.isNotEmpty) {
      for (int i = 0; i < psts.length; i++) {
        promotedCourses.add(CourseModel.fromMap({
          ...psts[i],
          'likes': psts[i]['likes']
              .map((dynamic like) => like['userId'].toString())
              .toList(),
          'coins': psts[i]['coins']
              .map((dynamic coin) => coin['userId'].toString())
              .toList()
        }));
      }
    }
  }

  void mixPostandPromoted() {
    mixedPosts.clear();
    mixedPosts.add({'type': 'notype'});
    int promotedPostIndex = 0;
    int promotedMarketIndex = 0;
    int promotedCourseIndex = 0;

    // Add the first promoted post, if available
    if (promotedPostIndex < promotedPosts.length) {
      mixedPosts.add({
        'type': 'promotedPost',
        'index': promotedPostIndex,
        'id': promotedPosts[promotedPostIndex].postId
      });
      promotedPostIndex++;
    } else if (promotedMarketIndex < promotedMarkets.length) {
      mixedPosts.add({'type': 'market', 'index': promotedMarketIndex});
      promotedMarketIndex++;
    } else if (promotedCourseIndex < promotedCourses.length) {
      mixedPosts.add({'type': 'course', 'index': promotedCourseIndex});
      promotedCourseIndex++;
    }

    for (int i = 0; i < posts.length; i++) {
      mixedPosts.add({'type': 'post', 'index': i, 'id': posts[i].postId});

      // After every 2 posts, add a promoted item if available
      if ((i + 1) % 2 == 0) {
        if (promotedPostIndex < promotedPosts.length) {
          mixedPosts.add({'type': 'promotedPost', 'index': promotedPostIndex});
          promotedPostIndex++;
        } else if (promotedMarketIndex < promotedMarkets.length) {
          mixedPosts.add({'type': 'market', 'index': promotedMarketIndex});
          promotedMarketIndex++;
        } else if (promotedCourseIndex < promotedCourses.length) {
          mixedPosts.add({'type': 'course', 'index': promotedCourseIndex});
          promotedCourseIndex++;
        }
      }
    }

    // If there are remaining promoted posts or markets, add them
    while (promotedPostIndex < promotedPosts.length) {
      mixedPosts.add({'type': 'promotedPost', 'index': promotedPostIndex});
      promotedPostIndex++;
    }

    while (promotedMarketIndex < promotedMarkets.length) {
      mixedPosts.add({'type': 'market', 'index': promotedMarketIndex});
      promotedMarketIndex++;
    }

    while (promotedCourseIndex < promotedCourses.length) {
      mixedPosts.add({'type': 'course', 'index': promotedCourseIndex});
      promotedCourseIndex++;
    }
  }

  void processPostsAndForumsData(dynamic data, dynamic forum) {
    processPostsToState(data['posts']['rows']);
    processForumsToState(forum['rows']);
    update();
  }

  /// LIKE AND UNLIKE FUNCTION
  void postLike(String userId, String postId, String type, String receiverUid) {
    if (type == 'post') {
      //Non-sponsored posts
      final int postIndex =
          posts.indexWhere((PostModel element) => element.postId == postId);
      if (postIndex != -1) {
        final bool checkLiked = posts[postIndex].likes!.contains(userId);
        if (checkLiked) {
          posts[postIndex].likes!.removeWhere((element) => element == userId);
        } else {
          posts[postIndex].likes!.add(userId);
        }
      }

      final int promotedPostIndex = promotedPosts
          .indexWhere((PostModel element) => element.postId == postId);
      if (promotedPostIndex != -1) {
        final bool checkLiked =
            promotedPosts[promotedPostIndex].likes!.contains(userId);
        if (checkLiked) {
          promotedPosts[promotedPostIndex]
              .likes!
              .removeWhere((element) => element == userId);
        } else {
          promotedPosts[promotedPostIndex].likes!.add(userId);
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
    } else if (type == 'forum') {
      final int forumIndex =
          forums.indexWhere((ForumModel forum) => forum.forumId == postId);
      if (forumIndex != -1) {
        final bool checkLiked = forums[forumIndex].likes!.contains(userId);
        if (checkLiked) {
          forums[forumIndex].likes?.remove(userId);
        } else {
          forums[forumIndex].likes?.add(userId);
        }
      }
    } else if (type == 'course') {
      final int courseIndex = profileController.usercourses
          .indexWhere((CourseModel course) => course.id == postId);
      if (courseIndex != -1) {
        final bool checkLiked =
            profileController.usercourses[courseIndex].likes!.contains(userId);
        if (checkLiked) {
          profileController.usercourses[courseIndex].likes?.remove(userId);
        } else {
          profileController.usercourses[courseIndex].likes?.add(userId);
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
      postIndex =
          posts.indexWhere((PostModel element) => element.postId == postId);

      //sponsored posts
      spIndex = sponsoredPosts.indexWhere((Map<String, dynamic> post) =>
          post['shouldCount'] == null &&
          !post['isForum'] &&
          post['isSponsored'] &&
          post['data'].postId == postId);
    } else {
      //non-sponsored posts
      postIndex =
          posts.indexWhere((PostModel element) => element.postId == postId);

      //sponsored posts
      spIndex = sponsoredPosts.indexWhere((Map<String, dynamic> post) =>
          post['shouldCount'] == null &&
          post['isForum'] &&
          post['isSponsored'] &&
          post['data'].forumId == postId);
    }
    if (postIndex != -1) {
      posts[postIndex].comments!.add(comment);
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
      }

      final int promotedPostIndex = promotedPosts
          .indexWhere((PostModel element) => element.postId == postId);
      if (promotedPostIndex != -1) {
        final bool checkIfCoined =
            promotedPosts[promotedPostIndex].coins!.contains(userId);
        if (checkIfCoined) {
          profileController.updateCoinCount(1);
          promotedPosts[promotedPostIndex]
              .coins!
              .removeWhere((String element) => element == userId);
        } else {
          profileController.updateCoinCount(-1);
          promotedPosts[promotedPostIndex].coins!.add(userId);
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

  /// BUY COURSE WITH COINS
  void courseCoin(String userId, String courseId, String price,
      ProfileController profileController, String type, String receiverUid) {
    // final bool checkIfCoined =
    //     mixedPosts[forumIndex]['data'].coins!.contains(userId);
    // if (checkIfCoined) {
    //   profileController.updateCoinCount(int.parse(price));
    //   // mixedPosts[forumIndex]['data']
    //   //     .coins!
    //   //     .removeWhere((String element) => element == userId);
    // } else {
    //   profileController.updateCoinCount(-int.parse(price));
    //   // mixedPosts[forumIndex]['data'].coins!.add(userId);
    // }

    update();
    if (profileController.myProfile.uid != receiverUid) {
      socket.emit('coin', {
        'postId': courseId,
        'userId': userId,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'receiverUid': receiverUid,
      });
    } else {
      socket.emit('coin', {
        'postId': courseId,
        'userId': userId,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }

  /// REPOST AND UNDO REPOST FUNCTION
  Future<void> postRepost(String userId, String postId, String type,
      int timestamp, String receiverUid, int? oldtimestamp) async {
    if (type == 'post') {
      //Non-sponsored posts
      final int postIndex =
          posts.indexWhere((PostModel element) => element.postId == postId);
      if (postIndex != -1) {
        final bool checkReposted = posts[postIndex].reposts!.contains(userId);

        if (checkReposted) {
          posts[postIndex].reposts!.removeWhere((element) => element == userId);
          showSnackbar(
              title: 'Success!',
              message: 'Post successfully unreposted',
              error: false);
        } else {
          posts[postIndex].reposts?.add(userId);
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
      'oldtimestamp': timestamp,
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
          addNewRePost(response.data, profileController);
          final ApiResponseModel timeresponse = await ApiService.put(
              path: 'post/update-post/$postId',
              body: oldtimestamp == 0 ? timestampData : timestampDataoldpost);
          if (timeresponse.success) {
            print('true');
          } else {
            print('false');
          }
        } else {
          profileController.removePost(response.data['postId']);
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
    posts.insert(0, modelizedNewPost);
    mixedPosts
        .insert(1, {'type': 'post', 'index': 0, 'id': modelizedNewPost.postId});

    for (int i = 2; i < mixedPosts.length; i++) {
      if (mixedPosts[i]['type'] == 'post') {
        mixedPosts[i] = {
          'type': 'post',
          'index': mixedPosts[i]['index'] + 1,
          'id': mixedPosts[i]['id']
        };
      }
    }

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

  void addNewRePost(
      Map<String, dynamic> newPost, ProfileController profileController) async {
    PostModel modelizedNewPost = PostModel.fromMap({
      ...newPost,
      'coins': <String>[],
      'likes': <String>[],
      'reposts': <String>[],
      'comments': <CommentModel>[],
    });
    posts.insert(0, modelizedNewPost);
    mixedPosts
        .insert(1, {'type': 'post', 'index': 0, 'id': modelizedNewPost.postId});
    for (int i = 2; i < mixedPosts.length; i++) {
      if (mixedPosts[i]['type'] == 'post') {
        mixedPosts[i] = {
          'type': 'post',
          'index': mixedPosts[i]['index'] + 1,
          'id': mixedPosts[i]['id']
        };
      }
    }

    // posts.insert(0, modelizedNewPost);
    update();
    socket.emit('newPostEvent', {
      'newPost': newPost,
      'coins': <String>[],
      'likes': <String>[],
      'reposts': <String>[],
      'comments': <CommentModel>[],
    });
  }

  void removePostsByUserId(String? userId) {
    ApiService.post(
      path: 'blockedpost',
      body: <String, dynamic>{'postId': userId},
    );
    posts.removeWhere((PostModel post) => post.user?.uid == userId);
    update();
  }

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
  void addCoinDaily() async {
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
        await ApiService.put(
          path: 'users/${profileController.myProfile.uid}',
          body: <String, dynamic>{
            'coinscount': profileController.myProfile.coinscount! + 1,
            'bossOfTheWeekUpTimeStamp': currentTimestamp,
          },
        );
        ApiService.post(path: 'transaction-history', body: {
          'userId': profileController.myProfile.uid,
          'transactionType': 'credit',
          'amount': 1,
          'paymentMethod': 'bank',
          'date': currentTimestamp,
          'approved': true,
          'status': 'Successful',
          'description': 'Daily Coin',
        });
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
        paginationPage.value, posts[posts.length - 1].timestamp);

    final ApiResponseModel forum = await HomeRepository.fetchForums(
        profileController.myProfile.uid, paginationPage.value);
    if (response.success) {
      paginationPage(paginationPage.value + 1);
      processPostsAndForumsData(response.data, forum.data);
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
      posts.insert(1, modelizedNewPost);
      mixedPosts.insert(
          1, {'type': 'posts', 'index': 1, 'id': modelizedNewPost.postId});

      update();
    }
  }

  void removePost(String postId) {
    mixedPosts.removeWhere((Map<String, dynamic> element) =>
        element['type'] == 'post' && element['id'] == postId);
    posts.removeWhere((element) => element.postId == postId);

    profileController.removePost(postId);
    update();
  }

  void updatePost(PostModel post) {
    final int postIndex =
        posts.indexWhere((PostModel element) => element.postId == post.postId);
    if (postIndex != -1) {
      posts[postIndex] = post;
      update();
    }
  }

  void updateViews(PostModel post) {
    HomeRepository.updateViews(post.postId, post.views! + 1);
    final int postIndex =
        posts.indexWhere((PostModel element) => element.postId == post.postId);
    if (postIndex != -1) {
      // Increment the view count of the post by 1
      posts[postIndex].setViews(post.views! + 1);
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
    final ApiResponseModel promoted = await HomeRepository.fetchPromoted();
    if (response.success) {
      profileController.processDataToState(
          {...response.data['user'], 'connecteds': response.data['connecteds']},
          response.data['interests'],
          response.data['userRanking']);
      _chatController.processDataToState(
          response.data['chats'], profileController.myProfile.uid);
      socket.emit('handshake', profileController.myProfile.uid);
      addCoinDaily();
      if (partner.success) {
        if (partner.data['count'] > 0) {
          bossUp?.addAll(partner.data['rows'].cast<Map<String, dynamic>>());
          // Find the item with id = 5
          final Map<String, dynamic> getTitle = bossUp!
              .firstWhere((Map<String, dynamic> item) => item['id'] == 5);

          bossUpTitle = getTitle['companyName'];
          bossUpLink = getTitle['companyUrl'];
          bossUp?.removeWhere((Map<String, dynamic> item) => item['id'] == 5);
        }
      } else {
        error(true);
        update();
      }
      if (promoted.success) {
        processPromotedPostsToState(promoted.data['promotedPosts']['rows']);
        processPromotedMarketsToState(promoted.data['promotedMarkets']['rows']);
        processPromotedCoursesToState(promoted.data['promotedCourses']['rows']);
        processPostsAndForumsData(
            response.data['posts'], response.data['posts']['forums']);
      }
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
    _showMyDialog();
    FirebaseMessaging.instance.getToken().then((String? value) {
      Map<String, dynamic> data = <String, dynamic>{
        'deviceToken': value,
      };
      ApiService.post(path: 'users/add-device-token', body: data);
    });
  }

  // /// LOAD POSTS FROM REMOTE SOURCE
  // Future<void> refreshData() async {
  //   refreshing(true);
  //   // error(false);
  //   update();
  //   final ApiResponseModel response = await HomeRepository.fetchRefreshData();
  //   final ApiResponseModel partner = await HomeRepository.fetchPartner();
  //   if (response.success) {
  //     processPostsAndForumsData(response.data['posts'], );
  //     // profileController.processDataToState(
  //     //     response.data['user'], response.data['interests']);
  //     bossUp?.clear();
  //     if (partner.data['count'] > 0) {
  //       bossUp?.addAll(partner.data['rows'].cast<Map<String, dynamic>>());
  //       // Find the item with id = 5
  //       final Map<String, dynamic> getTitle =
  //           bossUp!.firstWhere((Map<String, dynamic> item) => item['id'] == 5);

  //       bossUpTitle = getTitle['companyName'];
  //       bossUpLink = getTitle['companyUrl'];
  //     }
  //   } else {
  //     error(true);
  //     // showSnackbar(
  //     //     title: 'OOPS!',
  //     //     message: 'An error occurred, please try again!',
  //     //     error: true);
  //   }

  //   refreshing(false);
  //   update();
  // }

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
