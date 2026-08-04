// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ReferralsModel {
  final String referredUserUid;
  final String referBy;
  final List<String> referTo;
  // final int timestamp;
  ReferralsModel({
    required this.referredUserUid,
    required this.referBy,
    required this.referTo,
    // required this.timestamp,
  });

  ReferralsModel copyWith({
    String? referredUserUid,
    String? referBy,
    List<String>? referTo,
    // int? timestamp,
  }) {
    return ReferralsModel(
      referredUserUid: referredUserUid ?? this.referredUserUid,
      referBy: referBy ?? this.referBy,
      referTo: referTo ?? this.referTo,
      // timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'referredUserUid': referredUserUid,
      'referBy': referBy,
      'referTo': referTo,
      // 'timestamp': timestamp,
    };
  }

  factory ReferralsModel.fromMap(Map<String, dynamic> map) {
    return ReferralsModel(
      referredUserUid: map['referredUserUid']?.toString() ?? '',
      referBy: map['referBy']?.toString() ?? '',
      referTo: map['referTo'] != null
          ? List<String>.from(map['referTo'] as List<dynamic>)
          : <String>[],
      // timestamp: map['timestamp'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReferralsModel.fromJson(String source) =>
      ReferralsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ReferralsModel(referredUserUid: $referredUserUid, referBy: $referBy, referTo: $referTo, )';
  }
}
