import '../../common/models/my_user.dart';
import 'invite.dart';

class Referrals {
  String? code;
  String? uid;
  int? timestamp;
  List<Invite>? usedBy;
  MyUser? user;

  Referrals(
      {this.code, this.uid, this.timestamp, this.usedBy = const [], this.user});

  factory Referrals.toObject(Map<dynamic, dynamic> map) {
    return Referrals(
      code: map['code'] as String,
      uid: map['uid'] as String,
      timestamp: map['timestamp'] as int,
      usedBy:
          map['usedBy'] == null ? [] : Invite.toInviteList(data: map['usedBy']),
    );
  }

  // factory Referrals.toObjectFromDataSnapshot(DataSnapshot snapshot) {
  //   var map = snapshot.value;
  //   return Referrals(
  //     code: map['code'] as String,
  //     uid: map['uid'] as String,
  //     timestamp: map['timestamp'] as int,
  //     usedBy:
  //         map['usedBy'] == null ? [] : Invite.toInviteList(data: map['usedBy']),
  //   );
  // }

  Map<dynamic, dynamic> toSetFirstTimeMap() {
    // ignore: unnecessary_cast
    return {
      'code': code,
      'uid': uid,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      // 'usedBy': this.usedBy,
    } as Map<dynamic, dynamic>;
  }
}
