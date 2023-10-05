// ignore_for_file: public_member_api_docs

import 'package:business_bosses_v2/common/models/user_model.dart';

class EventModel {
  final int? id;
  final String? roomId;
  final String? title;
  final DateTime startAt;
  final DateTime endAt;
  final String? startTime;
  final bool? status;
  final UserModel? user;
  EventModel({
    this.id,
    required this.roomId,
    this.title,
    required this.startAt,
    required this.endAt,
    required this.startTime,
    this.status,
    this.user,
  });

  EventModel copyWith({
    int? id,
    String? roomId,
    String? title,
    DateTime? startAt,
    DateTime? endAt,
    String? startTime,
    bool? status,
    UserModel? user,
  }) {
    return EventModel(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      title: title ?? this.title,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      startTime: startTime ?? this.startTime,
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'roomId': roomId,
      'title': title,
      'startAt': startAt,
      'endAt': endAt,
      'startTime': startTime,
      'status': status,
      'user': user,
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'] as int,
      title: map['title'] != null ? map['title'] as String : null,
      roomId: map['roomId'] as String,
      startAt: map['startAt'] as DateTime,
      endAt: map['endAT'] as DateTime,
      startTime: map['startTime'] as String,
      status: map['status'] as bool,
      user: map['user'] != null
          ? UserModel.fromMap(map['user'] as Map<String, dynamic>)
          : null,
    );
  }
}
