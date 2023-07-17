// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:business_bosses_v2/common/models/user_model.dart';

class MessageModel {
  final String messageId;
  final String? messageText;
  final int timestamp;
  final String? image;
  final bool? isRawImage;
  final List<String>? deleted;
  final String senderUid;
  final String receiverUid;
  final bool seen;
  final String? marketId;
  final UserModel? user;
  MessageModel({
    required this.messageId,
    this.messageText,
    required this.timestamp,
    this.image,
    this.marketId,
    this.isRawImage,
    this.deleted,
    required this.senderUid,
    required this.receiverUid,
    required this.seen,
    this.user,
  });

  MessageModel copyWith({
    String? messageId,
    String? messageText,
    String? marketId,
    int? timestamp,
    String? image,
    bool? isRawImage,
    List<String>? deleted,
    String? senderUid,
    String? receiverUid,
    bool? seen,
    UserModel? user,
  }) {
    return MessageModel(
      messageId: messageId ?? this.messageId,
      messageText: messageText ?? this.messageText,
      marketId: marketId ?? this.marketId,
      timestamp: timestamp ?? this.timestamp,
      image: image ?? this.image,
      isRawImage: isRawImage ?? this.isRawImage,
      deleted: deleted ?? this.deleted,
      senderUid: senderUid ?? this.senderUid,
      receiverUid: receiverUid ?? this.receiverUid,
      seen: seen ?? this.seen,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'messageId': messageId,
      'messageText': messageText,
      'marketId': marketId,
      'timestamp': timestamp,
      'image': image,
      'isRawImage': isRawImage,
      'deleted': deleted,
      'senderUid': senderUid,
      'receiverUid': receiverUid,
      'seen': seen,
      'user': user?.toMap(),
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      messageId: map['messageId'] as String,
      messageText:
          map['messageText'] != null ? map['messageText'] as String : null,
      marketId: map['marketId'] != null ? map['marketId'] as String : null,
      timestamp: map['timestamp'] as int,
      image: map['image'] != null ? map['image'] as String : null,
      isRawImage: map['isRawImage'] != null ? map['isRawImage'] as bool : null,
      deleted: map['deleted'] != null
          ? List<String>.from((map['deleted'] as List<String>))
          : [],
      senderUid: map['senderUid'] as String,
      receiverUid: map['receiverUid'] as String,
      seen: map['seen'] as bool,
      user: map['user'] != null
          ? UserModel.fromMap(map['user'] as Map<String, dynamic>)
          : null,
    );
  }
}
