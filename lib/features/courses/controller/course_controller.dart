import 'dart:convert';

import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/features/courses/models/course_model.dart';
import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class CourseController extends GetxController {
  RxList<CourseModel> courses = RxList<CourseModel>(<CourseModel>[]);
  RxBool loading = RxBool(false);
  RxBool error = RxBool(false);
  late Industry industry;
  List<dynamic> myHistory = <dynamic>[];
  List<dynamic> myHistoryReceived = <dynamic>[];
  List<dynamic> myHistoryOut = <dynamic>[];
  RxBool hLoading = RxBool(false);
  RxBool hError = RxBool(false);
  RxBool rLoading = RxBool(false);
  RxBool rError = RxBool(false);
  RxList<dynamic> reviews = <dynamic>[].obs;

  @override
  void onInit() {
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
        courses[index] = CourseModel.fromMap(course);
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

  Future<void> updateCourseViews(String id, int views) async {
    Map<String, dynamic> course = <String, dynamic>{'views': views};
    final ApiResponseModel response =
        await ApiService.put(path: 'courses/update-course/$id', body: course);

    if (response.success) {
      int index = courses.indexWhere((CourseModel c) => c.id == id);
      if (index != -1) {
        courses[index] = CourseModel.fromMap(<String, dynamic>{
          ...courses[index].toMap(),
          ...course,
        });
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
        path: '/courses/get-industry-courses/${industry.industryId}');
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
}
