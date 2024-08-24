import 'package:business_bosses_v2/bbpro/models/project_model.dart';
import 'package:business_bosses_v2/bbpro/models/task_model.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:get/get.dart';

class ProjectController extends GetxController {
  final ProfileController profileController = Get.find();
  RxList<Task> tasks = RxList<Task>(<Task>[]);
  RxList<Project> projects = RxList<Project>(<Project>[]);

  Future<void> initProjects(String userId) async {
    projects.clear();
    ApiResponseModel response = await ApiService.get(path: 'projects/all');
    if (response.success) {
      for (int i = 0; i < response.data['rows'].length; i++) {
        projects.add(Project.fromMap(response.data['rows'][i]));
      }
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

  Future<void> updateTask(String taskId, Map<String, dynamic> data) async {
    try {
      // Call your API to update the task's status in the backend
      await ApiService.put(path: 'tasks/$taskId', body: data);
      // You can also handle local state or cache updates if necessary
    } catch (e) {
      // Handle any errors that occur during the update
    }
    update();
  }

  Future<void> updateProject(
      String projectId, Map<String, dynamic> data) async {
    try {
      // Call your API to update the task's status in the backend
      await ApiService.put(path: 'projects/$projectId', body: data);
      // You can also handle local state or cache updates if necessary
    } catch (e) {
      // Handle any errors that occur during the update
    }
    update();
  }

  @override
  void onInit() {
    initProjects(profileController.myProfile.uid);
    super.onInit();
  }
}
