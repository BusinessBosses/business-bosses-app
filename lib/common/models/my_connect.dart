import 'package:flutter/foundation.dart';

class MyConnect {
  String? id;
  // String? connectedBy;
  String? connectedTo;
  num? timestamp;
  // String? status;

  MyConnect({
    this.id,
    // this.connectedBy,
    this.connectedTo,
    this.timestamp,
    // this.status,
  });

  Map<dynamic, dynamic> toMap() {
    return <dynamic, dynamic>{
      'id': id,
      // 'connectedBy': connectedBy,
      'connect': connectedTo,
      'timestamp': timestamp,
      // 'status': this.status,
    };
  }

  factory MyConnect.fromMap(Map<dynamic, dynamic> map) {
    return MyConnect(
      id: map['id'].toString(),
      // connectedBy: map['connectedBy'] as String,
      connectedTo: map['connect'] as String,
      timestamp: map['timestamp'] as int,
      // status: map['status'] as String,
    );
  }

  // MyConnect({
  //   this.connectedBy,
  //   this.timestamp,
  //   this.status,
  // });
  //
  // factory MyConnect.toObject(Map<dynamic, dynamic> map) {
  //   return new MyConnect(
  //     connectedBy: map['uid'] as String,
  //     status: map['status'] as String,
  //     timestamp: map['timestamp'] as int,
  //   );
  // }
  //
  // toMap() {
  //   // ignore: unnecessary_cast
  //   return {
  //     'uid': this.connectedBy,
  //     'status': this.status,
  //     'timestamp': this.timestamp,
  //   } as Map<dynamic, dynamic>;
  // }
  //
  // toUpdateMap() {
  //   // ignore: unnecessary_cast
  //   return {
  //     // 'uid': this.uid,
  //     'status': this.status,
  //     // 'timestamp': this.timestamp,
  //   } as Map<dynamic, dynamic>;
  // }

  static List<MyConnect> toListFormMap({
    @required Map<dynamic, dynamic>? map,
  }) {
    if (map?.isEmpty ?? false) return <MyConnect>[];
    List<MyConnect> items = <MyConnect>[];
    map?.forEach((dynamic key, dynamic data) {
      final MyConnect item = MyConnect.fromMap(data);
      items.add(item);
    });
    return items;
  }

  // bool get isEmpty {
  //   if ((connectedBy?.isEmpty ?? true) &&
  //           (connectedTo?.isEmpty ?? true) &&
  //           timestamp == null /*&&
  //       (status?.isEmpty ?? true)*/
  //       ) return true;
  //   return false;
  // }

  // bool get isNotEmpty {
  //   if ((connectedBy?.isNotEmpty ?? false) &&
  //           (connectedTo?.isNotEmpty ?? false) &&
  //           timestamp != null /*&&
  //       (status?.isNotEmpty ?? false)*/
  //       ) return true;
  //   return false;
  // }

  static String connectId(String myUser, String publicUserUid) {
    return myUser.substring(0, 12) + publicUserUid.substring(0, 12);
  }
}
