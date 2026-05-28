import 'dart:io';

import 'package:business_bosses_v2/bbpro/models/shop_model.dart';
import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/models/comment_model.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/common/widgets/text_widget.dart';
import 'package:business_bosses_v2/features/chat/controllers/chat_controller.dart';
import 'package:business_bosses_v2/features/forum/controller/bossup_controller.dart';
import 'package:business_bosses_v2/features/forum/controller/forum_controller.dart';
import 'package:business_bosses_v2/features/courses/models/course_model.dart';
import 'package:business_bosses_v2/features/donations/models/donations_model.dart';
import 'package:business_bosses_v2/features/forum/models/forum_model.dart';
import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:business_bosses_v2/features/home/repository/home_repository.dart';
import 'package:business_bosses_v2/features/impact/controllers/impact_controller.dart';
import 'package:business_bosses_v2/features/live_event/models/events_model.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/market_controller.dart';
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
  dynamic partnerOfTheWeek;
  RxList<BuyerRequestModel> myRequests = <BuyerRequestModel>[].obs;
  RxBool loadingRequests = false.obs;
  UserModel? rankWinner;
  Shop? rankWinnerShop;
  RxBool loadingRankWinner = true.obs;

  /// Holds stable random numbers for non-business users to prevent UI jitter
  final Map<String, String> _stableMetrics = <String, String>{};

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

  Future<void> fetchRankWinner() async {
    // 🔥 1. Load from cache immediately
    final dynamic cachedWinner = sandBox.read('rank_winner_cache');
    if (cachedWinner != null) {
      rankWinnerShop = Shop.fromMap(cachedWinner['shop'] ?? <String, dynamic>{});
      rankWinner = rankWinnerShop?.user;
      loadingRankWinner.value = false;
      update();
    } else {
      loadingRankWinner.value = true;
    }

    try {
      // 🔥 2. Background fetch
      final ApiResponseModel response =
          await ApiService.get(path: 'impact/top/shops?limit=1');

      if (response.success &&
          response.data != null &&
          response.data is List<dynamic> &&
          (response.data as List<dynamic>).isNotEmpty) {
        final Map<String, dynamic> winnerData =
            Map<String, dynamic>.from((response.data as List<dynamic>).first);

        // Update state
        rankWinnerShop =
            Shop.fromMap(winnerData['shop'] ?? <String, dynamic>{});
        rankWinner = rankWinnerShop?.user;

        // Save to cache
        await sandBox.write('rank_winner_cache', winnerData);
      }
    } catch (e) {
      debugPrint('Error fetching rank winner: $e');
    } finally {
      loadingRankWinner.value = false;
      update();
    }
  }

  /// PROCESS RAW API DATA, MODELIZE AND SAVE TO STATE
  List<String> _extractUserIds(dynamic items) {
    if (items is List<dynamic>) {
      return List<String>.from(
          items.map((dynamic e) => e['userId'].toString()));
    }
    return <String>[];
  }

  /// Convert dynamic post list to PostModel list efficiently
  void processPostsToState(List<dynamic>? list) {
    if (list == null || list.isEmpty) return;

    final Iterable<PostModel> parsed = list.map((dynamic e) {
      final List<String> likes = List<String>.from(
          e['likes'].map((dynamic e) => e['userId'].toString()));
      final List<String> reposts = List<String>.from(
          e['reposts']?.map((dynamic e) => e['userId'].toString()) ??
              <dynamic>[]);
      final List<String> coins = List<String>.from(
          e['coins'].map((dynamic e) => e['userId'].toString()));

      profileController.updateInteractionState(e['postId'].toString(),
          likes: likes, reposts: reposts, coins: coins);

      return PostModel.fromMap(<String, dynamic>{
        ...e,
        'likes': likes,
        'reposts': reposts,
        'coins': coins,
      });
    });

    posts.addAll(parsed);
  }

  /// Convert dynamic post list to PostModel list efficiently
  void processCoursesToState(List<dynamic>? list) {
    if (list == null || list.isEmpty) return;

    final Iterable<CourseModel> parsed = list.map((dynamic e) {
      final List<String> likes = _extractUserIds(e['likes']);
      final List<String> coins = _extractUserIds(e['coins']);

      profileController.updateInteractionState(e['id'].toString(),
          likes: likes, coins: coins);

      return CourseModel.fromMap(<String, dynamic>{
        ...e,
        'likes': likes,
        'coins': coins,
      });
    });

    courses.addAll(parsed);
  }

  void processForumsToState(List<dynamic>? list) {
    if (list == null || list.isEmpty) return;

    final Iterable<ForumModel> parsed = list.map((dynamic e) {
      final List<String> likes = _extractUserIds(e['likes']);
      final List<String> coins = _extractUserIds(e['coins']);

      profileController.updateInteractionState(e['forumId'].toString(),
          likes: likes, coins: coins);

      return ForumModel.fromMap(<String, dynamic>{
        ...e,
        'likes': likes,
        'coins': coins,
      });
    });

    forums.addAll(parsed);
  }

  void processDonationsoState(List<dynamic>? list) {
    if (list == null || list.isEmpty) return;

    final Iterable<DonationModel> parsed = list.map((dynamic e) {
      final List<String> likes = _extractUserIds(e['likes']);

      profileController.updateInteractionState(e['id'].toString(),
          likes: likes);

      return DonationModel.fromMap(<String, dynamic>{
        ...e,
        'likes': likes,
      });
    });

    donations.addAll(parsed);
  }

  /// Promoted posts
  void processPromotedPostsToState(dynamic post) {
    final List<dynamic> psts = List<dynamic>.from(post ?? <dynamic>[]);
    if (psts.isEmpty) return;

    promotedPosts.addAll(psts.map((dynamic e) {
      final List<String> likes = List<String>.from(_extractUserIds(e['likes']));
      final List<String> reposts =
          List<String>.from(_extractUserIds(e['reposts']));
      final List<String> coins = List<String>.from(_extractUserIds(e['coins']));

      profileController.updateInteractionState(e['postId'].toString(),
          likes: likes, reposts: reposts, coins: coins);

      return PostModel.fromMap(<String, dynamic>{
        ...e,
        'likes': likes,
        'reposts': reposts,
        'coins': coins,
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
      final List<String> likes = List<String>.from(_extractUserIds(e['likes']));
      final List<String> coins = List<String>.from(_extractUserIds(e['coins']));

      profileController.updateInteractionState(e['id'].toString(),
          likes: likes, coins: coins);

      return CourseModel.fromMap(<String, dynamic>{
        ...e,
        'likes': likes,
        'coins': coins,
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
    profileController.toggleLike(postId, userId);

    if (type == 'post') {
      // Non-sponsored posts
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

      // Promoted posts
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

      // Profile posts
      final int profilePostIndex = profileController.posts
          .indexWhere((PostModel element) => element.postId == postId);
      if (profilePostIndex != -1) {
        final bool checkLiked =
            profileController.posts[profilePostIndex].likes!.contains(userId);
        if (checkLiked) {
          profileController.posts[profilePostIndex]
              .likes!
              .removeWhere((String element) => element == userId);
        } else {
          profileController.posts[profilePostIndex].likes!.add(userId);
        }
        profileController.update();
      }

      // Sponsored posts
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
      // Global courses
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
      // Promoted courses
      final int promotedCourseIndex = promotedCourses
          .indexWhere((CourseModel element) => element.id == postId);
      if (promotedCourseIndex != -1) {
        final bool checkLiked =
            promotedCourses[promotedCourseIndex].likes!.contains(userId);
        if (checkLiked) {
          promotedCourses[promotedCourseIndex].likes!.remove(userId);
        } else {
          promotedCourses[promotedCourseIndex].likes!.add(userId);
        }
      }
      // User courses
      final int uCourseIndex =
          usercourses.indexWhere((CourseModel course) => course.id == postId);
      if (uCourseIndex != -1) {
        final bool checkLiked =
            usercourses[uCourseIndex].likes!.contains(userId);
        if (checkLiked) {
          usercourses[uCourseIndex].likes?.remove(userId);
        } else {
          usercourses[uCourseIndex].likes?.add(userId);
        }
      }
    } else if (type == 'forum') {
      // Global forums
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
      // ForumController sync (if active)
      if (Get.isRegistered<ForumController>()) {
        final ForumController forumCtrl = Get.find<ForumController>();
        final int fIndex = forumCtrl.forums
            .indexWhere((ForumModel element) => element.forumId == postId);
        if (fIndex != -1) {
          final bool checkLiked =
              forumCtrl.forums[fIndex].likes!.contains(userId);
          if (checkLiked) {
            forumCtrl.forums[fIndex].likes!
                .removeWhere((String e) => e == userId);
          } else {
            forumCtrl.forums[fIndex].likes!.add(userId);
          }
          forumCtrl.update();
        }
      }
      // BossUpController sync (if active)
      if (Get.isRegistered<BossUpController>()) {
        final BossUpController bossUpCtrl = Get.find<BossUpController>();
        final int fIndex = bossUpCtrl.forums
            .indexWhere((ForumModel element) => element.forumId == postId);
        if (fIndex != -1) {
          final bool checkLiked =
              bossUpCtrl.forums[fIndex].likes!.contains(userId);
          if (checkLiked) {
            bossUpCtrl.forums[fIndex].likes!
                .removeWhere((String e) => e == userId);
          } else {
            bossUpCtrl.forums[fIndex].likes!.add(userId);
          }
          bossUpCtrl.update();
        }
      }
    } else if (type == 'donation') {
      // Global donations
      final int donationIndex =
          donations.indexWhere((DonationModel element) => element.id == postId);
      if (donationIndex != -1) {
        final bool checkLiked = donations[donationIndex].likes!.contains(userId);
        if (checkLiked) {
          donations[donationIndex].likes!.remove(userId);
        } else {
          donations[donationIndex].likes!.add(userId);
        }
      }
      // User donations
      final int uDonationIndex = userdonations
          .indexWhere((DonationModel element) => element.id == postId);
      if (uDonationIndex != -1) {
        final bool checkLiked =
            userdonations[uDonationIndex].likes!.contains(userId);
        if (checkLiked) {
          userdonations[uDonationIndex].likes!.remove(userId);
        } else {
          userdonations[uDonationIndex].likes!.add(userId);
        }
      }
    }

    update();

    // REST API call to persist the like

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
    profileController.toggleCoin(postId, userId);

    if (type == 'post') {
      // Non-sponsored Posts
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

      // Promoted Posts
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

      // Profile posts
      final int profilePostIndex = profileController.posts
          .indexWhere((PostModel element) => element.postId == postId);
      if (profilePostIndex != -1) {
        final bool checkIfCoined =
            profileController.posts[profilePostIndex].coins!.contains(userId);
        if (checkIfCoined) {
          profileController.updateCoinCount(1);
          profileController.posts[profilePostIndex]
              .coins!
              .removeWhere((String element) => element == userId);
        } else {
          profileController.updateCoinCount(-1);
          profileController.posts[profilePostIndex].coins!.add(userId);
        }
        profileController.update();
      }

      // Sponsored posts
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
    } else if (type == 'forum') {
      // Global forums
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
      // ForumController sync
      if (Get.isRegistered<ForumController>()) {
        final ForumController forumCtrl = Get.find<ForumController>();
        final int fIndex = forumCtrl.forums
            .indexWhere((ForumModel element) => element.forumId == postId);
        if (fIndex != -1) {
          final bool checkIfCoined =
              forumCtrl.forums[fIndex].coins!.contains(userId);
          if (checkIfCoined) {
            forumCtrl.forums[fIndex].coins!
                .removeWhere((String e) => e == userId);
          } else {
            forumCtrl.forums[fIndex].coins!.add(userId);
          }
          forumCtrl.update();
        }
      }
      // BossUpController sync
      if (Get.isRegistered<BossUpController>()) {
        final BossUpController bossUpCtrl = Get.find<BossUpController>();
        final int fIndex = bossUpCtrl.forums
            .indexWhere((ForumModel element) => element.forumId == postId);
        if (fIndex != -1) {
          final bool checkIfCoined =
              bossUpCtrl.forums[fIndex].coins!.contains(userId);
          if (checkIfCoined) {
            bossUpCtrl.forums[fIndex].coins!
                .removeWhere((String e) => e == userId);
          } else {
            bossUpCtrl.forums[fIndex].coins!.add(userId);
          }
          bossUpCtrl.update();
        }
      }
    } else if (type == 'course') {
      // Global courses
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
      // Promoted courses
      final int promotedCourseIndex = promotedCourses
          .indexWhere((CourseModel element) => element.id == postId);
      if (promotedCourseIndex != -1) {
        final bool checkIfCoined =
            promotedCourses[promotedCourseIndex].coins!.contains(userId);
        if (checkIfCoined) {
          promotedCourses[promotedCourseIndex].coins!.remove(userId);
        } else {
          promotedCourses[promotedCourseIndex].coins!.add(userId);
        }
      }
      // User courses
      final int uCourseIndex =
          usercourses.indexWhere((CourseModel element) => element.id == postId);
      if (uCourseIndex != -1) {
        final bool checkIfCoined = usercourses[uCourseIndex].coins!.contains(userId);
        if (checkIfCoined) {
          usercourses[uCourseIndex].coins!.remove(userId);
        } else {
          usercourses[uCourseIndex].coins!.add(userId);
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
    profileController.toggleRepost(postId, userId);

    if (type == 'post') {
      // Non-sponsored posts
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

      // Promoted posts
      final int promotedPostIndex = promotedPosts
          .indexWhere((PostModel element) => element.postId == postId);
      if (promotedPostIndex != -1) {
        final bool checkReposted =
            promotedPosts[promotedPostIndex].reposts!.contains(userId);
        if (checkReposted) {
          promotedPosts[promotedPostIndex]
              .reposts!
              .removeWhere((String element) => element == userId);
        } else {
          promotedPosts[promotedPostIndex].reposts!.add(userId);
        }
      }

      // Profile posts
      final int profilePostIndex = profileController.posts
          .indexWhere((PostModel element) => element.postId == postId);
      if (profilePostIndex != -1) {
        final bool checkReposted =
            profileController.posts[profilePostIndex].reposts!.contains(userId);
        if (checkReposted) {
          profileController.posts[profilePostIndex]
              .reposts!
              .removeWhere((String element) => element == userId);
        } else {
          profileController.posts[profilePostIndex].reposts!.add(userId);
        }
        profileController.update();
      }

      // Sponsored posts
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
            debugPrint('true');
          } else {
            debugPrint('false');
          }
        } else {
          profileController.removePost(response.data['postId']);
        }
      } else {
        debugPrint('Repost failed with status code: $response');
      }
    } catch (e) {
      debugPrint('Error during repost API request: $e');
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
      'industry': industries
          .where(
              (Industry element) => element.industryId == newPost['industryId'])
          .first
          .toMap(),
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

    // Interaction state preservation for pagination
    final Map<String, List<String>> currentLikes = <String, List<String>>{};
    final Map<String, List<String>> currentCoins = <String, List<String>>{};
    final Map<String, List<String>> currentReposts = <String, List<String>>{};

    for (final PostModel post in posts) {
      currentLikes[post.postId] = List<String>.from(post.likes ?? <String>[]);
      currentCoins[post.postId] = List<String>.from(post.coins ?? <String>[]);
      currentReposts[post.postId] =
          List<String>.from(post.reposts ?? <String>[]);
    }

    final ApiResponseModel response = await HomeRepository.fetchPosts(
        paginationPage.value, posts[posts.length - 1].timestamp);
    if (response.success) {
      paginationPage(paginationPage.value + 1);
      processPostsAndCoursesData(response.data);

      // Restore interactions for known posts to prevent flickering/revert
      for (final PostModel post in posts) {
        if (currentLikes.containsKey(post.postId)) {
          post.likes?.assignAll(currentLikes[post.postId]!);
        }
        if (currentCoins.containsKey(post.postId)) {
          post.coins?.assignAll(currentCoins[post.postId]!);
        }
        if (currentReposts.containsKey(post.postId)) {
          post.reposts?.assignAll(currentReposts[post.postId]!);
        }
      }
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

  Future<void> removePost(String postId) async {
    mixedPosts.removeWhere((Map<String, dynamic> element) =>
        element['type'] == 'post' && element['id'] == postId);
    posts.removeWhere((PostModel element) => element.postId == postId);

    profileController.removePost(postId);
    update();
  }

  Future<void> removeForum(String postId) async {
    await ApiService.delete(path: 'forum/delete/$postId');
    mixedPosts.removeWhere((Map<String, dynamic> element) =>
        element['type'] == 'forum' && element['id'] == postId);
    forums.removeWhere((ForumModel element) => element.forumId == postId);
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
    HomeRepository.updateViews(post.postId);
    final int postIndex =
        posts.indexWhere((PostModel element) => element.postId == post.postId);
    if (postIndex != -1) {
      // Increment the view count of the post by 1
      posts[postIndex].setViews(post.views! + 1);
      posts.refresh();
    }
  }

  void updateForumViews(ForumModel forum) {
    HomeRepository.updateForumViews(forum.forumId);
    final int forumIndex = forums
        .indexWhere((ForumModel element) => element.forumId == forum.forumId);
    if (forumIndex != -1) {
      forums[forumIndex].setViews(forum.views! + 1);
      forums.refresh();
    }
  }

  /// LOAD POSTS FROM REMOTE SOURCE
  Future<void> loadData() async {
    // 🔥 Check for cached data first
    final dynamic cachedData = sandBox.read('home_data');
    final dynamic cachedPromoted = sandBox.read('promoted_data');

    if (cachedData != null) {
      try {
        _processAllData(cachedData, cachedPromoted);
        loading(false);
        error(false);
        update();
      } catch (e) {
        debugPrint('Error processing cached data: $e');
      }
    } else {
      loading(true);
      error(false);
      update();
    }

    // 🔥 Background fetch (or initial fetch if no cache)
    _fetchAndCache();
  }

  void _processAllData(dynamic data, dynamic promotedData) {
    profileController.processDataToState(
      <dynamic, dynamic>{...data['user'], 'connecteds': data['connecteds']},
      data['interests'],
      data['userRanking'],
    );

    partnerOfTheWeek = data['partnerOfTheWeek'];

    _chatController.processDataToState(
        data['chats'], profileController.myProfile.uid);

    // --- Promoted Data ---
    if (promotedData != null) {
      promotedPosts.clear();
      promotedCourses.clear();
      processPromotedPostsToState(promotedData['promotedPosts']?['rows']);
      processPromotedCoursesToState(promotedData['promotedCourses']?['rows']);
    }

    // --- Posts & Courses ---
    posts.clear();
    courses.clear();
    forums.clear();
    donations.clear();
    processPostsAndCoursesData(data['posts']);

    // --- Profile Setup ---
    if (profileController.myProfile.bio == null) {
      Get.off(() => UpdateProfileScreen(user: profileController.myProfile));
    }

    // --- Courses ---
    usercourses.clear();
    final List<Map<String, dynamic>> courseRows =
        List<Map<String, dynamic>>.from(
            data['courses']?['rows'] ?? <dynamic>[]);
    usercourses.addAll(courseRows.map((Map<String, dynamic> e) {
      final List<String> likes = List<String>.from(_extractUserIds(e['likes']));
      final List<String> coins = List<String>.from(_extractUserIds(e['coins']));
      profileController.updateInteractionState(e['id'].toString(),
          likes: likes, coins: coins);
      return CourseModel.fromMap(<String, dynamic>{
        ...e,
        'likes': likes,
        'coins': coins,
      });
    }));

    // --- Donations ---
    userdonations.clear();
    final List<Map<String, dynamic>> donationRows =
        List<Map<String, dynamic>>.from(
            data['donations']?['rows'] ?? <dynamic>[]);
    userdonations.addAll(donationRows.map((Map<String, dynamic> e) {
      final List<String> likes = List<String>.from(_extractUserIds(e['likes']));
      profileController.updateInteractionState(e['id'].toString(),
          likes: likes);
      return DonationModel.fromMap(<String, dynamic>{
        ...e,
        'likes': likes,
      });
    }));

    // --- Remaining Setup ---
    processBossToState(data['bossOfTheWeek']);
    processMentorToState(data['mentorOfTheWeek']);
    processBackerToState(data['backerOfTheWeek']);
  }

  Future<void> _fetchAndCache() async {
    try {
      final List<ApiResponseModel> results =
          await Future.wait(<Future<ApiResponseModel>>[
        HomeRepository.fetchData(),
        HomeRepository.fetchPromoted(),
      ]);

      final ApiResponseModel response = results[0];
      final ApiResponseModel promoted = results[1];

      // Keep track of current interactions before overwriting state
      final Map<String, List<String>> currentLikes = <String, List<String>>{};
      final Map<String, List<String>> currentCoins = <String, List<String>>{};
      final Map<String, List<String>> currentReposts = <String, List<String>>{};

      for (final PostModel post in posts) {
        currentLikes[post.postId] = List<String>.from(post.likes ?? <String>[]);
        currentCoins[post.postId] = List<String>.from(post.coins ?? <String>[]);
        currentReposts[post.postId] =
            List<String>.from(post.reposts ?? <String>[]);
      }

      if (!response.success) {
        if (response.message == 'send a valid token') {
          await ApiService().logout();
          showAccessTokenDialog();
        }
        if (posts.isEmpty) {
          error(true);
          cError(true);
        }
        loading(false);
        update();
        socket.disconnect();
        return;
      }

      // Store in cache
      await sandBox.write('home_data', response.data);
      if (promoted.success) {
        await sandBox.write('promoted_data', promoted.data);
      }

      // Process new data
      _processAllData(response.data, promoted.success ? promoted.data : null);

      // Restore interactions for posts that are still in the list to prevent flickering/revert
      for (final PostModel post in posts) {
        if (currentLikes.containsKey(post.postId)) {
          post.likes?.assignAll(currentLikes[post.postId]!);
        }
        if (currentCoins.containsKey(post.postId)) {
          post.coins?.assignAll(currentCoins[post.postId]!);
        }
        if (currentReposts.containsKey(post.postId)) {
          post.reposts?.assignAll(currentReposts[post.postId]!);
        }
      }

      socket.emit('handshake', profileController.myProfile.uid);

      if (profileController.myProfile.hasShop) {
        await Get.find<ShopController>().initShop();
      }

      loading(false);
      update();

      addCoinDaily();
      _showMyDialog();

      // Device token logic
      try {
        if (Platform.isIOS) {
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
            FirebaseMessaging.instance.onTokenRefresh.listen((String token) {
              ApiService.post(
                  path: 'users/add-device-token',
                  body: <String, dynamic>{'deviceToken': token});
            });
          }
        } else {
          final String? token = await FirebaseMessaging.instance.getToken();
          if (token != null) {
            ApiService.post(
                path: 'users/add-device-token',
                body: <String, dynamic>{'deviceToken': token});
          }
        }
      } catch (e) {
        debugPrint('Failed to get FCM token: $e');
      }

      await Get.find<ReachController>().loadData(
          profileController.myProfile.uid, profileController.myProfile.uid);
      loadMyRequests();

      // Also refresh marketplace data
      if (Get.isRegistered<MarketController>()) {
        Get.find<MarketController>().initMarket();
      }
    } catch (e, st) {
      debugPrint('Error fetching data: $e\n$st');
      if (posts.isEmpty) {
        error(true);
      }
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
    final ApiResponseModel response =
        await HomeRepository.updateCourseViews(id);

    if (response.success) {
      int index = usercourses.indexWhere((CourseModel c) => c.id == id);
      if (index != -1) {
        usercourses[index] = CourseModel.fromMap(<String, dynamic>{
          ...usercourses[index].toMap(),
          'views': views + 1,
        });
        usercourses.refresh();
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
    if (userData == null) return;
    final UserModel modelizedData = UserModel.fromMap(<dynamic, dynamic>{
      ...userData,
      'connections': <dynamic>[],
      'connecteds': <dynamic>[]
    });
    bossOfTheWeek = modelizedData;
    update();
  }

  void processMentorToState(dynamic userData) {
    if (userData == null) return;
    final UserModel modelizedData = UserModel.fromMap(<dynamic, dynamic>{
      ...userData,
      'connections': <dynamic>[],
      'connecteds': <dynamic>[]
    });
    mentorOfTheWeek = modelizedData;
    update();
  }

  void processBackerToState(dynamic userData) {
    if (userData == null) return;
    final UserModel modelizedData = UserModel.fromMap(<dynamic, dynamic>{
      ...userData,
      'connections': <dynamic>[],
      'connecteds': <dynamic>[]
    });
    backerOfTheWeek = modelizedData;
    update();
  }

  String getStableMetric(String key, String Function() generator) {
    if (!_stableMetrics.containsKey(key)) {
      _stableMetrics[key] = generator();
    }
    return _stableMetrics[key]!;
  }

  void initSocket() {
    socket = io.io(Constants.socketUrl, <String, dynamic>{
      'autoConnect': false,
      'transports': <String>['websocket'],
    });
    socket.connect();
    socket.onConnect((_) {
      debugPrint('Connection established');
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

      debugPrint('reconnected');
    });

    socket.onDisconnect((_) => debugPrint('Connection Disconnection'));
    socket.onConnectError(
        (dynamic err) => debugPrint('Socket connection error: $err'));
    socket.onError((dynamic err) => debugPrint('Socket error: $err'));
  }

  @override
  void onInit() {
    profileController = Get.find<ProfileController>();
    _chatController = Get.find<ChatController>();

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
