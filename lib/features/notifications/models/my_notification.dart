// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:business_bosses_v2/common/models/user_model.dart';

class MyNotification {
  String notificationId;
  String? dataId;
  String senderUid;
  String message;
  String title;
  int timestamp;
  String receiverUid;
  bool isRead;
  String? notificationType;
  String? username;
  UserModel? user;
  String? image;
  MyNotification({
    required this.notificationId,
    this.dataId,
    required this.senderUid,
    required this.message,
    required this.title,
    required this.timestamp,
    required this.receiverUid,
    required this.isRead,
    this.notificationType,
    this.username,
    this.user,
    this.image,
  });

  MyNotification copyWith({
    String? notificationId,
    String? dataId,
    String? senderUid,
    String? message,
    String? title,
    int? timestamp,
    String? receiverUid,
    bool? isRead,
    String? notificationType,
    String? username,
    UserModel? user,
    String? image,
  }) {
    return MyNotification(
      notificationId: notificationId ?? this.notificationId,
      dataId: dataId ?? this.dataId,
      senderUid: senderUid ?? this.senderUid,
      message: message ?? this.message,
      title: title ?? this.title,
      image: image ?? this.image,
      timestamp: timestamp ?? this.timestamp,
      receiverUid: receiverUid ?? this.receiverUid,
      isRead: isRead ?? this.isRead,
      notificationType: notificationType ?? this.notificationType,
      username: username ?? this.username,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'notificationId': notificationId,
      'dataId': dataId,
      'senderUid': senderUid,
      'message': message,
      'title': title,
      'timestamp': timestamp,
      'receiverUid': receiverUid,
      'isRead': isRead,
      'notificationType': notificationType,
      'username': username,
      'image': image,
      'user': user?.toMap(),
    };
  }

  factory MyNotification.fromMap(Map<String, dynamic> map) {
    return MyNotification(
      notificationId: map['notificationId'] as String,
      dataId: map['dataId'] != null ? map['dataId'] as String : null,
      senderUid: map['senderUid'] as String,
      message: map['message'] as String,
      title: map['title'] as String,
      timestamp: map['timestamp'] as int,
      receiverUid: map['receiverUid'] as String,
      isRead: map['isRead'] as bool,
      notificationType: map['notificationType'] != null
          ? map['notificationType'] as String
          : null,
      username: map['username'] != null ? map['username'] as String : null,
      image: map['image'] != null ? map['image'] as String : null,
      user: map['user'] != null
          ? UserModel.fromMap(map['user'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MyNotification.fromJson(String source) =>
      MyNotification.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MyNotification(notificationId: $notificationId, dataId: $dataId, senderUid: $senderUid, message: $message, title: $title, timestamp: $timestamp, receiverUid: $receiverUid, isRead: $isRead, notificationType: $notificationType, username: $username, image: $image, user: $user)';
  }

  @override
  bool operator ==(covariant MyNotification other) {
    if (identical(this, other)) return true;

    return other.notificationId == notificationId &&
        other.dataId == dataId &&
        other.senderUid == senderUid &&
        other.message == message &&
        other.title == title &&
        other.timestamp == timestamp &&
        other.receiverUid == receiverUid &&
        other.isRead == isRead &&
        other.notificationType == notificationType &&
        other.username == username &&
        other.image == image &&
        other.user == user;
  }

  @override
  int get hashCode {
    return notificationId.hashCode ^
        dataId.hashCode ^
        senderUid.hashCode ^
        message.hashCode ^
        title.hashCode ^
        timestamp.hashCode ^
        receiverUid.hashCode ^
        isRead.hashCode ^
        notificationType.hashCode ^
        username.hashCode ^
        image.hashCode ^
        user.hashCode;
  }
}
