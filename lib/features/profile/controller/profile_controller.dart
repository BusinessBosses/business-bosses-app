import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:business_bosses_v2/features/home/repository/home_repository.dart';
import 'package:business_bosses_v2/features/posts/models/post_model.dart';
import 'package:business_bosses_v2/features/profile/repository/profile_repository.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:get/get.dart';
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
    update();
  }

  void updatePostViews(PostModel post, int views) {
    HomeRepository.updateViews(post.postId, views);
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
    final List<ApiResponseModel> results =
        await Future.wait(<Future<ApiResponseModel>>[
      ProfileRepository.fetchData(0, 50, userId), // Profile API
      ApiService.get(path: 'impact/user/$userId'), // Impact API
    ]);

    final ApiResponseModel response = results[0];
    final ApiResponseModel impactResponse = results[1];

    if (response.success) {
      if (impactResponse.success) {
        impact = impactResponse.data; // assign impact data
      } else {
        impact = <dynamic, dynamic>{}; // fallback if error
      }

      final List<dynamic> psts = response.data['posts']['rows'];
      for (int i = 0; i < psts.length; i++) {
        posts.add(PostModel.fromMap(<String, dynamic>{
          ...psts[i],
          'likes': psts[i]['likes']
              .map((dynamic like) => like['userId'].toString())
              .toList(),
          'reposts': psts[i]['reposts']
              ?.map((dynamic repost) => repost['userId'].toString())
              .toList(),
          'coins': psts[i]['coins']
              .map((dynamic coin) => coin['userId'].toString())
              .toList()
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
          'likes': psts[i]['likes']
              .map((dynamic like) => like['userId'].toString())
              .toList(),
          'reposts': psts[i]['reposts']
              ?.map((dynamic repost) => repost['userId'].toString())
              .toList(),
          'coins': psts[i]['coins']
              .map((dynamic coin) => coin['userId'].toString())
              .toList()
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
    isLoading(true);
    update();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> res =
        await loadData(prefs.getString(Constants.USER_ID)!);

    posts = res['posts'] ?? <PostModel>[];
    isLoading(false);
  }

  @override
  void onInit() {
    fetchData();
    currentMatchType.value = myProfile.matchType ?? '';
    super.onInit();
  }
}
