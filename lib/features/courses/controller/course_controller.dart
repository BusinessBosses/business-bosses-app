import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/features/courses/models/course_model.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class CourseController extends GetxController {
  RxList<CourseModel> courses = RxList<CourseModel>(<CourseModel>[]);

  Future<void> createCourse(Map<String, dynamic> course) async {
    final ApiResponseModel response =
        await ApiService.get(path: 'courses/create-course');

    if (response.success) {
      Get.back();
      Get.snackbar('Success', 'Course created successfully');
    }
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
