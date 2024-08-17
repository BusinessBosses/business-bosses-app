import 'dart:convert';
import 'task_model.dart'; // Make sure to import the Task model

class Project {
  final String id;
  final String userId;
  final String name;
  final String description;
  final int? amount;
  final String duration;
  final bool isDeleted;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Task>? tasks;

  Project({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    this.amount,
    required this.duration,
    required this.isDeleted,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.tasks,
  });

  factory Project.fromJson(String str) => Project.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Project.fromMap(Map<String, dynamic> json) => Project(
        id: json['id'],
        userId: json['userId'],
        name: json['name'],
        description: json['description'],
        amount: (json['amount']),
        duration: json['duration'],
        isDeleted: json['isDeleted'],
        deletedAt: json['deletedAt'] != null
            ? DateTime.parse(json['deletedAt'])
            : null,
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        tasks: json['tasks'] == null
            ? null
            : List<Task>.from(
                json['tasks'].map((dynamic x) => Task.fromMap(x))),
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'userId': userId,
        'name': name,
        'description': description,
        'amount': amount,
        'duration': duration,
        'isDeleted': isDeleted,
        'deletedAt': deletedAt?.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'tasks': tasks == null
            ? null
            : List<dynamic>.from(tasks!.map((Task x) => x.toMap())),
      };
}
