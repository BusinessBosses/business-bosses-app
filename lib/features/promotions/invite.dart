import 'package:flutter/foundation.dart';

import '../../common/models/my_user.dart';

class Invite {
  String? uid;
  int? timestamp;
  MyUser? user;

  Invite({this.uid, this.timestamp, this.user});

  factory Invite.toObject(Map<dynamic, dynamic> map) {
    return Invite(
      uid: map['uid'] as String,
      timestamp: map['timestamp'] as int,
    );
  }

  // factory Invite.toObjectFromDataSnapshot(DataSnapshot snapshot) {
  //   var map = snapshot.value;
  //   return Invite(
  //     uid: map['uid'] as String,
  //     timestamp: map['timestamp'] as int,
  //   );
  //}

  Map<dynamic, dynamic> toSetMap() {
    // ignore: unnecessary_cast
    return <String, Object?>{
      'uid': uid,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    } as Map<dynamic, dynamic>;
  }

  static List<Invite> toInviteList({
    @required dynamic data,
  }) {
    Map<dynamic, dynamic> values = data as Map<dynamic, dynamic>;
    List<Invite> invites = <Invite>[];
    values.forEach((dynamic key, dynamic data) {
      final Invite invite = Invite.toObject(data);
      invites.add(invite);
    });
    return invites;
  }
}
