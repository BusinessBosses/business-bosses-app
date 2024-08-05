import 'package:flutter/material.dart';

class Task {
  final String title;
  final TaskStatus status;
  final String? description;

  Task({
    this.description,
    required this.title,
    required this.status,
  });
}

enum TaskStatus {
  todo("To Do", Colors.black),
  inprogress("In Progress", Colors.blue),
  inreview("In Review", Colors.orange),
  done("Done", Colors.green);

  const TaskStatus(
    this.displayTitle,
    this.backgroundColor,
  );

  final String displayTitle;
  final Color backgroundColor;
}
