import '../../../common/models/my_user.dart';

class MyNotification {
  String? notificationId;
  String? dataId;
  String? senderUid;
  String? message;
  String? postID;
  String? title;
  int? timestamp;

  List<String>? tokens;
  List<String>? receiverUid;
  List<String>? readBy;
  String? notificationType;
  String? extraId;

  // EXTRA
  // MyUser user;
  // String photoUrl;
  String? username;
  List<MyUser> users;

  MyNotification({
    this.notificationId,
    this.dataId,
    this.senderUid,
    this.message,
    this.title,
    this.timestamp,
    this.tokens,
    this.postID,
    this.receiverUid,
    this.readBy = const [],
    this.notificationType,
    this.extraId,

// EXTRA

    // this.user,
    // this.photoUrl,
    // this.username,
    this.users = const [],
  });

  factory MyNotification.toObject(Map<dynamic, dynamic> map) {
    return MyNotification(
      notificationId: map['notificationId'] as String,
      dataId: map['dataId'] as String,
      senderUid: map['senderUid'] as String,
      message: map['message'] as String,
      postID: map['postID'] as String,
      title: map['title'] as String,
      timestamp: map['timestamp'] as int,
      tokens: map['tokens'] == null ? [] : List.from(map['tokens']),
      receiverUid: map['receiverUid'] == null
          ? []
          : List<String>.from(map['receiverUid']),
      readBy: map['readBy'] == null ? [] : List<String>.from(map['readBy']),
      notificationType: map['notificationType'] as String,
      extraId: map['extraId'] as String,
    );
  }

  // factory MyNotification.toObjectFormSnapshot(DataSnapshot snapshot) {
  //   if (snapshot == null) return MyNotification();
  //   Map<dynamic, dynamic> map = snapshot?.value;
  //   return MyNotification(
  //     notificationId: map['notificationId'] as String,
  //     dataId: map['dataId'] as String,
  //     senderUid: map['senderUid'] as String,
  //     message: map['message'] as String,
  //     postID: map['postID'] as String,
  //     title: map['title'] as String,
  //     timestamp: map['timestamp'] as int,
  //     tokens: map['tokens'] == null ? [] : List.from(map['tokens']),
  //     receiverUid: map['receiverUid'] == null
  //         ? []
  //         : List<String>.from(map['receiverUid']),
  //     readBy: map['readBy'] == null ? [] : List<String>.from(map['readBy']),
  //     notificationType: map['notificationType'] as String,
  //     extraId: map['extraId'] as String,
  //   );
  // }

  factory MyNotification.toObjectOpenNotification(Map<dynamic, dynamic> map) {
    return MyNotification(
      notificationId: map['notificationId'] as String,
      dataId: map['dataId'] as String,
      senderUid: map['senderUid'] as String,
      message: map['message'] as String,
      title: map['title'] as String,
      postID: map['postID'] as String,
      timestamp: int.tryParse(map['timestamp'] ?? ''),
      tokens: (map['tokens'] ?? '').toString().split(','),
      receiverUid: (map['receiverUid']).toString().split(','),
      readBy: map['readBy'] == null ? [] : List<String>.from(map['readBy']),
      notificationType: map['notificationType'] as String,
      // photoUrl: map['photoUrl'] as String,
      // username: map['username'] as String,
    );
  }

  Map<dynamic, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'notificationId': notificationId,
      'dataId': dataId,
      'senderUid': senderUid,
      'message': message,
      'title': title,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'tokens': tokens,
      'receiverUid': receiverUid,
      'readBy': readBy,
      'postID': postID,
      'notificationType': notificationType,
      'extraId': extraId,
    } as Map<dynamic, dynamic>;
  }

  Map<dynamic, dynamic> toIdMap() {
    // ignore: unnecessary_cast
    return {
      notificationId: {
        'notificationId': notificationId,
        'dataId': dataId,
        'senderUid': senderUid,
        'message': message,
        'postID': postID,
        'title': title,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'tokens': tokens,
        'receiverUid': receiverUid,
        'readBy': readBy,
        'notificationType': notificationType,
        'extraId': extraId,
      }
    } as Map<dynamic, dynamic>;
  }

  Map<dynamic, dynamic> toReadMap() {
    // ignore: unnecessary_cast
    return {
      // 'notificationId': this.notificationId,
      // 'dataId': this.dataId,
      // 'senderUid': this.senderUid,
      // 'message': this.message,
      // 'title': this.title,
      // 'timestamp': DateTime.now().millisecondsSinceEpoch,
      // 'tokens': this.tokens,
      // 'receiverUid': this.receiverUid,
      'readBy': readBy,
      // 'notificationType': this.notificationType,
      // 'extraId': this.extraId,
    } as Map<dynamic, dynamic>;
  }

  Map<dynamic, dynamic> toCloudMap() {
    // ignore: unnecessary_cast
    return {
      'notificationId': notificationId,
      'dataId': dataId,
      'senderUid': senderUid,
      'message': message,
      'title': title,
      // 'tokens': this.tokens.join(','),
      // 'receiverUid': this.receiverUid.join(','),
      'notificationType': notificationType,
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      // 'extraId': this.extraId,
    } as Map<dynamic, dynamic>;
  }

  Map<dynamic, dynamic> toMessageCloudMap() {
    // ignore: unnecessary_cast
    return {
      'notificationId': notificationId,
      'dataId': dataId,
      'senderUid': senderUid,
      'message': message,
      'title': title,
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      'tokens': tokens!.join(','),
      'receiverUid': receiverUid!.join(','),
      // 'readBy': this.readBy,
      'notificationType': notificationType,
      // 'photoUrl': this.photoUrl ?? '',
      'username': username ?? '',
      // 'extraId': this.extraId,
    } as Map<dynamic, dynamic>;
  }

//
// factory MyNotification.toObject(Map<dynamic, dynamic> map) {
//   return new MyNotification(
//     notificationId: map['notificationId'] as String,
//     dataId: map['dataId'] as String,
//     senderUid: map['senderUid'] as String,
//     message: map['message'] as String,
//     title: map['title'] as String,
//     readBy: map['readBy'] as List<String>,
//     timestamp: map['timestamp'] as int,
//     tokens: map['tokens'] as List<String>,
//     receiverUid: map['receiverUid'] as List<String>,
//     // user: map['user'] as MyUser,
//   );
// }
//
// Map<dynamic, dynamic> toMapSetMap() {
//   MyFirebase firebase = MyFirebase();
//   // ignore: unnecessary_cast
//   return {
//     'notificationId': this.notificationId,
//     'dataId': this.dataId,
//     'message': this.message,
//     'title': this.title,
//     // 'subData': this.subData.toMap(),
//     // 'tokens': this.tokens,
//     // 'receiverUid': this.receiverUid,
//
//     'senderUid': /*this.senderUid*/ firebase.uid,
//     // 'readBy': /*this.readBy*/ this.readBy,
//     // 'timestamp': /*this.timestamp*/ DateTime.now().millisecondsSinceEpoch,
//
//     // 'user': this.user,
//   } as Map<dynamic, dynamic>;
// }
//
// HashMap<String, dynamic> toHashMap(){
//   MyFirebase firebase = MyFirebase();
//   // ignore: unnecessary_cast
//   return {
//     'notificationId': this.notificationId,
//     'dataId': this.dataId,
//     'message': this.message,
//     'title': this.title,
//     // 'subData': this.subData.toMap(),
//     'tokens': this.tokens,
//     'receiverUid': this.receiverUid,
//
//     'senderUid': /*this.senderUid*/ firebase.uid,
//     'readBy': /*this.readBy*/ [],
//     'timestamp': /*this.timestamp*/ DateTime.now().millisecondsSinceEpoch,
//
//     // 'user': this.user,
//   } as HashMap<String, dynamic>;
// }
}

// class SubData {
//   String dataId;
//   String notificationType;
//   String extraId;
//
//   SubData({
//      this.dataId,
//      this.notificationType,
//     this.extraId,
//   });
//
//   factory SubData.toObject(Map<dynamic, dynamic> map) {
//     return new SubData(
//       dataId: map['dataId'] as String,
//       notificationType: map['notificationType'] as String,
//       extraId: map['extraId'] as String,
//     );
//   }
//   Map<dynamic, dynamic> toMap() {
//     // ignore: unnecessary_cast
//     return {
//       'dataId': this.dataId,
//       'notificationType': this.notificationType,
//       'extraId': this.extraId,
//     } as Map<dynamic, dynamic>;
//   }
// }
