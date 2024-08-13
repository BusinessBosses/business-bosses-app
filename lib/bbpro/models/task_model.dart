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
    required this.userId,
    required this.projectId,
    required this.name,
    this.amount,
    required this.startAt,
    required this.endAt,
    required this.status,
    required this.createdAt,
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
        startAt: DateTime.parse(json['startAt']),
        endAt: DateTime.parse(json['endAt']),
        status: json['status'],
        createdAt: DateTime.parse(json['createdAt']),
        clientId: json['clientId'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'userId': userId,
        'projectId': projectId,
        'name': name,
        'amount': amount,
        'startAt': startAt?.toIso8601String(),
        'endAt': endAt?.toIso8601String(),
        'status': status,
        'createdAt': createdAt?.toIso8601String(),
        'clientId': clientId,
      };
}

enum TaskStatus {
  todo('To Do', Colors.black),
  inprogress('In Progress', Colors.blue),
  inreview('In Review', Colors.orange),
  done('Done', Colors.green);

  const TaskStatus(
    this.displayTitle,
    this.backgroundColor,
  );

  final String displayTitle;
  final Color backgroundColor;
}
