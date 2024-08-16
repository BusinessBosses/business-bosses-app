import 'package:business_bosses_v2/bbpro/models/task_model.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:get/get.dart';

class ProjectController extends GetxController {
  final ProfileController profileController = Get.find();
  RxList<Task> tasks = RxList<Task>(<Task>[]);

  Future<bool> initProjects() async {
    ApiResponseModel response = await ApiService.get(path: 'shops');
    if (response.success) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> initTasks(String userId) async {
    tasks.clear();
    ApiResponseModel response = await ApiService.get(path: 'tasks/all');
    if (response.success) {
      for (int i = 0; i < response.data['rows'].length; i++) {
        tasks.add(Task.fromMap(response.data['rows'][i]));
      }
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

  @override
  void onInit() {
    initTasks(profileController.myProfile.uid);
    super.onInit();
  }
}
