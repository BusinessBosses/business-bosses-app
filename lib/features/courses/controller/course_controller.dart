import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/courses/models/course_model.dart';
import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
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

  @override
  void onInit() {
    // TODO: implement onInit
    if (Get.arguments == null) {
      Get.back();
      return;
    } else {
      if (Get.arguments.runtimeType == Industry) {
        industry = Get.arguments;
        initCourses();
      }
    }

    super.onInit();
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
      int index = courses.indexWhere((c) => c.id == id);
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
      int index = courses.indexWhere((c) => c.id == id);
      if (index != -1) {
        courses[index] = CourseModel.fromMap({
          ...courses[index].toMap(),
          ...course,
        });
      }
      update();
    }
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

  Future<void> uploadFile(String filePath) async {
    try {
      dynamic uri = Uri.parse('https://businessbosses.com.ng/upload_files.php');
      dynamic request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('file', filePath));
      dynamic response = await request.send();
      if (response.statusCode == 200) {
        print('File uploaded successfully');
        print('url of uploaded file');
        // Handle success
      } else {
        print('Error during file upload: ${response.reasonPhrase}');
        // Handle error
      }
    } catch (e) {
      print('Error uploading file: $e');
      // Handle exception
    }
  }

  /// delete selected course
  void onDeleteCourse(String courseId) async {
    try {
      final ApiResponseModel response = await ApiService.delete(
        path: 'courses/delete-course/$courseId',
      );

      if (response.success) {
        showSnackbar(message: 'Course deleted successfully!', title: 'Success');
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
