// ignore_for_file: public_member_api_docs

import 'package:business_bosses_v2/common/models/user_model.dart';

class EventModel {
  final int? id;
  final String? roomId;
  final String? title;
  final DateTime? startAt;
  final DateTime? endAt;
  final String? startTime;
  final bool? status;
  final UserModel? user;
  final String? image;
  int? totalAttendees;
  EventModel({
    this.id,
    required this.roomId,
    this.title,
    required this.startAt,
    required this.endAt,
    required this.startTime,
    this.status,
    this.user,
    this.image,
    this.totalAttendees = 0,
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
    String? image,
    int? totalAttendees,
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
      image: image ?? this.image,
      totalAttendees: totalAttendees ?? this.totalAttendees,
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
      'image': image,
      'totalAttendees': totalAttendees,
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'] as int,
      title: map['title'] != null ? map['title'] as String : null,
      roomId: map['roomId'] as String,
      startAt: map['startAt'] != null
          ? DateTime.parse(map['startAt'] as String)
          : null,
      endAt:
          map['endAt'] != null ? DateTime.parse(map['endAt'] as String) : null,
      startTime: map['startTime'] as String,
      status: map['status'] != null ? map['status'] as bool : null,
      user: map['user'] != null
          ? UserModel.fromMap(map['user'] as Map<String, dynamic>)
          : null,
      image: map['image'] != null ? map['image'] as String : null,
      totalAttendees:
          map['totalAttendees'] != null ? map['totalAttendees'] as int : null,
    );
  }

  void setAttendCount(int newViews) {
    totalAttendees = newViews;
  }
}
