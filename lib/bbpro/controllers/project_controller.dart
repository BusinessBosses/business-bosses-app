import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/project_model.dart';
import 'package:business_bosses_v2/bbpro/models/task_model.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:get/get.dart';

class ProjectController extends GetxController {
  final ProfileController profileController = Get.find();
  final ShopController shopController = Get.find();
  RxList<Task> tasks = RxList<Task>(<Task>[]);
  RxList<Project> projects = RxList<Project>(<Project>[]);
  RxBool loading = RxBool(true);
  final Map<ProjectStatus, List<Project>> statusProjects =
      <ProjectStatus, List<Project>>{};
  final List<Project> allProjects = <Project>[];

  Future<void> initProjects(String userId) async {
    loading(true);
    update();
    projects.clear();
    allProjects.clear();
    ApiResponseModel response =
        await ApiService.get(path: 'projects/user-projects/$userId');
    if (response.success) {
      for (int i = 0; i < response.data['rows'].length; i++) {
        projects.add(Project.fromMap(response.data['rows'][i]));
      }
      // Initialize empty lists for each status
      for (ProjectStatus status in ProjectStatus.values) {
        statusProjects[status] = <Project>[];
      }
      for (ProjectStatus status in ProjectStatus.values) {
        List<Project> statusTasks = projects
            .where((Project project) => project.status == status)
            .toList();
        statusProjects[status] = statusTasks;
        allProjects.addAll(statusTasks);
      }
    }
    loading(false);
    update();
  }

  Future<void> initTasks(String userId) async {
    tasks.clear();
    ApiResponseModel response =
        await ApiService.get(path: 'tasks/user-tasks/$userId');
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
      shopController.loadShopData();
      return true;
    } else {
      return false;
    }
  }

  Future<void> updateTask(String taskId, Map<String, dynamic> data) async {
    try {
      // Call your API to update the task's status in the backend
      await ApiService.put(path: 'tasks/$taskId', body: data);
      shopController.loadShopData();
      // You can also handle local state or cache updates if necessary
    } catch (e) {
      // Handle any errors that occur during the update
    }
    update();
  }

  Future<bool> updateProject(
      String projectId, Map<String, dynamic> data) async {
    try {
      // Call your API to update the task's status in the backend
      final ApiResponseModel response =
          await ApiService.put(path: 'projects/$projectId', body: data);
      if (response.success) {
        shopController.loadShopData();
        return true;
      }
      return false;
      // You can also handle local state or cache updates if necessary
    } catch (e) {
      // Handle any errors that occur during the update
      return false;
    }
  }

  Future<bool> deleteProject(String projectId) async {
    try {
      // Call your API to update the task's status in the backend
      final ApiResponseModel response =
          await ApiService.delete(path: 'projects/$projectId');

      if (response.success) {
        initProjects(profileController.myProfile.uid);
        shopController.loadShopData();
        return true;
      } else {
        showSnackbar(message: 'Error deleting project');
        return false;
      }

      // You can also handle local state or cache updates if necessary
    } catch (e) {
      showSnackbar(message: 'Error deleting project');
      return false;
      // Handle any errors that occur during the update
    }
  }
}
