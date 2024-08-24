import 'package:business_bosses_v2/bbpro/controllers/project_controller.dart';
import 'package:business_bosses_v2/bbpro/models/project_model.dart';
import 'package:business_bosses_v2/bbpro/models/task_model.dart';
import 'package:business_bosses_v2/bbpro/widgets/statswidget.dart';
import 'package:business_bosses_v2/bbpro/widgets/taskdisplayitem.dart';
import 'package:business_bosses_v2/bbpro/widgets/taskwidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProjectPopUp extends StatefulWidget {
  final Project project;
  const ProjectPopUp({
    Key? key,
    required this.project,
  }) : super(key: key);

  @override
  State<ProjectPopUp> createState() => _ProjectPopUpState();
}

class _ProjectPopUpState extends State<ProjectPopUp> {
  final ProjectController projectController = Get.find();
  @override
  Widget build(BuildContext context) {
    final int totalTasks = widget.project.tasks?.length ?? 0;
    final int completedTasks = widget.project.tasks
            ?.where((Task task) => task.status.toString() == 'completed')
            .length ??
        0;
    final double completionRate =
        (totalTasks > 0) ? (completedTasks / totalTasks) * 100 : 0;

    return Dialog(
      backgroundColor: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      insetPadding: const EdgeInsets.all(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              height: 15,
            ),
            TaskWidget(
                isExpanded: false,
                project: widget.project,
                bgcolor: Colors.red),
            const SizedBox(
              height: 15,
            ),
            StatsWidget(
              completedTasks: completedTasks,
              totalTasks: totalTasks,
              completionRate: completionRate,
            ),
            const SizedBox(
              height: 15,
            ),
            const Row(
              children: <Widget>[],
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                children: <Widget>[
                  const Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('Tasks'),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 300,
                    child: ListView.builder(
                      itemCount: widget.project.tasks?.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        return TaskDisplayItem(
                          task: widget.project.tasks![index],
                          onChanged: (bool? value) {
                            setState(() {
                              widget.project.tasks![index].status = value!
                                  ? TaskStatus.completed
                                  : TaskStatus.pending;

                              projectController.updateTask(
                                  widget.project.tasks![index].id,
                                  <String, dynamic>{
                                    'status': widget
                                        .project.tasks![index].status
                                        .toString()
                                  });
                              // The completion rate and task stats will automatically update
                            });
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
