// ignore_for_file: library_prefixes, public_member_api_docs, always_specify_types, always_declare_return_types, avoid_print

import 'dart:developer';
import 'dart:io';

import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/models/comment_model.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/common/widgets/text_widget.dart';
import 'package:business_bosses_v2/features/chat/controllers/chat_controller.dart';
import 'package:business_bosses_v2/features/courses/models/course_model.dart';
import 'package:business_bosses_v2/features/donations/models/donations_model.dart';
import 'package:business_bosses_v2/features/forum/models/forum_model.dart';
import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:business_bosses_v2/features/home/repository/home_repository.dart';
import 'package:business_bosses_v2/features/impact/controllers/impact_controller.dart';
import 'package:business_bosses_v2/features/live_event/models/events_model.dart';
import 'package:business_bosses_v2/features/marketplace/models/buyer_request_model.dart';
import 'package:business_bosses_v2/features/posts/controllers/create_post_controller.dart';
import 'package:business_bosses_v2/features/posts/models/post_model.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/features/profile/presentation/update_profile_screen.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:business_bosses_v2/utils/constants/constants.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class HomeController extends GetxController {
  late io.Socket socket;
  // final PostsController _postsController = Get.find();
  late final ProfileController profileController;
  late final ChatController _chatController;
  // ignore: unused_field
  late final CreatePostController _createPostController;
  // final CommunitiesController _communitiesController =
  //     Get.put(CommunitiesController());
  final GetStorage sandBox = GetStorage();
  RxBool error = RxBool(false);
  RxBool noConnection = RxBool(false);
  List<Industry> industries = <Industry>[];
  List<UserModel> bossupMembers = <UserModel>[];

  RxInt paginationPage = RxInt(1);
  RxBool loading = RxBool(false);
  RxBool loadingMore = RxBool(false);
  RxBool refreshing = RxBool(false);
  List<Map<String, dynamic>> mixedPosts = <Map<String, dynamic>>[
    <String, dynamic>{'type': 'notype'},
  ];
  List<Map<String, dynamic>> sponsoredPosts = <Map<String, dynamic>>[
    <String, dynamic>{
      'isForum': false,
      'data': <dynamic, dynamic>{},
      'shouldCount': false,
      'isSponsored': true
    }
  ];
  List<String> blocked = <String>[];
  RxList<PostModel> promotedPosts = RxList<PostModel>(<PostModel>[]);
  RxList<CourseModel> promotedCourses = RxList<CourseModel>(<CourseModel>[]);
  RxList<EventModel> events = RxList<EventModel>(<EventModel>[]);
  RxList<EventModel> myEvents = RxList<EventModel>(<EventModel>[]);
  // RxList<UserModel> marketMembers = RxList<UserModel>(<UserModel>[]);
  Set<dynamic> itemsWithIncrementedViews = <dynamic>{};
  String notificationDescription = '';
  String notificationStatus = '';
  Map<String, String> votes = <String, String>{};
  RxList<PostModel> posts = RxList<PostModel>(<PostModel>[]);
  RxList<CourseModel> courses = RxList<CourseModel>(<CourseModel>[]);
  RxList<ForumModel> forums = RxList<ForumModel>(<ForumModel>[]);
  RxList<DonationModel> donations = RxList<DonationModel>(<DonationModel>[]);
  RxList<CourseModel> usercourses = <CourseModel>[].obs;
  RxBool cError = RxBool(false);
  RxList<DonationModel> userdonations = <DonationModel>[].obs;
  UserModel? bossOfTheWeek = UserModel();
  UserModel? mentorOfTheWeek = UserModel();
  UserModel? backerOfTheWeek = UserModel();
  UserModel? ambassadorOfTheWeek = UserModel();
  dynamic partnerOfTheWeek;
  RxList<BuyerRequestModel> myRequests = <BuyerRequestModel>[].obs;
  RxBool loadingRequests = false.obs;
  final ReachController impactController = Get.put(ReachController());

  void addIndustries(List<Industry> data) {
    industries = data;
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

  // void addMarketMembers(RxList<UserModel> data) {
  //   marketMembers.clear();
  //   marketMembers = data;
  // }

  void pollVote(PostModel post, String selectedOption) {
    ApiService.post(path: 'pollvote', body: <String, dynamic>{
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
            color: Colors.black.withValues(alpha: .8),
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
  List<String> _extractUserIds(dynamic items) {
    if (items is List) {
      return items.map((dynamic e) => e['userId'].toString()).toList();
    }
    return <String>[];
  }

  /// Convert dynamic post list to PostModel list efficiently
  void processPostsToState(List<dynamic>? list) {
    if (list == null || list.isEmpty) return;

    final Iterable<PostModel> parsed = list.map((dynamic e) {
      return PostModel.fromMap(<String, dynamic>{
        ...e,
        'likes': e['likes'].map((dynamic e) => e['userId']).toList(),
        'reposts': e['reposts'].map((dynamic e) => e['userId']).toList(),
        'coins': e['coins'].map((dynamic e) => e['userId']).toList(),
      });
    });

    posts.addAll(parsed);
  }

  /// Convert dynamic post list to PostModel list efficiently
  void processCoursesToState(List<dynamic>? list) {
    if (list == null || list.isEmpty) return;

    final Iterable<CourseModel> parsed = list.map((dynamic e) {
      return CourseModel.fromMap(<String, dynamic>{...e});
    });

    courses.addAll(parsed);
  }

  void processForumsToState(List<dynamic>? list) {
    if (list == null || list.isEmpty) return;

    final Iterable<ForumModel> parsed = list.map((dynamic e) {
      return ForumModel.fromMap(<String, dynamic>{
        ...e,
        'likes': _extractUserIds(e['likes']),
        'coins': _extractUserIds(e['coins']),
      });
    });

    forums.addAll(parsed);
  }

  void processDonationsoState(List<dynamic>? list) {
    if (list == null || list.isEmpty) return;

    final Iterable<DonationModel> parsed = list.map((dynamic e) {
      return DonationModel.fromMap(<String, dynamic>{
        ...e,
        'likes': _extractUserIds(e['likes']),
      });
    });

    donations.addAll(parsed);
  }

  /// Promoted posts
  void processPromotedPostsToState(dynamic post) {
    final List<dynamic> psts = List<dynamic>.from(post ?? <dynamic>[]);
    if (psts.isEmpty) return;

    promotedPosts.addAll(psts.map((dynamic e) {
      return PostModel.fromMap(<String, dynamic>{
        ...e,
        'likes': _extractUserIds(e['likes']),
        'reposts': _extractUserIds(e['reposts']),
        'coins': _extractUserIds(e['coins']),
      });
    }));
  }

  Future<void> loadMyRequests() async {
    loadingRequests.value = true;
    myRequests.clear();
    try {
      final ApiResponseModel response = await ApiService.get(
          path: 'buyer-request/user/${profileController.myProfile.uid}');
      if (response.success) {
        myRequests.clear();
        for (dynamic request in response.data) {
          myRequests.add(BuyerRequestModel.fromJson(request));
        }
      }
    } finally {
      loadingRequests.value = false;
    }
  }

  /// Promoted courses
  void processPromotedCoursesToState(dynamic post) {
    final List<dynamic> psts = List<dynamic>.from(post ?? <dynamic>[]);
    if (psts.isEmpty) return;

    promotedCourses.addAll(psts.map((dynamic e) {
      return CourseModel.fromMap(<String, dynamic>{
        ...e,
        'likes': _extractUserIds(e['likes']),
        'coins': _extractUserIds(e['coins']),
      });
    }));
  }

  /// Mix posts and promoted content for feed
  /// Mix posts + courses, sort by timestamp and then mix with promoted
  /// Mix posts + courses + forums + donations
  void mixPostandPromoted() {
    final List<Map<String, dynamic>> result = <Map<String, dynamic>>[
      <String, dynamic>{'type': 'notype'}
    ];

    // 1) Build unified organic list
    final List<Map<String, dynamic>> organic = <Map<String, dynamic>>[];

    for (int i = 0; i < posts.length; i++) {
      organic.add(<String, dynamic>{
        'kind': 'post',
        'index': i,
        'id': posts[i].postId,
        'timestamp': posts[i].timestamp,
      });
    }

    for (int i = 0; i < courses.length; i++) {
      organic.add(<String, dynamic>{
        'kind': 'course',
        'index': i,
        'id': courses[i].id,
        'timestamp': courses[i].timestamp ?? 0,
      });
    }

    for (int i = 0; i < donations.length; i++) {
      organic.add(<String, dynamic>{
        'kind': 'donation',
        'index': i,
        'id': donations[i].id,
        'timestamp': donations[i].timestamp ?? 0,
      });
    }

    for (int i = 0; i < forums.length; i++) {
      organic.add(<String, dynamic>{
        'kind': 'forum',
        'index': i,
        'id': forums[i].forumId,
        'timestamp': forums[i].timestamp ?? 0,
      });
    }

    // 2) Sort by timestamp DESC
    organic.sort(
      (Map<String, dynamic> a, Map<String, dynamic> b) =>
          (b['timestamp'] as int).compareTo(a['timestamp'] as int),
    );

    int promotedPostIndex = 0;
    int promotedCourseIndex = 0;

    // Optional: promote first post at top
    if (promotedPosts.isNotEmpty) {
      result.add(<String, dynamic>{'type': 'promotedPost', 'index': 0});
      promotedPostIndex = 1;
    }

    // 3) Walk & insert promoted
    for (int i = 0; i < organic.length; i++) {
      final Map<String, dynamic> item = organic[i];

      result.add(<String, dynamic>{
        'type': item['kind'], // post / course / donation / forum
        'index': item['index'],
        'id': item['id'],
        'source': 'organic',
      });

      if ((i + 1) % 2 == 0) {
        if (promotedPostIndex < promotedPosts.length) {
          result.add(<String, dynamic>{
            'type': 'promotedPost',
            'index': promotedPostIndex++,
          });
        } else if (promotedCourseIndex < promotedCourses.length) {
          result.add(<String, dynamic>{
            'type': 'course',
            'index': promotedCourseIndex++,
            'source': 'promoted',
          });
        }
      }
    }

    mixedPosts = result;
  }

  /// Combine post and forum data
  void processPostsAndCoursesData(dynamic data) {
    processPostsToState(data?['posts']?['rows']);
    processCoursesToState(data?['courses']?['rows']);
    processForumsToState(data?['forums']?['rows']);
    processDonationsoState(data?['donations']?['rows']);
    mixPostandPromoted();
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
          posts[postIndex]
              .likes!
              .removeWhere((String element) => element == userId);
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
              .removeWhere((String element) => element == userId);
        } else {
          promotedPosts[promotedPostIndex].likes!.add(userId);
        }
      }

      //Sponsored posts
      final int spIndex = sponsoredPosts.indexWhere(
          (Map<String, dynamic> post) =>
              post['shouldCount'] == null &&
              post['isSponsored'] &&
              post['data'].postId == postId);
      if (spIndex != -1) {
        final bool checkLiked =
            sponsoredPosts[spIndex]['data'].likes!.contains(userId);
        if (checkLiked) {
          sponsoredPosts[spIndex]['data']
              .likes!
              .removeWhere((dynamic element) => element == userId);
        } else {
          sponsoredPosts[spIndex]['data'].likes!.add(userId);
        }
      }
    } else if (type == 'course') {
      final int courseIndex =
          usercourses.indexWhere((CourseModel course) => course.id == postId);
      if (courseIndex != -1) {
        final bool checkLiked =
            usercourses[courseIndex].likes!.contains(userId);
        if (checkLiked) {
          usercourses[courseIndex].likes?.remove(userId);
        } else {
          usercourses[courseIndex].likes?.add(userId);
        }
      }
    }
    // else {
    //   final int postIndex = mixedPosts.indexWhere(
    //       (Map<String, dynamic> post) => post['shouldCount'] == null);
    //   if (postIndex != -1) {
    //     final bool checkLiked =
    //         mixedPosts[postIndex]['data'].likes!.contains(userId);
    //     if (checkLiked) {
    //       mixedPosts[postIndex]['data']
    //           .likes!
    //           .removeWhere((element) => element == userId);
    //     } else {
    //       mixedPosts[postIndex]['data'].likes!.add(userId);
    //     }
    //   }
    // }

    // --- FIX: Forum like ---
    if (type == 'forum') {
      final int forumIndex =
          forums.indexWhere((ForumModel element) => element.forumId == postId);
      if (forumIndex != -1) {
        final bool checkLiked = forums[forumIndex].likes!.contains(userId);
        if (checkLiked) {
          forums[forumIndex]
              .likes!
              .removeWhere((String element) => element == userId);
        } else {
          forums[forumIndex].likes!.add(userId);
        }
      }
    }

    if (type == 'donation') {
      final int donationIndex =
          donations.indexWhere((DonationModel element) => element.id == postId);
      if (donationIndex != -1) {
        final bool checkLiked =
            donations[donationIndex].likes!.contains(userId);
        if (checkLiked) {
          donations[donationIndex]
              .likes!
              .removeWhere((String element) => element == userId);
        } else {
          donations[donationIndex].likes!.add(userId);
        }
      }
    }

// --- FIX: Course like (global courses feed) ---
    if (type == 'course') {
      final int courseIndex =
          courses.indexWhere((CourseModel element) => element.id == postId);
      if (courseIndex != -1) {
        final bool checkLiked = courses[courseIndex].likes!.contains(userId);
        if (checkLiked) {
          courses[courseIndex].likes!.remove(userId);
        } else {
          courses[courseIndex].likes!.add(userId);
        }
      }
    }

    update();

    // REST API call to persist the like
    ApiService.post(path: 'likes', body: <String, dynamic>{
      'postId': postId,
      'userId': userId,
      'type': type,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });

    if (profileController.myProfile.uid != receiverUid) {
      socket.emit('like', <String, Object>{
        'postId': postId,
        'userId': userId,
        'type': type,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'receiverUid': receiverUid,
      });
    } else {
      socket.emit('like', <String, Object>{
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
          post['isSponsored'] &&
          post['data'].postId == postId);
    } else {
      //non-sponsored posts
      postIndex =
          posts.indexWhere((PostModel element) => element.postId == postId);

      //sponsored posts
      spIndex = sponsoredPosts.indexWhere((Map<String, dynamic> post) =>
          post['shouldCount'] == null && post['isSponsored']);
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
    }
    // --- FIX: Forum coin ---
    if (type == 'forum') {
      final int forumIndex =
          forums.indexWhere((ForumModel element) => element.forumId == postId);
      if (forumIndex != -1) {
        final bool checkIfCoined = forums[forumIndex].coins!.contains(userId);
        if (checkIfCoined) {
          profileController.updateCoinCount(1);
          forums[forumIndex]
              .coins!
              .removeWhere((String element) => element == userId);
        } else {
          profileController.updateCoinCount(-1);
          forums[forumIndex].coins!.add(userId);
        }
      }
    }

// --- FIX: Course coin (UI only toggle) ---
    if (type == 'course') {
      final int courseIndex =
          courses.indexWhere((CourseModel element) => element.id == postId);
      if (courseIndex != -1) {
        final bool checkIfCoined = courses[courseIndex].coins!.contains(userId);
        if (checkIfCoined) {
          profileController.updateCoinCount(1);
          courses[courseIndex].coins!.remove(userId);
        } else {
          profileController.updateCoinCount(-1);
          courses[courseIndex].coins!.add(userId);
        }
      }
    }

    update();
    if (profileController.myProfile.uid != receiverUid) {
      socket.emit('coin', <String, Object>{
        'postId': postId,
        'userId': userId,
        'type': type,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'receiverUid': receiverUid,
      });
    } else {
      socket.emit('coin', <String, Object>{
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
    update();
    if (profileController.myProfile.uid != receiverUid) {
      socket.emit('coin', <String, Object>{
        'postId': courseId,
        'userId': userId,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'receiverUid': receiverUid,
      });
    } else {
      socket.emit('coin', <String, Object>{
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
          posts[postIndex]
              .reposts!
              .removeWhere((String element) => element == userId);
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
              post['isSponsored'] &&
              post['data'].postId == postId);
      if (spIndex != -1) {
        final bool checkReposts =
            sponsoredPosts[spIndex]['data'].reposts!.contains(userId);
        if (checkReposts) {
          sponsoredPosts[spIndex]['data']
              .reposts!
              .removeWhere((dynamic element) => element == userId);
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
    Map<String, dynamic> repostData = <String, dynamic>{
      'postId': postId,
      'oldtimestamp': timestamp,
    };

    Map<String, dynamic> timestampData = <String, dynamic>{
      'oldtimestamp': timestamp,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };

    Map<String, dynamic> timestampDataoldpost = <String, dynamic>{
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };

    try {
      ApiResponseModel response =
          await ApiService.post(path: 'post/create-repost', body: repostData);
      //if repost is deleted this is the response "repost":{"success":true,"message":"reposted post deleted"}
      // Handle the response if needed

      if (response.success) {
        dynamic reposted = response.data['repost']['reposted'];
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
    PostModel modelizedNewPost = PostModel.fromMap(<String, dynamic>{
      ...newPost,
      'coins': <String>[],
      'likes': <String>[],
      'reposts': <String>[],
      'comments': <CommentModel>[],
      'user': <String, String?>{
        'username': profileController.myProfile.username,
        'email': profileController.myProfile.email,
        'uid': profileController.myProfile.uid,
        'name': profileController.myProfile.name,
        'bio': profileController.myProfile.bio
      }
    });
    posts.insert(0, modelizedNewPost);
    mixedPosts.insert(1, <String, dynamic>{
      'type': 'post',
      'index': 0,
      'id': modelizedNewPost.postId
    });

    for (int i = 2; i < mixedPosts.length; i++) {
      if (mixedPosts[i]['type'] == 'post') {
        mixedPosts[i] = <String, dynamic>{
          'type': 'post',
          'index': mixedPosts[i]['index'] + 1,
          'id': mixedPosts[i]['id']
        };
      }
    }

    // posts.insert(0, modelizedNewPost);
    update();
    socket.emit('newPostEvent', <String, Map<String, dynamic>>{
      'newPost': newPost,
      'user': <String, String?>{
        'username': profileController.myProfile.username,
        'email': profileController.myProfile.email,
        'uid': profileController.myProfile.uid,
        'name': profileController.myProfile.name,
        'bio': profileController.myProfile.bio
      }
    });
  }

  void addNewForum(Map<String, dynamic> newPost) async {
    ForumModel modelizedNewPost = ForumModel.fromMap(<String, dynamic>{
      ...newPost,
      'coins': <String>[],
      'likes': <String>[],
      'comments': <CommentModel>[],
      'user': profileController.myProfile.toMap()
    });

    forums.insert(0, modelizedNewPost);
    mixPostandPromoted();
    update();
  }

  void addNewCourse(Map<String, dynamic> newPost, int id) async {
    courses.insert(
        0,
        CourseModel.fromMap(<String, dynamic>{
          ...newPost,
          'id': id,
          'coins': <String>[],
          'likes': <String>[],
          'comments': <CommentModel>[],
          'user': profileController.myProfile.toMap()
        }));
    mixPostandPromoted();
    update();
  }

  void addNewRePost(
      Map<String, dynamic> newPost, ProfileController profileController) async {
    PostModel modelizedNewPost = PostModel.fromMap(<String, dynamic>{
      ...newPost,
      'coins': <String>[],
      'likes': <String>[],
      'reposts': <String>[],
      'comments': <CommentModel>[],
    });
    posts.insert(0, modelizedNewPost);
    mixedPosts.insert(1, <String, dynamic>{
      'type': 'post',
      'index': 0,
      'id': modelizedNewPost.postId
    });
    for (int i = 2; i < mixedPosts.length; i++) {
      if (mixedPosts[i]['type'] == 'post') {
        mixedPosts[i] = <String, dynamic>{
          'type': 'post',
          'index': mixedPosts[i]['index'] + 1,
          'id': mixedPosts[i]['id']
        };
      }
    }

    // posts.insert(0, modelizedNewPost);
    update();
    socket.emit('newPostEvent', <String, Object>{
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
      builder: (BuildContext context) => PopScope(
        canPop: false,
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
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Get.dialog(
                  const Center(child: CircularProgressIndicator()),
                  barrierDismissible:
                      false, // Prevent dialog from closing when tapping outside
                );
                ApiService().logout();
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
          color: Colors.black.withValues(alpha: .8),
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
          color: Colors.black.withValues(alpha: .8),
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
      profileController.myProfile = UserModel.fromMap(<dynamic, dynamic>{
        ...profileController.myProfile.toMap(),
        'isUpdated': false
      });
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
        ApiService.post(path: 'transaction-history', body: <String, dynamic>{
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
    if (response.success) {
      paginationPage(paginationPage.value + 1);
      processPostsAndCoursesData(response.data);
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
    mixPostandPromoted();
    update();
  }

  Future<void> sinkPosts(Map<String, dynamic> data) async {
    if (profileController.myProfile.uid != data['user']['uid']) {
      PostModel modelizedNewPost = PostModel.fromMap(<String, dynamic>{
        ...data['newPost'],
        'coins': <String>[],
        'likes': <String>[],
        'reposts': <String>[],
        'comments': <CommentModel>[],
        'user': data['user']
      });
      posts.insert(1, modelizedNewPost);
      mixedPosts.insert(1, <String, dynamic>{
        'type': 'posts',
        'index': 1,
        'id': modelizedNewPost.postId
      });

      update();
    }
  }

  void removePost(String postId) {
    mixedPosts.removeWhere((Map<String, dynamic> element) =>
        element['type'] == 'post' && element['id'] == postId);
    posts.removeWhere((PostModel element) => element.postId == postId);

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
    }
  }

  /// LOAD POSTS FROM REMOTE SOURCE
  Future<void> loadData() async {
    loading(true);
    error(false);
    update();

    try {
      // Run multiple API calls concurrently
      final List<ApiResponseModel> results =
          await Future.wait(<Future<ApiResponseModel>>[
        HomeRepository.fetchData(),
        HomeRepository.fetchPromoted(),
      ]);

      final ApiResponseModel response = results[0];
      final ApiResponseModel promoted = results[1];

      if (!response.success) {
        if (response.message == 'send a valid token') {
          await ApiService().logout();
          showAccessTokenDialog();
        }
        error(true);
        cError(true);
        loading(false);
        update();
        socket.disconnect();
        return;
      }

      // --- Main Data Processing ---
      final dynamic data = response.data;

      profileController.processDataToState(
        <dynamic, dynamic>{...data['user'], 'connecteds': data['connecteds']},
        data['interests'],
        data['userRanking'],
      );

      partnerOfTheWeek = response.data['partnerOfTheWeek'];

      _chatController.processDataToState(
          data['chats'], profileController.myProfile.uid);
      socket.emit('handshake', profileController.myProfile.uid);

      // --- Promoted Data ---
      if (promoted.success) {
        processPromotedPostsToState(promoted.data['promotedPosts']['rows']);
        processPromotedCoursesToState(promoted.data['promotedCourses']['rows']);
        processPostsAndCoursesData(data['posts']);
      }

      // --- Profile Setup ---
      if (profileController.myProfile.bio == null) {
        Get.off(() => UpdateProfileScreen(user: profileController.myProfile));
      }

      // --- Courses ---
      final List<Map<String, dynamic>> courseRows =
          List<Map<String, dynamic>>.from(
              data['courses']?['rows'] ?? <dynamic>[]);
      usercourses.addAll(
          courseRows.map((Map<String, dynamic> e) => CourseModel.fromMap(e)));

      // --- Donations ---
      final List<Map<String, dynamic>> donationRows =
          List<Map<String, dynamic>>.from(
              data['donations']?['rows'] ?? <dynamic>[]);
      userdonations.addAll(donationRows.map((Map<String, dynamic> e) {
        return DonationModel.fromMap(<String, dynamic>{
          ...e,
          'likes': (e['likes'] as List<dynamic>)
              .map((dynamic like) => like['userId'].toString())
              .toList(),
        });
      }));

      // --- Remaining Setup ---
      processBossToState(data['bossOfTheWeek']);
      processMentorToState(data['mentorOfTheWeek']);
      processBackerToState(data['backerOfTheWeek']);
      processAmbassadorToState(data['ambassadorOfTheWeek']);
      if (profileController.myProfile.hasShop) {
        await Get.find<ShopController>().initShop();
      }

      // Final UI updates & background tasks
      loading(false);
      update();

      addCoinDaily();
      _showMyDialog();
      // Fire and forget: send device token

      // Fire and forget: send device token
      try {
        // Check platform first
        if (Platform.isIOS) {
          // On iOS, check if APNS token is available first
          final String? apnsToken =
              await FirebaseMessaging.instance.getAPNSToken();
          if (apnsToken != null) {
            final String? token = await FirebaseMessaging.instance.getToken();
            if (token != null) {
              ApiService.post(
                  path: 'users/add-device-token',
                  body: <String, dynamic>{'deviceToken': token});
            }
          } else {
            // APNS token not ready yet, listen for it
            FirebaseMessaging.instance.onTokenRefresh.listen((String token) {
              ApiService.post(
                  path: 'users/add-device-token',
                  body: <String, dynamic>{'deviceToken': token});
            });
          }
        } else {
          // Android - direct token retrieval
          final String? token = await FirebaseMessaging.instance.getToken();
          if (token != null) {
            ApiService.post(
                path: 'users/add-device-token',
                body: <String, dynamic>{'deviceToken': token});
          }
        }
      } catch (e) {
        debugPrint('Failed to get FCM token: $e');
        // Non-critical error, app can continue without push token
      }
      await impactController.loadData(
          profileController.myProfile.uid, profileController.myProfile.uid);
      loadMyRequests();
    } catch (e, st) {
      debugPrint('Error loading data: $e\n$st');
      error(true);
      loading(false);
      update();
    }
  }

  Future<void> updateCourse(Map<String, dynamic> course, String id) async {
    final ApiResponseModel response =
        await ApiService.put(path: 'courses/update-course/$id', body: course);

    if (response.success) {
      int index = usercourses.indexWhere((CourseModel c) => c.id == id);
      if (index != -1) {
        usercourses[index] = CourseModel.fromMap(course);
        Get.back();
        showSnackbar(message: 'Course updated successfully', title: 'Success');
      } else {
        showSnackbar(
            message: 'Course not found in the list',
            title: 'Error',
            error: true);
      }
      update();
    }
  }

  void onDeleteCourse(String courseId) async {
    try {
      final ApiResponseModel response = await ApiService.delete(
        path: 'courses/delete-course/$courseId',
      );

      if (response.success) {
        showSnackbar(message: 'Course deleted successfully!', title: 'Success');
        usercourses.removeWhere((CourseModel course) => course.id == courseId);
        courses.removeWhere((CourseModel course) => course.id == courseId);
        mixPostandPromoted();
        update();

        return;
      } else {
        showSnackbar(
            message: 'Failed to delete course.', title: 'O0PS!', error: true);
        return;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateCourseViews(String id, int views) async {
    Map<String, dynamic> course = <String, dynamic>{'views': views};
    final ApiResponseModel response =
        await ApiService.put(path: 'courses/update-course/$id', body: course);

    if (response.success) {
      int index = usercourses.indexWhere((CourseModel c) => c.id == id);
      if (index != -1) {
        usercourses[index] = CourseModel.fromMap(<String, dynamic>{
          ...usercourses[index].toMap(),
          ...course,
        });
      }
      update();
    }
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

  void processBossToState(dynamic userData) {
    final UserModel modelizedData = UserModel.fromMap(<dynamic, dynamic>{
      ...userData,
      'connections': <dynamic>[],
      'connecteds': <dynamic>[]
    });
    bossOfTheWeek = modelizedData;
    update();
  }

  void processMentorToState(dynamic userData) {
    final UserModel modelizedData = UserModel.fromMap(<dynamic, dynamic>{
      ...userData,
      'connections': <dynamic>[],
      'connecteds': <dynamic>[]
    });
    mentorOfTheWeek = modelizedData;
    update();
  }

  void processBackerToState(dynamic userData) {
    final UserModel modelizedData = UserModel.fromMap(<dynamic, dynamic>{
      ...userData,
      'connections': <dynamic>[],
      'connecteds': <dynamic>[]
    });
    backerOfTheWeek = modelizedData;
    update();
  }

  void processAmbassadorToState(dynamic userData) {
    final UserModel modelizedData = UserModel.fromMap(<dynamic, dynamic>{
      ...userData,
      'connections': <dynamic>[],
      'connecteds': <dynamic>[]
    });
    ambassadorOfTheWeek = modelizedData;
    update();
  }

  void initSocket() {
    socket = io.io(Constants.socketUrl, <String, dynamic>{
      'autoConnect': false,
      'transports': <String>['websocket'],
    });
    socket.connect();
    socket.onConnect((_) {
      print('Connection established');
    });

    socket.on('handshake', (dynamic data) {
      // print(data);
    });

    socket.on('new-message', (dynamic data) {
      // print(data);
      _chatController.newMessage(data);
    });

    socket.on('new-notification', (dynamic data) {
      // print(data);
      profileController.updateProfile(<String, dynamic>{
        ...profileController.myProfile.toMap(),
        'unReadCount': 1
      });
    });

    socket.onReconnect((_) {
      socket.emit('handshake', profileController.myProfile.uid);

      print('reconnected');
    });

    socket.onDisconnect((_) => print('Connection Disconnection'));
    socket.onConnectError((dynamic err) => print(err));
    socket.onError((dynamic err) => print(err));
  }

  @override
  void onInit() {
    profileController = Get.put(ProfileController());
    _chatController = Get.put(ChatController());

    initSocket(); // only ONE socket setup

    loadData(); // loads once

    super.onInit();
  }

  @override
  void dispose() {
    socket.disconnect();
    socket.dispose();
    super.dispose();
    socket.off('newPostEvent');
  }
}
