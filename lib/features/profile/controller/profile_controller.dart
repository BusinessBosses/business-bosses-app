import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/courses/models/course_model.dart';
import 'package:business_bosses_v2/features/forum/models/forum_model.dart';
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
  UserModel? bossOfTheWeek = UserModel();
  List<PostModel> posts = <PostModel>[];
  RxBool isLoading = RxBool(false);
  RxList<CourseModel> usercourses = <CourseModel>[].obs;
  RxBool dLoading = RxBool(false);
  RxBool cLoading = RxBool(false);
  RxBool dError = RxBool(false);
  RxBool cError = RxBool(false);
  RxList<ForumModel> userresources = <ForumModel>[].obs;

  ///MODELIZE RAW DATA AND PUSH TO STATE
  void processDataToState(
      dynamic userData, List interests, dynamic userRanking) {
    final UserModel modelizedData = UserModel.fromMap(<dynamic, dynamic>{
      ...userData,
      'connections':
          userData['connections'].map((mp) => mp['connect']).toList(),
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

  ///MODELIZE RAW DATA AND PUSH TO STATE
  void processBossToState(dynamic userData) {
    final UserModel modelizedData = UserModel.fromMap(<dynamic, dynamic>{
      ...userData,
      'connections': userData['connections'].map((e) => e['connect']).toList(),
      'connecteds': userData['connecteds'].map((e) => e['userId']).toList()
    });
    bossOfTheWeek = modelizedData;
    // print(userData);
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

  /// LOAD BOSS TO STATE
  Future<void> loadBoss() async {
    final ApiResponseModel response = await ProfileRepository.fetchBoss();
    if (response.data != 'no record found') {
      processBossToState(response.data);
      // print(response.data);
    } else {
      bossOfTheWeek = null;
    }
  }

  static Future<Map<String, dynamic>> loadData(String userId) async {
    List<PostModel> posts = <PostModel>[];
    final ApiResponseModel response =
        // ProfileRepos
        await ProfileRepository.fetchData(0, 50, userId);
    if (response.success) {
      final List psts = response.data['posts']['rows'];
      for (int i = 0; i < psts.length; i++) {
        posts.add(PostModel.fromMap(<String, dynamic>{
          ...psts[i],
          'likes': psts[i]['likes']
              .map((like) => like['userId'].toString())
              .toList(),
          'reposts': psts[i]['reposts']
              ?.map((repost) => repost['userId'].toString())
              .toList(),
          'coins':
              psts[i]['coins'].map((coin) => coin['userId'].toString()).toList()
        }));
      }

      return <String, dynamic>{
        'posts': posts,
        'user': <dynamic, dynamic>{
          ...response.data['user']['data'],
          'connections': response.data['user']['data']['connections']
              .map((mp) => mp['connect'])
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
              .map((mp) => mp['connect'])
              .toList()
        },
        'industries': response.data['industries']
      };
    }
  }

  static Future<Map<String, dynamic>> loadrepostsData(String userId) async {
    List<PostModel> posts = <PostModel>[];
    final ApiResponseModel response =
        // ProfileRepos
        await ProfileRepository.fetchData(0, 50, userId);
    if (response.success) {
      final List psts = response.data['posts']['rows'];
      for (int i = 0; i < psts.length; i++) {
        posts.add(PostModel.fromMap(<String, dynamic>{
          ...psts[i],
          'likes': psts[i]['likes']
              .map((like) => like['userId'].toString())
              .toList(),
          'reposts': psts[i]['reposts']
              ?.map((repost) => repost['userId'].toString())
              .toList(),
          'coins':
              psts[i]['coins'].map((coin) => coin['userId'].toString()).toList()
        }));
      }

      return <String, dynamic>{
        'posts': posts,
        'user': <dynamic, dynamic>{
          ...response.data['user']['data'],
          'connections': response.data['user']['data']['connections']
              .map((mp) => mp['connect'])
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
              .map((mp) => mp['connect'])
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
        await ProfileController.loadData(prefs.getString(Constants.USER_ID)!);

    posts = res['posts'];
    isLoading(false);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    fetchData();
    loadBoss();
    super.onInit();
  }

  Future<void> fetchuserCourses(String userId) async {
    try {
      cLoading(true); // Set loading to true before fetching data

      ApiResponseModel response =
          await ApiService.get(path: 'courses/get-user-courses/$userId');

      if (response.success) {
        usercourses.clear();
        if (response.data['Courses']['rows'] != null) {
          // Check if response.data['rows'] is not null
          for (int i = 0; i < response.data['Courses']['rows'].length; i++) {
            CourseModel usercourse = CourseModel.fromMap(<String, dynamic>{
              ...response.data['Courses']['rows'][i],
            });
            usercourses.add(usercourse);
          }
        }
      } else {
        cError(true);
      }
    } catch (e) {
      cError(true); // Set error to true if there's an error
    } finally {
      cLoading(false); // Set loading back to false after fetching data
    }
    update();
  }

  Future<void> fetchuserResources(String userId) async {
    try {
      dLoading(true); // Set loading to true before fetching data

      ApiResponseModel response = await ApiService.get(
          path: 'forum/get-user-forum/$userId?page=0&size=20');

      if (response.success) {
        userresources.clear();
        for (int i = 0; i < response.data['rows'].length; i++) {
          if (response.data['rows'] != null) {
            ForumModel userresource = ForumModel.fromMap(<String, dynamic>{
              ...response.data['rows'][i],
              'likes': response.data['rows'][i]['likes']
                  .map((dynamic like) => like['userId'].toString())
                  .toList(),
            });
            userresources.add(userresource);
          }
        }
      } else {
        dError(true); // Set error to true if there's an error
      }
    } catch (e) {
      dError(true); // Set error to true if there's an error
    } finally {
      dLoading(false); // Set loading back to false after fetching data
    }
    update();
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
}
