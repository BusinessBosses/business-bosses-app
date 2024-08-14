import 'package:flutter/material.dart';
import 'dart:convert';

class Task {
  final String id;
  final String? userId;
  final String? projectId;
  final String? name;
  final String? amount;
  final DateTime? startAt;
  final DateTime? endAt;
  final TaskStatus status;
  final DateTime? createdAt;
  final String? clientId;

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
  });

  factory Task.fromJson(String str) => Task.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Task.fromMap(Map<String, dynamic> json) => Task(
        id: json['id'],
        userId: json['userId'],
        projectId: json['projectId'],
        name: json['name'],
        amount: json['amount'],
        startAt:
            json['startAt'] != null ? DateTime.parse(json['startAt']) : null,
        endAt: json['endAt'] != null ? DateTime.parse(json['endAt']) : null,
        status: TaskStatus.fromString(json['status']),
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : null,
        clientId: json['clientId'],
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'userId': userId,
        'projectId': projectId,
        'name': name,
        'amount': amount,
        'startAt': startAt?.toIso8601String(),
        'endAt': endAt?.toIso8601String(),
        'status': status.toString(),
        'createdAt': createdAt?.toIso8601String(),
        'clientId': clientId,
      };
}

enum TaskStatus {
  todo,
  pending,
  completed;

  static TaskStatus fromString(String status) {
    switch (status) {
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
      case TaskStatus.todo:
        return 'to-do';
      case TaskStatus.pending:
        return 'pending';
      case TaskStatus.completed:
        return 'completed';
    }
  }
}
