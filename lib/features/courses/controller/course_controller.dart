import 'dart:convert';

import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/models/comment_model.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/common/widgets/gallery_screen.dart';
import 'package:business_bosses_v2/features/courses/models/course_model.dart';
import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:business_bosses_v2/utils/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class CourseController extends GetxController {
  RxList<CourseModel> courses = RxList<CourseModel>(<CourseModel>[]);
  final HomeController homeController = Get.find();
  RxBool loading = RxBool(false);
  RxBool error = RxBool(false);
  RxBool courseLoading = RxBool(false);
  RxBool courseError = RxBool(false);
  late Industry industry;
  List<dynamic> myHistory = <dynamic>[];
  List<dynamic> myHistoryReceived = <dynamic>[];
  List<dynamic> myHistoryOut = <dynamic>[];
  RxBool hLoading = RxBool(true);
  RxBool hError = RxBool(false);
  RxBool courseAccess = RxBool(false);
  RxBool rLoading = RxBool(true);
  RxBool rError = RxBool(false);
  RxList<dynamic> reviews = <dynamic>[].obs;
  RxList<CourseModel> usercourses = <CourseModel>[].obs;
  final ProfileController profileController = Get.find();
  late IO.Socket socket;
  late List<String> connecteds =
      profileController.myProfile.connecteds ?? <String>[];
  List<UserModel> searchedUsers = <UserModel>[];
  List<CourseModel> searchedPosts = <CourseModel>[];
  RxBool loadingSearch = RxBool(false);
  RxBool loadingPostsSearch = RxBool(false);
  RxList<String> userIds = <String>[].obs;
  RxBool isUserSearch = RxBool(false);
  RxBool isPostSearch = RxBool(false);
  RxList<UserModel> usersMembers = <UserModel>[].obs;
  late ImagePicker _picker;

  @override
  void onInit() async {
    initSocket();
    super.onInit();
    if (Get.arguments == null) {
      Get.back();
      return;
    } else {
      if (Get.arguments.runtimeType == Industry) {
        industry = Get.arguments;
        initCourses();
      }
    }
  }

  void clearUserSearch() {
    isUserSearch(false);
    update();
  }

  void clearPostSearch() {
    isPostSearch(false);
    update();
  }

  /// PICK IMAGE FROM DEVICE GALLERY
  Future<void> onPickImage(GalleryType type, {bool isUpdating = false}) async {
    // print(" $updatingImageFileList $isUpdating");

    try {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {}

      update();
    } catch (e) {
      // handle error
    }
  }

  Future<void> createCourse(Map<String, dynamic> course) async {
    loading(true);
    update();
    final ApiResponseModel response =
        await ApiService.post(path: 'courses/create-course', body: course);

    if (response.success) {
      courses.insert(
          0,
          CourseModel.fromMap(<String, dynamic>{
            ...course,
            'id': response.data['id'],
            'coins': <String>[],
            'likes': <String>[],
            'comments': <CommentModel>[],
            'user': profileController.myProfile.toMap()
          }));
      homeController.usercourses.insert(
          0,
          CourseModel.fromMap(<String, dynamic>{
            ...course,
            'id': response.data['id'],
            'coins': <String>[],
            'likes': <String>[],
            'comments': <CommentModel>[],
            'user': profileController.myProfile.toMap()
          }));
      Get.back();
      Get.snackbar('Success', 'Course created successfully');
    }
    loading(false);
    update();
  }

  Future<void> updateCourse(Map<String, dynamic> course, String id) async {
    final ApiResponseModel response =
        await ApiService.put(path: 'courses/update-course/$id', body: course);

    if (response.success) {
      int index = courses.indexWhere((CourseModel c) => c.id == id);
      if (index != -1) {
        courses[index] = CourseModel.fromMap(<String, dynamic>{
          ...response.data,
          'comments': <CommentModel>[],
          'user': profileController.myProfile.toMap()
        });
        int homeIndex = homeController.usercourses
            .indexWhere((CourseModel c) => c.id == id);
        if (homeIndex != -1) {
          homeController.usercourses[homeIndex] =
              CourseModel.fromMap(<String, dynamic>{
            ...response.data,
            'comments': <CommentModel>[],
            'user': profileController.myProfile.toMap()
          });
        }
        Get.back();
        showSnackbar(message: 'Course updated successfully', title: 'Success');
      } else {
        showSnackbar(message: 'Course not found', title: 'Error', error: true);
      }
      update();
    }
  }

  Future<void> updateCourseViews(String id, int views) async {
    Map<String, dynamic> course = <String, dynamic>{'views': views};
    final ApiResponseModel response =
        await ApiService.put(path: 'courses/update-course/$id', body: course);

    if (response.success) {
      int index = courses.indexWhere((CourseModel c) => c.id == id);
      if (index != -1) {
        courses[index].setViews();
      }
      update();
    }
  }

  Future<void> getReviews(String id) async {
    rLoading(true);
    rError(false);
    update();
    reviews.clear();
    final ApiResponseModel response =
        await ApiService.get(path: 'course-ratings/course/$id');
    if (response.success) {
      for (int i = 0; i < response.data.length; i++) {
        if (response.data[i]['rater'] != null &&
            response.data[i]['author'] != null) {
          reviews.add(response.data[i]);
        }
      }
    } else {
      rError(true);
    }
    rLoading(false);
    update();
  }

  Future<void> initCourses() async {
    loading(true);
    error(false);
    update();

    final ApiResponseModel response = await ApiService.get(
        path: '/courses/get-industry-courses/${industry.industryId}?size=1000');
    if (response.success) {
      for (int i = 0; i < response.data['rows'].length; i++) {
        if (response.data['rows'][i]['user'] != null) {
          courses.add(CourseModel.fromMap(response.data['rows'][i]));
        }
      }
    } else {
      error(true);
    }
    loading(false);
    update();
  }

  Future<String?> uploadFile(String filePath) async {
    try {
      dynamic uri = Uri.parse('https://businessbosses.com.ng/upload_files.php');
      dynamic request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('file', filePath));
      dynamic response = await request.send();
      if (response.statusCode == 200) {
        // Handle success
        dynamic jsonResponse = await http.Response.fromStream(response);
        Map<String, dynamic> data = json.decode(jsonResponse.body);
        if (data.containsKey('file_name')) {
          return data['file_name'];
        } else {
          return null;
        }
      } else {
        // Handle error
      }
    } catch (e) {
      // Handle exception
    }
    return null;
  }

  /// delete selected course
  void onDeleteCourse(String courseId) async {
    try {
      final ApiResponseModel response = await ApiService.delete(
        path: 'courses/delete-course/$courseId',
      );

      if (response.success) {
        showSnackbar(message: 'Course deleted successfully!', title: 'Success');
        courses.removeWhere((CourseModel course) => course.id == courseId);
        int homeIndex = homeController.usercourses
            .indexWhere((CourseModel c) => c.id == courseId);
        if (homeIndex >= -1) {
          homeController.usercourses
              .removeWhere((CourseModel course) => course.id == courseId);
        }
        update();
        return;
      } else {
        showSnackbar(
            message: 'Failed to delete course.', title: 'O0PS!', error: true);
        return;
      }
    } catch (e) {
      rethrow;
      // showSnackbar(
      //     message: 'Error deleting post.', title: 'O0PS!', error: true);
    }
  }

  Future<void> payforcourse(String courseid, num amount) async {
    final ApiResponseModel response = await ApiService.post(
        path: '/course-transactions',
        body: <String, dynamic>{
          'userId': profileController.myProfile.uid,
          'courseId': courseid,
          'date': DateTime.now().millisecondsSinceEpoch
        });

    if (response.success) {
      profileController.myProfile
          .incrementCoinsCount(-int.parse(amount.toString()));
      Get.snackbar('Success', 'Course purchased successfully');
      courseAccess(true);
    } else {
      showSnackbar(
          message: 'An error occurred. Please try again',
          title: 'O0PS!',
          error: true);
    }
    update();
  }

  Future<void> fetchuserCourses(String userId) async {
    try {
      loading(true); // Set loading to true before fetching data

      ApiResponseModel response =
          await ApiService.get(path: 'courses/get-user-courses/$userId');

      if (response.success) {
        usercourses.clear();
        if (response.data['rows'] != null) {
          // Check if response.data['rows'] is not null
          for (int i = 0; i < response.data['rows'].length; i++) {
            CourseModel usercourse = CourseModel.fromMap(<String, dynamic>{
              ...response.data['rows'][i],
              // 'likes': response.data['rows'][i]['likes']
              //     .map((dynamic like) => like['userId'].toString())
              //     .toList(),
            });

            usercourses.add(usercourse);
          }
        }
      } else {
        error(true);
      }
    } catch (e) {
      error(true); // Set error to true if there's an error
    } finally {
      loading(false); // Set loading back to false after fetching data
    }
  }

  Future<void> searchUsers(String query) async {
    loadingSearch(true);
    update();

    searchedUsers.clear();

    for (var user in usersMembers) {
      if (user.username.toLowerCase().contains(query.toLowerCase()) ||
          user.name!.toLowerCase().contains(query.toLowerCase())) {
        searchedUsers.add(user);
      }
    }
    loadingSearch(false);
    update();
  }

  Future<void> searchPosts(
    String query,
  ) async {
    loadingPostsSearch(true);
    update();

    searchedPosts.clear();

    // Assuming products is the list of already fetched products
    for (var row in courses) {
      if (row.description!.toLowerCase().contains(query.toLowerCase()) ||
          row.title!.toLowerCase().contains(query.toLowerCase())) {
        searchedPosts.add(row);
      }
    }

    loadingPostsSearch(false);
    update();
  }

  void connectToUser(UserModel user) async {
    final int checkConnected =
        connecteds.indexWhere((String element) => element == user.uid);
    profileController.updateConnections(user.uid);
    update();
    if (isUserSearch.value) {
      final int checkConnectedSearch =
          connecteds.indexWhere((String element) => element == user.uid);
      if (checkConnectedSearch == -1) {
        connecteds.add(user.uid);
      } else {
        connecteds.removeAt(checkConnectedSearch);
      }
    }
    if (checkConnected == -1) {
      connecteds.add(user.uid);
      await connect(user.uid);
    } else {
      connecteds.removeAt(checkConnected);
      await disconnect(user.uid);
    }

    update();
  }

  Future<void> connect(String userId) async {
    await ApiService.post(path: '/connection/connect', body: <String, dynamic>{
      'userId': profileController.myProfile.uid,
      'connectedId': userId,
      'timestamp': DateTime.now().millisecondsSinceEpoch
    });
  }

  Future<void> disconnect(String userId) async {
    await ApiService.post(
        path: '/connection/disconnect',
        body: <String, dynamic>{
          'userId': profileController.myProfile.uid,
          'connectedId': userId,
          'timestamp': DateTime.now().millisecondsSinceEpoch
        });
  }

  Future<void> initHistory(UserModel user) async {
    hLoading(true);
    hError(false);
    myHistory.clear();
    final ApiResponseModel response = await ApiService.get(
        path: 'course-transactions/user/${user.uid}?size=10000');
    if (response.success) {
      for (int i = 0; i < response.data['rows'].length; i++) {
        myHistory.add(response.data['rows'][i]);
        if (response.data['rows'][i]['course']['userId'] == user.uid) {
          myHistoryReceived.add(response.data['rows'][i]);
        } else {
          myHistoryOut.add(response.data['rows'][i]);
        }
      }
    } else {
      hError(true);
    }
    hLoading(false);
    update();
  }

  /// LIKE AND UNLIKE FUNCTION
  void postLike(String userId, String postId, String receiverUid) {
    final int courseIndex =
        courses.indexWhere((CourseModel course) => course.id == postId);
    if (courseIndex != -1) {
      final bool checkLiked = courses[courseIndex].likes!.contains(userId);
      if (checkLiked) {
        courses[courseIndex].likes?.remove(userId);
      } else {
        courses[courseIndex].likes?.add(userId);
      }
      update();
    }

    final int homeCourseIndex = homeController.usercourses
        .indexWhere((CourseModel course) => course.id == postId);
    if (homeCourseIndex != -1) {
      final bool checkLiked =
          homeController.usercourses[homeCourseIndex].likes!.contains(userId);
      if (checkLiked) {
        homeController.usercourses[homeCourseIndex].likes?.remove(userId);
      } else {
        homeController.usercourses[homeCourseIndex].likes?.add(userId);
      }
      update();
    }

    if (profileController.myProfile.uid != receiverUid) {
      socket.emit('like', <String, dynamic>{
        'postId': postId,
        'userId': userId,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'receiverUid': receiverUid,
      });
    } else {
      socket.emit('like', <String, dynamic>{
        'postId': postId,
        'userId': userId,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }

  /// COIN AND UNCOIN FUNCTION
  void postCoin(String userId, String postId,
      ProfileController profileController, String receiverUid) {
    final int courseIndex =
        courses.indexWhere((CourseModel course) => course.id == postId);
    if (courseIndex != -1) {
      final bool checkCoin = courses[courseIndex].coins!.contains(userId);
      if (checkCoin) {
        courses[courseIndex].coins?.remove(userId);
      } else {
        courses[courseIndex].coins?.add(userId);
      }
      update();
    }
    update();
    if (profileController.myProfile.uid != receiverUid) {
      socket.emit('coin', <String, dynamic>{
        'postId': postId,
        'userId': userId,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'receiverUid': receiverUid,
      });
    } else {
      socket.emit('coin', <String, dynamic>{
        'postId': postId,
        'userId': userId,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }

  Future<void> checkUserAccess(CourseModel course) async {
    courseLoading(true);

    final ApiResponseModel response = await ApiService.get(
      path:
          'course-transactions/user-access/${profileController.myProfile.uid}/${course.id}',
    );
    if (response.success) {
      courseAccess(true);
    } else {
      courseAccess(false);
    }
    courseLoading(false);
    update();
  }

  void initSocket() {
    socket = IO.io(Constants.socketUrl, <String, dynamic>{
      'autoConnect': false,
      'transports': <String>['websocket'],
    });
    socket.connect();
    socket.onConnect((_) {
      print('Connection established');
    });

    socket.on('handshake', (data) {
      // print(data);
    });

    socket.on('new-notification', (data) {
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
    socket.onConnectError((err) => print(err));
    socket.onError((err) => print(err));
  }
}
