import 'package:business_bosses_v2/bbpro/common/widgets/statswidget.dart';
import 'package:business_bosses_v2/bbpro/common/widgets/taskdisplayitem.dart';
import 'package:business_bosses_v2/bbpro/common/widgets/taskwidget.dart';
import 'package:business_bosses_v2/bbpro/models/task_model.dart';
import 'package:flutter/material.dart';

class ProjectPopUp extends StatelessWidget {
  const ProjectPopUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                task: Task.fromMap(<String, dynamic>{'name': ''}),
                bgcolor: Colors.red),
            const SizedBox(
              height: 15,
            ),
            StatsWidget(
              completedTasks: 12,
              totalTasks: 15,
              completionRate: 35,
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
                      itemCount: 5,
                      itemBuilder: (BuildContext context, int index) {
                        return TaskDisplayItem(
                          task: Task.fromMap(<String, dynamic>{'name': ''}),
                          onChanged: (bool? value) {},
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
