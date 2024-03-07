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
    final ApiResponseModel response =
        await ApiService.post(path: 'courses/create-course', body: course);

    if (response.success) {
      Get.back();
      Get.snackbar('Success', 'Course created successfully');
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
}
