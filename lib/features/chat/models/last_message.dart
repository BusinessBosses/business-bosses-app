import 'package:business_bosses_v2/common/models/user_model.dart';

class LastMessage {
  String? text;
  String? uid;
  int? timestamp;
  List<String>? deletedBy = <String>[];
  bool? deleted;
  List<String>? deletedBySingles = <String>[];
  UserModel? user;
  bool? isRead;

  LastMessage({
    this.text,
    this.uid,
    this.timestamp,
    this.deleted,
    this.deletedBy,
    this.deletedBySingles,
    this.isRead,
    // this.name,
    // this.photoUrl,
    this.user,
  });

  bool hasCompleteDate() {
    if (timestamp == null) return false;
    if (text == null) return false;
    if (uid == null) return false;

    return true;
  }

  factory LastMessage.toObject(Map<dynamic, dynamic> map) {
    return LastMessage(
      text: map['text'] as String,
      deleted: map['deleted'] as bool,
      uid: map['uid'] as String,
      deletedBy:
          map['deletedBy'] == null ? <String>[] : List<String>.from(map['deletedBy']),
      deletedBySingles: map['deletedBySingles'] == null
          ? <String>[]
          : List<String>.from(map['deletedBySingles']),
      timestamp: map['timestamp'] as int,
      isRead: map['isRead'] as bool,
    );
  }

  // factory LastMessage.toObjectFormSnapshot(DataSnapshot snapshot) {
  //   Map<dynamic, dynamic> map = snapshot.value;
  //   return LastMessage(
  //     text: map['text'] as String,
  //     uid: map['uid'] as String,
  //     isRead: map['isRead'] as bool,
  //     deleted: map['deleted'] as bool,
  //     deletedBy:
  //         map['deletedBy'] == null ? [] : List<String>.from(map['deletedBy']),
  //     deletedBySingles: map['deletedBySingles'] == null
  //         ? []
  //         : List<String>.from(map['deletedBySingles']),
  //     timestamp: map['timestamp'] as int,
  //   );
}

// Map<dynamic, dynamic> toMap() {
//   // ignore: unnecessary_cast
//   return {
//     'text': text,
//     'uid': uid,
//     'isRead': isRead,
//     'timestamp': timestamp,
//     'deleted': deleted,
//     'deletedBy': deletedBy,
//     'deletedBySingles': deletedBySingles,
//   } as Map<dynamic, dynamic>;
// }

// Map<dynamic, dynamic> toSetAsSenderMap() {
//   // ignore: unnecessary_cast
//   return {
//     'text': text,
//     'uid': uid,
//     'isRead': false,
//     'deleted': deleted,
//     'timestamp': timestamp,
//   } as Map<dynamic, dynamic>;
// }

// Map<dynamic, dynamic> toSetAsReceiverMap() {
//   // ignore: unnecessary_cast
//   return {
//     'text': text,
//     'uid': uid,
//     'deleted': deleted,
//     'isRead': true,
//     'timestamp': timestamp,
//   } as Map<dynamic, dynamic>;
// }

Map<dynamic, dynamic> toReadMap() {
  // ignore: unnecessary_cast
  return <String, bool>{
    'isRead': true,
  } as Map<dynamic, dynamic>;
}
