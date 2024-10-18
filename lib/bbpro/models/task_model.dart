import 'package:business_bosses_v2/bbpro/models/project_model.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class Task {
  final String id;
  final String? userId;
  final String? projectId;
  final String? name;
  final String? amount; // Changed from double? to String?
  final DateTime? startAt;
  final DateTime? endAt;
  TaskStatus status;
  final DateTime? createdAt;
  final String? clientId;
  final Project? project;

  Task({
    required this.id,
    this.userId,
    this.projectId,
    this.name,
    this.amount,
    this.startAt,
    this.endAt,
    required this.status,
    this.createdAt,
    this.clientId,
    this.project,
  });

  factory Task.fromJson(String str) => Task.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Task.fromMap(Map<String, dynamic> json) => Task(
        id: json['id'],
        userId: json['userId'],
        projectId: json['projectId'],
        name: json['name'],
        amount:
            json['amount']?.toString(), // Changed to handle amount as String
        startAt:
            json['startAt'] != null ? DateTime.parse(json['startAt']) : null,
        endAt: json['endAt'] != null ? DateTime.parse(json['endAt']) : null,
        status: TaskStatus.fromString(json['status']),
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : null,
        clientId: json['clientId'],
        project:
            json['project'] == null ? null : Project.fromMap(json['project']),
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'userId': userId,
        'projectId': projectId,
        'name': name,
        'amount': amount, // Changed to handle amount as String
        'startAt': startAt?.toIso8601String(),
        'endAt': endAt?.toIso8601String(),
        'status': status.toString(),
        'createdAt': createdAt?.toIso8601String(),
        'clientId': clientId,
        'project': project == null ? null : project!.toMap(),
      };
}

enum TaskStatus {
  allprojects,
  todo,
  pending,
  completed;

  static TaskStatus fromString(String status) {
    switch (status) {
      case 'all projects':
        return TaskStatus.allprojects;
      case 'to-do':
        return TaskStatus.todo;
      case 'pending':
        return TaskStatus.pending;
      case 'completed':
        return TaskStatus.completed;
      default:
        throw ArgumentError('Unknown status: $status');
    }
  }

  String get displayTitle {
    switch (this) {
      case TaskStatus.allprojects:
        return 'All Tasks';
      case TaskStatus.todo:
        return 'To Do';
      case TaskStatus.pending:
        return 'Pending';
      case TaskStatus.completed:
        return 'Completed';
    }
  }

  Color get backgroundColor {
    switch (this) {
      case TaskStatus.allprojects:
        return Colors.white;
      case TaskStatus.todo:
        return Colors.black12;
      case TaskStatus.pending:
        return Colors.yellow.withAlpha(100);
      case TaskStatus.completed:
        return Colors.green.withAlpha(100);
    }
  }

  @override
  String toString() {
    switch (this) {
      case TaskStatus.allprojects:
        return 'all projects';
      case TaskStatus.todo:
        return 'to-do';
      case TaskStatus.pending:
        return 'pending';
      case TaskStatus.completed:
        return 'completed';
    }
  }
}
