import 'dart:convert';
import 'package:flutter/material.dart';

// import 'task_model.dart'; // Make sure to import the Task model

class Project {
  final String id;
  final String userId;
  final String name;
  final String description;
  final String? amount; // Changed from double? to String?
  final String duration;
  final DateTime createdAt;
  final ProjectStatus status;
  final DateTime startAt;
  final DateTime endAt;

  Project({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    this.amount,
    required this.duration,
    required this.createdAt,
    required this.startAt,
    required this.endAt,
    this.status = ProjectStatus.todo,
  });

  factory Project.fromJson(String str) => Project.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Project.fromMap(Map<String, dynamic> json) => Project(
        id: json['id'],
        userId: json['userId'],
        status: ProjectStatus.fromString(json['status']),
        name: json['name'],
        description: json['description'],
        amount:
            json['amount']?.toString(), // Changed to handle amount as String
        duration: json['duration'],
        createdAt: DateTime.parse(json['createdAt']),
        startAt: DateTime.parse(json['createdAt']),
        endAt: DateTime.parse(json['createdAt']),
        // tasks: json['tasks'] == null
        //     ? null
        //     : List<Task>.from(
        //         json['tasks'].map((dynamic x) => Task.fromMap(x))),
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'userId': userId,
        'name': name,
        'description': description,
        'amount': amount, // Changed to handle amount as String
        'duration': duration,
        'createdAt': createdAt.toIso8601String(),
        'startAt': startAt.toIso8601String(),
        'endAt': endAt.toIso8601String(),
        // 'tasks': tasks == null
        //     ? null
        //     : List<dynamic>.from(tasks!.map((Task x) => x.toMap())),
      };
}

enum ProjectStatus {
  allprojects,
  todo,
  pending,
  completed;

  static ProjectStatus fromString(String status) {
    switch (status) {
      case 'all projects':
        return ProjectStatus.allprojects;
      case 'to-do':
        return ProjectStatus.todo;
      case 'pending':
        return ProjectStatus.pending;
      case 'completed':
        return ProjectStatus.completed;
      default:
        throw ArgumentError('Unknown status: $status');
    }
  }

  String get displayTitle {
    switch (this) {
      case ProjectStatus.allprojects:
        return 'All Projects';
      case ProjectStatus.todo:
        return 'To Do';
      case ProjectStatus.pending:
        return 'Pending';
      case ProjectStatus.completed:
        return 'Completed';
    }
  }

  Color get backgroundColor {
    switch (this) {
      case ProjectStatus.allprojects:
        return Colors.white;
      case ProjectStatus.todo:
        return Colors.black12;
      case ProjectStatus.pending:
        return Colors.yellow.withAlpha(100);
      case ProjectStatus.completed:
        return Colors.green.withAlpha(100);
    }
  }

  @override
  String toString() {
    switch (this) {
      case ProjectStatus.allprojects:
        return 'all projects';
      case ProjectStatus.todo:
        return 'to-do';
      case ProjectStatus.pending:
        return 'pending';
      case ProjectStatus.completed:
        return 'completed';
    }
  }
}
