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
    return {
      'uid': uid,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    } as Map<dynamic, dynamic>;
  }

  static List<Invite> toInviteList({
    @required var data,
  }) {
    Map values = data as Map;
    List<Invite> invites = [];
    values.forEach((key, data) {
      final Invite invite = Invite.toObject(data);
      invites.add(invite);
    });
    return invites;
  }
}
