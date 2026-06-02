// ignore_for_file: always_specify_types

import 'dart:convert';

import '../../../services/api_service.dart';
import '../../../common/models/api_response_model.dart';

/// INDUSTRY MODEL
class Industry {
  String? industryId;
  String? industry;
  String? photo;
  String? description;
  int? timestamp;
  bool? active;
  String? categoryId;
  List<String>? joinedUsers;
  String? criteria;
  String? award;
  String? createTitle;
  String? createInfo;
  String? createDescription;
  DateTime? startAt; // Updated to DateTime
  DateTime? endedAt; // Updated to DateTime
  int? joinedUsersCount;

  /// INDUSTRY MODEL
  Industry({
    this.industryId,
    this.industry,
    this.photo,
    this.description,
    this.timestamp,
    this.active,
    this.categoryId,
    this.joinedUsers,
    this.award,
    this.criteria,
    this.createTitle,
    this.createInfo,
    this.createDescription,
    this.startAt,
    this.endedAt,
    this.joinedUsersCount,
  });

  factory Industry.toObject(Map<dynamic, dynamic> map) {
    return Industry(
      industryId: map['industryId']?.toString() ?? '',
      industry: map['industry']?.toString() ?? '',
      photo: map['photo']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      active: map['active'] == true,
      timestamp: map['timestamp'] != null
          ? int.tryParse(map['timestamp'].toString()) ?? 0
          : 0,
      categoryId: map['categoryId']?.toString() ?? '',
      joinedUsers: map['joinedUsers'] == null
          ? <String>[]
          : List<String>.from(map['joinedUsers']),
      criteria: map['criteria']?.toString(),
      award: map['award']?.toString(),
      createTitle: map['createTitle']?.toString(),
      createInfo: map['createInfo']?.toString(),
      createDescription: map['createDescription']?.toString(),
      startAt: map['startAt'] == null
          ? null
          : DateTime.tryParse(map['startAt'].toString()),
      endedAt: map['endedAt'] == null
          ? null
          : DateTime.tryParse(map['endedAt'].toString()),
      joinedUsersCount: map['joinedUsersCount'] is int
          ? map['joinedUsersCount'] as int
          : int.tryParse(map['joinedUsersCount']?.toString() ?? '0') ?? 0,
    );
  }

  factory Industry.fromMap(Map<String, dynamic> map) {
    return Industry(
      industryId: map['industryId']?.toString(),
      industry: map['industry']?.toString(),
      photo: map['photo']?.toString(),
      description: map['description']?.toString(),
      timestamp: map['timestamp'] != null
          ? int.tryParse(map['timestamp'].toString())
          : null,
      active: map['active'] == true,
      categoryId: map['categoryId']?.toString(),
      joinedUsers: map['joinedUsers'] != null
          ? (map['joinedUsers'] as List).map((dynamic e) => e?.toString() ?? '').toList()
          : <String>[],
      criteria: map['criteria']?.toString(),
      award: map['award']?.toString(),
      createTitle: map['createTitle']?.toString(),
      createInfo: map['createInfo']?.toString(),
      createDescription: map['createDescription']?.toString(),
      startAt: map['startAt'] != null
          ? DateTime.tryParse(map['startAt'].toString())
          : null,
      endedAt: map['endedAt'] != null
          ? DateTime.tryParse(map['endedAt'].toString())
          : null,
      joinedUsersCount: map['joinedUsersCount'] != null
          ? int.tryParse(map['joinedUsersCount'].toString()) ?? 0
          : 0,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'industryId': industryId,
      'industry': industry,
      'photo': photo,
      'description': description,
      'timestamp': timestamp,
      'active': active,
      'categoryId': categoryId,
      'joinedUsers': joinedUsers,
      'criteria': criteria,
      'award': award,
      'createTitle': createTitle,
      'createInfo': createInfo,
      'createDescription': createDescription,
      'startAt': startAt?.toIso8601String(),
      'endedAt': endedAt?.toIso8601String(),
      'joinedUsersCount': joinedUsersCount,
    };
  }

  static List<Industry> toIndustries({
    required List snapshot,
  }) {
    List<Industry> industries = <Industry>[];
    for (int i = 0; i < snapshot.length; i++) {
      final Industry industry = Industry.toObject(snapshot[i]);
      industries.add(industry);
    }
    // snapshot.forEach((key, data) {
    //   final Industry industry = Industry.toObject(data);
    //   if (industry.active ?? true) industries.add(industry);
    // });
    return industries;
  }

  static List<Industry> toJustSortIndustryList(List<dynamic> responseData) {
    // ignore: unnecessary_null_comparison
    if (responseData == null) return <Industry>[];
    List<Industry> items = <Industry>[];
    for (final postJson in responseData) {
      Industry pt = Industry.toObject(postJson);
      items.add(pt);
    }
    items.sort(
        (Industry a, Industry b) => b.timestamp!.compareTo(a.timestamp as num));
    return items;
  }

  Future<List<Industry>> fetchIndustry() async {
    final ApiResponseModel response =
        await ApiService.get(path: Uri.parse('industry/user-count').toString());

    if (response.success == true) {
      final List<dynamic> responseData = jsonDecode(response.data.rows);
      final List<Industry> industries =
          Industry.toJustSortIndustryList(responseData);

      return industries;
    } else {
      throw Exception('Failed to fetch industries');
    }
  }
}
