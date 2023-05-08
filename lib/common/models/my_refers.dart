import 'package:flutter/material.dart';

class MyRefers {
  String referredUserUid;
  String referBy;
  List<String> referTo;
  int timestamp;

  MyRefers({
    required this.referredUserUid,
    required this.referBy,
    required this.referTo,
    required this.timestamp,
  });

  Map<dynamic, dynamic> toMap() {
    return {
      'referredUserUid': referredUserUid,
      'referBy': referBy,
      'referTo': referTo,
      'timestamp': timestamp,
    };
  }

  factory MyRefers.fromMap(Map<dynamic, dynamic> map) {
    return MyRefers(
      referredUserUid: map['referredUserUid'] as String,
      referBy: map['referBy'] as String,
      referTo: List<String>.from(map['referTo']),
      timestamp: map['timestamp'] as int,
    );
  }

  static List<MyRefers> toListFormMap({
    required Map map,
  }) {
    if (map?.isEmpty ?? false) return [];
    List<MyRefers> myRefers = [];
    map?.forEach((key, data) {
      final MyRefers ref = MyRefers.fromMap(data);
      myRefers.add(ref);
    });
    return myRefers;
  }

  static List<String> uniqueUserUidList({
    required List<MyRefers> referralsList,
  }) {
    List<String> refsUids = [];
    for (MyRefers ref in referralsList) {
      debugPrint(
          'MyRefers.uniqueUserUidList: ${ref.referTo != null} || ${ref.referTo.length}');
      if (ref.referTo != null || ref.referTo.isNotEmpty) {
        for (var t in ref.referTo) {
          debugPrint('MyRefers.uniqueUserUidList: ${refsUids.contains(t)}');
          if (!refsUids.contains(t)) {
            refsUids.add(t);
          }
        }
      }
    }
    debugPrint('MyRefers.uniqueUserUidList ${refsUids.length}');
    return refsUids;
  }
}
