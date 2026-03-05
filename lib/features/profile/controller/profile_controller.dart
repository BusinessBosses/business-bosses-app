import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/courses/models/course_model.dart';
import 'package:business_bosses_v2/features/donations/models/donations_model.dart';
import 'package:business_bosses_v2/features/forum/models/forum_model.dart';
import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:business_bosses_v2/features/home/repository/home_repository.dart';
import 'package:business_bosses_v2/features/posts/models/post_model.dart';
import 'package:business_bosses_v2/features/profile/repository/profile_repository.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/models/comment_model.dart';
import '../../../utils/constants/constants.dart';

/// PROFILE CONTROLLER
class ProfileController extends GetxController {
  /// MODELIZED PROFILE DATA
  UserModel myProfile = UserModel();
  List<PostModel> posts = <PostModel>[];
  RxBool isLoading = RxBool(false);
  dynamic impact;
  RxString currentMatchType = ''.obs;
  final GetStorage sandBox = GetStorage();

  // Central interaction state
  final RxMap<String, List<String>> likesMap = <String, List<String>>{}.obs;
  final RxMap<String, List<String>> coinsMap = <String, List<String>>{}.obs;
  final RxMap<String, List<String>> repostsMap = <String, List<String>>{}.obs;

  void updateInteractionState(String id,
      {List<String>? likes, List<String>? coins, List<String>? reposts}) {
    if (likes != null) likesMap[id] = List<String>.from(likes);
    if (coins != null) coinsMap[id] = List<String>.from(coins);
    if (reposts != null) repostsMap[id] = List<String>.from(reposts);
  }

  List<String> getLikes(String id, List<String>? fallback) {
    return likesMap[id] ?? fallback ?? <String>[];
  }

  List<String> getCoins(String id, List<String>? fallback) {
    return coinsMap[id] ?? fallback ?? <String>[];
  }

  List<String> getReposts(String id, List<String>? fallback) {
    return repostsMap[id] ?? fallback ?? <String>[];
  }

  void toggleLike(String id, String userId) {
    final List<String> current = List<String>.from(likesMap[id] ?? <String>[]);
    if (current.contains(userId)) {
      current.remove(userId);
    } else {
      current.add(userId);
    }
    likesMap[id] = current;
  }

  void toggleCoin(String id, String userId) {
    final List<String> current = List<String>.from(coinsMap[id] ?? <String>[]);
    if (current.contains(userId)) {
      current.remove(userId);
    } else {
      current.add(userId);
    }
    coinsMap[id] = current;
  }

  void toggleRepost(String id, String userId) {
    final List<String> current = List<String>.from(repostsMap[id] ?? <String>[]);
    if (current.contains(userId)) {
      current.remove(userId);
    } else {
      current.add(userId);
    }
    repostsMap[id] = current;
  }

  ///MODELIZE RAW DATA AND PUSH TO STATE
  void processDataToState(
      dynamic userData, List<dynamic> interests, dynamic userRanking) {
    final UserModel modelizedData = UserModel.fromMap(<dynamic, dynamic>{
      ...userData,
      'connections':
          userData['connections'].map((dynamic mp) => mp['connect']).toList(),
      'connecteds': userData['connecteds'],
      'interests': interests,
      'weeklyRank': userRanking['rankWeekly'],
      'monthlyRank': userRanking['rankMonthly']
    });
    myProfile = modelizedData;
    currentMatchType.value = myProfile.matchType ?? '';
    update();
  }

  void toggleInterests(Industry industry) {
    final int index = myProfile.interests!.indexWhere(
        (Industry element) => element.industryId == industry.industryId);
    if (index != -1) {
      myProfile.interests!.removeAt(index);
    } else {
      myProfile.interests!.add(industry);
    }
    update();
  }

  void updateCoinCount(int num) {
    myProfile = UserModel.fromMap(<dynamic, dynamic>{
      ...myProfile.toMap(),
      'coinscount': myProfile.coinscount! + num
    });
    update();
  }

  /// UPDATE USER DATA
  void updateProfile(Map<String, dynamic> newData) {
    myProfile = UserModel.fromMap(newData);
    currentMatchType.value = myProfile.matchType ?? '';
    update();
  }

  void updatePostViews(PostModel post, int views) {
    HomeRepository.updateViews(post.postId);
  }

  void updateConnections(String uid) {
    final bool checkIfConnected = myProfile.connecteds == null
        ? false
        : myProfile.connecteds!.contains(uid);
    final List<String>? newConnecteds = checkIfConnected
        ? myProfile.connecteds
            ?.where((String element) => element != uid)
            .toList()
        : myProfile.connecteds == null
            ? <String>[uid]
            : <String>[...myProfile.connecteds!, uid];
    myProfile = UserModel.fromMap(<dynamic, dynamic>{
      ...myProfile.toMap(),
      'connecteds': newConnecteds,
      'connectedCount': checkIfConnected
          ? myProfile.connectedCount! - 1
          : myProfile.connectedCount! + 1
    });

    update();
  }

  Future<Map<String, dynamic>> loadData(String userId) async {
    List<PostModel> posts = <PostModel>[];
    List<CourseModel> courses = <CourseModel>[];
    List<DonationModel> donations = <DonationModel>[];
    List<ForumModel> forums = <ForumModel>[];
    final List<ApiResponseModel> results =
        await Future.wait(<Future<ApiResponseModel>>[
      ProfileRepository.fetchData(0, 50, userId), // Profile API
      ApiService.get(path: 'impact/user/$userId'), // Impact API
    ]);

    final ApiResponseModel response = results[0];
    final ApiResponseModel impactResponse = results[1];

    if (response.success) {
      // 🔥 Update cache
      await sandBox.write('profile_data_$userId', response.data);

      if (impactResponse.success) {
        impact = impactResponse.data; // assign impact data
        await sandBox.write('impact_data_$userId', impactResponse.data);
      } else {
        impact = <dynamic, dynamic>{}; // fallback if error
      }
      final List<dynamic> psts = response.data['posts']['rows'];
      for (int i = 0; i < psts.length; i++) {
        final List<String> likes = List<String>.from(psts[i]['likes']
            .map((dynamic like) => like['userId'].toString()));
        final List<String> reposts = List<String>.from(psts[i]['reposts']
                ?.map((dynamic repost) => repost['userId'].toString()) ??
            <dynamic>[]);
        final List<String> coins = List<String>.from(psts[i]['coins']
            .map((dynamic coin) => coin['userId'].toString()));

        updateInteractionState(psts[i]['postId'].toString(),
            likes: likes, reposts: reposts, coins: coins);

        posts.add(PostModel.fromMap(<String, dynamic>{
          ...psts[i],
          'likes': likes,
          'reposts': reposts,
          'coins': coins,
        }));
      }

      /// ---------------- COURSES ----------------
      final List<dynamic> crs =
          response.data['courses']?['rows'] ?? <dynamic>[];
      for (final dynamic c in crs) {
        final List<String> likes = List<String>.from((c['likes'] as List<dynamic>?)
                ?.map((dynamic like) => like['userId'].toString()) ??
            <dynamic>[]);
        final List<String> coins = List<String>.from((c['coins'] as List<dynamic>?)
                ?.map((dynamic coin) => coin['userId'].toString()) ??
            <dynamic>[]);

        updateInteractionState(c['id'].toString(), likes: likes, coins: coins);

        courses.add(CourseModel.fromMap(<String, dynamic>{...c}));
      }

      /// ---------------- DONATIONS ----------------
      final List<dynamic> dns =
          response.data['donations']?['rows'] ?? <dynamic>[];
      for (final dynamic d in dns) {
        final List<String> likes = List<String>.from(d['likes']
            .map((dynamic like) => like['userId'].toString()));

        updateInteractionState(d['id'].toString(), likes: likes);

        donations.add(DonationModel.fromMap(<String, dynamic>{
          ...d,
          'likes': likes,
        }));
      }

      /// ---------------- FORUMS ----------------
      final List<dynamic> frms =
          response.data['forums']?['rows'] ?? <dynamic>[];
      for (final dynamic f in frms) {
        final List<String> likes = List<String>.from(f['likes']
            .map((dynamic like) => like['userId'].toString()));
        final List<String> coins = List<String>.from(f['coins']
            .map((dynamic coin) => coin['userId'].toString()));

        updateInteractionState(f['forumId'].toString(),
            likes: likes, coins: coins);

        forums.add(ForumModel.fromMap(<String, dynamic>{
          ...f,
          'likes': likes,
          'coins': coins,
        }));
      }

      return <String, dynamic>{
        'posts': posts,
        'courses': courses,
        'donations': donations,
        'forums': forums,
        'user': <dynamic, dynamic>{
          ...response.data['user']['data'],
          'connections': response.data['user']['data']['connections']
              .map((dynamic mp) => mp['connect'])
              .toList()
        },
        'industries': response.data['industries']
      };
    } else {
      return <String, dynamic>{
        'posts': <PostModel>[],
        'courses': <CourseModel>[],
        'donations': <DonationModel>[],
        'forums': <ForumModel>[],
        'user': <String, dynamic>{},
        'industries': <Industry>[]
      };
    }
  }

  static Future<Map<String, dynamic>> loadrepostsData(String userId) async {
    List<PostModel> posts = <PostModel>[];
    final ApiResponseModel response =
        // ProfileRepos
        await ProfileRepository.fetchData(0, 50, userId);
    if (response.success) {
      final List<dynamic> psts = response.data['posts']['rows'];
      for (int i = 0; i < psts.length; i++) {
        posts.add(PostModel.fromMap(<String, dynamic>{
          ...psts[i],
          'likes': List<String>.from(psts[i]['likes']
              .map((dynamic like) => like['userId'].toString())),
          'reposts': List<String>.from(psts[i]['reposts']
                  ?.map((dynamic repost) => repost['userId'].toString()) ??
              <dynamic>[]),
          'coins': List<String>.from(psts[i]['coins']
              .map((dynamic coin) => coin['userId'].toString()))
        }));
      }

      return <String, dynamic>{
        'posts': posts,
        'user': <dynamic, dynamic>{
          ...response.data['user']['data'],
          'connections': response.data['user']['data']['connections']
              .map((dynamic mp) => mp['connect'])
              .toList()
        },
        'industries': response.data['industries']
      };
    } else {
      return <String, dynamic>{
        'posts': <PostModel>[],
        'user': <dynamic, dynamic>{
          ...response.data['user']['data'],
          'connections': response.data['user']['data']['connections']
              .map((dynamic mp) => mp['connect'])
              .toList()
        },
        'industries': response.data['industries']
      };
    }
  }

  /// ADD NEW POST TO STATE
  void addNewPost(
    Map<String, dynamic> newPost,
  ) async {
    PostModel modelizedNewPost = PostModel.fromMap(<String, dynamic>{
      ...newPost,
      'coins': <String>[],
      'likes': <String>[],
      'comments': <CommentModel>[],
      'user': <String, String?>{
        'username': myProfile.username,
        'email': myProfile.email,
        'uid': myProfile.uid,
        'name': myProfile.name,
      }
    });
    posts.insert(0, modelizedNewPost);
    update();
  }

  //ADD NEW REPOST TO PERSON PROFILE
  void addRePost(
    Map<String, dynamic> newPost,
  ) async {
    PostModel modelizedNewPost = PostModel.fromMap(<String, dynamic>{
      ...newPost,
      'coins': <String>[],
      'likes': <String>[],
      'comments': <CommentModel>[],
    });
    posts.insert(0, modelizedNewPost);
    update();
  }

  void removePost(String postId) {
    final int postIndex =
        posts.indexWhere((PostModel element) => element.postId == postId);
    if (postIndex != -1) {
      posts.removeAt(postIndex);
      update();
    }
  }

  void updatePost(PostModel post) {
    final int postIndex =
        posts.indexWhere((PostModel element) => element.postId == post.postId);
    if (postIndex != -1) {
      posts[postIndex] = post;
      update();
    }
  }

  Future<void> fetchData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString(Constants.USER_ID);
    if (userId == null) return;

    // 🔥 Check for cached data first
    final dynamic cachedProfile = sandBox.read('profile_data_$userId');
    final dynamic cachedImpact = sandBox.read('impact_data_$userId');

    if (cachedProfile != null) {
      _processCachedProfile(cachedProfile);
      if (cachedImpact != null) {
        impact = cachedImpact;
      }
      isLoading(false);
      update();
    } else {
      isLoading(true);
      update();
    }

    // 🔥 Background fetch
    try {
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

      final Map<String, dynamic> res = await loadData(userId);
      posts = res['posts'] ?? <PostModel>[];

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
    } catch (e) {
      debugPrint('Error fetching profile data: $e');
    } finally {
      isLoading(false);
      update();
    }
  }

  void _processCachedProfile(dynamic data) {
    posts.clear();
    final List<dynamic> psts = data['posts']?['rows'] ?? <dynamic>[];
    for (int i = 0; i < psts.length; i++) {
      posts.add(PostModel.fromMap(<String, dynamic>{
        ...psts[i],
        'likes': List<String>.from((psts[i]['likes'] as List<dynamic>)
            .map((dynamic like) => like['userId'].toString())),
        'reposts': List<String>.from((psts[i]['reposts'] as List<dynamic>?)
                ?.map((dynamic repost) => repost['userId'].toString()) ??
            <dynamic>[]),
        'coins': List<String>.from((psts[i]['coins'] as List<dynamic>)
            .map((dynamic coin) => coin['userId'].toString()))
      }));
    }
  }

  @override
  void onInit() {
    fetchData();
    currentMatchType.value = myProfile.matchType ?? '';
    super.onInit();
  }
}
