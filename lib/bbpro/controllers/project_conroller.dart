import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:get/get.dart';

class ProjectController extends GetxController {
  Future<bool> initProjects() async {
    ApiResponseModel response = await ApiService.get(path: 'shops');
    if (response.success) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> addProject(Map<String, dynamic> data) async {
    ApiResponseModel response =
        await ApiService.post(path: 'projects', body: data);
    if (response.success) {
      return true;
    } else {
      return false;
    }
  }
}
