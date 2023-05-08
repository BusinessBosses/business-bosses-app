// ignore_for_file: public_member_api_docs, always_specify_types, unnecessary_null_comparison

import 'package:flutter/material.dart';

/// REFERAL CLASS
class MyRefers {
  String referredUserUid;
  String referBy;
  List<String> referTo;
  int timestamp;

  /// REFERAL CLASSS
  MyRefers({
    required this.referredUserUid,
    required this.referBy,
    required this.referTo,
    required this.timestamp,
  });

  /// TO MAP
  Map<dynamic, dynamic> toMap() {
    return <String, dynamic>{
      'referredUserUid': referredUserUid,
      'referBy': referBy,
      'referTo': referTo,
      'timestamp': timestamp,
    };
  }

  /// FROM MAP
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
    if (map.isEmpty) return [];
    List<MyRefers> myRefers = [];
    map.forEach((dynamic key, dynamic data) {
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
        for (String t in ref.referTo) {
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
