import 'package:business_bosses_v2/bbpro/models/task_model.dart';
import 'package:flutter/material.dart';

import '../../utils/theme/theme.dart';

class TaskDisplayItem extends StatefulWidget {
  final Task task;
  final ValueChanged<bool?> onChanged;

  const TaskDisplayItem({Key? key, required this.task, required this.onChanged})
      : super(key: key);

  @override
  State<TaskDisplayItem> createState() => _TaskDisplayItemState();
}

class _TaskDisplayItemState extends State<TaskDisplayItem> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Checkbox(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          activeColor:
              proprimaryColor, // Sets the color of the checkbox when checked
          value: true,
          onChanged: (bool? value) {
            setState(() {
              widget.onChanged;
            });
          },
        ),
        const Text('task name'),
      ],
    );
  }
}
