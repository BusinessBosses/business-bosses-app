import 'package:business_bosses_v2/bbpro/controllers/project_controller.dart';
import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/project_model.dart';
import 'package:business_bosses_v2/bbpro/widgets/taskwidget.dart';
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TodoTaskView extends StatefulWidget {
  const TodoTaskView({super.key});

  @override
  State<TodoTaskView> createState() => _TodoTaskViewState();
}

class _TodoTaskViewState extends State<TodoTaskView> {
  final ProjectController projectController = Get.put(ProjectController());
  final ShopController shopController = Get.put(ShopController());
  final ProfileController profileController = Get.find();
  bool loading = true;

  @override
  void initState() {
    projectController.initProjects(profileController.myProfile.uid).then((_) {
      setState(() {
        loading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('To-do Tasks'),
        ),
        body: loading
            ? const SafetyModel()
            : Obx(
                () => projectController.loading.value
                    ? const SafetyModel()
                    : projectController.projects
                            .where((Project project) =>
                                project.status == ProjectStatus.todo)
                            .isEmpty
                        ? const Center(
                            child: SafetyModel(
                              isLoading: false,
                              icon: Icon(Icons.warning),
                              title: 'No To-do Tasks Found!',
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                              itemCount: projectController.projects.length,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                if (projectController.projects[index].status ==
                                    ProjectStatus.todo) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: TaskWidget(
                                      project:
                                          projectController.projects[index],
                                      bgcolor: projectController.projects[index]
                                          .status.backgroundColor,
                                    ),
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              },
                            ),
                          ),
              ));
  }
}
